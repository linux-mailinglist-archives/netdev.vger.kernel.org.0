Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27E141E338
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349432AbhI3VWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:22:46 -0400
Received: from mga04.intel.com ([192.55.52.120]:24274 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348770AbhI3VWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 17:22:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="223401442"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="223401442"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:21:01 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="520621727"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.1])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:21:01 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next] devlink: print maximum number of snapshots if available
Date:   Thu, 30 Sep 2021 14:20:50 -0700
Message-Id: <20210930212050.1673896-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently the kernel gained ability to report the maximum number of
snapshots a region can have. Print this value out if it was reported.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---

This requires updating the UAPI headers to the commit which includes the
DEVLINK_ATTR_REGION_MAX_SNAPSHOTS attribute.

 devlink/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2f2142ed3856..07c4e08ab9d8 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -7845,6 +7845,10 @@ static void pr_out_region(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_REGION_SNAPSHOT_ID])
 		pr_out_snapshot(dl, tb);
 
+	if (tb[DEVLINK_ATTR_REGION_MAX_SNAPSHOTS])
+		pr_out_u64(dl, "max",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_REGION_MAX_SNAPSHOTS]));
+
 	pr_out_region_handle_end(dl);
 }
 

base-commit: 2f5825cb38028a14961a79844a069be4e3057eca
-- 
2.31.1.331.gb0c09ab8796f

