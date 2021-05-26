Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D59391E04
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhEZRY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:24:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:18184 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234461AbhEZRYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:24:12 -0400
IronPort-SDR: AJ4df8Ur6HbBBUNSjKNbQxyM02ZRhmpCvU2VieLDi1ZRolNtAe6ILCSglqMpU+jl9NB8Ta6ZgJ
 H2eUF8Mfsn9A==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="266415792"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="266415792"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 10:21:27 -0700
IronPort-SDR: vI6lLBhmgu+vxUr5vPuixu1MKztuQ0Y+6Eo4jDlXf0khGIopyUs4RCgKaF3uAM5sao/oD8MXdI
 It6dnWAeJ9Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="443149225"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 26 May 2021 10:21:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 09/11] igbvf: convert to strongly typed descriptors
Date:   Wed, 26 May 2021 10:23:44 -0700
Message-Id: <20210526172346.3515587-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The igbvf driver for some reason never strongly typed it's descriptor
formats. Make this driver like the rest of the Intel drivers and use
__le* for our little endian descriptors.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
Warning Detail
.../igbvf/netdev.c:203:48: warning: incorrect type in assignment (different base types)
.../igbvf/netdev.c:203:48:    expected unsigned long long [usertype] pkt_addr
.../igbvf/netdev.c:203:48:    got restricted __le64 [usertype]
.../igbvf/netdev.c:205:48: warning: incorrect type in assignment (different base types)
.../igbvf/netdev.c:205:48:    expected unsigned long long [usertype] hdr_addr
.../igbvf/netdev.c:205:48:    got restricted __le64 [usertype]
.../igbvf/netdev.c:207:48: warning: incorrect type in assignment (different base types)
.../igbvf/netdev.c:207:48:    expected unsigned long long [usertype] pkt_addr
.../igbvf/netdev.c:207:48:    got restricted __le64 [usertype]
.../igbvf/netdev.c:261:19: warning: cast to restricted __le32
.../igbvf/netdev.c:276:25: warning: cast to restricted __le16
.../igbvf/netdev.c:282:26: warning: cast to restricted __le16
.../igbvf/netdev.c:356:52: warning: incorrect type in argument 5 (different base types)
.../igbvf/netdev.c:356:52:    expected restricted __le16 [usertype] vlan
.../igbvf/netdev.c:356:52:    got unsigned short [usertype] vlan
.../igbvf/netdev.c:371:27: warning: cast to restricted __le32
.../igbvf/netdev.c:797:45: warning: restricted __le32 degrades to integer
---
 drivers/net/ethernet/intel/igbvf/vf.h | 42 +++++++++++++--------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/vf.h b/drivers/net/ethernet/intel/igbvf/vf.h
index c71b0d7dbcee..ba9bb3132d5d 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.h
+++ b/drivers/net/ethernet/intel/igbvf/vf.h
@@ -35,31 +35,31 @@ struct e1000_hw;
 /* Receive Descriptor - Advanced */
 union e1000_adv_rx_desc {
 	struct {
-		u64 pkt_addr; /* Packet buffer address */
-		u64 hdr_addr; /* Header buffer address */
+		__le64 pkt_addr; /* Packet buffer address */
+		__le64 hdr_addr; /* Header buffer address */
 	} read;
 	struct {
 		struct {
 			union {
-				u32 data;
+				__le32 data;
 				struct {
-					u16 pkt_info; /* RSS/Packet type */
+					__le16 pkt_info; /* RSS/Packet type */
 					/* Split Header, hdr buffer length */
-					u16 hdr_info;
+					__le16 hdr_info;
 				} hs_rss;
 			} lo_dword;
 			union {
-				u32 rss; /* RSS Hash */
+				__le32 rss; /* RSS Hash */
 				struct {
-					u16 ip_id; /* IP id */
-					u16 csum;  /* Packet Checksum */
+					__le16 ip_id; /* IP id */
+					__le16 csum;  /* Packet Checksum */
 				} csum_ip;
 			} hi_dword;
 		} lower;
 		struct {
-			u32 status_error; /* ext status/error */
-			u16 length; /* Packet length */
-			u16 vlan;   /* VLAN tag */
+			__le32 status_error; /* ext status/error */
+			__le16 length; /* Packet length */
+			__le16 vlan; /* VLAN tag */
 		} upper;
 	} wb;  /* writeback */
 };
@@ -70,14 +70,14 @@ union e1000_adv_rx_desc {
 /* Transmit Descriptor - Advanced */
 union e1000_adv_tx_desc {
 	struct {
-		u64 buffer_addr; /* Address of descriptor's data buf */
-		u32 cmd_type_len;
-		u32 olinfo_status;
+		__le64 buffer_addr; /* Address of descriptor's data buf */
+		__le32 cmd_type_len;
+		__le32 olinfo_status;
 	} read;
 	struct {
-		u64 rsvd; /* Reserved */
-		u32 nxtseq_seed;
-		u32 status;
+		__le64 rsvd; /* Reserved */
+		__le32 nxtseq_seed;
+		__le32 status;
 	} wb;
 };
 
@@ -94,10 +94,10 @@ union e1000_adv_tx_desc {
 
 /* Context descriptors */
 struct e1000_adv_tx_context_desc {
-	u32 vlan_macip_lens;
-	u32 seqnum_seed;
-	u32 type_tucmd_mlhl;
-	u32 mss_l4len_idx;
+	__le32 vlan_macip_lens;
+	__le32 seqnum_seed;
+	__le32 type_tucmd_mlhl;
+	__le32 mss_l4len_idx;
 };
 
 #define E1000_ADVTXD_MACLEN_SHIFT	9  /* Adv ctxt desc mac len shift */
-- 
2.26.2

