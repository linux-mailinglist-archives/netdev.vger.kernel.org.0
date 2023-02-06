Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E77C68C2B9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjBFQNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjBFQNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:13:30 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD32196E;
        Mon,  6 Feb 2023 08:13:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675699994; x=1707235994;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nqrQtqd1T9xl/j9igH6LicfTqt28OCju6w046xOfGT8=;
  b=R9Ki1kspX3VfeFMu/fKN1mHTYox6ZinvaNu+9w6n0WuRTSB4Qb50aAa2
   JLDKEd1wLl5l+KqX0QkTTXaLaCn/AVWHE3ccoGU/NwPPl0iXMjmmFDvjS
   AgWdoXVaCNG/UI9c520NT3489C93fzh3V9KU5O4XpzqyG/SuyY5ku9vG6
   EH2n4+e5+ab4gdE7JQvi/K0zy2c5GMgHjYFVDvOwAB66wxcPhm8Z1CSwk
   EoTp6r+wp2lehBOfOwfcQC3jT8sYgngf9x/5ZXKzJZjKbutePE0LIN20z
   5WsqKa0lZ6AQd8zzMFlPo6C33dMkX9LNmu1Ie1IrYvQHhicA33lNrVBLA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="308888751"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="308888751"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 08:12:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="698884370"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="698884370"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 06 Feb 2023 08:12:37 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D6DDB1EA; Mon,  6 Feb 2023 18:13:15 +0200 (EET)
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
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 1/3] string_helpers: Move string_is_valid() to the header
Date:   Mon,  6 Feb 2023 18:13:12 +0200
Message-Id: <20230206161314.15667-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.39.1
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

Move string_is_valid() to the header for wider use.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v2: added tag and updated subject (Simon)
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

