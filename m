Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1526389E1
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiKYMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiKYMew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:34:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B184A9E7
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669379684; x=1700915684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eXn6Yvb5MA1RZy55IvPtGrVfS3vqrD8npS+FVGk1oK0=;
  b=N8Q+ByrPnjNimmqJF05B0T5f4ePlpZwFLaxO7QM3WWoqullS7+0hi8L3
   d+QqNLFSjnTCjIVRb48vvkohwVw1MOA6WSVeMcChojsvZewiqRrbqNytn
   StTvekjzR0x+6rIgoRNBsiPgFIWgWHPVN/XcSJQiLY7EtZ/3JK1aQCKio
   q5DXlpdReYutDE5IXK3OoTI8E9l0aNDGi5LHPmpSxkP+OeV+kr4E96+af
   sFADvA4++CG3sknnZhTTTKB8frnDb17hVmKluiHWjK7/4EzEbSfZyqOc5
   xGc6EagCA+0I2Xq8wWYdniXjaalNkWQUzYk7UTy0cQ9QRow28yih16KHi
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="314510198"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="314510198"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="711264008"
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="711264008"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2022 04:34:41 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next 2/5] devlink: Add uapi changes for tx_priority and tx_weight
Date:   Fri, 25 Nov 2022 13:34:18 +0100
Message-Id: <20221125123421.36297-3-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221125123421.36297-1-michal.wilczynski@intel.com>
References: <20221125123421.36297-1-michal.wilczynski@intel.com>
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

