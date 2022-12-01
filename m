Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7C63EDB8
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiLAK2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbiLAK2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:28:09 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16E32CCB3
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890479; x=1701426479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eXn6Yvb5MA1RZy55IvPtGrVfS3vqrD8npS+FVGk1oK0=;
  b=Ak1KXtVy6HOZF/I8DbViZHGFLOUVLHnPtl6EPaRU7elRMGnY47qEla7V
   pppjxcC/anTv1eOGWc1utRer7OMNK5s31O01889uOxXfipOSLfgDOxX0n
   6MBj2uqNhf63nDpC/G8GXRhKoxVFo5owChjWyxYzK7zp8tskBFzsgEEb9
   IkGzbbIES2JyqbHa2PeNYTa5Yw1ALdBPV/VV1/gD/1vG7BX9m3a0jeW3l
   B5BAiuq90QdIr9f3BXpN8iXUSPtGCx4VLJJ8O+rf7+y66m0la/yCao7qm
   VOCINZHOJUD5eUzBBx7AmW7+pgff7/tDsHwqsV7McewqCejGmgNL+ovkR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313277998"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="313277998"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:27:59 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="769184479"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="769184479"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:27:56 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next v2 1/4] devlink: Add uapi changes for tx_priority and tx_weight
Date:   Thu,  1 Dec 2022 11:26:23 +0100
Message-Id: <20221201102626.56390-2-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221201102626.56390-1-michal.wilczynski@intel.com>
References: <20221201102626.56390-1-michal.wilczynski@intel.com>
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

Per discussion [1] I'm putting the uapi changes in separate commit.
Those changes are already merged to net-next [2].

[1] https://lore.kernel.org/netdev/48df4e83-a9b8-11db-aeaf-2015666af5a5@gmail.com/
[2] https://lore.kernel.org/netdev/20221115104825.172668-1-michal.wilczynski@intel.com/

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 include/uapi/linux/devlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 0224b8bd49b2..b6b058e4bdb2 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -607,6 +607,9 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u32 */
+	DEVLINK_ATTR_RATE_TX_WEIGHT,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.37.2

