Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE363A4125
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhFKLUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhFKLUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:20:23 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A057C061574;
        Fri, 11 Jun 2021 04:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=DrvgGGmhKdmAiF7A1CYoQiOOQAZiaaF5Tj1DEKE7yo4=; b=MLxH2umIb1Mz/VlkqjhlX5IOg
        IiO2nQi0JGTJt1PrxZn0Uvqr/tOnQF5/3tVE4rW5P/bIR1hbjZRCpicBFFiT/eEcDESM0Hc5he3YY
        JXw/pnzmPtrADeKrONpGIZ8vF4jzo7GEFemlMYLzqOtgQYmaACZJkQBuIInsOCon7NxW3sD4Vy6xW
        8DSmuEAQwlrDCgsAqhx7DWd4mE1sHZ4dV4RJWhEQtXr/6B8iXZjOLBF9RJjopsbEibQDsnwwW7Xgp
        UHayJ1tizwSUXg4wECB1diruDSMxVQiAFLt67B8YbXIyNWh7scRvis94h2affJeAYFAixhUZIwoil
        Bpfxnb/1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44910)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lrfB8-00013a-QI; Fri, 11 Jun 2021 12:18:22 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lrfB8-0001Eo-3E; Fri, 11 Jun 2021 12:18:22 +0100
Date:   Fri, 11 Jun 2021 12:18:22 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v9 14/15] net: phylink: Refactor
 phylink_of_phy_connect()
Message-ID: <20210611111821.GI22278@shell.armlinux.org.uk>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-15-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611105401.270673-15-ciorneiioana@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 01:54:00PM +0300, Ioana Ciornei wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Refactor phylink_of_phy_connect() to use phylink_fwnode_phy_connect().
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Acked-by: Grant Likely <grant.likely@arm.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
