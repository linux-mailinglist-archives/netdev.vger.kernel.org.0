Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E896410CA9
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 19:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhISRa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 13:30:27 -0400
Received: from mga06.intel.com ([134.134.136.31]:58775 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230156AbhISRaZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 13:30:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10112"; a="284044618"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="284044618"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2021 10:29:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="612241093"
Received: from ccgwwan-adlp2.iind.intel.com ([10.224.174.127])
  by fmsmga001.fm.intel.com with ESMTP; 19 Sep 2021 10:28:57 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        linuxwwan@intel.com
Subject: [PATCH V2 net-next 6/6] net: wwan: iosm: fw flashing & cd collection infrastructure changes
Date:   Sun, 19 Sep 2021 22:58:35 +0530
Message-Id: <20210919172835.26377-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IOSM Makefile & WWAN Kconfig changes to support fw flashing & cd
collection module compliation.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
v2: no change.
---
 drivers/net/wwan/Kconfig       | 1 +
 drivers/net/wwan/iosm/Makefile | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index 77dbfc418bce..17543be14665 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -71,6 +71,7 @@ config RPMSG_WWAN_CTRL
 config IOSM
 	tristate "IOSM Driver for Intel M.2 WWAN Device"
 	depends on INTEL_IOMMU
+	select NET_DEVLINK
 	help
 	  This driver enables Intel M.2 WWAN Device communication.
 
diff --git a/drivers/net/wwan/iosm/Makefile b/drivers/net/wwan/iosm/Makefile
index 4f9f0ae398e1..b838034bb120 100644
--- a/drivers/net/wwan/iosm/Makefile
+++ b/drivers/net/wwan/iosm/Makefile
@@ -18,6 +18,9 @@ iosm-y = \
 	iosm_ipc_protocol.o		\
 	iosm_ipc_protocol_ops.o	\
 	iosm_ipc_mux.o			\
-	iosm_ipc_mux_codec.o
+	iosm_ipc_mux_codec.o		\
+	iosm_ipc_devlink.o		\
+	iosm_ipc_flash.o		\
+	iosm_ipc_coredump.o
 
 obj-$(CONFIG_IOSM) := iosm.o
-- 
2.25.1

