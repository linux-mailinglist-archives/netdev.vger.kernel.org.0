Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81442AF591
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 16:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727476AbgKKP5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 10:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgKKP5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 10:57:01 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73366C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 07:57:01 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w6so1879427pfu.1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 07:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZTl9Olh8eAj9K5mitpaP1luX2iDXpRTtAw5W2V6+XKs=;
        b=mMNbr0KNhePHaVv1wq+rTGTpuluLwf8qoo4zZn8GGaYsIKCip1RM+7ax98OWAsITyf
         kG4hZ9y/Wj1CLldgkCaV/27wMf7obPS0tgYchq2RP+oXOP1r79IOZeoMPKiNXSgp7Rix
         6GpTNlkP8fTc47B6UpvdFX2KQ7wx9uU8Hu6NVRXrclcUoVBQpEgpo/79hw5bnlpcG++U
         MwokMUY2nPu2XRGfzTYTcFL9vhF0n72VR/jMFpng8OYnoSJw2a7znzMQ7daWRtBDjFuj
         qtTuB38ze/5TgrwW1tDpFHGfnisiEpmniJlBBwN0HiUeEYsfLUCcm21XivLkar4DgwcP
         ms1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZTl9Olh8eAj9K5mitpaP1luX2iDXpRTtAw5W2V6+XKs=;
        b=qa2hLduCVKxi8O0Rft233FXDrm6BbIiJLS3itfefdv+783fMBufQEfGzc5/HDiqpza
         dPzWXP8KaqF1KtSnXvxcCBpWohMz52K8oXOONciQHiaCzZAqDLmXp7d3ogBh/+dq1cNf
         EzO+vRKM/Pb5jnZhl6UWEvcrGSYtp6qyfXMEVttekrrJe0BUg2PtvandE1Z8X6Spx7vE
         3C5tv/ik2ZnugyijCmu9wEAOTN/Eb3djwsB0RbNqtcwPrtFq5omFlHx57hVGxfJOn1dr
         LIb0kftEaURHQqitV//PptY2wHz6PYtwQMSSKAvi6pNFnZ17DPg7jJtWdTVTJU5rggkQ
         H01Q==
X-Gm-Message-State: AOAM532Q0z4WUjVjzpxdUBBWponvv0UkrIODjZVVZpWVv4ri4k/nYOjW
        iBhyQuULzxnnNA5NesDv+xMsKRhPKlE=
X-Google-Smtp-Source: ABdhPJzinixPHxVH03TSoC6jyyTTi9YUlv+r8fIOwtIv/xTP9430m87OI9puQqNcg8zNmN/AedF3+g==
X-Received: by 2002:a63:6243:: with SMTP id w64mr21944557pgb.430.1605110220208;
        Wed, 11 Nov 2020 07:57:00 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id l133sm3167282pfd.112.2020.11.11.07.56.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 07:56:59 -0800 (PST)
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
To:     Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Markus_Bl=c3=b6chl?= <markus.bloechl@ipetronik.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
 <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3df0cfa6-cbc9-dddb-0283-9b48fb6516d8@gmail.com>
Date:   Wed, 11 Nov 2020 07:56:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <20201111074341.24cafaf3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2020 7:43 AM, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 16:39:58 +0100 Markus Blöchl wrote:
>> The rx-vlan-filter feature flag prevents unexpected tagged frames on
>> the wire from reaching the kernel in promiscuous mode.
>> Disable this offloading feature in the lan7800 controller whenever
>> IFF_PROMISC is set and make sure that the hardware features
>> are updated when IFF_PROMISC changes.
>>
>> Signed-off-by: Markus Blöchl <markus.bloechl@ipetronik.com>
>> ---
>>
>> Notes:
>>     When sniffing ethernet using a LAN7800 ethernet controller, vlan-tagged
>>     frames are silently dropped by the controller due to the
>>     RFE_CTL_VLAN_FILTER flag being set by default since commit
>>     4a27327b156e("net: lan78xx: Add support for VLAN filtering.").
>>
>>     In order to receive those tagged frames it is necessary to manually disable
>>     rx vlan filtering using ethtool ( `ethtool -K ethX rx-vlan-filter off` or
>>     corresponding ioctls ). Setting all bits in the vlan filter table to 1 is
>>     an even worse approach, imho.
>>
>>     As a user I would probably expect that setting IFF_PROMISC should be enough
>>     in all cases to receive all valid traffic.
>>     Therefore I think this behaviour is a bug in the driver, since other
>>     drivers (notably ixgbe) automatically disable rx-vlan-filter when
>>     IFF_PROMISC is set. Please correct me if I am wrong here.
> 
> I've been mulling over this, I'm not 100% sure that disabling VLAN
> filters on promisc is indeed the right thing to do. The ixgbe doing
> this is somewhat convincing. OTOH users would not expect flow filters
> to get disabled when promisc is on, so why disable vlan filters?
> 
> Either way we should either document this as an expected behavior or
> make the core clear the features automatically rather than force
> drivers to worry about it.
> 
> Does anyone else have an opinion, please?

The semantics of promiscuous are pretty clear though, and if you have a
NIC with VLAN filtering capability which could prevent the stack from
seeing *all* packets, that would be considered a bug. I suppose that you
could not disable VLAN filtering but instead install all 4096 - N VLANs
(N being currently used) into the filter to guarantee receiving those
VLAN tagged frames?

As far as flow filters, this is actually a good question, it sounds like
there are some possibly interesting problems to solve there. For
instance with an Ethernet switch, if you had a rule that diverted
packets to be switched directly to a particular port, what should happen
when either of these ports is in promiscuous mode? Should the switch be
instructed to replace all of the rules to forward + copy to the CPU?
-- 
Florian
