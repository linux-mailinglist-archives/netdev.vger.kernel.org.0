Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88EF219486
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 01:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgGHXqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 19:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHXqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 19:46:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E72C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 16:46:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t11so164356pfq.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 16:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wjXXLmNasbmFovZrtae0ec77dHFuvWrKDR6UgZkQq1o=;
        b=X1FU4G1VLFZex+8YiDlXau6+MCCQm8OG7mebpY9uGQDklifI/m4+5Xql3pSiPyk7wI
         RYBJQUA75gBRMOCLqN/1/4LZs5wbPVYGqQNFaKqo3lGTVQWMw64uQh+BWsjO/eUaFuAL
         5uUSeZQG+L+RIsEOS6bJ66gWqPlq1K4GAiO4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wjXXLmNasbmFovZrtae0ec77dHFuvWrKDR6UgZkQq1o=;
        b=EqxdE8mRctqCnJFV8qMS/lFHkrpBhCQ+Qc1H5e9G8W7POD/hZMrmPlUbqbgcOEyoDj
         Dp9wh8lbyyQQ3sQX0X3o4kCTALbZLxroCZrFu+OFj3QjRwWf29q5jcp8N5f5B97mowZ/
         jWHx6HcBC4a7RMa4uRmDVZXs4a6JnqzNJGmLMo4s9IdVipCbdpfzUYpvE2qTFAIMJflb
         Bhhbf59zf8CyIdf7Zb3uf/XHMmSBC07WvRQp4uGRKHQD2I9qFd3frEakyJx0Y5RHFKJC
         ARTo9K9z1wowE21SEkCKtCgBgRKEZmr7sEdFC2GDY+HSjdBbaBANkAO67gprleTpfxue
         qkRg==
X-Gm-Message-State: AOAM530X1U35cKH3+rOCi+DtDKVKhmF7sS42dI2pmW9FcoBMNYRURcN8
        T1Lr1LnI35a0AgGsv0I7t2QCPw==
X-Google-Smtp-Source: ABdhPJzcShw6xLbb9Fq4V0uhaRKl2b8m8iqOu3ZQoUcx4EgzAu79u0+9nu96sxU6kKMTElpnEagW1g==
X-Received: by 2002:aa7:8e90:: with SMTP id a16mr53417728pfr.84.1594251966115;
        Wed, 08 Jul 2020 16:46:06 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v11sm807844pfc.108.2020.07.08.16.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 16:46:05 -0700 (PDT)
Date:   Wed, 8 Jul 2020 16:46:04 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
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
Subject: Re: [PATCH v6 1/7] net/scm: Regularize compat handling of
 scm_detach_fds()
Message-ID: <202007081636.5458B0B@keescook>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-2-keescook@chromium.org>
 <20200707114103.lkfbt3kdtturp42z@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707114103.lkfbt3kdtturp42z@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 01:41:03PM +0200, Christian Brauner wrote:
> On Mon, Jul 06, 2020 at 01:17:14PM -0700, Kees Cook wrote:
> > Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
> > scm_detach_fds") into the compat code.
> > 
> > Move the check added in commit 1f466e1f15cf ("net: cleanly handle kernel
> > vs user buffers for ->msg_control") to before the compat call, even
> > though it should be impossible for an in-kernel call to also be compat.
> > 
> > Correct the int "flags" argument to unsigned int to match fd_install()
> > and similar APIs.
> > 
> > Regularize any remaining differences, including a whitespace issue,
> > a checkpatch warning, and add the check from commit 6900317f5eff ("net,
> > scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
> > fixed an overflow unique to 64-bit. To avoid confusion when comparing
> > the compat handler to the native handler, just include the same check
> > in the compat handler.
> > 
> > Fixes: 48a87cc26c13 ("net: netprio: fd passed in SCM_RIGHTS datagram not set correctly")
> > Fixes: d84295067fc7 ("net: net_cls: fd passed in SCM_RIGHTS datagram not set correctly")
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> 
> Thanks. Just a comment below.
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks!

> >  include/net/scm.h |  1 +
> >  net/compat.c      | 55 +++++++++++++++++++++--------------------------
> >  net/core/scm.c    | 18 ++++++++--------
> >  3 files changed, 35 insertions(+), 39 deletions(-)
> > 
> > diff --git a/include/net/scm.h b/include/net/scm.h
> > index 1ce365f4c256..581a94d6c613 100644
> > --- a/include/net/scm.h
> > +++ b/include/net/scm.h
> > @@ -37,6 +37,7 @@ struct scm_cookie {
> >  #endif
> >  };
> >  
> > +int __scm_install_fd(struct file *file, int __user *ufd, unsigned int o_flags);
> >  void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm);
> >  void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm);
> >  int __scm_send(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm);
> > diff --git a/net/compat.c b/net/compat.c
> > index 5e3041a2c37d..27d477fdcaa0 100644
> > --- a/net/compat.c
> > +++ b/net/compat.c
> > @@ -281,39 +281,31 @@ int put_cmsg_compat(struct msghdr *kmsg, int level, int type, int len, void *dat
> >  	return 0;
> >  }
> >  
> > -void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
> > +static int scm_max_fds_compat(struct msghdr *msg)
> >  {
> > -	struct compat_cmsghdr __user *cm = (struct compat_cmsghdr __user *) kmsg->msg_control;
> > -	int fdmax = (kmsg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
> > -	int fdnum = scm->fp->count;
> > -	struct file **fp = scm->fp->fp;
> > -	int __user *cmfptr;
> > -	int err = 0, i;
> > +	if (msg->msg_controllen <= sizeof(struct compat_cmsghdr))
> > +		return 0;
> > +	return (msg->msg_controllen - sizeof(struct compat_cmsghdr)) / sizeof(int);
> > +}
> >  
> > -	if (fdnum < fdmax)
> > -		fdmax = fdnum;
> > +void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
> > +{
> > +	struct compat_cmsghdr __user *cm =
> > +		(struct compat_cmsghdr __user *)msg->msg_control;
> > +	unsigned int o_flags = (msg->msg_flags & MSG_CMSG_CLOEXEC) ? O_CLOEXEC : 0;
> > +	int fdmax = min_t(int, scm_max_fds_compat(msg), scm->fp->count);
> 
> Just a note that SCM_RIGHTS fd-sending is limited to 253 (SCM_MAX_FD)
> fds so min_t should never ouput > SCM_MAX_FD here afaict.
> 
> > +	int __user *cmsg_data = CMSG_USER_DATA(cm);
> > +	int err = 0, i;
> >  
> > -	for (i = 0, cmfptr = (int __user *) CMSG_COMPAT_DATA(cm); i < fdmax; i++, cmfptr++) {
> > -		int new_fd;
> > -		err = security_file_receive(fp[i]);
> > +	for (i = 0; i < fdmax; i++) {
> > +		err = __scm_install_fd(scm->fp->fp[i], cmsg_data + i, o_flags);
> >  		if (err)
> >  			break;
> > -		err = get_unused_fd_flags(MSG_CMSG_CLOEXEC & kmsg->msg_flags
> > -					  ? O_CLOEXEC : 0);
> > -		if (err < 0)
> > -			break;
> > -		new_fd = err;
> > -		err = put_user(new_fd, cmfptr);
> > -		if (err) {
> > -			put_unused_fd(new_fd);
> > -			break;
> > -		}
> > -		/* Bump the usage count and install the file. */
> > -		fd_install(new_fd, get_file(fp[i]));
> >  	}
> >  
> >  	if (i > 0) {
> >  		int cmlen = CMSG_COMPAT_LEN(i * sizeof(int));
> > +
> >  		err = put_user(SOL_SOCKET, &cm->cmsg_level);
> >  		if (!err)
> >  			err = put_user(SCM_RIGHTS, &cm->cmsg_type);
> > @@ -321,16 +313,19 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
> >  			err = put_user(cmlen, &cm->cmsg_len);
> >  		if (!err) {
> >  			cmlen = CMSG_COMPAT_SPACE(i * sizeof(int));
> > -			kmsg->msg_control += cmlen;
> > -			kmsg->msg_controllen -= cmlen;
> > +			if (msg->msg_controllen < cmlen)
> > +				cmlen = msg->msg_controllen;
> > +			msg->msg_control += cmlen;
> > +			msg->msg_controllen -= cmlen;
> >  		}
> >  	}
> > -	if (i < fdnum)
> > -		kmsg->msg_flags |= MSG_CTRUNC;
> > +
> > +	if (i < scm->fp->count || (scm->fp->count && fdmax <= 0))
> 
> I think fdmax can't be < 0 after your changes? scm_max_fds() guarantees
> that fdmax is always >= 0 and min_t() guarantees that fdmax <= scm->fp->count.
> So the check should technically be :)

You left our your suggestion! :) But, I think you mean "== 0" ?

The check actually comes from the refactoring from commit 2618d530dd8b
("net/scm: cleanup scm_detach_fds") which I mostly copy/pasted into
compat. However, fdmax is an int, and scm->fp->count is signed so it's
possible fdmax is < 0 (but I don't think count can actually ever be <
0), but I don't want to refactor all the types just to fix this boundary
condition. :)

-- 
Kees Cook
