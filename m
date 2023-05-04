Return-Path: <netdev+bounces-339-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73E736F7326
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:25:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5831D1C2124D
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65596EEA9;
	Thu,  4 May 2023 19:25:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D39BA2D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:25:31 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675417AB0
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:25:29 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aaf91ae451so8110335ad.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 12:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1683228329; x=1685820329;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWz74gs9YbjjcP/TbLdqoCCVmxHlzFS4fKPajiBJEcg=;
        b=kJyfgT9qqrwyszyZJHeO6jha+Eb7yTZ5QInR0r1wzA9R5JnW3IztC3n/mEazyQdPHG
         Ere5is2BLji1hM6qxqmKqHJWZIvwE89o/ZKohV/x+kfoQ3q0Mi5eeNq1t4RZz51o+s63
         Lsl1IaVzsOAKlkzKlcT3kVfP+76tQ6g+BsSTE0K2R8MNL89cOUPI0UO5qaZSOKYD1A/l
         QOO43L9IdTLP6rqG+4yjbD+MY/0Bu+8bWqGI1wQidgBJOfX0cDHGJXxBi5ysT8ZqIP/b
         bFLFMfQFk0iCgs7xXJVrCpHlxX5KSzQ2EQht12tP0UBPKMlqMg0LD3tzviixSCmROZg1
         k10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683228329; x=1685820329;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWz74gs9YbjjcP/TbLdqoCCVmxHlzFS4fKPajiBJEcg=;
        b=d/FBUGQAEFgJOxYfbrYYKCLd1QjmylkxR5adSMFHYDTgbmsJf48wmaRnNn1CYS2Aeh
         5T3oAY8jpiwVtBoBWX0t5RLN5YCNk6ks6oLQgWn01LXtMQ6N3UYkdne6KDJWX51ewer5
         cGLTdgF9NBjv4O9UvDkHCMTMfXtl/BI8Lk/Tol5zW33/qPhgTIlVZEZF+DDyvmWH3OD6
         hggwB1Rol+lV2PRz7gZP5TDz/NmgqpoqVW3/HGNI321WRy8yIhNyWAV7t147hpVQup3u
         uzMW+YpCPhA4NTwA9UoEXMwC6oaWqhDu2MAv4cCtKmlOwknrmcK5kH2jD9q1K1NNeYOl
         w6qQ==
X-Gm-Message-State: AC+VfDyDVsbVKZTGfajC9whj8JEx17OM7a9154Gjr8PciF5Bao+uVbB5
	xbu03U1YaFdWckGh7lBjVmNvpNfhg/9kRfWgAz55vA==
X-Google-Smtp-Source: ACHHUZ6MpMIO+5MwY1UZTlZ5I2LOGEuLN531jLrQ+wjSBU2QWES4cuqvWvYL2sCyRKH3Qo7gECeJWw==
X-Received: by 2002:a17:902:cec2:b0:1a6:3799:ec2a with SMTP id d2-20020a170902cec200b001a63799ec2amr5200493plg.35.1683228328820;
        Thu, 04 May 2023 12:25:28 -0700 (PDT)
Received: from [192.168.100.190] ([209.52.149.8])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902d34900b001a1c721f7f8sm23826801plk.267.2023.05.04.12.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 12:25:28 -0700 (PDT)
Message-ID: <eecbad1b-8c38-da98-60e8-5091ca7131ca@mistywest.com>
Date: Thu, 4 May 2023 12:25:28 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: Unable to TX data on VSC8531
Content-Language: en-US
To: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: netdev@vger.kernel.org
References: <b0cdace8-5aa2-ce78-7cbf-4edf87dbc3a6@mistywest.com>
 <20230501064655.2ovbo3yhkym3zu57@soft-dev3-1>
 <2c2bade5-01d5-7065-13e6-56fcdbf92b5a@mistywest.com>
 <20230502071135.bcxg5nip62m7wndb@soft-dev3-1>
 <0ba220c3-1a89-69ff-4c90-e2777a0dd04e@mistywest.com>
 <20230502205026.3h6nmwnotlgbfl5o@soft-dev3-1>
From: Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <20230502205026.3h6nmwnotlgbfl5o@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Horatiu,

On 2023-05-02 1:50 p.m., Horatiu Vultur wrote:
> The 05/02/2023 13:16, Ron Eggler wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>>
>> On 2023-05-02 12:11 a.m., Horatiu Vultur wrote:
>>> The 05/01/2023 13:34, Ron Eggler wrote:
>>>
>>> [snip greetings]
>>>
>>>>> I've posted here previously about the bring up of two network interfaces
>>>>> on an embedded platform that is using two the Microsemi VSC8531 PHYs.
>>>>> (previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner
>>>>> Kallweit & Andrew Lunn).
>>>>> I'm able to seemingly fully access & operate the network interfaces
>>>>> through ifconfig (and the ip commands) and I set the ip address to match
>>>>> my /24 network. However, while it looks like I can receive & see traffic
>>>>> on the line with tcpdump, it appears like none of my frames can go out
>>>>> in TX direction and hence entries in my arp table mostly remain
>>>>> incomplete (and if there actually happens to be a complete entry,
>>>>> sending anything to it doesn't seem to work and the TX counters in
>>>>> ifconfig stay at 0. How can I further troubleshoot this? I have set the
>>>>> phy-mode to rgmii-id in the device tree and have experimented with all
>>>>> the TX_CLK delay register settings in the PHY but have failed to make
>>>>> any progress.
>>>>> Some of the VSC phys have this COMA mode, and then you need to pull
>>>>> down a GPIO to take it out of this mode. I looked a little bit but I
>>>>> didn't find anything like this for VSC8531 but maybe you can double
>>>>> check this. But in that case both the RX and TX will not work.
>>>>> Are there any errors seen in the registers 16 (0x10) or register 17
>>>>> (0x11)?
>>>> Good point rewgarding the COMA mode, I have not found anything like it.
>>>> The RGMII connectivity should be pretty straight forward per the
>>>> datasheet, TX0-TX4, TX_CLK, TX_CTL, RXD0-RXD4, RX_CLK & RX_CTL.
>>>> Not sure if you've seen this in the subthread that is  ongoing with
>>>> Andrew Lunn but as part of it, I did invoke the mii-tool and got a
>>>> pretty printout of the PHY registers, see below:
>>>>
>>>> # mii-tool -vv eth0
>>>> Using SIOCGMIIPHY=0x8947
>>>> eth0: negotiated 100baseTx-FD, link ok
>>>>     registers for MII PHY 0:
>>>>       1040 796d 0007 0572 01e1 45e1 0005 2801
>>>>       0000 0300 4000 0000 0000 0000 0000 3000
>>>>       9000 0000 0008 0000 0000 0000 3201 1000
>>>>       0000 a020 0000 0000 802d 0021 0400 0000
>>> Unfortunetly, I can't see anything obvious wrong with the registers.
>>>
>>>>     product info: vendor 00:01:c1, model 23 rev 2
>>>>     basic mode:   autonegotiation enabled
>>>>     basic status: autonegotiation complete, link ok
>>>>     capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>>>> 10baseT-FD 10baseT-HD
>>>>     advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>>> Are you expecting to run at 100Mbit?
>> that's right and expected.
>>>>     link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>>>> 10baseT-FD 10baseT-HD flow-control
>>>>
>>>> Alternartively, the registers can be read with phytool also:
>>>>
>>>> # phytool read eth0/0/0x10
>>>> 0x9000
>>>> # phytool read eth0/0/0x11
>>>> 0000
>>> Another thing that you can try, is to put a probe and see if you
>>> actually see the TXCLK? And if I understand correctly that should be at
>>> 25MHz (because the link speed is 100Mbit).
>> Ah, that's a problem:
>> I did probe and the clock I probe is at 2.5MHz, not 25.
> That is one step foward :)
Sure is! I actually found that my TX_CLK is always at 2.5MHz and doesn't 
go to 25MHz(100BaseT) or 125 (1000BaseT).
>> Just to try out, I also temporarily connected it to 1000baseT:
>>
>> # mii-tool -vv eth0
>> Using SIOCGMIIPHY=0x8947
>> eth0: negotiated 1000baseT-FD flow-control, link ok
>>    registers for MII PHY 0:
>>      1040 796d 0007 0572 01e1 c1e1 000d 2001
>>      4d47 0300 3800 0000 0000 0000 0000 3000
>>      0000 9000 0008 0000 0000 0000 3201 1000
>>      0000 a020 a000 0000 a035 0021 0400 0000
>>    product info: vendor 00:01:c1, model 23 rev 2
>>    basic mode:   autonegotiation enabled
>>    basic status: autonegotiation complete, link ok
>>    capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD
>>    advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD
>> 10baseT-HD
>>    link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD
>>
>> and even here, the TX_CLK remained at 2.5MHz (mind the scope I'm using
>> only goes up to 70MHz but I surely would not expect it to show me a
>> clear clock at 2.5MHz for a faster frequency).
> Then in theory if you force the speed to be 10Mbit, will it work?
I hooked it up to a anopther box, poin-to-point and used:

# ethtool -s eth0 speed 10 duplex half autoneg off mdix auto

on both hosts to force the speed to 10Mbps but I still had problems: 
Data would not make it out onto the line and the ifconfig TX counters 
remained at 0 for eth0 (but the counters on my lo interface incremented 
instead)

>
>> It appears to be "stuck" at 10MBit speed. Also it is at 2.5V instead of
>> 1.8V.
>>
>> Would I be able to configure this through device tree setting?
> I am not sure, if this is possible, shouldn't be a configuration option
> on the MAC side? As if I understand correctly, the MAC should generate
> the TX_CLK in RGMII regardless of the speed.
that is my understanding too, I'm expecting that some option on the MPU 
side is misconfigured. I'm digging through the datasheets.
> I would prefer to leave this to people who have more knowledge then me
> to answer to this.
Yeah, thanks! Your assistance has been very helpful until here!
-- 
Ron

