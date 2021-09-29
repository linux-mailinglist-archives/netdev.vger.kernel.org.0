Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B80141C358
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhI2LWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:22:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229567AbhI2LWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:22:03 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18TA4qC3030706;
        Wed, 29 Sep 2021 07:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=w5BMI4jf7JbupfatK1eGMlJeM7pUt0KPcq2ugY/c8m8=;
 b=GlelxGk+5M3bHHP9uUaHv10jXMpgt0GtBYs4TcuiPjk+U2PPk0ldm03dczJSnyR2G34L
 ugPL/SqcVhGgA2pZxDg1wkw3S2vCD0NyfKojFHgDX1W/GjtLw3rRuE5E5KTSg3aeDhaR
 SBnSIIfDZ9zX7srcO3jyLsFHzbM9Jhjhwfa8fYEuR0j3tcEN3VPI1lmNpMrI5GIklaIl
 gAj/rBgXbLDKbXEbuM0T51d+66MZzKBsxF31IgKUMHidem7Cdhi9kANvqk2ZOoTUFW25
 F+T+inZ+n+dPBdTaaRWbl02IdjaXyHBtvtPAEkUpqF1D03J9fwN1hie2Z7iw0ucbmBPD kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bcp2w1epd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:27 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18TAhR28014252;
        Wed, 29 Sep 2021 07:19:26 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bcp2w1ep3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:26 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18TBBRCu032680;
        Wed, 29 Sep 2021 11:19:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3b9ud9y45j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 11:19:24 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18TBEI5161473032
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 11:14:18 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A23342072;
        Wed, 29 Sep 2021 11:19:21 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F1154206E;
        Wed, 29 Sep 2021 11:19:16 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.83.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Sep 2021 11:19:16 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v4 3/8] bpf powerpc: refactor JIT compiler code
Date:   Wed, 29 Sep 2021 16:48:50 +0530
Message-Id: <20210929111855.50254-4-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929111855.50254-1-hbathini@linux.ibm.com>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GJOsgWFkvgnwZ4-kwtafmRnMvLSuxdR_
X-Proofpoint-ORIG-GUID: 2KQV42-eDfQT7sUYN_YFNvf5LKvHtmLr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_04,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 adultscore=0 suspectscore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor powerpc LDX JITing code to simplify adding BPF_PROBE_MEM
support.

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---

Changes in v4:
* Dropped the default case in the switch statement for bpf size.
* Dropped explicit fallthrough statement for empty switch cases.


 arch/powerpc/net/bpf_jit_comp32.c | 33 ++++++++++++++++++-------------
 arch/powerpc/net/bpf_jit_comp64.c | 31 +++++++++++++++++------------
 2 files changed, 37 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index b60b59426a24..65a4d1ed97bf 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -282,6 +282,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		u32 src_reg = bpf_to_ppc(ctx, insn[i].src_reg);
 		u32 src_reg_h = src_reg - 1;
 		u32 tmp_reg = bpf_to_ppc(ctx, TMP_REG);
+		u32 size = BPF_SIZE(code);
 		s16 off = insn[i].off;
 		s32 imm = insn[i].imm;
 		bool func_addr_fixed;
@@ -810,23 +811,27 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 * BPF_LDX
 		 */
 		case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
-			if (!fp->aux->verifier_zext)
-				EMIT(PPC_RAW_LI(dst_reg_h, 0));
-			break;
 		case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
-			if (!fp->aux->verifier_zext)
-				EMIT(PPC_RAW_LI(dst_reg_h, 0));
-			break;
 		case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
-			if (!fp->aux->verifier_zext)
-				EMIT(PPC_RAW_LI(dst_reg_h, 0));
-			break;
 		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
-			EMIT(PPC_RAW_LWZ(dst_reg_h, src_reg, off));
-			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off + 4));
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
+			if (size != BPF_DW && !fp->aux->verifier_zext)
+				EMIT(PPC_RAW_LI(dst_reg_h, 0));
 			break;
 
 		/*
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 2a87da50d9a4..49e6e0b6e4d2 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -285,6 +285,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		u32 code = insn[i].code;
 		u32 dst_reg = b2p[insn[i].dst_reg];
 		u32 src_reg = b2p[insn[i].src_reg];
+		u32 size = BPF_SIZE(code);
 		s16 off = insn[i].off;
 		s32 imm = insn[i].imm;
 		bool func_addr_fixed;
@@ -716,25 +717,29 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
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
+			if (size != BPF_DW && insn_is_zext(&insn[i + 1]))
+				addrs[++i] = ctx->idx * 4;
 			break;
 
 		/*
-- 
2.31.1

