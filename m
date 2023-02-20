Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBE269D512
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 21:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjBTUjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 15:39:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbjBTUjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 15:39:39 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC152CDE3
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 12:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=Zc1xSTwlC0td84fUFHfJvVQmMqS
        m9cAxruIKWttGvQ4=; b=ai1+PCJwGMKaHT8aULK8P5md1EtoCkiYxhOT4RvBDSk
        kRu8FEfYd+nNRIt+Gpf2E7ZOm/9TKmC91Pa2EGj/rqxCQtF1T3DltQ2g02JqERYV
        awMpkVHgtELknYZD2q4PMnPG/W7V2Qr0sKeCJtJl00hl+Z2th5lzV6c9+Dd4s+40
        =
Received: (qmail 1409209 invoked from network); 20 Feb 2023 21:39:33 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 20 Feb 2023 21:39:33 +0100
X-UD-Smtp-Session: l3s3148p1@yDYVqSf1BOAujntl
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: phy: micrel: drop superfluous use of temp variable
Date:   Mon, 20 Feb 2023 21:39:30 +0100
Message-Id: <20230220203930.31989-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'temp' was used before commit c0c99d0cd107 ("net: phy: micrel: remove
the use of .ack_interrupt()") refactored the code. Now, we can simplify
it a little.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/phy/micrel.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 54a17b576eac..82bbda820a33 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -412,11 +412,9 @@ static int kszphy_config_intr(struct phy_device *phydev)
 		if (err)
 			return err;
 
-		temp = KSZPHY_INTCS_ALL;
-		err = phy_write(phydev, MII_KSZPHY_INTCS, temp);
+		err = phy_write(phydev, MII_KSZPHY_INTCS, KSZPHY_INTCS_ALL);
 	} else {
-		temp = 0;
-		err = phy_write(phydev, MII_KSZPHY_INTCS, temp);
+		err = phy_write(phydev, MII_KSZPHY_INTCS, 0);
 		if (err)
 			return err;
 
-- 
2.30.2

