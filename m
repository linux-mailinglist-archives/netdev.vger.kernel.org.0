Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708805AF777
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiIFV4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIFV4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:56:15 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913718E99C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662501374; x=1694037374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bxfQunuTBvcor8fWgkijxWqL2cYCUPgR8+fT+/Kj0Zk=;
  b=hi6osMpyw8jTI4AnM95fLAc5bloGfAiihlgwBz7W2DGC13qAK1GL8Qab
   9GbwioFUp28M8Wjpe5decREP4Fbz2+uABXAq4+kFQtpiBHrQ323B7wDCS
   CW2TaYyFsmoLGxY/6yh0YMqeDrdg+jb8/wt78Z7coVO7yhFLs4vfZjxPc
   ltdenwGRzJIuw+hZ7fXO9nC0+GLvaq2SQslZoXMYE6ut4ywc6c8Sof5Bb
   7KpfTrDlnRPQ1QdrwNnpaXbpIIU7kSU2LsWujVwj+NLMAVNxK0xEC+Z1D
   yX3wCSXgmKWFT1tL/L4V6xZ0kTNePl81gEl4XotB5ynrJMx+36OCuqCSM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="383012344"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="383012344"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 14:56:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="682562900"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 06 Sep 2022 14:56:13 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jaroslaw Gawin <jaroslawx.gawin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Andrii Staikov <andrii.staikov@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/3] i40e: add description and modify interrupts configuration procedure
Date:   Tue,  6 Sep 2022 14:56:05 -0700
Message-Id: <20220906215606.3501995-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
References: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaroslaw Gawin <jaroslawx.gawin@intel.com>

Add description for values written into registers QINT_XXXX
and small cosmetic changes for MSI/LEGACY interrupts
configuration in the same way as for MSI-X.
Descriptions confirm the code is written correctly and
make the code clear. Small cosmetic changes for MSI/LEGACY
interrupts make code clear in the same manner as for MSI-X
interrupts.

Signed-off-by: Jaroslaw Gawin <jaroslawx.gawin@intel.com>
Signed-off-by: Andrii Staikov <andrii.staikov@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h      | 14 +++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c | 34 ++++++++-------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index d86b6d349ea9..9a60d6b207f7 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -399,6 +399,20 @@ struct i40e_ddp_old_profile_list {
 				 I40E_FLEX_54_MASK | I40E_FLEX_55_MASK | \
 				 I40E_FLEX_56_MASK | I40E_FLEX_57_MASK)
 
+#define I40E_QINT_TQCTL_VAL(qp, vector, nextq_type) \
+	(I40E_QINT_TQCTL_CAUSE_ENA_MASK | \
+	(I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) | \
+	((vector) << I40E_QINT_TQCTL_MSIX_INDX_SHIFT) | \
+	((qp) << I40E_QINT_TQCTL_NEXTQ_INDX_SHIFT) | \
+	(I40E_QUEUE_TYPE_##nextq_type << I40E_QINT_TQCTL_NEXTQ_TYPE_SHIFT))
+
+#define I40E_QINT_RQCTL_VAL(qp, vector, nextq_type) \
+	(I40E_QINT_RQCTL_CAUSE_ENA_MASK | \
+	(I40E_RX_ITR << I40E_QINT_RQCTL_ITR_INDX_SHIFT) | \
+	((vector) << I40E_QINT_RQCTL_MSIX_INDX_SHIFT) | \
+	((qp) << I40E_QINT_RQCTL_NEXTQ_INDX_SHIFT) | \
+	(I40E_QUEUE_TYPE_##nextq_type << I40E_QINT_RQCTL_NEXTQ_TYPE_SHIFT))
+
 struct i40e_flex_pit {
 	struct list_head list;
 	u16 src_offset;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 89dd46130c03..9b2f18dfd0c4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3879,7 +3879,7 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *vsi)
 		wr32(hw, I40E_PFINT_RATEN(vector - 1),
 		     i40e_intrl_usec_to_reg(vsi->int_rate_limit));
 
-		/* Linked list for the queuepairs assigned to this vector */
+		/* begin of linked list for RX queue assigned to this vector */
 		wr32(hw, I40E_PFINT_LNKLSTN(vector - 1), qp);
 		for (q = 0; q < q_vector->num_ringpairs; q++) {
 			u32 nextqp = has_xdp ? qp + vsi->alloc_queue_pairs : qp;
@@ -3895,6 +3895,7 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *vsi)
 			wr32(hw, I40E_QINT_RQCTL(qp), val);
 
 			if (has_xdp) {
+				/* TX queue with next queue set to TX */
 				val = I40E_QINT_TQCTL_CAUSE_ENA_MASK |
 				      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) |
 				      (vector << I40E_QINT_TQCTL_MSIX_INDX_SHIFT) |
@@ -3904,7 +3905,7 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *vsi)
 
 				wr32(hw, I40E_QINT_TQCTL(nextqp), val);
 			}
-
+			/* TX queue with next RX or end of linked list */
 			val = I40E_QINT_TQCTL_CAUSE_ENA_MASK |
 			      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) |
 			      (vector << I40E_QINT_TQCTL_MSIX_INDX_SHIFT) |
@@ -3973,7 +3974,6 @@ static void i40e_configure_msi_and_legacy(struct i40e_vsi *vsi)
 	struct i40e_q_vector *q_vector = vsi->q_vectors[0];
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_hw *hw = &pf->hw;
-	u32 val;
 
 	/* set the ITR configuration */
 	q_vector->rx.next_update = jiffies + 1;
@@ -3990,28 +3990,20 @@ static void i40e_configure_msi_and_legacy(struct i40e_vsi *vsi)
 	/* FIRSTQ_INDX = 0, FIRSTQ_TYPE = 0 (rx) */
 	wr32(hw, I40E_PFINT_LNKLST0, 0);
 
-	/* Associate the queue pair to the vector and enable the queue int */
-	val = I40E_QINT_RQCTL_CAUSE_ENA_MASK		       |
-	      (I40E_RX_ITR << I40E_QINT_RQCTL_ITR_INDX_SHIFT)  |
-	      (nextqp	   << I40E_QINT_RQCTL_NEXTQ_INDX_SHIFT)|
-	      (I40E_QUEUE_TYPE_TX << I40E_QINT_TQCTL_NEXTQ_TYPE_SHIFT);
-
-	wr32(hw, I40E_QINT_RQCTL(0), val);
+	/* Associate the queue pair to the vector and enable the queue
+	 * interrupt RX queue in linked list with next queue set to TX
+	 */
+	wr32(hw, I40E_QINT_RQCTL(0), I40E_QINT_RQCTL_VAL(nextqp, 0, TX));
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		val = I40E_QINT_TQCTL_CAUSE_ENA_MASK		     |
-		      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT)|
-		      (I40E_QUEUE_TYPE_TX
-		       << I40E_QINT_TQCTL_NEXTQ_TYPE_SHIFT);
-
-		wr32(hw, I40E_QINT_TQCTL(nextqp), val);
+		/* TX queue in linked list with next queue set to TX */
+		wr32(hw, I40E_QINT_TQCTL(nextqp),
+		     I40E_QINT_TQCTL_VAL(nextqp, 0, TX));
 	}
 
-	val = I40E_QINT_TQCTL_CAUSE_ENA_MASK		      |
-	      (I40E_TX_ITR << I40E_QINT_TQCTL_ITR_INDX_SHIFT) |
-	      (I40E_QUEUE_END_OF_LIST << I40E_QINT_TQCTL_NEXTQ_INDX_SHIFT);
-
-	wr32(hw, I40E_QINT_TQCTL(0), val);
+	/* last TX queue so the next RX queue doesn't matter */
+	wr32(hw, I40E_QINT_TQCTL(0),
+	     I40E_QINT_TQCTL_VAL(I40E_QUEUE_END_OF_LIST, 0, RX));
 	i40e_flush(hw);
 }
 
-- 
2.35.1

