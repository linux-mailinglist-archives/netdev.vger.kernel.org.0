Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2CE65CE23
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 09:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbjADIRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 03:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbjADIRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 03:17:08 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BF719297
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 00:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672820227; x=1704356227;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YIIE7e4F2SBYSsFGvifc4Pe2sBpUJMMsXNbeMjZx/j0=;
  b=JkNNR9q+iRyZ2i0th8r0hCLD2gKO8DikE95oLzaBLD1k8kZ8Di0AAuVY
   0WMYg7/QmalDeAlXpFby6WsLvfMtKmHOz7N1vZGgh9H4Ox0Nz0jhUJNBz
   P8KZortGntq/nq1ztdgD5OwzVmcqGVLeaaAGYhAce9GGPyPoHnCFX1SqE
   jLxgGdQAzkeaT/V8GX1adqJJa0gG7pMe7pohayE4SRRFOXyioiCwcbXLs
   MMieNhQqg+Y/BbI6Hc+Z+uUdSA7K7jt7NfdEg9+q40q74xevm2TOhJ0Bm
   R6eubICn1apTGGQy3vU06jSjj9PHaX0CwVdwGAOb4dTqKX29A64UcFN7w
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="301561359"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="301561359"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 00:17:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="632726099"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="632726099"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 04 Jan 2023 00:16:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id BA0E9F4; Wed,  4 Jan 2023 10:17:31 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] net: thunderbolt: Move into own directory
Date:   Wed,  4 Jan 2023 10:17:29 +0200
Message-Id: <20230104081731.45928-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
References: <20230104081731.45928-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We will be adding tracepoints to the driver so instead of littering the
main network driver directory, move the driver into its own directory.
While there, rename the module to thunderbolt_net (with underscore) to
match with the thunderbolt_dma_test convention.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 MAINTAINERS                                       |  2 +-
 drivers/net/Kconfig                               | 13 +------------
 drivers/net/Makefile                              |  4 +---
 drivers/net/thunderbolt/Kconfig                   | 12 ++++++++++++
 drivers/net/thunderbolt/Makefile                  |  3 +++
 drivers/net/{thunderbolt.c => thunderbolt/main.c} |  0
 6 files changed, 18 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/thunderbolt/Kconfig
 create mode 100644 drivers/net/thunderbolt/Makefile
 rename drivers/net/{thunderbolt.c => thunderbolt/main.c} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index f61eb221415b..d3a02bbf32fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20767,7 +20767,7 @@ M:	Mika Westerberg <mika.westerberg@linux.intel.com>
 M:	Yehezkel Bernat <YehezkelShB@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	drivers/net/thunderbolt.c
+F:	drivers/net/thunderbolt/
 
 THUNDERX GPIO DRIVER
 M:	Robert Richter <rric@kernel.org>
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e63b8c43f3e..950a09f021dd 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -583,18 +583,7 @@ config FUJITSU_ES
 	  This driver provides support for Extended Socket network device
 	  on Extended Partitioning of FUJITSU PRIMEQUEST 2000 E2 series.
 
-config USB4_NET
-	tristate "Networking over USB4 and Thunderbolt cables"
-	depends on USB4 && INET
-	help
-	  Select this if you want to create network between two computers
-	  over a USB4 and Thunderbolt cables. The driver supports Apple
-	  ThunderboltIP protocol and allows communication with any host
-	  supporting the same protocol including Windows and macOS.
-
-	  To compile this driver a module, choose M here. The module will be
-	  called thunderbolt-net.
-
+source "drivers/net/thunderbolt/Kconfig"
 source "drivers/net/hyperv/Kconfig"
 
 config NETDEVSIM
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 6ce076462dbf..e26f98f897c5 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -84,8 +84,6 @@ obj-$(CONFIG_HYPERV_NET) += hyperv/
 obj-$(CONFIG_NTB_NETDEV) += ntb_netdev.o
 
 obj-$(CONFIG_FUJITSU_ES) += fjes/
-
-thunderbolt-net-y += thunderbolt.o
-obj-$(CONFIG_USB4_NET) += thunderbolt-net.o
+obj-$(CONFIG_USB4_NET) += thunderbolt/
 obj-$(CONFIG_NETDEVSIM) += netdevsim/
 obj-$(CONFIG_NET_FAILOVER) += net_failover.o
diff --git a/drivers/net/thunderbolt/Kconfig b/drivers/net/thunderbolt/Kconfig
new file mode 100644
index 000000000000..e127848c8cbd
--- /dev/null
+++ b/drivers/net/thunderbolt/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config USB4_NET
+	tristate "Networking over USB4 and Thunderbolt cables"
+	depends on USB4 && INET
+	help
+	  Select this if you want to create network between two computers
+	  over a USB4 and Thunderbolt cables. The driver supports Apple
+	  ThunderboltIP protocol and allows communication with any host
+	  supporting the same protocol including Windows and macOS.
+
+	  To compile this driver a module, choose M here. The module will be
+	  called thunderbolt_net.
diff --git a/drivers/net/thunderbolt/Makefile b/drivers/net/thunderbolt/Makefile
new file mode 100644
index 000000000000..dd644c8775d9
--- /dev/null
+++ b/drivers/net/thunderbolt/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_USB4_NET) := thunderbolt_net.o
+thunderbolt_net-objs := main.o
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt/main.c
similarity index 100%
rename from drivers/net/thunderbolt.c
rename to drivers/net/thunderbolt/main.c
-- 
2.35.1

