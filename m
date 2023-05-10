Return-Path: <netdev+bounces-1507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0CD16FE0BC
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:47:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A740E1C20DA3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F45414AA6;
	Wed, 10 May 2023 14:47:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643033D60
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:47:38 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3391BD6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:47:35 -0700 (PDT)
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com [209.85.219.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2A6393F17A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1683730054;
	bh=JjIUi7jBNspmRga1n5cvGl2/nqkm6+K5dZzGhpmb1Bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=rn1hoDknTtm4pd/7y7lo6ZLsllSBkEcd8GZdXuPTRuUOQfLXtk0EBXoU2BBgxyeM9
	 YdNvIdDXyKwtnpD1Ay7FruaokDVT5LRZ9gVXKGr0zG3pZMZ1LORBbDgD0jl6eMkZ8/
	 HQf7XcikrDz53Uf2IlR6rSBQ2hUjBQ95lzIU52of8wQCNbF4yk80zaR68ylWjplDym
	 4krBKHAp+fnCUKqWZQT3W0VdnRdKEHlACcUiloKA8rBb2gEOCFKljscgtrF/LKxgZT
	 FfhFwUa347O62Xipt/AlyL1ILuW08b21pwLQO85SFBsGeOmxV1So1/jFVvwyKWGENh
	 vtg7VZDQSrihQ==
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-b9e2b65f2eeso13260169276.2
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683730053; x=1686322053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JjIUi7jBNspmRga1n5cvGl2/nqkm6+K5dZzGhpmb1Bo=;
        b=OURpZH4XEzl+hmXYyt8vnq1VowyLdYG+QcWdP8ZzGVR9MQK+seooQ1gHF1pvHYsftJ
         6ZqGFypFeTAyj9Tu/ISdguBb4ZkEJ9mU1NKS0ivq9G1+8ouwxDqygdRzB6XRsfFpCVD+
         gJGfLdQQxn5H/yD9wkOVLX9Y/bACnOfR3O2ewWZY/AQEnM/UI3vLo5b9p696yM2jFr6B
         JOTzI45C7wfTyEk1bvG3Ia3FBCRbjb7uNE4PSQPgcn9BMjmq/c2AFt40tEQgnA2hG002
         pBu4fOkAZFOxBcd9acDiJYetN8Au5UbeXGbOYSj/cDAU4cNGfd8ebYEFx6VdPYUWwxbw
         nglQ==
X-Gm-Message-State: AC+VfDwixQLlzJZz9TvxVJtpxCRDApnPzOHzyLmSQzj6ijjBnyG784/X
	xn42I2QjnbELOSvOB35yoULMvNlqxvgS3YFSVuntMTzqQ+SjWnyt8BORno46uZ0f8NxPX566UZF
	GypG6jTNEe7ZKveHesN79V+3MjaSludGyhLyLi0owj+Jjefw8cA==
X-Received: by 2002:a25:50c1:0:b0:ba1:b7e4:e0dd with SMTP id e184-20020a2550c1000000b00ba1b7e4e0ddmr18740723ybb.56.1683730053268;
        Wed, 10 May 2023 07:47:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5BvjS8N0bb9sG5W4XddT53p706jOzztHM9E/9C8JuNAkUBBSRRA3HmYJNVEaL9ADLicLIha3aVU6xa+N0EDKQ=
X-Received: by 2002:a25:50c1:0:b0:ba1:b7e4:e0dd with SMTP id
 e184-20020a2550c1000000b00ba1b7e4e0ddmr18740710ybb.56.1683730053000; Wed, 10
 May 2023 07:47:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510131527.1244929-1-aleksandr.mikhalitsyn@canonical.com> <CAKH8qBuzWHoEiABvTgM2qnx5Av127VMHnncGtU5EZq+ffT9eGg@mail.gmail.com>
In-Reply-To: <CAKH8qBuzWHoEiABvTgM2qnx5Av127VMHnncGtU5EZq+ffT9eGg@mail.gmail.com>
From: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Wed, 10 May 2023 16:47:21 +0200
Message-ID: <CAEivzxd5a8qykjbi03dyPD4hfBMsbKNTr=b0MEd2gamjC-stZA@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: add bpf_bypass_getsockopt proto callback
To: Stanislav Fomichev <sdf@google.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	linux-sctp@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 4:32=E2=80=AFPM Stanislav Fomichev <sdf@google.com>=
 wrote:
>
> On Wed, May 10, 2023 at 6:15=E2=80=AFAM Alexander Mikhalitsyn
> <aleksandr.mikhalitsyn@canonical.com> wrote:
> >
> > Add bpf_bypass_getsockopt proto callback and filter out
> > SCTP_SOCKOPT_PEELOFF and SCTP_SOCKOPT_PEELOFF_FLAGS socket options
> > from running eBPF hook on them.
> >
> > These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GETSOCKOPT
> > hook returns an error after success of the original handler
> > sctp_getsockopt(...), userspace will receive an error from getsockopt
> > syscall and will be not aware that fd was successfully installed into f=
dtable.
> >
> > This patch was born as a result of discussion around a new SCM_PIDFD in=
terface:
> > https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalits=
yn@canonical.com/
> >
> > Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Stanislav Fomichev <sdf@google.com>
> > Cc: Neil Horman <nhorman@tuxdriver.com>
> > Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Cc: Xin Long <lucien.xin@gmail.com>
> > Cc: linux-sctp@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.c=
om>
>
> Acked-by: Stanislav Fomichev <sdf@google.com>
>
> with a small nit below

Hi Stanislav!

Thanks for your review.

I've also added a Suggested-by tag with your name in -v2, because
you've given me this idea to use bpf_bypass_getsockopt.
Hope that you are comfortable with it.

>
> > ---
> >  net/sctp/socket.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> > index cda8c2874691..a9a0ababea90 100644
> > --- a/net/sctp/socket.c
> > +++ b/net/sctp/socket.c
> > @@ -8281,6 +8281,29 @@ static int sctp_getsockopt(struct sock *sk, int =
level, int optname,
> >         return retval;
> >  }
> >
>
> [...]
>
> > +bool sctp_bpf_bypass_getsockopt(int level, int optname)
>
> static bool ... ? You're not making it indirect-callable, so seems
> fine to keep private to this compilation unit?

Sure, my bad. Fixed in v2.

Kind regards,
Alex

>
> > +{
> > +       /*
> > +        * These options do fd_install(), and if BPF_CGROUP_RUN_PROG_GE=
TSOCKOPT
> > +        * hook returns an error after success of the original handler
> > +        * sctp_getsockopt(...), userspace will receive an error from g=
etsockopt
> > +        * syscall and will be not aware that fd was successfully insta=
lled into fdtable.
> > +        *
> > +        * Let's prevent bpf cgroup hook from running on them.
> > +        */
> > +       if (level =3D=3D SOL_SCTP) {
> > +               switch (optname) {
> > +               case SCTP_SOCKOPT_PEELOFF:
> > +               case SCTP_SOCKOPT_PEELOFF_FLAGS:
> > +                       return true;
> > +               default:
> > +                       return false;
> > +               }
> > +       }
> > +
> > +       return false;
> > +}
> > +
> >  static int sctp_hash(struct sock *sk)
> >  {
> >         /* STUB */
> > @@ -9650,6 +9673,7 @@ struct proto sctp_prot =3D {
> >         .shutdown    =3D  sctp_shutdown,
> >         .setsockopt  =3D  sctp_setsockopt,
> >         .getsockopt  =3D  sctp_getsockopt,
> > +       .bpf_bypass_getsockopt  =3D sctp_bpf_bypass_getsockopt,
> >         .sendmsg     =3D  sctp_sendmsg,
> >         .recvmsg     =3D  sctp_recvmsg,
> >         .bind        =3D  sctp_bind,
> > @@ -9705,6 +9729,7 @@ struct proto sctpv6_prot =3D {
> >         .shutdown       =3D sctp_shutdown,
> >         .setsockopt     =3D sctp_setsockopt,
> >         .getsockopt     =3D sctp_getsockopt,
> > +       .bpf_bypass_getsockopt  =3D sctp_bpf_bypass_getsockopt,
> >         .sendmsg        =3D sctp_sendmsg,
> >         .recvmsg        =3D sctp_recvmsg,
> >         .bind           =3D sctp_bind,
> > --
> > 2.34.1
> >

