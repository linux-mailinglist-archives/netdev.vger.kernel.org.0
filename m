Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 151551A798D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439241AbgDNLbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:31:46 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:34443 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439050AbgDNL1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:27:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586863640; x=1618399640;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=1BR/cROdhCyfHaruTl2nwBlZr33q3GBAyi/Fdo/0EBs=;
  b=Sxx+bmhFrFiDOtNx8DIOtFmKLaLWd6R9EjSkGqVmz3rcvMisbW7Pe60b
   +SnL379uC/1DUOwe2ZhT2iHuHDnkaDgbUMPdY4T9kVSh0DjjVPy29zU29
   s16sARZe9Hlxxr6PIvpPcNLw2yKcUTiSyZIPmVMedDbDT/znyvxDc/UQ9
   A5A9ljRWgy1PZ5eMLYfxfE4SdZMf7UrZdt6nys5QFgaSp4k7btALIQrXm
   pvEmLftyUQAFKJqfx28QWmsZPLeBGCwPvj8S7pNRuAptF2iiGXZUTIQnK
   W1ndYMTdhzjiRpc45mIHHdYACqFimKQj7q0/X5tyK7s3i3BtWzMTNP3+m
   Q==;
IronPort-SDR: zf/hQoiWm3Y4RBNwpq0ONwJR+PnwvCap7KnI5S0xk8gopFMrODfRESHZLocIn7gSMns8dFDAob
 e1FK6TFYF6yL6IogcF6HpR87WSe9sOf+fTjOLmnW9VUNRH7Q8I66JVQu4p1xRFFCKjLOd7UC+t
 ytrqHlWgdkMZDKZkrv2n12HrCP1ygh3pJJs9hcRPr206putOzuhS2nYfM7w+ycXw8jn1fLu8Tr
 SzX3u8SWZvk/q117BLWKro0KrxocCbYwsZEBO6+k97dBDpDgGlE/G3I1e17J3WGqvBRUMuoq0d
 oPo=
X-IronPort-AV: E=Sophos;i="5.72,382,1580799600"; 
   d="scan'208";a="9066823"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Apr 2020 04:27:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Apr 2020 04:27:19 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Tue, 14 Apr 2020 04:27:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [RFC net-next v5 3/9] bridge: mrp: Expose function br_mrp_port_open
Date:   Tue, 14 Apr 2020 13:26:12 +0200
Message-ID: <20200414112618.3644-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414112618.3644-1-horatiu.vultur@microchip.com>
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case the HW is capable to detect when the MRP ring is open or closed. It is
expected that the network driver will notify the SW that the ring is open or
closed.

The function br_mrp_port_open is used to notify the kernel that one of the ports
stopped receiving MRP_Test frames. The argument 'loc' has a value of '1' when
the port stopped receiving MRP_Test and '0' when it started to receive MRP_Test.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/linux/mrp_bridge.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 include/linux/mrp_bridge.h

diff --git a/include/linux/mrp_bridge.h b/include/linux/mrp_bridge.h
new file mode 100644
index 000000000000..23d46b356263
--- /dev/null
+++ b/include/linux/mrp_bridge.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _LINUX_MRP_BRIDGE_H
+#define _LINUX_MRO_BRIDGE_H
+
+#include <linux/netdevice.h>
+
+/* The drivers are responsible to call this function when it detects that the
+ * MRP port stopped receiving MRP_Test frames or it started to receive MRP_Test.
+ * The argument dev represents the port and loc(Lost of Continuity) has a value
+ * of 1 when it stopped receiving MRP_Test frames and a value of 0 when it
+ * started to receive frames.
+ *
+ * This eventually notify the userspace which is required to react on these
+ * changes.
+ */
+
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+int br_mrp_port_open(struct net_device *dev, u8 loc);
+#else
+inline int br_mrp_port_open(struct net_device *dev, u8 loc)  {}
+#endif
+
+#endif
-- 
2.17.1

