Return-Path: <netdev+bounces-11059-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FD98731620
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C17B21C20DD0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A476FC4;
	Thu, 15 Jun 2023 11:06:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DC5BA58
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:06:03 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C337296A
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686827154; x=1718363154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mp6ByUro06NPtnrqt6nAiZsz0HX+LOCLcdaHlWDZcO4=;
  b=eeAGxZYNaqBDsaUy9Cufr8zJefwKDcC08lZoGRtC5rkxl1rj2biuIuA0
   xAsHwszkbeLlqTDo14Z4WwGpI3/qfEh42ji1lrhO+w28eaGr/Igz6EbXa
   ukC47LJ8CSVuOlgPazythhVYuAUg4nR3pfMf6cFIyoHsuNPRCMcYDS0Vk
   jetzhX+uHxPGoLXpee2OBhNpNkFg93GeEExwtQtc7dBXx64vE5jX58BC0
   mGZ48riy7OI+7I2QTP44tVN86/fwvCe65eW83p+Kk3cOnTPU2JHr1WUB3
   /D3Ryswflv7oVVxb5xhhldzd9oZmfRfJA0nwft0SwDoUyszIIybKAXnd5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387329820"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="387329820"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 04:05:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="1042624090"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="1042624090"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2023 04:05:32 -0700
Received: from pelor.igk.intel.com (pelor.igk.intel.com [10.123.220.13])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id DFE6D33BEA;
	Thu, 15 Jun 2023 12:05:31 +0100 (IST)
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: [PATCH iwl-next v2 1/2] iavf: remove some unused functions and pointless wrappers
Date: Thu, 15 Jun 2023 07:03:08 -0400
Message-Id: <20230615110309.14698-2-przemyslaw.kitszel@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230615110309.14698-1-przemyslaw.kitszel@intel.com>
References: <20230615110309.14698-1-przemyslaw.kitszel@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 5c9759d76a2a..b997d00bc223 100644
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


