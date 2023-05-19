Return-Path: <netdev+bounces-3903-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E5FE70980B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 15:16:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57C751C21006
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 13:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7310C2D1;
	Fri, 19 May 2023 13:16:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30C7C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 13:16:46 +0000 (UTC)
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5848BD8;
	Fri, 19 May 2023 06:16:43 -0700 (PDT)
Received: (Authenticated sender: alexis.lothore@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id EE0CE240003;
	Fri, 19 May 2023 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684502201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BMRHN6Y9kPqZOTRa6PWX6stTWQUsJnYXYUXm/l4rB2U=;
	b=i6E1UvJwyBnGESykQGwUgVfdIzCHSc8nEk+PZxzWIqrfHM7XdbeYJ2oXsoFnflBQCUmFIe
	kIiw69Y1pNuq0GnGM7kJovTQESmOI+R9M7swzDFfpn9mBTI1t2kwCqWRQyVRMCAcVFKN3D
	5efkHEXc64VmpUda6WBRHl0bkzHcTGYUP68iF0QD789LsRTWpp+OroZWVaQuktDgeeRQbf
	gQRfE17KFrKM/OfA5kDQFpcPMf+qz5UG0w4tQ1peAyRCmP4X0u5jeqdsMT+IiEWbYoHRNm
	5RHntfpzSWPDn6iZVtma2/YkdSEYav31sLCatplDvXRWPzvCiYxzuQ6HDtPA+A==
Message-ID: <7419ffc0-b292-97c4-fee6-610a1a841265@bootlin.com>
Date: Fri, 19 May 2023 15:16:57 +0200
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
Content-Language: en-US
To: =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
 Andrew Lunn <andrew@lunn.ch>
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
 <ee281c0f-5e8b-8453-08bf-858c5503dc22@bootlin.com>
 <6643e099-7b72-4da2-aba1-521e1a4c961b@lunn.ch>
 <20230519143713.1ac9c7a1@thinkpad>
From: =?UTF-8?Q?Alexis_Lothor=c3=a9?= <alexis.lothore@bootlin.com>
In-Reply-To: <20230519143713.1ac9c7a1@thinkpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/19/23 14:38, Marek Behún wrote:
> On Thu, 18 May 2023 14:58:00 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>>>>> +	[MV88E6361] = {
>>>>> +		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6361,
>>>>> +		.family = MV88E6XXX_FAMILY_6393,
>>>>> +		.name = "Marvell 88E6361",
>>>>> +		.num_databases = 4096,
>>>>> +		.num_macs = 16384,
>>>>> +		.num_ports = 11,
>>>>> +		/* Ports 1, 2 and 8 are not routed */
>>>>> +		.invalid_port_mask = BIT(1) | BIT(2) | BIT(8),
>>>>> +		.num_internal_phys = 5,  
>>>>
>>>> Which ports have internal PHYs? 2, 3, 4, 5, 6, 7 ?  What does
>>>> mv88e6xxx_phy_is_internal() return for these ports, and
>>>> mv88e6xxx_get_capsmv88e6xxx_get_caps()? I'm wondering if you actually
>>>> need to list 8 here?  
>>>
>>> Indeed there is something wrong here too. I need to tune
>>> mv88e6393x_phylink_get_caps to reflect 88E6361 differences.
>>>
>>> As stated above, port 3 to 7 are the ones with internal PHY.
>>> For mv88e6xxx_phy_is_internal, I see that it is merely comparing the port index
>>> to the number of internal phys, so in this case it would advertise (wrongly)
>>> that ports 0 to 4 have internal phys.  
>>
>> Ports 1 and 2 should hopefully be protected by the
>> invalid_port_mask. It should not even be possible to create those
>> ports. port 0 is interesting, and possibly currently broken on
>> 6393. Please take a look at that.
> 
> Why would port 0 be broken on 6393x ?
By "broken", I guess Andrew means that if we feed port 0 to
mv88e6xxx_phy_is_internal, it will return true, which is wrong since there is no
internal phy for port 0 on 6393X ?
> 
> Marek

-- 
Alexis Lothoré, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com


