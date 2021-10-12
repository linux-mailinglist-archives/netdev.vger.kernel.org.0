Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA91142A47D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhJLMfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:35:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233112AbhJLMfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:35:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CAIxhf018283;
        Tue, 12 Oct 2021 08:32:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dano76bt5YYqdslyZjjxxNT3puwv/3ZfgVUY6UIStbQ=;
 b=GWgjembDWgfMaHLTOOc+uITMQL8/UwlzR1pyMenwBhBmPxF1k8pcO1eA+DhKJ3bkQV53
 BVcnDSuifNx7H8il5njM/usyFg/6PGGpW94Yb0GBoT+UUwsj1Cti73rCmX/s5Jlrl069
 74sUld3/zAMFGVV8zjlqmXb9nhO2ps15meVY1bVAd6ByVdvJHS4E0uKz6T0eZofvyve8
 DcP5jdEuD1MU1jZRgJFJsfKu8qhPnF2lb/AaW3GUoAlebS/wlUtBLLJD5XUjs+R9nxNN
 hbSeO7dJ8LhPvlgb0ZG8KZ/IB9m+p9lOSoR/o3hwEsHsl1JNGJxCNMReNTi8jUYake0q 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn5ruehpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:32:21 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CCWF3P005962;
        Tue, 12 Oct 2021 08:32:19 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bn5ruehmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:32:19 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CCVsvC029258;
        Tue, 12 Oct 2021 12:32:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bj8hrg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 12:32:15 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CCVwV540567078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 12:31:58 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8023CA4051;
        Tue, 12 Oct 2021 12:31:58 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A51E5A4076;
        Tue, 12 Oct 2021 12:31:41 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.27.69])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 12:31:40 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: [RESEND PATCH v4 2/8] bpf powerpc: Remove extra_pass from bpf_jit_build_body()
Date:   Tue, 12 Oct 2021 18:00:50 +0530
Message-Id: <20211012123056.485795-3-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012123056.485795-1-hbathini@linux.ibm.com>
References: <20211012123056.485795-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L1sMddrN2gUXElwYA_V9OyC0ej-jaZqB
X-Proofpoint-GUID: _1Om5541v9DKUvQfX_x1WoQvZEI-1RCV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_03,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

In case of extra_pass, usual JIT passes are always skipped. So,
extra_pass is always false while calling bpf_jit_build_body() and
can be removed.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---

* No changes in v4.


 arch/powerpc/net/bpf_jit.h        | 2 +-
 arch/powerpc/net/bpf_jit_comp.c   | 6 +++---
 arch/powerpc/net/bpf_jit_comp32.c | 4 ++--
 arch/powerpc/net/bpf_jit_comp64.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 89bd744c2bff..7145b651fc2a 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -175,7 +175,7 @@ static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
 
 void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs, bool extra_pass);
+		       u32 *addrs);
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_realloc_regs(struct codegen_context *ctx);
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index fcbf7a917c56..f7972b2c21f6 100644
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
-		if (bpf_jit_build_body(fp, code_base, &cgctx, addrs, extra_pass)) {
+		if (bpf_jit_build_body(fp, code_base, &cgctx, addrs)) {
 			bpf_jit_binary_free(bpf_hdr);
 			fp = org_fp;
 			goto out_addrs;
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 0da31d41d413..903f945601c0 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -268,7 +268,7 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs, bool extra_pass)
+		       u32 *addrs)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
@@ -862,7 +862,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_JMP | BPF_CALL:
 			ctx->seen |= SEEN_FUNC;
 
-			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+			ret = bpf_jit_get_func_addr(fp, &insn[i], false,
 						    &func_addr, &func_addr_fixed);
 			if (ret < 0)
 				return ret;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 8b5157ccfeba..b25bf9b11b9d 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -297,7 +297,7 @@ asm (
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs, bool extra_pass)
+		       u32 *addrs)
 {
 	enum stf_barrier_type stf_barrier = stf_barrier_type_get();
 	const struct bpf_insn *insn = fp->insnsi;
@@ -831,7 +831,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_JMP | BPF_CALL:
 			ctx->seen |= SEEN_FUNC;
 
-			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+			ret = bpf_jit_get_func_addr(fp, &insn[i], false,
 						    &func_addr, &func_addr_fixed);
 			if (ret < 0)
 				return ret;
-- 
2.31.1

