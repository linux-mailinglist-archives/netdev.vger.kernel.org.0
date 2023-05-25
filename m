Return-Path: <netdev+bounces-5474-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD517117D0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 48ED21C20EF0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AA124159;
	Thu, 25 May 2023 20:05:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BE124142
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 20:05:27 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC2AA;
	Thu, 25 May 2023 13:05:25 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 8C0B05C0095;
	Thu, 25 May 2023 16:05:24 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 25 May 2023 16:05:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm3; t=1685045124; x=1685131524; bh=af
	wKzTFSZxMLcqKLuXLhRfp2yktpJdcBueVH1/yBuCY=; b=axniLfx3MCQJtIdS2i
	bbCI1gKUjhdos+LPj7dMHAYGJ0kIZxmo5eepqWAE7guVByUAUq09j/dl3wR0exKp
	yV32dweobQqIVx73WaAa4ap9dg7vDVyMJh2pgCTiMYW/mB0531Lpi0lyvTduaIZb
	segLTqm/rP9GQJDnMBQnsjTA604sELGT5Zp95Xg1i0V9B22GU+tnSxQymkX5ByvZ
	biNiPiWdPxHDwu3jc01BUcEJuAfoPQmX77euxVwdLFH/84iLUi+nspLZa3ijVCLq
	AzgZEsdpUUOszPoT4UaCIJ//8RfjUEi8HI/CZ9gQ5y1IqQYqBWK6YktH7o+pfAaW
	sesA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685045124; x=1685131524; bh=afwKzTFSZxMLc
	qKLuXLhRfp2yktpJdcBueVH1/yBuCY=; b=nfx8wMoCs7XVydCE/92WK9t67M6Vf
	pkoD2o8+Q/ID2M6Miu3AM0b/6fMQ3EyLFob4SRbPS8oj+ncr3Mh8bYKLvG+b62B7
	tzyKbdKIGJ9niMp21ClnxBQOefX9h+XrcDjUqOY3+0Ny1NY4bOzX001CeI7w1EEb
	wpg+8vLJ47zGOfLsewNYmdFALbqL8ExsTBESmlvRbDvUlGK9dU/l5lCN+8POkHrK
	rFuK+MI/oVXWJhEn+kr1S/nYETGIh0qjyL7OW8nRB7t5KZ61geBzcvvvEdw7KajW
	uBT1haEpxzvrJnIzsRnXih1FY2QPa5pl1obmzORelYHcLUQGTWMHOj0Cw==
X-ME-Sender: <xms:hL9vZMuoaZ7x8t-fTexT-DbZ34_dPbdx1dTmHcxUvO47BP9dvGuazA>
    <xme:hL9vZJdcvU0sJPq2YFj08NYHsSuJMZKogzoRoh7UajVTm0ChkbYTFkzPhSRAOHjG_
    58BGBTF9Rd1UpAJQKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejjedgudegfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:hL9vZHxuZH-G-7F2VAVBDZgcDeg5R5LHeMCJrBULELxHVv3nl43qkA>
    <xmx:hL9vZPPeOSBx09yN1CxVUlCc7aZPHYfi4U7GmM-Q7UuwF4S2LqMT1Q>
    <xmx:hL9vZM8DOjViW_JhojDs6dnwqGXet4C5OpvRU7TPw3qeP3Gxn9RDJw>
    <xmx:hL9vZAZVIB_9pTmhgHHnXbn_q87msw8Hub67qf1WG0RscYac1dxUVQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 30132B60086; Thu, 25 May 2023 16:05:24 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-441-ga3ab13cd6d-fm-20230517.001-ga3ab13cd
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <7f46f5c0-a5cb-4e4f-9201-2fd06e92e1ef@app.fastmail.com>
In-Reply-To: <20230525184520.2004878-20-sashal@kernel.org>
References: <20230525184520.2004878-1-sashal@kernel.org>
 <20230525184520.2004878-20-sashal@kernel.org>
Date: Thu, 25 May 2023 22:05:01 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Sasha Levin" <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: "Jakub Kicinski" <kuba@kernel.org>, "Andrew Lunn" <andrew@lunn.ch>,
 "Heiner Kallweit" <hkallweit1@gmail.com>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.14 20/20] mdio_bus: unhide mdio_bus_init prototype
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023, at 20:45, Sasha Levin wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> [ Upstream commit 2e9f8ab68f42b059e80db71266c1675c07c664bd ]
>
> mdio_bus_init() is either used as a local module_init() entry,
> or it gets called in phy_device.c. In the former case, there
> is no declaration, which causes a warning:
>
> drivers/net/phy/mdio_bus.c:1371:12: error: no previous prototype for 
> 'mdio_bus_init' [-Werror=missing-prototypes]
>
> Remove the #ifdef around the declaration to avoid the warning..

Hi Sasha,

While there is nothing wrong with backporting the -Wmissing-prototypes
warning fixes I sent, there is also really no point unless you
want to backport all 140 of them and then also turn on that warning
during testing.

The option is only enabled at the W=1 level or when using sparse (C=1).
I hope to get these all done in 6.5 for the most common architectures,
but I wouldn't bother putting them into stable kernels.

     Arnd

