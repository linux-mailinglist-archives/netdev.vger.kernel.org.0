Return-Path: <netdev+bounces-11559-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC867339E3
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 21:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DDBA2817AB
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8900B1E528;
	Fri, 16 Jun 2023 19:30:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784531ACDB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:30:56 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C84205;
	Fri, 16 Jun 2023 12:30:52 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id E37585C0158;
	Fri, 16 Jun 2023 15:22:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 16 Jun 2023 15:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ryhl.io; h=cc:cc
	:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1686943366; x=1687029766; bh=tC67s3TArG681IrT06ayhzAKnIwzDaM1R2x
	lX6l2qEU=; b=kG9aj8zpcojl0S/OiVaoLG1+DEuCyq43YJjzkyjiUuC6ZNyWI7W
	IvmF59432nURcamoGbh1IkmxNNpBOspIHxFgItq2zxV1B5hPpVb5oImZTEeMH9e3
	kwR7s5jEyCXi9FevTUN4XgzR2kLwvwwxBgSl3ujEOQOXidqW3adjWbAV2WDpMmJC
	Gr5lVbPix68MiUZX5MWe4ZgdhEaLOm2A2ocI2VeI9pEYttfTIrVRFgy3ArGQWQJp
	J+rs9TkpqTD34zu0zW8NY2byZg+++CzAFAUAn2gYL/2ZUavA+RuTCWD4S6HArGX9
	taO8hb/x0aFM2VwAw/MRPKs7NhVPcmrIU4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1686943366; x=1687029766; bh=tC67s3TArG681IrT06ayhzAKnIwzDaM1R2x
	lX6l2qEU=; b=CDZwLcwPvHqC2Q421TI1Ci/KV/vV6/wxGJYt4nXOp5x4NHYGEq3
	k0KdL+UHAiJVaXSbDoZbN18S0ik88xPLzpFzTRvnZJj2TvExLIVQ8QkVjQFGz2JM
	s/DBOGUnIVT833T8Lx57pTCnDovg2neDW0dzluXOFrL1ESFr65szuj8hOwfAHEou
	By/CUPc1GiNF+G3lNhjfuTbXoWyOmkraH+H7gulkkZCg3MrqTnkMVZEIoXopVzar
	BKbVxu2ZF28CrpLARTeRelHB+e1jM/964GZHSz+yss25tqvVZSTAmDC6vFHA9kPi
	ifMNLWZLJrYKKGTtbPCfr33McXyKYfLAcCg==
X-ME-Sender: <xms:hraMZClAqRvpFf2IGX8Nyxy0ITyi2d2UjpJxO_XvATF2vl_EuxQwrg>
    <xme:hraMZJ1Dd9KOaOfh5GPC6NGUqgIjJqz1WIZYwDwGIvE1BWzQ66xpPB33lL6ml-q8f
    OIBgUehoBQjkd_kHQ>
X-ME-Received: <xmr:hraMZAowozXW6EPovGa5eWKmZF2ipWxY0Kb4yZtUZVE3u6o4kRJ41BxtInCqU14hLqxEu-LeITIW2y3eVMhTwF4bFgaPzlWUaAzYkg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedvgedgudefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefkffggfgfuvfevfhfhjggtgfesthejredttdefjeenucfhrhhomheptehl
    ihgtvgcutfihhhhluceorghlihgtvgesrhihhhhlrdhioheqnecuggftrfgrthhtvghrnh
    epheduuddvteekvdektdduledugfffhfdugeejgeeuvdevtdetveejheehiefffeegnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghlihgtvg
    esrhihhhhlrdhioh
X-ME-Proxy: <xmx:hraMZGncv622zcEQKwGv474BV_scq76vBiikUm4eNcqTdcnUVhN97g>
    <xmx:hraMZA3zxtUs_0QDYejlvdxsb_n23GreJhqRQFXPLAgBuXH3UA3XiQ>
    <xmx:hraMZNvG9Zr8Qgq_n1TOjmejtyx3PEO7kSLW1RkDlLnNdrgeObksLw>
    <xmx:hraMZE_xXU3bgbpbDh2jFlFDZN3lBy69GXfmdrHcudvt_V5kCxBV7Q>
Feedback-ID: i56684263:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jun 2023 15:22:45 -0400 (EDT)
Message-ID: <053cb4c3-aab1-23b3-56e3-4f1741e69404@ryhl.io>
Date: Fri, 16 Jun 2023 21:23:28 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Content-Language: en-US, da
To: Jakub Kicinski <kuba@kernel.org>
Cc: FUJITA Tomonori <fujita.tomonori@gmail.com>, andrew@lunn.ch,
 netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
 aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
References: <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <20230616.220220.1985070935510060172.ubuntu@gmail.com>
 <20230616114006.3a2a09e5@kernel.org>
 <66dcc87e-e03f-1043-c91d-25d6fa7130a1@ryhl.io>
 <20230616121041.4010f51b@kernel.org>
From: Alice Ryhl <alice@ryhl.io>
In-Reply-To: <20230616121041.4010f51b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/23 21:10, Jakub Kicinski wrote:
> On Fri, 16 Jun 2023 21:00:36 +0200 Alice Ryhl wrote:
>> A Rust method can be defined to take the struct "by value", which
>> consumes the struct and prevents you from using it again. This can let
>> you provide many different cleanup methods that each clean it up in
>> different ways.
>>
>> However, you cannot force the user to use one of those methods. They
>> always have the option of letting the value go out of scope, which calls
>> the destructor. And they can do this at any time.
>>
>> That said, the destructor of the value does not necessarily *have* to
>> translate to immediately freeing the value. If the value if refcounted,
>> the destructor could just drop the refcount. It would also be possible
>> for a destructor to schedule the cleanup operation to a workqueue. Or
>> you could do something more clever.
> 
> Can we put a WARN_ON() in the destructor and expect object to never be
> implicitly freed?  skbs represent packets (most of the time) and for
> tracking which part of the stack is dropping packets we try to provide
> a drop reason along the freed skb. It'd be great if for Rust we could
> from the get-go direct everyone towards the APIs with an explicit reason
> code.

Yes, you can certainly put a WARN_ON in the destructor.

Another possibility is to use a scope to clean up. I don't know anything 
about these skb objects are used, but you could have the user define a 
"process this socket" function that you pass a pointer to the skb, then 
make the return value be something that explains what should be done 
with the packet. Since you must return a value of the right type, this 
forces you to choose.

Of course, this requires that the processing of packets can be expressed 
as a function call, where it only inspects the packet for the duration 
of that function call. (Lifetimes can ensure that the skb pointer does 
not escape the function.)

Would something like that work?

Alice

