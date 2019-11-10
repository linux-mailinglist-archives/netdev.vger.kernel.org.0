Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08371F6B71
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 21:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfKJUyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 15:54:23 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37698 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfKJUyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 15:54:23 -0500
Received: by mail-pl1-f193.google.com with SMTP id g8so2681603plt.4
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 12:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Gxb2DID2btJNpbi6hWWKObTu9P3YqGj/PM7VeNJfWYI=;
        b=XSjWn/KfMkbXe2f5gC7aLtWN6Z/IBdt1uZQMg+SIx/WpXjAwVUOEytblD0t6+BIYPw
         pmNPaU05/OWBc/Is61DuqmUkhFpCTYkA316YJGNt97678Biy3i7R+wO1fy5k5eBXj3dv
         SmjkQbPdvranCR86ydn1KVGxoies6WJ6PF3ys+laPSaqMkM/xUCgdR2kPVZQlw3DSr3e
         PbJ/5BmnhRb41bC8OY1v2pfgvuo/mjNaCL2SJNjVYoIv0g9tG0oDqLSTmAi/74jQSSLJ
         rQxRpYtV68ho++CQ87gBCfCxy54nbE13q27b1XUPF8W5mSTUV2ja9wGYfnwL4Z2kgI6v
         XJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Gxb2DID2btJNpbi6hWWKObTu9P3YqGj/PM7VeNJfWYI=;
        b=E6a/GNjlvc/2zv4JtX+3QfSxBtHejd7WNg/JLi1VIRS91KF3Fk5UeBcNZYq/Vr/L0A
         8Hec4Bq4H6Fdapfio1hb5pwvH0dPnRu73ac6tqOyWTKWN/2/j7mP3xEQaUTZgK/SxXKc
         V8xmohGmn4eazHwm8VrKIZNxu3bmM5hVEmCoG5GV2wK6Jz8Swjrjqm7lpPtAWVmhHI5o
         JiL+G3xAtgSVQ+GXNW6galUdvvd1spWBCiacApE2VgYoGAqfYv0l/4GQggEEe1x7tY1N
         RA8rfO+AV6KYszCHsrGPsu3atWe5Ut27AQWWuY4PzXLFUEi1w6Zy1H1VJT87yRXA1umQ
         4Fzg==
X-Gm-Message-State: APjAAAWDCpc7yCzlxYtU6wFvRYtb6svdoTJyKvhXVfBVOR+BNrOOxWN1
        /K+KoRKRbJoQn/qDFNRrQBA=
X-Google-Smtp-Source: APXvYqwryILIwJFawNQmbg2dHKzfHhH3VzJ1xTc95IoPTC1IOaeEb+YQbB5NuMjEgeoKitt6ZojGAQ==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr22222134plf.243.1573419261803;
        Sun, 10 Nov 2019 12:54:21 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 26sm11628993pjg.21.2019.11.10.12.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Nov 2019 12:54:21 -0800 (PST)
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20191109130301.13716-1-olteanv@gmail.com>
 <20191109130301.13716-16-olteanv@gmail.com> <20191110165031.GF25889@lunn.ch>
 <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
 <20191110171250.GH25889@lunn.ch>
 <CA+h21hpg2a=V44R_YNBBxTP4jLMgQaHBzHXyqaMDhg9uBvtpAA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <d99479d0-b5c2-bee2-73ff-7d9235840225@gmail.com>
Date:   Sun, 10 Nov 2019 12:54:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hpg2a=V44R_YNBBxTP4jLMgQaHBzHXyqaMDhg9uBvtpAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2019 9:33 AM, Vladimir Oltean wrote:
> On Sun, 10 Nov 2019 at 19:12, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Sun, Nov 10, 2019 at 07:00:33PM +0200, Vladimir Oltean wrote:
>>> On Sun, 10 Nov 2019 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
>>>>
>>>> On Sat, Nov 09, 2019 at 03:03:01PM +0200, Vladimir Oltean wrote:
>>>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>>>
>>>>> VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
>>>>> queuing subsystem for terminating traffic locally).
>>>>
>>>> So maybe that answers my last question.
>>>>
>>>>> There are 2 issues with hardcoding the CPU port as #10:
>>>>> - It is not clear which snippets of the code are configuring something
>>>>>   for one of the CPU ports, and which snippets are just doing something
>>>>>   related to the number of physical ports.
>>>>> - Actually any physical port can act as a CPU port connected to an
>>>>>   external CPU (in addition to the local CPU). This is called NPI mode
>>>>>   (Node Processor Interface) and is the way that the 6-port VSC9959
>>>>>   (Felix) switch is integrated inside NXP LS1028A (the "local management
>>>>>   CPU" functionality is not used there).
>>>>
>>>> So i'm having trouble reading this and spotting the difference between
>>>> the DSA concept of a CPU port and the two extra "CPU ports". Maybe
>>>> using the concept of virtual ports would help?
>>>>
>>>> Are the physical ports number 0-9, and so port #10 is the first extra
>>>> "CPU port", aka a virtual port? And so that would not work for DSA,
>>>> where you need a physical port.
>>>>
>>>>       Andrew
>>>
>>> Right. See my other answer which links to Ocelot documentation.
>>
>> Yes, i'm getting the picture now.
>>
>> The basic problem is that in the Linux kernel CPU port has a specific
>> meaning, and it is clashing with the meaning used in the datasheet. So
>> maybe in the driver, we need to refer to these two ports as 'local
>> ports'?
>>
> 
> Hmm, I don't know. Both types of CPU ports lead to management CPUs,
> but to different types of them. I understand the clash with the DSA
> meaning, but even if I rename it I would have to provide an
> explanation relative to the datasheet definitions (and I already
> explain that the NPI mode is the DSA type of CPU port). I'm not sure
> there is a net gain.

Maybe we need to agree on renaming DSA's CPU port to "mgmt_port" or
something that indicates that there is in-band signaling to help support
the function of managing the switch, incidentally Broadcom switches call
their ports In-Band Management Port (IMP) which is clearer IMHO.
-- 
Florian
