Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF13349484
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 23:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfFQVoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 17:44:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfFQVoh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 17:44:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8hWxnlgCDerBlIvj+w63UCSLHnF0C+AVIm4FEITlEIE=; b=CD+JLJVLfj9MvebafqYPRCUL0e
        NRBW3VdKFZZwUmfVsLLrE1NtmlpLEZqIRYSq/tSuVvsGifvEkubpdhniN/Rkzpvmw3xbQFs7lCudL
        511xtxJO1FTF5q4F0dGMnHaMaMat/Su2q66OuBojyAY9c9Q8l/ZcrwO8VJRk27uWJOuU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hczQS-0003z7-Lo; Mon, 17 Jun 2019 23:44:28 +0200
Date:   Mon, 17 Jun 2019 23:44:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: mediatek: Add MT7621 TRGMII mode
 support
Message-ID: <20190617214428.GO17551@lunn.ch>
References: <20190616182010.18778-1-opensource@vdorst.com>
 <20190617140223.GC25211@lunn.ch>
 <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 09:33:12PM +0000, René van Dorst wrote:
> Quoting Andrew Lunn <andrew@lunn.ch>:
> 
> >On Sun, Jun 16, 2019 at 08:20:08PM +0200, René van Dorst wrote:
> >>Like many other mediatek SOCs, the MT7621 SOC and the internal MT7530
> >>switch both
> >>supports TRGMII mode. MT7621 TRGMII speed is 1200MBit.
> >
> >Hi René
> >
> 
> Hi Andrew,
> 
> >Is TRGMII used only between the SoC and the Switch? Or does external
> >ports of the switch also support 1200Mbit/s? If external ports support
> >this, what does ethtool show for Speed?
> 
> Only the first GMAC of the SOC and port 6 of the switch supports this mode.
> The switch can be internal in the SOC but also a separate chip.
> 
> PHYLINK and ethertool reports the link as 1Gbit.
> The link is fixed-link with speed = 1000.
> 
> dmesg output with unposted PHYLINK patches:
> [    5.236763] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
> [    5.249813] mt7530 mdio-bus:1f: phylink_mac_config:
> mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1 an=1
> [    6.389435] mtk_soc_eth 1e100000.ethernet eth0: phylink_mac_config:
> mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1 an=1

With PHYLINK, you can probably set the fixed link to the true 1.2Gbps.

> # ethtool eth0
> Settings for eth0:
>          Supported ports: [ MII ]
>          Supported link modes:   1000baseT/Full
>          Supported pause frame use: No
>          Supports auto-negotiation: No
>          Supported FEC modes: Not reported
>          Advertised link modes:  1000baseT/Full
>          Advertised pause frame use: No
>          Advertised auto-negotiation: No
>          Advertised FEC modes: Not reported
>          Speed: 1000Mb/s

We could consider adding 1200BaseT/Full?

   Andrew
