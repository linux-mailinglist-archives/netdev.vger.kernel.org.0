Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7D40FC74
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbhIQPek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:34:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235775AbhIQPeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:34:10 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HFTa2v015058;
        Fri, 17 Sep 2021 11:32:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MTuEhCIsGTVthrRwsTOMw36zUulonYolZBOt5UBNoBc=;
 b=K77eSIeOpGLH9g44QfxgsVDLm+Aq+J12og5l5AO2xBa+Lh9jbB20wfdftfb9P766JNH7
 66oIcFwIvwiid+MhuzkELGUkZ6pcvCF+bpQbZf5sxJteJjRzv/9gG2pxrW0scnS8X5Ud
 A4l7XPaFa1UX42xBUTyoKny1h36gbZ9OXsoB13ZA+wFdpDd+N45Hicw7YXPvUDeGJeuA
 TUUc/xMQtw9FgqdYE42OajmPnY7bjCqialryNWGh3weZiTMA6oHjJXGEJaS56x11P6LO
 miZRwkfoTtYU1k0RQlQoALv5gNhWEm0DibWA54d8Lo5AVugk8LqftLNmGAaj6fOAg+CE rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4r0cresk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:32:13 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HFTd2B015312;
        Fri, 17 Sep 2021 11:32:12 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4r0crer0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:32:12 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFH6wG025481;
        Fri, 17 Sep 2021 15:32:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b0kqkp2qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:32:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFRQvb57540954
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:27:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE49E11C050;
        Fri, 17 Sep 2021 15:32:04 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E244A11C066;
        Fri, 17 Sep 2021 15:31:59 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:31:59 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v2 5/8] bpf ppc64: Add BPF_PROBE_MEM support for JIT
Date:   Fri, 17 Sep 2021 21:00:44 +0530
Message-Id: <20210917153047.177141-6-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917153047.177141-1-hbathini@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a1e4C-bT3nebIfe-wh_VaC5v6mQnEm6J
X-Proofpoint-GUID: 3IWy-l-tg_vIZypHsk5vxqKz7AEQnjqK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 adultscore=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109030001 definitions=main-2109170096
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
---

Changes in v2:
* Used JITing code after refactoring.
* Replaced 'xor reg,reg,reg' with 'li reg,0' where appropriate.
* Avoided unnecessary init during declaration.


 arch/powerpc/net/bpf_jit.h        |  5 ++-
 arch/powerpc/net/bpf_jit_comp.c   | 25 ++++++++++----
 arch/powerpc/net/bpf_jit_comp32.c |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c | 57 ++++++++++++++++++++++++++++++-
 4 files changed, 80 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 0c8f885b8f48..6357c71c26eb 100644
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
index c5c9e8ad1de7..e92bd79d3bac 100644
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
 	bpf_jit_binary_lock_ro(bpf_hdr);
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index c8ae14c316e3..94641b7be387 100644
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
index 78b28f25555c..2fc10995f243 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -270,9 +270,54 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	/* out: */
 }
 
+/*
+ * The caller should check for (BPF_MODE(code) == BPF_PROBE_MEM) before calling
+ * this function, as this only applies to BPF_PROBE_MEM, for now.
+ */
+static int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
+				 struct codegen_context *ctx, int dst_reg)
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
+	pc = (unsigned long)&image[ctx->idx - 1];
+
+	fixup = (void *)fp->aux->extable -
+		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
+		(ctx->exentry_idx * BPF_FIXUP_LEN);
+
+	fixup[0] = PPC_RAW_LI(dst_reg, 0);
+	fixup[1] = PPC_RAW_BRANCH((long)(pc + 4) - (long)&fixup[1]);
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
@@ -714,12 +759,16 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
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
@@ -737,6 +786,12 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 
 			if ((size != BPF_DW) && insn_is_zext(&insn[i + 1]))
 				addrs[++i] = ctx->idx * 4;
+
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				ret = bpf_add_extable_entry(fp, image, pass, ctx, dst_reg);
+				if (ret)
+					return ret;
+			}
 			break;
 
 		/*
-- 
2.31.1

