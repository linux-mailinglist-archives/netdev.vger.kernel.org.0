Return-Path: <netdev+bounces-1589-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4026FE65E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AE2D28137E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B481D2DA;
	Wed, 10 May 2023 21:41:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688DE21CCA
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:41:04 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CC63C01
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:41:01 -0700 (PDT)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E87DB3F229
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683754857;
	bh=m6wgVd9NGqSXcldf6QvSjr1yIoYB5cxk8Q6ivPxNQdY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=GpWzHDCbRZeGMvaTA9C51w62z71GTubTvzZWo3Lc/7xmNebUQvP2YI3TD+3T8DKSL
	 yx+onOMnKfIA4ZxUIOdluIRaBnQu/jub6Td14Fx7vcCY77w184qHuv+IAQEQovASSI
	 kAl69j4csi2KbHq9HDG1PRAe9trwKYnWcK6nbLmCspFLbwRqKUWYj0BYGOZlgS20Rh
	 F3xpgGUw1J8ipiVYxtUVlF3otSYpOJW+4gmynXU7UrbJUrNbpaT1ADTq73kYdKeRds
	 FqWk/JHUgeiCqy7gPwjIIe79tU9gBx+I+UkeeEqABmxYI8Yyb+7zy8kBIPcOWmKN0j
	 SXBKLCbNT1c4w==
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-b9a7766d220so9721923276.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683754857; x=1686346857;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m6wgVd9NGqSXcldf6QvSjr1yIoYB5cxk8Q6ivPxNQdY=;
        b=YWyen7Hv03x9GMll9E/tkEw4YVqzp86xKhCUhUerRbm2RB5658T2PJa0q/bYwOq9DE
         vQrSOtKzl8GqwvhKOniCJ/V9dcGNes35l9hPfF4TYsVn+RUhO3yb6Djbvn1aU5ErGlvm
         QP6mcS5jls2yo9X54JydERetV8f2bHcTevJat202RiXEzLXT/zUlxSFmd11tbtPriFAq
         V9YbTzqDC9jKFNy4AeED/sHiz8qnQzE1kcMWhvLv/bPQWVjWGbWTdqmD31gN78efeaZs
         cNREQm9PhcF29F9S0clgx4PoGJRipe7awQScbbq40g+D9r4n1tjtDRBdO0xEy11fbfbX
         9/BA==
X-Gm-Message-State: AC+VfDwuiAqhv8/dnmLzA+EBfzM1UgH+TryVIvXBeb6g+3ityQlhANWh
	fDHlS/5qWHbjfKZH6l+6G+xFihhVAKiTtFTzGLuwqylLuFWv5l0bsz/sgAdUuvEJrmtpHxau0MW
	GJhxbjISuvDqo1AONKIGyFojGXPPiFTydEvssKypPPBGrO0Xgpg==
X-Received: by 2002:a05:6902:727:b0:b9e:6d19:8dcc with SMTP id l7-20020a056902072700b00b9e6d198dccmr21751057ybt.59.1683754857056;
        Wed, 10 May 2023 14:40:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HxJ/1TQ3NAW43qRmB0YIfRnnDmDVwytpoKPgforTBE0sLyzrGcvHKku5yUsSLyJO4L6tbCM74I0m2bKdOnRM=
X-Received: by 2002:a05:6902:727:b0:b9e:6d19:8dcc with SMTP id
 l7-20020a056902072700b00b9e6d198dccmr21751038ybt.59.1683754856770; Wed, 10
 May 2023 14:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510152216.1392682-1-aleksandr.mikhalitsyn@canonical.com> <CAKH8qBuAoobsVP2Q5KN06fZ2NM3_aMwT7Y2OoKwS4Cf=cv3ZGg@mail.gmail.com>
In-Reply-To: <CAKH8qBuAoobsVP2Q5KN06fZ2NM3_aMwT7Y2OoKwS4Cf=cv3ZGg@mail.gmail.com>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Wed, 10 May 2023 23:40:45 +0200
Message-ID: <CAEivzxc3hzqMROfCgshD6qW3=NErpF6LWXFGjoBhPNNzEZ3kDg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: core: add SOL_SOCKET filter for bpf
 getsockopt hook
To: Stanislav Fomichev <sdf@google.com>
Cc: davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 11:31=E2=80=AFPM Stanislav Fomichev <sdf@google.com=
> wrote:
>
> On Wed, May 10, 2023 at 8:23=E2=80=AFAM Alexander Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > We have per struct proto ->bpf_bypass_getsockopt callback
> > to filter out bpf socket cgroup getsockopt hook from being called.
> >
> > It seems worthwhile to add analogical helper for SOL_SOCKET
> > level socket options. First user will be SO_PEERPIDFD.
> >
> > This patch was born as a result of discussion around a new SCM_PIDFD in=
terface:
> > https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalits=
yn@canonical.com/
> >
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Stanislav Fomichev <sdf@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: bpf@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
> > ---
> >  include/linux/bpf-cgroup.h | 8 +++++---
> >  include/net/sock.h         | 1 +
> >  net/core/sock.c            | 5 +++++
> >  3 files changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> > index 57e9e109257e..97d8a49b35bf 100644
> > --- a/include/linux/bpf-cgroup.h
> > +++ b/include/linux/bpf-cgroup.h
> > @@ -387,10 +387,12 @@ static inline bool cgroup_bpf_sock_enabled(struct=
 sock *sk,
> >         int __ret =3D retval;                                          =
          \
> >         if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT) &&                   =
        \
> >             cgroup_bpf_sock_enabled(sock, CGROUP_GETSOCKOPT))          =
        \
> > -               if (!(sock)->sk_prot->bpf_bypass_getsockopt ||         =
        \
> > -                   !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_g=
etsockopt, \
> > +               if (((level !=3D SOL_SOCKET) ||                        =
          \
> > +                    !sock_bpf_bypass_getsockopt(level, optname)) &&   =
        \
> > +                   (!(sock)->sk_prot->bpf_bypass_getsockopt ||        =
        \
>
> Any reason we are not putting this into bpf_bypass_getsockopt for
> af_unix struct proto? SO_PEERPIDFD seems relevant only for af_unix?

Yes, that should work perfectly well. The reason why I'm going this
way is that we are
declaring all SOL_SOCKET-level options in the net/core/sock.c which is
not specific to any address family.
It seems reasonable to have a way to filter out getsockopt for these
options too.

But I'm not insisting on that way.

Kind regards,
Alex

>
> > +                    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_=
getsockopt, \
> >                                         tcp_bpf_bypass_getsockopt,     =
        \
> > -                                       level, optname))               =
        \
> > +                                       level, optname)))              =
        \
> >                         __ret =3D __cgroup_bpf_run_filter_getsockopt(  =
          \
> >                                 sock, level, optname, optval, optlen,  =
        \
> >                                 max_optlen, retval);                   =
        \
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 8b7ed7167243..530d6d22f42d 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1847,6 +1847,7 @@ int sk_getsockopt(struct sock *sk, int level, int=
 optname,
> >                   sockptr_t optval, sockptr_t optlen);
> >  int sock_getsockopt(struct socket *sock, int level, int op,
> >                     char __user *optval, int __user *optlen);
> > +bool sock_bpf_bypass_getsockopt(int level, int optname);
> >  int sock_gettstamp(struct socket *sock, void __user *userstamp,
> >                    bool timeval, bool time32);
> >  struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long he=
ader_len,
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 5440e67bcfe3..194a423eb6e5 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1963,6 +1963,11 @@ int sock_getsockopt(struct socket *sock, int lev=
el, int optname,
> >                              USER_SOCKPTR(optlen));
> >  }
> >
> > +bool sock_bpf_bypass_getsockopt(int level, int optname)
> > +{
> > +       return false;
> > +}
> > +
> >  /*
> >   * Initialize an sk_lock.
> >   *
> > --
> > 2.34.1
> >

