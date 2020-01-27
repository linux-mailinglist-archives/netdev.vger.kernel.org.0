Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 082F414A4F6
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgA0N0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:26:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48930 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbgA0N0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:26:41 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RDQQtX032197;
        Mon, 27 Jan 2020 05:26:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=8S1eUTNPCVHKkxjywDetm+KEUJC2vMz4kQy5huX4hDU=;
 b=iizI9fxmib1vD+hl37O6MFofJ7GyR9tC2PG0sE84rHgba2yrW2qjIdHMpLwt2/yeQeH4
 WfEgzwEamv5DMVBPpkY6Cw0SE6jwJ7EoZLxbJDa/vtCqwVjbDkUA5p8hyIDsSksDUKNm
 CJYa39gjN4McS8DM3kLOrWIgI6bklNXkD3M86bXl+giaSYUArvQnbzG8wux2tNnzfVe+
 aE0l8+nsALTlXPfAY0NthLXLuOEbTpXSOO+r2luy3Phg7itomf1xslZ5oUCS5R8NB9Cx
 1VaWuV3B9hFu2cZm4QT9/Ur2NYPnNYrrsZs0plyxI7ma3NbcrfU9Od1k4ECpx74+OZWO HQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xrp2sxxun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 05:26:39 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jan
 2020 05:26:37 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jan 2020 05:26:37 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id BD5713F7044;
        Mon, 27 Jan 2020 05:26:35 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 net-next 04/13] qed: FW 8.42.2.0 Parser offsets modified
Date:   Mon, 27 Jan 2020 15:26:10 +0200
Message-ID: <20200127132619.27144-5-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200127132619.27144-1-michal.kalderon@marvell.com>
References: <20200127132619.27144-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_02:2020-01-24,2020-01-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert storm ram line to regpair rather than two distinct u32
to better represent the u64 width of the ram.
Convert some defines to be hex instead of negative values
these values also changed by FW from previous value.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    | 51 +++++++++++-----------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index 965529b1a9c5..40b8a52dbfa3 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1000,7 +1000,6 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
 	return true;
 }
 
-
 #define SET_TUNNEL_TYPE_ENABLE_BIT(var, offset, enable) \
 	do { \
 		typeof(var) *__p_var = &(var); \
@@ -1008,8 +1007,9 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
 		*__p_var = (*__p_var & ~BIT(__offset)) | \
 			   ((enable) ? BIT(__offset) : 0); \
 	} while (0)
-#define PRS_ETH_TUNN_OUTPUT_FORMAT        -188897008
-#define PRS_ETH_OUTPUT_FORMAT             -46832
+
+#define PRS_ETH_TUNN_OUTPUT_FORMAT     0xF4DAB910
+#define PRS_ETH_OUTPUT_FORMAT          0xFFFF4910
 
 void qed_set_vxlan_dest_port(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt, u16 dest_port)
@@ -1153,8 +1153,8 @@ void qed_set_geneve_enable(struct qed_hwfn *p_hwfn,
 	       ip_geneve_enable ? 1 : 0);
 }
 
-#define PRS_ETH_VXLAN_NO_L2_ENABLE_OFFSET   4
-#define PRS_ETH_VXLAN_NO_L2_OUTPUT_FORMAT      -927094512
+#define PRS_ETH_VXLAN_NO_L2_ENABLE_OFFSET      3
+#define PRS_ETH_VXLAN_NO_L2_OUTPUT_FORMAT   -925189872
 
 void qed_set_vxlan_no_l2_enable(struct qed_hwfn *p_hwfn,
 				struct qed_ptt *p_ptt, bool enable)
@@ -1219,7 +1219,8 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 		    bool udp,
 		    bool ipv4, bool ipv6, enum gft_profile_type profile_type)
 {
-	u32 reg_val, cam_line, ram_line_lo, ram_line_hi, search_non_ip_as_gft;
+	u32 reg_val, cam_line, search_non_ip_as_gft;
+	struct regpair ram_line = { };
 
 	if (!ipv6 && !ipv4)
 		DP_NOTICE(p_hwfn,
@@ -1285,35 +1286,33 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 	    qed_rd(p_hwfn, p_ptt, PRS_REG_GFT_CAM + CAM_LINE_SIZE * pf_id);
 
 	/* Write line to RAM - compare to filter 4 tuple */
-	ram_line_lo = 0;
-	ram_line_hi = 0;
 
 	/* Search no IP as GFT */
 	search_non_ip_as_gft = 0;
 
 	/* Tunnel type */
-	SET_FIELD(ram_line_lo, GFT_RAM_LINE_TUNNEL_DST_PORT, 1);
-	SET_FIELD(ram_line_lo, GFT_RAM_LINE_TUNNEL_OVER_IP_PROTOCOL, 1);
+	SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_DST_PORT, 1);
+	SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_OVER_IP_PROTOCOL, 1);
 
 	if (profile_type == GFT_PROFILE_TYPE_4_TUPLE) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_DST_IP, 1);
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_SRC_IP, 1);
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_SRC_PORT, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_DST_PORT, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_DST_IP, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_SRC_IP, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_SRC_PORT, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_DST_PORT, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_L4_DST_PORT) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_DST_PORT, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_DST_PORT, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_IP_DST_ADDR) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_DST_IP, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_DST_IP, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_IP_SRC_ADDR) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_SRC_IP, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_SRC_IP, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_TUNNEL_TYPE) {
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_TUNNEL_ETHERTYPE, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_ETHERTYPE, 1);
 
 		/* Allow tunneled traffic without inner IP */
 		search_non_ip_as_gft = 1;
@@ -1324,11 +1323,11 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 	qed_wr(p_hwfn,
 	       p_ptt,
 	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
-	       ram_line_lo);
+	       ram_line.lo);
 	qed_wr(p_hwfn,
 	       p_ptt,
 	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id + REG_SIZE,
-	       ram_line_hi);
+	       ram_line.hi);
 
 	/* Set default profile so that no filter match will happen */
 	qed_wr(p_hwfn,
-- 
2.14.5

