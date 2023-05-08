Return-Path: <netdev+bounces-936-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0986FB6AE
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC3EB1C209CA
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B79B11190;
	Mon,  8 May 2023 19:18:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCD3AD25
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:18:40 +0000 (UTC)
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A79749EB;
	Mon,  8 May 2023 12:18:39 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-643846c006fso5255611b3a.0;
        Mon, 08 May 2023 12:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683573518; x=1686165518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WuCiNUgzLkxks+od5swaJeY0tSj1GrHtK2OX92t1PJI=;
        b=qhm9A147IFWEKAtcVF8XCQrg6Mi+EaVdaVqLKWhmuhpW5DPLUzxEY+ZYDTmDDmKbSI
         bwCR8EjcaIXaQ77zCv6S6qsPWQglt08XMC5TwKh+CGAmpt8uxhzitXH39OKPkbiwsSoS
         XDJ+hDfj4VmnRRGK4V7oJPdGwjyVRQS4Uwiw/i+iOhxLBBqkPyeoopSR1Jh0Pgai2fGo
         YPMbXuRe2c0vmpx54A9ER8UllgSHhq/Oa++a65kOcQrqJ6gdBH5MS0ZtM8VAsQPwvUoo
         kiv7u5UyHcuCq6h2M2ftYHl+DXURGd4/nReVCzokJShhOHx/bP31QoFwGwB/4JJ3ej2C
         RMNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683573518; x=1686165518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WuCiNUgzLkxks+od5swaJeY0tSj1GrHtK2OX92t1PJI=;
        b=DcSSavyrGsNrYfsFuXZVoMH0CO5WMP9MU39T2jaBuIKG3M5X9+v3+Qs0O3HAx6iJFS
         zwoPl1j+wKlLDw1WnYNwSTFJnt2eDxAyWt5ys+/GqZgPEjoimakrkmRJkR0IfMpIU6L6
         xIqE79moHMd2KmqY/LO7l6OhgABtsKDH9hyBHAvT27Ifm01r1p+AuN25CQFmYg5YNsY7
         VhpXmyf3Gl/6b25SJoaCZa8hyzl4kHFTKfIPR7Lb4PXK0/Z0N2BuU6bzYcBe+jjLrYoM
         2jmAUVW4fZR9lIYEhhifmAaOw6aA9xcRRlp6vgDyPS+cc+morQQkFH9B1u/bQcJfgPnC
         gkbw==
X-Gm-Message-State: AC+VfDwtIXh/GadgIHWpR4FnM1EaUtpcu/9vj8fsVV4FHLOmFEPRuvz8
	3Bxt6PsCIAFqRi73YuRJmH8=
X-Google-Smtp-Source: ACHHUZ5/Mjv7Qbc4Ov6aN4PgpeKsVyraOZcyncxpKcEStjS89OysYhOPpe3Ls4LIv9V873zLrduwRQ==
X-Received: by 2002:a05:6a20:4312:b0:fd:e806:9c95 with SMTP id h18-20020a056a20431200b000fde8069c95mr14890280pzk.13.1683573518550;
        Mon, 08 May 2023 12:18:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f13-20020aa782cd000000b0062e63cdfcb6sm319565pfn.94.2023.05.08.12.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 12:18:37 -0700 (PDT)
Message-ID: <7da02335-6c02-f9f8-5cdd-b9bf3734addb@gmail.com>
Date: Mon, 8 May 2023 12:18:36 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/3] net: phy: Let drivers check Wake-on-LAN
 status
Content-Language: en-US
To: Florian Fainelli <florian.fainelli@broadcom.com>,
 Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Heiner Kallweit <hkallweit1@gmail.com>, Russell King
 <linux@armlinux.org.uk>, =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
 Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
 <20230508184309.1628108-2-f.fainelli@gmail.com>
 <a4a76d54-c264-4ed8-8784-93ea392615e8@lunn.ch>
 <00ef2d9e-2c30-9f13-f702-f692ce0baee9@broadcom.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <00ef2d9e-2c30-9f13-f702-f692ce0baee9@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/8/23 12:17, Florian Fainelli wrote:
> On 5/8/23 12:02, Andrew Lunn wrote:
>> On Mon, May 08, 2023 at 11:43:07AM -0700, Florian Fainelli wrote:
>>> A few PHY drivers are currently attempting to not suspend the PHY when
>>> Wake-on-LAN is enabled, however that code is not currently executing at
>>> all due to an early check in phy_suspend().
>>>
>>> This prevents PHY drivers from making an appropriate decisions and put
>>> the hardware into a low power state if desired.
>>>
>>> In order to allow the PHY framework to always call into the PHY driver's
>>> ->suspend routine whether Wake-on-LAN is enabled or not, provide a
>>> phydev::wol_enabled boolean that tracks whether the PHY or the attached
>>> MAC has Wake-on-LAN enabled.
>>>
>>> If phydev::wol_enabled then the PHY shall not prevent its own
>>> Wake-on-LAN detection logic from working and shall not prevent the
>>> Ethernet MAC from receiving packets for matching.
>>
>> Hi Florian
>>
>> Did you look at using late_suspend for this? Then there would not be
>> any need to change all these drivers which are happy as they are.
> 
> I did not know its existence until you mentioned it, this would require 
> plumbing all the way from the MDIO bus driver down to the PHY driver 
> level, which could be done, but for a single driver? The way Linux 
> suspends devices currently, and the fact that the interrupt is driven 
> level low, it does not give much room if at all for missing the 
> interrupt AFAICT.

I suppose that a middle ground could be to introduce a specific callback 
or flag that says: please call my suspend routine and I will do what's 
necessary.

> 
> phy_suspend() is called both from the system suspend path, but also 
> whenever the PHY is unused, and this is a nice property because we do 
> not really need to differentiate these paths usually, that includes 
> Wake-on-LAN.
> 
> Besides there are drivers like drivers/net/phy/at803x.c that wish to 
> isolate the PHY if WoL is enabled and which are currently not doing it 
> because this never gets called.

-- 
Florian


