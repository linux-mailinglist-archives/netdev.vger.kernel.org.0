Return-Path: <netdev+bounces-7746-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BCA7215CC
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 11:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A3651C209F2
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:18:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83C7440D;
	Sun,  4 Jun 2023 09:18:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA79E3C22
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 09:18:36 +0000 (UTC)
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36713B1;
	Sun,  4 Jun 2023 02:18:35 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-4652fcb2ac1so54031e0c.1;
        Sun, 04 Jun 2023 02:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685870314; x=1688462314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aox3XK8tx72aeNja1udkD88JAZ0aWEszFBLsOxbe+fI=;
        b=rSfoJfS2X8Zx0gaX8WEMmFcIYgSg25rCZ+TYlggJeZcpKateZrWXEbic+aLXjMv2GR
         gjjZI0N+ru+UqG9tRNfDeqiJB9NSP/YBse9KnKB4ov97mKBPgeYSpjB+I+rJFaeRquxk
         Q8kCSN4N48veUEAxUTT3rcE0aHfP3FIjZ5UCEANBn5J4AFUCV8SdSYuZcSnKYoGqxtOA
         x3hNvruleQUDpiRe8e2S6c9ZDbAhV10jcwWwQ9w65XG/9MX7IGHroZUMTKUtepX057C3
         9CVX+K1Y0WwQvZQFvme2NWhA1VtLGqamnw7qtm4ZCD+1CyeTsOEc6lTtRVdp06jsDWDF
         N9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685870314; x=1688462314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aox3XK8tx72aeNja1udkD88JAZ0aWEszFBLsOxbe+fI=;
        b=gTHDl2qU1P2foAPXvM+sqNzoaVwA3l8cpJS/fXb9nSiBFTS+YGMoKc/+Hdf813BLME
         BL3PzG5sB161/Ukg7kK3T9FGTmECloWdl3TfkH7aJBAdzSKSi9sVdJNQMvNyUKhrue/s
         S/0pu2WMP11tjzld3zxQ41y2d1xMULMqHxPqa+IraTRMSxVABdHyEUjgV0+6LYHFDfSi
         1RZeZSUC1tJGUgMJZjnPU8s2mTuABX0DyP+y7opV77Gj+Hsp1koBlR/NXP+JISFjmZnD
         rjMILkymIxf6PmD3enKKu4gprClM87zlWaL/OHOeE+bT4EwSOcaXQLPwmS1urS9vdTmO
         N/dA==
X-Gm-Message-State: AC+VfDy+VkvvloSnw5x8g8kOGY9zacntpbqXmnRNgOQbVKlZ2VWOswA/
	M28ksQDGgWUo/lrXtHU2UYvSvRwrd1MLxVipRQ0=
X-Google-Smtp-Source: ACHHUZ4eCakEWsPBp89FEc1u6EWVeN0rw7V8m/x6CRpEQwG051tQBrs1bgGohAOKHeCdHM/ijFvcBlc1oEI7P0Nb/aA=
X-Received: by 2002:a1f:45d5:0:b0:460:d627:22ca with SMTP id
 s204-20020a1f45d5000000b00460d62722camr2332346vka.1.1685870314156; Sun, 04
 Jun 2023 02:18:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602163044.1820619-1-leitao@debian.org> <CAF=yD-Kk9mVWPZN50NUu8uGwEbySNS-WzvJ=1HTTcVsA6OOuvA@mail.gmail.com>
 <ZHxEX0TlXX7VV9kX@gmail.com>
In-Reply-To: <ZHxEX0TlXX7VV9kX@gmail.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Sun, 4 Jun 2023 11:17:56 +0200
Message-ID: <CAF=yD-LvTDmWp+wAqwuQ7vKLT0hAHcQjV9Ef2rEag5J4cSZrkA@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: ioctl: Use kernel memory on protocol
 ioctl callbacks
To: Breno Leitao <leitao@debian.org>
Cc: Remi Denis-Courmont <courmisch@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, David Ahern <dsahern@kernel.org>, 
	Matthieu Baerts <matthieu.baerts@tessares.net>, Mat Martineau <martineau@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, axboe@kernel.dk, 
	asml.silence@gmail.com, leit@fb.com, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org, 
	mptcp@lists.linux.dev, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> On Sat, Jun 03, 2023 at 10:21:50AM +0200, Willem de Bruijn wrote:
> > On Fri, Jun 2, 2023 at 6:31=E2=80=AFPM Breno Leitao <leitao@debian.org>=
 wrote:
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> >
> > Please check the checkpatch output
> >
> > https://patchwork.hopto.org/static/nipa/753609/13265673/checkpatch/stdo=
ut
>
> I am checking my current checkpatch before sending the patch, but I am
> not seeing the problems above.
>
> My tree is at 44c026a73be8038 ("Linux 6.4-rc3"), and I am not able to
> reproduce the problems above.
>
>         $ scripts/checkpatch.pl v5/v5-0001-net-ioctl-Use-kernel-memory-on=
-protocol-ioctl-cal.patch
>         total: 0 errors, 0 warnings, 0 checks, 806 lines checked
>         v5/v5-0001-net-ioctl-Use-kernel-memory-on-protocol-ioctl-cal.patc=
h has no obvious style problems and is ready for submission.
>
> Let me investigate what options I am missing when running checkpatch.

The reference is to the checkpatch as referenced by patchwork:

https://patchwork.kernel.org/project/netdevbpf/patch/20230602163044.1820619=
-1-leitao@debian.org/

The 80 character limit is a soft limit. But also note the CHECK
statements on whitespace.

>
> > > +/* A wrapper around sock ioctls, which copies the data from userspac=
e
> > > + * (depending on the protocol/ioctl), and copies back the result to =
userspace.
> > > + * The main motivation for this function is to pass kernel memory to=
 the
> > > + * protocol ioctl callbacks, instead of userspace memory.
> > > + */
> > > +int sk_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
> > > +{
> > > +       int rc =3D 1;
> > > +
> > > +       if (sk_is_ipmr(sk))
> > > +               rc =3D ipmr_sk_ioctl(sk, cmd, arg);
> > > +       else if (sk_is_icmpv6(sk))
> > > +               rc =3D ip6mr_sk_ioctl(sk, cmd, arg);
> > > +       else if (sk_is_phonet(sk))
> > > +               rc =3D phonet_sk_ioctl(sk, cmd, arg);
> >
> > Does this handle all phonet ioctl cases correctly?
> >
> > Notably pn_socket_ioctl has a SIOCPNGETOBJECT that reads and writes a u=
16.
>
> We are not touching  "struct proto_ops" in this patch at all.  And
> pn_socket_ioctl() is part of "struct proto_ops".
>
>         const struct proto_ops phonet_stream_ops =3D {
>                   ...
>                   .ioctl          =3D pn_socket_ioctl,
>         }
>
> That said, all the "struct proto_ops" ioctl calls backs continue to use
> "unsigned long arg" with userspace information, at least for now.

Ok. Perhaps good to call out in the commit message that this does not
convert all protocol ioctl callbacks.

