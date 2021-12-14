Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42870474B57
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237259AbhLNS70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:59:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:65190 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237253AbhLNS7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 13:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639508365; x=1671044365;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kZKxiw+nU/oiR/HbgJwXXo98UhTtUHTtgoxeUoGIcg0=;
  b=SAWScCG8Zt+pIR9x8dW+hAc6qri8pzWuxdxP5mYMGVe87sX1vqjnByJF
   CWI/MUfiJUqAX0fw6jHfPNIL7evnhLjkAw4blWRkMfJdvhdq/4FvXbJ95
   5ivIZibeTX6TTJI/RLsJg2E7XEemnbgHqqEce7IKJKoMfB5Eppwny935S
   vuMpihkVAEZj8ceWwhLsUYiVzL1C72Jmq875M57q+DSCuCW/QAlmDMwzj
   cKqqfITMraPosf+hAabnnf5NbJFKS3P7Bloih9f5VgZAik+oP9kqQ1DNo
   XJKdyaIlKJOExFZhYLQTRWA497guJmByKhnHMb5+YLbwUMMBWHZp/wknO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="325335075"
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="325335075"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2021 10:30:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,205,1635231600"; 
   d="scan'208";a="583712803"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 14 Dec 2021 10:30:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 11/12] ice: Remove unnecessary casts
Date:   Tue, 14 Dec 2021 10:29:07 -0800
Message-Id: <20211214182908.1513343-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
References: <20211214182908.1513343-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The "bitmap" variable is already an unsigned long so there is no need
for this cast.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index b4bf18f9d4e3..7947223536e3 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -2661,11 +2661,9 @@ ice_cfg_agg(struct ice_port_info *pi, u32 agg_id, enum ice_agg_type agg_type,
 	int status;
 
 	mutex_lock(&pi->sched_lock);
-	status = ice_sched_cfg_agg(pi, agg_id, agg_type,
-				   (unsigned long *)&bitmap);
+	status = ice_sched_cfg_agg(pi, agg_id, agg_type, &bitmap);
 	if (!status)
-		status = ice_save_agg_tc_bitmap(pi, agg_id,
-						(unsigned long *)&bitmap);
+		status = ice_save_agg_tc_bitmap(pi, agg_id, &bitmap);
 	mutex_unlock(&pi->sched_lock);
 	return status;
 }
-- 
2.31.1

