Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6829822D
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:36:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415590AbgJYOgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:36:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43472 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbgJYOgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 10:36:18 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWh7w-003RDq-Pc; Sun, 25 Oct 2020 15:36:08 +0100
Date:   Sun, 25 Oct 2020 15:36:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH] net: phy: realtek: omit setting
 PHY-side delay when "rgmii" specified
Message-ID: <20201025143608.GD792004@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io>
 <20201025141825.GB792004@lunn.ch>
 <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 10:27:05PM +0800, Icenowy Zheng wrote:
> 
> 
> 于 2020年10月25日 GMT+08:00 下午10:18:25, Andrew Lunn <andrew@lunn.ch> 写到:
> >On Sun, Oct 25, 2020 at 04:55:56PM +0800, Icenowy Zheng wrote:
> >> Currently there are many boards that just set "rgmii" as phy-mode in
> >the
> >> device tree, and leave the hardware [TR]XDLY pins to set PHY delay
> >mode.
> >> 
> >> In order to keep old device tree working, omit setting delay for just
> >> "RGMII" without any internal delay suffix, otherwise many devices are
> >> broken.
> >
> >Hi Icenowy
> >
> >We have been here before with the Atheros PHY. It did not correctly
> >implement one of the delay modes, until somebody really did need that
> >mode. So the driver was fixed. And we then found a number of device
> >trees were also buggy. It was painful for a while, but all the device
> >trees got fixed.
> 
> 1. As the PHY chip has hardware configuration for configuring delays,
> we should at least have a mode that respects what's set on the hardware.

Yes, that is PHY_INTERFACE_MODE_NA. In DT, set the phy-mode to "". Or
for most MAC drivers, don't list a phy-mode at all.

> 2. As I know, at least Fedora ships a device tree with their bootloader, and
> the DT will not be updated with kernel.

I would check that. Debian does the exact opposite, the last time i
looked. It always uses the DT that come with the kernel because it
understands DT can have bugs, like all software.

      Andrew
