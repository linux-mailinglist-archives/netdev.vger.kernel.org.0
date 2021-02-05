Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982D0311915
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbhBFCya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:54:30 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230380AbhBFCoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:44:23 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MfxAB031246;
        Fri, 5 Feb 2021 14:51:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=uALul4v2+zZsc38DNQaKkgp6b7KEPSQXVyZUjs93Q0w=;
 b=R640Vc3+f2LK4J9P3ZtZnjbI0np4ndvJ0UBtHeOIM4ROPG1Yj1aa5AILF+L0ZRk1AVKH
 v7D6Z44waWtS6y4LW5HyvkGCUxe5aghIQX4sYxUt97X0JPuwayG8clBXRO32Qhh6znJn
 Qa9jxbbQkpQ+srKus2kqbZsyySVH2svEskV1Vx2YNKAlSxo2s/AxHVCcBVxln13Gb0fK
 lWkBgSMWXsOR2m7xJHkrpfxo51u5H1i0bkWPGDo5nv5hHsIiMWfjTNw5cL7NVYU+9hY4
 vJLSMa0zEaOHMZKHZnyCOsDJmjTO8Mq3z21sNdw5LA+U79ZTcqTGD8O78orjXorUqcir Og== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr6ag1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:51:14 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:51:12 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:51:12 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A68233F7043;
        Fri,  5 Feb 2021 14:51:08 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v4 03/14] octeontx2-af: cn10k: Update NIX/NPA context structure
Date:   Sat, 6 Feb 2021 04:20:02 +0530
Message-ID: <20210205225013.15961-4-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIX hardware context structure got changed to accommodate new
features like bandwidth steering, L3/L4 outer/inner checksum
enable/disable etc., on CN10K platform.
This patch defines new mbox message NIX_CN10K_AQ_INST for new
NIX context initialization.

This patch also updates the NPA context structures to accommodate
bit field changes made for CN10K platform.

This patch also removes Big endian bit fields from existing
structures as its support got deprecated in current and upcoming silicons.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  35 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   8 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h | 604 ++++++---------------
 3 files changed, 223 insertions(+), 424 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 5a08f3e..f2b37b3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -241,6 +241,8 @@ M(NIX_BP_ENABLE,	0x8016, nix_bp_enable, nix_bp_cfg_req,	\
 				nix_bp_cfg_rsp)	\
 M(NIX_BP_DISABLE,	0x8017, nix_bp_disable, nix_bp_cfg_req, msg_rsp) \
 M(NIX_GET_MAC_ADDR, 0x8018, nix_get_mac_addr, msg_req, nix_get_mac_addr_rsp) \
+M(NIX_CN10K_AQ_ENQ,	0x8019, nix_cn10k_aq_enq, nix_cn10k_aq_enq_req, \
+				nix_cn10k_aq_enq_rsp)
 
 /* Messages initiated by AF (range 0xC00 - 0xDFF) */
 #define MBOX_UP_CGX_MESSAGES						\
@@ -549,6 +551,39 @@ struct nix_lf_free_req {
 	u64 flags;
 };
 
+/* CN10K NIX AQ enqueue msg */
+struct nix_cn10k_aq_enq_req {
+	struct mbox_msghdr hdr;
+	u32  qidx;
+	u8 ctype;
+	u8 op;
+	union {
+		struct nix_cn10k_rq_ctx_s rq;
+		struct nix_cn10k_sq_ctx_s sq;
+		struct nix_cq_ctx_s cq;
+		struct nix_rsse_s   rss;
+		struct nix_rx_mce_s mce;
+	};
+	union {
+		struct nix_cn10k_rq_ctx_s rq_mask;
+		struct nix_cn10k_sq_ctx_s sq_mask;
+		struct nix_cq_ctx_s cq_mask;
+		struct nix_rsse_s   rss_mask;
+		struct nix_rx_mce_s mce_mask;
+	};
+};
+
+struct nix_cn10k_aq_enq_rsp {
+	struct mbox_msghdr hdr;
+	union {
+		struct nix_cn10k_rq_ctx_s rq;
+		struct nix_cn10k_sq_ctx_s sq;
+		struct nix_cq_ctx_s cq;
+		struct nix_rsse_s   rss;
+		struct nix_rx_mce_s mce;
+	};
+};
+
 /* NIX AQ enqueue msg */
 struct nix_aq_enq_req {
 	struct mbox_msghdr hdr;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index b54753e..46da18d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1000,6 +1000,14 @@ int rvu_mbox_handler_nix_aq_enq(struct rvu *rvu,
 	return rvu_nix_aq_enq_inst(rvu, req, rsp);
 }
 #endif
+/* CN10K mbox handler */
+int rvu_mbox_handler_nix_cn10k_aq_enq(struct rvu *rvu,
+				      struct nix_cn10k_aq_enq_req *req,
+				      struct nix_cn10k_aq_enq_rsp *rsp)
+{
+	return rvu_nix_aq_enq_inst(rvu, (struct nix_aq_enq_req *)req,
+				  (struct nix_aq_enq_rsp *)rsp);
+}
 
 int rvu_mbox_handler_nix_hwctx_disable(struct rvu *rvu,
 				       struct hwctx_disable_req *req,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 5e15f4f..5e5f45c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -139,63 +139,29 @@ enum npa_inpq {
 
 /* NPA admin queue instruction structure */
 struct npa_aq_inst_s {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u64 doneint               : 1;	/* W0 */
-	u64 reserved_44_62        : 19;
-	u64 cindex                : 20;
-	u64 reserved_17_23        : 7;
-	u64 lf                    : 9;
-	u64 ctype                 : 4;
-	u64 op                    : 4;
-#else
-	u64 op                    : 4;
+	u64 op                    : 4; /* W0 */
 	u64 ctype                 : 4;
 	u64 lf                    : 9;
 	u64 reserved_17_23        : 7;
 	u64 cindex                : 20;
 	u64 reserved_44_62        : 19;
 	u64 doneint               : 1;
-#endif
 	u64 res_addr;			/* W1 */
 };
 
 /* NPA admin queue result structure */
 struct npa_aq_res_s {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u64 reserved_17_63        : 47; /* W0 */
-	u64 doneint               : 1;
-	u64 compcode              : 8;
-	u64 ctype                 : 4;
-	u64 op                    : 4;
-#else
-	u64 op                    : 4;
+	u64 op                    : 4; /* W0 */
 	u64 ctype                 : 4;
 	u64 compcode              : 8;
 	u64 doneint               : 1;
 	u64 reserved_17_63        : 47;
-#endif
 	u64 reserved_64_127;		/* W1 */
 };
 
 struct npa_aura_s {
 	u64 pool_addr;			/* W0 */
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W1 */
-	u64 avg_level             : 8;
-	u64 reserved_118_119      : 2;
-	u64 shift                 : 6;
-	u64 aura_drop             : 8;
-	u64 reserved_98_103       : 6;
-	u64 bp_ena                : 2;
-	u64 aura_drop_ena         : 1;
-	u64 pool_drop_ena         : 1;
-	u64 reserved_93           : 1;
-	u64 avg_con               : 9;
-	u64 pool_way_mask         : 16;
-	u64 pool_caching          : 1;
-	u64 reserved_65           : 2;
-	u64 ena                   : 1;
-#else
-	u64 ena                   : 1;
+	u64 ena                   : 1;  /* W1 */
 	u64 reserved_65           : 2;
 	u64 pool_caching          : 1;
 	u64 pool_way_mask         : 16;
@@ -209,59 +175,24 @@ struct npa_aura_s {
 	u64 shift                 : 6;
 	u64 reserved_118_119      : 2;
 	u64 avg_level             : 8;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W2 */
-	u64 reserved_189_191      : 3;
-	u64 nix1_bpid             : 9;
-	u64 reserved_177_179      : 3;
-	u64 nix0_bpid             : 9;
-	u64 reserved_164_167      : 4;
-	u64 count                 : 36;
-#else
-	u64 count                 : 36;
+	u64 count                 : 36; /* W2 */
 	u64 reserved_164_167      : 4;
 	u64 nix0_bpid             : 9;
 	u64 reserved_177_179      : 3;
 	u64 nix1_bpid             : 9;
 	u64 reserved_189_191      : 3;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W3 */
-	u64 reserved_252_255      : 4;
-	u64 fc_hyst_bits          : 4;
-	u64 fc_stype              : 2;
-	u64 fc_up_crossing        : 1;
-	u64 fc_ena                : 1;
-	u64 reserved_240_243      : 4;
-	u64 bp                    : 8;
-	u64 reserved_228_231      : 4;
-	u64 limit                 : 36;
-#else
-	u64 limit                 : 36;
+	u64 limit                 : 36; /* W3 */
 	u64 reserved_228_231      : 4;
 	u64 bp                    : 8;
-	u64 reserved_240_243      : 4;
+	u64 reserved_241_243      : 3;
+	u64 fc_be                 : 1;
 	u64 fc_ena                : 1;
 	u64 fc_up_crossing        : 1;
 	u64 fc_stype              : 2;
 	u64 fc_hyst_bits          : 4;
 	u64 reserved_252_255      : 4;
-#endif
 	u64 fc_addr;			/* W4 */
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W5 */
-	u64 reserved_379_383      : 5;
-	u64 err_qint_idx          : 7;
-	u64 reserved_371          : 1;
-	u64 thresh_qint_idx       : 7;
-	u64 reserved_363          : 1;
-	u64 thresh_up             : 1;
-	u64 thresh_int_ena        : 1;
-	u64 thresh_int            : 1;
-	u64 err_int_ena           : 8;
-	u64 err_int               : 8;
-	u64 update_time           : 16;
-	u64 pool_drop             : 8;
-#else
-	u64 pool_drop             : 8;
+	u64 pool_drop             : 8;  /* W5 */
 	u64 update_time           : 16;
 	u64 err_int               : 8;
 	u64 err_int_ena           : 8;
@@ -273,31 +204,15 @@ struct npa_aura_s {
 	u64 reserved_371          : 1;
 	u64 err_qint_idx          : 7;
 	u64 reserved_379_383      : 5;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W6 */
-	u64 reserved_420_447      : 28;
-	u64 thresh                : 36;
-#else
-	u64 thresh                : 36;
-	u64 reserved_420_447      : 28;
-#endif
+	u64 thresh                : 36; /* W6*/
+	u64 rsvd_423_420          : 4;
+	u64 fc_msh_dst            : 11;
+	u64 reserved_435_447      : 13;
 	u64 reserved_448_511;		/* W7 */
 };
 
 struct npa_pool_s {
 	u64 stack_base;			/* W0 */
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W1 */
-	u64 reserved_115_127      : 13;
-	u64 buf_size              : 11;
-	u64 reserved_100_103      : 4;
-	u64 buf_offset            : 12;
-	u64 stack_way_mask        : 16;
-	u64 reserved_70_71        : 3;
-	u64 stack_caching         : 1;
-	u64 reserved_66_67        : 2;
-	u64 nat_align             : 1;
-	u64 ena                   : 1;
-#else
 	u64 ena                   : 1;
 	u64 nat_align             : 1;
 	u64 reserved_66_67        : 2;
@@ -308,36 +223,10 @@ struct npa_pool_s {
 	u64 reserved_100_103      : 4;
 	u64 buf_size              : 11;
 	u64 reserved_115_127      : 13;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W2 */
-	u64 stack_pages           : 32;
-	u64 stack_max_pages       : 32;
-#else
 	u64 stack_max_pages       : 32;
 	u64 stack_pages           : 32;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W3 */
-	u64 reserved_240_255      : 16;
-	u64 op_pc                 : 48;
-#else
 	u64 op_pc                 : 48;
 	u64 reserved_240_255      : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W4 */
-	u64 reserved_316_319      : 4;
-	u64 update_time           : 16;
-	u64 reserved_297_299      : 3;
-	u64 fc_up_crossing        : 1;
-	u64 fc_hyst_bits          : 4;
-	u64 fc_stype              : 2;
-	u64 fc_ena                : 1;
-	u64 avg_con               : 9;
-	u64 avg_level             : 8;
-	u64 reserved_270_271      : 2;
-	u64 shift                 : 6;
-	u64 reserved_260_263      : 4;
-	u64 stack_offset          : 4;
-#else
 	u64 stack_offset          : 4;
 	u64 reserved_260_263      : 4;
 	u64 shift                 : 6;
@@ -348,26 +237,13 @@ struct npa_pool_s {
 	u64 fc_stype              : 2;
 	u64 fc_hyst_bits          : 4;
 	u64 fc_up_crossing        : 1;
-	u64 reserved_297_299      : 3;
+	u64 fc_be		  : 1;
+	u64 reserved_298_299      : 2;
 	u64 update_time           : 16;
 	u64 reserved_316_319      : 4;
-#endif
 	u64 fc_addr;			/* W5 */
 	u64 ptr_start;			/* W6 */
 	u64 ptr_end;			/* W7 */
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W8 */
-	u64 reserved_571_575      : 5;
-	u64 err_qint_idx          : 7;
-	u64 reserved_563          : 1;
-	u64 thresh_qint_idx       : 7;
-	u64 reserved_555          : 1;
-	u64 thresh_up             : 1;
-	u64 thresh_int_ena        : 1;
-	u64 thresh_int            : 1;
-	u64 err_int_ena           : 8;
-	u64 err_int               : 8;
-	u64 reserved_512_535      : 24;
-#else
 	u64 reserved_512_535      : 24;
 	u64 err_int               : 8;
 	u64 err_int_ena           : 8;
@@ -379,14 +255,10 @@ struct npa_pool_s {
 	u64 reserved_563          : 1;
 	u64 err_qint_idx          : 7;
 	u64 reserved_571_575      : 5;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W9 */
-	u64 reserved_612_639      : 28;
 	u64 thresh                : 36;
-#else
-	u64 thresh                : 36;
-	u64 reserved_612_639      : 28;
-#endif
+	u64 rsvd_615_612	  : 4;
+	u64 fc_msh_dst		  : 11;
+	u64 reserved_627_639      : 13;
 	u64 reserved_640_703;		/* W10 */
 	u64 reserved_704_767;		/* W11 */
 	u64 reserved_768_831;		/* W12 */
@@ -414,6 +286,7 @@ enum nix_aq_ctype {
 	NIX_AQ_CTYPE_MCE  = 0x3,
 	NIX_AQ_CTYPE_RSS  = 0x4,
 	NIX_AQ_CTYPE_DYNO = 0x5,
+	NIX_AQ_CTYPE_BAND_PROF = 0x6,
 };
 
 /* NIX admin queue instruction opcodes */
@@ -428,59 +301,29 @@ enum nix_aq_instop {
 
 /* NIX admin queue instruction structure */
 struct nix_aq_inst_s {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u64 doneint		: 1;	/* W0 */
-	u64 reserved_44_62	: 19;
-	u64 cindex		: 20;
-	u64 reserved_15_23	: 9;
-	u64 lf			: 7;
-	u64 ctype		: 4;
-	u64 op			: 4;
-#else
 	u64 op			: 4;
 	u64 ctype		: 4;
-	u64 lf			: 7;
-	u64 reserved_15_23	: 9;
+	u64 lf			: 9;
+	u64 reserved_17_23	: 7;
 	u64 cindex		: 20;
 	u64 reserved_44_62	: 19;
 	u64 doneint		: 1;
-#endif
 	u64 res_addr;			/* W1 */
 };
 
 /* NIX admin queue result structure */
 struct nix_aq_res_s {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u64 reserved_17_63	: 47;	/* W0 */
-	u64 doneint		: 1;
-	u64 compcode		: 8;
-	u64 ctype		: 4;
-	u64 op			: 4;
-#else
 	u64 op			: 4;
 	u64 ctype		: 4;
 	u64 compcode		: 8;
 	u64 doneint		: 1;
 	u64 reserved_17_63	: 47;
-#endif
 	u64 reserved_64_127;		/* W1 */
 };
 
 /* NIX Completion queue context structure */
 struct nix_cq_ctx_s {
 	u64 base;
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W1 */
-	u64 wrptr		: 20;
-	u64 avg_con		: 9;
-	u64 cint_idx		: 7;
-	u64 cq_err		: 1;
-	u64 qint_idx		: 7;
-	u64 rsvd_81_83		: 3;
-	u64 bpid		: 9;
-	u64 rsvd_69_71		: 3;
-	u64 bp_ena		: 1;
-	u64 rsvd_64_67		: 4;
-#else
 	u64 rsvd_64_67		: 4;
 	u64 bp_ena		: 1;
 	u64 rsvd_69_71		: 3;
@@ -491,31 +334,10 @@ struct nix_cq_ctx_s {
 	u64 cint_idx		: 7;
 	u64 avg_con		: 9;
 	u64 wrptr		: 20;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W2 */
-	u64 update_time		: 16;
-	u64 avg_level		: 8;
-	u64 head		: 20;
-	u64 tail		: 20;
-#else
 	u64 tail		: 20;
 	u64 head		: 20;
 	u64 avg_level		: 8;
 	u64 update_time		: 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W3 */
-	u64 cq_err_int_ena	: 8;
-	u64 cq_err_int		: 8;
-	u64 qsize		: 4;
-	u64 rsvd_233_235	: 3;
-	u64 caching		: 1;
-	u64 substream		: 20;
-	u64 rsvd_210_211	: 2;
-	u64 ena			: 1;
-	u64 drop_ena		: 1;
-	u64 drop		: 8;
-	u64 bp			: 8;
-#else
 	u64 bp			: 8;
 	u64 drop		: 8;
 	u64 drop_ena		: 1;
@@ -527,20 +349,161 @@ struct nix_cq_ctx_s {
 	u64 qsize		: 4;
 	u64 cq_err_int		: 8;
 	u64 cq_err_int_ena	: 8;
-#endif
+};
+
+/* CN10K NIX Receive queue context structure */
+struct nix_cn10k_rq_ctx_s {
+	u64 ena			: 1;
+	u64 sso_ena		: 1;
+	u64 ipsech_ena		: 1;
+	u64 ena_wqwd		: 1;
+	u64 cq			: 20;
+	u64 rsvd_36_24		: 13;
+	u64 lenerr_dis		: 1;
+	u64 csum_il4_dis	: 1;
+	u64 csum_ol4_dis	: 1;
+	u64 len_il4_dis		: 1;
+	u64 len_il3_dis		: 1;
+	u64 len_ol4_dis		: 1;
+	u64 len_ol3_dis		: 1;
+	u64 wqe_aura		: 20;
+	u64 spb_aura		: 20;
+	u64 lpb_aura		: 20;
+	u64 sso_grp		: 10;
+	u64 sso_tt		: 2;
+	u64 pb_caching		: 2;
+	u64 wqe_caching		: 1;
+	u64 xqe_drop_ena	: 1;
+	u64 spb_drop_ena	: 1;
+	u64 lpb_drop_ena	: 1;
+	u64 pb_stashing		: 1;
+	u64 ipsecd_drop_ena	: 1;
+	u64 chi_ena		: 1;
+	u64 rsvd_127_125	: 3;
+	u64 band_prof_id	: 10; /* W2 */
+	u64 rsvd_138		: 1;
+	u64 policer_ena		: 1;
+	u64 spb_sizem1		: 6;
+	u64 wqe_skip		: 2;
+	u64 rsvd_150_148	: 3;
+	u64 spb_ena		: 1;
+	u64 lpb_sizem1		: 12;
+	u64 first_skip		: 7;
+	u64 rsvd_171		: 1;
+	u64 later_skip		: 6;
+	u64 xqe_imm_size	: 6;
+	u64 rsvd_189_184	: 6;
+	u64 xqe_imm_copy	: 1;
+	u64 xqe_hdr_split	: 1;
+	u64 xqe_drop		: 8; /* W3 */
+	u64 xqe_pass		: 8;
+	u64 wqe_pool_drop	: 8;
+	u64 wqe_pool_pass	: 8;
+	u64 spb_aura_drop	: 8;
+	u64 spb_aura_pass	: 8;
+	u64 spb_pool_drop	: 8;
+	u64 spb_pool_pass	: 8;
+	u64 lpb_aura_drop	: 8; /* W4 */
+	u64 lpb_aura_pass	: 8;
+	u64 lpb_pool_drop	: 8;
+	u64 lpb_pool_pass	: 8;
+	u64 rsvd_291_288	: 4;
+	u64 rq_int		: 8;
+	u64 rq_int_ena		: 8;
+	u64 qint_idx		: 7;
+	u64 rsvd_319_315	: 5;
+	u64 ltag		: 24; /* W5 */
+	u64 good_utag		: 8;
+	u64 bad_utag		: 8;
+	u64 flow_tagw		: 6;
+	u64 ipsec_vwqe		: 1;
+	u64 vwqe_ena		: 1;
+	u64 vwqe_wait		: 8;
+	u64 max_vsize_exp	: 4;
+	u64 vwqe_skip		: 2;
+	u64 rsvd_383_382	: 2;
+	u64 octs		: 48; /* W6 */
+	u64 rsvd_447_432	: 16;
+	u64 pkts		: 48; /* W7 */
+	u64 rsvd_511_496	: 16;
+	u64 drop_octs		: 48; /* W8 */
+	u64 rsvd_575_560	: 16;
+	u64 drop_pkts		: 48; /* W9 */
+	u64 rsvd_639_624	: 16;
+	u64 re_pkts		: 48; /* W10 */
+	u64 rsvd_703_688	: 16;
+	u64 rsvd_767_704;		/* W11 */
+	u64 rsvd_831_768;		/* W12 */
+	u64 rsvd_895_832;		/* W13 */
+	u64 rsvd_959_896;		/* W14 */
+	u64 rsvd_1023_960;		/* W15 */
+};
+
+/* CN10K NIX Send queue context structure */
+struct nix_cn10k_sq_ctx_s {
+	u64 ena                   : 1;
+	u64 qint_idx              : 6;
+	u64 substream             : 20;
+	u64 sdp_mcast             : 1;
+	u64 cq                    : 20;
+	u64 sqe_way_mask          : 16;
+	u64 smq                   : 10; /* W1 */
+	u64 cq_ena                : 1;
+	u64 xoff                  : 1;
+	u64 sso_ena               : 1;
+	u64 smq_rr_weight         : 14;
+	u64 default_chan          : 12;
+	u64 sqb_count             : 16;
+	u64 rsvd_120_119          : 2;
+	u64 smq_rr_count_lb       : 7;
+	u64 smq_rr_count_ub       : 25; /* W2 */
+	u64 sqb_aura              : 20;
+	u64 sq_int                : 8;
+	u64 sq_int_ena            : 8;
+	u64 sqe_stype             : 2;
+	u64 rsvd_191              : 1;
+	u64 max_sqe_size          : 2; /* W3 */
+	u64 cq_limit              : 8;
+	u64 lmt_dis               : 1;
+	u64 mnq_dis               : 1;
+	u64 smq_next_sq           : 20;
+	u64 smq_lso_segnum        : 8;
+	u64 tail_offset           : 6;
+	u64 smenq_offset          : 6;
+	u64 head_offset           : 6;
+	u64 smenq_next_sqb_vld    : 1;
+	u64 smq_pend              : 1;
+	u64 smq_next_sq_vld       : 1;
+	u64 rsvd_255_253          : 3;
+	u64 next_sqb              : 64; /* W4 */
+	u64 tail_sqb              : 64; /* W5 */
+	u64 smenq_sqb             : 64; /* W6 */
+	u64 smenq_next_sqb        : 64; /* W7 */
+	u64 head_sqb              : 64; /* W8 */
+	u64 rsvd_583_576          : 8;  /* W9 */
+	u64 vfi_lso_total         : 18;
+	u64 vfi_lso_sizem1        : 3;
+	u64 vfi_lso_sb            : 8;
+	u64 vfi_lso_mps           : 14;
+	u64 vfi_lso_vlan0_ins_ena : 1;
+	u64 vfi_lso_vlan1_ins_ena : 1;
+	u64 vfi_lso_vld           : 1;
+	u64 rsvd_639_630          : 10;
+	u64 scm_lso_rem           : 18; /* W10 */
+	u64 rsvd_703_658          : 46;
+	u64 octs                  : 48; /* W11 */
+	u64 rsvd_767_752          : 16;
+	u64 pkts                  : 48; /* W12 */
+	u64 rsvd_831_816          : 16;
+	u64 rsvd_895_832          : 64; /* W13 */
+	u64 dropped_octs          : 48;
+	u64 rsvd_959_944          : 16;
+	u64 dropped_pkts          : 48;
+	u64 rsvd_1023_1008        : 16;
 };
 
 /* NIX Receive queue context structure */
 struct nix_rq_ctx_s {
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W0 */
-	u64 wqe_aura      : 20;
-	u64 substream     : 20;
-	u64 cq            : 20;
-	u64 ena_wqwd      : 1;
-	u64 ipsech_ena    : 1;
-	u64 sso_ena       : 1;
-	u64 ena           : 1;
-#else
 	u64 ena           : 1;
 	u64 sso_ena       : 1;
 	u64 ipsech_ena    : 1;
@@ -548,19 +511,6 @@ struct nix_rq_ctx_s {
 	u64 cq            : 20;
 	u64 substream     : 20;
 	u64 wqe_aura      : 20;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W1 */
-	u64 rsvd_127_122  : 6;
-	u64 lpb_drop_ena  : 1;
-	u64 spb_drop_ena  : 1;
-	u64 xqe_drop_ena  : 1;
-	u64 wqe_caching   : 1;
-	u64 pb_caching    : 2;
-	u64 sso_tt        : 2;
-	u64 sso_grp       : 10;
-	u64 lpb_aura      : 20;
-	u64 spb_aura      : 20;
-#else
 	u64 spb_aura      : 20;
 	u64 lpb_aura      : 20;
 	u64 sso_grp       : 10;
@@ -571,23 +521,7 @@ struct nix_rq_ctx_s {
 	u64 spb_drop_ena  : 1;
 	u64 lpb_drop_ena  : 1;
 	u64 rsvd_127_122  : 6;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W2 */
-	u64 xqe_hdr_split : 1;
-	u64 xqe_imm_copy  : 1;
-	u64 rsvd_189_184  : 6;
-	u64 xqe_imm_size  : 6;
-	u64 later_skip    : 6;
-	u64 rsvd_171      : 1;
-	u64 first_skip    : 7;
-	u64 lpb_sizem1    : 12;
-	u64 spb_ena       : 1;
-	u64 rsvd_150_148  : 3;
-	u64 wqe_skip      : 2;
-	u64 spb_sizem1    : 6;
-	u64 rsvd_139_128  : 12;
-#else
-	u64 rsvd_139_128  : 12;
+	u64 rsvd_139_128  : 12; /* W2 */
 	u64 spb_sizem1    : 6;
 	u64 wqe_skip      : 2;
 	u64 rsvd_150_148  : 3;
@@ -600,18 +534,7 @@ struct nix_rq_ctx_s {
 	u64 rsvd_189_184  : 6;
 	u64 xqe_imm_copy  : 1;
 	u64 xqe_hdr_split : 1;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W3 */
-	u64 spb_pool_pass : 8;
-	u64 spb_pool_drop : 8;
-	u64 spb_aura_pass : 8;
-	u64 spb_aura_drop : 8;
-	u64 wqe_pool_pass : 8;
-	u64 wqe_pool_drop : 8;
-	u64 xqe_pass      : 8;
-	u64 xqe_drop      : 8;
-#else
-	u64 xqe_drop      : 8;
+	u64 xqe_drop      : 8; /* W3*/
 	u64 xqe_pass      : 8;
 	u64 wqe_pool_drop : 8;
 	u64 wqe_pool_pass : 8;
@@ -619,19 +542,7 @@ struct nix_rq_ctx_s {
 	u64 spb_aura_pass : 8;
 	u64 spb_pool_drop : 8;
 	u64 spb_pool_pass : 8;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W4 */
-	u64 rsvd_319_315  : 5;
-	u64 qint_idx      : 7;
-	u64 rq_int_ena    : 8;
-	u64 rq_int        : 8;
-	u64 rsvd_291_288  : 4;
-	u64 lpb_pool_pass : 8;
-	u64 lpb_pool_drop : 8;
-	u64 lpb_aura_pass : 8;
-	u64 lpb_aura_drop : 8;
-#else
-	u64 lpb_aura_drop : 8;
+	u64 lpb_aura_drop : 8; /* W4 */
 	u64 lpb_aura_pass : 8;
 	u64 lpb_pool_drop : 8;
 	u64 lpb_pool_pass : 8;
@@ -640,55 +551,21 @@ struct nix_rq_ctx_s {
 	u64 rq_int_ena    : 8;
 	u64 qint_idx      : 7;
 	u64 rsvd_319_315  : 5;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W5 */
-	u64 rsvd_383_366  : 18;
-	u64 flow_tagw     : 6;
-	u64 bad_utag      : 8;
-	u64 good_utag     : 8;
-	u64 ltag          : 24;
-#else
-	u64 ltag          : 24;
+	u64 ltag          : 24; /* W5 */
 	u64 good_utag     : 8;
 	u64 bad_utag      : 8;
 	u64 flow_tagw     : 6;
 	u64 rsvd_383_366  : 18;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W6 */
-	u64 rsvd_447_432  : 16;
-	u64 octs          : 48;
-#else
-	u64 octs          : 48;
+	u64 octs          : 48; /* W6 */
 	u64 rsvd_447_432  : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W7 */
-	u64 rsvd_511_496  : 16;
-	u64 pkts          : 48;
-#else
-	u64 pkts          : 48;
+	u64 pkts          : 48; /* W7 */
 	u64 rsvd_511_496  : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W8 */
+	u64 drop_octs     : 48; /* W8 */
 	u64 rsvd_575_560  : 16;
-	u64 drop_octs     : 48;
-#else
-	u64 drop_octs     : 48;
-	u64 rsvd_575_560  : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W9 */
-	u64 rsvd_639_624  : 16;
-	u64 drop_pkts     : 48;
-#else
-	u64 drop_pkts     : 48;
+	u64 drop_pkts     : 48; /* W9 */
 	u64 rsvd_639_624  : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)	/* W10 */
+	u64 re_pkts       : 48; /* W10 */
 	u64 rsvd_703_688  : 16;
-	u64 re_pkts       : 48;
-#else
-	u64 re_pkts       : 48;
-	u64 rsvd_703_688  : 16;
-#endif
 	u64 rsvd_767_704;		/* W11 */
 	u64 rsvd_831_768;		/* W12 */
 	u64 rsvd_895_832;		/* W13 */
@@ -711,30 +588,12 @@ enum nix_stype {
 
 /* NIX Send queue context structure */
 struct nix_sq_ctx_s {
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W0 */
-	u64 sqe_way_mask          : 16;
-	u64 cq                    : 20;
-	u64 sdp_mcast             : 1;
-	u64 substream             : 20;
-	u64 qint_idx              : 6;
-	u64 ena                   : 1;
-#else
 	u64 ena                   : 1;
 	u64 qint_idx              : 6;
 	u64 substream             : 20;
 	u64 sdp_mcast             : 1;
 	u64 cq                    : 20;
 	u64 sqe_way_mask          : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W1 */
-	u64 sqb_count             : 16;
-	u64 default_chan          : 12;
-	u64 smq_rr_quantum        : 24;
-	u64 sso_ena               : 1;
-	u64 xoff                  : 1;
-	u64 cq_ena                : 1;
-	u64 smq                   : 9;
-#else
 	u64 smq                   : 9;
 	u64 cq_ena                : 1;
 	u64 xoff                  : 1;
@@ -742,37 +601,12 @@ struct nix_sq_ctx_s {
 	u64 smq_rr_quantum        : 24;
 	u64 default_chan          : 12;
 	u64 sqb_count             : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W2 */
-	u64 rsvd_191              : 1;
-	u64 sqe_stype             : 2;
-	u64 sq_int_ena            : 8;
-	u64 sq_int                : 8;
-	u64 sqb_aura              : 20;
-	u64 smq_rr_count          : 25;
-#else
 	u64 smq_rr_count          : 25;
 	u64 sqb_aura              : 20;
 	u64 sq_int                : 8;
 	u64 sq_int_ena            : 8;
 	u64 sqe_stype             : 2;
 	u64 rsvd_191              : 1;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W3 */
-	u64 rsvd_255_253          : 3;
-	u64 smq_next_sq_vld       : 1;
-	u64 smq_pend              : 1;
-	u64 smenq_next_sqb_vld    : 1;
-	u64 head_offset           : 6;
-	u64 smenq_offset          : 6;
-	u64 tail_offset           : 6;
-	u64 smq_lso_segnum        : 8;
-	u64 smq_next_sq           : 20;
-	u64 mnq_dis               : 1;
-	u64 lmt_dis               : 1;
-	u64 cq_limit              : 8;
-	u64 max_sqe_size          : 2;
-#else
 	u64 max_sqe_size          : 2;
 	u64 cq_limit              : 8;
 	u64 lmt_dis               : 1;
@@ -786,23 +620,11 @@ struct nix_sq_ctx_s {
 	u64 smq_pend              : 1;
 	u64 smq_next_sq_vld       : 1;
 	u64 rsvd_255_253          : 3;
-#endif
 	u64 next_sqb              : 64;/* W4 */
 	u64 tail_sqb              : 64;/* W5 */
 	u64 smenq_sqb             : 64;/* W6 */
 	u64 smenq_next_sqb        : 64;/* W7 */
 	u64 head_sqb              : 64;/* W8 */
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W9 */
-	u64 rsvd_639_630          : 10;
-	u64 vfi_lso_vld           : 1;
-	u64 vfi_lso_vlan1_ins_ena : 1;
-	u64 vfi_lso_vlan0_ins_ena : 1;
-	u64 vfi_lso_mps           : 14;
-	u64 vfi_lso_sb            : 8;
-	u64 vfi_lso_sizem1        : 3;
-	u64 vfi_lso_total         : 18;
-	u64 rsvd_583_576          : 8;
-#else
 	u64 rsvd_583_576          : 8;
 	u64 vfi_lso_total         : 18;
 	u64 vfi_lso_sizem1        : 3;
@@ -812,68 +634,28 @@ struct nix_sq_ctx_s {
 	u64 vfi_lso_vlan1_ins_ena : 1;
 	u64 vfi_lso_vld           : 1;
 	u64 rsvd_639_630          : 10;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD) /* W10 */
-	u64 rsvd_703_658          : 46;
-	u64 scm_lso_rem           : 18;
-#else
 	u64 scm_lso_rem           : 18;
 	u64 rsvd_703_658          : 46;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD) /* W11 */
-	u64 rsvd_767_752          : 16;
-	u64 octs                  : 48;
-#else
 	u64 octs                  : 48;
 	u64 rsvd_767_752          : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD) /* W12 */
-	u64 rsvd_831_816          : 16;
-	u64 pkts                  : 48;
-#else
 	u64 pkts                  : 48;
 	u64 rsvd_831_816          : 16;
-#endif
 	u64 rsvd_895_832          : 64;/* W13 */
-#if defined(__BIG_ENDIAN_BITFIELD) /* W14 */
-	u64 rsvd_959_944          : 16;
-	u64 dropped_octs          : 48;
-#else
 	u64 dropped_octs          : 48;
 	u64 rsvd_959_944          : 16;
-#endif
-#if defined(__BIG_ENDIAN_BITFIELD) /* W15 */
-	u64 rsvd_1023_1008        : 16;
-	u64 dropped_pkts          : 48;
-#else
 	u64 dropped_pkts          : 48;
 	u64 rsvd_1023_1008        : 16;
-#endif
 };
 
 /* NIX Receive side scaling entry structure*/
 struct nix_rsse_s {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	uint32_t reserved_20_31		: 12;
-	uint32_t rq			: 20;
-#else
 	uint32_t rq			: 20;
 	uint32_t reserved_20_31		: 12;
 
-#endif
 };
 
 /* NIX receive multicast/mirror entry structure */
 struct nix_rx_mce_s {
-#if defined(__BIG_ENDIAN_BITFIELD)  /* W0 */
-	uint64_t next       : 16;
-	uint64_t pf_func    : 16;
-	uint64_t rsvd_31_24 : 8;
-	uint64_t index      : 20;
-	uint64_t eol        : 1;
-	uint64_t rsvd_2     : 1;
-	uint64_t op         : 2;
-#else
 	uint64_t op         : 2;
 	uint64_t rsvd_2     : 1;
 	uint64_t eol        : 1;
@@ -881,7 +663,6 @@ struct nix_rx_mce_s {
 	uint64_t rsvd_31_24 : 8;
 	uint64_t pf_func    : 16;
 	uint64_t next       : 16;
-#endif
 };
 
 enum nix_lsoalg {
@@ -900,15 +681,6 @@ enum nix_txlayer {
 };
 
 struct nix_lso_format {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u64 rsvd_19_63		: 45;
-	u64 alg			: 3;
-	u64 rsvd_14_15		: 2;
-	u64 sizem1		: 2;
-	u64 rsvd_10_11		: 2;
-	u64 layer		: 2;
-	u64 offset		: 8;
-#else
 	u64 offset		: 8;
 	u64 layer		: 2;
 	u64 rsvd_10_11		: 2;
@@ -916,24 +688,9 @@ struct nix_lso_format {
 	u64 rsvd_14_15		: 2;
 	u64 alg			: 3;
 	u64 rsvd_19_63		: 45;
-#endif
 };
 
 struct nix_rx_flowkey_alg {
-#if defined(__BIG_ENDIAN_BITFIELD)
-	u64 reserved_35_63	:29;
-	u64 ltype_match		:4;
-	u64 ltype_mask		:4;
-	u64 sel_chan		:1;
-	u64 ena			:1;
-	u64 reserved_24_24	:1;
-	u64 lid			:3;
-	u64 bytesm1		:5;
-	u64 hdr_offset		:8;
-	u64 fn_mask		:1;
-	u64 ln_mask		:1;
-	u64 key_offset		:6;
-#else
 	u64 key_offset		:6;
 	u64 ln_mask		:1;
 	u64 fn_mask		:1;
@@ -946,7 +703,6 @@ struct nix_rx_flowkey_alg {
 	u64 ltype_mask		:4;
 	u64 ltype_match		:4;
 	u64 reserved_35_63	:29;
-#endif
 };
 
 /* NIX VTAG size */
-- 
2.7.4

