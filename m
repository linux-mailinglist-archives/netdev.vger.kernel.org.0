Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2386557EF80
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiGWOTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 10:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbiGWOTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 10:19:45 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47011C128;
        Sat, 23 Jul 2022 07:19:32 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id c187-20020a1c35c4000000b003a30d88fe8eso6734625wma.2;
        Sat, 23 Jul 2022 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hxLZXkCpImVS+WGQcLLF+kau62/dlzx/l3VCuBDqnsc=;
        b=OOcdrY540PfWVo4DuX3qFa5120a/2tqR4fE5Q7WWJODuHG1NnrNElJ+KVg2qDiqC5L
         RPPDubO2BEs8fyCNQJmWfSSh2/6eQxA0W++I/tqDTCXX7pwjd6KNvG9WJKHBhlVUhZYs
         Jhi1I58PCFdURNYqVwVOAuRV3RGa8hsEhbr29fIy6x9qGPeUVEnPaVeJA53EW2w3bseN
         oeKF95FUd0+EHHIIwHV5D/x3fv7sJ7eN1kQJ1jd1RyirxYTzGOBLFr4JdkpbKnjo6R4w
         lf+wb5vLwflSxyGEPIeV7D60JT1NTj0e49WpWW/3k93tk15iEp0z6Z4+pnWkL++Eqzm8
         gh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hxLZXkCpImVS+WGQcLLF+kau62/dlzx/l3VCuBDqnsc=;
        b=5jsOBsu/hhySe3ZKmPuq9AcNV9Ppc+zGXtz81ZKN85LYZzbnPTLJFctakEzD+iNZIW
         9Ke6CBHQTYF7QMQPGoBxynpk7NkWXsvFGl4Z0BYocf8dAGp/0/A9q+Ef5ZB8roIQBGmv
         Ij8LA5uQdonIY2YsWHj5kxaGC/BDMoM0IyvDG+9SvuE/dOwNKo8PFWQVdN/v/lO7+oUM
         0Wpmpiu4g35woiR4IzIk6mm/IQlzy2AvNU4fsadCqJ8un6NibkkKqHTdK3hb6GuIwpE9
         QtB33sUJ1NFlwnyRFxdWJuFKWyThOnUUTb0BuYEV6vJDQdTPrlG0hnbbtSdnAauGBSvH
         7mQQ==
X-Gm-Message-State: AJIora9BkUel0AnD/iABt9THc0t1drZ1gmJtx+1KKsy2MviNZgwEXJ3Y
        OMRjAa/uNoYsua79doRQS58=
X-Google-Smtp-Source: AGRyM1vT0O5KtI4rfc05RBMtcBkvgXqMEq85w3D70jBWpUZffcdY8qaFR1I8cyLYwkqTOpJo3ZDjlQ==
X-Received: by 2002:a05:600c:1c19:b0:3a3:181e:89e with SMTP id j25-20020a05600c1c1900b003a3181e089emr15703195wms.203.1658585970742;
        Sat, 23 Jul 2022 07:19:30 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-207-127.retail.telecomitalia.it. [87.7.207.127])
        by smtp.googlemail.com with ESMTPSA id l18-20020a05600c1d1200b003a04d19dab3sm21011960wms.3.2022.07.23.07.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 07:19:30 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH v3 03/14] net: dsa: qca8k: move mib struct to common code
Date:   Sat, 23 Jul 2022 16:18:34 +0200
Message-Id: <20220723141845.10570-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220723141845.10570-1-ansuelsmth@gmail.com>
References: <20220723141845.10570-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same MIB struct is used by drivers based on qca8k family switch. Move
it to common code to make it accessible also by other drivers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca/Makefile                  |  1 +
 drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} | 51 ---------------
 drivers/net/dsa/qca/qca8k-common.c            | 63 +++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  3 +
 4 files changed, 67 insertions(+), 51 deletions(-)
 rename drivers/net/dsa/qca/{qca8k.c => qca8k-8xxx.c} (98%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c

diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
index 40bb7c27285b..701f1d199e93 100644
--- a/drivers/net/dsa/qca/Makefile
+++ b/drivers/net/dsa/qca/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
 obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
+qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
diff --git a/drivers/net/dsa/qca/qca8k.c b/drivers/net/dsa/qca/qca8k-8xxx.c
similarity index 98%
rename from drivers/net/dsa/qca/qca8k.c
rename to drivers/net/dsa/qca/qca8k-8xxx.c
index 9820c5942d2a..249dc4f89beb 100644
--- a/drivers/net/dsa/qca/qca8k.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -24,57 +24,6 @@
 
 #include "qca8k.h"
 
-#define MIB_DESC(_s, _o, _n)	\
-	{			\
-		.size = (_s),	\
-		.offset = (_o),	\
-		.name = (_n),	\
-	}
-
-static const struct qca8k_mib_desc ar8327_mib[] = {
-	MIB_DESC(1, 0x00, "RxBroad"),
-	MIB_DESC(1, 0x04, "RxPause"),
-	MIB_DESC(1, 0x08, "RxMulti"),
-	MIB_DESC(1, 0x0c, "RxFcsErr"),
-	MIB_DESC(1, 0x10, "RxAlignErr"),
-	MIB_DESC(1, 0x14, "RxRunt"),
-	MIB_DESC(1, 0x18, "RxFragment"),
-	MIB_DESC(1, 0x1c, "Rx64Byte"),
-	MIB_DESC(1, 0x20, "Rx128Byte"),
-	MIB_DESC(1, 0x24, "Rx256Byte"),
-	MIB_DESC(1, 0x28, "Rx512Byte"),
-	MIB_DESC(1, 0x2c, "Rx1024Byte"),
-	MIB_DESC(1, 0x30, "Rx1518Byte"),
-	MIB_DESC(1, 0x34, "RxMaxByte"),
-	MIB_DESC(1, 0x38, "RxTooLong"),
-	MIB_DESC(2, 0x3c, "RxGoodByte"),
-	MIB_DESC(2, 0x44, "RxBadByte"),
-	MIB_DESC(1, 0x4c, "RxOverFlow"),
-	MIB_DESC(1, 0x50, "Filtered"),
-	MIB_DESC(1, 0x54, "TxBroad"),
-	MIB_DESC(1, 0x58, "TxPause"),
-	MIB_DESC(1, 0x5c, "TxMulti"),
-	MIB_DESC(1, 0x60, "TxUnderRun"),
-	MIB_DESC(1, 0x64, "Tx64Byte"),
-	MIB_DESC(1, 0x68, "Tx128Byte"),
-	MIB_DESC(1, 0x6c, "Tx256Byte"),
-	MIB_DESC(1, 0x70, "Tx512Byte"),
-	MIB_DESC(1, 0x74, "Tx1024Byte"),
-	MIB_DESC(1, 0x78, "Tx1518Byte"),
-	MIB_DESC(1, 0x7c, "TxMaxByte"),
-	MIB_DESC(1, 0x80, "TxOverSize"),
-	MIB_DESC(2, 0x84, "TxByte"),
-	MIB_DESC(1, 0x8c, "TxCollision"),
-	MIB_DESC(1, 0x90, "TxAbortCol"),
-	MIB_DESC(1, 0x94, "TxMultiCol"),
-	MIB_DESC(1, 0x98, "TxSingleCol"),
-	MIB_DESC(1, 0x9c, "TxExcDefer"),
-	MIB_DESC(1, 0xa0, "TxDefer"),
-	MIB_DESC(1, 0xa4, "TxLateCol"),
-	MIB_DESC(1, 0xa8, "RXUnicast"),
-	MIB_DESC(1, 0xac, "TXUnicast"),
-};
-
 static void
 qca8k_split_addr(u32 regaddr, u16 *r1, u16 *r2, u16 *page)
 {
diff --git a/drivers/net/dsa/qca/qca8k-common.c b/drivers/net/dsa/qca/qca8k-common.c
new file mode 100644
index 000000000000..7a63e96c8c08
--- /dev/null
+++ b/drivers/net/dsa/qca/qca8k-common.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2009 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
+ * Copyright (c) 2015, 2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2016 John Crispin <john@phrozen.org>
+ */
+
+#include <linux/netdevice.h>
+#include <net/dsa.h>
+
+#include "qca8k.h"
+
+#define MIB_DESC(_s, _o, _n)	\
+	{			\
+		.size = (_s),	\
+		.offset = (_o),	\
+		.name = (_n),	\
+	}
+
+const struct qca8k_mib_desc ar8327_mib[] = {
+	MIB_DESC(1, 0x00, "RxBroad"),
+	MIB_DESC(1, 0x04, "RxPause"),
+	MIB_DESC(1, 0x08, "RxMulti"),
+	MIB_DESC(1, 0x0c, "RxFcsErr"),
+	MIB_DESC(1, 0x10, "RxAlignErr"),
+	MIB_DESC(1, 0x14, "RxRunt"),
+	MIB_DESC(1, 0x18, "RxFragment"),
+	MIB_DESC(1, 0x1c, "Rx64Byte"),
+	MIB_DESC(1, 0x20, "Rx128Byte"),
+	MIB_DESC(1, 0x24, "Rx256Byte"),
+	MIB_DESC(1, 0x28, "Rx512Byte"),
+	MIB_DESC(1, 0x2c, "Rx1024Byte"),
+	MIB_DESC(1, 0x30, "Rx1518Byte"),
+	MIB_DESC(1, 0x34, "RxMaxByte"),
+	MIB_DESC(1, 0x38, "RxTooLong"),
+	MIB_DESC(2, 0x3c, "RxGoodByte"),
+	MIB_DESC(2, 0x44, "RxBadByte"),
+	MIB_DESC(1, 0x4c, "RxOverFlow"),
+	MIB_DESC(1, 0x50, "Filtered"),
+	MIB_DESC(1, 0x54, "TxBroad"),
+	MIB_DESC(1, 0x58, "TxPause"),
+	MIB_DESC(1, 0x5c, "TxMulti"),
+	MIB_DESC(1, 0x60, "TxUnderRun"),
+	MIB_DESC(1, 0x64, "Tx64Byte"),
+	MIB_DESC(1, 0x68, "Tx128Byte"),
+	MIB_DESC(1, 0x6c, "Tx256Byte"),
+	MIB_DESC(1, 0x70, "Tx512Byte"),
+	MIB_DESC(1, 0x74, "Tx1024Byte"),
+	MIB_DESC(1, 0x78, "Tx1518Byte"),
+	MIB_DESC(1, 0x7c, "TxMaxByte"),
+	MIB_DESC(1, 0x80, "TxOverSize"),
+	MIB_DESC(2, 0x84, "TxByte"),
+	MIB_DESC(1, 0x8c, "TxCollision"),
+	MIB_DESC(1, 0x90, "TxAbortCol"),
+	MIB_DESC(1, 0x94, "TxMultiCol"),
+	MIB_DESC(1, 0x98, "TxSingleCol"),
+	MIB_DESC(1, 0x9c, "TxExcDefer"),
+	MIB_DESC(1, 0xa0, "TxDefer"),
+	MIB_DESC(1, 0xa4, "TxLateCol"),
+	MIB_DESC(1, 0xa8, "RXUnicast"),
+	MIB_DESC(1, 0xac, "TXUnicast"),
+};
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 7b4a698f092a..584fcd7fc355 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -422,4 +422,7 @@ struct qca8k_fdb {
 	u8 mac[6];
 };
 
+/* Common setup function */
+extern const struct qca8k_mib_desc ar8327_mib[];
+
 #endif /* __QCA8K_H */
-- 
2.36.1

