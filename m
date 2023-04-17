Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0252A6E4DE3
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjDQQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDQQBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:01:36 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18696A4F
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:01:33 -0700 (PDT)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8C7BF3F22C
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 16:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681747290;
        bh=/kB8PTdZp9FCy2VesM7GryZxZuuzN7J3d6Cztc1s4KA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=T/4zdseNBXTYpSBKmUcqG0cs422dniSwSu1YySl+uQ5Vrt6bW192I+CK0ioN6pZ/o
         LbVL0ADkUVO3Dk714Sol9RaWYnKCcYEUPw+VzuFhvQi6DgFSvv9qkwZSnz31yVi5gL
         8Pz8Sr/7wHDw40IDjUcvQAFoPu5ZbAmw3mc40UP959esoho1CiViS8l97TOhhtoxCL
         d9z71A1lLmgPrn99ky8KcOskhvcCa/BWUBHDAbgPu596aDy4gdeA79mVD6Z8+bKXGz
         iIY5WSHfuHiYYCAhxfVYcdNS6O5VYu2MPZyZ4/Fv8NthExv6K2zVQ4lyCkA26Usfum
         z1vPt5AlF/bHg==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-54fde069e4aso86773827b3.3
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681747288; x=1684339288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/kB8PTdZp9FCy2VesM7GryZxZuuzN7J3d6Cztc1s4KA=;
        b=L0rjrV7dwMSeiJhgcwzrky+yIUoVJkp4j8dF5ILKk/vDPJ/DAKduVeRzjg+/tQKE9P
         lqJzWZPQKHG3WEAcqRf95fG/dHxxWMJzL+ThxIJz8VPz3GBy8BBL9BZbSRjydmDUPs33
         OJBJDHnnD/KuhE9H/FLtglNlKadL6ukE9c1zsfcm0XSmXdS/Bc7xJ4CWbpqijN/gnC/J
         FKW9FTPWW1TVEAeiAuSBs3OOewAL7QlbHa2aI7q1IG6SdjUGn4lHSGqORm2JNUzYQlgr
         1o9q3qCfVFsoZFeCw/pzOIJ/pi8TeK6N0mbZAh3Y2vWSk8bSgUlcY7jgymtB3DRNAxYR
         vMYQ==
X-Gm-Message-State: AAQBX9dzMm7Lgoob06OXc4mgsgErrgYMC6rwlfZALjB03muzVm14Mwvg
        wOLf6SVD40TFEf4m4djWXZIHorfuPsQ4/SY0vP3x/wRdpmu4h9qsMLqPBWHwP5JYNUQlmYGoXBP
        Hh9gI3IUuNvaZtzHTGrKI2BiMmpiQe47jnUscC2THFM/tFOuhtA==
X-Received: by 2002:a25:d707:0:b0:b8f:578c:4e3a with SMTP id o7-20020a25d707000000b00b8f578c4e3amr7482317ybg.12.1681747288405;
        Mon, 17 Apr 2023 09:01:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350aN6nAZhn2Ad/1ZDvT36ltWXPPp4aptbjJl93RW0dgPSZtLll5a7js64JbalQnxM5Us4nwbubY2yMoCh0CWkeA=
X-Received: by 2002:a25:d707:0:b0:b8f:578c:4e3a with SMTP id
 o7-20020a25d707000000b00b8f578c4e3amr7482297ybg.12.1681747287984; Mon, 17 Apr
 2023 09:01:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230413133355.350571-1-aleksandr.mikhalitsyn@canonical.com>
 <20230413133355.350571-2-aleksandr.mikhalitsyn@canonical.com> <20230417-bahnanlagen-fixstern-bccf5afe6fa0@brauner>
In-Reply-To: <20230417-bahnanlagen-fixstern-bccf5afe6fa0@brauner>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Mon, 17 Apr 2023 18:01:16 +0200
Message-ID: <CAEivzxcAeBPJYTVTN7cRik7AXo3y-Ox1yffPG2bvwxXsH2WWDg@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
To:     Christian Brauner <brauner@kernel.org>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, daniel@iogearbox.net,
        Eric Dumazet <edumazet@google.com>,
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 5:18=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Apr 13, 2023 at 03:33:52PM +0200, Alexander Mikhalitsyn wrote:
> > Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTI=
ALS,
> > but it contains pidfd instead of plain pid, which allows programmers no=
t
> > to care about PID reuse problem.
> >
> > Idea comes from UAPI kernel group:
> > https://uapi-group.org/kernel-features/
> >
> > Big thanks to Christian Brauner and Lennart Poettering for productive
> > discussions about this.
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
> > Cc: Luca Boccassi <bluca@debian.org>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Tested-by: Luca Boccassi <bluca@debian.org>
> > Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> > v4:
> >       - fixed silent fd_install if writting of CMSG to the userspace fa=
ils (pointed by Christian)
> > v2:
> >       According to review comments from Kuniyuki Iwashima and Christian=
 Brauner:
> >       - use pidfd_create(..) retval as a result
> >       - whitespace change
> > ---
> >  arch/alpha/include/uapi/asm/socket.h    |  2 ++
> >  arch/mips/include/uapi/asm/socket.h     |  2 ++
> >  arch/parisc/include/uapi/asm/socket.h   |  2 ++
> >  arch/sparc/include/uapi/asm/socket.h    |  2 ++
> >  include/linux/net.h                     |  1 +
> >  include/linux/socket.h                  |  1 +
> >  include/net/scm.h                       | 39 +++++++++++++++++++++++--
> >  include/uapi/asm-generic/socket.h       |  2 ++
> >  net/core/sock.c                         | 11 +++++++
> >  net/mptcp/sockopt.c                     |  1 +
> >  net/unix/af_unix.c                      | 18 ++++++++----
> >  tools/include/uapi/asm-generic/socket.h |  2 ++
> >  12 files changed, 76 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/=
uapi/asm/socket.h
> > index 739891b94136..ff310613ae64 100644
> > --- a/arch/alpha/include/uapi/asm/socket.h
> > +++ b/arch/alpha/include/uapi/asm/socket.h
> > @@ -137,6 +137,8 @@
> >
> >  #define SO_RCVMARK           75
> >
> > +#define SO_PASSPIDFD         76
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64
> > diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/ua=
pi/asm/socket.h
> > index 18f3d95ecfec..762dcb80e4ec 100644
> > --- a/arch/mips/include/uapi/asm/socket.h
> > +++ b/arch/mips/include/uapi/asm/socket.h
> > @@ -148,6 +148,8 @@
> >
> >  #define SO_RCVMARK           75
> >
> > +#define SO_PASSPIDFD         76
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64
> > diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/includ=
e/uapi/asm/socket.h
> > index f486d3dfb6bb..df16a3e16d64 100644
> > --- a/arch/parisc/include/uapi/asm/socket.h
> > +++ b/arch/parisc/include/uapi/asm/socket.h
> > @@ -129,6 +129,8 @@
> >
> >  #define SO_RCVMARK           0x4049
> >
> > +#define SO_PASSPIDFD         0x404A
> > +
> >  #if !defined(__KERNEL__)
> >
> >  #if __BITS_PER_LONG =3D=3D 64
> > diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/=
uapi/asm/socket.h
> > index 2fda57a3ea86..6e2847804fea 100644
> > --- a/arch/sparc/include/uapi/asm/socket.h
> > +++ b/arch/sparc/include/uapi/asm/socket.h
> > @@ -130,6 +130,8 @@
> >
> >  #define SO_RCVMARK               0x0054
> >
> > +#define SO_PASSPIDFD             0x0055
> > +
> >  #if !defined(__KERNEL__)
> >
> >
> > diff --git a/include/linux/net.h b/include/linux/net.h
> > index b73ad8e3c212..c234dfbe7a30 100644
> > --- a/include/linux/net.h
> > +++ b/include/linux/net.h
> > @@ -43,6 +43,7 @@ struct net;
> >  #define SOCK_PASSSEC         4
> >  #define SOCK_SUPPORT_ZC              5
> >  #define SOCK_CUSTOM_SOCKOPT  6
> > +#define SOCK_PASSPIDFD               7
> >
> >  #ifndef ARCH_HAS_SOCKET_TYPES
> >  /**
> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index 13c3a237b9c9..6bf90f251910 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -177,6 +177,7 @@ static inline size_t msg_data_left(struct msghdr *m=
sg)
> >  #define      SCM_RIGHTS      0x01            /* rw: access rights (arr=
ay of int) */
> >  #define SCM_CREDENTIALS 0x02         /* rw: struct ucred             *=
/
> >  #define SCM_SECURITY 0x03            /* rw: security label           *=
/
> > +#define SCM_PIDFD    0x04            /* ro: pidfd (int)              *=
/
> >
> >  struct ucred {
> >       __u32   pid;
> > diff --git a/include/net/scm.h b/include/net/scm.h
> > index 585adc1346bd..c67f765a165b 100644
> > --- a/include/net/scm.h
> > +++ b/include/net/scm.h
> > @@ -120,12 +120,44 @@ static inline bool scm_has_secdata(struct socket =
*sock)
> >  }
> >  #endif /* CONFIG_SECURITY_NETWORK */
> >
> > +static __inline__ void scm_pidfd_recv(struct msghdr *msg, struct scm_c=
ookie *scm)
> > +{
> > +     struct file *pidfd_file =3D NULL;
> > +     int pidfd;
> > +
> > +     /*
> > +      * put_cmsg() doesn't return an error if CMSG is truncated,
> > +      * that's why we need to opencode these checks here.
> > +      */
> > +     if ((msg->msg_controllen <=3D sizeof(struct cmsghdr)) ||
> > +         (msg->msg_controllen - sizeof(struct cmsghdr)) < sizeof(int))=
 {
> > +             msg->msg_flags |=3D MSG_CTRUNC;
> > +             return;
>
> Hm, curious about this: We mark the message as truncated for SCM_PIDFD
> but if the same conditions were to apply for SCM_PASSCRED we don't mark
> the message as truncated. Am I reading this correct? And is so, you
> please briefly explain this difference?

Hi, Christian!

For SCM_CREDENTIALS we mark it too. Inside the put_cmsg function:
https://github.com/torvalds/linux/blob/6a8f57ae2eb07ab39a6f0ccad60c76074305=
1026/net/core/scm.c#L225

The reason why I'm open-coding these checks is that I want to know
that the message
doesn't fit into the userspace buffer before doing pidfd_prepare and
other stuff and because
put_cmsg is not returning an error when message doesn't fit in the
userspace buffer and
we won't be able to properly do pidfd cleanup (put struct pid and fd index)=
.

>
> > +     }
> > +
> > +     WARN_ON_ONCE(!scm->pid);
> > +     pidfd =3D pidfd_prepare(scm->pid, 0, &pidfd_file);
> > +
> > +     if (put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd)) {
>
> If the put_cmsg() of the pidfd fails userspace needs to be able to
> detect this. Otherwise they can't distinguish between the SCM_PIDFD
> value being zero because the put_cmsg() failed or put_cmsg() succeeded
> and the allocated fd nr was 0.

If pidfd_prepare fails then userspace will receive SCM_PIDFD message
with negative pidfd value.

>
> Looking at put_cmsg() it looks to me that userspace will receive a
> SCM_PIDFD message only if the put_cmsg() is completely successful. IIUC,
> then this change is fine.

Kind regards,
Alex
