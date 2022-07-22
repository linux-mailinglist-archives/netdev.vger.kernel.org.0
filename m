Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DC457E2FE
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 16:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiGVOV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiGVOV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 10:21:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCE56406;
        Fri, 22 Jul 2022 07:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hLPlQqZjJSQKPGHb0YS9zkev/y0pH7c+d/jPKAb2GH0=; b=Eipa470pMb32q7EeATriUghX+/
        KITuXZ9S4vCLTY46DmqjDyGpM7vOaTX373ELSkiENYVCUbx37ijqPkd2wE1e8eoZ/NXZn+FVtqsz4
        5A2IXJfCRbSu4HpYZz1TJWAO/I1puYiooK+eEk4qyILtT2gAbRvdqAuK7BuODcMliMa/h6kELMlhy
        wIVeKCswUAQFHcWin+dBmP6pOsTdfWz2RcKi3eUrlLuied06chsOSAqrvqr18tEZk2V7nQqkCA3Ei
        o6d+sBhp7fmyprsdGAzuuaiZSBcNf0kpciA3v0JXXoXb2tvk2/APeeqctcks5LlC1MElSVoNmw11j
        u8LOPsqw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33510)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oErYE-0006sX-48; Fri, 22 Jul 2022 13:14:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oErY1-0005of-0U; Fri, 22 Jul 2022 13:14:25 +0100
Date:   Fri, 22 Jul 2022 13:14:24 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtqUoOiiAez2Kmd5@shell.armlinux.org.uk>
References: <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 12:44:17PM +0100, Russell King (Oracle) wrote:
> Given that this managed property was introduced for mvneta, mvneta's
> implementation of it is the best reference we have to work out what
> the intentions of it were beyond the commit text.
> 
> With in-band mode enabled, mvneta makes use of a fixed-link PHY, and
> updates the fixed-link PHY with the status from its GMAC block (which
> is the combined PCS+MAC).
> 
> So, when in-band mode is specified, the results from SGMII or 1000base-X
> negotiation are read from the MAC side of the link, pushed into the
> fixed-PHY, which then are reflected back into the driver via the usual
> phylib adjust_link().

... and I should have said that this is exactly why in-band mode is
treated as a fixed-link, even though it's nothing of the sort. It makes
use of the infrastructure that was present at the time (fixed-phy) to
implement this feature of reading the link status from the PCS/MAC end
of the link.

It may not have been the best design, but it's an evolved design based
on the code that was available and what people thought at the time (and
pre-dates my involvement with mvneta in mainline.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
