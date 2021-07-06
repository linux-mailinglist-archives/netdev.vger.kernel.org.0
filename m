Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 116803BC740
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 09:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhGFHgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 03:36:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230350AbhGFHgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 03:36:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1667Wn7S159059;
        Tue, 6 Jul 2021 03:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=81hS0zAo7m0Uu/SD1zkMb91o9SxmgBOCy4lfWFM+4DU=;
 b=KbYN6uCoJk2pK2hI5cCjAp5mVoSFtKn6JXGstg35/zjl5fRsIuAeYsuo5ncM6ZiVoG5q
 WkR1R52cTDKiF6w1a3Jko8cL72Vu/T+8xPWtHY3+Nr6c/txzmNl5SlL/UPBHk6nCvPwz
 UIBZdNK2LN/fQ6/hZpbsoAOXJwuiVQatJstLpNBcoAZn4lzXKXV94YPxpZoErJ5j47B+
 kE7ufmLkoPgYvT8sk+ShdBMRdwUH++lPU+JajfOFSlaQx6trON1SppjLPzzjaE/5TSwB
 YBbNPZzLWXP0GWT2gevvqDHjT4pUxZ5HNRf5G0ag4oLah6Z1RoUc8XcS5kr+qK7qn8rK ww== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mjkk8epb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:32:57 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1667WuaI159400;
        Tue, 6 Jul 2021 03:32:56 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mjkk8enf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 03:32:56 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1667DI2m011615;
        Tue, 6 Jul 2021 07:32:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 39jfh88kpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Jul 2021 07:32:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1667Wpp425100640
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 6 Jul 2021 07:32:51 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 201855204F;
        Tue,  6 Jul 2021 07:32:51 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.43.134])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5D9B152063;
        Tue,  6 Jul 2021 07:32:44 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     ravi.bangoria@linux.ibm.com, sandipan@linux.ibm.com,
        paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] bpf powerpc: Add BPF_PROBE_MEM support for 64bit JIT
Date:   Tue,  6 Jul 2021 13:02:10 +0530
Message-Id: <20210706073211.349889-4-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
References: <20210706073211.349889-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jLKvLTB7uTaMnXjX42bEDmhVgMOqBo28
X-Proofpoint-ORIG-GUID: eg3mamSYx2-ft0vDJp-97EcY0l92C2Wu
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-06_02:2021-07-02,2021-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107060037
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF load instruction with BPF_PROBE_MEM mode can cause a fault
inside kernel. Append exception table for such instructions
within BPF program.

Unlike other archs which uses extable 'fixup' field to pass dest_reg
and nip, BPF exception table on PowerPC follows the generic PowerPC
exception table design, where it populates both fixup and extable
sections witin BPF program. fixup section contains two instructions,
first instruction clears dest_reg and 2nd jumps to next instruction
in the BPF code. extable 'insn' field contains relative offset of
the instruction and 'fixup' field contains relative offset of the
fixup entry. Example layout of BPF program with extable present:

             +------------------+
             |                  |
             |                  |
   0x4020 -->| ld   r27,4(r3)   |
             |                  |
             |                  |
   0x40ac -->| lwz  r3,0(r4)    |
             |                  |
             |                  |
             |------------------|
   0x4280 -->| xor r27,r27,r27  |  \ fixup entry
             | b   0x4024       |  /
   0x4288 -->| xor r3,r3,r3     |
             | b   0x40b0       |
             |------------------|
   0x4290 -->| insn=0xfffffd90  |  \ extable entry
             | fixup=0xffffffec |  /
   0x4298 -->| insn=0xfffffe14  |
             | fixup=0xffffffec |
             +------------------+

   (Addresses shown here are chosen random, not real)

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit.h        |  5 ++-
 arch/powerpc/net/bpf_jit_comp.c   | 25 +++++++++----
 arch/powerpc/net/bpf_jit_comp32.c |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c | 60 ++++++++++++++++++++++++++++++-
 4 files changed, 83 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 411c63d945c7..e9408ad190d3 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -141,8 +141,11 @@ struct codegen_context {
 	unsigned int idx;
 	unsigned int stack_size;
 	int b2p[ARRAY_SIZE(b2p)];
+	unsigned int exentry_idx;
 };
 
+#define BPF_FIXUP_LEN	8 /* Two instructions */
+
 static inline void bpf_flush_icache(void *start, void *end)
 {
 	smp_wmb();	/* smp write barrier */
@@ -166,7 +169,7 @@ static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
 
 void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs);
+		       u32 *addrs, int pass);
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_realloc_regs(struct codegen_context *ctx);
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index a9585e52a88d..3ebd8897cf09 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -89,6 +89,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 {
 	u32 proglen;
 	u32 alloclen;
+	u32 extable_len = 0;
+	u32 fixup_len = 0;
 	u8 *image = NULL;
 	u32 *code_base;
 	u32 *addrs;
@@ -131,7 +133,6 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		image = jit_data->image;
 		bpf_hdr = jit_data->header;
 		proglen = jit_data->proglen;
-		alloclen = proglen + FUNCTION_DESCR_SIZE;
 		extra_pass = true;
 		goto skip_init_ctx;
 	}
@@ -149,7 +150,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	cgctx.stack_size = round_up(fp->aux->stack_depth, 16);
 
 	/* Scouting faux-generate pass 0 */
-	if (bpf_jit_build_body(fp, 0, &cgctx, addrs)) {
+	if (bpf_jit_build_body(fp, 0, &cgctx, addrs, 0)) {
 		/* We hit something illegal or unsupported. */
 		fp = org_fp;
 		goto out_addrs;
@@ -162,7 +163,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	 */
 	if (cgctx.seen & SEEN_TAILCALL) {
 		cgctx.idx = 0;
-		if (bpf_jit_build_body(fp, 0, &cgctx, addrs)) {
+		if (bpf_jit_build_body(fp, 0, &cgctx, addrs, 0)) {
 			fp = org_fp;
 			goto out_addrs;
 		}
@@ -177,8 +178,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	bpf_jit_build_prologue(0, &cgctx);
 	bpf_jit_build_epilogue(0, &cgctx);
 
+	fixup_len = fp->aux->num_exentries * BPF_FIXUP_LEN;
+	extable_len = fp->aux->num_exentries * sizeof(struct exception_table_entry);
+
 	proglen = cgctx.idx * 4;
-	alloclen = proglen + FUNCTION_DESCR_SIZE;
+	alloclen = proglen + FUNCTION_DESCR_SIZE + fixup_len + extable_len;
 
 	bpf_hdr = bpf_jit_binary_alloc(alloclen, &image, 4, bpf_jit_fill_ill_insns);
 	if (!bpf_hdr) {
@@ -186,6 +190,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		goto out_addrs;
 	}
 
+	if (extable_len) {
+		fp->aux->extable = (void *)image + FUNCTION_DESCR_SIZE +
+				   proglen + fixup_len;
+	}
+
 skip_init_ctx:
 	code_base = (u32 *)(image + FUNCTION_DESCR_SIZE);
 
@@ -210,7 +219,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		/* Now build the prologue, body code & epilogue for real. */
 		cgctx.idx = 0;
 		bpf_jit_build_prologue(code_base, &cgctx);
-		bpf_jit_build_body(fp, code_base, &cgctx, addrs);
+		if (bpf_jit_build_body(fp, code_base, &cgctx, addrs, pass)) {
+			bpf_jit_binary_free(bpf_hdr);
+			fp = org_fp;
+			goto out_addrs;
+		}
 		bpf_jit_build_epilogue(code_base, &cgctx);
 
 		if (bpf_jit_enable > 1)
@@ -234,7 +247,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
 	fp->bpf_func = (void *)image;
 	fp->jited = 1;
-	fp->jited_len = alloclen;
+	fp->jited_len = proglen + FUNCTION_DESCR_SIZE;
 
 	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
 	if (!fp->is_func || extra_pass) {
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 1f81bea35aab..23ab5620a45a 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -266,7 +266,7 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs)
+		       u32 *addrs, int pass)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index 984177d9d394..1884c6dca89a 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -270,9 +270,51 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	/* out: */
 }
 
+static int add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
+			     u32 code, struct codegen_context *ctx, int dst_reg)
+{
+	off_t offset;
+	unsigned long pc;
+	struct exception_table_entry *ex;
+	u32 *fixup;
+
+	/* Populate extable entries only in the last pass */
+	if (pass != 2 || BPF_MODE(code) != BPF_PROBE_MEM)
+		return 0;
+
+	if (!fp->aux->extable ||
+	    WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
+		return -EINVAL;
+
+	pc = (unsigned long)&image[ctx->idx - 1];
+
+	fixup = (void *)fp->aux->extable -
+		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
+		(ctx->exentry_idx * BPF_FIXUP_LEN);
+
+	fixup[0] = PPC_RAW_XOR(dst_reg, dst_reg, dst_reg);
+	fixup[1] = (PPC_INST_BRANCH |
+		   (((long)(pc + 4) - (long)&fixup[1]) & 0x03fffffc));
+
+	ex = &fp->aux->extable[ctx->exentry_idx];
+
+	offset = pc - (long)&ex->insn;
+	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
+		return -ERANGE;
+	ex->insn = offset;
+
+	offset = (long)fixup - (long)&ex->fixup;
+	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
+		return -ERANGE;
+	ex->fixup = offset;
+
+	ctx->exentry_idx++;
+	return 0;
+}
+
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs)
+		       u32 *addrs, int pass)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
@@ -710,25 +752,41 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 */
 		/* dst = *(u8 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
 			EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
 			if (insn_is_zext(&insn[i + 1]))
 				addrs[++i] = ctx->idx * 4;
+			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
+			if (ret)
+				return ret;
 			break;
 		/* dst = *(u16 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_H:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
 			EMIT(PPC_RAW_LHZ(dst_reg, src_reg, off));
 			if (insn_is_zext(&insn[i + 1]))
 				addrs[++i] = ctx->idx * 4;
+			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
+			if (ret)
+				return ret;
 			break;
 		/* dst = *(u32 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_W:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
 			EMIT(PPC_RAW_LWZ(dst_reg, src_reg, off));
 			if (insn_is_zext(&insn[i + 1]))
 				addrs[++i] = ctx->idx * 4;
+			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
+			if (ret)
+				return ret;
 			break;
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
 			PPC_BPF_LL(dst_reg, src_reg, off);
+			ret = add_extable_entry(fp, image, pass, code, ctx, dst_reg);
+			if (ret)
+				return ret;
 			break;
 
 		/*
-- 
2.26.3

