Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514801F5953
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgFJQqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgFJQqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 12:46:04 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8127DC03E96B
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:46:02 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id o5so2964424iow.8
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 09:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+KF3Wg/KxPPsJnDwGBY4BTGRIdXAYib5hVwhMtHWLfU=;
        b=HgRMAuTWMBRBanlAB5E2bZMUR3yQzh2TAR348xhZFkKLdl6VkFbd8lfpnil/ZRcEp4
         4LhjxroS+10lgG32UVuCCmD24KDsjkmYd6x9H9e6fKK74z86ggmWb9GYqt7BLRWc11Aa
         +cYfguNB5oZfimX73XONF31dxBMsZOfbKNmTo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+KF3Wg/KxPPsJnDwGBY4BTGRIdXAYib5hVwhMtHWLfU=;
        b=Tittimx+XCuBKalDIloyqVB2q0ayPfjLGGqKIjV0An9y5hCSAf/a+p5hEvt4+sAW8a
         FRZAa1IxjKoxQ90kxEfe/0eThBFIG0s9iO91nV5k4MdRSIn8QHva7klHfx80oHM0/oRO
         zL4vK/w7xlt9pRp/vqGLROwOkkph5B8Yz9nrtXvLpeaVY+yr2KjVEUD9otC7N4QnWP11
         okJBbdlsdLKde8zBqa+i+HZ4w2dn9YQ9OUu3/yexmJN2mRVF5QWTCCLmPlE9OzZkRc/Z
         eU02ljg9jMacE2UaxXTqANtryP4dsqpBhLBLBlMkGYDPPWcBAe1f7REjId2Ip3zIeMHx
         mNeQ==
X-Gm-Message-State: AOAM5335vbrRImcSni4Z0lFhE9Kkq3ktidLmEyeP5AE8VwAz9eAqKRua
        Ygnqozmt3QDmCAE6MX+X6WZOMrcaY6xGog==
X-Google-Smtp-Source: ABdhPJzAEl8tQK/3JovbXIeTrhwaRfdkvH2RM45wUhIv1vuHEWFFrbA6dYbpMJnhTGD1odepimGgVA==
X-Received: by 2002:a6b:7611:: with SMTP id g17mr4174027iom.110.1591807561732;
        Wed, 10 Jun 2020 09:46:01 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id b8sm190113ior.35.2020.06.10.09.46.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 09:46:01 -0700 (PDT)
Date:   Wed, 10 Jun 2020 16:45:59 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian@brauner.io>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pidfd: Replace open-coded partial __scm_install_fd()
Message-ID: <20200610164558.GA30124@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200610045214.1175600-1-keescook@chromium.org>
 <20200610045214.1175600-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610045214.1175600-3-keescook@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 09, 2020 at 09:52:14PM -0700, Kees Cook wrote:
> The sock counting (sock_update_netprioidx() and sock_update_classid())
> was missing from this implementation of fd installation, compared to
> SCM_RIGHTS. Use the new scm helper to get the work done, after adjusting
> it to return the installed fd and accept a NULL user pointer.
> 
> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> AFAICT, the following patches are needed for back-porting this to stable:
> 
> 0462b6bdb644 ("net: add a CMSG_USER_DATA macro")
> 2618d530dd8b ("net/scm: cleanup scm_detach_fds")
> 1f466e1f15cf ("net: cleanly handle kernel vs user buffers for ->msg_control")
> 6e8a4f9dda38 ("net: ignore sock_from_file errors in __scm_install_fd")
> ---
>  kernel/pid.c   | 12 ++----------
>  net/compat.c   |  2 +-
>  net/core/scm.c | 27 ++++++++++++++++++++-------
>  3 files changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index f1496b757162..a7ce4ba898d3 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -42,6 +42,7 @@
>  #include <linux/sched/signal.h>
>  #include <linux/sched/task.h>
>  #include <linux/idr.h>
> +#include <net/scm.h>
>  
>  struct pid init_struct_pid = {
>  	.count		= REFCOUNT_INIT(1),
> @@ -635,18 +636,9 @@ static int pidfd_getfd(struct pid *pid, int fd)
>  	if (IS_ERR(file))
>  		return PTR_ERR(file);
>  
> -	ret = security_file_receive(file);
> -	if (ret) {
> -		fput(file);
> -		return ret;
> -	}
> -
> -	ret = get_unused_fd_flags(O_CLOEXEC);
> +	ret = __scm_install_fd(file, NULL, O_CLOEXEC);
>  	if (ret < 0)
>  		fput(file);
> -	else
> -		fd_install(ret, file);
> -
>  	return ret;
>  }
>  
> diff --git a/net/compat.c b/net/compat.c
> index 117f1869bf3b..f8575555b6d7 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -299,7 +299,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
>  
>  	for (i = 0; i < fdmax; i++) {
>  		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> -		if (err)
> +		if (err < 0)
>  			break;
>  	}
>  
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 86d96152646f..e80648fb4da7 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -280,6 +280,14 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
>  }
>  EXPORT_SYMBOL(put_cmsg_scm_timestamping);
>  
> +/**
> + * __scm_install_fd() - Install received file into file descriptor table
Any reason not to rename this remote_install_* or similar, and move it to fs/?
> + *
> + * Installs a received file into the file descriptor table, with appropriate
> + * checks and count updates.
> + *
> + * Returns fd installed or -ve on error.
> + */
>  int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
>  {
>  	struct socket *sock;
> @@ -294,20 +302,25 @@ int __scm_install_fd(struct file *file, int __user *ufd, int o_flags)
>  	if (new_fd < 0)
>  		return new_fd;
>  
> -	error = put_user(new_fd, ufd);
> -	if (error) {
> -		put_unused_fd(new_fd);
> -		return error;
> +	if (ufd) {
See my comment elsewhere about not being able to use NULL here.
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
>  static int scm_max_fds(struct msghdr *msg)
> @@ -337,7 +350,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  
>  	for (i = 0; i < fdmax; i++) {
>  		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> -		if (err)
> +		if (err < 0)
>  			break;
>  	}
>  
> -- 
> 2.25.1
> 
