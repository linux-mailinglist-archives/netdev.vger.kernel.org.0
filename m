Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007B662E7CA
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241157AbiKQWJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241131AbiKQWIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:08:45 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253BD8431A
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668722898; x=1700258898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BH8sZVOc2gMgeixhBVj3ez8MSjCKaEWOqeRX5apb0Oo=;
  b=I0IA6eEAz2NtsUSpnU+dqRp/p38olXaQEKVA4lho/MNpx/Y9SDvPsSFX
   og3laU6bR2jQQJLOeZxMEf/Bh4VDVmZ0TWlX6cEr7XtBziuNxCNHOpU0o
   NoKl7fr3ZQ8TS/NAgROdRaoqpq9X6MormDnXShMx+BmJGfBV4Dak9k6gR
   Rv5jVG/VjAeCk8PfXXOHk8PX1eCxwO9Twx5IIFHe4ZnvHL2nSeR1xdaTv
   KaF6l+LxgQEcTfZd47sO5U6SHWnFtM2hza0zlmubkxJpUIoFDnjNPrIRi
   ERZYgmYdiZiXUzK63s8S1j2ajgj4QtBu2eIstbZPCneLnXfay2ntnzPcj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="313001218"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="313001218"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="672975627"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="672975627"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:08:12 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/8] devlink: remove unnecessary parameter from chunk_fill function
Date:   Thu, 17 Nov 2022 14:07:59 -0800
Message-Id: <20221117220803.2773887-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221117220803.2773887-1-jacob.e.keller@intel.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 net/core/devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index f2ee1da5283c..c28c3f2bb6e4 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6367,7 +6367,6 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 }
 
 static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
-						 struct devlink *devlink,
 						 u8 *chunk, u32 chunk_size,
 						 u64 addr)
 {
@@ -6398,7 +6397,6 @@ static int devlink_nl_cmd_region_read_chunk_fill(struct sk_buff *msg,
 #define DEVLINK_REGION_READ_CHUNK_SIZE 256
 
 static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
-						struct devlink *devlink,
 						struct devlink_snapshot *snapshot,
 						u64 start_offset,
 						u64 end_offset,
@@ -6415,9 +6413,7 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
 		u8 *data;
 
 		data = &snapshot->data[curr_offset];
-		err = devlink_nl_cmd_region_read_chunk_fill(skb, devlink,
-							    data, data_size,
-							    curr_offset);
+		err = devlink_nl_cmd_region_read_chunk_fill(skb, data, data_size, curr_offset);
 		if (err)
 			break;
 
@@ -6546,9 +6542,7 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
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

