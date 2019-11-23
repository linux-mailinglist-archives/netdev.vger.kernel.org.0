Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B37231080C1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKWVOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:14:53 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:43943 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWVOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:14:53 -0500
Received: by mail-pj1-f68.google.com with SMTP id a10so4672500pju.10
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 13:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/sKBB9D5fubc0DQh9cZWgRBVipYQ8Tpm//9+EI6aMSg=;
        b=CpKRmQykyvRtzwTXePJRNRyUINp5eBeReC/wNmppLvL9FQZNJwxp96VWc0mnxZ0ity
         IjRNsFNYXfPoM4t0XoKUMoJAa2Cnkxej+1HBCyQc+LqKEgnvv8hkCDxgZMXHopZ0bET/
         pp1egBNBDXsSZVdSfpedFdwIJKSao/+XkQq6jVipdzSa5JCRFtefonJyPlt9yHbzM0lm
         cMidFU6l7ofjwCXl9K3Zq2pY3GaKuJ5ldEV04BM9lS3WKUPDEKfUNkG67TApIlW6LoWF
         hiGhGgA1aPnzTGuysNzpEEezjtnQXro04dNOsNvmzQ/qgNCqMKHyRDdqfhw8c8Yq1K2y
         afGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/sKBB9D5fubc0DQh9cZWgRBVipYQ8Tpm//9+EI6aMSg=;
        b=MBfzHL66r7u8fRTMxov/AtGvtN0awHVVniutkoCWpIaUcV+HDjhfMmx+b0du1gH6M7
         NVRbqCINBzxtKUuEE4lsliCXW7vMD1vNYUKxOvzDLb7ApR1iv0BDaHuc5g7wBRNpihwq
         gyBBBZ9tKOOAwAVTWtyhSijho3+33CrIrPw3rGOX6JFPV8rPIakPCdoOEME6NhtnU5Vt
         1BEgYNEaswTrFNg5hcC6PcYDu6tD8Gt6HxP9vszLxJniq5MxMtPBW7WrkW5+Ryyv+uaI
         UqpxX7bugQNqZkw1mvsC0xXYJ40RCeYqlKpFR/u/rmX6yXQ5vwtK3rPgAG64v44PVoic
         xl3A==
X-Gm-Message-State: APjAAAXRUyx7AR7LTYD7eauf7O98PkapAXID4S/DqibIj2ehzptYAuSe
        9/ZammkA/N5EB85pK6y3GXhj++xD
X-Google-Smtp-Source: APXvYqxJT7ezJbZ99gCwW8rInM9dfmz0SsPUdRnSOrGwbOY5i4Nmt9biYQkpvBYlt91LS+LmiWD/og==
X-Received: by 2002:a17:90a:1089:: with SMTP id c9mr28425904pja.8.1574543691635;
        Sat, 23 Nov 2019 13:14:51 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l2sm2851965pjf.4.2019.11.23.13.14.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Nov 2019 13:14:51 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
References: <20191123194844.9508-1-olteanv@gmail.com>
 <20191123194844.9508-2-olteanv@gmail.com>
 <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
 <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <9f344984-ef0c-fc57-d396-48d4c77e1954@gmail.com>
Date:   Sat, 23 Nov 2019 13:14:49 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/2019 12:46 PM, Vladimir Oltean wrote:
> 
> Correct. I was actually held back a bit while looking at Andrew's
> patch dc0fe7d47f9f ("net: dsa: Set the master device's MTU to account
> for DSA overheads") where he basically discarded errors, so that's the
> approach I took too (thinking that some DSA masters would not have ops
> for changing or reporting the MTU).
> 
>> I had prepared a patch series with Murali doing nearly the same thing
>> and targeting Broadcom switches nearly a year ago but since I never got
>> feedback whether this worked properly for the use case he was after, I
>> did not submit it since I did not need it personally and found it to be
>> a nice can of worms.
>>
> 
> Nice, do you mind if I take your series instead then?

Not at all, if it works, please go ahead, not sure how hard it is going
to be to rebase.

> 
>> Another thing that I had not gotten around testing was making sure that
>> when a slave_dev gets enslaved as a bridge port member, that bridge MTU
>> normalization would kick in and make sure that if you have say: port 0
>> configured with MTU 1500 and port 1 configured with MTU 9000, the bridge
>> would normalize to MTU 1500 as you would expect.
>>
> 
> Nope, that doesn't happen by default, at least in my implementation.
> Is there code in the bridge core for it?

net/bridge/br_if.c::br_mtu_auto_adjust() takes care of adjusting the
bridge master device's MTU based on the minimum MTU of all ports within
the bridge, but what it seems to be missing is ensuring that if bridge
ports are enslaved, and those bridge ports happen to be part of the same
switch id (similar decision path to setting skb->fwd_offload_mark), then
the bridge port's MTU should also be auto adjusted. mlxsw also supports
changing the MTU, so I am surprised this is not something they fixed
already.

> 
>> https://github.com/ffainelli/linux/commits/dsa-mtu
>>
>> This should be a DSA switch fabric notifier IMHO because changing the
>> MTU on an user port implies changing the MTU on every DSA port in
>> between plus the CPU port. Your approach here works for the first
>> upstream port, but not for the ones in between, and there can be more,
>> as is common with the ZII devel Rev. B and C boards.
> 
> Yes, correct. Your patch implements notifiers which is definitely
> good. I don't have a cascaded setup to test yet (my Turris Mox was
> supposed to arrive but for some reason it was returned to the seller
> by the shipping company...).

Andrew and Vivien may know whether it is possible to get you a ZII Devel
rev. B or C since those have 3 switches in the fabric and have
constituted nice test platforms. Not sure if there is a version with a
CPU port that is Gigabit capable though.
-- 
Florian
