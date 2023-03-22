Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2866C504C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjCVQRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCVQRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:17:03 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0626E5AB66
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:17:00 -0700 (PDT)
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com [209.85.128.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9CBF844518
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1679501818;
        bh=5QvK/RWVsdh1PrNgrgSsfKAyfmsSiQq5SuhN6WWxP1g=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=ec3QpiacodC48Fk+iyNvB3i7F68pW3IDkxNTg4fshC3lYx9rDce3TMPNdHPZrqxJj
         Bd1F/9JYz36GlaVEvjkvkuN1pXV/7/xBIjsJEDQNil1UQ6cE6QuFMjmQgBTahu1rau
         HumK/f3k8zjL+GJeVa6dy321tDTtiM2I8ZVtfKQbCgFwBeyAPHHGuCsar4XQqcSWoU
         pAiPgpLa137VJEsa2xk5zUMHRAOGDyxeaDa0frYyKpcHwEA4EWEQs8y7NBpbjxc0cw
         IoUOP/H61vEe7vH7r47DORzF4KShoZz8JcOB+nVGvBIyrrI6tPZ9DkJkoQ+BpNeLMT
         GbGtFpOqaxM1Q==
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-54463468d06so191843347b3.7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679501817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5QvK/RWVsdh1PrNgrgSsfKAyfmsSiQq5SuhN6WWxP1g=;
        b=gV30Khc196NZ7MO0R1MUxM70fgp+b1u2ROMmuv+8HL+WAosseGAWvcsnaV6lULKUJp
         uUT/ISaWKYY3rdg75Zn5/1oSSD6RCysg/ZdPlTW7mfm6Q2ZgcN05i9q81ugeMrUcLS/U
         JsX54SWTOscB4dBs+bW/BnSxH7KcFovZEX86YnEtXzvHQ3wI/Eecb8BPngsFAP28SwRO
         0WYIb5amoG7VKif6XmCZkknbJeQtdiZ+mYhdv9563Hh4iMS/Ly3cU1WH61F7JsOUxlD8
         4/BVke9lx3vm6YFm/XNLsvazKZkou6Iza9Lf9JMb1Cc/fFEufKZ9XaLYpfG6F9Vonn1X
         9/IQ==
X-Gm-Message-State: AAQBX9d3+tp3VJTnLqZ8yT8dCRBCKcMaWZdlmkEoo7kQ6mpp9Ef4KgYw
        Br6PIGQ7nrKdzCVZUHdoT8dTZth8xT6VN89dP9FiC9Br2mfuHgBD4nIQRKbn+XU/n0nPYV9Jn9s
        H30iIF4M/FdGqXkEV++tLKHESthrDBanBOp8tceX7tOe+0VT5YQ==
X-Received: by 2002:a25:a28f:0:b0:a99:de9d:d504 with SMTP id c15-20020a25a28f000000b00a99de9dd504mr199425ybi.12.1679501817524;
        Wed, 22 Mar 2023 09:16:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350YtteuKOCzNuJqb5LScmZRd5TpQ+jRTLDacD8tyX6c859Ci1EUYI+EXZbH+wRd234cHezr9Xcc3IMawgL17xmY=
X-Received: by 2002:a25:a28f:0:b0:a99:de9d:d504 with SMTP id
 c15-20020a25a28f000000b00a99de9dd504mr199411ybi.12.1679501817257; Wed, 22 Mar
 2023 09:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230321183342.617114-1-aleksandr.mikhalitsyn@canonical.com>
 <20230321183342.617114-3-aleksandr.mikhalitsyn@canonical.com> <20230322153544.u7rfjijcpuheda6m@wittgenstein>
In-Reply-To: <20230322153544.u7rfjijcpuheda6m@wittgenstein>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 22 Mar 2023 17:16:46 +0100
Message-ID: <CAEivzxfaezv6eyrmoXU0rVqEYhz2hh-k0TSCJWdShY7Og2PakA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] net: core: add getsockopt SO_PEERPIDFD
To:     Christian Brauner <brauner@kernel.org>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 4:35=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, Mar 21, 2023 at 07:33:41PM +0100, Alexander Mikhalitsyn wrote:
> > Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> > This thing is direct analog of SO_PEERCRED which allows to get plain PI=
D.
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> > v2:
> >       According to review comments from Kuniyuki Iwashima and Christian=
 Brauner:
> >       - use pidfd_create(..) retval as a result
> >       - whitespace change
> > ---
> >  arch/alpha/include/uapi/asm/socket.h    |  1 +
> >  arch/mips/include/uapi/asm/socket.h     |  1 +
> >  arch/parisc/include/uapi/asm/socket.h   |  1 +
> >  arch/sparc/include/uapi/asm/socket.h    |  1 +
> >  include/uapi/asm-generic/socket.h       |  1 +
> >  net/core/sock.c                         | 21 +++++++++++++++++++++
> >  tools/include/uapi/asm-generic/socket.h |  1 +
> >  7 files changed, 27 insertions(+)
> >
> > diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/=
uapi/asm/socket.h
> > index ff310613ae64..e94f621903fe 100644
> > --- a/arch/alpha/include/uapi/asm/socket.h
> > +++ b/arch/alpha/include/uapi/asm/socket.h
> > @@ -138,6 +138,7 @@
> >  #define SO_RCVMARK           75
> >
> >  #define SO_PASSPIDFD         76
> > +#define SO_PEERPIDFD         77
> >
> >  #if !defined(__KERNEL__)
> >
> > diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/ua=
pi/asm/socket.h
> > index 762dcb80e4ec..60ebaed28a4c 100644
> > --- a/arch/mips/include/uapi/asm/socket.h
> > +++ b/arch/mips/include/uapi/asm/socket.h
> > @@ -149,6 +149,7 @@
> >  #define SO_RCVMARK           75
> >
> >  #define SO_PASSPIDFD         76
> > +#define SO_PEERPIDFD         77
> >
> >  #if !defined(__KERNEL__)
> >
> > diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/includ=
e/uapi/asm/socket.h
> > index df16a3e16d64..be264c2b1a11 100644
> > --- a/arch/parisc/include/uapi/asm/socket.h
> > +++ b/arch/parisc/include/uapi/asm/socket.h
> > @@ -130,6 +130,7 @@
> >  #define SO_RCVMARK           0x4049
> >
> >  #define SO_PASSPIDFD         0x404A
> > +#define SO_PEERPIDFD         0x404B
> >
> >  #if !defined(__KERNEL__)
> >
> > diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/=
uapi/asm/socket.h
> > index 6e2847804fea..682da3714686 100644
> > --- a/arch/sparc/include/uapi/asm/socket.h
> > +++ b/arch/sparc/include/uapi/asm/socket.h
> > @@ -131,6 +131,7 @@
> >  #define SO_RCVMARK               0x0054
> >
> >  #define SO_PASSPIDFD             0x0055
> > +#define SO_PEERPIDFD             0x0056
> >
> >  #if !defined(__KERNEL__)
> >
> > diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-gener=
ic/socket.h
> > index b76169fdb80b..8ce8a39a1e5f 100644
> > --- a/include/uapi/asm-generic/socket.h
> > +++ b/include/uapi/asm-generic/socket.h
> > @@ -133,6 +133,7 @@
> >  #define SO_RCVMARK           75
> >
> >  #define SO_PASSPIDFD         76
> > +#define SO_PEERPIDFD         77
> >
> >  #if !defined(__KERNEL__)
> >
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 3f974246ba3e..85c269ca9d8a 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1763,6 +1763,27 @@ int sk_getsockopt(struct sock *sk, int level, in=
t optname,
> >               goto lenout;
> >       }
> >
> > +     case SO_PEERPIDFD:
> > +     {
> > +             struct pid *peer_pid;
> > +             int pidfd;
> > +
> > +             if (len > sizeof(pidfd))
> > +                     len =3D sizeof(pidfd);
> > +
> > +             spin_lock(&sk->sk_peer_lock);
> > +             peer_pid =3D get_pid(sk->sk_peer_pid);
> > +             spin_unlock(&sk->sk_peer_lock);
> > +
> > +             pidfd =3D pidfd_create(peer_pid, 0);
> > +
> > +             put_pid(peer_pid);
> > +
> > +             if (copy_to_sockptr(optval, &pidfd, len))
> > +                     return -EFAULT;
>
> This leaks the pidfd. We could do:
>
>         if (copy_to_sockptr(optval, &pidfd, len)) {
>                 close_fd(pidfd);
>                 return -EFAULT;
>         }

Ah, my bad. Thanks for pointing this out!

>
> but it's a nasty anti-pattern to install the fd in the caller's fdtable
> and then close it again. So let's avoid it if we can. Since you can only
> set one socket option per setsockopt() sycall we should be able to
> reserve an fd and pidfd_file, do the stuff that might fail, and then
> call fd_install. So that would roughly be:
>
>         peer_pid =3D get_pid(sk->sk_peer_pid);
>         pidfd_file =3D pidfd_file_create(peer_pid, 0, &pidfd);
>         f (copy_to_sockptr(optval, &pidfd, len))
>                return -EFAULT;
>         goto lenout:
>
>         .
>         .
>         .
>
> lenout:
>         if (copy_to_sockptr(optlen, &len, sizeof(int)))
>                 return -EFAULT;
>
>         // Made it safely, install pidfd now.
>         fd_install(pidfd, pidfd_file)
>
> (See below for the associated api I'm going to publish independent of
> this as kernel/fork.c and fanotify both could use it.)
>
> But now, let's look at net/socket.c there's another wrinkle. So let's say=
 you
> have successfully installed the pidfd then it seems you can still fail la=
ter:
>
>         if (level =3D=3D SOL_SOCKET)
>                 err =3D sock_getsockopt(sock, level, optname, optval, opt=
len);
>         else if (unlikely(!sock->ops->getsockopt))
>                 err =3D -EOPNOTSUPP;
>         else
>                 err =3D sock->ops->getsockopt(sock, level, optname, optva=
l,
>                                             optlen);
>
>         if (!in_compat_syscall())
>                 err =3D BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, o=
ptname,
>                                                      optval, optlen, max_=
optlen,
>                                                      err);
>
> out_put:
>         fput_light(sock->file, fput_needed);
>         return err;
>
> If the bpf hook returns an error we've placed an fd into the caller's soc=
kopt
> buffer without their knowledge.

yes, so we need to postpone fd_install to the end of __sys_getsockopt.
I'll think about that.

>
> From 4fee16f0920308bee2531fd3b08484f607eb5830 Mon Sep 17 00:00:00 2001
> From: Christian Brauner <brauner@kernel.org>
> Date: Wed, 22 Mar 2023 15:59:02 +0100
> Subject: [PATCH 1/3] [HERE BE DRAGONS - DRAFT - __UNTESTED__] pid: add
>  pidfd_file_create()
>
> Reserve and fd and pidfile, do stuff that might fail, install fd when
> point of no return.
>
> [HERE BE DRAGONS - DRAFT - __UNTESTED__] pid: add pidfd_file_create()
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  include/linux/pid.h |  1 +
>  kernel/pid.c        | 45 +++++++++++++++++++++++++++++++++------------
>  2 files changed, 34 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/pid.h b/include/linux/pid.h
> index 343abf22092e..c486dbc4d7b6 100644
> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -80,6 +80,7 @@ extern struct pid *pidfd_pid(const struct file *file);
>  struct pid *pidfd_get_pid(unsigned int fd, unsigned int *flags);
>  struct task_struct *pidfd_get_task(int pidfd, unsigned int *flags);
>  int pidfd_create(struct pid *pid, unsigned int flags);
> +struct file *pidfd_file_create(struct pid *pid, unsigned int flags, int =
*pidfd);
>
>  static inline struct pid *get_pid(struct pid *pid)
>  {
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 3fbc5e46b721..8d0924f1dbf6 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -576,6 +576,32 @@ struct task_struct *pidfd_get_task(int pidfd, unsign=
ed int *flags)
>         return task;
>  }
>
> +struct file *pidfd_file_create(struct pid *pid, unsigned int flags, int =
*pidfd)
> +{
> +       int fd;
> +       struct file *pidfile;
> +
> +       if (!pid || !pid_has_task(pid, PIDTYPE_TGID))
> +               return ERR_PTR(-EINVAL);
> +
> +       if (flags & ~(O_NONBLOCK | O_RDWR | O_CLOEXEC))
> +               return ERR_PTR(-EINVAL);
> +
> +       fd =3D get_unused_fd_flags(O_RDWR | O_CLOEXEC);
> +       if (fd < 0)
> +               return ERR_PTR(fd);
> +
> +       pidfile =3D anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
> +                                    flags | O_RDWR | O_CLOEXEC);
> +       if (IS_ERR(pidfile)) {
> +               put_unused_fd(fd);
> +               return pidfile;
> +       }
> +       get_pid(pid); /* held by pidfile now */
> +       *pidfd =3D fd;
> +       return pidfile;
> +}
> +
>  /**
>   * pidfd_create() - Create a new pid file descriptor.
>   *
> @@ -594,20 +620,15 @@ struct task_struct *pidfd_get_task(int pidfd, unsig=
ned int *flags)
>   */
>  int pidfd_create(struct pid *pid, unsigned int flags)
>  {
> -       int fd;
> +       int pidfd;
> +       struct file *pidfile;
>
> -       if (!pid || !pid_has_task(pid, PIDTYPE_TGID))
> -               return -EINVAL;
> +       pidfile =3D pidfd_file_create(pid, flags, &pidfd);
> +       if (IS_ERR(pidfile))
> +               return PTR_ERR(pidfile);
>
> -       if (flags & ~(O_NONBLOCK | O_RDWR | O_CLOEXEC))
> -               return -EINVAL;
> -
> -       fd =3D anon_inode_getfd("[pidfd]", &pidfd_fops, get_pid(pid),
> -                             flags | O_RDWR | O_CLOEXEC);
> -       if (fd < 0)
> -               put_pid(pid);
> -
> -       return fd;
> +       fd_install(pidfd, pidfile);
> +       return pidfd;
>  }
>
>  /**
> --
> 2.34.1
>
> From c336f1c6cc39faa5aef4fbedd3c4f8eca51d8436 Mon Sep 17 00:00:00 2001
> From: Christian Brauner <brauner@kernel.org>
> Date: Wed, 22 Mar 2023 15:59:54 +0100
> Subject: [PATCH 2/3] [HERE BE DRAGONS - DRAFT - __UNTESTED__] fork: use
>  pidfd_file_create()
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  kernel/fork.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f68954d05e89..c8dc78ee0a74 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2296,20 +2296,11 @@ static __latent_entropy struct task_struct *copy_=
process(
>          * if the fd table isn't shared).
>          */
>         if (clone_flags & CLONE_PIDFD) {
> -               retval =3D get_unused_fd_flags(O_RDWR | O_CLOEXEC);
> -               if (retval < 0)
> -                       goto bad_fork_free_pid;
> -
> -               pidfd =3D retval;
> -
> -               pidfile =3D anon_inode_getfile("[pidfd]", &pidfd_fops, pi=
d,
> -                                             O_RDWR | O_CLOEXEC);
> +               pidfile =3D pidfd_file_create(pid, O_RDWR | O_CLOEXEC, &p=
idfd);
>                 if (IS_ERR(pidfile)) {
> -                       put_unused_fd(pidfd);
>                         retval =3D PTR_ERR(pidfile);
>                         goto bad_fork_free_pid;
>                 }
> -               get_pid(pid);   /* held by pidfile now */
>
>                 retval =3D put_user(pidfd, args->pidfd);
>                 if (retval)
> --
> 2.34.1
>
> From 0897f68fe06a8777d8ec600fdc719143f76095b1 Mon Sep 17 00:00:00 2001
> From: Christian Brauner <brauner@kernel.org>
> Date: Wed, 22 Mar 2023 16:02:50 +0100
> Subject: [PATCH 3/3] [HERE BE DRAGONS - DRAFT - __UNTESTED__] fanotify: u=
se
>  pidfd_file_create()
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/notify/fanotify/fanotify_user.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fano=
tify_user.c
> index 8f430bfad487..4a8db6b5f690 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -665,6 +665,7 @@ static ssize_t copy_event_to_user(struct fsnotify_gro=
up *group,
>         unsigned int pidfd_mode =3D info_mode & FAN_REPORT_PIDFD;
>         struct file *f =3D NULL;
>         int ret, pidfd =3D FAN_NOPIDFD, fd =3D FAN_NOFD;
> +       struct file *pidfd_file =3D NULL;
>
>         pr_debug("%s: group=3D%p event=3D%p\n", __func__, group, event);
>
> @@ -718,9 +719,11 @@ static ssize_t copy_event_to_user(struct fsnotify_gr=
oup *group,
>                     !pid_has_task(event->pid, PIDTYPE_TGID)) {
>                         pidfd =3D FAN_NOPIDFD;
>                 } else {
> -                       pidfd =3D pidfd_create(event->pid, 0);
> -                       if (pidfd < 0)
> +                       pidfd_file =3D pidfd_file_create(event->pid, 0, &=
pidfd);
> +                       if (IS_ERR(pidfd_file)) {
>                                 pidfd =3D FAN_EPIDFD;
> +                               pidfd_file =3D NULL;
> +                       }
>                 }
>         }
>
> @@ -750,6 +753,8 @@ static ssize_t copy_event_to_user(struct fsnotify_gro=
up *group,
>
>         if (f)
>                 fd_install(fd, f);
> +       if (pidfd_file)
> +               fd_install(pidfd, pidfd_file);
>
>         return metadata.event_len;
>
> @@ -759,8 +764,10 @@ static ssize_t copy_event_to_user(struct fsnotify_gr=
oup *group,
>                 fput(f);
>         }
>
> -       if (pidfd >=3D 0)
> -               close_fd(pidfd);
> +       if (pidfd >=3D 0) {
> +               put_unused_fd(pidfd);
> +               fput(pidfd_file);
> +       }
>
>         return ret;
>  }
> --
> 2.34.1
>
