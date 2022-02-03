Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57614A8BAD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 19:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353507AbiBCSa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 13:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiBCSax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 13:30:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0725CC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 10:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sf5S2tji5tBFLX0eJXeka8UyHy0HmVDahHm73HrbmRk=; b=OSvnJaUCyW+Vgckl4bpFMZdovq
        YhINRMcP0Y0CrOfGp056O0EAtkH3bAc7nhPiAIlLOoRDNiiyzbNoyALTZhDePtNHa8HzhniZx3/AU
        XFiPjb30+xbb+GnQ6TP930AMRIwnrNSoFVv9iRESB8tb5djbpl9uZdjy+epJrTgtHN+oXGEN7XQ+3
        uoy9IS+MoSNrW7pbj90KusHaUHW927Sz4M1soP6QMTJ+vEGX4lruqlBws6eyhnQzFKPH62Zr15dnt
        sI4SljyMCyawOUa+XFkteQsUieDxCHTnJAvYRSsO8zslbeqOGhvsKIDNjbQUYJNbOQbU/ir/WayjO
        WHr9IS4Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57022)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFgsb-00038y-Pc; Thu, 03 Feb 2022 18:30:49 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFgsa-0004Dw-Gi; Thu, 03 Feb 2022 18:30:48 +0000
Date:   Thu, 3 Feb 2022 18:30:48 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/5] net: dsa: b53: convert to
 phylink_generic_validate() and mark as non-legacy
Message-ID: <YfwfWA1qTboNWcpN@shell.armlinux.org.uk>
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
 <360d1489-dbfb-d8e8-205c-4aab6ae55a30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <360d1489-dbfb-d8e8-205c-4aab6ae55a30@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 10:27:56AM -0800, Florian Fainelli wrote:
> On 2/3/2022 6:48 AM, Russell King (Oracle) wrote:
> > Hi,
> > 
> > This series converts b53 to use phylink_generic_validate() and also
> > marks this driver as non-legacy.
> > 
> > Patch 1 cleans up an if() condition to be more readable before we
> > proceed with the conversion.
> > 
> > Patch 2 populates the supported_interfaces and mac_capabilities members
> > of phylink_config.
> > 
> > Patch 3 drops the use of phylink_helper_basex_speed() which is now not
> > necessary.
> > 
> > Patch 4 switches the driver to use phylink_generic_validate()
> > 
> > Patch 5 marks the driver as non-legacy.
> 
> I won't be able to test these patches on the platform that does use the SRAB
> code until the beginning of next week since I don't actually have access to
> the hardware right now, but I will respond once tested.

That's fine, thanks for letting me know!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
