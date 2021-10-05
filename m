Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86CA422C8F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbhJEPe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231513AbhJEPe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 11:34:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB98DC061749
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 08:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vdo/Roq2CRXdvz4HpLrGPRa/L0o4Z6268vZII2ENmW4=; b=DavTtbylGdGvltojzGGVrZH0uw
        w3xid6rqt47V+2QzpHT7fcgHqUFjwR3bq2hdDdLwI00LIvQpT7VobOufg3PhaE/xWvSA+wwQBdLEs
        2a6LcGBqPvKgRhkLUR9n4SFawuoCq6epmffgXf9OmANM7wfXrzdGUdMxUG2rc7AkFWHqgTy7VuScz
        ZEETPX8nP1W2Xa25e+l28Rt+5ui92OSt/ZZmOIe+YiC6tnewXYjYKfaMzwL/htTZslzQQehjtCZhZ
        7FzutTqOU/3UOLfzXuPMDAmzxquA5X8X5ThiCO/loXikqrMsGN9LFD1sawI/7U8Yi1ULglh69/trR
        9sYk/LIQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54958)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXmRA-0000UT-0z; Tue, 05 Oct 2021 16:33:00 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXmR7-00007J-6z; Tue, 05 Oct 2021 16:32:57 +0100
Date:   Tue, 5 Oct 2021 16:32:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Add mdiobus_modify_changed() helper
Message-ID: <YVxwKVZVbmC78fKK@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sean Anderson's recent patch series is introducing more read-write
operations on the MDIO bus that only need to happen if a change is
being made.

We have similar logic in __mdiobus_modify_changed(), but we didn't
add its correponding locked variant mdiobus_modify_changed() as we
had very few users. Now that we are getting more, let's add the
helper.

 drivers/net/phy/mdio_bus.c | 22 ++++++++++++++++++++++
 drivers/net/phy/phylink.c  | 28 ++++------------------------
 include/linux/mdio.h       |  2 ++
 3 files changed, 28 insertions(+), 24 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
