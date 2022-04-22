Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFCB50C3F1
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiDVWaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbiDVWaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:30:16 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B673362E0
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 14:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650664563; x=1682200563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IvAlB4kUGkNkLRy+VtIdYp9rNluXsVFF0Id0C7yAEHk=;
  b=QG97WTjTjlliIluc4AU/ubVoNkbCLGZzIQZsrjlPn+zu+jKqDxAXyke7
   WmezPq8xRATdMw4AbLznAsoY6Dl49dPKDsximyLV1VJ1ci0fxCbW8FlPQ
   IoEHpIr9NkxhceqQi06RAALgFwf7kTWSkuBzGFIn8DSgddNc7VhTm/2nG
   pnPk7cIwtKNX6RTHl7gLQEm7nhiykVycl5MweRkaJ4a+p+fJlVES46K65
   Yd/D6OIOSGgT0u134KG4ikFl0Qa7liW4K+pvDkSxw5K4IIvmcAwdrGg+n
   aABY4f6wtrDi4tbjrp2JvT1BU0bH8vrwMdp61uFQbZGBGBC5YEAnmQhtN
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264285984"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="264285984"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="578119266"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.99.29])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 14:55:49 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 7/8] mptcp: dump infinite_map field in mptcp_dump_mpext
Date:   Fri, 22 Apr 2022 14:55:42 -0700
Message-Id: <20220422215543.545732-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
References: <20220422215543.545732-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

In trace event class mptcp_dump_mpext, dump the newly added infinite_map
field of struct mptcp_dump_mpext too.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/trace/events/mptcp.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/mptcp.h b/include/trace/events/mptcp.h
index f8e28e686c65..563e48617374 100644
--- a/include/trace/events/mptcp.h
+++ b/include/trace/events/mptcp.h
@@ -84,6 +84,7 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		__field(u8, reset_transient)
 		__field(u8, reset_reason)
 		__field(u8, csum_reqd)
+		__field(u8, infinite_map)
 	),
 
 	TP_fast_assign(
@@ -102,9 +103,10 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		__entry->reset_transient = mpext->reset_transient;
 		__entry->reset_reason = mpext->reset_reason;
 		__entry->csum_reqd = mpext->csum_reqd;
+		__entry->infinite_map = mpext->infinite_map;
 	),
 
-	TP_printk("data_ack=%llu data_seq=%llu subflow_seq=%u data_len=%u csum=%x use_map=%u dsn64=%u data_fin=%u use_ack=%u ack64=%u mpc_map=%u frozen=%u reset_transient=%u reset_reason=%u csum_reqd=%u",
+	TP_printk("data_ack=%llu data_seq=%llu subflow_seq=%u data_len=%u csum=%x use_map=%u dsn64=%u data_fin=%u use_ack=%u ack64=%u mpc_map=%u frozen=%u reset_transient=%u reset_reason=%u csum_reqd=%u infinite_map=%u",
 		  __entry->data_ack, __entry->data_seq,
 		  __entry->subflow_seq, __entry->data_len,
 		  __entry->csum, __entry->use_map,
@@ -112,7 +114,7 @@ DECLARE_EVENT_CLASS(mptcp_dump_mpext,
 		  __entry->use_ack, __entry->ack64,
 		  __entry->mpc_map, __entry->frozen,
 		  __entry->reset_transient, __entry->reset_reason,
-		  __entry->csum_reqd)
+		  __entry->csum_reqd, __entry->infinite_map)
 );
 
 DEFINE_EVENT(mptcp_dump_mpext, mptcp_sendmsg_frag,
-- 
2.36.0

