Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83426E4F7C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDQRni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbjDQRne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:43:34 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF357293
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:43:32 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r9so6173518iot.6
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681753412; x=1684345412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuPqDXtYJhebviq0BQVIjMAo1butyf50CpUXaXZx7Dg=;
        b=nA6Tr3yE2n3b77oVbMwHXCjBkemTMHPbIUK+8Lg4s+gvrNfBU2h4AD4bIXR7Fhyt6D
         Iq5pw+U/IrigLqq24FYYtd1glzob5TjCmB1aUoV8K7pf3LoSFaoNFT9kgCwFZsBXjNzV
         65xJ/iuF1wRQ6pGETqLbF80EgrzDaAaLs3CbelP2Qt1QlDkN7kdySWy8dJN0kTxu62lv
         iNKNoH+A48ICo+ht0u/cHtjoprByBaaRlTOBiNaB9bNEykF0vld2lQvLqmx6yFgdAob1
         3GHWQNyh9nJq1v7SRMLnXbyVn9qMD56wHC22MsMCCFn1qFVRVMom4Y4z22Wrv+NOsfGz
         JJcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681753412; x=1684345412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EuPqDXtYJhebviq0BQVIjMAo1butyf50CpUXaXZx7Dg=;
        b=cr8zUpX6THgBNkpA86C8/Ja3voHu55b+XYQr4B1hoWO8Z2I9Ih4BOclGCNigBUCPP4
         hwmp5M6YUQ9JJUi+onu8TsRkImLMe7VJNlmR3T668D+Ju+5VlRU83p07U3/7vDL3Hl5v
         40ttMzDBq00nkmyQTNmsemS6u/ytbDhPs37r+T1Q/FRIguuwUpgSyMreK2JM2Ap6JusT
         bnbZR8ev/miwcvRLPZYj4OBx3VLDr2nVPpLz+KDmWJ7rDNwCx03hav5EhWHMMlKamYsD
         0v4VdjPk0QZlmJdgM7pAGYQaJ0wRlVz4bs96CHoEkEiEx4w7t5Y7RjYVnmQIM39D24/h
         Gs1w==
X-Gm-Message-State: AAQBX9eoArwdmb7szmvnROR05vL9lFuvUqVlpQmc6RhUT0yyPwoQJmA+
        1EWm4pcejYJOjxIWdcbr8BrJzdqk/hMwGHH7occSMQ==
X-Google-Smtp-Source: AKy350Zat+4b5P7I5NcVKvUB0bohvKa0btYkvsdXGsyQv8r7YvIrM4cTOYZFMtALOCr+DBdcSHjkZDpPCgHtmdZdbgk=
X-Received: by 2002:a02:95ce:0:b0:40f:9d2e:24ae with SMTP id
 b72-20020a0295ce000000b0040f9d2e24aemr3383379jai.0.1681753411679; Mon, 17 Apr
 2023 10:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-2-aleksandr.mikhalitsyn@canonical.com>
 <20230417-bahnanlagen-fixstern-bccf5afe6fa0@brauner> <CAEivzxcAeBPJYTVTN7cRik7AXo3y-Ox1yffPG2bvwxXsH2WWDg@mail.gmail.com>
 <20230417-irren-performanz-3c18de02e6e2@brauner>
In-Reply-To: <20230417-irren-performanz-3c18de02e6e2@brauner>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Apr 2023 19:43:19 +0200
Message-ID: <CANn89i+cBg24iEnXnx2x5AB40ZLf6g2ysbLENBW9mXWB8arbjw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
To:     Christian Brauner <brauner@kernel.org>
Cc:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 7:16=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Mon, Apr 17, 2023 at 06:01:16PM +0200, Aleksandr Mikhalitsyn wrote:
> > On Mon, Apr 17, 2023 at 5:18=E2=80=AFPM Christian Brauner <brauner@kern=
el.org> wrote:
> > >
> > > On Thu, Apr 13, 2023 at 03:33:52PM +0200, Alexander Mikhalitsyn wrote=
:
> > > > Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CRED=
ENTIALS,
> > > > but it contains pidfd instead of plain pid, which allows programmer=
s not
> > > > to care about PID reuse problem.
> > > >
> > > > Idea comes from UAPI kernel group:
> > > > https://uapi-group.org/kernel-features/
> > > >
> > > > Big thanks to Christian Brauner and Lennart Poettering for producti=
ve
> > > > discussions about this.
> > > >
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Eric Dumazet <edumazet@google.com>
> > > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > > Cc: Leon Romanovsky <leon@kernel.org>
> > > > Cc: David Ahern <dsahern@kernel.org>
> > > > Cc: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Kees Cook <keescook@chromium.org>
> > > > Cc: Christian Brauner <brauner@kernel.org>
> > > > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > Cc: Lennart Poettering <mzxreary@0pointer.de>
> > > > Cc: Luca Boccassi <bluca@debian.org>
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Cc: netdev@vger.kernel.org
> > > > Cc: linux-arch@vger.kernel.org
> > > > Tested-by: Luca Boccassi <bluca@debian.org>
> > > > Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonic=
al.com>
> > > > ---
> > > > v4:
> > > >       - fixed silent fd_install if writting of CMSG to the userspac=
e fails (pointed by Christian)
> > > > v2:
> > > >       According to review comments from Kuniyuki Iwashima and Chris=
tian Brauner:
> > > >       - use pidfd_create(..) retval as a result
> > > >       - whitespace change
> > > > ---
> > > >  arch/alpha/include/uapi/asm/socket.h    |  2 ++
> > > >  arch/mips/include/uapi/asm/socket.h     |  2 ++
> > > >  arch/parisc/include/uapi/asm/socket.h   |  2 ++
> > > >  arch/sparc/include/uapi/asm/socket.h    |  2 ++
> > > >  include/linux/net.h                     |  1 +
> > > >  include/linux/socket.h                  |  1 +
> > > >  include/net/scm.h                       | 39 +++++++++++++++++++++=
++--
> > > >  include/uapi/asm-generic/socket.h       |  2 ++
> > > >  net/core/sock.c                         | 11 +++++++
> > > >  net/mptcp/sockopt.c                     |  1 +
> > > >  net/unix/af_unix.c                      | 18 ++++++++----
> > > >  tools/include/uapi/asm-generic/socket.h |  2 ++
> > > >  12 files changed, 76 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/incl=
ude/uapi/asm/socket.h
> > > > index 739891b94136..ff310613ae64 100644
> > > > --- a/arch/alpha/include/uapi/asm/socket.h
> > > > +++ b/arch/alpha/include/uapi/asm/socket.h
> > > > @@ -137,6 +137,8 @@
> > > >
> > > >  #define SO_RCVMARK           75
> > > >
> > > > +#define SO_PASSPIDFD         76
> > > > +
> > > >  #if !defined(__KERNEL__)
> > > >
> > > >  #if __BITS_PER_LONG =3D=3D 64
> > > > diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/includ=
e/uapi/asm/socket.h
> > > > index 18f3d95ecfec..762dcb80e4ec 100644
> > > > --- a/arch/mips/include/uapi/asm/socket.h
> > > > +++ b/arch/mips/include/uapi/asm/socket.h
> > > > @@ -148,6 +148,8 @@
> > > >
> > > >  #define SO_RCVMARK           75
> > > >
> > > > +#define SO_PASSPIDFD         76
> > > > +
> > > >  #if !defined(__KERNEL__)
> > > >
> > > >  #if __BITS_PER_LONG =3D=3D 64
> > > > diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/in=
clude/uapi/asm/socket.h
> > > > index f486d3dfb6bb..df16a3e16d64 100644
> > > > --- a/arch/parisc/include/uapi/asm/socket.h
> > > > +++ b/arch/parisc/include/uapi/asm/socket.h
> > > > @@ -129,6 +129,8 @@
> > > >
> > > >  #define SO_RCVMARK           0x4049
> > > >
> > > > +#define SO_PASSPIDFD         0x404A
> > > > +
> > > >  #if !defined(__KERNEL__)
> > > >
> > > >  #if __BITS_PER_LONG =3D=3D 64
> > > > diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/incl=
ude/uapi/asm/socket.h
> > > > index 2fda57a3ea86..6e2847804fea 100644
> > > > --- a/arch/sparc/include/uapi/asm/socket.h
> > > > +++ b/arch/sparc/include/uapi/asm/socket.h
> > > > @@ -130,6 +130,8 @@
> > > >
> > > >  #define SO_RCVMARK               0x0054
> > > >
> > > > +#define SO_PASSPIDFD             0x0055
> > > > +
> > > >  #if !defined(__KERNEL__)
> > > >
> > > >
> > > > diff --git a/include/linux/net.h b/include/linux/net.h
> > > > index b73ad8e3c212..c234dfbe7a30 100644
> > > > --- a/include/linux/net.h
> > > > +++ b/include/linux/net.h
> > > > @@ -43,6 +43,7 @@ struct net;
> > > >  #define SOCK_PASSSEC         4
> > > >  #define SOCK_SUPPORT_ZC              5
> > > >  #define SOCK_CUSTOM_SOCKOPT  6
> > > > +#define SOCK_PASSPIDFD               7
> > > >
> > > >  #ifndef ARCH_HAS_SOCKET_TYPES
> > > >  /**
> > > > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > > > index 13c3a237b9c9..6bf90f251910 100644
> > > > --- a/include/linux/socket.h
> > > > +++ b/include/linux/socket.h
> > > > @@ -177,6 +177,7 @@ static inline size_t msg_data_left(struct msghd=
r *msg)
> > > >  #define      SCM_RIGHTS      0x01            /* rw: access rights =
(array of int) */
> > > >  #define SCM_CREDENTIALS 0x02         /* rw: struct ucred          =
   */
> > > >  #define SCM_SECURITY 0x03            /* rw: security label        =
   */
> > > > +#define SCM_PIDFD    0x04            /* ro: pidfd (int)           =
   */
> > > >
> > > >  struct ucred {
> > > >       __u32   pid;
> > > > diff --git a/include/net/scm.h b/include/net/scm.h
> > > > index 585adc1346bd..c67f765a165b 100644
> > > > --- a/include/net/scm.h
> > > > +++ b/include/net/scm.h
> > > > @@ -120,12 +120,44 @@ static inline bool scm_has_secdata(struct soc=
ket *sock)
> > > >  }
> > > >  #endif /* CONFIG_SECURITY_NETWORK */
> > > >
> > > > +static __inline__ void scm_pidfd_recv(struct msghdr *msg, struct s=
cm_cookie *scm)
> > > > +{
> > > > +     struct file *pidfd_file =3D NULL;
> > > > +     int pidfd;
> > > > +
> > > > +     /*
> > > > +      * put_cmsg() doesn't return an error if CMSG is truncated,
> > > > +      * that's why we need to opencode these checks here.
> > > > +      */
> > > > +     if ((msg->msg_controllen <=3D sizeof(struct cmsghdr)) ||
> > > > +         (msg->msg_controllen - sizeof(struct cmsghdr)) < sizeof(i=
nt)) {
> > > > +             msg->msg_flags |=3D MSG_CTRUNC;
> > > > +             return;
> > >
> > > Hm, curious about this: We mark the message as truncated for SCM_PIDF=
D
> > > but if the same conditions were to apply for SCM_PASSCRED we don't ma=
rk
> > > the message as truncated. Am I reading this correct? And is so, you
> > > please briefly explain this difference?
> >
> > Hi, Christian!
> >
> > For SCM_CREDENTIALS we mark it too. Inside the put_cmsg function:
> > https://github.com/torvalds/linux/blob/6a8f57ae2eb07ab39a6f0ccad60c7607=
43051026/net/core/scm.c#L225
> >
> > The reason why I'm open-coding these checks is that I want to know
> > that the message
> > doesn't fit into the userspace buffer before doing pidfd_prepare and
> > other stuff and because
> > put_cmsg is not returning an error when message doesn't fit in the
> > userspace buffer and
> > we won't be able to properly do pidfd cleanup (put struct pid and fd in=
dex).
> >
> > >
> > > > +     }
> > > > +
> > > > +     WARN_ON_ONCE(!scm->pid);
> > > > +     pidfd =3D pidfd_prepare(scm->pid, 0, &pidfd_file);
> > > > +
> > > > +     if (put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd)=
) {
> > >
> > > If the put_cmsg() of the pidfd fails userspace needs to be able to
> > > detect this. Otherwise they can't distinguish between the SCM_PIDFD
> > > value being zero because the put_cmsg() failed or put_cmsg() succeede=
d
> > > and the allocated fd nr was 0.
> >
> > If pidfd_prepare fails then userspace will receive SCM_PIDFD message
> > with negative pidfd value.
>
> So we discussed this a bit offline and I think there's still an issue.
> If put_cmsg() fails
>
>           if (msg->msg_control_is_user) {
>                   struct cmsghdr __user *cm =3D msg->msg_control_user;
>
>                   check_object_size(data, cmlen - sizeof(*cm), true);
>
>                   if (!user_write_access_begin(cm, cmlen))
>                           goto efault;
>
>                   // This succeeds so cm->cmsg_len =3D=3D sizeof(int)
>                   unsafe_put_user(cmlen, &cm->cmsg_len, efault_end);
>
>                   // This succeeds so cm->cmsg_level =3D=3D SOL_SOCKET
>                   unsafe_put_user(level, &cm->cmsg_level, efault_end);
>
>                   // This succeeds so cm->cmsg_type =3D=3D SCM_PIDFD
>                   unsafe_put_user(type, &cm->cmsg_type, efault_end);
>
>                   // This fails and leaves all bits set to 0
>                   unsafe_copy_to_user(CMSG_USER_DATA(cm), data,
>                                       cmlen - sizeof(*cm), efault_end);
>                   user_write_access_end();
>
> so now we hit
>
>           if (put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd)) =
{
>                   if (pidfd_file) {
>                           put_unused_fd(pidfd);
>                           fput(pidfd_file);
>                   }
>
>                   return;
>           }
>
> and return early. Afaict, userspace would now receive:
>
>         if (cmsg && cmsg->cmsg_len =3D=3D CMSG_LEN(sizeof(int)) &&
>             cmsg->cmsg_level =3D=3D SOL_SOCKET &&
>             cmsg->cmsg_type =3D=3D SCM_PIDFD) {
>                 memcpy(&pidfd, CMSG_DATA(cmsg), sizeof(int));
>
>                 // pidfd is now 0 which is a valid fd number
>                 // it'll likely refer to /dev/stdin or whatever and so
>                 // will fail or, worst case, 0 refers to another pidfd :)
>                 pidfd_send_signal(pidfd, SIGKILL);
>
> so we need to address this. So one way I think that would solve this is:
>
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 3cd7dd377e53..d1f4cd135c5a 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -236,9 +236,9 @@ int put_cmsg(struct msghdr * msg, int level, int type=
, int len, void *data)
>
>                 unsafe_put_user(cmlen, &cm->cmsg_len, efault_end);
>                 unsafe_put_user(level, &cm->cmsg_level, efault_end);
> -               unsafe_put_user(type, &cm->cmsg_type, efault_end);
>                 unsafe_copy_to_user(CMSG_USER_DATA(cm), data,
>                                     cmlen - sizeof(*cm), efault_end);
> +               unsafe_put_user(type, &cm->cmsg_type, efault_end);
>                 user_write_access_end();
>         } else {
>                 struct cmsghdr *cm =3D msg->msg_control;
>
> such that we only copy cm->cmsg_type after we transfered the data.

This looks wrong to me.

if put_cmsg() returns -EFAULT, then msg->msg_control and
msg->msg_controllen were not changed.

So the user application should not attempt to read this part of the
control buffer, this could contain garbage.
