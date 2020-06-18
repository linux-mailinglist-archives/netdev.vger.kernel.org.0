Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E21FFC3B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730965AbgFRUFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730934AbgFRUFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:05:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9855C0613EF
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:05:16 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so3414449pgk.4
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 13:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hH5UdqkrUsHHkWkTkrsTpUaZ/SG0CR6QLInGjMheMsQ=;
        b=etadw103cqJRZdZ59vL7+FSIVCyWqJxsPUoshMP46pJkWYpyPh1Z8z2rOaozPM6T9H
         5c7AmqMnocB+A8JJb/7BGlmzUHsa8VUg/Sy09a1I4Lr+wMi+eXoSUP1amVW/VFTdTB0Y
         Az+830Tp9h9FTrH3X1IX6E56xQAUj6mYytnd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hH5UdqkrUsHHkWkTkrsTpUaZ/SG0CR6QLInGjMheMsQ=;
        b=LpoIGKF2NA9QpndoTNpOJ7eyyR4KKyHKh335IaeTAAwbUfFpnoS4wNJPqxUcw4DTYh
         BffubuC9PvU8SsO3tBAJlM+5myP8jx39RFratvfbquxovuz5E1FgOZPqZyAfgDKbZvW2
         5D9l+AcWPiVFDmyksOJSXsjogwZ42aHNrPhXsLkVzCUX2czypJ3ImWZtDnRexkqzMBhn
         z0XI8++1wVun9dKv1b2s8ZB4+Lfo58i/QEzNkR5jmcyXwwpgMFU8LVdNVrtwi+WOV3Y/
         Ul2rLcK61m9IKr3zrUoHTp3QfhT+BgxIp5VJvdkUH/bVWboUHpNenRVtzGsJDIM0kIcA
         J+bQ==
X-Gm-Message-State: AOAM531/mf9Fe32sr2tNAS2Gdq3T9OBWpDpPdZKzCNR5clXNnRu1i1/2
        r1KwluMzTQ3RDLnFskgpm/W8Ww==
X-Google-Smtp-Source: ABdhPJyvN1SyXkPFRjQ3ru6p0iO6TqH4uR0HKiNTz7KbggpLMsPBApIzCK92OExHh+Nr7VZgXchX+A==
X-Received: by 2002:a62:1c5:: with SMTP id 188mr4954296pfb.213.1592510716220;
        Thu, 18 Jun 2020 13:05:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p14sm3201600pju.7.2020.06.18.13.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 13:05:15 -0700 (PDT)
Date:   Thu, 18 Jun 2020 13:05:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
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
Message-ID: <202006181302.84BFFF52CA@keescook>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-3-keescook@chromium.org>
 <20200618085614.fw3ynalpcipbplf3@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618085614.fw3ynalpcipbplf3@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 10:56:14AM +0200, Christian Brauner wrote:
> On Mon, Jun 15, 2020 at 08:25:15PM -0700, Kees Cook wrote:
> > In preparation for users of the "install a received file" logic outside
> > of net/ (pidfd and seccomp), relocate and rename __scm_install_fd() from
> > net/core/scm.c to __fd_install_received() in fs/file.c, and provide a
> > wrapper named fd_install_received_user(), as future patches will change
> > the interface to __fd_install_received().
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  fs/file.c            | 47 ++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/file.h |  8 ++++++++
> >  include/net/scm.h    |  1 -
> >  net/compat.c         |  2 +-
> >  net/core/scm.c       | 32 +-----------------------------
> >  5 files changed, 57 insertions(+), 33 deletions(-)
> > 
> > diff --git a/fs/file.c b/fs/file.c
> > index abb8b7081d7a..fcfddae0d252 100644
> > --- a/fs/file.c
> > +++ b/fs/file.c
> > @@ -11,6 +11,7 @@
> >  #include <linux/export.h>
> >  #include <linux/fs.h>
> >  #include <linux/mm.h>
> > +#include <linux/net.h>
> >  #include <linux/sched/signal.h>
> >  #include <linux/slab.h>
> >  #include <linux/file.h>
> > @@ -18,6 +19,8 @@
> >  #include <linux/bitops.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/rcupdate.h>
> > +#include <net/cls_cgroup.h>
> > +#include <net/netprio_cgroup.h>
> >  
> >  unsigned int sysctl_nr_open __read_mostly = 1024*1024;
> >  unsigned int sysctl_nr_open_min = BITS_PER_LONG;
> > @@ -931,6 +934,50 @@ int replace_fd(unsigned fd, struct file *file, unsigned flags)
> >  	return err;
> >  }
> >  
> > +/**
> > + * __fd_install_received() - Install received file into file descriptor table
> > + *
> > + * @fd: fd to install into (if negative, a new fd will be allocated)
> > + * @file: struct file that was received from another process
> > + * @ufd_required: true to use @ufd for writing fd number to userspace
> > + * @ufd: __user pointer to write new fd number to
> > + * @o_flags: the O_* flags to apply to the new fd entry
> > + *
> > + * Installs a received file into the file descriptor table, with appropriate
> > + * checks and count updates. Optionally writes the fd number to userspace.
> > + *
> > + * Returns -ve on error.
> > + */
> > +int __fd_install_received(struct file *file, int __user *ufd, unsigned int o_flags)
> > +{
> > +	struct socket *sock;
> > +	int new_fd;
> > +	int error;
> > +
> > +	error = security_file_receive(file);
> > +	if (error)
> > +		return error;
> > +
> > +	new_fd = get_unused_fd_flags(o_flags);
> > +	if (new_fd < 0)
> > +		return new_fd;
> > +
> > +	error = put_user(new_fd, ufd);
> > +	if (error) {
> > +		put_unused_fd(new_fd);
> > +		return error;
> > +	}
> > +
> > +	/* Bump the usage count and install the file. */
> > +	sock = sock_from_file(file, &error);
> > +	if (sock) {
> > +		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> > +		sock_update_classid(&sock->sk->sk_cgrp_data);
> > +	}
> > +	fd_install(new_fd, get_file(file));
> > +	return 0;
> > +}
> > +
> >  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
> >  {
> >  	int err = -EBADF;
> > diff --git a/include/linux/file.h b/include/linux/file.h
> > index 122f80084a3e..fe18a1a0d555 100644
> > --- a/include/linux/file.h
> > +++ b/include/linux/file.h
> > @@ -91,6 +91,14 @@ extern void put_unused_fd(unsigned int fd);
> >  
> >  extern void fd_install(unsigned int fd, struct file *file);
> >  
> > +extern int __fd_install_received(struct file *file, int __user *ufd,
> > +				 unsigned int o_flags);
> > +static inline int fd_install_received_user(struct file *file, int __user *ufd,
> > +					   unsigned int o_flags)
> > +{
> > +	return __fd_install_received(file, ufd, o_flags);
> > +}
> 
> Shouldn't this be the other way around such that
> fd_install_received_user() is the workhorse that has a "ufd" argument
> and fd_install_received() is the static inline function that doesn't?
> 
> extern int fd_install_received_user(struct file *file, int __user *ufd, unsigned int o_flags)
> static inline int fd_install_received(struct file *file, unsigned int o_flags)
> {
> 	return fd_install_received_user(file, NULL, o_flags);
> }

So, I think it's all worked out in v5[1], so the helper argument handling
is better for the ufd case, as David pointed out earlier. (As in,
I think you're reacting to the same general problem here.)

> (So I'm on vacation this week some my reviews are selective and spotty
> but I promise to be back next week. :))

No worries!

-Kees

[1] https://lore.kernel.org/lkml/20200617220327.3731559-1-keescook@chromium.org/

-- 
Kees Cook
