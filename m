Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27530234EE5
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgHAAWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:22:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:49844 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726215AbgHAAWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 20:22:16 -0400
IronPort-SDR: pnLa7z8FDHH7/5CaQi1HiWVakbsvpA7IvmVOOgYvYZ2nKJhFDNEZVV+l/oDUzuHYnpKnb6/FoZ
 GivubL8dbcbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="153106658"
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="153106658"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 17:22:14 -0700
IronPort-SDR: lqQdfzl9OQk0DoizqSHK2Gn0kIbC/LDWQowASTIdENgzFI0/HYz20TE/qT3N8hlHj/rmXIcbDI
 mMZfP8mLuFsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="435594773"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2020 17:22:14 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v2 4/5] Update devlink header for overwrite mask attribute
Date:   Fri, 31 Jul 2020 17:21:58 -0700
Message-Id: <20200801002159.3300425-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b60
In-Reply-To: <20200801002159.3300425-1-jacob.e.keller@intel.com>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/uapi/linux/devlink.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b7f23faae901..3d006ad2fdaf 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -228,6 +228,28 @@ enum {
 	DEVLINK_ATTR_STATS_MAX = __DEVLINK_ATTR_STATS_MAX - 1
 };
 
+/* Specify what sections of a flash component can be overwritten when
+ * performing an update. Overwriting of firmware binary sections is always
+ * implicitly assumed to be allowed.
+ *
+ * Each section must be documented in
+ * Documentation/networking/devlink/devlink-flash.rst
+ *
+ */
+enum {
+	DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT,
+	DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT,
+
+	__DEVLINK_FLASH_OVERWRITE_MAX_BIT,
+	DEVLINK_FLASH_OVERWRITE_MAX_BIT = __DEVLINK_FLASH_OVERWRITE_MAX_BIT - 1
+};
+
+#define DEVLINK_FLASH_OVERWRITE_SETTINGS BIT(DEVLINK_FLASH_OVERWRITE_SETTINGS_BIT)
+#define DEVLINK_FLASH_OVERWRITE_IDENTIFIERS BIT(DEVLINK_FLASH_OVERWRITE_IDENTIFIERS_BIT)
+
+#define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
+	GENMASK(DEVLINK_FLASH_OVERWRITE_MAX_BIT, 0)
+
 /**
  * enum devlink_trap_action - Packet trap action.
  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
@@ -458,6 +480,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_LANES,			/* u32 */
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
+	DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MASK,	/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.28.0.163.g6104cc2f0b60

