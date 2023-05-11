Return-Path: <netdev+bounces-1855-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B6526FF530
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 668EB28176B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EBC9629;
	Thu, 11 May 2023 14:55:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B0136D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:55:15 +0000 (UTC)
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7794C124BB;
	Thu, 11 May 2023 07:54:49 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id A94DA5C0040;
	Thu, 11 May 2023 10:53:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 May 2023 10:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683816824; x=1683903224; bh=1F3ippDhrsx3M
	VtWBGNFUQJfNyeHVvQtpmBRtivpaEI=; b=ebTY8aY2Nl8V7VpGYMdLFP/KZayC0
	jIc6F89XxXRANdxHazsmp65k3fNwYaPoejqA91D4PejeRJSqifE4ZoPo+zgK77oi
	0WnqRFHzXHKIXhJ3ExZWtEVWXd2Iuo7wIvwdvFpF/bB0DQpoe0ws8gr2hRhXiuE0
	+6iJ8QCiQsSRdLgJVqryJ6zWTY6xbtUorPvNpLlB/GgHF/j51i7jeer2T2Zqn9iO
	3xmj9dsEBd/JCbzg1hswZ/C6KbWlexYxto4a2YZ5FkwqYUjxqnXkbcw5PIF/vNmG
	ML7f+jvAPH1wyY2dgbC9lF2ZP1KQ5QIhW6/HSOaGz7/PebEgDKgq3qPxw==
X-ME-Sender: <xms:eAFdZOM3CfAFuLf_ZsGA23k03jTXEQdA0pQJLFw7Ei1YBU7dqLcH8g>
    <xme:eAFdZM_ZXCP3Pf2HdfQEiN7NpMTA5VGngOfhO0q1X2P9FaUsGk-WHbomctgeH02GC
    hDL-FVknWXDj4s>
X-ME-Received: <xmr:eAFdZFQPbb4ZYghXezTHbZhpLaf-aDqpCaJdLjxBPp3MUNDcAa727q-_cG-0B9Yfe2WU0JDj8-ljXM_MxJHUDPBIy-4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegkedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:eAFdZOtqiE483RbST2vEqBm7KtD4pSzNwUWs-G1WK5rpDsIGnhsiWg>
    <xmx:eAFdZGdsDJc8MLUol0z2WCuFPhRnNM3jQbmEYw-bYus-z9Lu1X3ABg>
    <xmx:eAFdZC1OiTstfHLbqD0D2mvLMLE_eLkf0JRIsEKw8llJVG3IMpb_hQ>
    <xmx:eAFdZM3SZwFOeWvSxSZSkNiBuYnQEWih-mkweK5aHKpcNb2SqkO4jw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 May 2023 10:53:43 -0400 (EDT)
Date: Thu, 11 May 2023 17:53:39 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com, shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v8 1/2] vxlan: Add nolocalbypass option to vxlan.
Message-ID: <ZF0Bcz4SCOLX33O3@shredder>
References: <20230511032210.9146-1-vladimir@nikishkin.pw>
 <87a5yb8rkg.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5yb8rkg.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 11:38:33AM +0800, Vladimir Nikishkin wrote:
> Do I need to re-submit the patch to ifconfig separately, or the old one
> was good enough?

You will need to re-submit the iproute2 patches after the kernel patches
are accepted

