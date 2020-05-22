Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52C1DE047
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgEVG40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:26 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbgEVG4X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:23 -0400
IronPort-SDR: R9tZqUpVwShwd92/caPNZ2hRIBIZhCicPzBHZxDHYqTbUNB9sWyhmaBgt4hkunfaAc8NflViYA
 WkyQYy4ahLyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:12 -0700
IronPort-SDR: 1AaNtcbnROH2GYFc3mz07xVEP33IpAtP54RVAU35cpU94mHDlY2IZklIprgOxQcYr89S+Li/hY
 c3Un+9/2PN/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017785"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 17/17] ice: Rename build_ctob to ice_build_ctob
Date:   Thu, 21 May 2020 23:56:07 -0700
Message-Id: <20200522065607.1680050-18-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

To make the function easier to identify as being part of the ice driver,
prepend ice to the function name.

Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 11 ++++++-----
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  4 ++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  4 ++--
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 05d1077f80c3..0d90e32efab9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1680,7 +1680,8 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 		 */
 		while (unlikely(size > ICE_MAX_DATA_PER_TXD)) {
 			tx_desc->cmd_type_offset_bsz =
-				build_ctob(td_cmd, td_offset, max_data, td_tag);
+				ice_build_ctob(td_cmd, td_offset, max_data,
+					       td_tag);
 
 			tx_desc++;
 			i++;
@@ -1700,8 +1701,8 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 		if (likely(!data_len))
 			break;
 
-		tx_desc->cmd_type_offset_bsz = build_ctob(td_cmd, td_offset,
-							  size, td_tag);
+		tx_desc->cmd_type_offset_bsz = ice_build_ctob(td_cmd, td_offset,
+							      size, td_tag);
 
 		tx_desc++;
 		i++;
@@ -1732,8 +1733,8 @@ ice_tx_map(struct ice_ring *tx_ring, struct ice_tx_buf *first,
 
 	/* write last descriptor with RS and EOP bits */
 	td_cmd |= (u64)ICE_TXD_LAST_DESC_CMD;
-	tx_desc->cmd_type_offset_bsz = build_ctob(td_cmd, td_offset, size,
-						  td_tag);
+	tx_desc->cmd_type_offset_bsz =
+			ice_build_ctob(td_cmd, td_offset, size, td_tag);
 
 	/* Force memory writes to complete before letting h/w know there
 	 * are new descriptors to fetch.
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 9d6512f96b8c..1ba97172d8d0 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -232,8 +232,8 @@ int ice_xmit_xdp_ring(void *data, u16 size, struct ice_ring *xdp_ring)
 
 	tx_desc = ICE_TX_DESC(xdp_ring, i);
 	tx_desc->buf_addr = cpu_to_le64(dma);
-	tx_desc->cmd_type_offset_bsz = build_ctob(ICE_TXD_LAST_DESC_CMD, 0,
-						  size, 0);
+	tx_desc->cmd_type_offset_bsz = ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0,
+						      size, 0);
 
 	/* Make certain all of the status bits have been updated
 	 * before next_to_watch is written.
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
index af0fca5b91ff..58ff58f0f972 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
@@ -22,7 +22,7 @@ ice_test_staterr(union ice_32b_rx_flex_desc *rx_desc, const u16 stat_err_bits)
 }
 
 static inline __le64
-build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
+ice_build_ctob(u64 td_cmd, u64 td_offset, unsigned int size, u64 td_tag)
 {
 	return cpu_to_le64(ICE_TX_DESC_DTYPE_DATA |
 			   (td_cmd    << ICE_TXD_QW1_CMD_S) |
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 23e5515d4527..20ac54e3156d 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -988,8 +988,8 @@ static bool ice_xmit_zc(struct ice_ring *xdp_ring, int budget)
 
 		tx_desc = ICE_TX_DESC(xdp_ring, xdp_ring->next_to_use);
 		tx_desc->buf_addr = cpu_to_le64(dma);
-		tx_desc->cmd_type_offset_bsz = build_ctob(ICE_TXD_LAST_DESC_CMD,
-							  0, desc.len, 0);
+		tx_desc->cmd_type_offset_bsz =
+			ice_build_ctob(ICE_TXD_LAST_DESC_CMD, 0, desc.len, 0);
 
 		xdp_ring->next_to_use++;
 		if (xdp_ring->next_to_use == xdp_ring->count)
-- 
2.26.2

