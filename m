Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E003471A42
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhLLNBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhLLNBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 08:01:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C1C061714
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 05:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=58R7jiYWFw7GIrEbSLWqRMSidUnqz0Ryva5lwW0x8b8=; b=yY3NjLwfLdp80LSAmvYrsk2CI/
        wJ8GILLBwcnPFQjbTUOsMaimues4IRX4x9Mhg/hA8l+4PvtKboipq54prPx4mDmG2eovSvZ5a6pyy
        G45t5KwCgycFQhV1YtOYHEnKx3eda1km9pNu/8Q7l+4PykK+vIvO5x7ElUzj1vDVIhV+HkdE4jiLV
        pq7DvIdD5vsnh6eyl+fiCsUvlyuADNNsHgKpaYAf9DrO/YOP6+gnAhnsLAGO5I+ucmSHKu8JfqHn8
        71fQfidh8XKqMY2OIr+WfvF6BF5OKRTA9WM1qHHa+1r2l+nLG/geFaHpnHpBqugNjKaaGnx7bZN0A
        Y171MD/Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42542 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mwOTc-0002bd-Ce; Sun, 12 Dec 2021 13:01:16 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mwOTb-00FHgY-TW; Sun, 12 Dec 2021 13:01:15 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next] net: axienet: mark as a legacy_pre_march2020 driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mwOTb-00FHgY-TW@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 12 Dec 2021 13:01:15 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

axienet has a PCS, but does not make use of the phylink PCS support.
Mark it was a pre-March 2020 driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
This driver was missed from the patch set when the patches were sent
for merging; it was in the original RFC series.

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index e39356364f33..23ac353b35fe 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2051,6 +2051,7 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
+	lp->phylink_config.legacy_pre_march2020 = true;
 	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD;
 
-- 
2.30.2

