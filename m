Return-Path: <netdev+bounces-11935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7F9373558B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:14:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04F111C2088E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF967C8CD;
	Mon, 19 Jun 2023 11:14:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D384EC146
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:14:51 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F95E94;
	Mon, 19 Jun 2023 04:14:50 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 38F385C0273;
	Mon, 19 Jun 2023 07:14:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 19 Jun 2023 07:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm2; t=1687173286; x=1687259686; bh=oi
	jxXR5PNPp5nmjwjO50BTIW1T7lI9DdXO0k2ZBn404=; b=yqrsAHe2b39hCHkWAf
	Y5Rw1e6V7JOHKbBKrxjK2mxPr1Cc9iR8jp4ZG8AHfgBE3DIwEzoAXn7LUbtzvSIn
	/ZtyhxJsrX53P/0GeuBvH2wYOjNBiddQUpJZC9rpJE0su415Wld9gVw79DJQcw6E
	/jjHMG0FNb2xUiSYT/XgPgNgXvcF5AgzkyhwJI+mSIMq/2dOpvOA5JL5eVg33v81
	R2VuQv3f+9hJuLzSzNuUAQEqKy1qeLMDKO5vY5kZbE2Za6oebgTHWOvRfH1hXKDi
	GeDsG5BrLguFnK8QbeFsm4+9izwbsXmGniwMiv36OHFx+xsBLo6NCYA/d2tHtNRL
	Ot3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; t=1687173286; x=1687259686; bh=oijxXR5PNPp5n
	mjwjO50BTIW1T7lI9DdXO0k2ZBn404=; b=mYffinqf8xdotv2iURcxvb3x72a+W
	GdqMfR57JgL5YYpG3MxYZ7Hijii5EVjUvEXS9aFFRPBiBQX6rW15QXwSyC9pWGfD
	2IUPY2NaHaTAQcU1Btcbh8q2p3MV64C/pWz9ejslsGuFjvw5sB/123ywr8qvZnu6
	ppX1otM1V2cxDNWmoonJzfzcGeWqRhp2hY53oQ9ojzQ3TlAzf7WcRGu6j2NH19fX
	2Z75oQdEl/UJvviahPuJ9l9RAw53VWMKgrFsYCZp+ED8mqtnK1yphztXU7L7o0ar
	vAaDoxJ4UMnRgMrSYBDHuhZ0E7zqQyQXLmUdllw/x2s8SP/jIDR4cAlFg==
X-ME-Sender: <xms:pTiQZEDr8QiOKUa-YMv1w9FTBMaq3sWKbcEKYlZCQ2bF-EY6vJ_d_g>
    <xme:pTiQZGjGUs8ytv3uWSWnssYDsO9zRJWEzi7hcysV5_XpNsLRqpxyzPFXdx5k_Pf59
    hhXwAr8TLFR_w>
X-ME-Received: <xmr:pTiQZHlCwLOYWjSx8ZYgnehAH3XTzbml_1A7Wuq3BmimALMceVH4pTNpF81bTEIo-nFnogsvKqH0qWaYvKU5d7DS36tHmIzKrk6OaC-vqqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefvddgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:pTiQZKxvBL_ZySKrDRF_ogO1SOmpSQ8xerJSQmfm_6oEITh1jm9xMw>
    <xmx:pTiQZJTYC6gm_kBFm5JMbENj45Lh4RXmDzu15lZ1To6b-wak03nhrw>
    <xmx:pTiQZFbL9rJLbALGsVNPSw9RFp1hkjd-lcReMLnMv1FQ9pPhTwbS8w>
    <xmx:pjiQZFq3DFeHFbXfjMq1ZrKNnLEb_RVTINj7-PmEEcLk5m-LbaC9tg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jun 2023 07:14:45 -0400 (EDT)
Date: Mon, 19 Jun 2023 13:14:42 +0200
From: Greg KH <greg@kroah.com>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: alice@ryhl.io, andrew@lunn.ch, kuba@kernel.org, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <2023061940-kindling-lagoon-3054@gregkh>
References: <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
 <20230619.175003.876496330266041709.ubuntu@gmail.com>
 <2023061940-rotting-frequency-765f@gregkh>
 <20230619.200559.1405325531450768221.ubuntu@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619.200559.1405325531450768221.ubuntu@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 08:05:59PM +0900, FUJITA Tomonori wrote:
> On Mon, 19 Jun 2023 11:46:38 +0200
> Greg KH <greg@kroah.com> wrote:
> 
> > On Mon, Jun 19, 2023 at 05:50:03PM +0900, FUJITA Tomonori wrote:
> >> Hi,
> >> 
> >> On Sat, 17 Jun 2023 12:08:26 +0200
> >> Alice Ryhl <alice@ryhl.io> wrote:
> >> 
> >> > On 6/16/23 22:04, Andrew Lunn wrote:
> >> >>> Yes, you can certainly put a WARN_ON in the destructor.
> >> >>>
> >> >>> Another possibility is to use a scope to clean up. I don't know
> >> >>> anything
> >> >>> about these skb objects are used, but you could have the user define a
> >> >>> "process this socket" function that you pass a pointer to the skb,
> >> >>> then make
> >> >>> the return value be something that explains what should be done with
> >> >>> the
> >> >>> packet. Since you must return a value of the right type, this forces
> >> >>> you to
> >> >>> choose.
> >> >>>
> >> >>> Of course, this requires that the processing of packets can be
> >> >>> expressed as
> >> >>> a function call, where it only inspects the packet for the duration of
> >> >>> that
> >> >>> function call. (Lifetimes can ensure that the skb pointer does not
> >> >>> escape
> >> >>> the function.)
> >> >>>
> >> >>> Would something like that work?
> >> >> I don't think so, at least not in the contest of an Rust Ethernet
> >> >> driver.
> >> >> There are two main flows.
> >> >> A packet is received. An skb is allocated and the received packet is
> >> >> placed into the skb. The Ethernet driver then hands the packet over to
> >> >> the network stack. The network stack is free to do whatever it wants
> >> >> with the packet. Things can go wrong within the driver, so at times it
> >> >> needs to free the skb rather than pass it to the network stack, which
> >> >> would be a drop.
> >> >> The second flow is that the network stack has a packet it wants sent
> >> >> out an Ethernet port, in the form of an skb. The skb gets passed to
> >> >> the Ethernet driver. The driver will do whatever it needs to do to
> >> >> pass the contents of the skb to the hardware. Once the hardware has
> >> >> it, the driver frees the skb. Again, things can go wrong and it needs
> >> >> to free the skb without sending it, which is a drop.
> >> >> So the lifetime is not a simple function call.
> >> >> The drop reason indicates why the packet was dropped. It should give
> >> >> some indication of what problem occurred which caused the drop. So
> >> >> ideally we don't want an anonymous drop. The C code does not enforce
> >> >> that, but it would be nice if the rust wrapper to dispose of an skb
> >> >> did enforce it.
> >> > 
> >> > It sounds like a destructor with WARN_ON is the best approach right
> >> > now.
> >> 
> >> Better to simply BUG()? We want to make sure that a device driver
> >> explicity calls a function that consumes a skb object (on tx path,
> >> e.g., napi_consume_skb()). If a device driver doesn't call such, it's
> >> a bug that should be found easily and fixed during the development. It
> >> would be even better if the compiler could find such though.
> > 
> > No, BUG() means "I have given up all hope here because the hardware is
> > broken and beyond repair so the machine will now crash and take all of
> > your data with it because I don't know how to properly recover".  That
> > should NEVER happen in a device driver, as that's very presumptious of
> > it, and means the driver itself is broken.
> > 
> > Report the error back up the chain and handle it properly, that's the
> > correct thing to do.
> 
> I see. Then netdev_warn() should be used instead.

Yes.

> Is it possible to handle the case where a device driver wrongly
> doesn't consume a skb object?

I have no idea as I do not know the network driver stack, sorry.

> >> If Rust bindings for netdev could help device developpers in such way,
> >> it's worth an experiments? because looks like netdev subsystem accepts
> >> more drivers for new hardware than other subsystems.
> > 
> > Have you looked at the IIO subsystem?  :)
> 
> No, I've not. Are there possible drivers that Rust could be useful
> for?

Who knows, you said you were looking for subsystems with lots and lots
of new drivers, and the IIO subsystem has over a thousand of them, all
just added in the past few years.

good luck!

greg k-h

