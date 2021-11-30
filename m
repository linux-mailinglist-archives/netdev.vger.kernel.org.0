Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2C4463FDB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344058AbhK3VZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:25:28 -0500
Received: from mga03.intel.com ([134.134.136.65]:13470 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344046AbhK3VYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 16:24:46 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236264004"
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="236264004"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 13:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="744895473"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2021 13:21:18 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Paul Greenwalt <paul.greenwalt@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 07/10] iavf: Fix static code analysis warning
Date:   Tue, 30 Nov 2021 13:20:01 -0800
Message-Id: <20211130212004.198898-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
References: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Change min() to min_t() to fix static code analysis warning of possible
overflow.

Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 3525eab8e9f9..42c9f9dc235c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1766,7 +1766,7 @@ int iavf_napi_poll(struct napi_struct *napi, int budget)
 	if (likely(napi_complete_done(napi, work_done)))
 		iavf_update_enable_itr(vsi, q_vector);
 
-	return min(work_done, budget - 1);
+	return min_t(int, work_done, budget - 1);
 }
 
 /**
-- 
2.31.1

