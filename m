Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE3BFFACB
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfKQQti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:49:38 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50266 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfKQQti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:49:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=C1rQWDry0dpvs0YlyglnHndpmo5lRLnq4C5C9GTT3z4=; b=Wbkd/2J0GSJMAllOqOe1jmc7U
        ejXCKWSBpPIqbvsb/5CK3plmPKOwN4k9Upy49evir2rztLcefFDYc9GAOeMOHq0sCVc1Ez8X1qF8K
        Xg+nRvzHZoxo9uiMTY+0Z8+AuV43S8+/haPqa2OWBxxmsZq2RAR6n/dUXa7Q1NGwwNjo4Fol0dmAf
        9psDbZwPmiJvtjavAl8icld+UrTJpazyZPAdzhvVPC2slFREyRuqZKRfRyhoAUU9FiFDCFEHcZi1j
        XEkHKuueej27v9dmibqS8KC6kBmMS47KPSzxjP/34SkFdG8jaUqAm5Sa690WF0/Q2E0XkhE7/HxHk
        zLru/xmIw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40904)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iWNjt-0006Pf-JP; Sun, 17 Nov 2019 16:49:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iWNjo-0007N1-Na; Sun, 17 Nov 2019 16:49:24 +0000
Date:   Sun, 17 Nov 2019 16:49:24 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        laurentiu.tudor@nxp.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v4 0/5] dpaa2-eth: add MAC/PHY support through
 phylink
Message-ID: <20191117164924.GI1344@shell.armlinux.org.uk>
References: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572477512-4618-1-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 01:18:27AM +0200, Ioana Ciornei wrote:
> The dpaa2-eth driver now has support for connecting to its associated PHY
> device found through standard OF bindings. The PHY interraction is handled
> by PHYLINK and even though, at the moment, only RGMII_* phy modes are
> supported by the driver, this is just the first step into adding the
> necessary changes to support the entire spectrum of capabilities.

Hi,

You mention that one of the aims here is to eventually support SFPs.
Do you have a plan to solve the current problem with the DPAA2
structure, where the physical network interfaces are configured at
boot time by RCW for their operating mode?

If you want full SFP support, then you will need to dynamically
reconfigure the network interfaces.  For example, 10G NBASE-T SFP+
modules will dynamically switch between 10GBASE-R (XFI), 5000BASE-X,
2500BASE-X, and SGMII depending on the copper side link speed.  The
PHY may also support UXSGMII but it doesn't power up that way and it
is not known whether it is possible or how to change the interface
mode to UXSGMII.

Then there's the whole issue of SGMII vs 1000BASE-X SFPs, and fiber
channel SFPs that can operate at 2500BASE-X.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
