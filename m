Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C67215F5D
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgGFTah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:30:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6601EC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:30:36 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so3739353pfm.4
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 12:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jA71++q3kdwcFkfUU/1at8AL+IZxf2Nnq6lJ3LbUnXg=;
        b=Q+7dfF3lcRisIsTqM7EGD0tYjWye1O/Gfz50qcw4naOrpboCi2ZmrR6d1RzMnOs7mR
         Fh1/KCwCGizIS3GVQrZmc4YKPc7/8e4SSalTwfSqP37iQkamNsBrIJtKubGbQxGTlF4L
         Gxge8avBKJljPA0a7NtRL4/iHOuA13h42MPe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jA71++q3kdwcFkfUU/1at8AL+IZxf2Nnq6lJ3LbUnXg=;
        b=G3kb9aYxBNIZAheiEv7zk+knK/EEOw5ZhcHqDB8a7HGcV1l/jaetQJONiZJxknRvCD
         5HvoP6QnQqFcwSo6VVi+Xd9SWTBmH2CKvffJ6eyomq5h5+ix2d6el2hDw5g+WiPfzMio
         ikgO67YHUek1wqrekljAXRufYNbfxi1gJW4OsaPfyz9pGhpAD8OFzjA1OAbSSx4VavZs
         n7XHjI3X2oz9hTDJpz30Gg7QjfBQNCgqCug5y5Y1uoGuQeB0HiQ8IhXs1s3x51n4NCQC
         5xCtbNGFPqXnol5CQ7Vz/9JVt9H85c3at2oh2g+dOGtF+eoQEHvpmp2dRBJADEPCU7+M
         kNqA==
X-Gm-Message-State: AOAM531sbp44tH9/kxefNXG+oL3BdUAjQm1KKN3EP2lYkGHLgeXqbkq4
        bmLlKydgquqqwsLRdmvr3sWmIg==
X-Google-Smtp-Source: ABdhPJz7tXd/nnBDS0YQJcB7rwYbSOG0wy8tzeWXjOdUxA5eSWOjt+6q3dGWi3mLABNZOwnfZ4Olmg==
X-Received: by 2002:a62:fc15:: with SMTP id e21mr46353476pfh.167.1594063835932;
        Mon, 06 Jul 2020 12:30:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y8sm225835pju.49.2020.07.06.12.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 12:30:35 -0700 (PDT)
Date:   Mon, 6 Jul 2020 12:30:33 -0700
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
Subject: Re: [PATCH v5 4/7] pidfd: Replace open-coded partial
 fd_install_received()
Message-ID: <202007061225.5CBC3CF@keescook>
References: <20200617220327.3731559-1-keescook@chromium.org>
 <20200617220327.3731559-5-keescook@chromium.org>
 <20200706130713.n6r3vhn4hn2lodex@wittgenstein>
 <202007060830.0FE753B@keescook>
 <20200706161245.hjat2rsikt3linbm@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706161245.hjat2rsikt3linbm@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 06:12:45PM +0200, Christian Brauner wrote:
> On Mon, Jul 06, 2020 at 08:34:06AM -0700, Kees Cook wrote:
> > Yup, this was a mistake in my refactoring of the pidfs changes.
> 
> I already did.

Er, what? (I had a typo in my quote: s/pidfs/pidfd/.) I was trying to
say that this was just a mistake in my refactoring of the pidfd usage of
the new helper.

> > I still don't agree: it radically complicates the SCM_RIGHTS and seccomp
> 
> I'm sorry, I don't buy it yet, though I might've missed something in the
> discussions: :)
> After applying the patches in your series this literally is just (which
> is hardly radical ;):

Agreed, "radical" was too strong.

> diff --git a/fs/file.c b/fs/file.c
> index 9568bcfd1f44..26930b2ea39d 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -974,7 +974,7 @@ int __fd_install_received(int fd, struct file *file, int __user *ufd,
>         }
> 
>         if (fd < 0)
> -               fd_install(new_fd, get_file(file));
> +               fd_install(new_fd, file);
>         else {
>                 new_fd = fd;
>                 error = replace_fd(new_fd, file, o_flags);
> diff --git a/net/compat.c b/net/compat.c
> index 71494337cca7..605a5a67200c 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -298,9 +298,11 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
>         int err = 0, i;
> 
>         for (i = 0; i < fdmax; i++) {
> -               err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
> -               if (err < 0)
> +               err = fd_install_received_user(get_file(scm->fp->fp[i]), cmsg_data + i, o_flags);
> +               if (err < 0) {
> +                       fput(scm->fp->fp[i]);
>                         break;
> +               }
>         }
> 
>         if (i > 0) {
> diff --git a/net/core/scm.c b/net/core/scm.c
> index b9a0442ebd26..0d06446ae598 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -306,9 +306,11 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>         }
> 
>         for (i = 0; i < fdmax; i++) {
> -               err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
> -               if (err < 0)
> +               err = fd_install_received_user(get_file(scm->fp->fp[i]), cmsg_data + i, o_flags);
> +               if (err < 0) {
> +                       fput(scm->fp->fp[i]);
>                         break;
> +               }
>         }
> 
>         if (i > 0) {

But my point stands: I really dislike this; suddenly the caller needs to
manage this when it should be an entirely internal detail to the
function. It was only pidfd doing it wrong, and that was entirely my
fault in the conversion.

> The problem here is that the current patch invites bugs and has already
> produced one because fd_install() and fd_install_*() have the same
> naming scheme but different behavior when dealing with references.
> That's just not a good idea.

I will rename the helper and add explicit documentation, but I really
don't think callers should have to deal with managing the helper's split
ref lifetime.

-- 
Kees Cook
