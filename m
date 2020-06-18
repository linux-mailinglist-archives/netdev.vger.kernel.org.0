Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625E41FEB1F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgFRFtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgFRFtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 01:49:22 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E63C0613ED
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 22:49:22 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id w18so5682056iom.5
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 22:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jM1eoIIAt+grvNiuYi3rzmR7kTBktuLf10g4AO+YUOI=;
        b=0y1bvfItLik1rf3wmKn7Iu980MFvRglKuXHNUxhRgvYIMadB13+ziJIB8021zVD/3i
         S8wWZ/I1MB9wNT2Og7foF3D2CWDOmQmGASC8WAOPga/NMs3q6tUJudABNh6zM9yINyAp
         PttGFB7ur2H99nzntubSzEkQDyVNh4EGlGKgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jM1eoIIAt+grvNiuYi3rzmR7kTBktuLf10g4AO+YUOI=;
        b=gOJKzqmZgFpSQMOE/HRvrATcFfYEehl86JzZgitKz2Ucvr/75YmCNVKjbRBqDDD0wN
         S0KZZbqHzDEaRgSMqbZRMicgA2relPjH/e42QSqDuWcwHd8BsA/2fP4ro2LXq/Y9Yco8
         OsugdSVHX8rxjwASjxR6R/rvKY+7h0BpNzO2A8mhApQBoMosB7ktHcC7cvnHwqMkwTUH
         ImQvGZvI4g1Hb5Vu8Q7iT/QC5EaCvxWLdRrOl+AZ+sIz2XiYxv5hpRWUQ3I5sOx4JZWY
         RJZb0NOK0cJkCjriIWUlDyJwsr0oe+mhNX9Hrq9UNuZ3yySoVsVXmiO/pxWs99ta2m5k
         r+jw==
X-Gm-Message-State: AOAM530aZ3aPkzZBhYZVwusxqGY+CfQugM3tdVqOpwFmMAnnkUesNpiJ
        cgeJ+Nvi6FtS65sPzOKHVe1uIQ==
X-Google-Smtp-Source: ABdhPJycTD13Sevq9m2oc4L0wrVq1HgAkVfxdAa6RYaU6kPm28Y0RVvqaHnaQIcOg/iycnCDSM67EQ==
X-Received: by 2002:a02:5a85:: with SMTP id v127mr2785152jaa.83.1592459361462;
        Wed, 17 Jun 2020 22:49:21 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id b22sm1146946ios.21.2020.06.17.22.49.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 22:49:20 -0700 (PDT)
Date:   Thu, 18 Jun 2020 05:49:19 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
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
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 3/7] fs: Add fd_install_received() wrapper for
 __fd_install_received()
Message-ID: <20200618054918.GB18669@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200617220327.3731559-1-keescook@chromium.org>
 <20200617220327.3731559-4-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617220327.3731559-4-keescook@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 03:03:23PM -0700, Kees Cook wrote:
> For both pidfd and seccomp, the __user pointer is not used. Update
> __fd_install_received() to make writing to ufd optional via a NULL check.
> However, for the fd_install_received_user() wrapper, ufd is NULL checked
> so an -EFAULT can be returned to avoid changing the SCM_RIGHTS interface
> behavior. Add new wrapper fd_install_received() for pidfd and seccomp
> that does not use the ufd argument. For the new helper, the new fd needs
> to be returned on success. Update the existing callers to handle it.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/file.c            | 22 ++++++++++++++--------
>  include/linux/file.h |  7 +++++++
>  net/compat.c         |  2 +-
>  net/core/scm.c       |  2 +-
>  4 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index f2167d6feec6..de85a42defe2 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -942,9 +942,10 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>   * @o_flags: the O_* flags to apply to the new fd entry
>   *
>   * Installs a received file into the file descriptor table, with appropriate
> - * checks and count updates. Writes the fd number to userspace.
> + * checks and count updates. Optionally writes the fd number to userspace, if
> + * @ufd is non-NULL.
>   *
> - * Returns -ve on error.
> + * Returns newly install fd or -ve on error.
>   */
>  int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_flags)
>  {
> @@ -960,20 +961,25 @@ int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_fla
>  	if (new_fd < 0)
>  		return new_fd;
>  
> -	error = put_user(new_fd, ufd);
> -	if (error) {
> -		put_unused_fd(new_fd);
> -		return error;
> +	if (ufd) {
> +		error = put_user(new_fd, ufd);
> +		if (error) {
> +			put_unused_fd(new_fd);
> +			return error;
> +		}
>  	}
>  
> -	/* Bump the usage count and install the file. */
> +	/* Bump the usage count and install the file. The resulting value of
> +	 * "error" is ignored here since we only need to take action when
> +	 * the file is a socket and testing "sock" for NULL is sufficient.
> +	 */
>  	sock = sock_from_file(file, &error);
>  	if (sock) {
>  		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
>  		sock_update_classid(&sock->sk->sk_cgrp_data);
>  	}
>  	fd_install(new_fd, get_file(file));
> -	return 0;
> +	return new_fd;
>  }
>  
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
> diff --git a/include/linux/file.h b/include/linux/file.h
> index fe18a1a0d555..e19974ed9322 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -9,6 +9,7 @@
>  #include <linux/compiler.h>
>  #include <linux/types.h>
>  #include <linux/posix_types.h>
> +#include <linux/errno.h>
>  
>  struct file;
>  
> @@ -96,8 +97,14 @@ extern int __fd_install_received(struct file *file, int __user *ufd,
>  static inline int fd_install_received_user(struct file *file, int __user *ufd,
>  					   unsigned int o_flags)
>  {
> +	if (ufd == NULL)
> +		return -EFAULT;
Isn't this *technically* a behvaiour change? Nonetheless, I think this is a much better
approach than forcing everyone to do null checking, and avoids at least one error case
where the kernel installs FDs for SCM_RIGHTS, and they're not actualy usable.

>  	return __fd_install_received(file, ufd, o_flags);
>  }
> +static inline int fd_install_received(struct file *file, unsigned int o_flags)
> +{
> +	return __fd_install_received(file, NULL, o_flags);
> +}
>  
>  extern void flush_delayed_fput(void);
>  extern void __fput_sync(struct file *);
> diff --git a/net/compat.c b/net/compat.c
> index 94f288e8dac5..71494337cca7 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -299,7 +299,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
>  
>  	for (i = 0; i < fdmax; i++) {
>  		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
> -		if (err)
> +		if (err < 0)
>  			break;
>  	}
>  
> diff --git a/net/core/scm.c b/net/core/scm.c
> index df190f1fdd28..b9a0442ebd26 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -307,7 +307,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  
>  	for (i = 0; i < fdmax; i++) {
>  		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
> -		if (err)
> +		if (err < 0)
>  			break;
>  	}
>  
> -- 
> 2.25.1
> 

Reviewed-by: Sargun Dhillon <sargun@sargun.me>
