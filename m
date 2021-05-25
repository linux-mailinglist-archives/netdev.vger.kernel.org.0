Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477D1390B44
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhEYVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:24:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:35469 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhEYVYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 17:24:52 -0400
IronPort-SDR: 99VdJmjE98X2vOb0qwYchhmQhAQbWGnebdQ9wjpOJ/gJNqjJ8fSwoIsrzBwVsQMggED/jS471q
 DgYEtweJbErw==
X-IronPort-AV: E=McAfee;i="6200,9189,9995"; a="202062423"
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="202062423"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
IronPort-SDR: 1e5wjkfroolSYGyvErsfeKwewuDxNIQdFsZGAd3TFjN7hCzD2MwGmHiQTBVzlpk/rCkKdF31YL
 /IFit2dqaGwQ==
X-IronPort-AV: E=Sophos;i="5.82,329,1613462400"; 
   d="scan'208";a="546924973"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.216.142])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2021 14:23:19 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/4] mptcp: drop unconditional pr_warn on bad opt
Date:   Tue, 25 May 2021 14:23:11 -0700
Message-Id: <20210525212313.148142-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
References: <20210525212313.148142-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

This is a left-over of early day. A malicious peer can flood
the kernel logs with useless messages, just drop it.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 99fc21406168..71c535f4e1ef 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -130,7 +130,6 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			memcpy(mp_opt->hmac, ptr, MPTCPOPT_HMAC_LEN);
 			pr_debug("MP_JOIN hmac");
 		} else {
-			pr_warn("MP_JOIN bad option size");
 			mp_opt->mp_join = 0;
 		}
 		break;
-- 
2.31.1

