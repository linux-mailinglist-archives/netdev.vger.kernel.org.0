Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C007CB690B
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbfIRR1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 13:27:36 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:38622 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfIRR1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 13:27:35 -0400
Received: by mail-pl1-f180.google.com with SMTP id w10so275701plq.5
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 10:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b5jRGxuCoroeg1AwlwKt+FLzJJT9N8i68aPLCuSb4YI=;
        b=OfahrcQKVFJRD5pfU66sGAt3gV8B7BVwOQ2D56tZQazEUNUo62j45SD/8aH9f2YLHR
         xpN23xW0fTXzvvS/pBF01FGJJ2q6GUOg+IVlYFWiXe9tGsSJo3bYDx1IyqYd3jPRLeLg
         Z5/ZQnwPoyM0TooQ9bK5fgncw6zcGcIeymeXn91VoorTJcssVo7dONsxzadtYQtFoFoO
         oMs6rjweDP/mKrotxzv3D920M/Jkz/fi1snK206dnZMfESwICLv6T6aLyIu9iO1CWvMD
         7OGOhQ66Thx0NTh99eEvffiUEz2pEUeHCCsCzvarFo/SAH5mGigymHM+c+MFjaIesCKq
         9neQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=b5jRGxuCoroeg1AwlwKt+FLzJJT9N8i68aPLCuSb4YI=;
        b=DOjLYdPzbbb6awYMUAFfprBE+2EXoMoYNFd9b0RjE3ewjpzeyaKYMNl0qb5SmK7uk0
         ZpRci4n9p7cb6Wkxnih3lLbzo9hQbcJuvQ6Qw2sWAmuX8CFlHgzzcjf/9xp6c3iWnhNC
         8eiYb8PVWJANgXO3ddgXFlhwUjW0urTWgz0xKSh+X4Q4b1QMlbsGZTluxx9L3qzoMb4S
         yoHWXfSNgpTHHTYNQ6pDaTBJWwr0gN4SxaafpuHBj7UmmOmJ1gBCTT27LRP9YVpjs82n
         oY9mx8rjNpdpMQFRATI0cDz5oJSMncfZb6OwBzCmKoXiwb2IL/lFopt8m8NP0uPS/psH
         6Bsg==
X-Gm-Message-State: APjAAAUaa1KogR57z23E4S533W09r11WfCEMdUSOiyMtBFj6t2gd0xRL
        vMoPGpMkH8KvSHNCVeAE5S0=
X-Google-Smtp-Source: APXvYqye/SHB3ZzO3CdelcqiyYf7/nuBhMNi+IAurAaBp4ifPN8S5DCHlrSuOCdx1xcNgADI9BPoyA==
X-Received: by 2002:a17:902:aa87:: with SMTP id d7mr5159466plr.203.1568827654450;
        Wed, 18 Sep 2019 10:27:34 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b18sm6973551pfi.157.2019.09.18.10.27.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 10:27:33 -0700 (PDT)
Subject: Re: dsa traffic priorization
To:     Dave Taht <dave.taht@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        kernel@pengutronix.de
References: <20190918140225.imqchybuf3cnknob@pengutronix.de>
 <CA+h21hpG52R6ScGpGX86Q7MuRHCgGNY-TxzaQGu2wZR8EtPtbA@mail.gmail.com>
 <CAA93jw6xB5uv48nB_rgtsky3mGthU2cjMMhuK_NFQeBxio4q5Q@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <81242a3a-6690-3bbc-71f9-c30936c030b0@gmail.com>
Date:   Wed, 18 Sep 2019 10:27:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAA93jw6xB5uv48nB_rgtsky3mGthU2cjMMhuK_NFQeBxio4q5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/18/19 8:03 AM, Dave Taht wrote:
> On Wed, Sep 18, 2019 at 7:37 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>>
>> Hi Sascha,
>>
>> On Wed, 18 Sep 2019 at 17:03, Sascha Hauer <s.hauer@pengutronix.de> wrote:
>>>
>>> Hi All,
>>>
>>> We have a customer using a Marvell 88e6240 switch with Ethercat on one port and
>>> regular network traffic on another port. The customer wants to configure two things
>>> on the switch: First Ethercat traffic shall be priorized over other network traffic
>>> (effectively prioritizing traffic based on port). Second the ethernet controller
>>> in the CPU is not able to handle full bandwidth traffic, so the traffic to the CPU
>>> port shall be rate limited.
>>>
>>
>> You probably already know this, but egress shaping will not drop
>> frames, just let them accumulate in the egress queue until something
>> else happens (e.g. queue occupancy threshold triggers pause frames, or
>> tail dropping is enabled, etc). Is this what you want? It sounds a bit
> 
> Dropping in general is a basic attribute of the fq_codel algorithm which is
> enabled by default on many boxes. It's latency sensitive, so it responds well
> to pause frame (over) use.
> 
> Usually the cpu to switch port is exposed via vlan (e.g eth0:2), and
> while you can inbound and
> outbound shape on that - using htb/hfsc +  fq_codel, or cake

That may be true with swconfig in OpenWrt, but this is not true with DSA
unless DSA_TAG_PROTO_8021Q is used which happens to be on just one
driver at the moment. With other switches that support a proprietary
switch tag format, there is not a particular VLAN or even a network
interface that describes the CPU port, other than the DSA master network
device which is the side facing the host system (not the switch itself).

> 
> But, also, most usually what happens when the cpu cannot keep up with
> the switch is we drop packets on the rx ring for receive, and in
> fq-codel on send.

Dave, you seem to have a tendency to just pattern match on specific QoS-
related topics appearing on netdev and throwing the wonderful tool that
fq_codel without necessarily considering whether this is applicable or
not to the people raising the questions.

Since we are talking about hardware switches here and not simply
stations on a network (although the Ethernet MAC behind the CPU port
ends up being one), there is the possibility of using the HW to do
ingress and/or egress policing. The question raised by Sascha is how to
avoid statically configuring and instead using possibly existing tools
to achieve the same configuration, from user-space, that is, not encode
policy in the driver, but just the mechanism.
-- 
Florian
