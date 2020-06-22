Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3B12037E5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgFVNZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgFVNZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:25:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8943C061573;
        Mon, 22 Jun 2020 06:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZDUlSn5jU53cp1tPLasRfOKgYW9o5ByHt6T8w7VHSbw=; b=UNo4j/9Z7nm29li5UdbbUkY9c
        BXrIyp0PeDMrh6/1rXFa1s/DpyaYpRW5Lt9ksPHRtAqAdpZcTZZWWNtCMF8x40/5UTtYyHsykxjUF
        mm/gZ7W433GtXJ+Z2/zaXZOPGErm5Z2bOB10MbLP1Rb1ouo//+R5TzOhHSGabBxPvEXUinAyQkcCR
        byltfJLzMVgXau1qeBFwL69UWxbYxNxJY9Z4Ig4G++P8d6kFrTXSmtq6JrwslQlQPppJhcKXQ9vwF
        V/ZabrP5MxwiPCAIWb+si1ZrVfHlO4GeZGIi7xDcfy+s9yzfzTjSZln5pQX8JTfYkNeCtQjEg9X/H
        oaOBDhPZQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58964)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnMRj-0000Fn-Nl; Mon, 22 Jun 2020 14:25:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnMRd-00005S-0R; Mon, 22 Jun 2020 14:25:05 +0100
Date:   Mon, 22 Jun 2020 14:25:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 13/15] net: phy: mdio: add support for PHY supply
 regulator
Message-ID: <20200622132504.GH1551@shell.armlinux.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-14-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622093744.13685-14-brgl@bgdev.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:37:42AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Currently many MAC drivers control the regulator supplying the PHY but
> this is conceptually wrong. The regulator should be defined as a property
> of the PHY node on the MDIO bus and controlled by the MDIO sub-system.
> 
> Add support for an optional PHY regulator which will be enabled before
> optional deasserting of the reset signal.

I wonder if this is the right place for this - MDIO devices do not have
to be PHYs - they can be switches, and using "phy-supply" for a switch
doesn't seem logical.

However, I can see the utility of having having a supply provided for
all mdio devices, so it seems to me to be a naming issue.  Andrew?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
