Return-Path: <netdev+bounces-4130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83F5070B207
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 01:27:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB304280E63
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 23:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED681A929;
	Sun, 21 May 2023 23:27:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4EE2596
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 23:27:45 +0000 (UTC)
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67479C5
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 16:27:44 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-561afe72a73so73854917b3.0
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 16:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684711663; x=1687303663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JQ4d5ZBNtKkwR2shrsT5Rt4EEbcIL90RTPPhh8DbCo0=;
        b=PNtfpZ296ckPkPC+n1ThSQ218n3ZBrjvSIj1fsTw8Ed2/yERLA+Z4qwjI61GFFJEXD
         IpwjLKgtbNdlWzXSwcXPR+327EOzdash8709fjf5wDid9oDLBuKSkYjUSJ8Rwb2yJgw8
         3ux9rlgWmpOmdFcGjc3CyPsxFQ3McL6qJLg8eIrZQrY17IIBqfxF8iMAIWvXE81LrbtT
         kK5UFrqmMminV0EcSOQIeliMITCHE0MFyU6Eb9rLS8Eh5+e+ORtGkKvbSPPFgYLRuWnF
         twogtI33qFIBN2DYlG3tw2z31SGVYs4ItlHvPEtUwZpMjTHBNo3D+fBdYLLNft4iOpj1
         K6eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684711663; x=1687303663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JQ4d5ZBNtKkwR2shrsT5Rt4EEbcIL90RTPPhh8DbCo0=;
        b=lBIxwjg3sfAh/eDvboGrkVOoHqsJ0YI+zmfBS0spAQHY2wr+rdw3W4sq1WnuTuBtZr
         YhJmzknyMHY4g0o//204c/NUHBHMtZz6ByBcNLQrj5oae7oJ99lLJ+UWPyezx1BPkLYj
         FydhXeMEDrRE7zA6wJrcf0iDfMT5FH0C43wRjgsSQRnbJhKWcItnutmKQNLrfGp3slw8
         EDg/ZcFcRBq5Em1/rZW0UeeWMwXO/tgflqXA5rePlpKcx3gRe87Rk+CFNXra3PRDqLHd
         BJ4iMiACgHITQ1vn3Yqwp4eqa2oaBOr6BD8CKFAPODSEW3gYNCoDqfnd0PzWBeKaVhmO
         A+gw==
X-Gm-Message-State: AC+VfDzAHao9AXvYsWeEUmzfDdQvSEqTgAKx/A+65BjV/ivf8X9f83/L
	9NBn3jNQvwX/JCCix+88r1M5fTSHiCEWjeqQNL4=
X-Google-Smtp-Source: ACHHUZ4PHD3BaCK4/XdvO58Frag207JGE8EFZiJpoe5iAac6J/vAUvEJnhjQoA0ODPAGlbhaAWUxLglZC7N0tmkSrcQ=
X-Received: by 2002:a81:4854:0:b0:561:9092:d60a with SMTP id
 v81-20020a814854000000b005619092d60amr9556619ywa.42.1684711663481; Sun, 21
 May 2023 16:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <25a7b1b138e5ad3c926afce8cd4e08d8b7ef3af6.1684516568.git.lucien.xin@gmail.com>
 <20230519134318.6508f057@hermes.local> <CANn89iLkzO0py2N5TZAFWvcMjidd6R1URh0+D6Xr1enVNp8Sew@mail.gmail.com>
In-Reply-To: <CANn89iLkzO0py2N5TZAFWvcMjidd6R1URh0+D6Xr1enVNp8Sew@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 21 May 2023 19:27:10 -0400
Message-ID: <CADvbK_eujS_Kg3FenuAhOMv+Xga92H9o92LC3Lw=f+7NYdxRoA@mail.gmail.com>
Subject: Re: [PATCH net] rtnetlink: not allow dev gro_max_size to exceed GRO_MAX_SIZE
To: Eric Dumazet <edumazet@google.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>, network dev <netdev@vger.kernel.org>, 
	davem@davemloft.net, kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 21, 2023 at 1:25=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Fri, May 19, 2023 at 10:43=E2=80=AFPM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Fri, 19 May 2023 13:16:08 -0400
> > Xin Long <lucien.xin@gmail.com> wrote:
> >
> > > In commit 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536"),
> > > it limited GRO_MAX_SIZE to (8 * 65535) to avoid overflows, but also
> > > deleted the check of GRO_MAX_SIZE when setting the dev gro_max_size.
> > >
> > > Currently, dev gro_max_size can be set up to U32_MAX (0xFFFFFFFF),
> > > and GRO_MAX_SIZE is not even used anywhere.
> > >
> > > This patch brings back the GRO_MAX_SIZE check when setting dev
> > > gro_max_size/gro_ipv4_max_size by users.
> > >
> > > Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
> > > Reported-by: Xiumei Mu <xmu@redhat.com>
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/core/rtnetlink.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > >
> > > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > > index 653901a1bf75..59b24b184cb0 100644
> > > --- a/net/core/rtnetlink.c
> > > +++ b/net/core/rtnetlink.c
> > > @@ -2886,6 +2886,11 @@ static int do_setlink(const struct sk_buff *sk=
b,
> > >       if (tb[IFLA_GRO_MAX_SIZE]) {
> > >               u32 gro_max_size =3D nla_get_u32(tb[IFLA_GRO_MAX_SIZE])=
;
> > >
> > > +             if (gro_max_size > GRO_MAX_SIZE) {
> > > +                     err =3D -EINVAL;
> > > +                     goto errout;
> > > +             }
> > > +
> >
> > Please add extack messages so the error can be reported better.
>
> Also, what is the reason for not changing rtnl_create_link() ?
Good catch!

Not only GRO_MAX_SIZE, all tb[IFLA_GSO/GRO_*] checks should be moved
to validate_linkmsg(), with extra added for sure. Otherwise:

# ip link add dummy1 gso_max_size 4294967295 gro_max_size 4294967295
gso_ipv4_max_size 4294967295 gro_ipv4_max_size 4294967295 type dummy
# ip -d link show dummy1
6: dummy1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
    link/ether ba:cd:f2:8d:84:9b brd ff:ff:ff:ff:ff:ff promiscuity 0
allmulti 0 minmtu 0 maxmtu 0
    dummy addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size
4294967295 gso_max_segs 65535 tso_max_size 65536 tso_max_segs 65535
gro_max_size 4294967295 gso_ipv4_max_size 4294967295 gro_ipv4_max_size
4294967295

Also, I might move validate_linkmsg() from do_setlink() to its caller,
to avoid validate_linkmsg() being called twice in the path of:
__rtnl_newlink() -> do_setlink().

Thanks.

