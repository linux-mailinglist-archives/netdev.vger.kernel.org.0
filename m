Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E3A629644
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238474AbiKOKuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238417AbiKOKtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:49:45 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E273626135
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668509358; x=1700045358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CdNB1lOP9vxItqr9IW6oDfWGhWDyfTI0k898ORTLrsY=;
  b=bA4gg/L51tdhFnejVSL3aQAX30HfLn/2k/KF+mGlwxNChSr4TF4VXMe2
   AV7Tnx9JUKTPFdMoxB4Cnqy7fqszvKV20VeKOUB9f/AsxUn+PG2OcO015
   +Yg7imhCQnROMyiOALWHjJbTG9FQ98kt0jSBuqcJGWEoD7aMnKBcQas83
   QotEnSo/XtLxNzf7zAiel3VtsIflrwXnbd49Y3LvYweEkSVA+AJ4gZXV8
   VwUJJ5CMzNtJeeopCc+bUZwaPdA2BIF7W8x+K6MItHgZcfD3dkfouQgdx
   1wjPjadeby4H2NNT9F/ZSzhX2UtveP2WMzlyuWfRtCpZddc5T1I+PILQT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="376489543"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="376489543"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:49:18 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="633193512"
X-IronPort-AV: E=Sophos;i="5.96,165,1665471600"; 
   d="scan'208";a="633193512"
Received: from unknown (HELO fedora.igk.intel.com) ([10.123.220.6])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 02:49:16 -0800
From:   Michal Wilczynski <michal.wilczynski@intel.com>
To:     netdev@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        jesse.brandeburg@intel.com, przemyslaw.kitszel@intel.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org,
        ecree.xilinx@gmail.com, jiri@resnulli.us,
        Michal Wilczynski <michal.wilczynski@intel.com>
Subject: [PATCH net-next v12 11/11] Documentation: Add documentation for new devlink-rate attributes
Date:   Tue, 15 Nov 2022 11:48:25 +0100
Message-Id: <20221115104825.172668-12-michal.wilczynski@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221115104825.172668-1-michal.wilczynski@intel.com>
References: <20221115104825.172668-1-michal.wilczynski@intel.com>
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

Provide documentation for newly introduced netlink attributes for
devlink-rate: tx_priority and tx_weight.

Mention the possibility to export tree from the driver.

Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
---
 .../networking/devlink/devlink-port.rst       | 33 ++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 7627b1da01f2..643f5903d1d8 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -191,13 +191,44 @@ API allows to configure following rate object's parameters:
 ``tx_max``
   Maximum TX rate value.
 
+``tx_priority``
+  Allows for usage of strict priority arbiter among siblings. This
+  arbitration scheme attempts to schedule nodes based on their priority
+  as long as the nodes remain within their bandwidth limit. The higher the
+  priority the higher the probability that the node will get selected for
+  scheduling.
+
+``tx_weight``
+  Allows for usage of Weighted Fair Queuing arbitration scheme among
+  siblings. This arbitration scheme can be used simultaneously with the
+  strict priority. As a node is configured with a higher rate it gets more
+  BW relative to it's siblings. Values are relative like a percentage
+  points, they basically tell how much BW should node take relative to
+  it's siblings.
+
 ``parent``
   Parent node name. Parent node rate limits are considered as additional limits
   to all node children limits. ``tx_max`` is an upper limit for children.
   ``tx_share`` is a total bandwidth distributed among children.
 
+``tx_priority`` and ``tx_weight`` can be used simultaneously. In that case
+nodes with the same priority form a WFQ subgroup in the sibling group
+and arbitration among them is based on assigned weights.
+
+Arbitration flow from the high level:
+#. Choose a node, or group of nodes with the highest priority that stays
+   within the BW limit and are not blocked. Use ``tx_priority`` as a
+   parameter for this arbitration.
+#. If group of nodes have the same priority perform WFQ arbitration on
+   that subgroup. Use ``tx_weight`` as a parameter for this arbitration.
+#. Select the winner node, and continue arbitration flow among it's children,
+   until leaf node is reached, and the winner is established.
+#. If all the nodes from the highest priority sub-group are satisfied, or
+   overused their assigned BW, move to the lower priority nodes.
+
 Driver implementations are allowed to support both or either rate object types
-and setting methods of their parameters.
+and setting methods of their parameters. Additionally driver implementation
+may export nodes/leafs and their child-parent relationships.
 
 Terms and Definitions
 =====================
-- 
2.37.2

