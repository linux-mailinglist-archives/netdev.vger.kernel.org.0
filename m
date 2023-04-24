Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3C56ECF81
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjDXNqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjDXNqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:46:39 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E7476AC
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682343989; x=1713879989;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aYEfdsEl+RcU4h6wpTrvPLQjiOWcDRb4FecP42B3/3g=;
  b=gcX9u7Vpmeb+eRisp7SIruXrhjVXSeoNq+m6CpT8umjnzJ2cf3W7Ipci
   MJIxJU7bgLou3VLTtZ9qxGuQL1inIPk51Xh0nVW612clkx0g7uUWdx1sh
   69H4JHToDi48CdXWUWCLnvxTko145T9MUlzfTUgwy6sEqhjnRiVe1bpnK
   fHSBUJyCkKQXd5nYRrJIncmjpU6kAlYQE5L1ZwHgoUIq28x0k/JDyAB/Q
   m69NLWlb3djcqHORSXU4lpjHo3WRpbeqzj/0QMclhOgi5yyu5zxNwsdGG
   GXxH7owvsx7XEugSz2sFGd6/GKidN2a0Qgu+HVMTOyjXEHThb0JvKYdXu
   g==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30519869"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 24 Apr 2023 15:46:27 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 24 Apr 2023 15:46:27 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 24 Apr 2023 15:46:27 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1682343987; x=1713879987;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aYEfdsEl+RcU4h6wpTrvPLQjiOWcDRb4FecP42B3/3g=;
  b=CtkanB9GQ80qiyi1rkLmk9+6CJk6G3Ga/8zrL7AOHc0o+WYNm2UPzRwY
   QlsAGu4TWMMm12d09sMJSnQtXhc7PP5NM176ZIcySqBKoQSvB2bf/41Tw
   SAt0TE0rfkQYRnnshTMuQ8JSKEoUiB5QcwmLs7HpWSbc0JUFQB4cN6WNc
   1W3bjJvey7UYzQbVt2EUcYfdAvzKDmvK9wqxN0os/KExfK3A/2XPjR+dv
   xRwnXL1mPVhyLev08N6E74ZVtsdWASE09k2F1YS4K1NEclzsbNHE3QCZE
   QVptc153qXH8BbtvJWJ65HN3dJjciEHz14BBs0S61Ydra8fw6D7BsAt+x
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,222,1677538800"; 
   d="scan'208";a="30519868"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 24 Apr 2023 15:46:27 +0200
Received: from steina-w.tq-net.de (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 4ACED280056;
        Mon, 24 Apr 2023 15:46:27 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/1] net: phy: dp83867: Add led_brightness_set support
Date:   Mon, 24 Apr 2023 15:46:25 +0200
Message-Id: <20230424134625.303957-1-alexander.stein@ew.tq-group.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up to 4 LEDs can be attached to the PHY, add support for setting
brightness manually.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
---
Blinking cannot be enforced, so led_blink_set cannot be implemented.

 drivers/net/phy/dp83867.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 5821f04c69dc..cf8ceebcc5cf 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -26,6 +26,8 @@
 #define MII_DP83867_MICR	0x12
 #define MII_DP83867_ISR		0x13
 #define DP83867_CFG2		0x14
+#define DP83867_LEDCR1		0x18
+#define DP83867_LEDCR2		0x19
 #define DP83867_CFG3		0x1e
 #define DP83867_CTRL		0x1f
 
@@ -150,6 +152,12 @@
 /* FLD_THR_CFG */
 #define DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK	0x7
 
+#define DP83867_LED_COUNT	4
+
+/* LED_DRV bits */
+#define DP83867_LED_DRV_EN(x)	BIT((x) * 4)
+#define DP83867_LED_DRV_VAL(x)	BIT((x) * 4 + 1)
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -970,6 +978,27 @@ static int dp83867_loopback(struct phy_device *phydev, bool enable)
 			  enable ? BMCR_LOOPBACK : 0);
 }
 
+static int
+dp83867_led_brightness_set(struct phy_device *phydev,
+			   u8 index, enum led_brightness brightness)
+{
+	u32 val;
+
+	if (index >= DP83867_LED_COUNT)
+		return -EINVAL;
+
+	/* DRV_EN==1: output is DRV_VAL */
+	val = DP83867_LED_DRV_EN(index);
+
+	if (brightness)
+		val |= DP83867_LED_DRV_VAL(index);
+
+	return phy_modify(phydev, DP83867_LEDCR2,
+			  DP83867_LED_DRV_VAL(index) |
+			  DP83867_LED_DRV_EN(index),
+			  val);
+}
+
 static struct phy_driver dp83867_driver[] = {
 	{
 		.phy_id		= DP83867_PHY_ID,
@@ -997,6 +1026,8 @@ static struct phy_driver dp83867_driver[] = {
 
 		.link_change_notify = dp83867_link_change_notify,
 		.set_loopback	= dp83867_loopback,
+
+		.led_brightness_set = dp83867_led_brightness_set,
 	},
 };
 module_phy_driver(dp83867_driver);
-- 
2.34.1

