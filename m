Return-Path: <netdev+bounces-9643-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A04A72A15D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76C6C28134C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987AE206A5;
	Fri,  9 Jun 2023 17:37:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC21C76B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:37:55 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD87DE4E;
	Fri,  9 Jun 2023 10:37:52 -0700 (PDT)
X-GND-Sasl: alexis.lothore@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686332271;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MQ4UWZI119Iu57pHOjYmAYSbWSzI2+ZEVxuwq6FNsuI=;
	b=mO/OT8X4tcThPPSE1PqmZdLmTaSOyoq1g7YjekEN/Ni3Rykt6kECY4LCqekesRIC9+PG+L
	pm0HxrJqT2kBpulKFVwfe6kmrqeP1cbPtFtxCBV3i+x5IXKCred26TIYpoEqvK4HmnsAy+
	Hp8XJyUGMbwDtC5mFrXYcPHqyRlEFQE5bvDod7yqNl9qiOpL1xTacNjEi9ch+rYMXHz07b
	qizwFTsx5p+rGkB0xf2c5A0pFH8JHykQR+fyu9Y+nVJ2/5ReKradFxieLZl2e77P/ma3R6
	iLSiyXyhZx9Cm/HYKtAXIjQ1nHkddrnnUnSO1C8dTm0M1QptNNNycS7wwj0nEQ==
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
X-GND-Sasl: alexis.lothore@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2D736FF802;
	Fri,  9 Jun 2023 17:37:50 +0000 (UTC)
Message-ID: <bb799b06-8ca8-8a29-3873-af09c859ae88@bootlin.com>
Date: Fri, 9 Jun 2023 19:38:13 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, paul.arola@telus.com,
 scott.roberts@telus.com
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
 <dbec77de-ee34-e281-3dd4-2332116a0910@bootlin.com>
 <176f073a-b5ab-4d8a-8850-fcd8eff65aa7@lunn.ch>
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <176f073a-b5ab-4d8a-8850-fcd8eff65aa7@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 19:16, Andrew Lunn wrote:
>> Yes, I can do that (or maybe -EINVAL to match Vladimir's comment ?). I think
>> it's worth mentioning that I encountered an issue regarding those values during
>> tests: I use tc program to set the tbf, and I observed that tc does not even
>> reach kernel to set the qdisc if we pass no burst/latency value OR if we set it
>> to 0. So tc enforces right on userspace side non-zero value for those
>> parameters, and I have passed random values and ignored them on kernel side.
> 
> That is not good. Please take a look around and see if any other
> driver offloads TBF, and what they do with burst.
> 
>> Checking available doc about tc-tbf makes me feel like that indeed a TBF qdisc
>> command without burst or latency value makes no sense, except my use case can
>> not have such values. That's what I struggled a bit to find a proper qdisc to
>> match hardware cap. I may fallback to a custom netlink program to improve testing.
> 
> We don't really want a custom application, since we want users to use
> TC to set this up.
> 
> Looking at the 6390 datasheet, Queue Counter Registers, mode 8 gives
> the number of egress buffers for a port. You could validate that the
> switch has at least the requested number of buffers assigned to the
> port? There is quite a bit you can configure, so maybe there is a way
> to influence the number of buffers, so you can actually implement the
> burst parameter?

Thanks for the pointers. I will check the egress buffers configuration and see
if I can come up with something better

> 
>       Andrew

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


