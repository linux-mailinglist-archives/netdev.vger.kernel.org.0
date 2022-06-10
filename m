Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FDE546B0D
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346406AbiFJQuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349892AbiFJQuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:50:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09CA28E05;
        Fri, 10 Jun 2022 09:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879801; x=1686415801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xfml1NwpVsO1qKFhuV1kEyknIGEvUDk3GH8dIhLg1z4=;
  b=ebTjv6QhtybLGIqF50Nc2WVyiCoz0OkDhSnaHJ0E1KtsBxfV0s7lEGnC
   CxGHvz7Ok2sGHgDtHQ4ckbPCsKlz3j7MxZi1aGT2UB2cADj00d7phngTV
   TmpFy0jlXzEwBJJyiWVLGordfPTI30XUiHcNI3ndA0aRN8MIf3pP5zvSp
   IIfCGdkJM88ZXszsLRGZ182cwzI2S0p0ZoxfhCVCiDIZQxTzjsO/Y/kn6
   Ha2cQtEv57YUUjB7ECF3ulyElLH2sg2bcZrT1req+8wsYW+V44bWFYC5b
   LnyQyashoyvbPGbS4wXgd50L/HvZtn0vVkWAoZd9ZolGz+HqmbMs4bWEw
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="339432571"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="339432571"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:50:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="760587734"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:49:59 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 5/6] dt-bindings: net: Add NCSI bindings
Date:   Sat, 11 Jun 2022 00:48:07 +0800
Message-Id: <20220610164808.2323340-6-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
References: <20220610164808.2323340-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
index 000000000000..19eb9a5db08b
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
+#define NCSI_VLAN_MODE_DISABLED	0
+#define NCSI_VLAN_MODE_ONLY	1
+#define NCSI_VLAN_MODE_FILTERED	2
+#define NCSI_VLAN_MODE_ANY	3
+
+#endif
-- 
2.34.1

