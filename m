Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEBB636B64
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 21:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238966AbiKWUjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 15:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240327AbiKWUio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 15:38:44 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FA965B1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 12:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669235923; x=1700771923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nb0cM/+peH7L5KnX1eHNfcFcSMP2+MZPIdPdszfOwBA=;
  b=TObKxNPaxu9sn0WLszV9wbsS9cccGf6u9ZR23g4cpdFQU/CMrsIdjMdC
   nlgIveghCWTojKUznMEfi7ydb3MnI8+qdggHvxyvv3sudC7ZogRb58zWV
   nCCGXPfvStfhew24dTdHl9OH+2CxVxXqvrxZ0VuqsYBszxpUz1Svvmfpu
   KXV16g3jhi+3Xhym8Y+mKbNZNc3M0yspiN1IGYwO0v/B3Xr0FjNSpR9/T
   AI+07YmVPqpsEhOqRcY+l2vIe7WECnjT7OsjPevpoPXSkrkHNQU9mZ/JJ
   27veWJRUJUhdFCCP59aKhFhw6IP1mVlTtpWuDHzgq27f6pO78hdWrN01U
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="315307131"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="315307131"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="619756052"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="619756052"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 12:38:41 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/9] devlink: remove unnecessary parameter from chunk_fill function
Date:   Wed, 23 Nov 2022 12:38:29 -0800
Message-Id: <20221123203834.738606-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221123203834.738606-1-jacob.e.keller@intel.com>
References: <20221123203834.738606-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devlink parameter of the devlink_nl_cmd_region_read_chunk_fill
function is not used. Remove it, to simplify the function signature.

Once removed, it is also obvious that the devlink parameter is not
necessary for the devlink_nl_region_read_snapshot_fill either.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
No changes since v1.

 net/core/devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 825c52a71df1..bd7af0600405 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6431,7 +6431,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 }
 
 static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
-						 struct devlink *devlink,
 						 u8 *chunk, u32 chunk_size,
 						 u64 addr)
 {
@@ -6462,7 +6461,6 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 #define DEVLINK_REGION_READ_CHUNK_SIZE 256
 
 static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
-						struct devlink *devlink,
 						struct devlink_snapshot *snapshot,
 						u64 start_offset,
 						u64 end_offset,
@@ -6481,9 +6479,7 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 				  DEVLINK_REGION_READ_CHUNK_SIZE);
 
 		data = &snapshot->data[curr_offset];
-		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
-							    data, data_size,
-							    curr_offset);
+		err = devlink_nl_cmd_region_read_chunk_fill(skb, data, data_size, curr_offset);
 		if (err)
 			break;
 
@@ -6612,9 +6608,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto nla_put_failure;
 	}
 
-	err = devlink_nl_region_read_snapshot_fill(skb, devlink,
-						   snapshot,
-						   start_offset,
+	err = devlink_nl_region_read_snapshot_fill(skb, snapshot, start_offset,
 						   end_offset, &ret_offset);
 
 	if (err && err != -EMSGSIZE)
-- 
2.38.1.420.g319605f8f00e

