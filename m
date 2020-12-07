Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6DE2D103F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgLGMQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:16:09 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:18847 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbgLGMQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:16:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607343368; x=1638879368;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7zj8OkiqVP0y2v8pLf60YgrsvbAJ9ccfq8Fe3AUJvYA=;
  b=e4nKzdYfu59KzKPX9vz6Lew49wYKH2OME1rrCsvg9FKXTrRnzh6Os7xp
   sw6aJv0pVlYWZQkg+MScziP73EhK3gVsVYIx27UqDzJyASmAFLQHlp5Ef
   15Zw0nJzjgqJ5siObzriJ2Dj256UnjUYkF856UNjodUW9qMgfRtJj1TV+
   /xOCqcz5s2oMp+qjONeq7JKlR8QIBgSW7pFSSNUBK6OSJxzdRn6dVH/h/
   Ncr1ZM3O1qqtFdnRdrslC2484zkQzSs8yeBzakRyWKYrxQ2hrHtSFazPQ
   u2AfPa+12/qNtw6LnirwPbLcsRfGxVb3NRIw5APAlYLI28ihPzFlKCh+S
   w==;
IronPort-SDR: YZSX5V89HI6pIj7H25CGbq/6Oa//DTbqPz7fH1Xl4/isiMBd7JeVQfl/SQ74dqq3ZFoz6vxj2/
 Iw/G7mlgIJVlp6wnqTYBTl0TIRWAVes3Nv64zZi+g1XY+e05PxIMoCp3pTtLj6QpdqtcHjV5jU
 Jf9P+gBqK69EKZbtQHWnwbmYhpEGaT7p+ZQOGtgwLv2HOMBFWquMKIZoNAs4GUZbfEuEe1UJhN
 ALdYsFLV5d6afkZgDgziYBwXfkv8UscHbeX16sVE2eg7iIuohyB1dCv2UmLRzamUF263SdpMUn
 AS8=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="98863068"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 05:14:01 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 05:14:00 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 7 Dec 2020 05:13:58 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 2/4] phy: Add ethernet serdes configuration option
Date:   Mon, 7 Dec 2020 13:13:43 +0100
Message-ID: <20201207121345.3818234-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201207121345.3818234-1-steen.hegelund@microchip.com>
References: <20201207121345.3818234-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a new ethernet phy configuration structure, that
allow PHYs used for ethernet to be configured with
speed, media type and clock information.

Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 include/linux/phy/phy-ethernet-serdes.h | 30 +++++++++++++++++++++++++
 include/linux/phy/phy.h                 |  4 ++++
 2 files changed, 34 insertions(+)
 create mode 100644 include/linux/phy/phy-ethernet-serdes.h

diff --git a/include/linux/phy/phy-ethernet-serdes.h b/include/linux/phy/phy-ethernet-serdes.h
new file mode 100644
index 000000000000..d2462fadf179
--- /dev/null
+++ b/include/linux/phy/phy-ethernet-serdes.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Microchip Sparx5 Ethernet SerDes driver
+ *
+ * Copyright (c) 2020 Microschip Inc
+ */
+#ifndef __PHY_ETHERNET_SERDES_H_
+#define __PHY_ETHERNET_SERDES_H_
+
+#include <linux/types.h>
+
+enum ethernet_media_type {
+	ETH_MEDIA_DEFAULT,
+	ETH_MEDIA_SR,
+	ETH_MEDIA_DAC,
+};
+
+/**
+ * struct phy_configure_opts_eth_serdes - Ethernet SerDes This structure is used
+ * to represent the configuration state of a Ethernet Serdes PHY.
+ * @speed: Speed of the serdes interface in Mbps
+ * @media_type: Specifies which media the serdes will be using
+ */
+struct phy_configure_opts_eth_serdes {
+	u32                        speed;
+	enum ethernet_media_type   media_type;
+};
+
+#endif
+
diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
index e435bdb0bab3..78ecb375cede 100644
--- a/include/linux/phy/phy.h
+++ b/include/linux/phy/phy.h
@@ -18,6 +18,7 @@
 
 #include <linux/phy/phy-dp.h>
 #include <linux/phy/phy-mipi-dphy.h>
+#include <linux/phy/phy-ethernet-serdes.h>
 
 struct phy;
 
@@ -49,11 +50,14 @@ enum phy_mode {
  *
  * @mipi_dphy:	Configuration set applicable for phys supporting
  *		the MIPI_DPHY phy mode.
+ * @eth_serdes: Configuration set applicable for phys supporting
+ *		the ethernet serdes.
  * @dp:		Configuration set applicable for phys supporting
  *		the DisplayPort protocol.
  */
 union phy_configure_opts {
 	struct phy_configure_opts_mipi_dphy	mipi_dphy;
+	struct phy_configure_opts_eth_serdes	eth_serdes;
 	struct phy_configure_opts_dp		dp;
 };
 
-- 
2.29.2

