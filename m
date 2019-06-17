Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7AE495C4
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 01:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfFQXUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 19:20:07 -0400
Received: from mx.0dd.nl ([5.2.79.48]:39954 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfFQXUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 19:20:07 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 6DE175FEE7;
        Tue, 18 Jun 2019 01:20:04 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="uOfUPqnK";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 31DC51C7A096;
        Tue, 18 Jun 2019 01:20:04 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 31DC51C7A096
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1560813604;
        bh=1V+kDFbsQWF2yVaPvwyK9QrJHGtmWAERQrJ9w82bGkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uOfUPqnKv2RKjGgsDvHezjQzYlcYRsBbJMIJqRIRlElb40ISlrs11soXd5jC2zl81
         E4Chur7eznaSsLZUUQd4Zycv0OIrADj61duD/0a/tkO2bnpzEP8qJMrF2unh8/Dhwj
         t0zoZSCha0UrGy9vZU84+INmpA6qSBnXCDKCEOnXgVmI/+b1EMr8T7AtWafEUhHcC6
         cBforI4Gh6/zPaOZ+crSgSzbRU8Oy/1flM116u1Yli3so42GglBPFuF0hRrat835Rc
         PP2IbTv2l5l66RYGnRKbWLlzyE0fqkQKigHvu1GmqdyYzwD5WpKWyKXcI6qfiR1NR0
         jz9VWQKuREyIg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Mon, 17 Jun 2019 23:20:04 +0000
Date:   Mon, 17 Jun 2019 23:20:04 +0000
Message-ID: <20190617232004.Horde.mAVymZdeb9Jjf29W2PeOggU@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mediatek: Add MT7621 TRGMII mode
 support
References: <20190616182010.18778-1-opensource@vdorst.com>
 <20190617140223.GC25211@lunn.ch>
 <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
 <20190617214428.GO17551@lunn.ch>
In-Reply-To: <20190617214428.GO17551@lunn.ch>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Lunn <andrew@lunn.ch>:

Hi Andrew,

> On Mon, Jun 17, 2019 at 09:33:12PM +0000, René van Dorst wrote:
>> Quoting Andrew Lunn <andrew@lunn.ch>:
>>
>> >On Sun, Jun 16, 2019 at 08:20:08PM +0200, René van Dorst wrote:
>> >>Like many other mediatek SOCs, the MT7621 SOC and the internal MT7530
>> >>switch both
>> >>supports TRGMII mode. MT7621 TRGMII speed is 1200MBit.
>> >
>> >Hi René
>> >
>>
>> Hi Andrew,
>>
>> >Is TRGMII used only between the SoC and the Switch? Or does external
>> >ports of the switch also support 1200Mbit/s? If external ports support
>> >this, what does ethtool show for Speed?
>>
>> Only the first GMAC of the SOC and port 6 of the switch supports this mode.
>> The switch can be internal in the SOC but also a separate chip.
>>
>> PHYLINK and ethertool reports the link as 1Gbit.
>> The link is fixed-link with speed = 1000.
>>
>> dmesg output with unposted PHYLINK patches:
>> [    5.236763] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
>> [    5.249813] mt7530 mdio-bus:1f: phylink_mac_config:
>> mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1 an=1
>> [    6.389435] mtk_soc_eth 1e100000.ethernet eth0: phylink_mac_config:
>> mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1 an=1
>
> With PHYLINK, you can probably set the fixed link to the true 1.2Gbps.

By adding some extra speed states in the code it seems to work.

+               if (state->speed == 1200)
+                       mcr |= PMCR_FORCE_SPEED_1000;

dmesg:
[    5.261375] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
[    5.274390] mt7530 mdio-bus:1f: phylink_mac_config:  
mode=fixed/trgmii/Unsupported (update phy-core.c)/Full  
adv=00,00000000,00000200 pause=12 link=1 an=1
[    6.296614] mtk_soc_eth 1e100000.ethernet eth0: configuring for  
fixed/trgmii link mode
[    6.313608] mtk_soc_eth 1e100000.ethernet eth0: phylink_mac_config:  
mode=fixed/trgmii/Unsupported (update phy core.c)/Full  
adv=00,00000000,00000200 pause=12 link=1 an=1

# ethtool eth0
Settings for eth0:
         Supported ports: [ MII ]
         Supported link modes:   Not reported
         Supported pause frame use: No
         Supports auto-negotiation: No
         Supported FEC modes: Not reported
         Advertised link modes:  Not reported
         Advertised pause frame use: No
         Advertised auto-negotiation: No
         Advertised FEC modes: Not reported
         Speed: 1200Mb/s
         Duplex: Full
         Port: MII
         PHYAD: 0
         Transceiver: internal
         Auto-negotiation: on
         Current message level: 0x000000ff (255)
                                drv probe link timer ifdown ifup rx_err tx_err
         Link detected: yes


>> # ethtool eth0
>> Settings for eth0:
>>          Supported ports: [ MII ]
>>          Supported link modes:   1000baseT/Full
>>          Supported pause frame use: No
>>          Supports auto-negotiation: No
>>          Supported FEC modes: Not reported
>>          Advertised link modes:  1000baseT/Full
>>          Advertised pause frame use: No
>>          Advertised auto-negotiation: No
>>          Advertised FEC modes: Not reported
>>          Speed: 1000Mb/s
>
> We could consider adding 1200BaseT/Full?

I don't have any opinion about this.
It is great that it shows nicely in ethtool but I think supporting more
speeds in phy_speed_to_str() is enough.

Also you may want to add other SOCs trgmii ranges too:
- 1200BaseT/Full for mt7621 only
- 2000BaseT/Full for mt7623 and mt7683
- 2600BaseT/Full for mt7623 only

I leave the decision to you.

Greats,

René

>
>    Andrew


