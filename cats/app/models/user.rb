class User < ApplicationRecord

    validates :user_name, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)

        if user && user.is_password?(password)
            user
        else 
            nil
        end
    end

    def self.generate_session_token
        SecureRandom.urlsafe_base64
    end

    def reset_session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        password_obj = BCrypt::Password.new(self.password_digest)
        password_obj.is_password?(password)
    end

    
end