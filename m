Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E805A452EB0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 11:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhKPKMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 05:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233808AbhKPKMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 05:12:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7DC061570
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 02:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=26XgUlI7jwAT2l4d3J+E1RgUnibSuYpdqUHKJZBKnlU=; b=kdcNU3TrcmYsk0mF7xjnEu2ALX
        5jsUKE35R/V+QLOyvMGhB1GTSyayWeW4CPgOj//9xIzC/mCb54Va67gjbipfjE1VDdFtT0fGcIuCh
        yYyI66THpKB2Ep4T0CkImyjZuoAL5+RXlwmnnaUHMGIDjT7v9oMUztWeDYYRjSk02196+KA9ewXzn
        /cytgFap52E1SDg11tpSUVB9LcP94o7BDvvsL2nExq0EkLdzIrsuuJB//KXT+4Z1ZNqIx8AUQ5S0/
        tT9OcHZ4Fm005Ou66y0bCrWrIpJU9NzynkAU1tAqFzK0MFcWn3oURx0LD83pAQnq78d4plXbqiAR3
        uqOht/vg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55656)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mmvOd-0000N3-WF; Tue, 16 Nov 2021 10:09:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mmvOc-0001us-8N; Tue, 16 Nov 2021 10:08:58 +0000
Date:   Tue, 16 Nov 2021 10:08:58 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 0/3] net: ocelot_net: phylink validate
 implementation updates
Message-ID: <YZODOgRlR3RY/JWX@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series converts ocelot_net to fill in the supported_interfaces
member of phylink_config, cleans up the validate() implementation,
and then converts to phylink_generic_validate().

 drivers/net/ethernet/mscc/ocelot_net.c | 41 +++++-----------------------------
 1 file changed, 6 insertions(+), 35 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
