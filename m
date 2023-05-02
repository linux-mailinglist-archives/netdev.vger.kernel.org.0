Return-Path: <netdev+bounces-12-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B3B6F4B26
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F18A280BEA
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80D6D9470;
	Tue,  2 May 2023 20:16:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5868F6E
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:16:35 +0000 (UTC)
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E200319B3
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:16:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aaea3909d1so31368955ad.2
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 13:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1683058567; x=1685650567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rl66wDG7Nz9exgnSaU34lbOD8FIIZux7sKu43kocDpo=;
        b=SWtf59RhcT9BF4X60+ApPelBaBmJcaF/AMqpv8rJlr/+Jlr+zBu0scengDbsI3ApHA
         6Bb9TwpgLw0EqrBak8XokMJAjneaShz05JYISYCdv9IzRhn2pXjw5KLG9vZNuTmI+Jp+
         7l7+KrZrSaKCatBIsG8ZVjjjBisG2OsA4qYO0XTRaeQ21FgPN4moCAacs3Jjk80pazDO
         HfJuJvbHRpOXMj6o0BFfdb0VhsKbwbIpj/Y4ujQFkVljR1/fbVadC8XLI7Cm1luuQo2J
         A77PWm3vgItTf+qkilUAY4WKYGByvKpfcB8XfocYFvzjwTocOQj5IJha5ZY+UQz/6ePn
         OpiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683058567; x=1685650567;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rl66wDG7Nz9exgnSaU34lbOD8FIIZux7sKu43kocDpo=;
        b=BdWJf12uyxaOjCiqHl719hBhYd52xJBpvJkEwH/6leRc8UpIgDeqfq+/B5L640J8W3
         ibXePQdv47y34QtTHmYHZZw11706Gni2ofv+Yu+ODhRb3i+l25zRVxoNgUV+ZwgVOLoM
         vAzpkRxOjuVgHFOgo9OLaJ9PaAv/KPjNrA9i9MeM6vGQsGxP1UUSzlfOvP2q22DmxiDG
         T1qZDq0Aju+FTZMQc1V/eVC6lII2gF4M+wSpclam0If5ntZLOEAkJST8uyudPTpcUhtd
         1E0SckxwJ/Geqx+F5PCAXsiWJA6n38hehBEdv+B69m35zxUOA2Fju1AME2mHXd2nAcC7
         BKkw==
X-Gm-Message-State: AC+VfDzkP0esRNjnvb8V09SKbK2r1Ic9aY8EXnYgpcn++iMn2fr7RPeq
	HQYoiwiDf9SwE/NcAi5awBsqi7rSjZ7H0OuyN8p5Qw==
X-Google-Smtp-Source: ACHHUZ74igFibFANFyNRQlW+psYegOuKiTL+bUvkOOzFATrT8IjB0YBbYeUSuAI83k/X8KajOejlUA==
X-Received: by 2002:a17:902:e747:b0:1a9:88a0:9b5d with SMTP id p7-20020a170902e74700b001a988a09b5dmr24021205plf.57.1683058567304;
        Tue, 02 May 2023 13:16:07 -0700 (PDT)
Received: from [192.168.100.190] ([209.52.149.8])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902c24c00b001a69d1bc32csm20158970plg.238.2023.05.02.13.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 13:16:06 -0700 (PDT)
Message-ID: <0ba220c3-1a89-69ff-4c90-e2777a0dd04e@mistywest.com>
Date: Tue, 2 May 2023 13:16:06 -0700
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
From: Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <20230502071135.bcxg5nip62m7wndb@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Horatiu,

On 2023-05-02 12:11 a.m., Horatiu Vultur wrote:
> The 05/01/2023 13:34, Ron Eggler wrote:
>
> [snip greetings]
>
>>> I've posted here previously about the bring up of two network interfaces
>>> on an embedded platform that is using two the Microsemi VSC8531 PHYs.
>>> (previous thread: issues to bring up two VSC8531 PHYs, Thanks to Heiner
>>> Kallweit & Andrew Lunn).
>>> I'm able to seemingly fully access & operate the network interfaces
>>> through ifconfig (and the ip commands) and I set the ip address to match
>>> my /24 network. However, while it looks like I can receive & see traffic
>>> on the line with tcpdump, it appears like none of my frames can go out
>>> in TX direction and hence entries in my arp table mostly remain
>>> incomplete (and if there actually happens to be a complete entry,
>>> sending anything to it doesn't seem to work and the TX counters in
>>> ifconfig stay at 0. How can I further troubleshoot this? I have set the
>>> phy-mode to rgmii-id in the device tree and have experimented with all
>>> the TX_CLK delay register settings in the PHY but have failed to make
>>> any progress.
>>> Some of the VSC phys have this COMA mode, and then you need to pull
>>> down a GPIO to take it out of this mode. I looked a little bit but I
>>> didn't find anything like this for VSC8531 but maybe you can double
>>> check this. But in that case both the RX and TX will not work.
>>> Are there any errors seen in the registers 16 (0x10) or register 17
>>> (0x11)?
>> Good point rewgarding the COMA mode, I have not found anything like it.
>> The RGMII connectivity should be pretty straight forward per the
>> datasheet, TX0-TX4, TX_CLK, TX_CTL, RXD0-RXD4, RX_CLK & RX_CTL.
>> Not sure if you've seen this in the subthread that is  ongoing with
>> Andrew Lunn but as part of it, I did invoke the mii-tool and got a
>> pretty printout of the PHY registers, see below:
>>
>> # mii-tool -vv eth0
>> Using SIOCGMIIPHY=0x8947
>> eth0: negotiated 100baseTx-FD, link ok
>>    registers for MII PHY 0:
>>      1040 796d 0007 0572 01e1 45e1 0005 2801
>>      0000 0300 4000 0000 0000 0000 0000 3000
>>      9000 0000 0008 0000 0000 0000 3201 1000
>>      0000 a020 0000 0000 802d 0021 0400 0000
> Unfortunetly, I can't see anything obvious wrong with the registers.
>
>>    product info: vendor 00:01:c1, model 23 rev 2
>>    basic mode:   autonegotiation enabled
>>    basic status: autonegotiation complete, link ok
>>    capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD
>>    advertising:  100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
> Are you expecting to run at 100Mbit?
that's right and expected.
>>    link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD
>> 10baseT-FD 10baseT-HD flow-control
>>
>> Alternartively, the registers can be read with phytool also:
>>
>> # phytool read eth0/0/0x10
>> 0x9000
>> # phytool read eth0/0/0x11
>> 0000
> Another thing that you can try, is to put a probe and see if you
> actually see the TXCLK? And if I understand correctly that should be at
> 25MHz (because the link speed is 100Mbit).
Ah, that's a problem:
I did probe and the clock I probe is at 2.5MHz, not 25.

Just to try out, I also temporarily connected it to 1000baseT:

# mii-tool -vv eth0
Using SIOCGMIIPHY=0x8947
eth0: negotiated 1000baseT-FD flow-control, link ok
   registers for MII PHY 0:
     1040 796d 0007 0572 01e1 c1e1 000d 2001
     4d47 0300 3800 0000 0000 0000 0000 3000
     0000 9000 0008 0000 0000 0000 3201 1000
     0000 a020 a000 0000 a035 0021 0400 0000
   product info: vendor 00:01:c1, model 23 rev 2
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD
   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 
10baseT-HD
   link partner: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 
10baseT-FD 10baseT-HD

and even here, the TX_CLK remained at 2.5MHz (mind the scope I'm using 
only goes up to 70MHz but I surely would not expect it to show me a 
clear clock at 2.5MHz for a faster frequency).

It appears to be "stuck" at 10MBit speed. Also it is at 2.5V instead of 
1.8V.

Would I be able to configure this through device tree setting?

Thanks Horatiu,

this definitely showed clearly where there is a problem.

-- 

Ron


