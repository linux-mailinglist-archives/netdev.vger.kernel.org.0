Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D111448460A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 17:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233868AbiADQh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 11:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232572AbiADQh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 11:37:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEFDC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 08:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PVaDyFAGotGE8t8xxB5G8c7NMMO99XTQDiDDMee85Y8=; b=I02ePHf6sHJcltpZ1Hfy9/IYVV
        PlhAmkszQIKmbr30RrAPlSEaZ9B3kRcUxnm6XyX9dEA4wIcWbHzgjIYStIv7r0xqI2Q6bXWRgxs7m
        cHY/kdxbIOecVN6TAx0Rj/StxzsxFK1gZCF2hUDs9ggCKBNNkR++0o2VietoS+CTG8GllxyB7pyRX
        NYQ5norS0tQ6z9KhVCL4znMOcCfO2s89AXfyoWl0hM5fs7TfNoihE3vQcQbPy9+T/YGnzjKm94n7W
        Yf7DjfKXwCyE2WZSauy3iKD0MoUcDEgcma9Qf32j1Dr06mIFa92wsIsnERYDLpn09V6sq/tqDGE+w
        MBJGVDJw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56572)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4moN-0007GZ-2k; Tue, 04 Jan 2022 16:37:23 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4moL-0007OC-Ck; Tue, 04 Jan 2022 16:37:21 +0000
Date:   Tue, 4 Jan 2022 16:37:21 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Fix RGMII delays for 88E1118
Message-ID: <YdR3wYFkm4eJApwb@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series fixes the RGMII delays for 88E1118 Marvell PHYs, after a
report by Corentin Labbe that the Marvell driver fails to work.

Patch 1 cleans up the paged register accesses in m88e1118_config_init()
and patch 2 adds the RGMII delay configuration.

This comes with an element of risk as existing DT may need to be fixed
for this in a similar way as we have done in the recent past for other
PHY drivers that have misinterpreted the RGMII interface modes.

 drivers/net/phy/marvell.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
