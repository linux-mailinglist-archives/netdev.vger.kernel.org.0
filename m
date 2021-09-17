Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C78D40FC76
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240759AbhIQPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:34:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240270AbhIQPeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:34:11 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HEsZO0012143;
        Fri, 17 Sep 2021 11:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mFUnr3IgX2BF4LuAYMripxxZ4UCMpantQuIamB1lfSQ=;
 b=EfIyQTlXh8Vq9e1T4gv28/vwTAiUI4M1VJBsUHkYBvAJA0us+6/l1cjkXIzdmdrQBTPm
 JULPeWuS04qOFd470fUpFkFt/ikZmfkn8DfyiY5GK28N2Ah5UZbOXYUeSMiu2Dj+GHhS
 g49FsLcTKBkqtH8t4LkY+2eRZWUfng/74G87smZH+ct9lVyHzhGhl30dLz07pmnKv9VQ
 Nuujc1ZBGhnkp2LZ/LTvW+2vNIXXnhasvgDyKAfEkdvWqz2gcTRtZewYNuiu63NyIQzf
 pBI1+05zswhK18CQsFFxCllD1SoVFivthCpXP72ufcO9maBD7qDNPmpvkVRgvOpqUBro TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4vu5hgt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:57 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HFD4N1033360;
        Fri, 17 Sep 2021 11:31:56 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4vu5hgs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:56 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFH5xw025470;
        Fri, 17 Sep 2021 15:31:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b0kqkp2jk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:31:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFRBYC57999762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:27:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12A6B11C074;
        Fri, 17 Sep 2021 15:31:50 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB77511C04C;
        Fri, 17 Sep 2021 15:31:44 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:31:44 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v2 3/8] bpf powerpc: refactor JIT compiler code
Date:   Fri, 17 Sep 2021 21:00:42 +0530
Message-Id: <20210917153047.177141-4-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917153047.177141-1-hbathini@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ywbi6zR_IqS9W8QcKRR_TABaMlat1m3G
X-Proofpoint-GUID: W1ltpOqoQ8Z_5dSKl42FnFE-Dx_MlVSX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor powerpc JITing. This simplifies adding BPF_PROBE_MEM support.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---

Changes in v2:
* New patch to refactor a bit of JITing code.


 arch/powerpc/net/bpf_jit_comp32.c | 50 +++++++++++---------
 arch/powerpc/net/bpf_jit_comp64.c | 76 ++++++++++++++++---------------
 2 files changed, 68 insertions(+), 58 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index b60b59426a24..c8ae14c316e3 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -276,17 +276,17 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 	u32 exit_addr = addrs[flen];
 
 	for (i = 0; i < flen; i++) {
-		u32 code = insn[i].code;
 		u32 dst_reg = bpf_to_ppc(ctx, insn[i].dst_reg);
-		u32 dst_reg_h = dst_reg - 1;
 		u32 src_reg = bpf_to_ppc(ctx, insn[i].src_reg);
-		u32 src_reg_h = src_reg - 1;
 		u32 tmp_reg = bpf_to_ppc(ctx, TMP_REG);
+		u32 true_cond, code = insn[i].code;
+		u32 dst_reg_h = dst_reg - 1;
+		u32 src_reg_h = src_reg - 1;
+		u32 size = BPF_SIZE(code);
 		s16 off = insn[i].off;
 		s32 imm = insn[i].imm;
 		bool func_addr_fixed;
 		u64 func_addr;
-		u32 true_cond;
 
 		/*
 		 * addrs[] maps a BPF bytecode address into a real offset from
@@ -809,25 +809,33 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		/*
 		 * BPF_LDX
 		 */
-		case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
-			if (!fp->aux->verifier_zext)
-				EMIT(PPC_RAW_LI(dst_reg_h, 0));
-			break;
-		case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
-			if (!fp->aux->verifier_zext)
-				EMIT(PPC_RAW_LI(dst_reg_h, 0));
-			break;
-		case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
-			if (!fp->aux->verifier_zext)
+		/* dst = *(u8 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_B:
+		/* dst = *(u16 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_H:
+		/* dst = *(u32 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_W:
+		/* dst = *(u64 *)(ul) (src + off) */
+		case BPF_LDX | BPF_MEM | BPF_DW:
+			switch (size) {
+			case BPF_B:
+				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
+				break;
+			case BPF_H:
+				EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
+				break;
+			case BPF_W:
+				EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
+				break;
+			case BPF_DW:
+				EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
+				EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
+				break;
+			}
+
+			if ((size != BPF_DW) && !fp->aux->verifier_zext)
 				EMIT(PPC_RAW_LI(dst_reg_h, 0));
 			break;
-		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
-			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
-			break;
 
 		/*
 		 * Doubleword load
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 2a87da50d9a4..78b28f25555c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -282,16 +282,15 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 	u32 exit_addr = addrs[flen];
 
 	for (i = 0; i < flen; i++) {
-		u32 code = insn[i].code;
 		u32 dst_reg = b2p[insn[i].dst_reg];
 		u32 src_reg = b2p[insn[i].src_reg];
+		u32 tmp_idx, code = insn[i].code;
+		u32 size = BPF_SIZE(code);
 		s16 off = insn[i].off;
 		s32 imm = insn[i].imm;
 		bool func_addr_fixed;
-		u64 func_addr;
-		u64 imm64;
+		u64 func_addr, imm64;
 		u32 true_cond;
-		u32 tmp_idx;
 
 		/*
 		 * addrs[] maps a BPF bytecode address into a real offset from
@@ -638,35 +637,34 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 */
 		case BPF_STX | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = src */
 		case BPF_ST | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = imm */
-			if (BPF_CLASS(code) == BPF_ST) {
-				EMIT(PPC_RAW_LI(b2p[TMP_REG_1], imm));
-				src_reg = b2p[TMP_REG_1];
-			}
-			EMIT(PPC_RAW_STB(src_reg, dst_reg, off));
-			break;
 		case BPF_STX | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = src */
 		case BPF_ST | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = imm */
-			if (BPF_CLASS(code) == BPF_ST) {
-				EMIT(PPC_RAW_LI(b2p[TMP_REG_1], imm));
-				src_reg = b2p[TMP_REG_1];
-			}
-			EMIT(PPC_RAW_STH(src_reg, dst_reg, off));
-			break;
 		case BPF_STX | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = src */
 		case BPF_ST | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = imm */
-			if (BPF_CLASS(code) == BPF_ST) {
-				PPC_LI32(b2p[TMP_REG_1], imm);
-				src_reg = b2p[TMP_REG_1];
-			}
-			EMIT(PPC_RAW_STW(src_reg, dst_reg, off));
-			break;
 		case BPF_STX | BPF_MEM | BPF_DW: /* (u64 *)(dst + off) = src */
 		case BPF_ST | BPF_MEM | BPF_DW: /* *(u64 *)(dst + off) = imm */
 			if (BPF_CLASS(code) == BPF_ST) {
-				PPC_LI32(b2p[TMP_REG_1], imm);
+				if ((size == BPF_B) || (size == BPF_H))
+					EMIT(PPC_RAW_LI(b2p[TMP_REG_1], imm));
+				else /* size == BPF_W || size == BPF_DW */
+					PPC_LI32(b2p[TMP_REG_1], imm);
 				src_reg = b2p[TMP_REG_1];
 			}
-			PPC_BPF_STL(src_reg, dst_reg, off);
+
+			switch (size) {
+			case BPF_B:
+				EMIT(PPC_RAW_STB(src_reg, dst_reg, off));
+				break;
+			case BPF_H:
+				EMIT(PPC_RAW_STH(src_reg, dst_reg, off));
+				break;
+			case BPF_W:
+				EMIT(PPC_RAW_STW(src_reg, dst_reg, off));
+				break;
+			case BPF_DW:
+				PPC_BPF_STL(src_reg, dst_reg, off);
+				break;
+			}
 			break;
 
 		/*
@@ -716,25 +714,29 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 */
 		/* dst = *(u8 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
-			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
-			if (insn_is_zext(&insn[i + 1]))
-				addrs[++i] = ctx->idx * 4;
-			break;
 		/* dst = *(u16 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_H:
-			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
-			if (insn_is_zext(&insn[i + 1]))
-				addrs[++i] = ctx->idx * 4;
-			break;
 		/* dst = *(u32 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_W:
-			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
-			if (insn_is_zext(&insn[i + 1]))
-				addrs[++i] = ctx->idx * 4;
-			break;
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
-			PPC_BPF_LL(dst_reg, src_reg, off);
+			switch (size) {
+			case BPF_B:
+				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
+				break;
+			case BPF_H:
+				EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
+				break;
+			case BPF_W:
+				EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
+				break;
+			case BPF_DW:
+				PPC_BPF_LL(dst_reg, src_reg, off);
+				break;
+			}
+
+			if ((size != BPF_DW) && insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 
 		/*
-- 
2.31.1

