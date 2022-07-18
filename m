Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3695F578BE3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiGRUjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbiGRUjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:39:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C79E6381;
        Mon, 18 Jul 2022 13:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NpoywGYSGD6/zCEmGsQO7b0EPXGTR8Bd0zOkYv1m+7o=; b=Q6BX0y7oSE08C1++V4xjcDive1
        mgx2W2yUfsAjDCTK7wH+hsZsAZZwkmkF0tTmbjRqlbCczvVmN+KWDLX5JYb8fPRwc5gmaq+It7iEn
        NkkF+cQPU+mlHV1EKCcLbNrkSugQBJAB6QWx4hV5uAPUWQG28UUkEEyYrsUGYSa3HmmDgtMHlQlEz
        0OwMEsszZ2BS5Zcj87+v3kn4KkHeIQmIppc8Vwlpdpz4erJcu7ptnGzN2Ff/WvwV8+N9pofX8L/5R
        7eRpc0J5LPoHKMl7TpsrDincGo7apswI7k7BGyd7LzC8qmDuEqQG5YowzWk2JYy0gw5CnHcgXoBj3
        8dWi7ywg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33438)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDXVz-00029e-3J; Mon, 18 Jul 2022 21:38:51 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDXVq-0002GI-5q; Mon, 18 Jul 2022 21:38:42 +0100
Date:   Mon, 18 Jul 2022 21:38:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtXE0idsKe6FZ+n4@shell.armlinux.org.uk>
References: <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWwbMucEyO+W8/Y@shell.armlinux.org.uk>
 <YtW9goFpOLGvIDog@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtW9goFpOLGvIDog@smile.fi.intel.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 11:07:30PM +0300, Andy Shevchenko wrote:
> On Mon, Jul 18, 2022 at 08:11:40PM +0100, Russell King (Oracle) wrote:
> > Good point - I guess we at least need to attach the swnode parent to the
> > device so its path is unique, because right now that isn't the case. I'm
> > guessing that:
> > 
> >         new_port_fwnode = fwnode_create_software_node(port_props, NULL);
> > 
> > will create something at the root of the swnode tree, and then:
> > 
> >         fixed_link_fwnode = fwnode_create_named_software_node(fixed_link_props,
> >                                                               new_port_fwnode,
> >                                                               "fixed-link");
> > 
> > will create a node with a fixed name. I guess it in part depends what
> > pathname the first node gets (which we don't specify.) I'm not familiar
> > with the swnode code to know what happens with the naming for the first
> > node.
> 
> First node's name will be unique which is guaranteed by IDA framework. If we
> have already 2B nodes, then yes, it would be problematic (but 2^31 ought to be
> enough :-).
> 
> > However, it seems sensible to me to attach the first node to the device
> > node, thus giving it a unique fwnode path. Does that solve the problem
> > in swnode land?
> 
> Yes, but in the driver you will have that as child of the device, analogue in DT
> 
>   my_root_node { // equal the level of device node you attach it to
> 	  fixed-link {
> 	  }
>   }
> 
> (Sorry, I don't know the DT syntax by heart, but I hope you got the idea.)

Yes, that looks about right.

What we're attempting to do here is create the swnode equivalent of this
DT description:

	some_node {
		phy-mode = "foo";

		fixed-link {
			speed = X;
			full-duplex;
		};
	};

and the some_node fwnode handle gets passed into phylink for it to
parse - we never attach it to the firmware tree itself. Once phylink
has parsed it, we destroy the swnode tree since it's no longer useful.

This would get used in this situation as an example:

	switch@4 {
		compatible = "marvell,mv88e6085";

		ports {
			port@0 {
				reg = <0>;
				phy-mode = "internal";
				phy-handle = <&sw_phy_0>;
			};
			...
			port@5 {
				reg = <5>;
				label = "cpu";
				ethernet = <&eth1>;
			};
		};
	};

The DSA driver knows the capabilities of the chip, so it knows what the
fastest "phy-mode" and speed would be, and whether full or half duplex
are supported.

We need to get this information into phylink some how, and my initial
approach was to add a new function to phylink to achieve that.

We would normally have passed the "port@5" node to phylink, just as we
pass the "port@0" node. However, because the "port@5" operates as a
fixed-link as determined by the hardware/driver, we need some way to
get that into phylink.

So, Vladimir's approach is to create a swnode tree that reflects the
DT layout, and rather than passing the "port@5" as a fwnode to phylink,
we instead pass that "some_node" swnode instead. Phylink then uses
normal fwnode APIs to parse the swnode tree it's been given, resulting
in it picking up the fixed-link specification as if it had been in the
original DT.

We don't augment the existing firmware tree for "port@5", we are
effectively creating a small sub-tree and using it as a subsitute
description.

I hope that clarifies what is going on here and why.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
