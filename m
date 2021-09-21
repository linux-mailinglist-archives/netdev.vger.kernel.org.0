Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CF3413421
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 15:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhIUNcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 09:32:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6912 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233196AbhIUNcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 09:32:32 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LCGeXY010400;
        Tue, 21 Sep 2021 09:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=jae7xOny31uYhRTB71750vBsBJ3WdyAzGbsamm6xgOY=;
 b=pTEcQA53kKCY0wJrVARhLU4lbdmW4L1hPUEvyNRwwl/6b2/a/Xfe2RwqmvAFsoej7b2z
 PEXj7J7CZ2UaffNhxgXlG3kMtc/RzjThleoXinCx+aIserM+vHabVx2nAdoFmZUNWxQ9
 NdN2TxlZWu6+BouRTt9UHr0y9Hhj+4fL03/1FQBz8Q3NYW4lE/RowCwiS0PUHsAFMtKf
 OJjmZnxSuU9tGu9v/wO2FBBcLTdGQaLcPPeLzS2eCuOEpWDXdF1so6VO/ihNQb/r1jQD
 hRDGljNqc5U3N8JhDDG5Mff7kPFtCz6QasjGfDC4yUCwxH3tvIxVRXusp2Jp9jKllnfk hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7e4ruuwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:30:27 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18LCO5l9012635;
        Tue, 21 Sep 2021 09:30:27 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b7e4ruuuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 09:30:26 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18LDNCa0014615;
        Tue, 21 Sep 2021 13:30:23 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cjmf61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 13:30:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18LDUJM758130836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Sep 2021 13:30:19 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46EA54C05C;
        Tue, 21 Sep 2021 13:30:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6788F4C071;
        Tue, 21 Sep 2021 13:30:14 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.117.91])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Sep 2021 13:30:14 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v3 5/8] bpf ppc64: Add BPF_PROBE_MEM support for JIT
Date:   Tue, 21 Sep 2021 18:59:40 +0530
Message-Id: <20210921132943.489732-6-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210921132943.489732-1-hbathini@linux.ibm.com>
References: <20210921132943.489732-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ia312Jg_hbnV1yLU-md3NqltIh3PaaPI
X-Proofpoint-ORIG-GUID: k3VopPwrDwaqxkFAu-Z6QC3ZY0U8F-kE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-21_01,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109210082
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

Changes in v3:
* Made all changes for bpf_add_extable_entry() in this patch instead
  of updating it again in patch #7.
* Fixed a coding style issue.


 arch/powerpc/net/bpf_jit.h        |  8 +++-
 arch/powerpc/net/bpf_jit_comp.c   | 70 ++++++++++++++++++++++++++++---
 arch/powerpc/net/bpf_jit_comp32.c |  2 +-
 arch/powerpc/net/bpf_jit_comp64.c | 17 +++++++-
 4 files changed, 88 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 0c8f885b8f48..561689a2abdf 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -141,8 +141,11 @@ struct codegen_context {
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
@@ -166,11 +169,14 @@ static inline void bpf_clear_seen_register(struct codegen_context *ctx, int i)
 
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
index c5c9e8ad1de7..f02457c6b54f 100644
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
 
@@ -210,7 +217,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
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
@@ -234,7 +245,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
 	fp->bpf_func = (void *)image;
 	fp->jited = 1;
-	fp->jited_len = alloclen;
+	fp->jited_len = proglen + FUNCTION_DESCR_SIZE;
 
 	bpf_flush_icache(bpf_hdr, (u8 *)bpf_hdr + (bpf_hdr->pages * PAGE_SIZE));
 	bpf_jit_binary_lock_ro(bpf_hdr);
@@ -258,3 +269,50 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
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
index 6e4956cd52e7..820c7848434e 100644
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
index 991eb43d4cd2..506934c13ef7 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -272,7 +272,7 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
-		       u32 *addrs)
+		       u32 *addrs, int pass)
 {
 	const struct bpf_insn *insn = fp->insnsi;
 	int flen = fp->len;
@@ -718,14 +718,22 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		/* dst = *(u8 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_B:
 			fallthrough;
+		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
+			fallthrough;
 		/* dst = *(u16 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_H:
 			fallthrough;
+		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
+			fallthrough;
 		/* dst = *(u32 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_W:
 			fallthrough;
+		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
+			fallthrough;
 		/* dst = *(u64 *)(ul) (src + off) */
 		case BPF_LDX | BPF_MEM | BPF_DW:
+			fallthrough;
+		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
 			switch (size) {
 			case BPF_B:
 				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
@@ -749,6 +757,13 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 
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

