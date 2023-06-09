Return-Path: <netdev+bounces-9531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 122A3729A3C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:44:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 423D31C21136
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BB8107AD;
	Fri,  9 Jun 2023 12:44:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D867A1391
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:44:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53555210E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 05:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686314675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1D0oq4bkiQSNh/WxS0cST0cylLt83oOYP2HnPrT8pLk=;
	b=J9k0ySgEYfYqZV3QPy7IiI4t/pqAw4IBL0Li1CqEmTqQNF1oQvuDfVd6aNEFk7wf0EGASh
	9OrYgFlgHgHtUajzFdKIxgrkLMtm7A0eIIJGt+28tYSHKAoOZNoKiaM8PYShb1oMlpgH/o
	hhFLsFARAQpCeLnX5KRWYMWqMfSwfH4=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198--E23eCuwOlSpKjkQFW18kw-1; Fri, 09 Jun 2023 08:44:33 -0400
X-MC-Unique: -E23eCuwOlSpKjkQFW18kw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b1e84d7c41so10370631fa.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 05:44:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686314672; x=1688906672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1D0oq4bkiQSNh/WxS0cST0cylLt83oOYP2HnPrT8pLk=;
        b=EX+A4BulxdVcOaPpyVVRNXx6qqsYmLHsSoZVBkfvrbu7BZkgZE54hpNLonkv4i5ab8
         v/o++MPX32avIt/4cLUqMxchukm2VK3vE8Z0Qs29m85trb7xq+USxl1GogeG4/2HDDS7
         wfWZmeI8Yigg45xNTz6sAySrDpRBnbnbmf4Je028iW+hYrs5X/12bd0UTkEKJ0bWfHty
         EgGH/O8D+CalTQo2zsd24X06MSRgOoOLMwiwO3Sw2dVlkWg+jxjvlx16TxNNPSLBBYAh
         gqbBraXEykvfFBSZs5zzSL4z/T83UWWmr72GWwfJFP45O2AvYY2hPovTl2qS9Y4S0mPg
         7+Mg==
X-Gm-Message-State: AC+VfDxJJqGvw5akyJEEw8nfRMQ5TxJ/f75YH2EMXklPBBp2JJ2hcVMg
	vdBRjuTf7i0js+Q7EEyJLdf4itW7fZrY7KlPLO4NkjdNmteFOZ7HHKSPO30RIN6IfrZz61sKeUg
	W/R5FKT61RiIHF1ayopKNMvbLfQEv9LOI
X-Received: by 2002:a2e:a405:0:b0:2b0:2976:1726 with SMTP id p5-20020a2ea405000000b002b029761726mr1116837ljn.10.1686314672204;
        Fri, 09 Jun 2023 05:44:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6sFWPYqUSBPBuEZ0F4dv6BskilTIAzCtaduHNn8wPrjPk4XKy5HJ+ex9R8wdBIWdb0npr/yh8MBRoU23WTRrU=
X-Received: by 2002:a2e:a405:0:b0:2b0:2976:1726 with SMTP id
 p5-20020a2ea405000000b002b029761726mr1116826ljn.10.1686314671844; Fri, 09 Jun
 2023 05:44:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de> <20230608140246.15190-3-fw@strlen.de>
 <CAKa-r6uyObXeAUTj28=f+V8BvrUQpXGP12JHRikct3SB=x48GA@mail.gmail.com> <20230608183431.GF27126@breakpoint.cc>
In-Reply-To: <20230608183431.GF27126@breakpoint.cc>
From: Davide Caratti <dcaratti@redhat.com>
Date: Fri, 9 Jun 2023 14:44:20 +0200
Message-ID: <CAKa-r6vsyzTOgwBFWiTkgTfm1u6jgSPST7C4mUZzL4SrVDA7rQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net/sched: act_ipt: add sanity checks on skb
 before calling target
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, jhs@mojatatu.com, 
	xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 8:34=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Davide Caratti <dcaratti@redhat.com> wrote:
> > hello Florian,
> >
> > On Thu, Jun 8, 2023 at 4:04=E2=80=AFPM Florian Westphal <fw@strlen.de> =
wrote:
> > >
> > > @@ -244,9 +264,22 @@ TC_INDIRECT_SCOPE int tcf_ipt_act(struct sk_buff=
 *skb,
> > >                 .pf     =3D NFPROTO_IPV4,
> > >         };
> > >
> > > +       if (skb->protocol !=3D htons(ETH_P_IP))
> > > +               return TC_ACT_UNSPEC;
> > > +
> >
> > maybe this can be converted to skb_protocol(skb, ...)  so that it's
> > clear how VLAN packets are treated ?
>
> Not sure how to handle this.
>
> act_ipt claims NFPROTO_IPV4; for iptables/nftables one has to use
> the interface name ("-i vlan0") to match on the vlan interface.
>
> I don't really want to add code that pulls/pops the vlan headers
> in act_ipt...

then probably we can just call

skb_protocol(skb, false)

and check if it's equal to htons(ETH_P_IP):
In this case it will use skb->protocol or skb->vlan_proto (if the tag
is "accelerated") - no recursive QinQ lookup. WDYT?
thanks,
--=20
davide


