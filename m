Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D09207987
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405183AbgFXQuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404017AbgFXQux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:50:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0716C061573;
        Wed, 24 Jun 2020 09:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u1F8tzMKngdxJFt6gQRkq7xv28jRUmanHyUKEBsVcpo=; b=ZGlh5RxW4InxZ7Jr34mRSgpIP
        BC2ZXdwKmi/rqOnIyw8h6eqsHXyNX5FojKj6InS5slHvG3YMArCT54vpxpu/7MGSLfuaGmwGzbjv+
        z/F3ILATxpDuv6PPr5chSvFdCgfo4Pi+HjIZ9EfUnKQ4q5mLqCx8/LNBM3Tl8h28x2JUtDhFCi5hl
        xP9NWxSApDu96csu/sWRtzkhfjU7KWm5HOnwDz4bM8JRzCxtv2hAmeo9GTJ1biToCaETwYv2b+9h9
        Nb67L1V53qnsN8mxbjmrZqWHzVcqXEiI5d3te+Xn/oBrbQErI5XzcXyRpZ6S6nA1ckuLGZVIpMs+P
        fapGRzjCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59220)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jo8bQ-0003Ld-UJ; Wed, 24 Jun 2020 17:50:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jo8bI-00027P-9n; Wed, 24 Jun 2020 17:50:16 +0100
Date:   Wed, 24 Jun 2020 17:50:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
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
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 09/15] net: phy: delay PHY driver probe until PHY
 registration
Message-ID: <20200624165016.GA1551@shell.armlinux.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-10-brgl@bgdev.pl>
 <20200622133940.GL338481@lunn.ch>
 <20200622135106.GK4560@sirena.org.uk>
 <dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com>
 <20200624094302.GA5472@sirena.org.uk>
 <CAMRc=McBxJdujCyjQF3NA=bCWHF1dx8xJ1Nc2snmqukvJ_VyoQ@mail.gmail.com>
 <f806586d-a6d7-99af-bba4-d1e7d28be192@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f806586d-a6d7-99af-bba4-d1e7d28be192@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 09:06:28AM -0700, Florian Fainelli wrote:
> On 6/24/2020 6:48 AM, Bartosz Golaszewski wrote:
> > I didn't expect to open such a can of worms...
> > 
> > This has evolved into several new concepts being proposed vs my
> > use-case which is relatively simple. The former will probably take
> > several months of development, reviews and discussions and it will
> > block supporting the phy supply on pumpkin boards upstream. I would
> > prefer not to redo what other MAC drivers do (phy-supply property on
> > the MAC node, controlling it from the MAC driver itself) if we've
> > already established it's wrong.
> 
> You are not new to Linux development, so none of this should come as a
> surprise to you. Your proposed solution has clearly short comings and is
> a hack, especially around the PHY_ID_NONE business to get a phy_device
> only then to have the real PHY device ID. You should also now that "I
> need it now because my product deliverable depends on it" has never been
> received as a valid argument to coerce people into accepting a solution
> for which there are at review time known deficiencies to the proposed
> approach.

It /is/ a generic issue.  The same problem exists for AMBA Primecell
devices, and that code has an internal deferred device list that it
manages.  See drivers/amba/bus.c, amba_deferred_retry_func(),
amba_device_try_add(), and amba_device_add().

As we see more devices gain this property, it needs to be addressed
in a generic way, rather than coming up with multiple bus specific
implementations.

Maybe struct bus_type needs a method to do the preparation to add
a device (such as reading IDs etc), which is called by device_add().
If that method returns -EPROBE_DEFER, the device gets added to a
deferred list, which gets retried when drivers are successfully
probed.  Possible maybe?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
