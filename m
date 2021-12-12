Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6487471A43
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 14:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhLLNBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 08:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhLLNBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 08:01:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F95C061714
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 05:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/OZtjxvphyoKFolLA0Vmma+kFBbWOh5dJ3528HL914M=; b=JpbQLHiDT4KveYWmS1qaxrFZ70
        QH+i+sf8fEK8bgtvpNuZe3GGfJurIfsWXAHlBJD3MGIukj2hAi7/YRGFriCjbLUd7fx1g+Rq1Ca2q
        urWp46nV+UGtd4fPG+i2nV5nRvVvkW16oTszW0OTi/8NhFIS+mnTAjT5a2xvgqLVDeF2Ak92BjYKW
        L2vltpMXH96K6pvSQ30ge2dkNmo63Ym3hUDoeI5o8cS8KLLxKGnHmSrJRUVwiRYBuQLReA1flM8xw
        lk3jSUfltyK1cp+U5W2ghJkwwBvUXMCaeg+Tv4uVvctd+32BIOXL3LWhobO5eoTO7C/r2UVkV8b3b
        vUWSFY7w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42544 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mwOTh-0002bm-EZ; Sun, 12 Dec 2021 13:01:21 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mwOTh-00FHge-1K; Sun, 12 Dec 2021 13:01:21 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: mvneta: mark as a legacy_pre_march2020 driver
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mwOTh-00FHge-1K@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 12 Dec 2021 13:01:21 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta provides mac_an_restart and mac_pcs_get_state methods, so needs
to be marked as a legacy driver. Marek spotted that mvneta had stopped
working in 2500base-X mode - thanks for reporting.

Reported-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index ce810fc3c1a2..e3c5d64ba340 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -5275,6 +5275,7 @@ static int mvneta_probe(struct platform_device *pdev)
 
 	pp->phylink_config.dev = &dev->dev;
 	pp->phylink_config.type = PHYLINK_NETDEV;
+	pp->phylink_config.legacy_pre_march2020 = true;
 	pp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
 		MAC_100 | MAC_1000FD | MAC_2500FD;
 
-- 
2.30.2

