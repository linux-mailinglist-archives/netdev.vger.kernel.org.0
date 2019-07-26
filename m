Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5DD7671B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbfGZNQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:16:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40018 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726364AbfGZNQd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zlBlbbS7pVGRZymSGxMNLXgZrluPVS4d6ho9KEo9Pe8=; b=peGM8EL7a0nP0aP/yzSd4+E5sp
        FK9GZHL9uLqS0vxfePvism+CuZKTKocVBcNjB0ekZRj/G6FeguYBa39rg7rRZIHGexiWGpeP9UeX+
        rgGEsjmSoJxk8KSmV3x/M/q6fp3YPZk4fLIefVARbHzSBkS12c6To7D8y+K9aswxBWgA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hr04q-0004s6-Hl; Fri, 26 Jul 2019 15:16:04 +0200
Date:   Fri, 26 Jul 2019 15:16:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, matthias.bgg@gmail.com,
        vivien.didelot@gmail.com, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: ethernet: Update mt7622
 docs and dts to reflect the new phylink API
Message-ID: <20190726131604.GA18223@lunn.ch>
References: <20190724192411.20639-1-opensource@vdorst.com>
 <20190725193123.GA32542@lunn.ch>
 <20190726071956.Horde.s4rfuzovwXB-d3LnV0PLRc8@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190726071956.Horde.s4rfuzovwXB-d3LnV0PLRc8@www.vdorst.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 07:19:56AM +0000, René van Dorst wrote:
> Quoting Andrew Lunn <andrew@lunn.ch>:
> 
> >>+	gmac0: mac@0 {
> >>+		compatible = "mediatek,eth-mac";
> >>+		reg = <0>;
> >>+		phy-mode = "sgmii";
> >>+
> >>+		fixed-link {
> >>+			speed = <2500>;
> >>+			full-duplex;
> >>+			pause;
> >>+		};
> >>+	};
> >
> >Hi René
> >
> 
> Hi Andrew,
> 
> >SGMII and fixed-link is rather odd. Why do you need this combination?
> 
> BananaPi R64 has a RTL8367S 5+2-port switch, switch interfaces with the SOC
> by a
> (H)SGMII and/or RGMII interface. SGMII is mainly used for the LAN ports and
> RGMII for the WAN port.
> 
> I mimic the SDK software which puts SGMII interface in 2.5GBit fixed-link
> mode.
> The RTL8367S switch code also put switch mac in forge 2.5GBit mode.
> 
> So this is the reason why I put a fixed-link mode here.

Are you sure it is using SGMII and not 2500BaseX? Can you get access
to the signalling word? SGMII is supposed to indicate to the MAC what
speed it is using, via inband signalling. So there should not be any
need for a fixed-link. 2500BaseX however does not have such
signalling, so there would need to be a fixed link.

Maybe we should really consider what phy-mode = "sgmii"; means. Should
this include the overclocked 2.5G speed, or should we add a 2500sgmii
link mode?

     Andrew
