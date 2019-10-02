Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D1FC4A81
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 11:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfJBJVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 05:21:34 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:15585 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725848AbfJBJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 05:21:34 -0400
X-UUID: 3c26d45595b54b3584ae1990c3361025-20191002
X-UUID: 3c26d45595b54b3584ae1990c3361025-20191002
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1288188747; Wed, 02 Oct 2019 17:21:30 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs05n1.mediatek.inc (172.21.101.15) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 2 Oct 2019 17:21:27 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 2 Oct 2019 17:21:27 +0800
Message-ID: <1570008088.13954.14.camel@mtksdccf07>
Subject: Re: [PATCH net 2/2] arm: dts: mediatek: Fix mt7629 dts to reflect
 the latest dt-binding
From:   mtk15127 <Mark-MC.Lee@mediatek.com>
To:     =?ISO-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@openwrt.org>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Mark Rutland" <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, MarkLee <Mark-MC.Lee@mediatek.com>
Date:   Wed, 2 Oct 2019 17:21:28 +0800
In-Reply-To: <20191001135608.Horde.OSYef8s44rR0XHw22Bf55r8@www.vdorst.com>
References: <20191001123150.23135-1-Mark-MC.Lee@mediatek.com>
         <20191001123150.23135-3-Mark-MC.Lee@mediatek.com>
         <20191001135608.Horde.OSYef8s44rR0XHw22Bf55r8@www.vdorst.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-10-01 at 13:56 +0000, René van Dorst wrote:
> Hi MarkLee,
> 
> Quoting MarkLee <Mark-MC.Lee@mediatek.com>:
> 
> > * Removes mediatek,physpeed property from dtsi that is useless in PHYLINK
> > * Set gmac0 to fixed-link sgmii 2.5Gbit mode
> > * Set gmac1 to gmii mode that connect to a internal gphy
> >
> > Signed-off-by: MarkLee <Mark-MC.Lee@mediatek.com>
> > ---
> >  arch/arm/boot/dts/mt7629-rfb.dts | 13 ++++++++++++-
> >  arch/arm/boot/dts/mt7629.dtsi    |  2 --
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/mt7629-rfb.dts  
> > b/arch/arm/boot/dts/mt7629-rfb.dts
> > index 3621b7d2b22a..6bf1f7d8ddb5 100644
> > --- a/arch/arm/boot/dts/mt7629-rfb.dts
> > +++ b/arch/arm/boot/dts/mt7629-rfb.dts
> > @@ -66,9 +66,21 @@
> >  	pinctrl-1 = <&ephy_leds_pins>;
> >  	status = "okay";
> >
> > +	gmac0: mac@0 {
> > +		compatible = "mediatek,eth-mac";
> > +		reg = <0>;
> > +		phy-mode = "sgmii";
> > +		fixed-link {
> > +			speed = <2500>;
> > +			full-duplex;
> > +			pause;
> > +		};
> > +	};
> > +
> >  	gmac1: mac@1 {
> >  		compatible = "mediatek,eth-mac";
> >  		reg = <1>;
> > +		phy-mode = "gmii";
> >  		phy-handle = <&phy0>;
> >  	};
> >
> > @@ -78,7 +90,6 @@
> >
> >  		phy0: ethernet-phy@0 {
> >  			reg = <0>;
> > -			phy-mode = "gmii";
> >  		};
> >  	};
> >  };
> > diff --git a/arch/arm/boot/dts/mt7629.dtsi b/arch/arm/boot/dts/mt7629.dtsi
> > index 9608bc2ccb3f..867b88103b9d 100644
> > --- a/arch/arm/boot/dts/mt7629.dtsi
> > +++ b/arch/arm/boot/dts/mt7629.dtsi
> > @@ -468,14 +468,12 @@
> >  			compatible = "mediatek,mt7629-sgmiisys", "syscon";
> >  			reg = <0x1b128000 0x3000>;
> >  			#clock-cells = <1>;
> > -			mediatek,physpeed = "2500";
> >  		};
> >
> >  		sgmiisys1: syscon@1b130000 {
> >  			compatible = "mediatek,mt7629-sgmiisys", "syscon";
> >  			reg = <0x1b130000 0x3000>;
> >  			#clock-cells = <1>;
> > -			mediatek,physpeed = "2500";
> >  		};
> >  	};
> >  };
> > --
> > 2.17.1
> 
> Does MT7629 soc has the same SGMII IP block as on the MT7622?
> If that is the case then phy-mode should set to "2500base-x".
  Yes,MT7629 and MT7622 use the same SGMII block. 
  Thanks for your suggestion, will change gmac0 phy-mode to "2500base-x"
  in the next patch.

Mark
> See discussion about the MT7622 [1] and dts of  
> mt7622-bananapi-bpi-r64.dts[2][3]
> 
> Note the code only set the phy in overclock mode if phymode =  
> 2500base-x and the
> link is a fixed-link, see [4].
> Alsp the current code doesn't support sgmii so well. Sgmii at 2.5Gbit is not
> supported at all.
> 
> Greats,
> 
> René
> 
> [1]:  
> https://lore.kernel.org/netdev/20190822144433.GT13294@shell.armlinux.org.uk/
> [2]:  
> https://lore.kernel.org/netdev/20190825174341.20750-4-opensource@vdorst.com/
> [3]:  
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts#n122
> [4]:  
> https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/tree/drivers/net/ethernet/mediatek/mtk_sgmii.c#n72
> 
> 
> 
> 
> 


