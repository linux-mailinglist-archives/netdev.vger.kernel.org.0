Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99439546B71
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350103AbiFJRER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350064AbiFJREL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:04:11 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D02736E22;
        Fri, 10 Jun 2022 10:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654880645; x=1686416645;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LGdrMf8Poia0UQQrb9LNvTq7/+7aAi6BFbIXFQllOa0=;
  b=VgwT5yQ7jkmRR05lgftyLqM5CNXauC6/s1x3BxrvTEZJzBOrnSsthw78
   m9lxLcA+0gsqtLCK2aQctvB8cU4JvfX2ejAI+ws+qL2jYbG5bmNgdEm8T
   YJp45cDdba3g+UzlnXd/f+ckWifRshZfPXo3H5UhKPTRIwxQqJjRL9FvO
   L1YC/KVdniBucDPfEfToEW7PepqwlGlctRCg8Fqz49F5moOhBU2aMufEN
   Jw4KeFtJ/T/YGeZgR7tuYB5QVkrBqsWWecsJZkhLJAA1IxQs1sXIVDVXB
   L2ssX6IS0qBHNrlKXKtn4Apjmo4CCted/xMh9WK5uPmwwLx4wDsjTjc2h
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="266452808"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="266452808"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:04:05 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638218803"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 10:04:03 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH v2 5/6] dt-bindings: net: Add NCSI bindings
Date:   Sat, 11 Jun 2022 00:59:39 +0800
Message-Id: <20220610165940.2326777-6-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
References: <20220610165940.2326777-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree bindings for NCSI VLAN modes. This allows VLAN mode to
be configured in devicetree.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 .../devicetree/bindings/net/ncsi.yaml         | 34 +++++++++++++++++++
 MAINTAINERS                                   |  2 ++
 include/dt-bindings/net/ncsi.h                | 15 ++++++++
 3 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ncsi.yaml
 create mode 100644 include/dt-bindings/net/ncsi.h

diff --git a/Documentation/devicetree/bindings/net/ncsi.yaml b/Documentation/devicetree/bindings/net/ncsi.yaml
new file mode 100644
index 000000000000..ec76ae9a77a9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ncsi.yaml
@@ -0,0 +1,34 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ncsi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Network Controller Sideband Interface (NCSI)
+
+maintainers:
+  - Samuel Mendoza-Jonas <sam@mendozajonas.com>
+
+description: |
+  Bindings for the Network Controller Sideband Interface (NCSI) driver
+
+properties:
+  ncsi,vlan-mode:
+    description: VLAN mode used on the NCSI device.
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [0, 1, 2, 3]
+
+examples:
+  - |
+    #include <dt-bindings/net/ncsi.h>
+
+    mac0: ethernet@1e660000 {
+      compatible = "aspeed,ast2600-mac", "faraday,ftgmac100";
+      reg = <0x1e660000 0x180>;
+      status = "okay";
+
+      use-ncsi;
+      ncsi,vlan-mode = <NCSI_VLAN_MODE_ANY>;
+    };
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index f468864fd268..199e4b5bceab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13534,6 +13534,8 @@ F:	drivers/scsi/sun3_scsi_vme.c
 NCSI LIBRARY
 M:	Samuel Mendoza-Jonas <sam@mendozajonas.com>
 S:	Maintained
+F:	Documentation/devicetree/bindings/net/ncsi.yaml
+F:	include/dt-bindings/net/ncsi.h
 F:	net/ncsi/
 
 NCT6775 HARDWARE MONITOR DRIVER
diff --git a/include/dt-bindings/net/ncsi.h b/include/dt-bindings/net/ncsi.h
new file mode 100644
index 000000000000..d45790d97a21
--- /dev/null
+++ b/include/dt-bindings/net/ncsi.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Device Tree constants for NCSI
+ */
+
+#ifndef _DT_BINDINGS_NCSI_H
+#define _DT_BINDINGS_NCSI_H
+
+/* VLAN Modes */
+#define NCSI_VLAN_MODE_DISABLED		0
+#define NCSI_VLAN_MODE_ONLY		1
+#define NCSI_VLAN_MODE_FILTERED		2
+#define NCSI_VLAN_MODE_ANY		3
+
+#endif
-- 
2.34.1

