Return-Path: <netdev+bounces-10400-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FF472E559
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AAE01C20CB7
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D9538CD2;
	Tue, 13 Jun 2023 14:15:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558C0522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:15:40 +0000 (UTC)
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45F1D1
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686665738; x=1718201738;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/AsdHWXHIV44bj+/sh2cZP3+Y7g33GwoX0+PiUBSW1w=;
  b=iKChgvfJTXq8r9M2LaNiIHn+e3e3oaBxigIwZmnwmYEnWU9xKyVOostL
   lVgYx6tWnQRq51vEBPfGYMHFhIqM6EGumfJwzT+yqr4nYPN1Kq+s0qQcZ
   26cw86q54+2e8gzuVyWgNQHcYKOr0d4dIaVhyXKN2VPYQHob4NNCGad5V
   1ucDXDh9YCIJwkibKbs2sn10PMDcy8K5Ix/vCSz7HyLKRPvIvzQpVwGJw
   tgiiAqoOUn6Zq5oVtrRDksRugNbs4HoQYmDYEUBo3CqhpvAZ47xG8SaOP
   nvkhrbMvk42sLKJ9+9JTLxEQPV2MJ0r5WwvVQa4NsqQqzUM8c+lUfOVZT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="337981462"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="337981462"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 07:15:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="856105019"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="856105019"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2023 07:15:36 -0700
Received: from pelor.igk.intel.com (pelor.igk.intel.com [10.123.220.13])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id A081B35429;
	Tue, 13 Jun 2023 15:15:35 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH iwl-next 1/2] iavf: remove some unused functions and pointless wrappers
Date: Tue, 13 Jun 2023 10:12:52 -0400
Message-Id: <20230613141253.57811-2-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613141253.57811-1-przemyslaw.kitszel@intel.com>
References: <20230613141253.57811-1-przemyslaw.kitszel@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Remove iavf_aq_get_rss_lut(), iavf_aq_get_rss_key(), iavf_vf_reset().

Remove some "OS specific memory free for shared code" wrappers ;)

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_alloc.h  |  3 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c | 45 -------------------
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 20 +++------
 drivers/net/ethernet/intel/iavf/iavf_osdep.h  |  9 ----
 .../net/ethernet/intel/iavf/iavf_prototype.h  |  5 ---
 5 files changed, 7 insertions(+), 75 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_alloc.h b/drivers/net/ethernet/intel/iavf/iavf_alloc.h
index 2711573c14ec..162ea70685a6 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_alloc.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_alloc.h
@@ -28,7 +28,6 @@ enum iavf_status iavf_free_dma_mem(struct iavf_hw *hw,
 				   struct iavf_dma_mem *mem);
 enum iavf_status iavf_allocate_virt_mem(struct iavf_hw *hw,
 					struct iavf_virt_mem *mem, u32 size);
-enum iavf_status iavf_free_virt_mem(struct iavf_hw *hw,
-				    struct iavf_virt_mem *mem);
+void iavf_free_virt_mem(struct iavf_hw *hw, struct iavf_virt_mem *mem);
 
 #endif /* _IAVF_ALLOC_H_ */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index dd11dbbd5551..1afd761d8052 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -35,7 +35,6 @@ enum iavf_status iavf_set_mac_type(struct iavf_hw *hw)
 		status = IAVF_ERR_DEVICE_NOT_SUPPORTED;
 	}
 
-	hw_dbg(hw, "found mac: %d, returns: %d\n", hw->mac.type, status);
 	return status;
 }
 
@@ -397,23 +396,6 @@ static enum iavf_status iavf_aq_get_set_rss_lut(struct iavf_hw *hw,
 	return status;
 }
 
-/**
- * iavf_aq_get_rss_lut
- * @hw: pointer to the hardware structure
- * @vsi_id: vsi fw index
- * @pf_lut: for PF table set true, for VSI table set false
- * @lut: pointer to the lut buffer provided by the caller
- * @lut_size: size of the lut buffer
- *
- * get the RSS lookup table, PF or VSI type
- **/
-enum iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 vsi_id,
-				     bool pf_lut, u8 *lut, u16 lut_size)
-{
-	return iavf_aq_get_set_rss_lut(hw, vsi_id, pf_lut, lut, lut_size,
-				       false);
-}
-
 /**
  * iavf_aq_set_rss_lut
  * @hw: pointer to the hardware structure
@@ -472,19 +454,6 @@ iavf_status iavf_aq_get_set_rss_key(struct iavf_hw *hw, u16 vsi_id,
 	return status;
 }
 
-/**
- * iavf_aq_get_rss_key
- * @hw: pointer to the hw struct
- * @vsi_id: vsi fw index
- * @key: pointer to key info struct
- *
- **/
-enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 vsi_id,
-				     struct iavf_aqc_get_set_rss_key_data *key)
-{
-	return iavf_aq_get_set_rss_key(hw, vsi_id, key, false);
-}
-
 /**
  * iavf_aq_set_rss_key
  * @hw: pointer to the hw struct
@@ -828,17 +797,3 @@ void iavf_vf_parse_hw_config(struct iavf_hw *hw,
 		vsi_res++;
 	}
 }
-
-/**
- * iavf_vf_reset
- * @hw: pointer to the hardware structure
- *
- * Send a VF_RESET message to the PF. Does not wait for response from PF
- * as none will be forthcoming. Immediately after calling this function,
- * the admin queue should be shut down and (optionally) reinitialized.
- **/
-enum iavf_status iavf_vf_reset(struct iavf_hw *hw)
-{
-	return iavf_aq_send_msg_to_pf(hw, VIRTCHNL_OP_RESET_VF,
-				      0, NULL, 0, NULL);
-}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index cf43e71e9c4f..adb9d3fe1a28 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -231,12 +231,11 @@ enum iavf_status iavf_allocate_dma_mem_d(struct iavf_hw *hw,
 }
 
 /**
- * iavf_free_dma_mem_d - OS specific memory free for shared code
+ * iavf_free_dma_mem - wrapper for DMA memory freeing
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-enum iavf_status iavf_free_dma_mem_d(struct iavf_hw *hw,
-				     struct iavf_dma_mem *mem)
+enum iavf_status iavf_free_dma_mem(struct iavf_hw *hw, struct iavf_dma_mem *mem)
 {
 	struct iavf_adapter *adapter = (struct iavf_adapter *)hw->back;
 
@@ -248,12 +247,12 @@ enum iavf_status iavf_free_dma_mem_d(struct iavf_hw *hw,
 }
 
 /**
- * iavf_allocate_virt_mem_d - OS specific memory alloc for shared code
+ * iavf_allocate_virt_mem - virt memory alloc wrapper
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to fill out
  * @size: size of memory requested
  **/
-enum iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
+enum iavf_status iavf_allocate_virt_mem(struct iavf_hw *hw,
 					  struct iavf_virt_mem *mem, u32 size)
 {
 	if (!mem)
@@ -269,20 +268,13 @@ enum iavf_status iavf_allocate_virt_mem_d(struct iavf_hw *hw,
 }
 
 /**
- * iavf_free_virt_mem_d - OS specific memory free for shared code
+ * iavf_free_virt_mem - virt memory free wrapper
  * @hw:   pointer to the HW structure
  * @mem:  ptr to mem struct to free
  **/
-enum iavf_status iavf_free_virt_mem_d(struct iavf_hw *hw,
-				      struct iavf_virt_mem *mem)
+void iavf_free_virt_mem(struct iavf_hw *hw, struct iavf_virt_mem *mem)
 {
-	if (!mem)
-		return IAVF_ERR_PARAM;
-
-	/* it's ok to kfree a NULL pointer */
 	kfree(mem->va);
-
-	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_osdep.h b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
index a452ce90679a..77d33deaabb5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_osdep.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_osdep.h
@@ -13,12 +13,6 @@
 /* get readq/writeq support for 32 bit kernels, use the low-first version */
 #include <linux/io-64-nonatomic-lo-hi.h>
 
-/* File to be the magic between shared code and
- * actual OS primitives
- */
-
-#define hw_dbg(hw, S, A...)	do {} while (0)
-
 #define wr32(a, reg, value)	writel((value), ((a)->hw_addr + (reg)))
 #define rd32(a, reg)		readl((a)->hw_addr + (reg))
 
@@ -35,14 +29,11 @@ struct iavf_dma_mem {
 
 #define iavf_allocate_dma_mem(h, m, unused, s, a) \
 	iavf_allocate_dma_mem_d(h, m, s, a)
-#define iavf_free_dma_mem(h, m) iavf_free_dma_mem_d(h, m)
 
 struct iavf_virt_mem {
 	void *va;
 	u32 size;
 };
-#define iavf_allocate_virt_mem(h, m, s) iavf_allocate_virt_mem_d(h, m, s)
-#define iavf_free_virt_mem(h, m) iavf_free_virt_mem_d(h, m)
 
 #define iavf_debug(h, m, s, ...)				\
 do {								\
diff --git a/drivers/net/ethernet/intel/iavf/iavf_prototype.h b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
index edebfbbcffdc..940cb4203fbe 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_prototype.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_prototype.h
@@ -40,12 +40,8 @@ enum iavf_status iavf_aq_queue_shutdown(struct iavf_hw *hw, bool unloading);
 const char *iavf_aq_str(struct iavf_hw *hw, enum iavf_admin_queue_err aq_err);
 const char *iavf_stat_str(struct iavf_hw *hw, enum iavf_status stat_err);
 
-enum iavf_status iavf_aq_get_rss_lut(struct iavf_hw *hw, u16 seid,
-				     bool pf_lut, u8 *lut, u16 lut_size);
 enum iavf_status iavf_aq_set_rss_lut(struct iavf_hw *hw, u16 seid,
 				     bool pf_lut, u8 *lut, u16 lut_size);
-enum iavf_status iavf_aq_get_rss_key(struct iavf_hw *hw, u16 seid,
-				     struct iavf_aqc_get_set_rss_key_data *key);
 enum iavf_status iavf_aq_set_rss_key(struct iavf_hw *hw, u16 seid,
 				     struct iavf_aqc_get_set_rss_key_data *key);
 
@@ -60,7 +56,6 @@ static inline struct iavf_rx_ptype_decoded decode_rx_desc_ptype(u8 ptype)
 
 void iavf_vf_parse_hw_config(struct iavf_hw *hw,
 			     struct virtchnl_vf_resource *msg);
-enum iavf_status iavf_vf_reset(struct iavf_hw *hw);
 enum iavf_status iavf_aq_send_msg_to_pf(struct iavf_hw *hw,
 					enum virtchnl_ops v_opcode,
 					enum iavf_status v_retval,
-- 
2.40.1


