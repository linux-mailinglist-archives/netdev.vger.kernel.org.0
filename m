Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B0B1FF38D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgFRNpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730407AbgFRNpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:45:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDEBC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 06:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cy4Eww+IphF0cIoi4ushBjsFKFGEp9AeZmtkJGS30go=; b=0evD5/lqOtWA1tj8GTvEKNDqh
        qQg23FErwrTBnqsE+Lofxy2ey6lKutTeGYvOm/1nzyfQtj9r0wgO0MZ6lm0cH3z0rsCF+cb1Wi48m
        UjeITij3xUO22fdhMYon7/U64D1SlG/eblHLcgcHp0C49hzF81Jlc2sCDdKhRAO6+iPSxXuH8vZxR
        JErDtQSyDyp2iQiKFJ1Mc0yEebRGvYygjpUXHKPac5aGZn9Oxhpk9P5Ppm4ci/SP1qxHLIqYdPlQY
        ON07grzmPs4jp0oEka6trkbktkpYgdyN4DTawKMhlsdREh4GiK7j/AfVQztLaa8m/SAqXRXK3g7gT
        47j4Cp37Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58782)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jluqj-0005A0-70; Thu, 18 Jun 2020 14:45:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jluqi-0004l7-JV; Thu, 18 Jun 2020 14:45:00 +0100
Date:   Thu, 18 Jun 2020 14:45:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Subject: [PATCH 0/9] Clause 45 PHY probing improvements
Message-ID: <20200618134500.GB1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Last time this series was posted back in May, Florian reviewed the
patches, which was the only feedback I received.  I'm now posting
them without the RFC tag.

This series aims to improve the probing for Clause 45 PHYs.

The first four patches clean up get_phy_device() and called functions,
updating the kernel doc, adding information about the various error
return values.

We then provide better kerneldoc for get_phy_device(), describing what
is going on, and more importantly what the various return codes mean.

Patch 6 adds support for probing MMDs >= 8 to check for their presence.

Patch 7 changes get_phy_c45_ids() to only set the returned
devices_in_package if we successfully find a PHY.

Patch 8 splits the use of "devices in package" from the "mmds present".

Patch 9 expands our ID reading to cover the other MMDs.

 drivers/net/phy/phy-c45.c    |   4 +-
 drivers/net/phy/phy_device.c | 159 ++++++++++++++++++++++++++++---------------
 drivers/net/phy/phylink.c    |   8 +--
 include/linux/phy.h          |   8 ++-
 4 files changed, 117 insertions(+), 62 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
