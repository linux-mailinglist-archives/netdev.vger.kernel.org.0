Return-Path: <netdev+bounces-4125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B53C70AF6F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 20:22:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5669B1C20937
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 18:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CEB58F61;
	Sun, 21 May 2023 18:22:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616C92F2E
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 18:22:32 +0000 (UTC)
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FFDE4
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 11:22:30 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f601283b36so10825e9.0
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 11:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684693349; x=1687285349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptPKJytPMSY7ubLZEVTpPqHexmVHYanSgHxoL5D4eHA=;
        b=hgom6/k/H3Fq+5RCWJSvuEJomON+PatIc3PHvvY0xA+qU6b2RYzG0L/LMpsYRjWRBV
         trGwtdVM4x8OYKBy7eWWDMxKBgSFdW9fV61b7yJDe58OXQOTbKsNlEC+um2A62y0zHzc
         /c9WrRJ032Dd4GIuPB7bjYGciSNnYcHOqDbbQizgl1AagmCj5QMgOiWsP7jdC/ck9tKq
         kIwIZaxk8TINanz69Cm+rQnHVllnHkb76fxyMpjdDo2yo9QurzNP9Ru5TJhspqetaNCt
         mHj12jUteINJJmSlK5JNLR+3mtvK17nkCtAuu1m/X+z15fOm7/lPQO4KsI4tHBuXrVPF
         7hVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684693349; x=1687285349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptPKJytPMSY7ubLZEVTpPqHexmVHYanSgHxoL5D4eHA=;
        b=lHtM1dyVh/QyaVqEHr232KoDaeCjv8kCo9DFyAhO2ohB9CQ57Xphv9iE6+Pxvdnmfa
         B7SLnKgp/fX0EK1tljr5LoOGHSAfVfw4Zq3TW+vb8/iy3uGIETGJXJr7KDUnerpS1rmx
         banMyzi0t9PAFDebceEKjPnsStRYUk1nk2OMWMY5M6QsNcZkgwW0JVFxJNIc2IPX/ETw
         I4gxi9AmYEWkrI2OckHyV/EedTuOLan8z4Siaw5qdw2rOznlI5Pi7lHXCWzNyKFvglWe
         E428U/XAAUChEeky8g+SDp0JzKZr8agL7KhXuJPTKuvXSLI4/KvjJWvWFS6H8knwfD+G
         BoHQ==
X-Gm-Message-State: AC+VfDx9D3NrMu7yCsPFaiVRBnodhfKM9+JjjmQi91SbVtKsmABq6DCv
	Wy5ANmVCXr3Fs8wwVpmrAYLbkxJ4N6ygXOYT7BeWcA==
X-Google-Smtp-Source: ACHHUZ7EJHOHKWzbRBImAmtuRNPrkUlrNwoFjcMASjfwnUqG6GOz1NHSvZPz3VE2Sn6r1uOpXzlD/AMe0SzLw9fQj44=
X-Received: by 2002:a05:600c:3d97:b0:3f4:fe69:2dca with SMTP id
 bi23-20020a05600c3d9700b003f4fe692dcamr517511wmb.7.1684693348600; Sun, 21 May
 2023 11:22:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com> <20230517213118.3389898-2-edumazet@google.com>
 <ZGZavH7hxiq/pkF8@corigine.com>
In-Reply-To: <ZGZavH7hxiq/pkF8@corigine.com>
From: Eric Dumazet <edumazet@google.com>
Date: Sun, 21 May 2023 20:22:16 +0200
Message-ID: <CANn89iJofjC=aqSu6X9itW8VQXTSFUOiAmBB2Zzuw-6kqTnwzA@mail.gmail.com>
Subject: Re: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in ipv6_rpl_srh_rcv()
To: Simon Horman <simon.horman@corigine.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Alexander Aring <alex.aring@gmail.com>, 
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 7:05=E2=80=AFPM Simon Horman <simon.horman@corigine=
.com> wrote:
>
> On Wed, May 17, 2023 at 09:31:16PM +0000, Eric Dumazet wrote:
> > After calls to pskb_may_pull() we need to reload @hdr variable,
> > because skb->head might have changed.
> >
> > We need to move up first pskb_may_pull() call right after
> > looped_back label.
> >
> > Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Alexander Aring <alex.aring@gmail.com>
> > Cc: David Lebrun <david.lebrun@uclouvain.be>
> > ---
> >  net/ipv6/exthdrs.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> > index a8d961d3a477f6516f542025dfbcfc6f47407a70..b129e982205ee43cbf74f49=
00c3031827d962dc2 100644
> > --- a/net/ipv6/exthdrs.c
> > +++ b/net/ipv6/exthdrs.c
> > @@ -511,6 +511,10 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
> >       }
> >
> >  looped_back:
> > +     if (!pskb_may_pull(skb, sizeof(*hdr))) {
> > +             kfree_skb(skb);
> > +             return -1;
> > +     }
> >       hdr =3D (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
> >
> >       if (hdr->segments_left =3D=3D 0) {
>
> Hi Eric,
>
> Not far below this line there is a call to pskb_pull():
>
>                 if (hdr->nexthdr =3D=3D NEXTHDR_IPV6) {
>                         int offset =3D (hdr->hdrlen + 1) << 3;
>
>                         skb_postpull_rcsum(skb, skb_network_header(skb),
>                                            skb_network_header_len(skb));
>
>                         if (!pskb_pull(skb, offset)) {
>                                 kfree_skb(skb);
>                                 return -1;
>                         }
>                         skb_postpull_rcsum(skb, skb_transport_header(skb)=
,
>                                            offset);
>
> Should hdr be reloaded after the call to pskb_pull() too?

I do not think so, because @hdr is not used between this pskb_pull()
and the return -1:

       if (hdr->nexthdr =3D=3D NEXTHDR_IPV6) {
            int offset =3D (hdr->hdrlen + 1) << 3;

            skb_postpull_rcsum(skb, skb_network_header(skb),
                       skb_network_header_len(skb));

            if (!pskb_pull(skb, offset)) {
                kfree_skb(skb);
                return -1;
            }
            skb_postpull_rcsum(skb, skb_transport_header(skb),
                       offset);

            skb_reset_network_header(skb);
            skb_reset_transport_header(skb);
            skb->encapsulation =3D 0;

            __skb_tunnel_rx(skb, skb->dev, net);

            netif_rx(skb);
            return -1;
        }

