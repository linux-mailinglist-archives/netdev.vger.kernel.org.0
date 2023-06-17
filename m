Return-Path: <netdev+bounces-11708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66AEC734007
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 794571C20A7D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 10:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4784A6FD9;
	Sat, 17 Jun 2023 10:07:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361666FAE
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 10:07:54 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE93115;
	Sat, 17 Jun 2023 03:07:52 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.west.internal (Postfix) with ESMTP id 794F7320090D;
	Sat, 17 Jun 2023 06:07:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 17 Jun 2023 06:07:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1686996467; x=1687082867; bh=fdy8Nxxcv9L88NlcC7koLpID+PVBjheubRG
	k1mIhVzY=; b=V01hnXjrgd04zMLD4LNpCeRUjyc52LRH7GxqnPAKOggf5bSezyH
	0c8Dea3wGx7qe7KCaaDoM0C2FZaA33gBRpk3CB2IXXEwfewoIlB1mgoC/2Pn+P9m
	5CmRr4ek1J271ifosX5yDo2Zio0PQi856r61ojaLFX35SsZpqfvgbitZHyv952A8
	xdGFRs3Z5XSp6sxSUc0YAOvJsuYPoVZAZe1w8J1pbFSU4Q2ihJ15g6dgoL2CDnGx
	6ixXl2KtWU9KzT40hmV+6vNejY6NNQwuLe/rRP01BFoEUNtX8UU6lOxLQtC8mgJr
	AXjyTls+txLWynd0DgavOrFK1czTEPEwz2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1686996467; x=1687082867; bh=fdy8Nxxcv9L88NlcC7koLpID+PVBjheubRG
	k1mIhVzY=; b=qQc0zIfLW9diIyGid+kpBRXWblJ+0nMMO3ak256cRkuCu18Gl4x
	7m1Fz6b5c1kE7FmYtLb5KNLLSyggkT6J5KGOe2+dm9SGp4uMcoLhSy01z/cnxBYP
	gmD4NLti2e14YDmFKC+2Yjuv+CW6IfDI+Bfoh7x2gVyBw688UqLZ39cGbJ/5MKNr
	aVEa8Q8xgw+vMJSl775XH7ROoaykgosBWh4E2I5+km9vjNDlksaUOXA7SGesQX/q
	bJvRP+1Bv8KaK9Rob8hKbAe4O1mcZ94PHLrN747dXVDHBvRix/o5nrnhrzgIDZ0o
	jh0+W5GruyZyX733RDSq2filcLPJqRxaamw==
X-ME-Sender: <xms:8oWNZENgvmAkRo8xhBHdwbUkDOZxfI38vh6UlQzFCne7Xabe3yUzrw>
    <xme:8oWNZK9KRVtpxW7YUAuXToaHsd_WKwdtZ_x82srH0kkgt2vBv-l8PWm6j4UbLwEOX
    u-Ouw2n-6CELkNOOA>
X-ME-Received: <xmr:8oWNZLReTrAty37bqNLG19JW3-Lu5V9DR8xziXo5zB0gtVCaVj8mAUoR9Gv9_kn7pnhPZLigtgqPDBXy9gceqmO-8qhJ2twajuvmpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvjedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfhffuvfevfhgjtgfgsehtjeertddtfeejnecuhfhrohhmpeetlhhi
    tggvucfthihhlhcuoegrlhhitggvsehrhihhlhdrihhoqeenucggtffrrghtthgvrhhnpe
    fhheeuieelveejfeektedvffevffduuefhgfetvdeugfeigfeivdejgedvjeeljeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhitggvse
    hrhihhlhdrihho
X-ME-Proxy: <xmx:8oWNZMt2RyV78peCLlIRmdZdPTtOhIyGOb9asWV9O92JYmI-s8tFPg>
    <xmx:8oWNZMe6j919nxeCZGg8-jy364MSvJX84ewmSsBeaLmE231eHKuXlw>
    <xmx:8oWNZA3tW7qSymdnwx10aFZeIUZ66qfeFJ0n_yvuItQQwI3QSU1N4w>
    <xmx:84WNZBEeMpF2-LXl-bCXx2_7WNvK9cY9DjVW3ivll0lxZ9UAOtpybQ>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 17 Jun 2023 06:07:44 -0400 (EDT)
Message-ID: <c1b23f21-d161-6241-26fb-7a2cbc4c059c@ryhl.io>
Date: Sat, 17 Jun 2023 12:08:26 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: Alice Ryhl <alice@ryhl.io>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>,
 FUJITA Tomonori <fujita.tomonori@gmail.com>, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, aliceryhl@google.com,
 miguel.ojeda.sandonis@gmail.com
References: <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <20230616114006.3a2a09e5@kernel.org>
 <66dcc87e-e03f-1043-c91d-25d6fa7130a1@ryhl.io>
 <20230616121041.4010f51b@kernel.org>
 <053cb4c3-aab1-23b3-56e3-4f1741e69404@ryhl.io>
 <7dbf3c85-02ca-4c9b-b40d-adcdb85305dd@lunn.ch>
Content-Language: en-US, da
In-Reply-To: <7dbf3c85-02ca-4c9b-b40d-adcdb85305dd@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/23 22:04, Andrew Lunn wrote:
>> Yes, you can certainly put a WARN_ON in the destructor.
>>
>> Another possibility is to use a scope to clean up. I don't know anything
>> about these skb objects are used, but you could have the user define a
>> "process this socket" function that you pass a pointer to the skb, then make
>> the return value be something that explains what should be done with the
>> packet. Since you must return a value of the right type, this forces you to
>> choose.
>>
>> Of course, this requires that the processing of packets can be expressed as
>> a function call, where it only inspects the packet for the duration of that
>> function call. (Lifetimes can ensure that the skb pointer does not escape
>> the function.)
>>
>> Would something like that work?
> 
> I don't think so, at least not in the contest of an Rust Ethernet
> driver.
> 
> There are two main flows.
> 
> A packet is received. An skb is allocated and the received packet is
> placed into the skb. The Ethernet driver then hands the packet over to
> the network stack. The network stack is free to do whatever it wants
> with the packet. Things can go wrong within the driver, so at times it
> needs to free the skb rather than pass it to the network stack, which
> would be a drop.
> 
> The second flow is that the network stack has a packet it wants sent
> out an Ethernet port, in the form of an skb. The skb gets passed to
> the Ethernet driver. The driver will do whatever it needs to do to
> pass the contents of the skb to the hardware. Once the hardware has
> it, the driver frees the skb. Again, things can go wrong and it needs
> to free the skb without sending it, which is a drop.
> 
> So the lifetime is not a simple function call.
> 
> The drop reason indicates why the packet was dropped. It should give
> some indication of what problem occurred which caused the drop. So
> ideally we don't want an anonymous drop. The C code does not enforce
> that, but it would be nice if the rust wrapper to dispose of an skb
> did enforce it.

It sounds like a destructor with WARN_ON is the best approach right now.

Unfortunately, I don't think we can enforce that the destructor is not 
used today. That said, in the future it may be possible to implement a 
linter that detects it - I know that there have already been experiments 
with other custom lints for the kernel (e.g., enforcing that you don't 
sleep while holding a spinlock).

> I would also say that this dummy driver and the C dummy driver is
> actually wrong in 'dropping' the frame. Its whole purpose in life is to
> be a black hole. It should only drop the packet if for some reason it
> cannot throw the packet into the black hole.

Ah, I suppose that we would also need a "by value" cleanup method for 
that case.

Alice

