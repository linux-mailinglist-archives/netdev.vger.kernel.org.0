Return-Path: <netdev+bounces-4082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10B6470AB2D
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 23:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D4C11C20984
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 21:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91F59449;
	Sat, 20 May 2023 21:52:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978543D39B
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 21:52:16 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B90FD
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 14:52:14 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1ae851f2a7dso12756915ad.0
        for <netdev@vger.kernel.org>; Sat, 20 May 2023 14:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1684619534; x=1687211534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UNaIy/SBdB1toAAOpOLbcw16Mouh3mBEe49+CMx4dn0=;
        b=KAn0ck7VIW8n0I56cSvPE/DZjf4nG98ZLwiS3r8QqLW/OXt2k7uPQ4ATAVkhRjceC4
         mRcLbsnNqEwAOl6r1pv4aCErLIIWtuHVLWWdkM1MMsN6/EECNe0A3tTffeSBMY4HoGjX
         WeNGSMbgLf29brXzPlkQDWdZPWjR/DvyipsfrCAQ8hleJY9od+L+PGl9qHc8GANtSFyf
         mSwvW20oAnzrgN3uYzi/cUY1cVmAcyW+nY/lhrDo/cVxhwiaKAoc50J8OP+PFfbmWAk9
         s7HDJOBRfj3yYtYeZG2yTdTt4I/sboYNN/EZi2TgzI5IOHadOtETdMiqXCRRbYk0iJbi
         0Bvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684619534; x=1687211534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UNaIy/SBdB1toAAOpOLbcw16Mouh3mBEe49+CMx4dn0=;
        b=ga9A9EbpJ47Oy2WcdZVsPtF4EDHmIerCxe2o3PY0pXidRutpB1XjPyDJpdcSxPs/Sj
         4672/70xInM8XIZU7GJeIZjq4RXChsLP+B2UYzeHj36k5yRKY4zJdib+kyTDvpYHFlK3
         Cr9fb+vP+Y16iYgvML6ubug0Byb1ft5tW9FO/59TjDBuKdCATngHhRveLrwoHTrov8qo
         CSg03Ode7D+bA9tPCVt5YlbXJAVcYuQL7/JNrVV/2RHpHDmJsq4PqNt2bro88PQYAyZS
         tdqiM36lpO38bKWdiBlk9E9CPiy/u9LbGKTCFKTRLQ3FcAImcp7VpAzE8Ssz3HybQAdw
         B4hA==
X-Gm-Message-State: AC+VfDxjXqjZHg4+1nD+QYF1YIauoMgC4t3dFtVyqpucHiHe2NzH/agG
	/k+8XShsHdxkXKqICiyxWG3xK1uCkGIPrCFHkFi4LA==
X-Google-Smtp-Source: ACHHUZ6GunVNYNa9Isl9/qmRzV4qdNetrOonV86jn4BbQF4KO4TMYLCk/o3ulTIhA4PBofxeqM6vAw==
X-Received: by 2002:a17:903:2444:b0:1a6:9762:6eed with SMTP id l4-20020a170903244400b001a697626eedmr8354671pls.22.1684619534216;
        Sat, 20 May 2023 14:52:14 -0700 (PDT)
Received: from [192.168.98.6] (remote.mistywest.io. [184.68.30.58])
        by smtp.gmail.com with ESMTPSA id l1-20020a170902ec0100b001ae6948e812sm1709429pld.303.2023.05.20.14.52.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 May 2023 14:52:13 -0700 (PDT)
Message-ID: <b007c778-03ee-23b1-e1b7-106e77819623@mistywest.com>
Date: Sat, 20 May 2023 14:52:12 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: PHY VSC8531 MDIO data not reflected in ethernet/ sub-module
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
References: <2cc45d13-78e5-d5c1-3147-1b44efc6a291@mistywest.com>
 <69d0d5d9-5ed0-4254-adaf-cf3f85c103b9@lunn.ch>
 <759ac0e2-9d5e-17ea-83e2-573a762492c2@mistywest.com>
 <9fbcac7f-9d12-4a42-9f2f-345c37585ff4@lunn.ch>
Content-Language: en-US
From: Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <9fbcac7f-9d12-4a42-9f2f-345c37585ff4@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I should follow up on this Thread and send out a Thank you for everybody 
that has pitched in. I've got the two Ethernet interfaces working fine 
now after I set "phy-mode" to "rgmii-id" and removed the "interrupts" 
and "interrupt-parent" attributes to trigger the polling of the PHY.
Both changes were made in the device tree.

Thanks again!
Ron


On 2023-05-11 19:47, Andrew Lunn wrote:
>> I don't see it being invoked every Seconds but it gets invoked on boot, I
>> added debug logs and see the following:
> What should happen is when the MAC driver call phy_start(), it either
> starts polling the PHY or it enabled interrupts. If it is not polling,
> then is sounds like you have interrupts setup for the PHY. Scatter
> some more debug prints around and about and see which is true.
>
>> state = UP which means it's ready to start auto negotiation(in
>> phy_state_machine())  but instead in phy_check_link_status(), phydev->state
>> should be set to  PHY_RUNNING but it only can get set to PHY_RUNNING when
>> phydev->link is 1 (in phy_check_link_status()):
> Yep. Either via polling, or interrupts, the state machine will change
> to state RUNNING.
>
>>>     phy_read_status()->
>>>       phydev->drv->read_status()
>>> or
>>>       genphy_read_status()
>>>
>>> Check what these are doing, why do they think the link is down.
>> Yes, so in phy_read_status, phydev->drv->read_status appears to be set but I
>> cannot figure out where it gets set. (I obviously need to find the function
>> to find why the link isn't read correctly).
> Since this is a microchip PHY, i would expect vsc85xx_read_status().
>
>> I temporarily set phydev->drv->read_status to 0 to force invocation of
>> genphy_read_status() function to see how that would work.
>>
>> genphy_update_link(0 is called from genphy_read_status() and I get the below
>> data:
>>
>> [    6.795480] DEBUG: in genphy_update_link(), after phy_read() bmcr 4160
>> [    6.805225] DEBUG: in genphy_update_link(), bmcr 0x1040 & 0x200
>> [    6.815730] DEBUG: in genphy_read_status(), genphy_update_link() 0
>> phydev->autoneg 1, phydev->link 0
>>
>>
>> Could it be that the link needs a second to come up when when the network
>> drivers get started and hence I should make sure that the polling once a
>> second works (which currently doesn't appear to be the case)? Am I missing a
>> configuration option?
> auto-neg takes a little over 1 second. Polling does not care, if it is
> not up this time, it might be the next. If you are using interrupts,
> then you need to ensure the interrupt actually fires when auto-neg is
> complete.
>
> 	Andrew
-- 
Ron -- Ron Eggler Senior Firmware Developer 778 230 9442 
www.mistywest.com __________________________________________________ 
About MistyWest We are a Research & Engineering firm composed of 
engineers and physicists with a focus on solving hard problems across a 
number of technology verticals. We specifically target projects that 
have the potential for high-impact, whether it's improving the human 
condition, impacting sustainability in a positive way, or otherwise 
moving us collectively to an inclusively abundant future.

