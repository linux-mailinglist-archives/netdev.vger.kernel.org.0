Return-Path: <netdev+bounces-11552-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2D087338A7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72B4728046B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6731DCBD;
	Fri, 16 Jun 2023 19:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4151DCB9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:00:20 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC823A9F;
	Fri, 16 Jun 2023 12:00:02 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id B668C5C0289;
	Fri, 16 Jun 2023 14:59:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 16 Jun 2023 14:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1686941995; x=1687028395; bh=V+c6CBDNkCbYKeSq99iOXAk5iH1MqkXVSh1
	tyFCMAZQ=; b=Bi1sqZyD0uQP1JIngGrZN/D0mTqyfOoRP+FoOSyw9luhImApcqR
	enK2AiUb5LqLY9Dw6BbQE/nya3OOx9JYMARR+RA/23yF0Vz/x2rfKLPfl6Tcaw02
	ECZcBj/Ccypb/iVkZCd4z6i435tA7BVPiO7Ch6pVuBjTTSUHPh5vi+n8Lz0ERPSl
	nfWpxGnbWLo2yUqn0OHzrgj2oR1QhhlgBnKstmp6GEdck2gSRTcQIc/q0QT7tzLd
	+ZyYhVXmDkdwCbT6/na2RNu7c5MPnyqEnNE56tw1JuySYAZbC1/6Iyv7K7cv+LfI
	IijofY+lqOj80iczKXT8fQ01n/ieXA143AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1686941995; x=1687028395; bh=V+c6CBDNkCbYKeSq99iOXAk5iH1MqkXVSh1
	tyFCMAZQ=; b=Zfe/h1p/LhktE7ivkmmzCDjIq3XG7NO65P86SeR2fwVI4jFzNYp
	XHyuyNPRjfvh2oHZL9J/iE4fE2ggo6eOYOYLTaCB/0gZNYt+I5B5+iomPqLUsVj6
	HcbiOURquW9CyxWsqUOX5zGiUc8WZW2H0LcfjDwVA+FLgVFKD9NNA8MGRO68tYSp
	quFTJ0ANnsGGRs9Hv1v9tUsSKoeGWqtw6WgIN0CVCSkFSWLYgEXvxYkx/Lqf+lpH
	wbe7LTIY2+f/S91Nbzi2J4DZfBl377CFQaw9+TQm7hTpg/s8w6BIQb2rcaEVG97P
	SoFy9YtA0w5YnZ/QVpcPQNI3K0SzPPVeyRQ==
X-ME-Sender: <xms:K7GMZBRgI-_AY5oXSYVoMnXnbYi0x-mIrcSoYbjqOrtpckSDEkTMYA>
    <xme:K7GMZKz8x8zsr3WupxoI5bOW1rfYON8BJk59Vw7bIsEGKm6iuRZmdL67UfuhRa0h5
    5MGAQ1ZwRTYkkCuyw>
X-ME-Received: <xmr:K7GMZG11GezR5FPnMoUQJnX_xAM7sj9_D7E9whWMiYgMOgRRttH0xH78cunRfT6CWmm6uJVHGI2aUAjqntLfWSCS2ir1gg759onPZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    epheduuddvteekvdektdduledugfffhfdugeejgeeuvdevtdetveejheehiefffeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:K7GMZJBZtnERINeX5uu2Ep_jVzUYwN2cNSaM2vo4FecWmKboxlcb1g>
    <xmx:K7GMZKhGH-wudRTcl45seU8X-r57dpvjT-e926-jhPHmTnP-Jgi94A>
    <xmx:K7GMZNqhkvY_PhPbYHzcZhYNRwcrawfAdcZz1UleFeNUsGRU5dwZoQ>
    <xmx:K7GMZMaVw_1mWLuSERh8Uja_8SMb4S1KOLAek7qXxos82pH3SaHIpQ>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jun 2023 14:59:53 -0400 (EDT)
Message-ID: <66dcc87e-e03f-1043-c91d-25d6fa7130a1@ryhl.io>
Date: Fri, 16 Jun 2023 21:00:36 +0200
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
To: Jakub Kicinski <kuba@kernel.org>,
 FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: andrew@lunn.ch, netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
References: <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <20230616114006.3a2a09e5@kernel.org>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <20230616114006.3a2a09e5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/23 20:40, Jakub Kicinski wrote:
> On Fri, 16 Jun 2023 22:02:20 +0900 (JST) FUJITA Tomonori wrote:
>>> The skb freeing looks shady from functional perspective.
>>> I'm guessing some form of destructor frees the skb automatically
>>> in xmit handler(?), but (a) no reason support, (b) kfree_skb_reason()
>>> is most certainly not safe to call on all xmit paths...
>>
>> Yeah, I assume that a driver keeps a skb in private data structure
>> (such as tx ring) then removes the skb from it after the completion of
>> tx; automatically the drop() method runs (where we need to free the
>> skb).
>>
>> I thought that calling dev_kfree_skb() is fine but no? We also need
>> something different for drivers that use other ways to free the skb
>> though.
>>
>> I use kfree_skb_reason() because dev_kfree_skb() is a macro so it
>> can't be called directly from Rust. But I should have used
>> dev_kfree_skb() with a helper function.
> 
> skbs (generally) can't be freed in an interrupt context.
> dev_kfree_skb_any_reason() is probably the most general implementation.
> But then we also have a set of functions used in known contexts for fast
> object recycling like napi_consume_skb().
> How would complex object destruction rules fit in in the Rust world?

A Rust method can be defined to take the struct "by value", which 
consumes the struct and prevents you from using it again. This can let 
you provide many different cleanup methods that each clean it up in 
different ways.

However, you cannot force the user to use one of those methods. They 
always have the option of letting the value go out of scope, which calls 
the destructor. And they can do this at any time.

That said, the destructor of the value does not necessarily *have* to 
translate to immediately freeing the value. If the value if refcounted, 
the destructor could just drop the refcount. It would also be possible 
for a destructor to schedule the cleanup operation to a workqueue. Or 
you could do something more clever.

Alice

