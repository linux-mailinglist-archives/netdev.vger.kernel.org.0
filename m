Return-Path: <netdev+bounces-6478-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4A2716781
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:48:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37DFF1C20C07
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E545271EE;
	Tue, 30 May 2023 15:48:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DEB17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:48:37 +0000 (UTC)
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CBEF3
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:48:36 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso103995e9.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685461714; x=1688053714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QMytrTVQulXXDgWl6VPCBJ0HfFu3xAMWRivySL2FvPE=;
        b=l0LwY1p9iQHqElJOXKGi+m8BofdBDz1RKAoijYdq9KCvFIPfzddeP1t3KlfK2AuOXd
         LDakrYNQq0BUAxBKa09QytVEFROLXr+LUEh6QzMjbPiY4yO1dKwSsm6IY7hcfoe5XLEw
         NNgVXEVatfvBwXp4HOcuwRvuy4KI9xGSOzZ5RoNK3WVfp4+a6XLaW8PtUCGz/2Fs0MBd
         AVFvj/cNpPvBmrhKxpHM44+4edvhfZ3j6LC4P3V2iaELJGFTVHWNKDxeaCzdkczY/JV8
         5xN/rOD7MrrESYru6i15axiT6pL0eR5w/Z37W9/x1S8a1pGe5XFjgAhBQJZFhbYnwMCK
         sfJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685461714; x=1688053714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QMytrTVQulXXDgWl6VPCBJ0HfFu3xAMWRivySL2FvPE=;
        b=MF7Zc80B39IX2x69UTUGunhbebXzmWXqIrE1+GLY1IHupMn958DypezLXd0tuOKgB0
         QWL+4qyfHlEGveE75crmicyE6U8kf3qSdlSgxSoZKKJ/DhDt3w8BYIr3oUfNFYF/V5Tt
         p8qW/UYWiIR5D1O8VlW4NjZTjGIKHT24R5KjYVkmW2TqIN8gdNkaAvg9tNVpJk4/Ps5c
         y2R+dfmq4vf60sXgDmNo3V5Y8WZbkZbaP3gTuBCb6fOKPl71qO7MlbHzhprLv1bHxSB+
         pbqPd7Vjvfk2QSBTO5YL2k6Uttn84oZ8JMfpPrPbn5jm8Vh353aLXZQ0Huk7ehD+2uve
         NzJg==
X-Gm-Message-State: AC+VfDx/K/n05N3AkoNllmMqR7hIdY8z200zCUA/xGTe+IIzM+6mK+hQ
	LW+uldt6qs96X4vF9LR9Lb0y2sX6KOk81f4LqR9Obg==
X-Google-Smtp-Source: ACHHUZ4+ueEwrwPaWigK7+YeuUL9hEfC0tZRofATY6ikA3Sl8/4yNnoNlTzMOCbPDhhk1woqWfBNd2TRmX5c8hXG6yE=
X-Received: by 2002:a05:600c:8512:b0:3f5:f63:d490 with SMTP id
 gw18-20020a05600c851200b003f50f63d490mr165943wmb.5.1685461714350; Tue, 30 May
 2023 08:48:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230529134430.492879-1-parav@nvidia.com> <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
In-Reply-To: <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 May 2023 17:48:22 +0200
Message-ID: <CANn89iLxUk6KpQ1a=Q+pNb95nkS6fYbHsuBGdxyTX23fuTGo6g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
To: David Ahern <dsahern@kernel.org>
Cc: Parav Pandit <parav@nvidia.com>, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 5:25=E2=80=AFPM David Ahern <dsahern@kernel.org> wr=
ote:
>
> On 5/29/23 7:44 AM, Parav Pandit wrote:
> > diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> > index 45dda7889387..88f9b0081ee7 100644
> > --- a/net/ipv4/tcp_offload.c
> > +++ b/net/ipv4/tcp_offload.c
> > @@ -296,7 +296,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *h=
ead, struct sk_buff *skb)
> >       return pp;
> >  }
> >
> > -int tcp_gro_complete(struct sk_buff *skb)
> > +void tcp_gro_complete(struct sk_buff *skb)
> >  {
> >       struct tcphdr *th =3D tcp_hdr(skb);
> >
> > @@ -311,8 +311,6 @@ int tcp_gro_complete(struct sk_buff *skb)
> >
> >       if (skb->encapsulation)
> >               skb->inner_transport_header =3D skb->transport_header;
> > -
> > -     return 0;
> >  }
> >  EXPORT_SYMBOL(tcp_gro_complete);
>
> tcp_gro_complete seems fairly trivial. Any reason not to make it an
> inline and avoid another function call in the datapath?

Probably, although it is a regular function call, not an indirect one.

In the grand total of driver rx napi + GRO cost, saving a few cycles
per GRO completed packet is quite small.

