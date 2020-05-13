Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFBF1D045A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgEMBeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:34:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:37296 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728313AbgEMBeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:34:18 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 7067279B8061E412AB15;
        Wed, 13 May 2020 09:34:15 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 13 May 2020 09:34:15 +0800
Received: from [127.0.0.1] (10.57.37.248) by dggeme760-chm.china.huawei.com
 (10.3.19.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Wed, 13
 May 2020 09:34:14 +0800
Subject: Re: [question] net: phy: rtl8211f: link speed shows 1000Mb/s but
 actual link speed in phy is 100Mb/s
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Salil Mehta <salil.mehta@huawei.com>
References: <478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com>
 <20200512140017.GK409897@lunn.ch>
From:   Yonglong Liu <liuyonglong@huawei.com>
Message-ID: <ef25a0a2-e13f-def1-5e91-ceae1bfaf333@huawei.com>
Date:   Wed, 13 May 2020 09:34:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200512140017.GK409897@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.57.37.248]
X-ClientProxiedBy: dggeme706-chm.china.huawei.com (10.1.199.102) To
 dggeme760-chm.china.huawei.com (10.3.19.106)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrew:
	Thanks for your reply!

On 2020/5/12 22:00, Andrew Lunn wrote:
> On Tue, May 12, 2020 at 08:48:21PM +0800, Yonglong Liu wrote:
>> I use two devices, both support 1000M speed, they are directly connected
>> with a network cable. Two devices enable autoneg, and then do the following
>> test repeatedly:
>> 	ifconfig eth5 down
>> 	ifconfig eth5 up
>> 	sleep $((RANDOM%6))
>> 	ifconfig eth5 down
>> 	ifconfig eth5 up
>> 	sleep 10
>>
>> With low probability, one device A link up with 100Mb/s, the other B link up with
>> 1000Mb/s(the actual link speed read from phy is 100Mb/s), and the network can
>> not work.
>>
>> device A:
>> Settings for eth5:
>>         Supported ports: [ TP ]
>>         Supported link modes:   10baseT/Half 10baseT/Full
>>                                 100baseT/Half 100baseT/Full
>>                                 1000baseT/Full
>>         Supported pause frame use: Symmetric Receive-only
>>         Supports auto-negotiation: Yes
>>         Supported FEC modes: Not reported
>>         Advertised link modes:  10baseT/Half 10baseT/Full
>>                                 100baseT/Half 100baseT/Full
>>                                 1000baseT/Full
>>         Advertised pause frame use: Symmetric
>>         Advertised auto-negotiation: Yes
>>         Advertised FEC modes: Not reported
>>         Link partner advertised link modes:  10baseT/Half 10baseT/Full
>>                                              100baseT/Half 100baseT/Full
>>         Link partner advertised pause frame use: Symmetric
>>         Link partner advertised auto-negotiation: Yes
>>         Link partner advertised FEC modes: Not reported
>>         Speed: 100Mb/s
>>         Duplex: Full
>>         Port: MII
>>         PHYAD: 3
>>         Transceiver: internal
>>         Auto-negotiation: on
>>         Current message level: 0x00000036 (54)
>>                                probe link ifdown ifup
>>         Link detected: yes
>>
>> The regs value read from mdio are:
>> reg 9 = 0x200
>> reg a = 0
>>
>> device B:
>> Settings for eth5:
>>         Supported ports: [ TP ]
>>         Supported link modes:   10baseT/Half 10baseT/Full
>>                                 100baseT/Half 100baseT/Full
>>                                 1000baseT/Full
>>         Supported pause frame use: Symmetric Receive-only
>>         Supports auto-negotiation: Yes
>>         Supported FEC modes: Not reported
>>         Advertised link modes:  10baseT/Half 10baseT/Full
>>                                 100baseT/Half 100baseT/Full
>>                                 1000baseT/Full
>>         Advertised pause frame use: Symmetric
>>         Advertised auto-negotiation: Yes
>>         Advertised FEC modes: Not reported
>>         Link partner advertised link modes:  10baseT/Half 10baseT/Full
>>                                              100baseT/Half 100baseT/Full
>>                                              1000baseT/Full
>>         Link partner advertised pause frame use: Symmetric
>>         Link partner advertised auto-negotiation: Yes
>>         Link partner advertised FEC modes: Not reported
>>         Speed: 1000Mb/s
>>         Duplex: Full
>>         Port: MII
>>         PHYAD: 3
>>         Transceiver: internal
>>         Auto-negotiation: on
>>         Current message level: 0x00000036 (54)
>>                                probe link ifdown ifup
>>         Link detected: yes
>>
>> The regs value read from mdio are:
>> reg 9 = 0
>> reg a = 0x800
>>
>> I had talk to the FAE of rtl8211f, they said if negotiation failed with 1000Mb/s,
>> rtl8211f will change reg 9 to 0, than try to negotiation with 100Mb/s.
>>
>> The problem happened as:
>> ifconfig eth5 up -> phy_start -> phy_start_aneg -> phy_modify_changed(MII_CTRL1000)
>> (this time both A and B, reg 9 = 0x200) -> wait for link up -> (B: reg 9 changed to 0)
>> -> link up.
> 
> This sounds like downshift, but not correctly working. 1Gbps requires
> that 4 pairs in the cable work. If a 1Gbps link is negotiated, but
> then does not establish because one of the pairs is broken, some PHYs
> will try to 'downshift'. They drop down to 100Mbps, which only
> requires two pairs of the cable to work. To do this, the PHY should
> change what it is advertising, to no longer advertise 1G, just 100M
> and 10M. The link partner should then try to use 100Mbps and
> hopefully, a link is established.
> 
> Looking at the ethtool, you can see device A is reporting device B is
> only advertising upto 100Mbps. Yet it is locally using 1G. That is
> broken. So i would say device A has the problem. Are both PHYs
> rtl8211f?

Both PHY is rtl8211f. I think Device B is broken. Device B advertising
it supported 1G, but actually, in phy, downshift to 100M, so Device B
link up with 1G in driver side, but actually 100M in phy.

> 
>> I think this is the bug of the rtl8211f itself, any one have an idea
>> to avoid this bug?
> 
> Are you 100% sure your cable and board layout is good? Is it trying> downshift because something is broken? Fix the cable/connector and the

Will check the layout with hardware engineer. This happened with a low
probability. When this happened, another down/up operation or restart
autoneg will solved.

> reason to downshift goes away. But it does not solve the problem if a
> customer has a broken cable. So you might want to deliberately cut a
> pair in the cable so it becomes 100% reproducable and try to debug it
> further. See if you can find out why auto-neg is not working
> correctly.

So, your opinion is, maybe we should checkout whether the hardware layout
or cable have problem?

By the way, do we have some mechanism to solve this downshift in software
side? If the PHY advertising downshift to 100M, but software still have
advertising with 1G(just like Device B), it will always have a broken network.

> 
> 	Andrew
> 
> .
> 

