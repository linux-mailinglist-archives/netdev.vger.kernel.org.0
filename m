Return-Path: <netdev+bounces-1593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D744C6FE682
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C77831C20DF8
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 650461E505;
	Wed, 10 May 2023 21:58:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549AD21CDF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:58:18 +0000 (UTC)
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8725910FF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:58:16 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-517ab9a4a13so7035279a12.1
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683755896; x=1686347896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3wULuI7vE90rEZGHqkXAEPCnr2L7cEtAQhbPdWNS9Q4=;
        b=w10BsZzNmpOZcByEOTWbcUf2Aks20U0Hwts/18pOJ/l3rUl5DLetI32fHjJuvE5Kz0
         bLbzzj7LzBwAVlYyXOjARD+KlA7mS9YQ75tv2DL3udb/yBdNrKtsm/zzQkKqXoj3UEAy
         oZYaI3GFcReaP09yRocM5sa5qOyfvw//XHyugOkEajzScXXuENYwsZsdPpctw5stAIPI
         G40UT7FLiTvMPjBkJkncb51qorp7/tpHhR6C0mwxvTb7WMuy+3uzV1ZTHOauI55HIvFt
         dJPe/+49q0TiLv//78njFyiO3ksKWHmSGNDs+WOOSTy2lLiDv+8YNB48Xbfj9Vh32A7b
         AB8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683755896; x=1686347896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3wULuI7vE90rEZGHqkXAEPCnr2L7cEtAQhbPdWNS9Q4=;
        b=GzzcC0QoMMFf+kOlkNQKQ/Q5fYAN0yoOGSEvaZqs89kHuqFjJS+wrPMZ9XRCmmP5CR
         yQ5mF1xkDxTxUAwThLKlBrq1CwOkOMePdUH2d9WlkpO1uDq2aR0pBAgFpVFmaNrMf3Of
         wWQCS00pI7uSgRvw0Jrpst9TQzfOiD4GxpcTuVrl/n+mjrf6xYhNczFUyojpveRCMpLZ
         9iegSoaHDk1CZmrFGbjeIT6fr3X+BBlIQN+tJdOxtofFq01c9SLrG/hQKsC5i9pEqK1b
         XTr16SrGMVHYiWY/L+wnl0ubU+R//oMh18Ybkh2GX2bd0YoKNhr+6UBMhyXdG0I2AMSG
         ECnQ==
X-Gm-Message-State: AC+VfDzK8TUhiWTc5/BZzZf3Tt05lH3hMYZwZlMZ+UlOupn80nEYVWSY
	o2QVXV0uwvPMzZaHBSFWE+mF2JxshfbL+rlNtMlzEQ==
X-Google-Smtp-Source: ACHHUZ6HKvxannQHa1uGj6p3nB11KdAuhdA0umN1tSOxdif9EQqPJy+EMDVNufLFBYZg0F/5EZzs2fnp/mlJYaF0H+s=
X-Received: by 2002:a17:90b:3142:b0:246:f8d7:3083 with SMTP id
 ip2-20020a17090b314200b00246f8d73083mr18757743pjb.16.1683755895931; Wed, 10
 May 2023 14:58:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510152216.1392682-1-aleksandr.mikhalitsyn@canonical.com>
 <CAKH8qBuAoobsVP2Q5KN06fZ2NM3_aMwT7Y2OoKwS4Cf=cv3ZGg@mail.gmail.com> <CAEivzxc3hzqMROfCgshD6qW3=NErpF6LWXFGjoBhPNNzEZ3kDg@mail.gmail.com>
In-Reply-To: <CAEivzxc3hzqMROfCgshD6qW3=NErpF6LWXFGjoBhPNNzEZ3kDg@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Wed, 10 May 2023 14:58:04 -0700
Message-ID: <CAKH8qBvp3iNPHrus3NpgwN1JCkSxzTTi3G3WoAR2LKwX1-QzhQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: core: add SOL_SOCKET filter for bpf
 getsockopt hook
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 2:41=E2=80=AFPM Aleksandr Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> On Wed, May 10, 2023 at 11:31=E2=80=AFPM Stanislav Fomichev <sdf@google.c=
om> wrote:
> >
> > On Wed, May 10, 2023 at 8:23=E2=80=AFAM Alexander Mikhalitsyn
> > <aleksandr.mikhalitsyn@canonical.com> wrote:
> > >
> > > We have per struct proto ->bpf_bypass_getsockopt callback
> > > to filter out bpf socket cgroup getsockopt hook from being called.
> > >
> > > It seems worthwhile to add analogical helper for SOL_SOCKET
> > > level socket options. First user will be SO_PEERPIDFD.
> > >
> > > This patch was born as a result of discussion around a new SCM_PIDFD =
interface:
> > > https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhali=
tsyn@canonical.com/
> > >
> > > Cc: Alexei Starovoitov <ast@kernel.org>
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: Christian Brauner <brauner@kernel.org>
> > > Cc: Stanislav Fomichev <sdf@google.com>
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Eric Dumazet <edumazet@google.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Paolo Abeni <pabeni@redhat.com>
> > > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: netdev@vger.kernel.org
> > > Cc: bpf@vger.kernel.org
> > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical=
.com>
> > > ---
> > >  include/linux/bpf-cgroup.h | 8 +++++---
> > >  include/net/sock.h         | 1 +
> > >  net/core/sock.c            | 5 +++++
> > >  3 files changed, 11 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > > index 57e9e109257e..97d8a49b35bf 100644
> > > --- a/include/linux/bpf-cgroup.h
> > > +++ b/include/linux/bpf-cgroup.h
> > > @@ -387,10 +387,12 @@ static inline bool cgroup_bpf_sock_enabled(stru=
ct sock *sk,
> > >         int __ret =3D retval;                                        =
            \
> > >         if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT) &&                 =
          \
> > >             cgroup_bpf_sock_enabled(sock, CGROUP_GETSOCKOPT))        =
          \
> > > -               if (!(sock)->sk_prot->bpf_bypass_getsockopt ||       =
          \
> > > -                   !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass=
_getsockopt, \
> > > +               if (((level !=3D SOL_SOCKET) ||                      =
            \
> > > +                    !sock_bpf_bypass_getsockopt(level, optname)) && =
          \
> > > +                   (!(sock)->sk_prot->bpf_bypass_getsockopt ||      =
          \
> >
> > Any reason we are not putting this into bpf_bypass_getsockopt for
> > af_unix struct proto? SO_PEERPIDFD seems relevant only for af_unix?
>
> Yes, that should work perfectly well. The reason why I'm going this
> way is that we are
> declaring all SOL_SOCKET-level options in the net/core/sock.c which is
> not specific to any address family.
> It seems reasonable to have a way to filter out getsockopt for these
> options too.
>
> But I'm not insisting on that way.

Yeah, let's move it into af_unix struct proto for now. That should
avoid adding extra conditionals for a few places that care about
performance (tcp zerocopy fastpath).
If we'd ever need to filter out generic SOL_SOCKET level options that
apply for all sockets, we might put (and copy-paste) them in the
respective {tcp,udp,unix,etc}_bpf_bypass_getsockopt.

> Kind regards,
> Alex
>
> >
> > > +                    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypas=
s_getsockopt, \
> > >                                         tcp_bpf_bypass_getsockopt,   =
          \
> > > -                                       level, optname))             =
          \
> > > +                                       level, optname)))            =
          \
> > >                         __ret =3D __cgroup_bpf_run_filter_getsockopt(=
            \
> > >                                 sock, level, optname, optval, optlen,=
          \
> > >                                 max_optlen, retval);                 =
          \
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index 8b7ed7167243..530d6d22f42d 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -1847,6 +1847,7 @@ int sk_getsockopt(struct sock *sk, int level, i=
nt optname,
> > >                   sockptr_t optval, sockptr_t optlen);
> > >  int sock_getsockopt(struct socket *sock, int level, int op,
> > >                     char __user *optval, int __user *optlen);
> > > +bool sock_bpf_bypass_getsockopt(int level, int optname);
> > >  int sock_gettstamp(struct socket *sock, void __user *userstamp,
> > >                    bool timeval, bool time32);
> > >  struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long =
header_len,
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index 5440e67bcfe3..194a423eb6e5 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -1963,6 +1963,11 @@ int sock_getsockopt(struct socket *sock, int l=
evel, int optname,
> > >                              USER_SOCKPTR(optlen));
> > >  }
> > >
> > > +bool sock_bpf_bypass_getsockopt(int level, int optname)
> > > +{
> > > +       return false;
> > > +}
> > > +
> > >  /*
> > >   * Initialize an sk_lock.
> > >   *
> > > --
> > > 2.34.1
> > >

