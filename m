Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4383563EDBD
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiLAK23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiLAK2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:28:12 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9897A2C105
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669890491; x=1701426491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mc7Od7XYGYoGaurxyko9c2tZRfh+P5cEKjX66w/8Ywc=;
  b=CX4WLXKsLZkuLvJMcyUpU9vsSuyB40QNHggPycPx9SOxGTG6arSudMYm
   /XRCBIQADx0GPAqcjJS4VLPI9VeJOMjdv9LjkfQwQVVJFWQXjFbTo/n5o
   1gacZ5Vb6JkomqKUxL5v8JOHXjSrufH4+QLFL62o3CR/X8kZEaBXm6jss
   aBKafnSome28zWeak57lM6VhfMZvcifxab2ZJ4Gm6w+Dhb7YEHrG0xtyM
   p7NZQLu31y7A2w+/SH3fLfaWn9CvjCcn8uUC8Q+U9MqL8V4LFQL0Amx8L
   scjFqND3S7wyNuq1TfC3rLJn9EZQAOG2tTjC2zq9dL6AuqRST7T8wzMMC
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313278028"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="313278028"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:28:11 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="769184577"
X-IronPort-AV: E=Sophos;i="5.96,209,1665471600"; 
   d="scan'208";a="769184577"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 02:28:08 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, przemyslaw.kitszel@intel.com,
        jiri@resnulli.us, wojciech.drewek@intel.com, dsahern@gmail.com,
        stephen@networkplumber.org,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH iproute2-next v2 4/4] devlink: Add documentation for tx_prority and tx_weight
Date:   Thu,  1 Dec 2022 11:26:26 +0100
Message-Id: <20221201102626.56390-5-michal.wilczynski@intel.com>
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

New netlink attributes tx_priority and tx_weight were added.
Update the man page for devlink-rate to account for new attributes.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
 man/man8/devlink-rate.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/devlink-rate.8 b/man/man8/devlink-rate.8
index cc2f50c38619..bcec3c31673a 100644
--- a/man/man8/devlink-rate.8
+++ b/man/man8/devlink-rate.8
@@ -26,12 +26,16 @@ devlink-rate \- devlink rate management
 .RI "{ " DEV/PORT_INDEX " | " DEV/NODE_NAME " } "
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
+.RB [ " tx_priority \fIN " ]
+.RB [ " tx_weight \fIN " ]
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
 .BI "devlink port function rate add " DEV/NODE_NAME
 .RB [ " tx_share \fIVALUE " ]
 .RB [ " tx_max \fIVALUE " ]
+.RB [ " tx_priority \fIN " ]
+.RB [ " tx_weight \fIN " ]
 .RB "[ {" " parent \fINODE_NAME " | " noparent " "} ]"
 
 .ti -8
@@ -83,6 +87,20 @@ rate group.
 .PP
 .BI tx_max " VALUE"
 - specifies maximum tx rate value.
+.PP
+.BI tx_priority " N"
+- allows for usage of strict priority arbiter among siblings. This arbitration
+scheme attempts to schedule nodes based on their priority as long as the nodes
+remain within their bandwidth limit. The higher the priority the higher the
+probability that the node will get selected for scheduling.
+.PP
+.BI tx_weight " N"
+- allows for usage of Weighted Fair Queuing arbitration scheme among siblings.
+This arbitration scheme can be used simultaneously with the strict priority.
+As a node is configured with a higher rate it gets more BW relative to it's
+siblings. Values are relative like a percentage points, they basically tell
+how much BW should node take relative to it's siblings.
+.PP
 .TP 8
 .I VALUE
 These parameter accept a floating point number, possibly followed by either a
@@ -123,6 +141,10 @@ To specify in IEC units, replace the SI prefix (k-, m-, g-, t-) with IEC prefix
 (ki-, mi-, gi- and ti-) respectively. Input is case-insensitive.
 .RE
 .PP
+.TP 8
+.I N
+These parameter accept integer meaning weight or priority of a node.
+.PP
 .BI parent " NODE_NAME \fR| " noparent
 - set rate object parent to existing node with name \fINODE_NAME\fR or unset
 parent. Rate limits of the parent node applied to all it's children. Actual
-- 
2.37.2

