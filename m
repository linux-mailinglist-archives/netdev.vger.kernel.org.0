Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041826408BE
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 15:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233338AbiLBOtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 09:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiLBOtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 09:49:10 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CC8D2936;
        Fri,  2 Dec 2022 06:49:09 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 5AF6588;
        Fri,  2 Dec 2022 15:49:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669992547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=q6y9iigXj3WP0hzsik/QSNuzmj4g9Dp1lWgTADU4n9g=;
        b=cZaf5Cuisju6zyt4dTQ5ygX0nSSXzAQ1vJ8+HIqq7BeDigqksGEpZdn3V+30MzLnvU32tL
        iAIcAb23huqXrnS5okAsM4qshxpSxwhJlR4m1B9b3Obd046JmIxCDXEAiEZmFPvxC1og3+
        WLH5PgGuOSwxxlimkMzIs6+yHUZStIiTkGL8vFR3dTPTwafGUetN5BYlXxDatDvx9OkM+m
        vehtqii72WWk1JR092//giJwz2NkgqprsdHF1YOWAk/PN+4cnPwvXRgWrmWbCoeB34Esv/
        hlYihXkmWxz4J+aT48jnnaNxO/h2+xxZevvzRbqrl/reFPrn87XpL6GULsF5ew==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: mxl-gpy: rename MMD_VEND1 macros to match datasheet
Date:   Fri,  2 Dec 2022 15:49:00 +0100
Message-Id: <20221202144900.3298204-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the temperature sensors macros to match the names in the
datasheet.

Signed-off-by: Michael Walle <michael@walle.cc>
---
For the curious: I probably copied the prefix from the already existing
VPSPEC2_ macros in the driver, the datasheet also mentions some VPSPEC2_
names, but I suspect they are typos.

 drivers/net/phy/mxl-gpy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 27c0f161623e..0ff7ef076072 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -78,8 +78,8 @@
 				 VSPEC1_SGMII_CTRL_ANRS)
 
 /* Temperature sensor */
-#define VPSPEC1_TEMP_STA	0x0E
-#define VPSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
+#define VSPEC1_TEMP_STA	0x0E
+#define VSPEC1_TEMP_STA_DATA	GENMASK(9, 0)
 
 /* WoL */
 #define VPSPEC2_WOL_CTL		0x0E06
@@ -140,14 +140,14 @@ static int gpy_hwmon_read(struct device *dev,
 	struct phy_device *phydev = dev_get_drvdata(dev);
 	int ret;
 
-	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VPSPEC1_TEMP_STA);
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND1, VSPEC1_TEMP_STA);
 	if (ret < 0)
 		return ret;
 	if (!ret)
 		return -ENODATA;
 
 	*value = polynomial_calc(&poly_N_to_temp,
-				 FIELD_GET(VPSPEC1_TEMP_STA_DATA, ret));
+				 FIELD_GET(VSPEC1_TEMP_STA_DATA, ret));
 
 	return 0;
 }
-- 
2.30.2

