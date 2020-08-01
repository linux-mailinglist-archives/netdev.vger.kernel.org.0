Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06242235343
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 18:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgHAQST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 12:18:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:19610 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgHAQSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 12:18:11 -0400
IronPort-SDR: CZvighjWh6Q1JiFgUDQVD+YKezUR+ywDoBIXSLnHYVzJjJb2XczWlyWSa5MTVLWv7ebrPqwHm6
 wqvqc3HkzL0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="236810854"
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="236810854"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 09:18:08 -0700
IronPort-SDR: LEGxremPwvnm+vKDXe/9PNpmZdr+XXhzl6Atv0/qUxj16WPI2zzwgtmjpMFny7Cd4CCOvMXTCr
 RS6V6GrbBT0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,422,1589266800"; 
   d="scan'208";a="331457724"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga007.jf.intel.com with ESMTP; 01 Aug 2020 09:18:07 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next 14/14] ice: Misc minor fixes
Date:   Sat,  1 Aug 2020 09:18:02 -0700
Message-Id: <20200801161802.867645-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
References: <20200801161802.867645-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of minor fixes including typos, white space, and
style. No functional changes.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c      | 5 ++---
 drivers/net/ethernet/intel/ice/ice_devlink.c     | 2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c   | 2 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h  | 4 ++--
 drivers/net/ethernet/intel/ice/ice_sched.c       | 4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx.c        | 7 +++----
 drivers/net/ethernet/intel/ice/ice_type.h        | 2 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c | 4 ++--
 drivers/net/ethernet/intel/ice/ice_xsk.c         | 2 --
 9 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 8a93fbd6f1be..34abfcea9858 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1718,8 +1718,7 @@ ice_alloc_hw_res(struct ice_hw *hw, u16 type, u16 num, bool btm, u16 *res)
  * @num: number of resources
  * @res: pointer to array that contains the resources to free
  */
-enum ice_status
-ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res)
+enum ice_status ice_free_hw_res(struct ice_hw *hw, u16 type, u16 num, u16 *res)
 {
 	struct ice_aqc_alloc_free_res_elem *buf;
 	enum ice_status status;
@@ -2121,7 +2120,7 @@ ice_parse_fdir_dev_caps(struct ice_hw *hw, struct ice_hw_dev_caps *dev_p,
  * @cap_count: the number of capabilities
  *
  * Helper device to parse device (0x000B) capabilities list. For
- * capabilities shared between device and device, this relies on
+ * capabilities shared between device and function, this relies on
  * ice_parse_common_caps.
  *
  * Loop through the list of provided capabilities and extract the relevant
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index dbbd8b6f9d1a..111d6bfe4222 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -357,7 +357,7 @@ void ice_devlink_unregister(struct ice_pf *pf)
  *
  * Create and register a devlink_port for this PF. Note that although each
  * physical function is connected to a separate devlink instance, the port
- * will still be numbered according to the physical function id.
+ * will still be numbered according to the physical function ID.
  *
  * Return: zero on success or an error code on failure.
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 2691dac0e159..b17ae3e20157 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -644,7 +644,7 @@ static bool ice_bits_max_set(const u8 *mask, u16 size, u16 max)
  * This function generates a key from a value, a don't care mask and a never
  * match mask.
  * upd, dc, and nm are optional parameters, and can be NULL:
- *	upd == NULL --> udp mask is all 1's (update all bits)
+ *	upd == NULL --> upd mask is all 1's (update all bits)
  *	dc == NULL --> dc mask is all 0's (no don't care bits)
  *	nm == NULL --> nm mask is all 0's (no never match bits)
  */
diff --git a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
index 92e4abca62a4..90abc8612a6a 100644
--- a/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
+++ b/drivers/net/ethernet/intel/ice/ice_hw_autogen.h
@@ -57,7 +57,7 @@
 #define PRTDCB_GENS				0x00083020
 #define PRTDCB_GENS_DCBX_STATUS_S		0
 #define PRTDCB_GENS_DCBX_STATUS_M		ICE_M(0x7, 0)
-#define PRTDCB_TUP2TC				0x001D26C0 /* Reset Source: CORER */
+#define PRTDCB_TUP2TC				0x001D26C0
 #define GL_PREEXT_L2_PMASK0(_i)			(0x0020F0FC + ((_i) * 4))
 #define GL_PREEXT_L2_PMASK1(_i)			(0x0020F108 + ((_i) * 4))
 #define GLFLXP_RXDID_FLX_WRD_0(_i)		(0x0045c800 + ((_i) * 4))
@@ -362,6 +362,7 @@
 #define GLV_TEPC(_VSI)				(0x00312000 + ((_VSI) * 4))
 #define GLV_UPRCL(_i)				(0x003B2000 + ((_i) * 8))
 #define GLV_UPTCL(_i)				(0x0030A000 + ((_i) * 8))
+#define PRTRPB_RDPC				0x000AC260
 #define VSIQF_FD_CNT(_VSI)			(0x00464000 + ((_VSI) * 4))
 #define VSIQF_FD_CNT_FD_GCNT_S			0
 #define VSIQF_FD_CNT_FD_GCNT_M			ICE_M(0x3FFF, 0)
@@ -378,6 +379,5 @@
 #define PFPM_WUS_FW_RST_WK_M			BIT(31)
 #define VFINT_DYN_CTLN(_i)			(0x00003800 + ((_i) * 4))
 #define VFINT_DYN_CTLN_CLEARPBA_M		BIT(1)
-#define PRTRPB_RDPC				0x000AC260
 
 #endif /* _ICE_HW_AUTOGEN_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 355f727563e4..44a228530253 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -170,7 +170,7 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 		return ICE_ERR_PARAM;
 	}
 
-	/* query the current node information from FW  before additing it
+	/* query the current node information from FW before adding it
 	 * to the SW DB
 	 */
 	status = ice_sched_query_elem(hw, le32_to_cpu(info->node_teid), &elem);
@@ -578,7 +578,7 @@ ice_alloc_lan_q_ctx(struct ice_hw *hw, u16 vsi_handle, u8 tc, u16 new_numqs)
 /**
  * ice_aq_rl_profile - performs a rate limiting task
  * @hw: pointer to the HW struct
- * @opcode:opcode for add, query, or remove profile(s)
+ * @opcode: opcode for add, query, or remove profile(s)
  * @num_profiles: the number of profiles
  * @buf: pointer to buffer
  * @buf_size: buffer size in bytes
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 77de8869e7ca..9d0d6b0025cf 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -631,9 +631,8 @@ ice_alloc_mapped_page(struct ice_ring *rx_ring, struct ice_rx_buf *bi)
 	dma_addr_t dma;
 
 	/* since we are recycling buffers we should seldom need to alloc */
-	if (likely(page)) {
+	if (likely(page))
 		return true;
-	}
 
 	/* alloc new page for storage */
 	page = dev_alloc_pages(ice_rx_pg_order(rx_ring));
@@ -1252,12 +1251,12 @@ int ice_clean_rx_irq(struct ice_ring *rx_ring, int budget)
  * @itr: ITR value to update
  *
  * Calculate how big of an increment should be applied to the ITR value passed
- * in based on wmem_default, SKB overhead, Ethernet overhead, and the current
+ * in based on wmem_default, SKB overhead, ethernet overhead, and the current
  * link speed.
  *
  * The following is a calculation derived from:
  *  wmem_default / (size + overhead) = desired_pkts_per_int
- *  rate / bits_per_byte / (size + Ethernet overhead) = pkt_rate
+ *  rate / bits_per_byte / (size + ethernet overhead) = pkt_rate
  *  (desired_pkt_rate / pkt_rate) * usecs_per_sec = ITR value
  *
  * Assuming wmem_default is 212992 and overhead is 640 bytes per
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index 1eb83d9b0546..4cdccfadf274 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -321,7 +321,7 @@ struct ice_nvm_info {
 	u32 flash_size;			/* Size of available flash in bytes */
 	u8 major_ver;			/* major version of NVM package */
 	u8 minor_ver;			/* minor version of dev starter */
-	u8 blank_nvm_mode;        /* is NVM empty (no FW present) */
+	u8 blank_nvm_mode;		/* is NVM empty (no FW present) */
 };
 
 struct ice_link_default_override_tlv {
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index cfdd820e9a2a..71497776ac62 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -2974,8 +2974,8 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		vsi->max_frame = qpi->rxq.max_pkt_size;
 	}
 
-	/* VF can request to configure less than allocated queues
-	 * or default allocated queues. So update the VSI with new number
+	/* VF can request to configure less than allocated queues or default
+	 * allocated queues. So update the VSI with new number
 	 */
 	vsi->num_txq = num_txq;
 	vsi->num_rxq = num_rxq;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 87862918bc7a..20ac5fca68c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -298,7 +298,6 @@ static void ice_xsk_remove_umem(struct ice_vsi *vsi, u16 qid)
 	}
 }
 
-
 /**
  * ice_xsk_umem_disable - disable a UMEM region
  * @vsi: Current VSI
@@ -594,7 +593,6 @@ int ice_clean_rx_irq_zc(struct ice_ring *rx_ring, int budget)
 		if (!size)
 			break;
 
-
 		rx_buf = &rx_ring->rx_buf[rx_ring->next_to_clean];
 		rx_buf->xdp->data_end = rx_buf->xdp->data + size;
 		xsk_buff_dma_sync_for_cpu(rx_buf->xdp);
-- 
2.26.2

