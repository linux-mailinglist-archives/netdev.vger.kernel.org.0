Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4351FEAC3
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgFRFOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:27995 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbgFRFOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:14 -0400
IronPort-SDR: 47vIvCvWnsOMwcqRCizVguIbnCiOr8IoCv320+t/mZkOEe3icsgszXv53HqGsFU9nLNEuEx6Fw
 isgijdF921XA==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="207694699"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="207694699"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:50 -0700
IronPort-SDR: McLwl+4qW4FJs/U6270NeS7XJA5yNme6w0xMHCvB4QtPgvV2rMewxQV8Ey7geyp+fpl1liw/Kl
 SplPMIb+MbYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495581"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] iecm: Add TX/RX header files
Date:   Wed, 17 Jun 2020 22:13:32 -0700
Message-Id: <20200618051344.516587-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

Introduces the data for the TX/RX paths for use
by the common module.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/net/intel/iecm_lan_pf_regs.h | 120 ++++
 include/linux/net/intel/iecm_lan_txrx.h    | 636 +++++++++++++++++++++
 include/linux/net/intel/iecm_txrx.h        | 610 ++++++++++++++++++++
 3 files changed, 1366 insertions(+)
 create mode 100644 include/linux/net/intel/iecm_lan_pf_regs.h
 create mode 100644 include/linux/net/intel/iecm_lan_txrx.h
 create mode 100644 include/linux/net/intel/iecm_txrx.h

diff --git a/include/linux/net/intel/iecm_lan_pf_regs.h b/include/linux/net/intel/iecm_lan_pf_regs.h
new file mode 100644
index 000000000000..6690a2645608
--- /dev/null
+++ b/include/linux/net/intel/iecm_lan_pf_regs.h
@@ -0,0 +1,120 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_LAN_PF_REGS_H_
+#define _IECM_LAN_PF_REGS_H_
+
+/* Receive queues */
+#define PF_QRX_BASE			0x00000000
+#define PF_QRX_TAIL(_QRX)		(PF_QRX_BASE + (((_QRX) * 0x1000)))
+#define PF_QRX_BUFFQ_BASE		0x03000000
+#define PF_QRX_BUFFQ_TAIL(_QRX)		\
+	(PF_QRX_BUFFQ_BASE + (((_QRX) * 0x1000)))
+
+/* Transmit queues */
+#define PF_QTX_BASE			0x05000000
+#define PF_QTX_COMM_DBELL(_DBQM)	(PF_QTX_BASE + ((_DBQM) * 0x1000))
+
+/* Control(PF Mailbox) Queue */
+#define PF_FW_BASE			0x08400000
+
+#define PF_FW_ARQBAL			(PF_FW_BASE)
+#define PF_FW_ARQBAH			(PF_FW_BASE + 0x4)
+#define PF_FW_ARQLEN			(PF_FW_BASE + 0x8)
+#define PF_FW_ARQLEN_ARQLEN_S		0
+#define PF_FW_ARQLEN_ARQLEN_M		MAKEMASK(0x1FFF, PF_FW_ARQLEN_ARQLEN_S)
+#define PF_FW_ARQLEN_ARQVFE_S		28
+#define PF_FW_ARQLEN_ARQVFE_M		BIT(PF_FW_ARQLEN_ARQVFE_S)
+#define PF_FW_ARQLEN_ARQOVFL_S		29
+#define PF_FW_ARQLEN_ARQOVFL_M		BIT(PF_FW_ARQLEN_ARQOVFL_S)
+#define PF_FW_ARQLEN_ARQCRIT_S		30
+#define PF_FW_ARQLEN_ARQCRIT_M		BIT(PF_FW_ARQLEN_ARQCRIT_S)
+#define PF_FW_ARQLEN_ARQENABLE_S	31
+#define PF_FW_ARQLEN_ARQENABLE_M	BIT(PF_FW_ARQLEN_ARQENABLE_S)
+#define PF_FW_ARQH			(PF_FW_BASE + 0xC)
+#define PF_FW_ARQH_ARQH_S		0
+#define PF_FW_ARQH_ARQH_M		MAKEMASK(0x1FFF, PF_FW_ARQH_ARQH_S)
+#define PF_FW_ARQT			(PF_FW_BASE + 0x10)
+
+#define PF_FW_ATQBAL			(PF_FW_BASE + 0x14)
+#define PF_FW_ATQBAH			(PF_FW_BASE + 0x18)
+#define PF_FW_ATQLEN			(PF_FW_BASE + 0x1C)
+#define PF_FW_ATQLEN_ATQLEN_S		0
+#define PF_FW_ATQLEN_ATQLEN_M		MAKEMASK(0x3FF, PF_FW_ATQLEN_ATQLEN_S)
+#define PF_FW_ATQLEN_ATQVFE_S		28
+#define PF_FW_ATQLEN_ATQVFE_M		BIT(PF_FW_ATQLEN_ATQVFE_S)
+#define PF_FW_ATQLEN_ATQOVFL_S		29
+#define PF_FW_ATQLEN_ATQOVFL_M		BIT(PF_FW_ATQLEN_ATQOVFL_S)
+#define PF_FW_ATQLEN_ATQCRIT_S		30
+#define PF_FW_ATQLEN_ATQCRIT_M		BIT(PF_FW_ATQLEN_ATQCRIT_S)
+#define PF_FW_ATQLEN_ATQENABLE_S	31
+#define PF_FW_ATQLEN_ATQENABLE_M	BIT(PF_FW_ATQLEN_ATQENABLE_S)
+#define PF_FW_ATQH			(PF_FW_BASE + 0x20)
+#define PF_FW_ATQH_ATQH_S		0
+#define PF_FW_ATQH_ATQH_M		MAKEMASK(0x3FF, PF_FW_ATQH_ATQH_S)
+#define PF_FW_ATQT			(PF_FW_BASE + 0x24)
+
+/* Interrupts */
+#define PF_GLINT_BASE			0x08900000
+#define PF_GLINT_DYN_CTL(_INT)		(PF_GLINT_BASE + ((_INT) * 0x1000))
+#define PF_GLINT_DYN_CTL_INTENA_S	0
+#define PF_GLINT_DYN_CTL_INTENA_M	BIT(PF_GLINT_DYN_CTL_INTENA_S)
+#define PF_GLINT_DYN_CTL_CLEARPBA_S	1
+#define PF_GLINT_DYN_CTL_CLEARPBA_M	BIT(PF_GLINT_DYN_CTL_CLEARPBA_S)
+#define PF_GLINT_DYN_CTL_SWINT_TRIG_S	2
+#define PF_GLINT_DYN_CTL_SWINT_TRIG_M	BIT(PF_GLINT_DYN_CTL_SWINT_TRIG_S)
+#define PF_GLINT_DYN_CTL_ITR_INDX_S	3
+#define PF_GLINT_DYN_CTL_INTERVAL_S	5
+#define PF_GLINT_DYN_CTL_INTERVAL_M	BIT(PF_GLINT_DYN_CTL_INTERVAL_S)
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_S	24
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_M \
+	BIT(PF_GLINT_DYN_CTL_SW_ITR_INDX_ENA_S)
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_S	25
+#define PF_GLINT_DYN_CTL_SW_ITR_INDX_M	BIT(PF_GLINT_DYN_CTL_SW_ITR_INDX_S)
+#define PF_GLINT_DYN_CTL_INTENA_MSK_S	31
+#define PF_GLINT_DYN_CTL_INTENA_MSK_M	BIT(PF_GLINT_DYN_CTL_INTENA_MSK_S)
+#define PF_GLINT_ITR(_i, _INT) (PF_GLINT_BASE + (((_INT) + \
+			       (((_i) + 1) * 4)) * 0x1000))
+#define PF_GLINT_ITR_MAX_INDEX		2
+#define PF_GLINT_ITR_INTERVAL_S		0
+#define PF_GLINT_ITR_INTERVAL_M		MAKEMASK(0xFFF, PF_GLINT_ITR_INTERVAL_S)
+
+/* Generic registers */
+#define PF_INT_DIR_OICR_ENA		0x08406000
+#define PF_INT_DIR_OICR_ENA_S		0
+#define PF_INT_DIR_OICR_ENA_M	MAKEMASK(0xFFFFFFFF, PF_INT_DIR_OICR_ENA_S)
+#define PF_INT_DIR_OICR			0x08406004
+#define PF_INT_DIR_OICR_TSYN_EVNT	0
+#define PF_INT_DIR_OICR_PHY_TS_0	BIT(1)
+#define PF_INT_DIR_OICR_PHY_TS_1	BIT(2)
+#define PF_INT_DIR_OICR_CAUSE		0x08406008
+#define PF_INT_DIR_OICR_CAUSE_CAUSE_S	0
+#define PF_INT_DIR_OICR_CAUSE_CAUSE_M	\
+	MAKEMASK(0xFFFFFFFF, PF_INT_DIR_OICR_CAUSE_CAUSE_S)
+#define PF_INT_PBA_CLEAR		0x0840600C
+
+#define PF_FUNC_RID			0x08406010
+#define PF_FUNC_RID_FUNCTION_NUMBER_S	0
+#define PF_FUNC_RID_FUNCTION_NUMBER_M	\
+	MAKEMASK(0x7, PF_FUNC_RID_FUNCTION_NUMBER_S)
+#define PF_FUNC_RID_DEVICE_NUMBER_S	3
+#define PF_FUNC_RID_DEVICE_NUMBER_M	\
+	MAKEMASK(0x1F, PF_FUNC_RID_DEVICE_NUMBER_S)
+#define PF_FUNC_RID_BUS_NUMBER_S	8
+#define PF_FUNC_RID_BUS_NUMBER_M	MAKEMASK(0xFF, PF_FUNC_RID_BUS_NUMBER_S)
+
+/* Reset registers */
+#define PFGEN_RTRIG			0x08407000
+#define PFGEN_RTRIG_CORER_S		0
+#define PFGEN_RTRIG_CORER_M		BIT(0)
+#define PFGEN_RTRIG_LINKR_S		1
+#define PFGEN_RTRIG_LINKR_M		BIT(1)
+#define PFGEN_RTRIG_IMCR_S		2
+#define PFGEN_RTRIG_IMCR_M		BIT(2)
+#define PFGEN_RSTAT			0x08407008 /* PFR Status */
+#define PFGEN_RSTAT_PFR_STATE_S		0
+#define PFGEN_RSTAT_PFR_STATE_M		MAKEMASK(0x3, PFGEN_RSTAT_PFR_STATE_S)
+#define PFGEN_CTRL			0x0840700C
+#define PFGEN_CTRL_PFSWR		BIT(0)
+
+#endif
diff --git a/include/linux/net/intel/iecm_lan_txrx.h b/include/linux/net/intel/iecm_lan_txrx.h
new file mode 100644
index 000000000000..6dc210925c7a
--- /dev/null
+++ b/include/linux/net/intel/iecm_lan_txrx.h
@@ -0,0 +1,636 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation. */
+
+#ifndef _IECM_LAN_TXRX_H_
+#define _IECM_LAN_TXRX_H_
+#include <linux/net/intel/iecm_osdep.h>
+
+enum iecm_rss_hash {
+	/* Values 0 - 28 are reserved for future use */
+	IECM_HASH_INVALID		= 0,
+	IECM_HASH_NONF_UNICAST_IPV4_UDP	= 29,
+	IECM_HASH_NONF_MULTICAST_IPV4_UDP,
+	IECM_HASH_NONF_IPV4_UDP,
+	IECM_HASH_NONF_IPV4_TCP_SYN_NO_ACK,
+	IECM_HASH_NONF_IPV4_TCP,
+	IECM_HASH_NONF_IPV4_SCTP,
+	IECM_HASH_NONF_IPV4_OTHER,
+	IECM_HASH_FRAG_IPV4,
+	/* Values 37-38 are reserved */
+	IECM_HASH_NONF_UNICAST_IPV6_UDP	= 39,
+	IECM_HASH_NONF_MULTICAST_IPV6_UDP,
+	IECM_HASH_NONF_IPV6_UDP,
+	IECM_HASH_NONF_IPV6_TCP_SYN_NO_ACK,
+	IECM_HASH_NONF_IPV6_TCP,
+	IECM_HASH_NONF_IPV6_SCTP,
+	IECM_HASH_NONF_IPV6_OTHER,
+	IECM_HASH_FRAG_IPV6,
+	IECM_HASH_NONF_RSVD47,
+	IECM_HASH_NONF_FCOE_OX,
+	IECM_HASH_NONF_FCOE_RX,
+	IECM_HASH_NONF_FCOE_OTHER,
+	/* Values 51-62 are reserved */
+	IECM_HASH_L2_PAYLOAD		= 63,
+	IECM_HASH_MAX
+};
+
+/* Supported RSS offloads */
+#define IECM_DEFAULT_RSS_HASH ( \
+	BIT_ULL(IECM_HASH_NONF_IPV4_UDP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV4_SCTP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV4_TCP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV4_OTHER) | \
+	BIT_ULL(IECM_HASH_FRAG_IPV4) | \
+	BIT_ULL(IECM_HASH_NONF_IPV6_UDP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV6_TCP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV6_SCTP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV6_OTHER) | \
+	BIT_ULL(IECM_HASH_FRAG_IPV6) | \
+	BIT_ULL(IECM_HASH_L2_PAYLOAD))
+
+#define IECM_DEFAULT_RSS_HASH_EXPANDED (IECM_DEFAULT_RSS_HASH | \
+	BIT_ULL(IECM_HASH_NONF_IPV4_TCP_SYN_NO_ACK) | \
+	BIT_ULL(IECM_HASH_NONF_UNICAST_IPV4_UDP) | \
+	BIT_ULL(IECM_HASH_NONF_MULTICAST_IPV4_UDP) | \
+	BIT_ULL(IECM_HASH_NONF_IPV6_TCP_SYN_NO_ACK) | \
+	BIT_ULL(IECM_HASH_NONF_UNICAST_IPV6_UDP) | \
+	BIT_ULL(IECM_HASH_NONF_MULTICAST_IPV6_UDP))
+
+/* For iecm_splitq_base_tx_compl_desc */
+#define IECM_TXD_COMPLQ_GEN_S	15
+#define IECM_TXD_COMPLQ_GEN_M		BIT_ULL(IECM_TXD_COMPLQ_GEN_S)
+#define IECM_TXD_COMPLQ_COMPL_TYPE_S	11
+#define IECM_TXD_COMPLQ_COMPL_TYPE_M	\
+	MAKEMASK(0x7UL, IECM_TXD_COMPLQ_COMPL_TYPE_S)
+#define IECM_TXD_COMPLQ_QID_S	0
+#define IECM_TXD_COMPLQ_QID_M		MAKEMASK(0x3FFUL, IECM_TXD_COMPLQ_QID_S)
+
+/* For base mode TX descriptors */
+#define IECM_TXD_CTX_QW1_MSS_S		50
+#define IECM_TXD_CTX_QW1_MSS_M		\
+	MAKEMASK(0x3FFFULL, IECM_TXD_CTX_QW1_MSS_S)
+#define IECM_TXD_CTX_QW1_TSO_LEN_S	30
+#define IECM_TXD_CTX_QW1_TSO_LEN_M	\
+	MAKEMASK(0x3FFFFULL, IECM_TXD_CTX_QW1_TSO_LEN_S)
+#define IECM_TXD_CTX_QW1_CMD_S		4
+#define IECM_TXD_CTX_QW1_CMD_M		\
+	MAKEMASK(0xFFFUL, IECM_TXD_CTX_QW1_CMD_S)
+#define IECM_TXD_CTX_QW1_DTYPE_S	0
+#define IECM_TXD_CTX_QW1_DTYPE_M	\
+	MAKEMASK(0xFUL, IECM_TXD_CTX_QW1_DTYPE_S)
+#define IECM_TXD_QW1_L2TAG1_S		48
+#define IECM_TXD_QW1_L2TAG1_M		\
+	MAKEMASK(0xFFFFULL, IECM_TXD_QW1_L2TAG1_S)
+#define IECM_TXD_QW1_TX_BUF_SZ_S	34
+#define IECM_TXD_QW1_TX_BUF_SZ_M	\
+	MAKEMASK(0x3FFFULL, IECM_TXD_QW1_TX_BUF_SZ_S)
+#define IECM_TXD_QW1_OFFSET_S		16
+#define IECM_TXD_QW1_OFFSET_M		\
+	MAKEMASK(0x3FFFFULL, IECM_TXD_QW1_OFFSET_S)
+#define IECM_TXD_QW1_CMD_S		4
+#define IECM_TXD_QW1_CMD_M		MAKEMASK(0xFFFUL, IECM_TXD_QW1_CMD_S)
+#define IECM_TXD_QW1_DTYPE_S		0
+#define IECM_TXD_QW1_DTYPE_M		MAKEMASK(0xFUL, IECM_TXD_QW1_DTYPE_S)
+
+/* TX Completion Descriptor Completion Types */
+#define IECM_TXD_COMPLT_ITR_FLUSH	0
+#define IECM_TXD_COMPLT_RULE_MISS	1
+#define IECM_TXD_COMPLT_RS		2
+#define IECM_TXD_COMPLT_REINJECTED	3
+#define IECM_TXD_COMPLT_RE		4
+#define IECM_TXD_COMPLT_SW_MARKER	5
+
+enum iecm_tx_desc_dtype_value {
+	IECM_TX_DESC_DTYPE_DATA				= 0,
+	IECM_TX_DESC_DTYPE_CTX				= 1,
+	IECM_TX_DESC_DTYPE_REINJECT_CTX			= 2,
+	IECM_TX_DESC_DTYPE_FLEX_DATA			= 3,
+	IECM_TX_DESC_DTYPE_FLEX_CTX			= 4,
+	IECM_TX_DESC_DTYPE_FLEX_TSO_CTX			= 5,
+	IECM_TX_DESC_DTYPE_FLEX_TSYN_L2TAG1		= 6,
+	IECM_TX_DESC_DTYPE_FLEX_L2TAG1_L2TAG2		= 7,
+	IECM_TX_DESC_DTYPE_FLEX_TSO_L2TAG2_PARSTAG_CTX	= 8,
+	IECM_TX_DESC_DTYPE_FLEX_HOSTSPLIT_SA_TSO_CTX	= 9,
+	IECM_TX_DESC_DTYPE_FLEX_HOSTSPLIT_SA_CTX	= 10,
+	IECM_TX_DESC_DTYPE_FLEX_L2TAG2_CTX		= 11,
+	IECM_TX_DESC_DTYPE_FLEX_FLOW_SCHE		= 12,
+	IECM_TX_DESC_DTYPE_FLEX_HOSTSPLIT_TSO_CTX	= 13,
+	IECM_TX_DESC_DTYPE_FLEX_HOSTSPLIT_CTX		= 14,
+	/* DESC_DONE - HW has completed write-back of descriptor */
+	IECM_TX_DESC_DTYPE_DESC_DONE			= 15,
+};
+
+enum iecm_tx_ctx_desc_cmd_bits {
+	IECM_TX_CTX_DESC_TSO		= 0x01,
+	IECM_TX_CTX_DESC_TSYN		= 0x02,
+	IECM_TX_CTX_DESC_IL2TAG2	= 0x04,
+	IECM_TX_CTX_DESC_RSVD		= 0x08,
+	IECM_TX_CTX_DESC_SWTCH_NOTAG	= 0x00,
+	IECM_TX_CTX_DESC_SWTCH_UPLINK	= 0x10,
+	IECM_TX_CTX_DESC_SWTCH_LOCAL	= 0x20,
+	IECM_TX_CTX_DESC_SWTCH_VSI	= 0x30,
+	IECM_TX_CTX_DESC_FILT_AU_EN	= 0x40,
+	IECM_TX_CTX_DESC_FILT_AU_EVICT	= 0x80,
+	IECM_TX_CTX_DESC_RSVD1		= 0xF00
+};
+
+enum iecm_tx_desc_len_fields {
+	/* Note: These are predefined bit offsets */
+	IECM_TX_DESC_LEN_MACLEN_S	= 0, /* 7 BITS */
+	IECM_TX_DESC_LEN_IPLEN_S	= 7, /* 7 BITS */
+	IECM_TX_DESC_LEN_L4_LEN_S	= 14 /* 4 BITS */
+};
+
+enum iecm_tx_base_desc_cmd_bits {
+	IECM_TX_DESC_CMD_EOP			= 0x0001,
+	IECM_TX_DESC_CMD_RS			= 0x0002,
+	 /* only on VFs else RSVD */
+	IECM_TX_DESC_CMD_ICRC			= 0x0004,
+	IECM_TX_DESC_CMD_IL2TAG1		= 0x0008,
+	IECM_TX_DESC_CMD_RSVD1			= 0x0010,
+	IECM_TX_DESC_CMD_IIPT_NONIP		= 0x0000, /* 2 BITS */
+	IECM_TX_DESC_CMD_IIPT_IPV6		= 0x0020, /* 2 BITS */
+	IECM_TX_DESC_CMD_IIPT_IPV4		= 0x0040, /* 2 BITS */
+	IECM_TX_DESC_CMD_IIPT_IPV4_CSUM		= 0x0060, /* 2 BITS */
+	IECM_TX_DESC_CMD_RSVD2			= 0x0080,
+	IECM_TX_DESC_CMD_L4T_EOFT_UNK		= 0x0000, /* 2 BITS */
+	IECM_TX_DESC_CMD_L4T_EOFT_TCP		= 0x0100, /* 2 BITS */
+	IECM_TX_DESC_CMD_L4T_EOFT_SCTP		= 0x0200, /* 2 BITS */
+	IECM_TX_DESC_CMD_L4T_EOFT_UDP		= 0x0300, /* 2 BITS */
+	IECM_TX_DESC_CMD_RSVD3			= 0x0400,
+	IECM_TX_DESC_CMD_RSVD4			= 0x0800,
+};
+
+/* Transmit descriptors  */
+/* splitq Tx buf, singleq Tx buf and singleq compl desc */
+struct iecm_base_tx_desc {
+	__le64 buf_addr; /* Address of descriptor's data buf */
+	__le64 qw1; /* type_cmd_offset_bsz_l2tag1 */
+};/* read used with buffer queues*/
+
+struct iecm_splitq_tx_compl_desc {
+	/* qid=[10:0] comptype=[13:11] rsvd=[14] gen=[15] */
+	__le16 qid_comptype_gen;
+	union {
+		__le16 q_head; /* Queue head */
+		__le16 compl_tag; /* Completion tag */
+	} q_head_compl_tag;
+	u8 ts[3];
+	u8 rsvd; /* Reserved */
+};/* writeback used with completion queues*/
+
+/* Context descriptors */
+struct iecm_base_tx_ctx_desc {
+	struct {
+		__le32 rsvd0;
+		__le16 l2tag2;
+		__le16 rsvd1;
+	} qw0;
+	__le64 qw1; /* type_cmd_tlen_mss/rt_hint */
+};
+
+/* Common cmd field defines for all desc except Flex Flow Scheduler (0x0C) */
+enum iecm_tx_flex_desc_cmd_bits {
+	IECM_TX_FLEX_DESC_CMD_EOP			= 0x01,
+	IECM_TX_FLEX_DESC_CMD_RS			= 0x02,
+	IECM_TX_FLEX_DESC_CMD_RE			= 0x04,
+	IECM_TX_FLEX_DESC_CMD_IL2TAG1			= 0x08,
+	IECM_TX_FLEX_DESC_CMD_DUMMY			= 0x10,
+	IECM_TX_FLEX_DESC_CMD_CS_EN			= 0x20,
+	IECM_TX_FLEX_DESC_CMD_FILT_AU_EN		= 0x40,
+	IECM_TX_FLEX_DESC_CMD_FILT_AU_EVICT		= 0x80,
+};
+
+struct iecm_flex_tx_desc {
+	__le64 buf_addr;	/* Packet buffer address */
+	struct {
+		__le16 cmd_dtype;
+#define IECM_FLEX_TXD_QW1_DTYPE_S		0
+#define IECM_FLEX_TXD_QW1_DTYPE_M		\
+		(0x1FUL << IECM_FLEX_TXD_QW1_DTYPE_S)
+#define IECM_FLEX_TXD_QW1_CMD_S		5
+#define IECM_FLEX_TXD_QW1_CMD_M		MAKEMASK(0x7FFUL, IECM_TXD_QW1_CMD_S)
+		union {
+			/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_DATA_(0x03) */
+			u8 raw[4];
+
+			/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_TSYN_L2TAG1 (0x06) */
+			struct {
+				__le16 l2tag1;
+				u8 flex;
+				u8 tsync;
+			} tsync;
+
+			/* DTYPE=IECM_TX_DESC_DTYPE_FLEX_L2TAG1_L2TAG2 (0x07) */
+			struct {
+				__le16 l2tag1;
+				__le16 l2tag2;
+			} l2tags;
+		} flex;
+		__le16 buf_size;
+	} qw1;
+};
+
+struct iecm_flex_tx_sched_desc {
+	__le64 buf_addr;	/* Packet buffer address */
+
+	/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_FLOW_SCHE_16B (0x0C) */
+	struct {
+		u8 cmd_dtype;
+#define IECM_TXD_FLEX_FLOW_DTYPE_M	0x1F
+#define IECM_TXD_FLEX_FLOW_CMD_EOP	0x20
+#define IECM_TXD_FLEX_FLOW_CMD_CS_EN	0x40
+#define IECM_TXD_FLEX_FLOW_CMD_RE	0x80
+
+		/* [23:23] Horizon Overflow bit, [22:0] timestamp */
+		u8 ts[3];
+#define IECM_TXD_FLOW_SCH_HORIZON_OVERFLOW_M	0x80
+
+		__le16 compl_tag;
+		__le16 rxr_bufsize;
+#define IECM_TXD_FLEX_FLOW_RXR		0x4000
+#define IECM_TXD_FLEX_FLOW_BUFSIZE_M	0x3FFF
+	} qw1;
+};
+
+/* Common cmd fields for all flex context descriptors
+ * Note: these defines already account for the 5 bit dtype in the cmd_dtype
+ * field
+ */
+enum iecm_tx_flex_ctx_desc_cmd_bits {
+	IECM_TX_FLEX_CTX_DESC_CMD_TSO			= 0x0020,
+	IECM_TX_FLEX_CTX_DESC_CMD_TSYN_EN		= 0x0040,
+	IECM_TX_FLEX_CTX_DESC_CMD_L2TAG2		= 0x0080,
+	IECM_TX_FLEX_CTX_DESC_CMD_SWTCH_UPLNK		= 0x0200, /* 2 bits */
+	IECM_TX_FLEX_CTX_DESC_CMD_SWTCH_LOCAL		= 0x0400, /* 2 bits */
+	IECM_TX_FLEX_CTX_DESC_CMD_SWTCH_TARGETVSI	= 0x0600, /* 2 bits */
+};
+
+/* Standard flex descriptor TSO context quad word */
+struct iecm_flex_tx_tso_ctx_qw {
+	__le32 flex_tlen;
+#define IECM_TXD_FLEX_CTX_TLEN_M	0x1FFFF
+#define IECM_TXD_FLEX_TSO_CTX_FLEX_S	24
+	__le16 mss_rt;
+#define IECM_TXD_FLEX_CTX_MSS_RT_M	0x3FFF
+	u8 hdr_len;
+	u8 flex;
+};
+
+union iecm_flex_tx_ctx_desc {
+	/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_CTX (0x04) */
+	struct {
+		u8 qw0_flex[8];
+		struct {
+			__le16 cmd_dtype;
+			__le16 l2tag1;
+			u8 qw1_flex[4];
+		} qw1;
+	} gen;
+
+	/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_TSO_CTX (0x05) */
+	struct {
+		struct iecm_flex_tx_tso_ctx_qw qw0;
+		struct {
+			__le16 cmd_dtype;
+			u8 flex[6];
+		} qw1;
+	} tso;
+
+	/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_TSO_L2TAG2_PARSTAG_CTX (0x08) */
+	struct {
+		struct iecm_flex_tx_tso_ctx_qw qw0;
+		struct {
+			__le16 cmd_dtype;
+			__le16 l2tag2;
+			u8 flex0;
+			u8 ptag;
+			u8 flex1[2];
+		} qw1;
+	} tso_l2tag2_ptag;
+
+	/* DTYPE = IECM_TX_DESC_DTYPE_FLEX_L2TAG2_CTX (0x0B) */
+	struct {
+		u8 qw0_flex[8];
+		struct {
+			__le16 cmd_dtype;
+			__le16 l2tag2;
+			u8 flex[4];
+		} qw1;
+	} l2tag2;
+
+	/* DTYPE = IECM_TX_DESC_DTYPE_REINJECT_CTX (0x02) */
+	struct {
+		struct {
+			__le32 sa_domain;
+#define IECM_TXD_FLEX_CTX_SA_DOM_M	0xFFFF
+#define IECM_TXD_FLEX_CTX_SA_DOM_VAL	0x10000
+			__le32 sa_idx;
+#define IECM_TXD_FLEX_CTX_SAIDX_M	0x1FFFFF
+		} qw0;
+		struct {
+			__le16 cmd_dtype;
+			__le16 txr2comp;
+#define IECM_TXD_FLEX_CTX_TXR2COMP	0x1
+			__le16 miss_txq_comp_tag;
+			__le16 miss_txq_id;
+		} qw1;
+	} reinjection_pkt;
+};
+
+/* Host Split Context Descriptors */
+struct iecm_flex_tx_hs_ctx_desc {
+	union {
+		struct {
+			__le32 host_fnum_tlen;
+#define IECM_TXD_FLEX_CTX_TLEN_S	0
+#define IECM_TXD_FLEX_CTX_TLEN_M	0x1FFFF
+#define IECM_TXD_FLEX_CTX_FNUM_S	18
+#define IECM_TXD_FLEX_CTX_FNUM_M	0x7FF
+#define IECM_TXD_FLEX_CTX_HOST_S	29
+#define IECM_TXD_FLEX_CTX_HOST_M	0x7
+			__le16 ftype_mss_rt;
+#define IECM_TXD_FLEX_CTX_MSS_RT_0	0
+#define IECM_TXD_FLEX_CTX_MSS_RT_M	0x3FFF
+#define IECM_TXD_FLEX_CTX_FTYPE_S	14
+#define IECM_TXD_FLEX_CTX_FTYPE_VF	MAKEMASK(0x0, IECM_TXD_FLEX_CTX_FTYPE_S)
+#define IECM_TXD_FLEX_CTX_FTYPE_VDEV	MAKEMASK(0x1, IECM_TXD_FLEX_CTX_FTYPE_S)
+#define IECM_TXD_FLEX_CTX_FTYPE_PF	MAKEMASK(0x2, IECM_TXD_FLEX_CTX_FTYPE_S)
+			u8 hdr_len;
+			u8 ptag;
+		} tso;
+		struct {
+			u8 flex0[2];
+			__le16 host_fnum_ftype;
+			u8 flex1[3];
+			u8 ptag;
+		} no_tso;
+	} qw0;
+
+	__le64 qw1_cmd_dtype;
+#define IECM_TXD_FLEX_CTX_QW1_PASID_S		16
+#define IECM_TXD_FLEX_CTX_QW1_PASID_M		0xFFFFF
+#define IECM_TXD_FLEX_CTX_QW1_PASID_VALID_S	36
+#define IECM_TXD_FLEX_CTX_QW1_PASID_VALID	\
+	MAKEMASK(0x1,  IECM_TXD_FLEX_CTX_PASID_VALID_S)
+#define IECM_TXD_FLEX_CTX_QW1_TPH_S		37
+#define IECM_TXD_FLEX_CTX_QW1_TPH		\
+	MAKEMASK(0x1, IECM_TXD_FLEX_CTX_TPH_S)
+#define IECM_TXD_FLEX_CTX_QW1_PFNUM_S		38
+#define IECM_TXD_FLEX_CTX_QW1_PFNUM_M		0xF
+/* The following are only valid for DTYPE = 0x09 and DTYPE = 0x0A */
+#define IECM_TXD_FLEX_CTX_QW1_SAIDX_S		42
+#define IECM_TXD_FLEX_CTX_QW1_SAIDX_M		0x1FFFFF
+#define IECM_TXD_FLEX_CTX_QW1_SAIDX_VAL_S	63
+#define IECM_TXD_FLEX_CTX_QW1_SAIDX_VALID	\
+	MAKEMASK(0x1,  IECM_TXD_FLEX_CTX_QW1_SAIDX_VAL_S)
+/* The following are only valid for DTYPE = 0x0D and DTYPE = 0x0E */
+#define IECM_TXD_FLEX_CTX_QW1_FLEX0_S		48
+#define IECM_TXD_FLEX_CTX_QW1_FLEX0_M		0xFF
+#define IECM_TXD_FLEX_CTX_QW1_FLEX1_S		56
+#define IECM_TXD_FLEX_CTX_QW1_FLEX1_M		0xFF
+};
+
+/* Rx */
+/* For iecm_splitq_base_rx_flex desc members */
+#define IECM_RXD_FLEX_PTYPE_S		0
+#define IECM_RXD_FLEX_PTYPE_M		MAKEMASK(0x3FFUL, IECM_RXD_FLEX_PTYPE_S)
+#define IECM_RXD_FLEX_UMBCAST_S		10
+#define IECM_RXD_FLEX_UMBCAST_M		MAKEMASK(0x3UL, IECM_RXD_FLEX_UMBCAST_S)
+#define IECM_RXD_FLEX_FF0_S		12
+#define IECM_RXD_FLEX_FF0_M		MAKEMASK(0xFUL, IECM_RXD_FLEX_FF0_S)
+#define IECM_RXD_FLEX_LEN_PBUF_S	0
+#define IECM_RXD_FLEX_LEN_PBUF_M	\
+	MAKEMASK(0x3FFFUL, IECM_RXD_FLEX_LEN_PBUF_S)
+#define IECM_RXD_FLEX_GEN_S		14
+#define IECM_RXD_FLEX_GEN_M		BIT_ULL(IECM_RXD_FLEX_GEN_S)
+#define IECM_RXD_FLEX_BUFQ_ID_S		15
+#define IECM_RXD_FLEX_BUFQ_ID_M		BIT_ULL(IECM_RXD_FLEX_BUFQ_ID_S)
+#define IECM_RXD_FLEX_LEN_HDR_S		0
+#define IECM_RXD_FLEX_LEN_HDR_M		\
+	MAKEMASK(0x3FFUL, IECM_RXD_FLEX_LEN_HDR_S)
+#define IECM_RXD_FLEX_RSC_S		10
+#define IECM_RXD_FLEX_RSC_M		BIT_ULL(IECM_RXD_FLEX_RSC_S)
+#define IECM_RXD_FLEX_SPH_S		11
+#define IECM_RXD_FLEX_SPH_M		BIT_ULL(IECM_RXD_FLEX_SPH_S)
+#define IECM_RXD_FLEX_MISS_S		12
+#define IECM_RXD_FLEX_MISS_M		BIT_ULL(IECM_RXD_FLEX_MISS_S)
+#define IECM_RXD_FLEX_FF1_S		13
+#define IECM_RXD_FLEX_FF1_M		MAKEMASK(0x7UL, IECM_RXD_FLEX_FF1_M)
+
+/* For iecm_singleq_base_rx_legacy desc members */
+#define IECM_RXD_QW1_LEN_SPH_S	63
+#define IECM_RXD_QW1_LEN_SPH_M	BIT_ULL(IECM_RXD_QW1_LEN_SPH_S)
+#define IECM_RXD_QW1_LEN_HBUF_S	52
+#define IECM_RXD_QW1_LEN_HBUF_M	MAKEMASK(0x7FFULL, IECM_RXD_QW1_LEN_HBUF_S)
+#define IECM_RXD_QW1_LEN_PBUF_S	38
+#define IECM_RXD_QW1_LEN_PBUF_M	MAKEMASK(0x3FFFULL, IECM_RXD_QW1_LEN_PBUF_S)
+#define IECM_RXD_QW1_PTYPE_S	30
+#define IECM_RXD_QW1_PTYPE_M	MAKEMASK(0xFFULL, IECM_RXD_QW1_PTYPE_S)
+#define IECM_RXD_QW1_ERROR_S	19
+#define IECM_RXD_QW1_ERROR_M	MAKEMASK(0xFFUL, IECM_RXD_QW1_ERROR_S)
+#define IECM_RXD_QW1_STATUS_S	0
+#define IECM_RXD_QW1_STATUS_M	MAKEMASK(0x7FFFFUL, IECM_RXD_QW1_STATUS_S)
+
+enum iecm_rx_flex_desc_status_error_0_qw1_bits {
+	/* Note: These are predefined bit offsets */
+	IECM_RX_FLEX_DESC_STATUS0_DD_S = 0,
+	IECM_RX_FLEX_DESC_STATUS0_EOF_S,
+	IECM_RX_FLEX_DESC_STATUS0_HBO_S,
+	IECM_RX_FLEX_DESC_STATUS0_L3L4P_S,
+	IECM_RX_FLEX_DESC_STATUS0_XSUM_IPE_S,
+	IECM_RX_FLEX_DESC_STATUS0_XSUM_L4E_S,
+	IECM_RX_FLEX_DESC_STATUS0_XSUM_EIPE_S,
+	IECM_RX_FLEX_DESC_STATUS0_XSUM_EUDPE_S,
+};
+
+enum iecm_rx_flex_desc_status_error_0_qw0_bits {
+	IECM_RX_FLEX_DESC_STATUS0_LPBK_S = 0,
+	IECM_RX_FLEX_DESC_STATUS0_IPV6EXADD_S,
+	IECM_RX_FLEX_DESC_STATUS0_RXE_S,
+	IECM_RX_FLEX_DESC_STATUS0_CRCP_S,
+	IECM_RX_FLEX_DESC_STATUS0_RSS_VALID_S,
+	IECM_RX_FLEX_DESC_STATUS0_L2TAG1P_S,
+	IECM_RX_FLEX_DESC_STATUS0_XTRMD0_VALID_S,
+	IECM_RX_FLEX_DESC_STATUS0_XTRMD1_VALID_S,
+	IECM_RX_FLEX_DESC_STATUS0_LAST /* this entry must be last!!! */
+};
+
+enum iecm_rx_flex_desc_status_error_1_bits {
+	/* Note: These are predefined bit offsets */
+	IECM_RX_FLEX_DESC_STATUS1_RSVD_S = 0, /* 2 bits */
+	IECM_RX_FLEX_DESC_STATUS1_ATRAEFAIL_S = 2,
+	IECM_RX_FLEX_DESC_STATUS1_L2TAG2P_S = 3,
+	IECM_RX_FLEX_DESC_STATUS1_XTRMD2_VALID_S = 4,
+	IECM_RX_FLEX_DESC_STATUS1_XTRMD3_VALID_S = 5,
+	IECM_RX_FLEX_DESC_STATUS1_XTRMD4_VALID_S = 6,
+	IECM_RX_FLEX_DESC_STATUS1_XTRMD5_VALID_S = 7,
+	IECM_RX_FLEX_DESC_STATUS1_LAST /* this entry must be last!!! */
+};
+
+enum iecm_rx_base_desc_status_bits {
+	/* Note: These are predefined bit offsets */
+	IECM_RX_BASE_DESC_STATUS_DD_S		= 0,
+	IECM_RX_BASE_DESC_STATUS_EOF_S		= 1,
+	IECM_RX_BASE_DESC_STATUS_L2TAG1P_S	= 2,
+	IECM_RX_BASE_DESC_STATUS_L3L4P_S	= 3,
+	IECM_RX_BASE_DESC_STATUS_CRCP_S		= 4,
+	IECM_RX_BASE_DESC_STATUS_RSVD_S		= 5, /* 3 BITS */
+	IECM_RX_BASE_DESC_STATUS_EXT_UDP_0_S	= 8,
+	IECM_RX_BASE_DESC_STATUS_UMBCAST_S	= 9, /* 2 BITS */
+	IECM_RX_BASE_DESC_STATUS_FLM_S		= 11,
+	IECM_RX_BASE_DESC_STATUS_FLTSTAT_S	= 12, /* 2 BITS */
+	IECM_RX_BASE_DESC_STATUS_LPBK_S		= 14,
+	IECM_RX_BASE_DESC_STATUS_IPV6EXADD_S	= 15,
+	IECM_RX_BASE_DESC_STATUS_RSVD1_S	= 16, /* 2 BITS */
+	IECM_RX_BASE_DESC_STATUS_INT_UDP_0_S	= 18,
+	IECM_RX_BASE_DESC_STATUS_LAST /* this entry must be last!!! */
+};
+
+enum iecm_rx_desc_fltstat_values {
+	IECM_RX_DESC_FLTSTAT_NO_DATA	= 0,
+	IECM_RX_DESC_FLTSTAT_RSV_FD_ID	= 1, /* 16byte desc? FD_ID : RSV */
+	IECM_RX_DESC_FLTSTAT_RSV	= 2,
+	IECM_RX_DESC_FLTSTAT_RSS_HASH	= 3,
+};
+
+enum iecm_rx_base_desc_error_bits {
+	/* Note: These are predefined bit offsets */
+	IECM_RX_BASE_DESC_ERROR_RXE_S		= 0,
+	IECM_RX_BASE_DESC_ERROR_ATRAEFAIL_S	= 1,
+	IECM_RX_BASE_DESC_ERROR_HBO_S		= 2,
+	IECM_RX_BASE_DESC_ERROR_L3L4E_S		= 3, /* 3 BITS */
+	IECM_RX_BASE_DESC_ERROR_IPE_S		= 3,
+	IECM_RX_BASE_DESC_ERROR_L4E_S		= 4,
+	IECM_RX_BASE_DESC_ERROR_EIPE_S		= 5,
+	IECM_RX_BASE_DESC_ERROR_OVERSIZE_S	= 6,
+	IECM_RX_BASE_DESC_ERROR_RSVD_S		= 7
+};
+
+/* Receive Descriptors */
+/* splitq buf*/
+struct iecm_splitq_rx_buf_desc {
+	struct {
+		__le16  buf_id; /* Buffer Identifier */
+		__le16  rsvd0;
+		__le32  rsvd1;
+	} qword0;
+	__le64  pkt_addr; /* Packet buffer address */
+	__le64  hdr_addr; /* Header buffer address */
+	__le64  rsvd2;
+}; /* read used with buffer queues*/
+
+/* singleq buf */
+struct iecm_singleq_rx_buf_desc {
+	__le64  pkt_addr; /* Packet buffer address */
+	__le64  hdr_addr; /* Header buffer address */
+	__le64  rsvd1;
+	__le64  rsvd2;
+}; /* read used with buffer queues*/
+
+union iecm_rx_buf_desc {
+	struct iecm_singleq_rx_buf_desc		read;
+	struct iecm_splitq_rx_buf_desc		split_rd;
+};
+
+/* splitq compl */
+struct iecm_flex_rx_desc {
+	/* Qword 0 */
+	u8 rxdid_ucast; /* profile_id=[3:0] */
+			/* rsvd=[5:4] */
+			/* ucast=[7:6] */
+	u8 status_err0_qw0;
+	__le16 ptype_err_fflags0;	/* ptype=[9:0] */
+					/* ip_hdr_err=[10:10] */
+					/* udp_len_err=[11:11] */
+					/* ff0=[15:12] */
+	__le16 pktlen_gen_bufq_id;	/* plen=[13:0] */
+					/* gen=[14:14]  only in splitq */
+					/* bufq_id=[15:15] only in splitq */
+	__le16 hdrlen_flags;		/* header=[9:0] */
+					/* rsc=[10:10] only in splitq */
+					/* sph=[11:11] only in splitq */
+					/* ext_udp_0=[12:12] */
+					/* int_udp_0=[13:13] */
+					/* trunc_mirr=[14:14] */
+					/* miss_prepend=[15:15] */
+	/* Qword 1 */
+	u8 status_err0_qw1;
+	u8 status_err1;
+	u8 fflags1;
+	u8 ts_low;
+	union {
+		__le16 fmd0;
+		__le16 buf_id; /* only in splitq */
+	} fmd0_bufid;
+	union {
+		__le16 fmd1;
+		__le16 raw_cs;
+		__le16 l2tag1;
+		__le16 rscseglen;
+	} fmd1_misc;
+	/* Qword 2 */
+	union {
+		__le16 fmd2;
+		__le16 hash1;
+	} fmd2_hash1;
+	union {
+		u8 fflags2;
+		u8 mirrorid;
+		u8 hash2;
+	} ff2_mirrid_hash2;
+	u8 hash3;
+	union {
+		__le16 fmd3;
+		__le16 l2tag2;
+	} fmd3_l2tag2;
+	__le16 fmd4;
+	/* Qword 3 */
+	union {
+		__le16 fmd5;
+		__le16 l2tag1;
+	} fmd5_l2tag1;
+	__le16 fmd6;
+	union {
+		struct {
+			__le16 fmd7_0;
+			__le16 fmd7_1;
+		} fmd7;
+		__le32 ts_high;
+	} flex_ts;
+}; /* writeback */
+
+/* singleq wb(compl) */
+struct iecm_singleq_base_rx_desc {
+	struct {
+		struct {
+			__le16 mirroring_status;
+			__le16 l2tag1;
+		} lo_dword;
+		union {
+			__le32 rss; /* RSS Hash */
+			__le32 fd_id; /* Flow Director filter id */
+		} hi_dword;
+	} qword0;
+	struct {
+		/* status/error/PTYPE/length */
+		__le64 status_error_ptype_len;
+	} qword1;
+	struct {
+		__le16 ext_status; /* extended status */
+		__le16 rsvd;
+		__le16 l2tag2_1;
+		__le16 l2tag2_2;
+	} qword2;
+	struct {
+		__le32 reserved;
+		__le32 fd_id;
+	} qword3;
+}; /* writeback */
+
+union iecm_rx_desc {
+	struct iecm_singleq_rx_buf_desc	read;
+	struct iecm_singleq_base_rx_desc	base_wb;
+	struct iecm_flex_rx_desc		flex_wb;
+};
+#endif /* _IECM_LAN_TXRX_H_ */
diff --git a/include/linux/net/intel/iecm_txrx.h b/include/linux/net/intel/iecm_txrx.h
new file mode 100644
index 000000000000..bf6f02592bb7
--- /dev/null
+++ b/include/linux/net/intel/iecm_txrx.h
@@ -0,0 +1,610 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2020 Intel Corporation */
+
+#ifndef _IECM_TXRX_H_
+#define _IECM_TXRX_H_
+
+#define IECM_MAX_Q				16
+/* Mailbox Queue */
+#define IECM_MAX_NONQ				1
+#define IECM_MAX_TXQ_DESC			512
+#define IECM_MAX_RXQ_DESC			512
+#define IECM_MIN_TXQ_DESC			128
+#define IECM_MIN_RXQ_DESC			128
+#define IECM_REQ_DESC_MULTIPLE			32
+
+#define IECM_DFLT_SINGLEQ_TX_Q_GROUPS		1
+#define IECM_DFLT_SINGLEQ_RX_Q_GROUPS		1
+#define IECM_DFLT_SINGLEQ_TXQ_PER_GROUP		4
+#define IECM_DFLT_SINGLEQ_RXQ_PER_GROUP		4
+
+#define IECM_COMPLQ_PER_GROUP			1
+#define IECM_BUFQS_PER_RXQ_SET			2
+
+#define IECM_DFLT_SPLITQ_TX_Q_GROUPS		4
+#define IECM_DFLT_SPLITQ_RX_Q_GROUPS		4
+#define IECM_DFLT_SPLITQ_TXQ_PER_GROUP		1
+#define IECM_DFLT_SPLITQ_RXQ_PER_GROUP		1
+
+/* Default vector sharing */
+#define IECM_MAX_NONQ_VEC	1
+#define IECM_MAX_Q_VEC		4 /* For Tx Completion queue and Rx queue */
+#define IECM_MAX_RDMA_VEC	2 /* To share with RDMA */
+#define IECM_MIN_RDMA_VEC	1 /* Minimum vectors to be shared with RDMA */
+#define IECM_MIN_VEC		3 /* One for mailbox, one for data queues, one
+				   * for RDMA
+				   */
+
+#define IECM_DFLT_TX_Q_DESC_COUNT		512
+#define IECM_DFLT_TX_COMPLQ_DESC_COUNT		512
+#define IECM_DFLT_RX_Q_DESC_COUNT		512
+#define IECM_DFLT_RX_BUFQ_DESC_COUNT		512
+
+#define IECM_RX_BUF_WRITE			16 /* Must be power of 2 */
+#define IECM_RX_HDR_SIZE			256
+#define IECM_RX_BUF_2048			2048
+#define IECM_RX_BUF_STRIDE			64
+#define IECM_LOW_WATERMARK			64
+#define IECM_HDR_BUF_SIZE			256
+#define IECM_PACKET_HDR_PAD	\
+	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+#define IECM_MAX_RXBUFFER			9728
+#define IECM_MAX_MTU		\
+	(IECM_MAX_RXBUFFER - IECM_PACKET_HDR_PAD)
+
+#define IECM_SINGLEQ_RX_BUF_DESC(R, i)	\
+	(&(((struct iecm_singleq_rx_buf_desc *)((R)->desc_ring))[i]))
+#define IECM_SPLITQ_RX_BUF_DESC(R, i)	\
+	(&(((struct iecm_splitq_rx_buf_desc *)((R)->desc_ring))[i]))
+
+#define IECM_BASE_TX_DESC(R, i)	\
+	(&(((struct iecm_base_tx_desc *)((R)->desc_ring))[i]))
+#define IECM_SPLITQ_TX_COMPLQ_DESC(R, i)	\
+	(&(((struct iecm_splitq_tx_compl_desc *)((R)->desc_ring))[i]))
+
+#define IECM_FLEX_TX_DESC(R, i)	\
+	(&(((union iecm_tx_flex_desc *)((R)->desc_ring))[i]))
+#define IECM_FLEX_TX_CTX_DESC(R, i)	\
+	(&(((union iecm_flex_tx_ctx_desc *)((R)->desc_ring))[i]))
+
+#define IECM_DESC_UNUSED(R)	\
+	((((R)->next_to_clean > (R)->next_to_use) ? 0 : (R)->desc_count) + \
+	(R)->next_to_clean - (R)->next_to_use - 1)
+
+union iecm_tx_flex_desc {
+	struct iecm_flex_tx_desc q; /* queue based scheduling */
+	struct iecm_flex_tx_sched_desc flow; /* flow based scheduling */
+};
+
+struct iecm_tx_buf {
+	struct hlist_node hlist;
+	void *next_to_watch;
+	struct sk_buff *skb;
+	unsigned int bytecount;
+	unsigned short gso_segs;
+#define IECM_TX_FLAGS_TSO	BIT(0)
+	u32 tx_flags;
+	DEFINE_DMA_UNMAP_ADDR(dma);
+	DEFINE_DMA_UNMAP_LEN(len);
+	u16 compl_tag;		/* Unique identifier for buffer; used to
+				 * compare with completion tag returned
+				 * in buffer completion event
+				 */
+};
+
+struct iecm_buf_lifo {
+	u16 top;
+	u16 size;
+	struct iecm_tx_buf **bufs;
+};
+
+struct iecm_tx_offload_params {
+	u16 td_cmd;	/* command field to be inserted into descriptor */
+	u32 tso_len;	/* total length of payload to segment */
+	u16 mss;
+	u8 tso_hdr_len;	/* length of headers to be duplicated */
+
+	/* Flow scheduling offload timestamp, formatting as hw expects it */
+#define IECM_TW_TIME_STAMP_GRAN_512_DIV_S	9
+#define IECM_TW_TIME_STAMP_GRAN_1024_DIV_S	10
+#define IECM_TW_TIME_STAMP_GRAN_2048_DIV_S	11
+#define IECM_TW_TIME_STAMP_GRAN_4096_DIV_S	12
+	u64 desc_ts;
+
+	/* For legacy offloads */
+	u32 hdr_offsets;
+};
+
+struct iecm_tx_splitq_params {
+	/* Descriptor build function pointer */
+	void (*splitq_build_ctb)(union iecm_tx_flex_desc *desc,
+				 struct iecm_tx_splitq_params *params,
+				 u16 td_cmd, u16 size);
+
+	/* General descriptor info */
+	enum iecm_tx_desc_dtype_value dtype;
+	u16 eop_cmd;
+	u16 compl_tag; /* only relevant for flow scheduling */
+
+	struct iecm_tx_offload_params offload;
+};
+
+#define IECM_TX_COMPLQ_CLEAN_BUDGET	256
+#define IECM_TX_MIN_LEN			17
+#define IECM_TX_DESCS_FOR_SKB_DATA_PTR	1
+#define IECM_TX_MAX_BUF			8
+#define IECM_TX_DESCS_PER_CACHE_LINE	4
+#define IECM_TX_DESCS_FOR_CTX		1
+/* TX descriptors needed, worst case */
+#define IECM_TX_DESC_NEEDED (MAX_SKB_FRAGS + IECM_TX_DESCS_FOR_CTX + \
+			     IECM_TX_DESCS_PER_CACHE_LINE + \
+			     IECM_TX_DESCS_FOR_SKB_DATA_PTR)
+
+/* The size limit for a transmit buffer in a descriptor is (16K - 1).
+ * In order to align with the read requests we will align the value to
+ * the nearest 4K which represents our maximum read request size.
+ */
+#define IECM_TX_MAX_READ_REQ_SIZE	4096
+#define IECM_TX_MAX_DESC_DATA		(16 * 1024 - 1)
+#define IECM_TX_MAX_DESC_DATA_ALIGNED \
+	(~(IECM_TX_MAX_READ_REQ_SIZE - 1) & IECM_TX_MAX_DESC_DATA)
+
+#define IECM_RX_DMA_ATTR \
+	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+#define IECM_RX_DESC(R, i)	\
+	(&(((union iecm_rx_desc *)((R)->desc_ring))[i]))
+
+struct iecm_rx_buf {
+	struct sk_buff *skb;
+	dma_addr_t dma;
+	struct page *page;
+	unsigned int page_offset;
+	u16 pagecnt_bias;
+	u16 buf_id;
+};
+
+/* Packet type non-ip values */
+enum iecm_rx_ptype_l2 {
+	IECM_RX_PTYPE_L2_RESERVED	= 0,
+	IECM_RX_PTYPE_L2_MAC_PAY2	= 1,
+	IECM_RX_PTYPE_L2_TIMESYNC_PAY2	= 2,
+	IECM_RX_PTYPE_L2_FIP_PAY2	= 3,
+	IECM_RX_PTYPE_L2_OUI_PAY2	= 4,
+	IECM_RX_PTYPE_L2_MACCNTRL_PAY2	= 5,
+	IECM_RX_PTYPE_L2_LLDP_PAY2	= 6,
+	IECM_RX_PTYPE_L2_ECP_PAY2	= 7,
+	IECM_RX_PTYPE_L2_EVB_PAY2	= 8,
+	IECM_RX_PTYPE_L2_QCN_PAY2	= 9,
+	IECM_RX_PTYPE_L2_EAPOL_PAY2	= 10,
+	IECM_RX_PTYPE_L2_ARP		= 11,
+};
+
+enum iecm_rx_ptype_outer_ip {
+	IECM_RX_PTYPE_OUTER_L2	= 0,
+	IECM_RX_PTYPE_OUTER_IP	= 1,
+};
+
+enum iecm_rx_ptype_outer_ip_ver {
+	IECM_RX_PTYPE_OUTER_NONE	= 0,
+	IECM_RX_PTYPE_OUTER_IPV4	= 1,
+	IECM_RX_PTYPE_OUTER_IPV6	= 2,
+};
+
+enum iecm_rx_ptype_outer_fragmented {
+	IECM_RX_PTYPE_NOT_FRAG	= 0,
+	IECM_RX_PTYPE_FRAG	= 1,
+};
+
+enum iecm_rx_ptype_tunnel_type {
+	IECM_RX_PTYPE_TUNNEL_NONE		= 0,
+	IECM_RX_PTYPE_TUNNEL_IP_IP		= 1,
+	IECM_RX_PTYPE_TUNNEL_IP_GRENAT		= 2,
+	IECM_RX_PTYPE_TUNNEL_IP_GRENAT_MAC	= 3,
+	IECM_RX_PTYPE_TUNNEL_IP_GRENAT_MAC_VLAN	= 4,
+};
+
+enum iecm_rx_ptype_tunnel_end_prot {
+	IECM_RX_PTYPE_TUNNEL_END_NONE	= 0,
+	IECM_RX_PTYPE_TUNNEL_END_IPV4	= 1,
+	IECM_RX_PTYPE_TUNNEL_END_IPV6	= 2,
+};
+
+enum iecm_rx_ptype_inner_prot {
+	IECM_RX_PTYPE_INNER_PROT_NONE		= 0,
+	IECM_RX_PTYPE_INNER_PROT_UDP		= 1,
+	IECM_RX_PTYPE_INNER_PROT_TCP		= 2,
+	IECM_RX_PTYPE_INNER_PROT_SCTP		= 3,
+	IECM_RX_PTYPE_INNER_PROT_ICMP		= 4,
+	IECM_RX_PTYPE_INNER_PROT_TIMESYNC	= 5,
+};
+
+enum iecm_rx_ptype_payload_layer {
+	IECM_RX_PTYPE_PAYLOAD_LAYER_NONE	= 0,
+	IECM_RX_PTYPE_PAYLOAD_LAYER_PAY2	= 1,
+	IECM_RX_PTYPE_PAYLOAD_LAYER_PAY3	= 2,
+	IECM_RX_PTYPE_PAYLOAD_LAYER_PAY4	= 3,
+};
+
+struct iecm_rx_ptype_decoded {
+	u32 ptype:10;
+	u32 known:1;
+	u32 outer_ip:1;
+	u32 outer_ip_ver:2;
+	u32 outer_frag:1;
+	u32 tunnel_type:3;
+	u32 tunnel_end_prot:2;
+	u32 tunnel_end_frag:1;
+	u32 inner_prot:4;
+	u32 payload_layer:3;
+};
+
+enum iecm_rx_hsplit {
+	IECM_RX_NO_HDR_SPLIT = 0,
+	IECM_RX_HDR_SPLIT = 1,
+	IECM_RX_HDR_SPLIT_PERF = 2,
+};
+
+/* The iecm_ptype_lkup table is used to convert from the 10-bit ptype in the
+ * hardware to a bit-field that can be used by SW to more easily determine the
+ * packet type.
+ *
+ * Macros are used to shorten the table lines and make this table human
+ * readable.
+ *
+ * We store the PTYPE in the top byte of the bit field - this is just so that
+ * we can check that the table doesn't have a row missing, as the index into
+ * the table should be the PTYPE.
+ *
+ * Typical work flow:
+ *
+ * IF NOT iecm_ptype_lkup[ptype].known
+ * THEN
+ *      Packet is unknown
+ * ELSE IF iecm_ptype_lkup[ptype].outer_ip == IECM_RX_PTYPE_OUTER_IP
+ *      Use the rest of the fields to look at the tunnels, inner protocols, etc
+ * ELSE
+ *      Use the enum iecm_rx_ptype_l2 to decode the packet type
+ * ENDIF
+ */
+/* macro to make the table lines short */
+#define IECM_PTT(PTYPE, OUTER_IP, OUTER_IP_VER, OUTER_FRAG, T, TE, TEF, I, PL)\
+	{	PTYPE, \
+		1, \
+		IECM_RX_PTYPE_OUTER_##OUTER_IP, \
+		IECM_RX_PTYPE_OUTER_##OUTER_IP_VER, \
+		IECM_RX_PTYPE_##OUTER_FRAG, \
+		IECM_RX_PTYPE_TUNNEL_##T, \
+		IECM_RX_PTYPE_TUNNEL_END_##TE, \
+		IECM_RX_PTYPE_##TEF, \
+		IECM_RX_PTYPE_INNER_PROT_##I, \
+		IECM_RX_PTYPE_PAYLOAD_LAYER_##PL }
+
+#define IECM_PTT_UNUSED_ENTRY(PTYPE) { PTYPE, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
+
+/* shorter macros makes the table fit but are terse */
+#define IECM_RX_PTYPE_NOF		IECM_RX_PTYPE_NOT_FRAG
+#define IECM_RX_PTYPE_FRG		IECM_RX_PTYPE_FRAG
+#define IECM_RX_PTYPE_INNER_PROT_TS	IECM_RX_PTYPE_INNER_PROT_TIMESYNC
+#define IECM_RX_SUPP_PTYPE		18
+#define IECM_RX_MAX_PTYPE		1024
+
+/* Lookup table mapping the HW PTYPE to the bit field for decoding */
+static const
+struct iecm_rx_ptype_decoded iecm_rx_ptype_lkup[IECM_RX_SUPP_PTYPE] = {
+	/* L2 Packet types */
+	IECM_PTT_UNUSED_ENTRY(0),
+	IECM_PTT(1, L2, NONE, NOF, NONE, NONE, NOF, NONE, PAY2),
+	IECM_PTT(11, L2, NONE, NOF, NONE, NONE, NOF, NONE, NONE),
+	IECM_PTT_UNUSED_ENTRY(12),
+
+	/* Non Tunneled IPv4 */
+	IECM_PTT(22, IP, IPV4, FRG, NONE, NONE, NOF, NONE, PAY3),
+	IECM_PTT(23, IP, IPV4, NOF, NONE, NONE, NOF, NONE, PAY3),
+	IECM_PTT(24, IP, IPV4, NOF, NONE, NONE, NOF, UDP,  PAY4),
+	IECM_PTT_UNUSED_ENTRY(25),
+	IECM_PTT(26, IP, IPV4, NOF, NONE, NONE, NOF, TCP,  PAY4),
+	IECM_PTT(27, IP, IPV4, NOF, NONE, NONE, NOF, SCTP, PAY4),
+	IECM_PTT(28, IP, IPV4, NOF, NONE, NONE, NOF, ICMP, PAY4),
+
+	/* Non Tunneled IPv6 */
+	IECM_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
+	IECM_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
+	IECM_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	IECM_PTT_UNUSED_ENTRY(91),
+	IECM_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
+	IECM_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
+	IECM_PTT(94, IP, IPV6, NOF, NONE, NONE, NOF, ICMP, PAY4),
+};
+
+#define IECM_INT_NAME_STR_LEN	(IFNAMSIZ + 16)
+
+enum iecm_queue_flags_t {
+	__IECM_Q_GEN_CHK,
+	__IECM_Q_FLOW_SCH_EN,
+	__IECM_Q_SW_MARKER,
+	__IECM_Q_FLAGS_NBITS,
+};
+
+struct iecm_intr_reg {
+	u32 dyn_ctl;
+	u32 dyn_ctl_intena_m;
+	u32 dyn_ctl_clrpba_m;
+	u32 dyn_ctl_itridx_s;
+	u32 dyn_ctl_itridx_m;
+	u32 dyn_ctl_intrvl_s;
+	u32 itr;
+};
+
+struct iecm_q_vector {
+	struct iecm_vport *vport;
+	cpumask_t affinity_mask;
+	struct napi_struct napi;
+	u16 v_idx;		/* index in the vport->q_vector array */
+	u8 itr_countdown;	/* when 0 should adjust ITR */
+	struct iecm_intr_reg intr_reg;
+	int num_txq;
+	struct iecm_queue **tx;
+	int num_rxq;
+	struct iecm_queue **rx;
+	char name[IECM_INT_NAME_STR_LEN];
+};
+
+struct iecm_rx_queue_stats {
+	u64 packets;
+	u64 bytes;
+	u64 generic_csum;
+	u64 basic_csum;
+	u64 csum_err;
+	u64 hsplit_hbo;
+};
+
+struct iecm_tx_queue_stats {
+	u64 packets;
+	u64 bytes;
+};
+
+union iecm_queue_stats {
+	struct iecm_rx_queue_stats rx;
+	struct iecm_tx_queue_stats tx;
+};
+
+enum iecm_latency_range {
+	IECM_LOWEST_LATENCY = 0,
+	IECM_LOW_LATENCY = 1,
+	IECM_BULK_LATENCY = 2,
+};
+
+struct iecm_itr {
+	u16 current_itr;
+	u16 target_itr;
+	enum virtchnl_itr_idx itr_idx;
+	union iecm_queue_stats stats; /* will reset to 0 when adjusting ITR */
+	enum iecm_latency_range latency_range;
+	unsigned long next_update;	/* jiffies of last ITR update */
+};
+
+/* indices into GLINT_ITR registers */
+#define IECM_ITR_ADAPTIVE_MIN_INC	0x0002
+#define IECM_ITR_ADAPTIVE_MIN_USECS	0x0002
+#define IECM_ITR_ADAPTIVE_MAX_USECS	0x007e
+#define IECM_ITR_ADAPTIVE_LATENCY	0x8000
+#define IECM_ITR_ADAPTIVE_BULK		0x0000
+#define ITR_IS_BULK(x) (!((x) & IECM_ITR_ADAPTIVE_LATENCY))
+
+#define IECM_ITR_DYNAMIC	0X8000	/* use top bit as a flag */
+#define IECM_ITR_MAX		0x1FE0
+#define IECM_ITR_100K		0x000A
+#define IECM_ITR_50K		0x0014
+#define IECM_ITR_20K		0x0032
+#define IECM_ITR_18K		0x003C
+#define IECM_ITR_GRAN_S		1	/* Assume ITR granularity is 2us */
+#define IECM_ITR_MASK		0x1FFE	/* ITR register value alignment mask */
+#define ITR_REG_ALIGN(setting)	__ALIGN_MASK(setting, ~IECM_ITR_MASK)
+#define IECM_ITR_IS_DYNAMIC(setting) (!!((setting) & IECM_ITR_DYNAMIC))
+#define IECM_ITR_SETTING(setting)	((setting) & ~IECM_ITR_DYNAMIC)
+#define ITR_COUNTDOWN_START	100
+#define IECM_ITR_TX_DEF		IECM_ITR_20K
+#define IECM_ITR_RX_DEF		IECM_ITR_50K
+
+/* queue associated with a vport */
+struct iecm_queue {
+	struct device *dev;		/* Used for DMA mapping */
+	struct iecm_vport *vport;	/* Back reference to associated vport */
+	union {
+		struct iecm_txq_group *txq_grp;
+		struct iecm_rxq_group *rxq_grp;
+	};
+	/* bufq: Used as group id, either 0 or 1, on clean Buf Q uses this
+	 *       index to determine which group of refill queues to clean.
+	 *       Bufqs are use in splitq only.
+	 * txq: Index to map between Tx Q group and hot path Tx ptrs stored in
+	 *      vport.  Used in both single Q/split Q.
+	 */
+	u16 idx;
+	/* Used for both Q models single and split. In split Q model relevant
+	 * only to Tx Q and Rx Q
+	 */
+	u8 __iomem *tail;
+	/* Used in both single and split Q.  In single Q, Tx Q uses tx_buf and
+	 * Rx Q uses rx_buf.  In split Q, Tx Q uses tx_buf, Rx Q uses skb, and
+	 * Buf Q uses rx_buf.
+	 */
+	union {
+		struct iecm_tx_buf *tx_buf;
+		struct {
+			struct iecm_rx_buf *buf;
+			struct iecm_rx_buf *hdr_buf;
+		} rx_buf;
+		struct sk_buff *skb;
+	};
+	enum virtchnl_queue_type q_type;
+	/* Queue id(Tx/Tx compl/Rx/Bufq) */
+	u16 q_id;
+	u16 desc_count;		/* Number of descriptors */
+
+	/* Relevant in both split & single Tx Q & Buf Q*/
+	u16 next_to_use;
+	/* In split q model only relevant for Tx Compl Q and Rx Q */
+	u16 next_to_clean;	/* used in interrupt processing */
+	/* Used only for Rx. In split Q model only relevant to Rx Q */
+	u16 next_to_alloc;
+	/* Generation bit check stored, as HW flips the bit at Queue end */
+	DECLARE_BITMAP(flags, __IECM_Q_FLAGS_NBITS);
+
+	union iecm_queue_stats q_stats;
+	struct u64_stats_sync stats_sync;
+
+	enum iecm_rx_hsplit rx_hsplit_en;
+
+	u16 rx_hbuf_size;	/* Header buffer size */
+	u16 rx_buf_size;
+	u16 rx_max_pkt_size;
+	u16 rx_buf_stride;
+	u8 rsc_low_watermark;
+	/* Used for both Q models single and split. In split Q model relevant
+	 * only to Tx compl Q and Rx compl Q
+	 */
+	struct iecm_q_vector *q_vector;	/* Back reference to associated vector */
+	struct iecm_itr itr;
+	unsigned int size;		/* length of descriptor ring in bytes */
+	dma_addr_t dma;			/* physical address of ring */
+	void *desc_ring;		/* Descriptor ring memory */
+
+	struct iecm_buf_lifo buf_stack; /* Stack of empty buffers to store
+					 * buffer info for out of order
+					 * buffer completions
+					 */
+	u16 tx_buf_key;			/* 16 bit unique "identifier" (index)
+					 * to be used as the completion tag when
+					 * queue is using flow based scheduling
+					 */
+	DECLARE_HASHTABLE(sched_buf_hash, 12);
+} ____cacheline_internodealigned_in_smp;
+
+/* Software queues are used in splitq mode to manage buffers between rxq
+ * producer and the bufq consumer.  These are required in order to maintain a
+ * lockless buffer management system and are strictly software only constructs.
+ */
+struct iecm_sw_queue {
+	u16 next_to_clean ____cacheline_aligned_in_smp;
+	u16 next_to_alloc ____cacheline_aligned_in_smp;
+	DECLARE_BITMAP(flags, __IECM_Q_FLAGS_NBITS)
+		____cacheline_aligned_in_smp;
+	u16 *ring ____cacheline_aligned_in_smp;
+	u16 q_entries;
+} ____cacheline_internodealigned_in_smp;
+
+/* Splitq only.  iecm_rxq_set associates an rxq with at most two refillqs.
+ * Each rxq needs a refillq to return used buffers back to the respective bufq.
+ * Bufqs then clean these refillqs for buffers to give to hardware.
+ */
+struct iecm_rxq_set {
+	struct iecm_queue rxq;
+	/* refillqs assoc with bufqX mapped to this rxq */
+	struct iecm_sw_queue *refillq0;
+	struct iecm_sw_queue *refillq1;
+};
+
+/* Splitq only.  iecm_bufq_set associates a bufq to an overflow and array of
+ * refillqs.  In this bufq_set, there will be one refillq for each rxq in this
+ * rxq_group.  Used buffers received by rxqs will be put on refillqs which
+ * bufqs will clean to return new buffers back to hardware.
+ *
+ * Buffers needed by some number of rxqs associated in this rxq_group are
+ * managed by at most two bufqs (depending on performance configuration).
+ */
+struct iecm_bufq_set {
+	struct iecm_queue bufq;
+	struct iecm_sw_queue overflowq;
+	/* This is always equal to num_rxq_sets in idfp_rxq_group */
+	int num_refillqs;
+	struct iecm_sw_queue *refillqs;
+};
+
+/* In singleq mode, an rxq_group is simply an array of rxqs.  In splitq, a
+ * rxq_group contains all the rxqs, bufqs, refillqs, and overflowqs needed to
+ * manage buffers in splitq mode.
+ */
+struct iecm_rxq_group {
+	struct iecm_vport *vport; /* back pointer */
+
+	union {
+		struct {
+			int num_rxq;
+			struct iecm_queue *rxqs;
+		} singleq;
+		struct {
+			int num_rxq_sets;
+			struct iecm_rxq_set *rxq_sets;
+			struct iecm_bufq_set *bufq_sets;
+		} splitq;
+	};
+};
+
+/* Between singleq and splitq, a txq_group is largely the same except for the
+ * complq.  In splitq a single complq is responsible for handling completions
+ * for some number of txqs associated in this txq_group.
+ */
+struct iecm_txq_group {
+	struct iecm_vport *vport; /* back pointer */
+
+	int num_txq;
+	struct iecm_queue *txqs;
+
+	/* splitq only */
+	struct iecm_queue *complq;
+};
+
+int iecm_vport_singleq_napi_poll(struct napi_struct *napi, int budget);
+void iecm_vport_init_num_qs(struct iecm_vport *vport,
+			    struct virtchnl_create_vport *vport_msg);
+void iecm_vport_calc_num_q_desc(struct iecm_vport *vport);
+void iecm_vport_calc_total_qs(struct virtchnl_create_vport *vport_msg,
+			      int num_req_qs);
+void iecm_vport_calc_num_q_groups(struct iecm_vport *vport);
+int iecm_vport_queues_alloc(struct iecm_vport *vport);
+void iecm_vport_queues_rel(struct iecm_vport *vport);
+void iecm_vport_calc_num_q_vec(struct iecm_vport *vport);
+void iecm_vport_intr_dis_irq_all(struct iecm_vport *vport);
+void iecm_vport_intr_clear_dflt_itr(struct iecm_vport *vport);
+void iecm_vport_intr_update_itr_ena_irq(struct iecm_q_vector *q_vector);
+void iecm_vport_intr_deinit(struct iecm_vport *vport);
+int iecm_vport_intr_init(struct iecm_vport *vport);
+irqreturn_t
+iecm_vport_intr_clean_queues(int __always_unused irq, void *data);
+void iecm_vport_intr_ena_irq_all(struct iecm_vport *vport);
+int iecm_config_rss(struct iecm_vport *vport);
+void iecm_get_rx_qid_list(struct iecm_vport *vport, u16 *qid_list);
+void iecm_fill_dflt_rss_lut(struct iecm_vport *vport, u16 *qid_list);
+int iecm_init_rss(struct iecm_vport *vport);
+void iecm_deinit_rss(struct iecm_vport *vport);
+int iecm_config_rss(struct iecm_vport *vport);
+void iecm_rx_reuse_page(struct iecm_queue *rx_bufq, bool hsplit,
+			struct iecm_rx_buf *old_buf);
+void iecm_rx_add_frag(struct iecm_rx_buf *rx_buf, struct sk_buff *skb,
+		      unsigned int size);
+struct sk_buff *iecm_rx_construct_skb(struct iecm_queue *rxq,
+				      struct iecm_rx_buf *rx_buf,
+				      unsigned int size);
+bool iecm_rx_cleanup_headers(struct sk_buff *skb);
+bool iecm_rx_recycle_buf(struct iecm_queue *rx_bufq, bool hsplit,
+			 struct iecm_rx_buf *rx_buf);
+void iecm_rx_skb(struct iecm_queue *rxq, struct sk_buff *skb);
+bool iecm_rx_buf_hw_alloc(struct iecm_queue *rxq, struct iecm_rx_buf *buf);
+void iecm_rx_buf_hw_update(struct iecm_queue *rxq, u32 val);
+void iecm_tx_buf_hw_update(struct iecm_queue *tx_q, u32 val,
+			   struct sk_buff *skb);
+void iecm_tx_buf_rel(struct iecm_queue *tx_q, struct iecm_tx_buf *tx_buf);
+unsigned int iecm_tx_desc_count_required(struct sk_buff *skb);
+int iecm_tx_maybe_stop(struct iecm_queue *tx_q, unsigned int size);
+void iecm_tx_timeout(struct net_device *netdev,
+		     unsigned int __always_unused txqueue);
+netdev_tx_t iecm_tx_splitq_start(struct sk_buff *skb,
+				 struct net_device *netdev);
+netdev_tx_t iecm_tx_singleq_start(struct sk_buff *skb,
+				  struct net_device *netdev);
+bool iecm_rx_singleq_buf_hw_alloc_all(struct iecm_queue *rxq,
+				      u16 cleaned_count);
+void iecm_get_stats64(struct net_device *netdev,
+		      struct rtnl_link_stats64 *stats);
+#endif /* !_IECM_TXRX_H_ */
-- 
2.26.2

