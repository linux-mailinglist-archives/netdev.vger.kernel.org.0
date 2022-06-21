Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 340F3552F5A
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 12:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiFUKCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 06:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiFUKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 06:02:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78911275D7;
        Tue, 21 Jun 2022 03:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CebAnGs2I4e+XopgqgMPynRsVklLyL9H2XvsgpMCH3A=; b=1XHoW/tBFaJiaNKU4sevkeQHAT
        wzUfAxdFftsUy5g5L9/JF4dxs7GL+VOQbvh9kbNbOhX+4Z0Dk6MK1XuRFVV1Uc0nCTbXndIkQJc/V
        fwbyHU2KTxvyHKNGA6gBBeuO/455fTuUXYM0dFbEg37zaZG+VPpP0SeJqJzdnrOQTlpbRRBOoeaYA
        up/T//k0ritMvyTsQS6847SkS55N2B0Yi/8FucBKE+t4PaP6z2/awQDssBq7Mb7g/DRmvLmZ4y6By
        WWSgQ9hM3rgxBf1g95BU/wLA2wFBAsd+pJb2t6V6Fh5HJnn9mr0xVhiiVqxFEFhhmMrzguYTPIPpo
        TNbTmF3Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32960)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o3ahq-0002AF-2D; Tue, 21 Jun 2022 11:01:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o3ahl-0005w5-HX; Tue, 21 Jun 2022 11:01:53 +0100
Date:   Tue, 21 Jun 2022 11:01:53 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 01/12] net: phy: fixed_phy: switch to fwnode_
 API
Message-ID: <YrGXEReoc3qweU1S@shell.armlinux.org.uk>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-2-mw@semihalf.com>
 <YrC1gEf4HpRp5zkh@lunn.ch>
 <CAPv3WKe3vBJ9r=6tMEtPj-3c0E3MBpW4Csf8zjS0jG03C35ycg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKe3vBJ9r=6tMEtPj-3c0E3MBpW4Csf8zjS0jG03C35ycg@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 11:56:06AM +0200, Marcin Wojtas wrote:
> pon., 20 cze 2022 o 19:59 Andrew Lunn <andrew@lunn.ch> napisał(a):
> >
> > On Mon, Jun 20, 2022 at 05:02:14PM +0200, Marcin Wojtas wrote:
> > > This patch allows to use fixed_phy driver and its helper
> > > functions without Device Tree dependency, by swtiching from
> > > of_ to fwnode_ API.
> >
> > Do you actually need this? phylink does not use this code, it has its
> > own fixed link implementation. And that implementation is not limited
> > to 1G.
> >
> 
> Yes, phylink has its own fixed-link handling, however the
> net/dsa/port.c relies on fixed_phy helpers these are not 1:1
> equivalents. I assumed this migration (fixed_phy -> phylink) is not
> straightforward and IMO should be handled separately. Do you recall
> justification for not using phylink in this part of net/dsa/*?

All modern DSA drivers use phylink and not fixed-phy as far as I'm
aware - there are a number that still implement the .adjust_link
callback, but note in dsa_port_link_register_of():

        if (!ds->ops->adjust_link) {
	...
		return 0;
	}

	dev_warn(ds->dev,
		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");

It's really just that they haven't been migrated.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
