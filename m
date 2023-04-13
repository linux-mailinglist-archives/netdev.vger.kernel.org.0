Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F6B6E0F2D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjDMNte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjDMNta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:49:30 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2D03584
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:49:29 -0700 (PDT)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com [209.85.128.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A39CB3F443
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681393201;
        bh=Fwm2zA4Lu+pnk2wfvmdsIMzskA4Hu3SYjIKwChZpmug=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=AWQY2V1XaMZhW8MzHMHoQ2wL1+urxuW4IcripYmhfVi+9HleXuaSpmjnD7zoxUhy3
         iyzP/W5gCwxLS3sP3JnxfAS2Ytw+Lp0fMNv5H31L7VSn2tg3oxS0Y+jMYjYjywkp+C
         0BDZ2Uvk3E6R7LbYOREocWWvIXsslaTJjcRnSCWA/jfo/vODqywKDJMqjYu2zq8OIp
         Wp54ZzOafPN/B07V8Ut2JPvO+JCj4zoKX2PziLc8aTWn3et/u1emPYjjbi8pEZnaf0
         KL2OrcqUpM7iWJniBKOMYGDLT6EDb4srr/gaq3Ofl/OTD8SGbGz/C93Gff/SUZMPkU
         x/YTgGuZomnfA==
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-54fd5d0ad7cso8016407b3.1
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 06:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681393200; x=1683985200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fwm2zA4Lu+pnk2wfvmdsIMzskA4Hu3SYjIKwChZpmug=;
        b=H02pO5bbkgOodQrz34Msx0OW2wJrtqNXxj1DO0BlQt1vRKiXHsULhQhH9PhxWez4h+
         bgMYJ90AefNc7fLl9QifvJEAQexXsKVmkkqW61tclDYBF7zEmWbTTaxiMlz/URc1IQqF
         R1/MhDRjx6VIK+VbEPFaBb71ns+koRLktzQlZo3K249QrHCwr2+0GvabMAjlDcBtzFuC
         3NWgysSCkhc4zUnEIYPaLMoIO5kGfKVSp6oBYJ6S1Gg4W9f/EyK7Cp8vcxWSo8+r+4DL
         hAHkylBnnvvGRg8wO3+FQbC0rZ9MQOfqwcOJqJK6lEO3lNgPZAJ8gPTcvg+VROstHS/j
         lK+g==
X-Gm-Message-State: AAQBX9eblU2g8oX1rV9q09r/5Hws6VHWZqfV62c63sZDWlHNwXHeEAER
        L3Y25y7LDKovd3xV7MxYqai0TD2M87Cy2AgXZedCKcrpF+s53A+KPqCVfcgiE4uW3xUIEu+Togl
        Aq5zQl8bsBH6CleiJ8FuvgKWGK96wCQ6lt1x7GTQotSOEOfCnlA==
X-Received: by 2002:a81:ae0b:0:b0:54f:8f2e:a03 with SMTP id m11-20020a81ae0b000000b0054f8f2e0a03mr1459789ywh.1.1681393200538;
        Thu, 13 Apr 2023 06:40:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350bWBZ+Oe+dqnl0WOzPCmKCiFgGY9gArAk6IN/SlCoHxVcrE5UC1Wg715sEPuLSw04N9G3npVyH3kp0ZgILmuV4=
X-Received: by 2002:a81:ae0b:0:b0:54f:8f2e:a03 with SMTP id
 m11-20020a81ae0b000000b0054f8f2e0a03mr1459771ywh.1.1681393200269; Thu, 13 Apr
 2023 06:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230411104231.160837-1-aleksandr.mikhalitsyn@canonical.com>
 <20230411104231.160837-2-aleksandr.mikhalitsyn@canonical.com> <20230411-umarmen-mulden-c34abb9b2511@brauner>
In-Reply-To: <20230411-umarmen-mulden-c34abb9b2511@brauner>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 13 Apr 2023 15:39:49 +0200
Message-ID: <CAEivzxfHjSPGu9HJP0jKa0i34vUVbaMqkGks+=0FzT7Wq_so8A@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/4] scm: add SO_PASSPIDFD and SCM_PIDFD
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
        Luca Boccassi <bluca@debian.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed in -v4

https://lore.kernel.org/netdev/20230413133355.350571-2-aleksandr.mikhalitsy=
n@canonical.com/T/#u

Kind regards,
Alex


On Tue, Apr 11, 2023 at 5:37=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Tue, Apr 11, 2023 at 12:42:28PM +0200, Alexander Mikhalitsyn wrote:
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
> >  include/net/scm.h                       | 14 ++++++++++++--
> >  include/uapi/asm-generic/socket.h       |  2 ++
> >  net/core/sock.c                         | 11 +++++++++++
> >  net/mptcp/sockopt.c                     |  1 +
> >  net/unix/af_unix.c                      | 18 +++++++++++++-----
> >  tools/include/uapi/asm-generic/socket.h |  2 ++
> >  12 files changed, 51 insertions(+), 7 deletions(-)
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
> > index 585adc1346bd..0c717ae9c8db 100644
> > --- a/include/net/scm.h
> > +++ b/include/net/scm.h
> > @@ -124,8 +124,9 @@ static __inline__ void scm_recv(struct socket *sock=
, struct msghdr *msg,
> >                               struct scm_cookie *scm, int flags)
> >  {
> >       if (!msg->msg_control) {
> > -             if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> > -                 scm_has_secdata(sock))
> > +             if (test_bit(SOCK_PASSCRED, &sock->flags) ||
> > +                 test_bit(SOCK_PASSPIDFD, &sock->flags) ||
> > +                 scm->fp || scm_has_secdata(sock))
> >                       msg->msg_flags |=3D MSG_CTRUNC;
> >               scm_destroy(scm);
> >               return;
> > @@ -141,6 +142,15 @@ static __inline__ void scm_recv(struct socket *soc=
k, struct msghdr *msg,
> >               put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds)=
, &ucreds);
> >       }
> >
> > +     if (test_bit(SOCK_PASSPIDFD, &sock->flags)) {
> > +             int pidfd;
> > +
> > +             WARN_ON_ONCE(!scm->pid);
> > +             pidfd =3D pidfd_create(scm->pid, 0);
> > +
> > +             put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd)=
;
>
> I know you already mentioned that you accidently missed to change this
> to not leak an fd. But just so we keep track of it see the comment to v2
> https://lore.kernel.org/netdev/20230322154817.c6qasnixow452e6x@wittgenste=
in/#t
