Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729B3573E4C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiGMUye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbiGMUya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:54:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2A21FCE1;
        Wed, 13 Jul 2022 13:54:22 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r18so15625681edb.9;
        Wed, 13 Jul 2022 13:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M4Ea5DgMOs4/kGcfAXY6ynZjwhN2TjDtrd59QQ2UqLo=;
        b=D4Nlq7uAp5YHU1mC82JZ4Ye+Vk0PUnTzrEc4JG4HAcNhvQXyHH8mPODxkSW0ICfJx/
         hsWlq2SnFOGSzAvo39WbgP0EpJXIXPlk7h/YrfQ0Kde9u0Nt/1V68JyGpxO4UeN7PqAz
         P7lpkAhRFCnirUk/I90n0l1uLy4kmbJEhMSl9RLFBloojPjNInXb9j+Eo1/bobZkaDm7
         O3Dxv5U6tb4myRdGHrIbbn74ExLRUM95v6yLlbcAWa4j3VgQKTb2r5JmPnhOFOYydEig
         ZjOZK50fi8YPi3V3EVbr7HoIZ3G0hy+9pqoczAi0diyDAZYRs/caGtYN5vijWBLCvGIK
         gtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M4Ea5DgMOs4/kGcfAXY6ynZjwhN2TjDtrd59QQ2UqLo=;
        b=llVZeezI6u/c/5Py0gRsSYplE0Ij32N7gxCcNKP0zDxB1w4aAsK8JR7Nhi3d7DWA5+
         py/COiSdwWv79Xp1JzwQxS+jdJeQSvxd8cRijEACja88LYVYKqTgek0jSTTaS/6F4M8L
         674YFz349/uTx+PrwkB+8FWaBDK9Zb09YTjN9z8WkmUSe12MDHT3/zfgRF94VFIuzfYY
         koZooL4ClrWzxplqZEw0btOnMFm/lrZOavHtL37s+6fB7pHdW7XIRV17JerhuDik5hV8
         DnEm7ZBTKGz6rcDYypY7oNqzulG6hhunR5JrwVVyoWCJS6RdKTxbtsr65JfBI1uxZFPs
         OzRQ==
X-Gm-Message-State: AJIora87Myigz6fgShQoGMcUC/wSqQheh7aYkwwgEcnQ3f00QuO0hynB
        QNUTjRVFCdsMVXwblEkMbrQ=
X-Google-Smtp-Source: AGRyM1tN7OBEDttw3PKwT8MYEqDyE8BNuNEu4mgPnw4NshH5f/3DYfyXgyWK8gtSAvvjrzXK6mPkqA==
X-Received: by 2002:a05:6402:27ca:b0:43a:c342:b226 with SMTP id c10-20020a05640227ca00b0043ac342b226mr7598814ede.342.1657745660592;
        Wed, 13 Jul 2022 13:54:20 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id k19-20020a05640212d300b0043a8f5ad272sm8617293edx.49.2022.07.13.13.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 13:54:20 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH] net: dsa: qca8k: move driver to qca dir
Date:   Wed, 13 Jul 2022 22:53:50 +0200
Message-Id: <20220713205350.18357-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move qca8k driver to qca dir in preparation for code split and
introduction of ipq4019 switch based on qca8k.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---

This is a start for the required changes for code
split. Greg wasn't so negative about this kind of change
so I think we can finally make the move.

Still waiting some comments about the code split.
(Can I split qca8k to common function that will be
used by ipq4019? (and later propose the actual 
ipq4019 driver?))

 drivers/net/dsa/Kconfig           | 8 --------
 drivers/net/dsa/Makefile          | 1 -
 drivers/net/dsa/qca/Kconfig       | 8 ++++++++
 drivers/net/dsa/qca/Makefile      | 1 +
 drivers/net/dsa/{ => qca}/qca8k.c | 0
 drivers/net/dsa/{ => qca}/qca8k.h | 0
 6 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/net/dsa/{ => qca}/qca8k.c (100%)
 rename drivers/net/dsa/{ => qca}/qca8k.h (100%)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 702d68ae435a..d8ae0e8af2a0 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -60,14 +60,6 @@ source "drivers/net/dsa/sja1105/Kconfig"
 
 source "drivers/net/dsa/xrs700x/Kconfig"
 
-config NET_DSA_QCA8K
-	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
-	select NET_DSA_TAG_QCA
-	select REGMAP
-	help
-	  This enables support for the Qualcomm Atheros QCA8K Ethernet
-	  switch chips.
-
 source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_RZN1_A5PSW
diff --git a/drivers/net/dsa/Makefile b/drivers/net/dsa/Makefile
index b32907afa702..16eb879e0cb4 100644
--- a/drivers/net/dsa/Makefile
+++ b/drivers/net/dsa/Makefile
@@ -8,7 +8,6 @@ endif
 obj-$(CONFIG_NET_DSA_LANTIQ_GSWIP) += lantiq_gswip.o
 obj-$(CONFIG_NET_DSA_MT7530)	+= mt7530.o
 obj-$(CONFIG_NET_DSA_MV88E6060) += mv88e6060.o
-obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
 obj-$(CONFIG_NET_DSA_RZN1_A5PSW) += rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303) += lan9303-core.o
 obj-$(CONFIG_NET_DSA_SMSC_LAN9303_I2C) += lan9303_i2c.o
diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
index 13b7e679b8b5..ba339747362c 100644
--- a/drivers/net/dsa/qca/Kconfig
+++ b/drivers/net/dsa/qca/Kconfig
@@ -7,3 +7,11 @@ config NET_DSA_AR9331
 	help
 	  This enables support for the Qualcomm Atheros AR9331 built-in Ethernet
 	  switch.
+
+config NET_DSA_QCA8K
+	tristate "Qualcomm Atheros QCA8K Ethernet switch family support"
+	select NET_DSA_TAG_QCA
+	select REGMAP
+	help
+	  This enables support for the Qualcomm Atheros QCA8K Ethernet
+	  switch chips.
diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 274022319066..40bb7c27285b 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
+obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca/qca8k.c
similarity index 100%
rename from drivers/net/dsa/qca8k.c
rename to drivers/net/dsa/qca/qca8k.c
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca/qca8k.h
similarity index 100%
rename from drivers/net/dsa/qca8k.h
rename to drivers/net/dsa/qca/qca8k.h
-- 
2.36.1

