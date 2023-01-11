Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428B3665487
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 07:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjAKG0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 01:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjAKG0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 01:26:05 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14262B4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 22:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673418362; x=1704954362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LCMBYOQEImmQnlYG+sEPbPrGF7SeTCEvCUuI80iJCqA=;
  b=CwzZBuIma4QQspkYc4dFL2ux7Pz/sXlAz55JBi6R8qtrt9hJalOWs8wt
   7mnkziphhX8Hn9Jl4BKQP/bdkFJ8byyvqZumGL0AP5/iPU8ha4lml7vod
   MPVRshlRILeQIDK7Gu+W5i5KgJvXoXQvAfs8IGpG7xFZHAbtXHYHBnPVW
   jHJq7MzMqugddGPW5eUCnZCkEXtmc87u8XJ3ebUmSMxCU3Pb0q6/T5AU6
   82rGYDCO1ifnUOWI6eNg8flZcjU8oGdrPTFbfGTRI8GwmFBduC6VVbu0P
   HbqAAfwqcQYay+z7yNSk8m0dtClbAkQA8fEn9Mu9gv2niLYuQOmC0fKhW
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="306856843"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="306856843"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 22:26:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="607256939"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="607256939"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 10 Jan 2023 22:25:59 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 7439784; Wed, 11 Jan 2023 08:26:33 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/3] net: thunderbolt: Move into own directory
Date:   Wed, 11 Jan 2023 08:26:31 +0200
Message-Id: <20230111062633.1385-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111062633.1385-1-mika.westerberg@linux.intel.com>
References: <20230111062633.1385-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
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
2.39.0

