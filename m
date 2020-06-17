Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1A01FD5A1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 21:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgFQT6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 15:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgFQT6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 15:58:03 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4523BC06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 12:58:03 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y18so1433485plr.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 12:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mtm26zMhVvziSNAo5SmfL3grFhcLxm63K6Ll3k7pVLA=;
        b=OGVeyzLchDvvpgrQEJsCwDmB0g5mSK2iyCbWztP7Kq7e12lAsbrbJJ/O765BM1d9FQ
         vMMvIE3saYLDImlEZ8eBNU3vlyvAG5MdNrvhwK/eP1+c7i+djFuR5nroesN2ZDFLFVQh
         AMcDeULYTTf+crJp+k+EIY9BLyYqFncTk8mtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mtm26zMhVvziSNAo5SmfL3grFhcLxm63K6Ll3k7pVLA=;
        b=tzYE5tq5UCBbZxoBkt8L37Q016ndLEY6E7PPTZ0qEauRQxxXFWfiml8VdGtwdvJpVM
         YUEBJvN7ZUaFRYqlmoKLtJQEHo4weyY+J7qMK5kK79K+16yLMxPBxqVivcuNeikpSmd0
         FV0hPZs70s4B+Dav9ejgCi1CSeuBTGjLGSRI2aBHoiR9pMDAJ6qCr4fjg7oXLgEwNiMU
         5NebCrUQNhpGycFd+XsNb2mvBV7vBxLEFLbGDuBx/M1LwihZzw6Bmn29FyncbiBq0O8c
         J+2m6G5tSZZXnqYqd9raAZA4ZScvUsjHIg4gjR8q4awvq4Mh3aStJHKSFPtEPUPi2fM+
         NVHw==
X-Gm-Message-State: AOAM5302m4hYLE7TXT/Tm89ijVnv8/iBJ0dETJvaOk4bwdIlVBlnrv9U
        47l57v18H/xgXJbKzIllaxW5eQ==
X-Google-Smtp-Source: ABdhPJx1Vhks5l1dJnwJicud25Ov+I84VyGCU0nF8o3XyWLhCCiEEzvHbnFtOemqhaMfq16ly8QKug==
X-Received: by 2002:a17:90a:7a8f:: with SMTP id q15mr598912pjf.116.1592423882783;
        Wed, 17 Jun 2020 12:58:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w22sm628496pfq.193.2020.06.17.12.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 12:58:01 -0700 (PDT)
Date:   Wed, 17 Jun 2020 12:58:00 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v4 03/11] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Message-ID: <202006171141.4DA1174979@keescook>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-4-keescook@chromium.org>
 <6de12195ec3244b99e6026b4b46e5be2@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6de12195ec3244b99e6026b4b46e5be2@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 03:35:20PM +0000, David Laight wrote:
> From: Kees Cook
> > Sent: 16 June 2020 04:25
> > 
> > For both pidfd and seccomp, the __user pointer is not used. Update
> > __fd_install_received() to make writing to ufd optional. (ufd
> > itself cannot checked for NULL because this changes the SCM_RIGHTS
> > interface behavior.) In these cases, the new fd needs to be returned
> > on success.  Update the existing callers to handle it. Add new wrapper
> > fd_install_received() for pidfd and seccomp that does not use the ufd
> > argument.
> ...> 
> >  static inline int fd_install_received_user(struct file *file, int __user *ufd,
> >  					   unsigned int o_flags)
> >  {
> > -	return __fd_install_received(file, ufd, o_flags);
> > +	return __fd_install_received(file, true, ufd, o_flags);
> > +}
> 
> Can you get rid of the 'return user' parameter by adding
> 	if (!ufd) return -EFAULT;
> to the above wrapper, then checking for NULL in the function?
> 
> Or does that do the wrong horrid things in the fail path?

Oh, hm. No, that shouldn't break the failure path, since everything gets
unwound in __fd_install_received if the ufd write fails.

Effectively this (I'll chop it up into the correct patches):

diff --git a/fs/file.c b/fs/file.c
index b583e7c60571..3b80324a31cc 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -939,18 +939,16 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
  *
  * @fd: fd to install into (if negative, a new fd will be allocated)
  * @file: struct file that was received from another process
- * @ufd_required: true to use @ufd for writing fd number to userspace
  * @ufd: __user pointer to write new fd number to
  * @o_flags: the O_* flags to apply to the new fd entry
  *
  * Installs a received file into the file descriptor table, with appropriate
  * checks and count updates. Optionally writes the fd number to userspace, if
- * @ufd_required is true (@ufd cannot just be tested for NULL because NULL may
- * actually get passed into SCM_RIGHTS).
+ * @ufd is non-NULL.
  *
  * Returns newly install fd or -ve on error.
  */
-int __fd_install_received(int fd, struct file *file, bool ufd_required,
+int __fd_install_received(int fd, struct file *file,
 			  int __user *ufd, unsigned int o_flags)
 {
 	struct socket *sock;
@@ -967,7 +965,7 @@ int __fd_install_received(int fd, struct file *file, bool ufd_required,
 			return new_fd;
 	}
 
-	if (ufd_required) {
+	if (ufd) {
 		error = put_user(new_fd, ufd);
 		if (error) {
 			put_unused_fd(new_fd);
diff --git a/include/linux/file.h b/include/linux/file.h
index f1d16e24a12e..2ade0d90bc5e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -91,20 +91,22 @@ extern void put_unused_fd(unsigned int fd);
 
 extern void fd_install(unsigned int fd, struct file *file);
 
-extern int __fd_install_received(int fd, struct file *file, bool ufd_required,
+extern int __fd_install_received(int fd, struct file *file,
 				 int __user *ufd, unsigned int o_flags);
 static inline int fd_install_received_user(struct file *file, int __user *ufd,
 					   unsigned int o_flags)
 {
-	return __fd_install_received(-1, file, true, ufd, o_flags);
+	if (ufd == NULL)
+		return -EFAULT;
+	return __fd_install_received(-1, file, ufd, o_flags);
 }
 static inline int fd_install_received(struct file *file, unsigned int o_flags)
 {
-	return __fd_install_received(-1, file, false, NULL, o_flags);
+	return __fd_install_received(-1, file, NULL, o_flags);
 }
 static inline int fd_replace_received(int fd, struct file *file, unsigned int o_flags)
 {
-	return __fd_install_received(fd, file, false, NULL, o_flags);
+	return __fd_install_received(fd, file, NULL, o_flags);
 }
 
 extern void flush_delayed_fput(void);

-- 
Kees Cook
