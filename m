Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2303341119E
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 11:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbhITJID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 05:08:03 -0400
Received: from www.zeus03.de ([194.117.254.33]:54400 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236118AbhITJHT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 05:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=GnB9PaNYAVWoSF
        sgf1jz7+etGw0c6Zs8IYhl8WXWXSE=; b=b+nWIIMq23r6AsaJWdNuPhfv4+LZg3
        gna6Yftspr/xvq6bIxktV26mcxPy+kpBtPeqsy9MJ8xvJVrz0HGhe3p2jl8zMyGJ
        pygO1YxAdc9SU3lI2XjszJehRIRvgjfJGWLsRHVHyl9KfC8kxPM+edMfZg6phmiO
        D2KOM3q7TS6OA=
Received: (qmail 2412743 invoked from network); 20 Sep 2021 11:05:27 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 20 Sep 2021 11:05:27 +0200
X-UD-Smtp-Session: l3s3148p1@uof8lGnMFIsgAwDPXwlxANIWpbLKE1Uh
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 7/9] net: mdio: mdio-bcm-iproc: simplify getting .driver_data
Date:   Mon, 20 Sep 2021 11:05:19 +0200
Message-Id: <20210920090522.23784-8-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
References: <20210920090522.23784-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should get 'driver_data' from 'struct device' directly. Going via
platform_device is an unneeded step back and forth.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Build tested only. buildbot is happy.

 drivers/net/mdio/mdio-bcm-iproc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-bcm-iproc.c b/drivers/net/mdio/mdio-bcm-iproc.c
index 77fc970cdfde..5666cfab15b9 100644
--- a/drivers/net/mdio/mdio-bcm-iproc.c
+++ b/drivers/net/mdio/mdio-bcm-iproc.c
@@ -181,8 +181,7 @@ static int iproc_mdio_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM_SLEEP
 static int iproc_mdio_resume(struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct iproc_mdio_priv *priv = platform_get_drvdata(pdev);
+	struct iproc_mdio_priv *priv = dev_get_drvdata(dev);
 
 	/* restore the mii clock configuration */
 	iproc_mdio_config_clk(priv->base);
-- 
2.30.2

