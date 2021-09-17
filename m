Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1500D40FC6A
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhIQPdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:33:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:11724 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240172AbhIQPde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:33:34 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HF03fs021470;
        Fri, 17 Sep 2021 11:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wnBT24qceSBzcbwPeNJpPByDoXNGG8g2yO1D+b5MqKA=;
 b=JsYRmqEpe5yerQcPJ76GFOzml+WetYdjYNtlO4+WJq1YY2L39XOJccocx2EVhxiXdH7G
 IFZGi+jZJ7gRDLTS1VtxVqIxdrejv/zpbouXUGQ/S0ay0zDTxv92CUy5ec7oo3M1qBb+
 jY05Mcu1/ogjWHj3NbsdmyvstPk2MGmVZD4Slss7e7jAug/1VgyirT91uYmRtH3nxWvy
 Zw7r2vmOi/BBvKVXFLL0hEAo22qEy0ibqqwcBu45/bPOPwGNobP9g6lpNgXFMsZ1ntwB
 9dAL1k2ymRz1Q1stHgUgZdAA/k+hY3qWzE1Fei27vx55TBfRQgKbcTHXCF3yWK+ayC/n pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4nc1d3ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:44 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HF1hDm031328;
        Fri, 17 Sep 2021 11:31:43 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4nc1d3k4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:31:43 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFGvH2027093;
        Fri, 17 Sep 2021 15:31:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3b0m3ax0dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:31:40 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFR1uD60555584
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:27:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25C3511C070;
        Fri, 17 Sep 2021 15:31:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7522011C07A;
        Fri, 17 Sep 2021 15:31:32 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:31:32 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: [PATCH v2 2/8] bpf powerpc: Remove extra_pass from bpf_jit_build_body()
Date:   Fri, 17 Sep 2021 21:00:41 +0530
Message-Id: <20210917153047.177141-3-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917153047.177141-1-hbathini@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9KalKDiewyDoXzSRggsH5M2XS4yacHPM
X-Proofpoint-GUID: QuImnyAxHx9ia3Uc45oiMD6iUtBDlmTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 adultscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

In case of extra_pass, usual JIT passes are always skipped. So,
extra_pass is always false while calling bpf_jit_build_body() and
thus it can be removed.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---

Changes in v2:
* Updated the changelog wording a bit.


 arch/powerpc/net/bpf_jit.h        | 2 +-
 arch/powerpc/net/bpf_jit_comp.c   | 6 +++---
 arch/powerpc/net/bpf_jit_comp32.c | 4 ++--
 arch/powerpc/net/bpf_jit_comp64.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index d6267e93027a..411c63d945c7 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -166,7 +166,7 @@ static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
 
 void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs, bool extra_pass);
+		       u32 *addrs);
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_realloc_regs(struct codegen_context *ctx);
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 53aefee3fe70..c5c9e8ad1de7 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -149,7 +149,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
 
 	/* Scouting faux-generate pass 0 */
-	if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+	if (bpf_jit_build_body(fp, 0, &cgctx, addrs)) {
 		/* We hit something illegal or unsupported. */
 		fp = org_fp;
 		goto out_addrs;
@@ -162,7 +162,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	 */
 	if (cgctx.seen & SEEN_TAILCALL) {
 		cgctx.idx = 0;
-		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, false)) {
+		if (bpf_jit_build_body(fp, 0, &cgctx, addrs)) {
 			fp = org_fp;
 			goto out_addrs;
 		}
@@ -210,7 +210,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		/* Now build the prologue, body code & epilogue for real. */
 		cgctx.idx = 0;
 		bpf_jit_build_prologue(code_base, &cgctx);
-		bpf_jit_build_body(fp, code_base, &cgctx, addrs, extra_pass);
+		bpf_jit_build_body(fp, code_base, &cgctx, addrs);
 		bpf_jit_build_epilogue(code_base, &cgctx);
 
 		if (bpf_jit_enable > 1)
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index beb12cbc8c29..b60b59426a24 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -266,7 +266,7 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs, bool extra_pass)
+		       u32 *addrs)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
@@ -860,7 +860,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_JMP | BPF_CALL:
 			ctx->seen |= SEEN_FUNC;
 
-			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+			ret = bpf_jit_get_func_addr(fp, &insn[i], false,
 						    &func_addr, &func_addr_fixed);
 			if (ret < 0)
 				return ret;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index b87a63dba9c8..2a87da50d9a4 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -272,7 +272,7 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs, bool extra_pass)
+		       u32 *addrs)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
@@ -769,7 +769,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_JMP | BPF_CALL:
 			ctx->seen |= SEEN_FUNC;
 
-			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+			ret = bpf_jit_get_func_addr(fp, &insn[i], false,
 						    &func_addr, &func_addr_fixed);
 			if (ret < 0)
 				return ret;
-- 
2.31.1

