Return-Path: <netdev+bounces-11904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4AA97350C6
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17D24280DAC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43296C2E0;
	Mon, 19 Jun 2023 09:46:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301E4BE6C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:46:46 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BD01B5;
	Mon, 19 Jun 2023 02:46:41 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 5AE7A5C010E;
	Mon, 19 Jun 2023 05:46:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 19 Jun 2023 05:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1687168001; x=1687254401; bh=6v
	RC2nFEMSkixfqH22jnDf8VaqJ2zh8vIMgMoTo5Afg=; b=VeoZK6pRuBh2mpGnNx
	WiCLK3iKEi2+QqabTs6UnDONoXkcUoQYnGHMJVzA7HGVsIGUBdp3XiatzHPsD0bw
	F7RsRTYPCXKum3kJL4o9mllR282+nBFoQT953M7uPX7Dvpk1Y5+IlGAQvpi3X7m5
	rI4/4TkJlxQPuw22K2j290KpD5OVDNiv/IcZkS1ZL1TfUAPvANJnB//V8Ac9BXm4
	qlIw/tje9xyAgfRqIkUsdp50lMrFGxo0/Hde6A5lcun2FmDpaFvOmU4kmLKqbang
	GYWHIzPjJQQnKoH98HdMaHgGlZX9azum+NUu8GD0mwhEdMfFZHs+/0NOpGC1b4jm
	MMDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1687168001; x=1687254401; bh=6vRC2nFEMSkix
	fqH22jnDf8VaqJ2zh8vIMgMoTo5Afg=; b=aBFvPF3v8B++X97DfiAIV6gB5eiFl
	1PbNKJnR6jPC7zD7dONmxyREoLy6Cksny5+0cyrgdSguNQiZo5aRvYHmr1xAgwZA
	GQgLR1TQbJMjZ1LNxb4K5slnkAJwhIc51to0IOFLulWgu8pi4mQ2RgrygwsO/8iB
	G9UGVorH/JcQ2iUpicnLNd/E438uhX48Mw+kSY1/jZviCrtRMH+ZHf3qm+kjZZDI
	7mkC1VWmAg8pnSDDLvqo4yNBWLaADQj5T4E9lClV+mUkcwZU1KACOd0VZUcLUpzo
	+QA6Knxp1Nry9IvivPEuhRnDcwX5WnlY1CnPEP6com5qD+hOxbCSN3VoQ==
X-ME-Sender: <xms:ASSQZK53sDCC7eTuRia2j2_JAINW-VW5Q2Ju0jEUBll53TdNPi5s1g>
    <xme:ASSQZD5lB8eWuYmR9bmO1Vl1rV0kITIJhReNXvhm7ZW9ujN9dYw1eFj6aooQ0UZbm
    0QxSLafTLEnUA>
X-ME-Received: <xmr:ASSQZJcnpHNabsURKG4qeSlSZl9a7rD3MO7tp5NErisNrZtbDp392QBtDCY74a2tKkXgGTQomzD93XghfcuyTrU8Uqm6HTjovRanEBjGJxs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:ASSQZHLxjW5dS-x91oiAcZ2jtwcwACzko0N0i9kupbLbjR2ScR65Bg>
    <xmx:ASSQZOL9t0azlygppYzwBhH9fsR0to8Bz1cYUuaDv3SVGNPZge_N4w>
    <xmx:ASSQZIzBrvMooGT53Q2CtJFIIFE6LmFflnVJ6kucY3i69OrhtLyWkQ>
    <xmx:ASSQZAiLBrvYNyP8MperIXW4wMtIb9zVm6iNaRVmyXD-b5ad7_2-xQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jun 2023 05:46:40 -0400 (EDT)
Date: Mon, 19 Jun 2023 11:46:38 +0200
From: Greg KH <greg@kroah.com>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: alice@ryhl.io, andrew@lunn.ch, kuba@kernel.org, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <2023061940-rotting-frequency-765f@gregkh>
References: <053cb4c3-aab1-23b3-56e3-4f1741e69404@ryhl.io>
 <7dbf3c85-02ca-4c9b-b40d-adcdb85305dd@lunn.ch>
 <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
 <20230619.175003.876496330266041709.ubuntu@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619.175003.876496330266041709.ubuntu@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 05:50:03PM +0900, FUJITA Tomonori wrote:
> Hi,
> 
> On Sat, 17 Jun 2023 12:08:26 +0200
> Alice Ryhl <alice@ryhl.io> wrote:
> 
> > On 6/16/23 22:04, Andrew Lunn wrote:
> >>> Yes, you can certainly put a WARN_ON in the destructor.
> >>>
> >>> Another possibility is to use a scope to clean up. I don't know
> >>> anything
> >>> about these skb objects are used, but you could have the user define a
> >>> "process this socket" function that you pass a pointer to the skb,
> >>> then make
> >>> the return value be something that explains what should be done with
> >>> the
> >>> packet. Since you must return a value of the right type, this forces
> >>> you to
> >>> choose.
> >>>
> >>> Of course, this requires that the processing of packets can be
> >>> expressed as
> >>> a function call, where it only inspects the packet for the duration of
> >>> that
> >>> function call. (Lifetimes can ensure that the skb pointer does not
> >>> escape
> >>> the function.)
> >>>
> >>> Would something like that work?
> >> I don't think so, at least not in the contest of an Rust Ethernet
> >> driver.
> >> There are two main flows.
> >> A packet is received. An skb is allocated and the received packet is
> >> placed into the skb. The Ethernet driver then hands the packet over to
> >> the network stack. The network stack is free to do whatever it wants
> >> with the packet. Things can go wrong within the driver, so at times it
> >> needs to free the skb rather than pass it to the network stack, which
> >> would be a drop.
> >> The second flow is that the network stack has a packet it wants sent
> >> out an Ethernet port, in the form of an skb. The skb gets passed to
> >> the Ethernet driver. The driver will do whatever it needs to do to
> >> pass the contents of the skb to the hardware. Once the hardware has
> >> it, the driver frees the skb. Again, things can go wrong and it needs
> >> to free the skb without sending it, which is a drop.
> >> So the lifetime is not a simple function call.
> >> The drop reason indicates why the packet was dropped. It should give
> >> some indication of what problem occurred which caused the drop. So
> >> ideally we don't want an anonymous drop. The C code does not enforce
> >> that, but it would be nice if the rust wrapper to dispose of an skb
> >> did enforce it.
> > 
> > It sounds like a destructor with WARN_ON is the best approach right
> > now.
> 
> Better to simply BUG()? We want to make sure that a device driver
> explicity calls a function that consumes a skb object (on tx path,
> e.g., napi_consume_skb()). If a device driver doesn't call such, it's
> a bug that should be found easily and fixed during the development. It
> would be even better if the compiler could find such though.

No, BUG() means "I have given up all hope here because the hardware is
broken and beyond repair so the machine will now crash and take all of
your data with it because I don't know how to properly recover".  That
should NEVER happen in a device driver, as that's very presumptious of
it, and means the driver itself is broken.

Report the error back up the chain and handle it properly, that's the
correct thing to do.

> If Rust bindings for netdev could help device developpers in such way,
> it's worth an experiments? because looks like netdev subsystem accepts
> more drivers for new hardware than other subsystems.

Have you looked at the IIO subsystem?  :)

thanks,

greg k-h

