Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A5D1FA83B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 07:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFPF3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 01:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbgFPF3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 01:29:46 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A224C08C5C3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 22:29:44 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h3so17629736ilh.13
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 22:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/atL1Ve60OqcVOW1A17eOHeeXaoo7IDTY4Z8Un8jaH8=;
        b=193OWy+wrWHpQHLeiYDs4HwLjRR3lzkgnsBt2V+dkl6TagtCtHrBhNG24ihvS9W6Zf
         zasBHbcZhYtRMZisoQXuaE9BeVT715PI0S1hhwE0J7wByQ95ip3Y+PHUh72iIzi+jHkx
         GEj69+viDrq4GN/szP7+GnPsyYy7nNibYDgc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/atL1Ve60OqcVOW1A17eOHeeXaoo7IDTY4Z8Un8jaH8=;
        b=V0iFivvlN1Fe6C16OY8xy3SmMXq00djl8TLl3h9ZjiuGLkoMVQHdUqXOoNqIHD04NP
         wLbVwdn8SH+ETodLX+hOaEjCK+qPJq7cn0HAPlXDaumCIgJh3s25m5aan/Q1N3Uq6kjJ
         Fleu8poBEXtxjSsDM3mTL5GDQl91UkBcyiPRaVIgn7/mt4g/6WbHnV09udD9WQjcdaiY
         jK2GXWRKCc062DjZ1qjbLZuphXL7tDyuzS2A0u/t8Iv7EwCGBRWqwmSDK3aCTNMP4gr0
         v/YHBncbQyW6Zwck/jR/oN1PSY4Ln27gvGpN2uiAm3IUWvkBUAOrJlsiwoRUe20QEVxU
         9BNA==
X-Gm-Message-State: AOAM531ptMzVExWrfPcovX6MxFQzD0WB4UpL6RsfdsPQ+bw4fkv0z0MR
        DDt5+highZSwT10qttzopwfVcg==
X-Google-Smtp-Source: ABdhPJx5Rg1ST0KUj/PKC9lU9klQRZh96t9kjm/st69tOnr6RVzMkeGE8OyZPHSvj533a1JeUJYcxA==
X-Received: by 2002:a92:c7c6:: with SMTP id g6mr1539412ilk.49.1592285383432;
        Mon, 15 Jun 2020 22:29:43 -0700 (PDT)
Received: from ircssh-2.c.rugged-nimbus-611.internal (80.60.198.104.bc.googleusercontent.com. [104.198.60.80])
        by smtp.gmail.com with ESMTPSA id z16sm9204945ilz.64.2020.06.15.22.29.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 22:29:43 -0700 (PDT)
Date:   Tue, 16 Jun 2020 05:29:41 +0000
From:   Sargun Dhillon <sargun@sargun.me>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
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
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 02/11] fs: Move __scm_install_fd() to
 __fd_install_received()
Message-ID: <20200616052941.GB16032@ircssh-2.c.rugged-nimbus-611.internal>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616032524.460144-3-keescook@chromium.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 08:25:15PM -0700, Kees Cook wrote:
> In preparation for users of the "install a received file" logic outside
> of net/ (pidfd and seccomp), relocate and rename __scm_install_fd() from
> net/core/scm.c to __fd_install_received() in fs/file.c, and provide a
> wrapper named fd_install_received_user(), as future patches will change
> the interface to __fd_install_received().
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/file.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/file.h |  8 ++++++++
>  include/net/scm.h    |  1 -
>  net/compat.c         |  2 +-
>  net/core/scm.c       | 32 +-----------------------------
>  5 files changed, 57 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index abb8b7081d7a..fcfddae0d252 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -11,6 +11,7 @@
>  #include <linux/export.h>
>  #include <linux/fs.h>
>  #include <linux/mm.h>
> +#include <linux/net.h>
>  #include <linux/sched/signal.h>
>  #include <linux/slab.h>
>  #include <linux/file.h>
> @@ -18,6 +19,8 @@
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> +#include <net/cls_cgroup.h>
> +#include <net/netprio_cgroup.h>
>  
>  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
>  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> @@ -931,6 +934,50 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
>  	return err;
>  }
>  
> +/**
> + * __fd_install_received() - Install received file into file descriptor table
> + *
> + * @fd: fd to install into (if negative, a new fd will be allocated)
> + * @file: struct file that was received from another process
> + * @ufd_required: true to use @ufd for writing fd number to userspace
> + * @ufd: __user pointer to write new fd number to
> + * @o_flags: the O_* flags to apply to the new fd entry
Probably doesn't matter, but this function doesn't take the fd, or ufd_required
argument in this patch. 

> + *
> + * Installs a received file into the file descriptor table, with appropriate
> + * checks and count updates. Optionally writes the fd number to userspace.
ufd does not apppear options here.

> + *
> + * Returns -ve on error.
> + */
> +int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_flags)
> +{
> +	struct socket *sock;
> +	int new_fd;
> +	int error;
> +
> +	error = security_file_receive(file);
> +	if (error)
> +		return error;
> +
> +	new_fd = get_unused_fd_flags(o_flags);
> +	if (new_fd < 0)
> +		return new_fd;
> +
> +	error = put_user(new_fd, ufd);
> +	if (error) {
> +		put_unused_fd(new_fd);
> +		return error;
> +	}
> +
> +	/* Bump the usage count and install the file. */
> +	sock = sock_from_file(file, &error);
> +	if (sock) {
> +		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> +		sock_update_classid(&sock->sk->sk_cgrp_data);
> +	}
> +	fd_install(new_fd, get_file(file));
> +	return 0;
> +}
> +
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  {
>  	int err = -EBADF;
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 122f80084a3e..fe18a1a0d555 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -91,6 +91,14 @@ extern void put_unused_fd(unsigned int fd);
>  
>  extern void fd_install(unsigned int fd, struct file *file);
>  
> +extern int __fd_install_received(struct file *file, int __user *ufd,
> +				 unsigned int o_flags);
> +static inline int fd_install_received_user(struct file *file, int __user *ufd,
> +					   unsigned int o_flags)
> +{
> +	return __fd_install_received(file, ufd, o_flags);
> +}
> +
>  extern void flush_delayed_fput(void);
>  extern void __fput_sync(struct file *);
>  
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 581a94d6c613..1ce365f4c256 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -37,7 +37,6 @@ struct scm_cookie {
>  #endif
>  };
>  
> -int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags);
>  void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
>  void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
>  int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
> diff --git a/net/compat.c b/net/compat.c
> index 27d477fdcaa0..94f288e8dac5 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -298,7 +298,7 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
>  	int err = 0, i;
>  
>  	for (i = 0; i < fdmax; i++) {
> -		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> +		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
>  		if (err)
>  			break;
>  	}
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 6151678c73ed..df190f1fdd28 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -280,36 +280,6 @@ void put_cmsg_scm_timestamping(struct msghdr *msg, struct scm_timestamping_inter
>  }
>  EXPORT_SYMBOL(put_cmsg_scm_timestamping);
>  
> -int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> -{
> -	struct socket *sock;
> -	int new_fd;
> -	int error;
> -
> -	error = security_file_receive(file);
> -	if (error)
> -		return error;
> -
> -	new_fd = get_unused_fd_flags(o_flags);
> -	if (new_fd < 0)
> -		return new_fd;
> -
> -	error = put_user(new_fd, ufd);
> -	if (error) {
> -		put_unused_fd(new_fd);
> -		return error;
> -	}
> -
> -	/* Bump the usage count and install the file. */
> -	sock = sock_from_file(file, &error);
> -	if (sock) {
> -		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> -		sock_update_classid(&sock->sk->sk_cgrp_data);
> -	}
> -	fd_install(new_fd, get_file(file));
> -	return 0;
> -}
> -
>  static int scm_max_fds(struct msghdr *msg)
>  {
>  	if (msg->msg_controllen <= sizeof(struct cmsghdr))
> @@ -336,7 +306,7 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>  	}
>  
>  	for (i = 0; i < fdmax; i++) {
> -		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> +		err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
>  		if (err)
>  			break;
>  	}
> -- 
> 2.25.1
> 
