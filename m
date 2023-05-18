Return-Path: <netdev+bounces-3535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D3CF707C82
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 581A428184A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 09:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1876AD46;
	Thu, 18 May 2023 09:10:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55F5AD44
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:10:53 +0000 (UTC)
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231DF1FDA;
	Thu, 18 May 2023 02:10:49 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id C8EEF40006;
	Thu, 18 May 2023 09:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684401048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ntNwT3ufuzTXN9KB3cXrWO9kyjTnFe0jhp+FBdX+ds=;
	b=W8gXr6R38X04sJF2/cHt0+En8n9JYEMzddJmyaKaScaIqrOXq9pFMPmVcdNH9WZ0+I7RmV
	CUwMsk0fQGI/OSidxewPggsmfUaEW9HrwE1YFInhbSse3g8aKBhs8ZbWpqLZ8ehf+6gllJ
	l6XEcvFJeetfkeYbGZkEuXLMVWMeTD/yPxDq0QSm4+BnEO8XP6WhqT2NjNAVOfQ0YCkXwb
	sDB8uIp6OBi/ZHeSLp56CFMnAkIVpjvmxChzYjtcEA4oAWGfZJfmofoc3hyece5GraBUXM
	hEIHdBZ5XclCGn2PYB9RSwAW2RCqqtQidwoHVG4P5GjfC/SobjstSQNodnh3oQ==
Message-ID: <ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
Date: Thu, 18 May 2023 11:11:03 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: enable support for
 88E6361 switch
To: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 thomas.petazzoni@bootlin.com, paul.arola@telus.com, scott.roberts@telus.com
References: <20230517203430.448705-1-alexis.lothore@bootlin.com>
 <20230517203430.448705-3-alexis.lothore@bootlin.com>
 <9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
Content-Language: en-US
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <9a836863-c279-490f-a49a-de4db5de9fd4@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Andrew, thanks for the prompt review !

On 5/17/23 22:51, Andrew Lunn wrote:
> On Wed, May 17, 2023 at 10:34:30PM +0200, alexis.lothore@bootlin.com wrote:
>> From: Alexis Lothoré <alexis.lothore@bootlin.com>
>>
>> Marvell 88E6361 is an 8-port switch derived from the
>> 88E6393X/88E9193X/88E6191X switches family. It can benefit from the
>> existing mv88e6xxx driver by simply adding the proper switch description in
>> the driver. Main differences with other switches from this
>> family are:
>> - 8 ports exposed (instead of 11): ports 1, 2 and 8 not available
>> - No 5GBase-x nor SFI/USXGMII support
> 
> So what exactly is supported for link modes?
> 
> The way you reuse the 6393 ops, are these differences actually
> enforced? It looks like mv88e6393x_phylink_get_caps() will allow
> 2500BaseX, 5GBaseX and 10GBaseR for port 10.

You are right, mv88e6393x_phylink_get_caps is currently too "generous" with
capabilities for 88E6361. With this chip, supported links modes are the following:
- port 0: MII, RMII, RGMII, 1000BaseX, 2500BaseX
- port 3 to 7: triple speed internal phys
- port 9 and 10: 1000BaseX, 25000BaseX
I'll add those specifications in cover letter for next revision for this series.
So indeed reported capabilities are wrong, I will update it. Taking a quick look
at other ops, I guess I'll have to fix some others too like
mv88e6393x_port_max_speed_mode
> 
>> +	[MV88E6361] = {
>> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
>> +		.family = MV88E6XXX_FAMILY_6393,
>> +		.name = "Marvell 88E6361",
>> +		.num_databases = 4096,
>> +		.num_macs = 16384,
>> +		.num_ports = 11,
>> +		/* Ports 1, 2 and 8 are not routed */
>> +		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
>> +		.num_internal_phys = 5,
> 
> Which ports have internal PHYs? 2, 3, 4, 5, 6, 7 ?  What does
> mv88e6xxx_phy_is_internal() return for these ports, and
> mv88e6xxx_get_capsmv88e6xxx_get_caps()? I'm wondering if you actually
> need to list 8 here?

Indeed there is something wrong here too. I need to tune
mv88e6393x_phylink_get_caps to reflect 88E6361 differences.

As stated above, port 3 to 7 are the ones with internal PHY.
For mv88e6xxx_phy_is_internal, I see that it is merely comparing the port index
to the number of internal phys, so in this case it would advertise (wrongly)
that ports 0 to 4 have internal phys. I also see that your suggestion (setting
num_interal_phys to max internal phy index + 1) is already in use for this
family (6393X has 8 internal phys but defines num_internal_phys to 9), so if
it's acceptable I will do as you suggest and set it to 8.

Thanks,
Alexis

> 
>      Andrew

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


