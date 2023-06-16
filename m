Return-Path: <netdev+bounces-11444-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 95FF273321D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7A4D1C20EC5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709591642E;
	Fri, 16 Jun 2023 13:24:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62009156C1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:24:06 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17AD35A2;
	Fri, 16 Jun 2023 06:24:03 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 52B405C008C;
	Fri, 16 Jun 2023 09:24:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 16 Jun 2023 09:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1686921843; x=1687008243; bh=4t05MCAWyt7rn2V/DbGOJJxi63K+xq8WoOL
	N9DHTCP0=; b=kn3BwIyCn4liDU+GTJrEOapylxG03oZcNUmrFkZSG8BlLYSEwZk
	gnm9cbkdHIAWqzVXSpw9fjQ0Q5KpCicf/ephL+UBOjZvFIwVESmE2Q56IZEKRA6B
	uZKo+Ku11zph4T7vytpmRzh4ihCiZlAYCD+Js3Ywxr8lF9m+W/2nmYvY4zX6Eymr
	CiJdszCL/haYAfRnYxO9Fift3RRL8ibknVNPsRkg924WvFvCXK9edOZ/1+QLjoWA
	INDNVo55q+IYs2o8ksttYhc4Ejqlm1BvBNnMfl1dcBFR/LFB/dktmyH7KiMqoZQI
	v/QNaexkUI6MhSo9m3pGDxV5gh3THw3BjrQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1686921843; x=1687008243; bh=4t05MCAWyt7rn2V/DbGOJJxi63K+xq8WoOL
	N9DHTCP0=; b=p336LSKVXB2Gyb3hokPT6x0bRMFRqLO8YQuupgaCJsxn2pkMm3e
	fE2TbAOUUFbHX4Jmbg/ivv63puHk6pi3AWGLpVCYoYbaYO2BOqhvlKnvPii5amK5
	WvCblsSTyTIEhx0X69VwZgZ//INMwK7pL4f/K+0ljY85Pu2bxKnldw0AujHSYhSg
	W6Yu8zGZbU8l6SkVDS37PkNQSEbTlNWDLGzP48K6FMLohj/EIfTFtBoFJMgwN6Qy
	W9mTxTJkYN2iWH3srSiulca3Co5OwDsYpV7NaLBD+QhD/pmufTvcGdhErIVCRPix
	sd5VDsx1XJasZJLXu6dfIwChgi0XHlcwHZA==
X-ME-Sender: <xms:c2KMZJQlxKosI1Fbn_yZfxmpnoVABjYRY54Rm3OJFpXMONvPmlvnOw>
    <xme:c2KMZCwUrTPoZWIUE3HKPWfEgrh4EuRS0PxGkkEtL1gkNANWx-PdKbwDpsBTnxKHn
    _liSfZ3hiBbF-3xQg>
X-ME-Received: <xmr:c2KMZO12wTjEa3X6qZtIGmJ1Qg_l1sso2IMNIwzhvEXJSInWAhs71QRZe81TwAXY3ipWjCVjeTIFryy6HYLfHTVZVqie5reU-m1CoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeetlhhi
    tggvucfthihhlhcuoegrlhhitggvsehrhihhlhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudduvdetkedvkedtudeludfgfffhudegjeeguedvvedtteevjeehheeiffefgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhitggvse
    hrhihhlhdrihho
X-ME-Proxy: <xmx:c2KMZBD9l2jcicpmexzWEBYLeWFDvi8y7gfnbUPTcD3M2qCd-vxGSA>
    <xmx:c2KMZCjkFn21fZkDA4Bu4jLsMLE2zJXYVDtby7M8K7yfD4axAcvLcQ>
    <xmx:c2KMZFqxgVkBaDkfMdVzsS3Ok0wPIKpOJt1V_SlWbXb7oyXuC6BjEQ>
    <xmx:c2KMZEbhy1eV6zH31bvqu71XOIg9_DJHzRf8Ou7bY9QQ2XTB1yxylw>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jun 2023 09:24:01 -0400 (EDT)
Message-ID: <838805e5-c2a6-e3f3-d2e7-d435f07b9bda@ryhl.io>
Date: Fri, 16 Jun 2023 15:24:43 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 rust-for-linux@vger.kernel.org, aliceryhl@google.com,
 miguel.ojeda.sandonis@gmail.com, FUJITA Tomonori <fujita.tomonori@gmail.com>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
 <20230614230128.199724bd@kernel.org>
 <0d0eba7d-ac43-d944-d105-008978f4402e@ryhl.io>
 <762a7d75-2ed8-4f29-b8e5-c90305275c9e@lunn.ch>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <762a7d75-2ed8-4f29-b8e5-c90305275c9e@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/23 15:20, Andrew Lunn wrote:
>> As for this being a single function rather than four functions, that's
>> definitely a debatable decision. You would only do that if it makes sense to
>> merge them together and if you would always assign all of them together. I
>> don't know enough about these fields to say whether it makes sense here.
> 
> It can actually make sense to do them all together, because the source
> of these is likely to be a per CPU data structure protected by a per
> CPU sequence lock. You iterate over all CPUs, doing a transaction,
> taking the sequence lock, copy the values, and then releasing the
> lock. Taking and releases the lock per value is unnecessary expense.

It can probably be split into several methods without introducing a lock 
call for each one, if the API is designed right.

Alice

