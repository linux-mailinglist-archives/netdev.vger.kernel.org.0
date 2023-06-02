Return-Path: <netdev+bounces-7397-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D93D5720065
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 13:29:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68E521C20C1D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E45182CF;
	Fri,  2 Jun 2023 11:29:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1846107B1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 11:29:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576991A1
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 04:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685705356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5O5N0TyyMY0AmUwL9aXlrKkbB93l6CptL3vOxA2D70=;
	b=M9CGJRPTslASNmFjROMQKVWjz1sUK90wiNyuoBsKcmnZ5cHirs6+uBpKXXwJKfwaoWuOzR
	3Rina7yT4AorXNY48sVPHrFYgs+KlV+ai/aY1YW6knXWlJ9mvXI3EvJfqf9zi9KUi6crwd
	XeIXRyr1fFVG6hS4lGjRwH58Ica0Hsw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-eXGwcvcaMq6FoWXYH2I1PQ-1; Fri, 02 Jun 2023 07:29:15 -0400
X-MC-Unique: eXGwcvcaMq6FoWXYH2I1PQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f613f5d290so32630295e9.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 04:29:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685705354; x=1688297354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m5O5N0TyyMY0AmUwL9aXlrKkbB93l6CptL3vOxA2D70=;
        b=lAeSH/BE5wQN0AnjSYv7VTYeOdQ5HUdDtqfbmqsN1Bo0jUJ6D3ig7V9izvnqnT6oR8
         zsY4sBPL5o4nyIRc5b6y+etajpryx+JJIyEW/gRn4vUFDQ6AI60b07lGAB9vQccVmo3M
         dzwFYOFPoahSo73Bz7L7KdWI6ikQ/4sh2IB1URAnJ9F/qWjvI+XwAtfWXTT5mBxw/hgj
         05rmyaeBx7WT4S5GVr8bbuiuIjT0Ez7GR3UL5uVy/FBk9Q8t211POOXhw8fEnYP11Tj0
         VMSyjb8oWWjUz8FsNrpJKf8z7CBz7rgLUnh1yNe/56e06q+vfNZ8xl63Htyr6npavxAQ
         fXTA==
X-Gm-Message-State: AC+VfDySDwAmU3TyhsnbXsOoozBaNyTp2AtELwqCYc3S6teFN0dy+WsZ
	PaMRfXB/XEhMbhMzRsHIhFO+L68JdSpeTvY9LAtl34SuvuAlpohCQF5VRWJXCWkfFjym3XErVSH
	DHfGvgm0dZJQSNnS3
X-Received: by 2002:a7b:c40e:0:b0:3f6:692:5607 with SMTP id k14-20020a7bc40e000000b003f606925607mr1556945wmi.40.1685705354400;
        Fri, 02 Jun 2023 04:29:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4dcPqFDvHV3ct60ARjBBFoyUN3UqVLOgErABUb/MJcY8uYWEWljv/fngcidmqyYie7j4vLsQ==
X-Received: by 2002:a7b:c40e:0:b0:3f6:692:5607 with SMTP id k14-20020a7bc40e000000b003f606925607mr1556931wmi.40.1685705354099;
        Fri, 02 Jun 2023 04:29:14 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d40ce000000b002e5ff05765esm1441961wrq.73.2023.06.02.04.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 04:29:13 -0700 (PDT)
Date: Fri, 2 Jun 2023 07:29:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc: "jasowang@redhat.com" <jasowang@redhat.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 0/3] virtio-net: allow usage of small vrings
Message-ID: <20230602072138-mutt-send-email-mst@kernel.org>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430100535-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723C479C388266434DE415ED4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230501062107-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723E9A0AED11B60360D27C2D46E9@AM0PR04MB4723.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723E9A0AED11B60360D27C2D46E9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 01, 2023 at 11:41:44AM +0000, Alvaro Karsz wrote:
> > > > Why the difference?
> > > >
> > >
> > > Because the RING_SIZE < 4 case requires much more adjustments.
> > >
> > > * We may need to squeeze the virtio header into the headroom.
> > > * We may need to squeeze the GSO header into the headroom, or block the features.
> > 
> > We alread do this though no?
> > I think we'll need to tweak hard_header_len to guarantee it's there
> > as opposed to needed_headroom ...
> > 
> > > * At the moment, without NETIF_F_SG, we can receive a skb with 2 segments, we may need to reduce it to 1.
> > 
> > You are saying clearing NETIF_F_SG does not guarantee a linear skb?
> > 
> 
> I don't know..
> I'm not sure what is the cause, but using this patchset, without any host GSO feature, I can get a chain of 3 descriptors.
> Posing an example of a 4 entries ring during iperf3, acting as a client:
> (TX descriptors)
> 
> len=86       flags 0x1         addr 0xf738d000
> len=1448   flags 0x0         addr 0xf738d800
> len=86       flags 0x8081   addr 0xf738e000
> len=1184,   flags 0x8081  addr 0xf738e800
> len=264     flags 0x8080   addr 0xf738f000
> len=86       flags 0x8081   addr 0xf738f800
> len=1448   flags 0x0         addr 0xf7390000
> len=86       flags 0x1         addr 0xf7390800
> len=1448   flags 0x0         addr 0xf7391000
> len=86       flags 0x1         addr 0xf716a800
> len=1448   flags 0x8080   addr 0xf716b000
> len=86       flags 0x8081   addr 0xf7391800
> len=1448   flags 0x8080   addr 0xf7392000
> 
> We got a chain of 3 in here.
> This happens often.
> 
> Now, when negotiating host GSO features, I can get up to 4:
> 
> len=86       flags 0x1         addr 0xf71fc800
> len=21328 flags 0x1         addr 0xf6e00800
> len=32768 flags 0x8081   addr 0xf6e06000
> len=11064 flags 0x8080   addr 0xf6e0e000
> len=86       flags 0x8081   addr 0xf738b000
> len=1         flags 0x8080   addr 0xf738b800
> len=86       flags 0x1         addr 0xf738c000
> len=21704 flags 0x1         addr 0xf738c800
> len=32768 flags 0x1         addr 0xf7392000
> len=10688 flags 0x0         addr 0xf739a000
> len=86       flags 0x8081   addr 0xf739d000
> len=22080 flags 0x8081   addr 0xf739d800
> len=32768 flags 0x8081   addr 0xf73a3000
> len=10312 flags 0x8080   addr 0xf73ab000
> 
> TBH, I thought that this behaviour was expected until you mentioned it,
> This is why virtnet_calc_max_descs returns 3 if no host_gso feature is negotiated, and 4 otherwise.
> I was thinking that we may need to use another skb to hold the TSO template (for headers generation)...
> 
> Any ideas?

Something's wrong with the code apparently. Want to try sticking
printk's in the driver to see what is going on?

Documentation/networking/netdev-features.rst says:
	Those features say that ndo_start_xmit can handle fragmented skbs:
	NETIF_F_SG --- paged skbs (skb_shinfo()->frags), NETIF_F_FRAGLIST ---
	chained skbs (skb->next/prev list).


of course we can always linearize if we want to ...


> > > * We may need to change all the control commands, so class,  command and command specific data will fit in a single segment.
> > > * We may need to disable the control command and all the features depending on it.
> > 
> > well if we don't commands just fail as we can't add them right?
> > no corruption or stalls ...
> > 
> > > * We may need to disable NAPI?
> > 
> > hmm why napi?
> > 
> 
> I'm not sure if it's required to disable it, but I'm not sure what's the point having napi if the ring size is 1..
> Will it work?

Not much point in it but it's simpler to just keep things consistent.

> > > There may be more changes..
> > >
> > > I was thinking that it may be easier to start with the easier case RING_SIZE >= 4, make sure everything is working fine, then send a follow up patchset with the required adjustments for RING_SIZE < 4.
> > 
> > 
> > it's ok but I'm just trying to figure out where does 4 come from.
> > 
> 
> I guess this part was not clear, sorry..
> In case of split vqs, we have ring size 2 before 4.
> And as you saw, we still get chains of 3 when NETIF_F_SG is off (Which I thought was expected).
> 

Worth figuring out where do these come from.

-- 
MST


