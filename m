Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0583BC73D
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 09:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhGFHgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 03:36:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27582 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230323AbhGFHf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 03:35:58 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1667330R007158;
        Tue, 6 Jul 2021 03:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qZNgAKBLxyufhG8gqj08NpI8f0VoLejOyJKjjYkszjs=;
 b=g7QH1RaD/xOXy8XkAYxhVtamztE32lse31MC7RwC9ELrLJPB1F4BEPB6OyENxFJvH/6r
 +bi8XGJSLVylaIBR2La3IC/TdfZ88JFYu6pMdrQyA/FUnaZxqpGLDsVjF9KDl9mpdg+2
 Ok/nQ8yKA2cMmzOsq56fvxFHynK7jL3A+b8/moXPpWXrH2l83+OInTa8xJyfv3STC27M
 EJ1zXgLgaRbPlOL0M1l9mB4wGMBUySwRdnJT9g11fbroEELEF/FvhMwl0ea/9CACqHeW
 Ei6YyIwg4siKYad6T68Gva0ADlYA829ksYyi6p0rhcD7cv7mqctdPJucFKUy8i+ckfi7 Tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39me70x5rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:32:50 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1667591V015661;
        Tue, 6 Jul 2021 03:32:49 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39me70x5ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:32:49 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1667BRHr006652;
        Tue, 6 Jul 2021 07:32:46 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9445-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:32:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1667WhGZ33685926
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 07:32:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEA0E5204F;
        Tue,  6 Jul 2021 07:32:43 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.43.134])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F14B35205A;
        Tue,  6 Jul 2021 07:32:36 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     ravi.bangoria@linux.ibm.com, sandipan@linux.ibm.com,
        paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] bpf powerpc: Remove extra_pass from bpf_jit_build_body()
Date:   Tue,  6 Jul 2021 13:02:09 +0530
Message-Id: <20210706073211.349889-3-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
References: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gngcAWcq0soGwDsY0rGB8FEFx9hLzuBd
X-Proofpoint-GUID: vG-i2ZiV9twljMo95lRZvoi1SxqOSeyO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of extra_pass, we always skips usual JIT passes. Thus
extra_pass is always false while calling bpf_jit_build_body()
and thus it can be removed.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
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
index 798ac4350a82..a9585e52a88d 100644
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
index bbb16099e8c7..1f81bea35aab 100644
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
@@ -846,7 +846,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_JMP | BPF_CALL:
 			ctx->seen |= SEEN_FUNC;
 
-			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+			ret = bpf_jit_get_func_addr(fp, &insn[i], false,
 						    &func_addr, &func_addr_fixed);
 			if (ret < 0)
 				return ret;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 57a8c1153851..984177d9d394 100644
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
@@ -763,7 +763,7 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		case BPF_JMP | BPF_CALL:
 			ctx->seen |= SEEN_FUNC;
 
-			ret = bpf_jit_get_func_addr(fp, &insn[i], extra_pass,
+			ret = bpf_jit_get_func_addr(fp, &insn[i], false,
 						    &func_addr, &func_addr_fixed);
 			if (ret < 0)
 				return ret;
-- 
2.26.3

