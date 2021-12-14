Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974E3474E7C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 00:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238191AbhLNXQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 18:16:28 -0500
Received: from mga18.intel.com ([134.134.136.126]:9348 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhLNXQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 18:16:26 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="225961180"
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="225961180"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:10 -0800
X-IronPort-AV: E=Sophos;i="5.88,206,1635231600"; 
   d="scan'208";a="518491441"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.180.223])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 15:16:10 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        fw@strlen.de, Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 4/4] mptcp: add missing documented NL params
Date:   Tue, 14 Dec 2021 15:16:04 -0800
Message-Id: <20211214231604.211016-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
References: <20211214231604.211016-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

'loc_id' and 'rem_id' are set in all events linked to subflows but those
were missing in the events description in the comments.

Fixes: b911c97c7dc7 ("mptcp: add netlink event support")
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/uapi/linux/mptcp.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/mptcp.h b/include/uapi/linux/mptcp.h
index c8cc46f80a16..f106a3941cdf 100644
--- a/include/uapi/linux/mptcp.h
+++ b/include/uapi/linux/mptcp.h
@@ -136,19 +136,21 @@ struct mptcp_info {
  * MPTCP_EVENT_REMOVED: token, rem_id
  * An address has been lost by the peer.
  *
- * MPTCP_EVENT_SUB_ESTABLISHED: token, family, saddr4 | saddr6,
- *                              daddr4 | daddr6, sport, dport, backup,
- *                              if_idx [, error]
+ * MPTCP_EVENT_SUB_ESTABLISHED: token, family, loc_id, rem_id,
+ *                              saddr4 | saddr6, daddr4 | daddr6, sport,
+ *                              dport, backup, if_idx [, error]
  * A new subflow has been established. 'error' should not be set.
  *
- * MPTCP_EVENT_SUB_CLOSED: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *                         sport, dport, backup, if_idx [, error]
+ * MPTCP_EVENT_SUB_CLOSED: token, family, loc_id, rem_id, saddr4 | saddr6,
+ *                         daddr4 | daddr6, sport, dport, backup, if_idx
+ *                         [, error]
  * A subflow has been closed. An error (copy of sk_err) could be set if an
  * error has been detected for this subflow.
  *
- * MPTCP_EVENT_SUB_PRIORITY: token, family, saddr4 | saddr6, daddr4 | daddr6,
- *                           sport, dport, backup, if_idx [, error]
- *       The priority of a subflow has changed. 'error' should not be set.
+ * MPTCP_EVENT_SUB_PRIORITY: token, family, loc_id, rem_id, saddr4 | saddr6,
+ *                           daddr4 | daddr6, sport, dport, backup, if_idx
+ *                           [, error]
+ * The priority of a subflow has changed. 'error' should not be set.
  */
 enum mptcp_event_type {
 	MPTCP_EVENT_UNSPEC = 0,
-- 
2.34.1

