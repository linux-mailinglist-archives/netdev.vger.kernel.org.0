Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8617540FC78
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242055AbhIQPeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 11:34:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241883AbhIQPeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 11:34:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HEseHG010187;
        Fri, 17 Sep 2021 11:32:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TE3t/C7KhZzf68MPy8xUct0IQvYhU6J6809lQcjuIyY=;
 b=r5CXO9fDwUnlpLrk6afreAjqZNLO2u82p7u2x0lDFa+xQdmVEDGybRyBdJO9Oh9CNLHo
 lPZPiHL7UtxjGl30t9BRd7QIw2byA7PMgOi53dFR5zJh7AQ2HDbWGWIQa7VlTMo8wZgn
 5D5QXav9v2HbcYcvnTKBBvIX3e2ppF8XVr+le8FBSWZ0jPMMlfa1MJVRws5hY5ZEgxfP
 dyeIw8fR+lIyjnH05YUc6Tu0bjHzlhfpiEAvVhKdzcWz6HaAWiO2JAPy9iDRZZkS99oe
 TTHjvWu48D7cQSdiaOQZ1tu1NPa2lzp+rww4v0iqh7MbLtggukL5/fEs6JctlkCUhx/J Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4huk17wp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:32:25 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HEsfJN010323;
        Fri, 17 Sep 2021 11:32:24 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b4huk17vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 11:32:24 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HFGt51028503;
        Fri, 17 Sep 2021 15:32:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3b0m3ae1dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 15:32:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HFRd7U47513892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 15:27:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D57711C071;
        Fri, 17 Sep 2021 15:32:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B692B11C077;
        Fri, 17 Sep 2021 15:32:13 +0000 (GMT)
Received: from hbathini-workstation.ibm.com (unknown [9.43.59.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 15:32:13 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, mpe@ellerman.id.au, ast@kernel.org,
        daniel@iogearbox.net
Cc:     christophe.leroy@csgroup.eu, paulus@samba.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v2 7/8] bpf ppc32: Add BPF_PROBE_MEM support for JIT
Date:   Fri, 17 Sep 2021 21:00:46 +0530
Message-Id: <20210917153047.177141-8-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917153047.177141-1-hbathini@linux.ibm.com>
References: <20210917153047.177141-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Yl90I_xeBxdp3p9-hQwTbgj6aqTcwmlE
X-Proofpoint-GUID: IlhxP-ZOvblwvvStKlIXvj_KG7m0nvqw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_06,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF load instruction with BPF_PROBE_MEM mode can cause a fault
inside kernel. Append exception table for such instructions
within BPF program.

Unlike other archs which uses extable 'fixup' field to pass dest_reg
and nip, BPF exception table on PowerPC follows the generic PowerPC
exception table design, where it populates both fixup and extable
sections within BPF program. fixup section contains 3 instructions,
first 2 instructions clear dest_reg (lower & higher 32-bit registers)
and last instruction jumps to next instruction in the BPF code.
extable 'insn' field contains relative offset of the instruction and
'fixup' field contains relative offset of the fixup entry. Example
layout of BPF program with extable present:

             +------------------+
             |                  |
             |                  |
   0x4020 -->| lwz   r28,4(r4)  |
             |                  |
             |                  |
   0x40ac -->| lwz  r3,0(r24)   |
             | lwz  r4,4(r24)   |
             |                  |
             |                  |
             |------------------|
   0x4278 -->| li  r28,0        |  \
             | li  r27,0        |  | fixup entry
             | b   0x4024       |  /
   0x4284 -->| li  r4,0         |
             | li  r3,0         |
             | b   0x40b4       |
             |------------------|
   0x4290 -->| insn=0xfffffd90  |  \ extable entry
             | fixup=0xffffffe4 |  /
   0x4298 -->| insn=0xfffffe14  |
             | fixup=0xffffffe8 |
             +------------------+

   (Addresses shown here are chosen random, not real)

Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---

Changes in v2:
* New patch to add BPF_PROBE_MEM support for PPC32.


 arch/powerpc/net/bpf_jit.h        |  7 +++++
 arch/powerpc/net/bpf_jit_comp.c   | 50 +++++++++++++++++++++++++++++++
 arch/powerpc/net/bpf_jit_comp32.c | 30 +++++++++++++++++++
 arch/powerpc/net/bpf_jit_comp64.c | 48 ++---------------------------
 4 files changed, 89 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 6357c71c26eb..6a591ef88006 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -144,7 +144,11 @@ struct codegen_context {
 	unsigned int exentry_idx;
 };
 
+#ifdef CONFIG_PPC32
+#define BPF_FIXUP_LEN	12 /* Three instructions */
+#else
 #define BPF_FIXUP_LEN	8 /* Two instructions */
+#endif
 
 static inline void bpf_flush_icache(void *start, void *end)
 {
@@ -174,6 +178,9 @@ void bpf_jit_build_prologue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_build_epilogue(u32 *image, struct codegen_context *ctx);
 void bpf_jit_realloc_regs(struct codegen_context *ctx);
 
+int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass, struct codegen_context *ctx,
+			  int insn_idx, int jmp_off, int dst_reg);
+
 #endif
 
 #endif
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index e92bd79d3bac..a1753b8c78c8 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -271,3 +271,53 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 
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
+		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
+		(ctx->exentry_idx * BPF_FIXUP_LEN);
+
+	fixup[0] = PPC_RAW_LI(dst_reg, 0);
+#ifdef CONFIG_PPC32
+	fixup[1] = PPC_RAW_LI(dst_reg - 1, 0); /* clear higher 32-bit register too */
+	fixup[2] = PPC_RAW_BRANCH((long)(pc + jmp_off) - (long)&fixup[2]);
+#else
+	fixup[1] = PPC_RAW_BRANCH((long)(pc + jmp_off) - (long)&fixup[1]);
+#endif
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
index 94641b7be387..c6262289dcc4 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -811,12 +811,16 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
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
@@ -835,6 +839,32 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 
 			if ((size != BPF_DW) && !fp->aux->verifier_zext)
 				EMIT(PPC_RAW_LI(dst_reg_h, 0));
+
+			if (BPF_MODE(code) == BPF_PROBE_MEM) {
+				int insn_idx = ctx->idx - 1;
+				int jmp_off = 4;
+
+				/*
+				 * In case of BPF_DW, two lwz instructions are emitted, one
+				 * for higher 32-bit and another for lower 32-bit. So, set
+				 * ex->insn to the first of the two and jump over both
+				 * instructions in fixup.
+				 *
+				 * Similarly, with !verifier_zext, two instructions are
+				 * emitted for BPF_B/H/W case. So, set ex-insn to the
+				 * instruction that could fault and skip over both
+				 * instructions.
+				 */
+				if ((size == BPF_DW) || !fp->aux->verifier_zext) {
+					insn_idx -= 1;
+					jmp_off += 4;
+				}
+
+				ret = bpf_add_extable_entry(fp, image, pass, ctx, insn_idx,
+							    jmp_off, dst_reg);
+				if (ret)
+					return ret;
+			}
 			break;
 
 		/*
diff --git a/arch/powerpc/net/bpf_jit_comp64.c b/arch/powerpc/net/bpf_jit_comp64.c
index eb28dbc67151..10cc9f04843c 100644
--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -270,51 +270,6 @@ static void bpf_jit_emit_tail_call(u32 *image, struct codegen_context *ctx, u32
 	/* out: */
 }
 
-/*
- * The caller should check for (BPF_MODE(code) == BPF_PROBE_MEM) before calling
- * this function, as this only applies to BPF_PROBE_MEM, for now.
- */
-static int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass,
-				 struct codegen_context *ctx, int dst_reg)
-{
-	off_t offset;
-	unsigned long pc;
-	struct exception_table_entry *ex;
-	u32 *fixup;
-
-	/* Populate extable entries only in the last pass */
-	if (pass != 2)
-		return 0;
-
-	if (!fp->aux->extable ||
-	    WARN_ON_ONCE(ctx->exentry_idx >= fp->aux->num_exentries))
-		return -EINVAL;
-
-	pc = (unsigned long)&image[ctx->idx - 1];
-
-	fixup = (void *)fp->aux->extable -
-		(fp->aux->num_exentries * BPF_FIXUP_LEN) +
-		(ctx->exentry_idx * BPF_FIXUP_LEN);
-
-	fixup[0] = PPC_RAW_LI(dst_reg, 0);
-	fixup[1] = PPC_RAW_BRANCH((long)(pc + 4) - (long)&fixup[1]);
-
-	ex = &fp->aux->extable[ctx->exentry_idx];
-
-	offset = pc - (long)&ex->insn;
-	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
-		return -ERANGE;
-	ex->insn = offset;
-
-	offset = (long)fixup - (long)&ex->fixup;
-	if (WARN_ON_ONCE(offset >= 0 || offset < INT_MIN))
-		return -ERANGE;
-	ex->fixup = offset;
-
-	ctx->exentry_idx++;
-	return 0;
-}
-
 /* Assemble the body code between the prologue & epilogue */
 int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *ctx,
 		       u32 *addrs, int pass)
@@ -811,7 +766,8 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 				addrs[++i] = ctx->idx * 4;
 
 			if (BPF_MODE(code) == BPF_PROBE_MEM) {
-				ret = bpf_add_extable_entry(fp, image, pass, ctx, dst_reg);
+				ret = bpf_add_extable_entry(fp, image, pass, ctx, ctx->idx - 1,
+							    4, dst_reg);
 				if (ret)
 					return ret;
 			}
-- 
2.31.1

