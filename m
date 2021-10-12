Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B8142A483
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 14:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236346AbhJLMfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 08:35:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4700 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhJLMfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 08:35:36 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CB3N2u026645;
        Tue, 12 Oct 2021 08:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=E07FShsQjSnlbWk31wd1vO085DfdNcBGxbgwITdj5Zg=;
 b=KVl3n1aXTVRaR0751NR053GSUWFp29uS4RwVsFR1d+16SDw8wZCf+C9OO+0bhHMkcf+L
 si4CkcBOr+dpxwsxPTC5kS8Xxr4vBp+8OOfLGf84DtpUmYeJvkcfeVV1jlVcUADNGdD+
 E+QkJP3X+GLhKGJx2pX28FT097GdAku8MY4EybR82I78wt6o5Rs/TFNnz4jOve9XbTIy
 idJsUzQnobyxO4oPdMgcio8vBs5eNoTxtRYbknRduYuxNYlskdXfbKlPNLDi7Q9oFjJU
 ifZMmaO84Cc73iuzeYkeiT1hsw60zPOTjmGPzQVvgQ4aVUBl9U4edVHclkX26jpSzhmW dQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn49yrkm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:33:04 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19CC6sio010244;
        Tue, 12 Oct 2021 08:33:03 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bn49yrkk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 08:33:03 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19CCVwn8029281;
        Tue, 12 Oct 2021 12:33:01 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bk2bj8hxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 12:33:01 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19CCWlp448693644
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 12:32:48 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1FB6A405F;
        Tue, 12 Oct 2021 12:32:47 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D925FA407B;
        Tue, 12 Oct 2021 12:32:32 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.27.69])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Oct 2021 12:32:32 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [RESEND PATCH v4 5/8] bpf ppc64: Add BPF_PROBE_MEM support for JIT
Date:   Tue, 12 Oct 2021 18:00:53 +0530
Message-Id: <20211012123056.485795-6-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012123056.485795-1-hbathini@linux.ibm.com>
References: <20211012123056.485795-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iJtfydG7YPzPC7WIazV9La763BvjXypv
X-Proofpoint-GUID: Um3VsELqUt9tqrJmI1aGtpvnFqKEGMDh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-12_03,2021-10-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 mlxlogscore=999 malwarescore=0
 adultscore=0 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120073
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

BPF load instruction with BPF_PROBE_MEM mode can cause a fault
inside kernel. Append exception table for such instructions
within BPF program.

Unlike other archs which uses extable 'fixup' field to pass dest_reg
and nip, BPF exception table on PowerPC follows the generic PowerPC
exception table design, where it populates both fixup and extable
sections within BPF program. fixup section contains two instructions,
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
   0x4280 -->| li  r27,0        |  \ fixup entry
             | b   0x4024       |  /
   0x4288 -->| li  r3,0         |
             | b   0x40b0       |
             |------------------|
   0x4290 -->| insn=0xfffffd90  |  \ extable entry
             | fixup=0xffffffec |  /
   0x4298 -->| insn=0xfffffe14  |
             | fixup=0xffffffec |
             +------------------+

   (Addresses shown here are chosen random, not real)

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---

Changes in v4:
* Dropped explicit fallthrough statement for empty switch cases.


 arch/powerpc/net/bpf_jit.h        |  8 +++-
 arch/powerpc/net/bpf_jit_comp.c   | 66 ++++++++++++++++++++++++++++---
 arch/powerpc/net/bpf_jit_comp32.c |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c | 13 +++++-
 4 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 6a945f6211f4..444c9debce91 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -150,8 +150,11 @@ struct codegen_context {
 	unsigned int idx;
 	unsigned int stack_size;
 	int b2p[ARRAY_SIZE(b2p)];
+	unsigned int exentry_idx;
 };
 
+#define BPF_FIXUP_LEN	2 /* Two instructions => 8 bytes */
+
 static inline void bpf_flush_icache(void *start, void *end)
 {
 	smp_wmb();	/* smp write barrier */
@@ -175,11 +178,14 @@ static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
 
 void bpf_jit_emit_func_call_rel(u32 *image, struct codegen_context *ctx, u64 func);
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs);
+		       u32 *addrs, int pass);
 void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_realloc_regs(struct codegen_context *ctx);
 
+int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass, struct codegen_context *ctx,
+			  int insn_idx, int jmp_off, int dst_reg);
+
 #endif
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index f7972b2c21f6..f02457c6b54f 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -101,6 +101,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 	struct bpf_prog *tmp_fp;
 	bool bpf_blinded = false;
 	bool extra_pass = false;
+	u32 extable_len;
+	u32 fixup_len;
 
 	if (!fp->jit_requested)
 		return org_fp;
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
 
+	fixup_len = fp->aux->num_exentries * BPF_FIXUP_LEN * 4;
+	extable_len = fp->aux->num_exentries * sizeof(struct exception_table_entry);
+
 	proglen = cgctx.idx * 4;
-	alloclen = proglen + FUNCTION_DESCR_SIZE;
+	alloclen = proglen + FUNCTION_DESCR_SIZE + fixup_len + extable_len;
 
 	bpf_hdr = bpf_jit_binary_alloc(alloclen, &image, 4, bpf_jit_fill_ill_insns);
 	if (!bpf_hdr) {
@@ -186,6 +190,9 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		goto out_addrs;
 	}
 
+	if (extable_len)
+		fp->aux->extable = (void *)image + FUNCTION_DESCR_SIZE + proglen + fixup_len;
+
 skip_init_ctx:
 	code_base = (u32 *)(image + FUNCTION_DESCR_SIZE);
 
@@ -210,7 +217,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		/* Now build the prologue, body code & epilogue for real. */
 		cgctx.idx = 0;
 		bpf_jit_build_prologue(code_base, &cgctx);
-		if (bpf_jit_build_body(fp, code_base, &cgctx, addrs)) {
+		if (bpf_jit_build_body(fp, code_base, &cgctx, addrs, pass)) {
 			bpf_jit_binary_free(bpf_hdr);
 			fp = org_fp;
 			goto out_addrs;
@@ -238,7 +245,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
 	fp->bpf_func = (void *)image;
 	fp->jited = 1;
-	fp->jited_len = alloclen;
+	fp->jited_len = proglen + FUNCTION_DESCR_SIZE;
 
 	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
 	bpf_jit_binary_lock_ro(bpf_hdr);
@@ -262,3 +269,50 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
 	return fp;
 }
+
+/*
+ * The caller should check for (BPF_MODE(code) == BPF_PROBE_MEM) before calling
+ * this function, as this only applies to BPF_PROBE_MEM, for now.
+ */
+int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass, struct codegen_context *ctx,
+			  int insn_idx, int jmp_off, int dst_reg)
+{
+	off_t offset;
+	unsigned long pc;
+	struct exception_table_entry *ex;
+	u32 *fixup;
+
+	/* Populate extable entries only in the last pass */
+	if (pass != 2)
+		return 0;
+
+	if (!fp->aux->extable ||
+	    WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
+		return -EINVAL;
+
+	pc = (unsigned long)&image[insn_idx];
+
+	fixup = (void *)fp->aux->extable -
+		(fp->aux->num_exentries * BPF_FIXUP_LEN * 4) +
+		(ctx->exentry_idx * BPF_FIXUP_LEN * 4);
+
+	fixup[0] = PPC_RAW_LI(dst_reg, 0);
+
+	fixup[BPF_FIXUP_LEN - 1] =
+		PPC_RAW_BRANCH((long)(pc + jmp_off) - (long)&fixup[BPF_FIXUP_LEN - 1]);
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
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index 8b2ac1c27f1f..54e7cef3e1f2 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -268,7 +268,7 @@ static int bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32 o
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs)
+		       u32 *addrs, int pass)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index ad852f15ca61..ede8cb3e453f 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -297,7 +297,7 @@ asm (
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs)
+		       u32 *addrs, int pass)
 {
 	enum stf_barrier_type stf_barrier = stf_barrier_type_get();
 	const struct bpf_insn *insn = fp->insnsi;
@@ -779,12 +779,16 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 */
 		/* dst = *(u8 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
 		/* dst = *(u16 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_H:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
 		/* dst = *(u32 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_W:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
+		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
 			switch (size) {
 			case BPF_B:
 				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
@@ -802,6 +806,13 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 
 			if (size != BPF_DW && insn_is_zext(&insn[i + 1]))
 				addrs[++i] = ctx->idx * 4;
+
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				ret = bpf_add_extable_entry(fp, image, pass, ctx, ctx->idx - 1,
+							    4, dst_reg);
+				if (ret)
+					return ret;
+			}
 			break;
 
 		/*
-- 
2.31.1

