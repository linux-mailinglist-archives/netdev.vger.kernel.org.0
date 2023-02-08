Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65AB68EFC4
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 14:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjBHNbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 08:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBHNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 08:31:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1F142DF9;
        Wed,  8 Feb 2023 05:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675863083; x=1707399083;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iRdp3KV5xmAJg0zcHWue1GbSneGTwjsPjdu/wNNtJlw=;
  b=QD16U+qI0sKd0YjgmPneiUn62GNFOBjJet5IgQndHdonwt4oWCla4NUL
   /oI9XeEF+UrXToeC/6kqg6+rG7lms/wB07bA5gQ307i5wFFVLrfG+bDYw
   keiXTBHgxZQyhttGYFlDxM0qSmtmYEqTB4dqk5x6rfzt7H9GZp5uagVSE
   t9tW05PfvpNTeeJSk29LBl+jiaODikCZ3gf0juMNmuXz73gi3uyfIZSrx
   P7pSahC4oTdNrIAAwyjdVHt7v9VsKcIMr2Gpew0BxVIo+WbeVDlbbNNk5
   oq5J/mWmFVISOzJHaitvzuMzOMFWV8rTrz25DQJrcrUlP+1cWtN88il3z
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="357188514"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="357188514"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 05:31:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="669197631"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="669197631"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 08 Feb 2023 05:31:20 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id ADDFF1F8; Wed,  8 Feb 2023 15:31:58 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        tipc-discussion@lists.sourceforge.net
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v3 1/3] string_helpers: Move string_is_valid() to the header
Date:   Wed,  8 Feb 2023 15:31:51 +0200
Message-Id: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
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

While at it, rename to string_is_terminated() to be
precise about its semantics.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v3: renamed to string_is_terminated (Jakub)
v2: added tag and updated subject (Simon)
 include/linux/string_helpers.h |  5 +++++
 net/tipc/netlink_compat.c      | 16 ++++++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
index 8530c7328269..fae6beaaa217 100644
--- a/include/linux/string_helpers.h
+++ b/include/linux/string_helpers.h
@@ -11,6 +11,11 @@ struct device;
 struct file;
 struct task_struct;
 
+static inline bool string_is_terminated(const char *s, int len)
+{
+	return memchr(s, '\0', len) ? true : false;
+}
+
 /* Descriptions of the types of units to
  * print in */
 enum string_size_units {
diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index dfea27a906f2..9b47c8409231 100644
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
@@ -445,7 +441,7 @@ static int tipc_nl_compat_bearer_enable(struct tipc_nl_compat_cmd_doit *cmd,
 		return -EINVAL;
 
 	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
-	if (!string_is_valid(b->name, len))
+	if (!string_is_terminated(b->name, len))
 		return -EINVAL;
 
 	if (nla_put_string(skb, TIPC_NLA_BEARER_NAME, b->name))
@@ -486,7 +482,7 @@ static int tipc_nl_compat_bearer_disable(struct tipc_nl_compat_cmd_doit *cmd,
 		return -EINVAL;
 
 	len = min_t(int, len, TIPC_MAX_BEARER_NAME);
-	if (!string_is_valid(name, len))
+	if (!string_is_terminated(name, len))
 		return -EINVAL;
 
 	if (nla_put_string(skb, TIPC_NLA_BEARER_NAME, name))
@@ -584,7 +580,7 @@ static int tipc_nl_compat_link_stat_dump(struct tipc_nl_compat_msg *msg,
 		return -EINVAL;
 
 	len = min_t(int, len, TIPC_MAX_LINK_NAME);
-	if (!string_is_valid(name, len))
+	if (!string_is_terminated(name, len))
 		return -EINVAL;
 
 	if (strcmp(name, nla_data(link[TIPC_NLA_LINK_NAME])) != 0)
@@ -819,7 +815,7 @@ static int tipc_nl_compat_link_set(struct tipc_nl_compat_cmd_doit *cmd,
 		return -EINVAL;
 
 	len = min_t(int, len, TIPC_MAX_LINK_NAME);
-	if (!string_is_valid(lc->name, len))
+	if (!string_is_terminated(lc->name, len))
 		return -EINVAL;
 
 	media = tipc_media_find(lc->name);
@@ -856,7 +852,7 @@ static int tipc_nl_compat_link_reset_stats(struct tipc_nl_compat_cmd_doit *cmd,
 		return -EINVAL;
 
 	len = min_t(int, len, TIPC_MAX_LINK_NAME);
-	if (!string_is_valid(name, len))
+	if (!string_is_terminated(name, len))
 		return -EINVAL;
 
 	if (nla_put_string(skb, TIPC_NLA_LINK_NAME, name))
-- 
2.39.1

