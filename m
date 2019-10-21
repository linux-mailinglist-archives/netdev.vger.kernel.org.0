Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1CF8DE163
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfJUAKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:10:19 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43969 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbfJUAKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:10:19 -0400
Received: by mail-lj1-f193.google.com with SMTP id n14so11330150ljj.10
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 17:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lJsmXghA9bj4MW9coGQv2iHXFYhIB7erLdehvCkiBm8=;
        b=fv9KRJjRBRF0GU7K38jgnfXAroHAYkJuBFwSWdswzpQgO4SsCA7fAHNjGITclSNNnZ
         NdrjV+i/pQ6fVJVmGq3wVdB+cjt5GRiFIx1yfcMVqCtd9BIYCJpF/p5ja6zNajiafDIt
         ek07xeKet0pO/3ozckCG3d0e9mZ/QyvhWbWIDGalS7dUZRgaNkvdUreubp5/dWnm2EQs
         fJpo+q6VtFnFhFL2kWM249uPYksD7oReFcoj27Z6nnE3dPZT7ZgoOvKaHI2QCbl2+NIb
         SfffzoKWjq7w7lmW/vQly0u5PnecveAX3Tg3qqVWhjP113svTU8Q1ctlnVX9dDV6McGM
         I4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lJsmXghA9bj4MW9coGQv2iHXFYhIB7erLdehvCkiBm8=;
        b=lg6Dr9XvXVxNt2R1WW7tjrwKAnf+IjFUzJh/U08nobNqU6eKjbjHhYTJ/nd6GWu83k
         NjlvZtSMYMch9Q1ehO5gf2x5KVlF2hDsG2StaCYqk1IU7WXt3zO7CrullOKr0rn1HmvV
         WrBUoKZgnzeVAM5h6ke1/OdMD6neB2C0LgBh0b3gk5xUJNLvt/o4FYbemFifPNYcJmbE
         oQ4/8JNX9JgxZ/ssIYylz7aHObgTIUUE6HHGyk6fHR1Weodp9yyYrQLejkXriJMSfHgw
         qtNNcxH+c8UAKER8Lntp/9pC4k85SPz0y5km5ollCoeGe5RLVcV7E1lXo6oNo48D3yAv
         2XfQ==
X-Gm-Message-State: APjAAAXqE37j221ZtekS6lqRYgIzTK0poqU2m+aKAkZ7NJEwqXW7PGxS
        AZ7q2luVagCkr0zPywHrTRGg2Bool+c=
X-Google-Smtp-Source: APXvYqyuo9YDC74WMeQGfJm4qomxCgwbK2bZOCC1WGfuGsJvbRY+Ebgo6xIRFkzNoZJkEp9DgxtYkw==
X-Received: by 2002:a2e:b0d8:: with SMTP id g24mr10114035ljl.159.1571616616233;
        Sun, 20 Oct 2019 17:10:16 -0700 (PDT)
Received: from localhost.bredbandsbolaget (c-79c8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.200.121])
        by smtp.gmail.com with ESMTPSA id a18sm2723081lfi.15.2019.10.20.17.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2019 17:10:13 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/10] ixp4xx_eth: move platform_data definition
Date:   Mon, 21 Oct 2019 02:08:18 +0200
Message-Id: <20191021000824.531-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The platform data is needed to compile the driver as standalone,
so move it to a global location along with similar files.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ixp4xx/include/mach/platform.h  | 13 +------------
 .../xscale/{ptp_ixp46x.h => ixp46x_ts.h}      |  0
 drivers/net/ethernet/xscale/ixp4xx_eth.c      |  1 +
 include/linux/platform_data/eth_ixp4xx.h      | 19 +++++++++++++++++++
 4 files changed, 21 insertions(+), 12 deletions(-)
 rename drivers/net/ethernet/xscale/{ptp_ixp46x.h => ixp46x_ts.h} (100%)
 create mode 100644 include/linux/platform_data/eth_ixp4xx.h

diff --git a/arch/arm/mach-ixp4xx/include/mach/platform.h b/arch/arm/mach-ixp4xx/include/mach/platform.h
index 04ef8025accc..6d403fe0bf52 100644
--- a/arch/arm/mach-ixp4xx/include/mach/platform.h
+++ b/arch/arm/mach-ixp4xx/include/mach/platform.h
@@ -15,6 +15,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/reboot.h>
+#include <linux/platform_data/eth_ixp4xx.h>
 
 #include <asm/types.h>
 
@@ -92,18 +93,6 @@ struct ixp4xx_pata_data {
 	void __iomem	*cs1;
 };
 
-#define IXP4XX_ETH_NPEA		0x00
-#define IXP4XX_ETH_NPEB		0x10
-#define IXP4XX_ETH_NPEC		0x20
-
-/* Information about built-in Ethernet MAC interfaces */
-struct eth_plat_info {
-	u8 phy;		/* MII PHY ID, 0 - 31 */
-	u8 rxq;		/* configurable, currently 0 - 31 only */
-	u8 txreadyq;
-	u8 hwaddr[6];
-};
-
 /*
  * Frequency of clock used for primary clocksource
  */
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.h b/drivers/net/ethernet/xscale/ixp46x_ts.h
similarity index 100%
rename from drivers/net/ethernet/xscale/ptp_ixp46x.h
rename to drivers/net/ethernet/xscale/ixp46x_ts.h
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 0075ecdb21f4..e811bf0d23cb 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -29,6 +29,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/platform_data/eth_ixp4xx.h>
 #include <linux/platform_device.h>
 #include <linux/ptp_classify.h>
 #include <linux/slab.h>
diff --git a/include/linux/platform_data/eth_ixp4xx.h b/include/linux/platform_data/eth_ixp4xx.h
new file mode 100644
index 000000000000..6f652ea0c6ae
--- /dev/null
+++ b/include/linux/platform_data/eth_ixp4xx.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __PLATFORM_DATA_ETH_IXP4XX
+#define __PLATFORM_DATA_ETH_IXP4XX
+
+#include <linux/types.h>
+
+#define IXP4XX_ETH_NPEA		0x00
+#define IXP4XX_ETH_NPEB		0x10
+#define IXP4XX_ETH_NPEC		0x20
+
+/* Information about built-in Ethernet MAC interfaces */
+struct eth_plat_info {
+	u8 phy;		/* MII PHY ID, 0 - 31 */
+	u8 rxq;		/* configurable, currently 0 - 31 only */
+	u8 txreadyq;
+	u8 hwaddr[6];
+};
+
+#endif
-- 
2.21.0

