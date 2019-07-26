Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F95276C6F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbfGZPQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 11:16:26 -0400
Received: from mx.0dd.nl ([5.2.79.48]:59574 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbfGZPQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 11:16:25 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 68A355FB2B;
        Fri, 26 Jul 2019 17:16:22 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="VQaqy9wL";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 215301D2A844;
        Fri, 26 Jul 2019 17:16:22 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 215301D2A844
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564154182;
        bh=m/ZOz2FsEC0YUtMqMjZjTXJt7148rlDQj0N5Q8iLfNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQaqy9wLOwsas5ImvkdNcKlGlIRrW51YuGIS1kh7QBfq44JMNNhetf9U2oUosYf/w
         5hmdK3vuhd5u3J6KhHms0GhUELsv0Z9GsXyas6l5k69XbYJnFR4HwpJDgcydg5Zy7u
         CZVqomgquSM+D5KXEYdOAEEZQMg+F/4s64MK5h1e28hXMAV3y+iUj0NGGfCpqWOUyQ
         fSoxVXFztY7shVArKqOAd4er4gBj7m1zIo3olR7NIp2FeES7p6iI3SzQDOkuoCu9L1
         x5BySbNkOwPo4psIbn8fbA7tVLD50tsXf6lAjkNkvu/LeaBv05TRdTfJ9k1s1euBXu
         OECqt/FKPCn1w==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Fri, 26 Jul 2019 15:16:22 +0000
Date:   Fri, 26 Jul 2019 15:16:22 +0000
Message-ID: <20190726151622.Horde.1AA717IbQrC7_YJcSBe4M-0@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: ethernet: Update mt7622
 docs and dts to reflect the new phylink API
References: <20190724192411.20639-1-opensource@vdorst.com>
 <20190725193123.GA32542@lunn.ch>
 <20190726071956.Horde.s4rfuzovwXB-d3LnV0PLRc8@www.vdorst.com>
 <20190726131604.GA18223@lunn.ch>
In-Reply-To: <20190726131604.GA18223@lunn.ch>
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

> On Fri, Jul 26, 2019 at 07:19:56AM +0000, René van Dorst wrote:
>> Quoting Andrew Lunn <andrew@lunn.ch>:
>>
>> >>+	gmac0: mac@0 {
>> >>+		compatible = "mediatek,eth-mac";
>> >>+		reg = <0>;
>> >>+		phy-mode = "sgmii";
>> >>+
>> >>+		fixed-link {
>> >>+			speed = <2500>;
>> >>+			full-duplex;
>> >>+			pause;
>> >>+		};
>> >>+	};
>> >
>> >Hi René
>> >
>>
>> Hi Andrew,
>>
>> >SGMII and fixed-link is rather odd. Why do you need this combination?
>>
>> BananaPi R64 has a RTL8367S 5+2-port switch, switch interfaces with the SOC
>> by a
>> (H)SGMII and/or RGMII interface. SGMII is mainly used for the LAN ports and
>> RGMII for the WAN port.
>>
>> I mimic the SDK software which puts SGMII interface in 2.5GBit fixed-link
>> mode.
>> The RTL8367S switch code also put switch mac in forge 2.5GBit mode.
>>
>> So this is the reason why I put a fixed-link mode here.
>
> Are you sure it is using SGMII and not 2500BaseX? Can you get access
> to the signalling word? SGMII is supposed to indicate to the MAC what
> speed it is using, via inband signalling. So there should not be any
> need for a fixed-link. 2500BaseX however does not have such
> signalling, so there would need to be a fixed link.

I am not sure.

I just converted the current mainline code to support phylink and  
mimic the DTS
of the SDK. But the SDK seems to be incorrect.

Realtek[0] calls these modes:
* SGMII (1.25GHz) Interface
* High SGMII (3.125GHz) Interface
Also the datasheet that I have doesn't talk about base-x modes.

But MT7622 Reference manual[1] page 1960 says:
  The core leverages the 1000Base-X PCS and Auto-Negotiation from IEEE 802.3
  specification (clause 36/37). This IP can support up to 3.125G baud  
for 2.5Gbps
  (proprietary 2500Base-X) data rate of MAC by overclocking.

So I think it phy-mode should be 2500Base-X in this case.

SGMII part is a bit hard for me to support, I don't have the hardware,
MediaTek datasheets are mostly incomplete and also I am a not familiar  
with it.

But I think I know what I have to change.
Based on your explanation above.

I think this more correct implementation:

* 1000base-x and 2500base-x always force the link.
* SGMII is always inband but I need in phylink_mac_link_status() to readout
   "PCS_SPEED_ABILITY Clause 45 3.5" register to see the inband status?
   Or is it just the GMAC PSMR register? For me it is a bit confusing.
   SGMII block has a register to set the link speed and etc. But tests on the
   bananapi R64 board shows that I also need to set the GMAC register else it
   didn't work. Also it is not easy to debug if you don't have the board.

> Maybe we should really consider what phy-mode = "sgmii"; means. Should
> this include the overclocked 2.5G speed, or should we add a 2500sgmii
> link mode?

No.

>
>      Andrew

Greats,

René

[0]:  
https://www.realtek.com/en/products/communications-network-ics/item/rtl8367s-cg
[1]:  
https://drive.google.com/file/d/1cW8KQmmVpwDGmBd48KNQes9CRn7FEgBb/view?usp=sharing

