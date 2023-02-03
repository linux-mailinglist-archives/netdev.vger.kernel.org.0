Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC0C689AFD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjBCOHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjBCOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:07:03 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AECA56D3;
        Fri,  3 Feb 2023 06:04:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675433087; x=1706969087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WaRnlHu7jSxKhE/JvaLSEplkobKDBaDVdAs1fxRPxZg=;
  b=BDxU84EdEZZm+xd0vZwszszOluxt+9wSkos6pP4rAh4/OWiQnX0QD665
   /b2UmzreG/GJZhsxNV6oV7QZJBCyM7rUbfDeR0iqyFzK+ocFlukUJs3y/
   +Yrfoae9H+8LNjXseIFxqiuQzEuB1G/cVfzUHj/vHLtaGsKCt+hXR3Ywc
   SHCNqshat5wXAdvTHKbZAdPAg3Q0gpIzopV7W0LCBhcS5HXQRRI5ccrOz
   ygOLLEo5yZx6YJ0YYRqfCjZuedwAR2HQX1o7FtBSeHqqyO1fqbL4huuFp
   UlLSkuzpJZp6p1iBxj+olt1KwRd1D2PiS5MiWWWuOq/2PBpEJiFHJLO5K
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="356094850"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="356094850"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 06:04:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="729273241"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="729273241"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2023 06:04:43 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id B2D0C358; Fri,  3 Feb 2023 16:05:20 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net
Cc:     Andy Shevchenko <andy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH v1 1/3] string_helpers: Move string_is_valid() to the header
Date:   Fri,  3 Feb 2023 16:04:59 +0200
Message-Id: <20230203140501.67659-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move string_is_valid() to the header for wider use.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/string_helpers.h | 5 +++++
 net/tipc/netlink_compat.c      | 6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 88fb8e1d0421..01c9a432865a 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -12,6 +12,11 @@ struct device;
 struct file;
 struct task_struct;
 
+static inline bool string_is_valid(const char *s, int len)
+{
+	return memchr(s, '\0', len) ? true : false;
+}
+
 /* Descriptions of the types of units to
  * print in */
 enum string_size_units {
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index dfea27a906f2..75186cd551a0 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -39,6 +39,7 @@
 #include "node.h"
 #include "net.h"
 #include <net/genetlink.h>
+#include <linux/string_helpers.h>
 #include <linux/tipc_config.h>
 
 /* The legacy API had an artificial message length limit called
@@ -173,11 +174,6 @@ static struct sk_buff *tipc_get_err_tlv(char *str)
 	return buf;
 }
 
-static inline bool string_is_valid(char *s, int len)
-{
-	return memchr(s, '\0', len) ? true : false;
-}
-
 static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
 				   struct tipc_nl_compat_msg *msg,
 				   struct sk_buff *arg)
-- 
2.39.1

