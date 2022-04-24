Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619B150CE74
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbiDXC1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbiDXC1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:27:03 -0400
Received: from smtp1.emailarray.com (smtp1.emailarray.com [65.39.216.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E98224085
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 19:24:04 -0700 (PDT)
Received: (qmail 42773 invoked by uid 89); 24 Apr 2022 02:24:03 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 24 Apr 2022 02:24:03 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v1 4/4] net: phy: Kconfig: Add broadcom PTP PHY library
Date:   Sat, 23 Apr 2022 19:23:56 -0700
Message-Id: <20220424022356.587949-5-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220424022356.587949-1-jonathan.lemon@gmail.com>
References: <20220424022356.587949-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a Broadcom PTP PHY library, initially supporting the BCM54213PE
found in the RPi CM4.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/phy/Kconfig  | 10 ++++++++++
 drivers/net/phy/Makefile |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index ea7571a2b39b..66f9c9cc51cf 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -101,6 +101,16 @@ config BROADCOM_PHY
 	  Currently supports the BCM5411, BCM5421, BCM5461, BCM54616S, BCM5464,
 	  BCM5481, BCM54810 and BCM5482 PHYs.
 
+config BCM_NET_PHYPTP
+	tristate "Broadcom PHY PTP support"
+	depends on NETWORK_PHY_TIMESTAMPING
+	depends on PHYLIB
+	depends on PTP_1588_CLOCK
+	depends on BROADCOM_PHY
+	depends on NET_PTP_CLASSIFY
+	help
+	  Supports PTP timestamping for certain Broadcom PHYs.
+
 config BCM54140_PHY
 	tristate "Broadcom BCM54140 PHY"
 	depends on PHYLIB
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b2728d00fc9a..bb21d4240a40 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_BCM84881_PHY)	+= bcm84881.o
 obj-$(CONFIG_BCM87XX_PHY)	+= bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+= bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+= bcm-phy-lib.o
+obj-$(CONFIG_BCM_NET_PHYPTP)	+= bcm-phy-ptp.o
 obj-$(CONFIG_BROADCOM_PHY)	+= broadcom.o
 obj-$(CONFIG_CICADA_PHY)	+= cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+= cortina.o
-- 
2.31.1

