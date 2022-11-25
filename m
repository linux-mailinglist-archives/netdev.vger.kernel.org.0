Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03371638699
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiKYJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiKYJru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:47:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B105D4299A;
        Fri, 25 Nov 2022 01:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369577; x=1700905577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZOjXz2rkjGvtDluRgzS/T7XUws+UFXTfD9CLFVJfKYk=;
  b=nPASSjlTabza0iW+yAsX6ru+DrGStOPhWQ8myJ+6iFv2x1yHtkRknGym
   s755G0KptXj+Zhp6Z1D6IivxlS6//4wy6oPSeiU6nO8s2xoq99bGF22Wn
   oNWRlsPzFw+SNC7aGrLd/1lyYngI+M+TXS95hFtV3RE6OB6m+Ud4Xk7jJ
   vECDk/ZRCzQegS2Mu2lrBsxX3U7d59ds4oJTBa4WVA5jy9ZxpjKOGrpW5
   6f6QbMRrhiekrQFCijWEu0eu+XMMhUkDhEXlVKmcolNxOdmKl1SqKzFRl
   knz57jJa5Jc1TQH82ymv4WFDDZVLsCWqDgqf6+Bj6JXq0BmqVBQSaSP8y
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="188632118"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:14 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/9] net: lan966x: Add initial VCAP
Date:   Fri, 25 Nov 2022 10:50:04 +0100
Message-ID: <20221125095010.124458-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When lan966x driver is initialized, initialize also the VCAP module for
lan966x.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Kconfig    |  1 +
 .../net/ethernet/microchip/lan966x/Makefile   |  5 +++-
 .../ethernet/microchip/lan966x/lan966x_main.c |  8 ++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  6 ++++
 .../microchip/lan966x/lan966x_vcap_impl.c     | 28 +++++++++++++++++++
 5 files changed, 47 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Kconfig b/drivers/net/ethernet/microchip/lan966x/Kconfig
index b7ae5ce7d3f7a..8bcd60f17d6d3 100644
--- a/drivers/net/ethernet/microchip/lan966x/Kconfig
+++ b/drivers/net/ethernet/microchip/lan966x/Kconfig
@@ -8,5 +8,6 @@ config LAN966X_SWITCH
 	select PHYLINK
 	select PACKING
 	select PAGE_POOL
+	select VCAP
 	help
 	  This driver supports the Lan966x network switch device.
diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 251a7d561d633..2c27784859014 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -12,4 +12,7 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_tc.o lan966x_mqprio.o lan966x_taprio.o \
 			lan966x_tbf.o lan966x_cbs.o lan966x_ets.o \
 			lan966x_tc_matchall.o lan966x_police.o lan966x_mirror.o \
-			lan966x_xdp.o
+			lan966x_xdp.o lan966x_vcap_impl.o
+
+# Provide include files
+ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 42be5d0f1f015..546f3ad9f2951 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1156,8 +1156,15 @@ static int lan966x_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_ptp;
 
+	err = lan966x_vcap_init(lan966x);
+	if (err)
+		goto cleanup_fdma;
+
 	return 0;
 
+cleanup_fdma:
+	lan966x_fdma_deinit(lan966x);
+
 cleanup_ptp:
 	lan966x_ptp_deinit(lan966x);
 
@@ -1181,6 +1188,7 @@ static int lan966x_remove(struct platform_device *pdev)
 	struct lan966x *lan966x = platform_get_drvdata(pdev);
 
 	lan966x_taprio_deinit(lan966x);
+	lan966x_vcap_deinit(lan966x);
 	lan966x_fdma_deinit(lan966x);
 	lan966x_cleanup_ports(lan966x);
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index bc93051aa0798..eecb1a2bf9a72 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -290,6 +290,9 @@ struct lan966x {
 	struct lan966x_port *mirror_monitor;
 	u32 mirror_mask[2];
 	u32 mirror_count;
+
+	/* vcap */
+	struct vcap_control *vcap_ctrl;
 };
 
 struct lan966x_port_config {
@@ -560,6 +563,9 @@ static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
 	return !!port->xdp_prog;
 }
 
+int lan966x_vcap_init(struct lan966x *lan966x);
+void lan966x_vcap_deinit(struct lan966x *lan966x);
+
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
 				     int gbase, int ginst,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
new file mode 100644
index 0000000000000..8d89cfcb8502d
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+#include "vcap_api.h"
+
+int lan966x_vcap_init(struct lan966x *lan966x)
+{
+	struct vcap_control *ctrl;
+
+	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
+	if (!ctrl)
+		return -ENOMEM;
+
+	lan966x->vcap_ctrl = ctrl;
+
+	return 0;
+}
+
+void lan966x_vcap_deinit(struct lan966x *lan966x)
+{
+	struct vcap_control *ctrl;
+
+	ctrl = lan966x->vcap_ctrl;
+	if (!ctrl)
+		return;
+
+	kfree(ctrl);
+}
-- 
2.38.0

