Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1B2ECC9B
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbhAGJUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:20:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:46055 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbhAGJUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610011251; x=1641547251;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MP9WWZwJ7UQGmfkRmv2GckvnNbBy3hLcNw3ATo6M4Wk=;
  b=iByEdVJ6AX2+4V44LNLZVk0GjsKfzIm9oplT8rIAHksAnUT2ksxtqcNQ
   6D6pIRXnpj+ZcjBFw65EXXoWk9AIKat8dlRp2QTQDbZOhUUXpVbV1sZoX
   PvA//lfnffq8c+Ez2Toi0yOy+XwlsOSJOcDGvzfeC8VX2DHnEXFJ5OyD0
   MkJRTQFzjHk2mARhJnmpGqdIJINynuwBBVhBsEVldT+rzvd3XlwjjzjUD
   zDilIR0+D2kSEWuC5kblBr4ZUXwiQccSdOzrRyhX/0/DHlAKmWv79wHmO
   viaSGGeXyNw1B+zOiPJQuZxg8Xl45etNA/2EplcBgYFsJXTN+sRgS6VU8
   Q==;
IronPort-SDR: DLHb0qzPV2b01yfQYcPeC8yPw5I0U9Sh4elNZVEtTZ67iszf5cLY7kAp94h+YZedjrfX6BWNb8
 Ki/gsmi+1pN932F9rlDrJCW1DrgxsLRVXnnOknIjGFQWb5vRUSGAR+HsQSQbINP2FgqGB7L0sH
 NM5r4PeHJS8arIESl1qeAUHhbOPW+QaXAjumf8YLb+ADUJ1Q98/nUqPTmczaL91yhi15sUrLIV
 aiSicdXVZN+XXUj9K1bO4SQcENWsxy1MHR/pDskYw1dj7tfGjuXcb744gGcC9evmR1doBxIfNN
 jnU=
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="110109555"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jan 2021 02:19:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 7 Jan 2021 02:19:36 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 7 Jan 2021 02:19:34 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
Date:   Thu, 7 Jan 2021 10:19:22 +0100
Message-ID: <20210107091924.1569575-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107091924.1569575-1-steen.hegelund@microchip.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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

