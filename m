Return-Path: <netdev+bounces-5706-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 791B1712810
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:10:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D20A28185B
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 14:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1488923D57;
	Fri, 26 May 2023 14:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052ED1EA6F
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 14:10:32 +0000 (UTC)
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4D3DF;
	Fri, 26 May 2023 07:10:31 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id a1e0cc1a2514c-786efb5ff24so44161241.0;
        Fri, 26 May 2023 07:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685110230; x=1687702230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fG713w/n5a4Y4ViFtXQB/KYC9f0zPKWxoGiBTJxDL+k=;
        b=m9DMWB2dnvhFdAq3/ujAYrL5BhwankhnPGSChUOWq8m3xfFLLE583TzVjx3bZgXsVS
         kDlkULz9eDZ+xlKaLWpGgTdiOpqYohDhGGeKxmsS4WJPsMABy6VT/AyrEGa0Ts7vWZ8W
         A8CXCpqyYuS7gJ0Ye0/5BXs7vrQrA9bmMEBcrFsWU/htHHYv1/no9yan/8P15XemaUax
         BWdurVADFOe5XbQ6+PwCU7da2D/zhDHr055LRVAAA9vjXzvvVtzRFZqQuCBCFAfdtEV4
         4W62mBBFz/lrUSjRLFfKJRDcvBdbIuteeK4gY5r/a0DjatF/qsVeGujZyAyCHRVQDqg+
         rDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685110230; x=1687702230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fG713w/n5a4Y4ViFtXQB/KYC9f0zPKWxoGiBTJxDL+k=;
        b=i8X5cAt6V315xbStmo9GskMgyDZVOJL8V1JG7Dvp3REc6RP23L6KTGj4SAmB3/WjSc
         09CtISyw+tV/eHutWssvgrYe6Qu9GTkCpJRGgvkd3aQoPmq/1x8Gywvsl08jYvHbIgmP
         t3c2b+6YiozsyT3UXlOGJppS7/gLza4QvVHBRpmmUzg7n2hYiQcGZZlh3p501BMwkFrF
         3FlRgaaXTxE+dg7s2lDkEmZJaSbE8UaYfQ7G0g/xqBzgYil5Z7tMAMDsLi1tJxWppShG
         Pek1zly4RNnwscq3dAtf19yBOu/ipIqvRJfVFGBQ94c59ZvKMj5c1L36bX55ZHQvcE6s
         y0ow==
X-Gm-Message-State: AC+VfDxLNdo8zWywY/QpaSrDtJ8YF2F3u2dby9k98CC+t6POBxlB411j
	w+ZALPvkcRNSZICUGAItz0nrF+AZf34+r4eAQkk=
X-Google-Smtp-Source: ACHHUZ6eVTZtnPu5x20WxcO0d18Lw5T2t9skn4lv62QG/WAk5aDS9ISiUWFT9zur/ylXW9J4eGBSPWcNqP+mXC3o1P0=
X-Received: by 2002:a67:ffc9:0:b0:42f:18d9:a602 with SMTP id
 w9-20020a67ffc9000000b0042f18d9a602mr462435vsq.32.1685110230556; Fri, 26 May
 2023 07:10:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230525125503.400797-1-leitao@debian.org> <CAF=yD-LHQNkgPb-R==53-2auVxkP9r=xqrz2A8oe61vkoDdWjg@mail.gmail.com>
 <a1074987-c3ce-56cd-3005-beb5a3c55ef9@kernel.org> <CAF=yD-LXcufhJBpkEcUuphFpR1TA4=QwUXw4sKFsSiEL_mwG4Q@mail.gmail.com>
 <ZHB3BNopbx+5AnIa@gmail.com>
In-Reply-To: <ZHB3BNopbx+5AnIa@gmail.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Fri, 26 May 2023 10:09:53 -0400
Message-ID: <CAF=yD-LO8fZJfayJoFPO_wvMw=FLGbf_DYUcaBpKv81OEOQVUA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
To: Breno Leitao <leitao@debian.org>
Cc: David Ahern <dsahern@kernel.org>, Remi Denis-Courmont <courmisch@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Matthieu Baerts <matthieu.baerts@tessares.net>, 
	Mat Martineau <martineau@kernel.org>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Xin Long <lucien.xin@gmail.com>, leit@fb.com, axboe@kernel.dk, asml.silence@gmail.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, dccp@vger.kernel.org, 
	linux-wpan@vger.kernel.org, mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 5:08=E2=80=AFAM Breno Leitao <leitao@debian.org> wr=
ote:
>
> On Thu, May 25, 2023 at 12:06:00PM -0400, Willem de Bruijn wrote:
> > On Thu, May 25, 2023 at 11:34=E2=80=AFAM David Ahern <dsahern@kernel.or=
g> wrote:
> > > On 5/25/23 9:05 AM, Willem de Bruijn wrote:
> > > > I don't understand what this buys us vs testing the sk_family,
> > > > sk_protocol and cmd here.
> > >
> > > To keep protocol specific code out of core files is the reason I
> > > suggested it.
> >
> > I guess you object to demultiplexing based on per-family
> > protocol and ioctl cmd constants directly in this file?
> >
> > That only requires including the smaller uapi headers.
> >
> > But now net/core/sock.h now still has to add includes
> > linux/mroute.h, linux/mroute6.h and net/phonet/phonet.h.
> >
> > Aside on phonet_is_sk, if we're keeping this: this should be
> > sk_is_phonet? Analogous to sk_is_tcp and such. And, it should suffice
> > to  demultiplex based on the protocol family, without testing the
> > type or protocol. The family is defined in protocol-independent header
> > linux/socket.h. The differences between
> > PN_PROTO_PHONET and PN_PROTO_PIPE should be handled inside the family
> > code. So I think it is cleaner just to open-coded as `if
> > (sk->sk_family =3D=3D PF_PHONET)`
>
> Should we do the same for ipmr as well? Currently I am checking it
> using:
>
>         return sk->sk_type =3D=3D SOCK_RAW && inet_sk(sk)->inet_num =3D=
=3D IPPROTO_ICMPV6;
>
> This is what ip{6}mr functions[1] are use to check if `sk` is using ip{6}=
mr.
> If we just use `sk->family`, then I suppose that `sk_is_ip6mr` would be
> something as coded below. Is this correct?
>
>         static inline int sk_is_ip6mr(struct sock *sk)
>         {
>                 return sk->sk_family =3D=3D PF_INET6;
>         }

Actually, for multicast routing, the protocol check is required.

> Anyway, should we continue with the current (V3) approach, where we keep
> the protocol code out of core files, or, should I come back to the
> previous (V2) approach, where the protocol checks is coded directly in
> the core file?

David expressed preference for the current approach. So let's stay with tha=
t.

