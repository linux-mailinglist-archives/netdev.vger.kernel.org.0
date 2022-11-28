Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3A463B360
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 21:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbiK1UhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 15:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbiK1UhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 15:37:03 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5882E9C1
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 12:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669667822; x=1701203822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MaOfUAU7GK69HFmAymA4Vsi4BOf85Hw/KEtwEJ9hdR8=;
  b=jxkv2WY4r1o+wbpYRslDffESzWkFdHY2xfBhisA273C6stt8r2ancguG
   GDSWMgo04gtlAarvtNlHUnrgKV13poV2tNEx7dIAlrIxX7sSMGW1M30//
   eN1lowRKR2K8oXDLQYkRWt8Xg1PAOY00Zyb5zCfaPfhfVgrDsotDnD7v/
   Ynndu8L2KwnHyFJGfk+L8FnIQqgzhXB737ljb51bJ4c3ILA4sf0LvbbSk
   OlBqmebkR61kYZmEoaIhuVry5M4ZYDgR90FkR0+7nKIzS5B6/yMxoRGyP
   ua2YkAcCwixstTqpxpbg7mSb8IxC66LdDqa7f1P1qG8OGmKjD+TLR9niO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379205393"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="379205393"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732286351"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="732286351"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 12:36:58 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 4/9] devlink: remove unnecessary parameter from chunk_fill function
Date:   Mon, 28 Nov 2022 12:36:42 -0800
Message-Id: <20221128203647.1198669-5-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.38.1.420.g319605f8f00e
In-Reply-To: <20221128203647.1198669-1-jacob.e.keller@intel.com>
References: <20221128203647.1198669-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
No changes since v2.

 net/core/devlink.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index b89649919bba..dc70c870cd00 100644
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

