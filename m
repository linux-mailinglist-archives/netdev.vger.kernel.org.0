Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE6A41C356
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245690AbhI2LWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:22:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57956 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245703AbhI2LV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 07:21:56 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T8fmg9010762;
        Wed, 29 Sep 2021 07:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dchSwOImzj2zVZsSzQNfcY1QIVoq32WOvQeJfTBO9XE=;
 b=BQ2/hUixd6kL1C9TV58mxXLnepwrAOYLc84MADN+WIRPcmRKNLEHHFHfHWj99fgQRj5q
 vMm6Lj5HZWx5YI5iJpRWN1pdA0dNJQeXDOIevn2A6+cCo4XBdZlLq5dogywDvNCW2HUH
 NdeA/AaicQCjLWhJroQWNHSGuok/+/0SUyHzN46jWIhEJx4XaYedGdFxoQ9DnShYwNo8
 UZvCXdxJAGj3/+pc/sUxFsh40vUlZjSnmpNrDLq3CoSXgisDPgULKz0xGOx1GQkXUA6I
 nHUWNDI0DFTmwPJxsZiIfnV6dFGaz5eLVen4sI8wxJycBgPUXY7z+g9g7EGFn94F7Y5n CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bcmusk6wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:48 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18TAQ6n8017601;
        Wed, 29 Sep 2021 07:19:47 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bcmusk6vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 07:19:47 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18TBDSEb010243;
        Wed, 29 Sep 2021 11:19:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3b9u1jq80t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Sep 2021 11:19:45 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18TBEdn059703746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 11:14:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 529094206C;
        Wed, 29 Sep 2021 11:19:42 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B452142078;
        Wed, 29 Sep 2021 11:19:37 +0000 (GMT)
Received: from hbathini-workstation.ibm.com.com (unknown [9.43.83.199])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 29 Sep 2021 11:19:37 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, ast@kernel.org, daniel@iogearbox.net
Cc:     paulus@samba.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Hari Bathini <hbathini@linux.ibm.com>
Subject: [PATCH v4 7/8] bpf ppc32: Add BPF_PROBE_MEM support for JIT
Date:   Wed, 29 Sep 2021 16:48:54 +0530
Message-Id: <20210929111855.50254-8-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929111855.50254-1-hbathini@linux.ibm.com>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zk4Lsv5miGvA5eZVNpHWcXprW--SOOxb
X-Proofpoint-ORIG-GUID: w062SnMyNXIyaXYXIbDajR4gacM6huQd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-29_04,2021-09-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290068
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

Changes in v4:
* Dropped explicit fallthrough statement for empty switch cases.


 arch/powerpc/net/bpf_jit.h        |  4 ++++
 arch/powerpc/net/bpf_jit_comp.c   |  2 ++
 arch/powerpc/net/bpf_jit_comp32.c | 30 ++++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit.h b/arch/powerpc/net/bpf_jit.h
index 561689a2abdf..800734056200 100644
--- a/arch/powerpc/net/bpf_jit.h
+++ b/arch/powerpc/net/bpf_jit.h
@@ -144,7 +144,11 @@ struct codegen_context {
 	unsigned int exentry_idx;
 };
 
+#ifdef CONFIG_PPC32
+#define BPF_FIXUP_LEN	3 /* Three instructions => 12 bytes */
+#else
 #define BPF_FIXUP_LEN	2 /* Two instructions => 8 bytes */
+#endif
 
 static inline void bpf_flush_icache(void *start, void *end)
 {
diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index f02457c6b54f..1a0041997050 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -297,6 +297,8 @@ int bpf_add_extable_entry(struct bpf_prog *fp, u32 *image, int pass, struct code
 		(ctx->exentry_idx * BPF_FIXUP_LEN * 4);
 
 	fixup[0] = PPC_RAW_LI(dst_reg, 0);
+	if (IS_ENABLED(CONFIG_PPC32))
+		fixup[1] = PPC_RAW_LI(dst_reg - 1, 0); /* clear higher 32-bit register too */
 
 	fixup[BPF_FIXUP_LEN - 1] =
 		PPC_RAW_BRANCH((long)(pc + jmp_off) - (long)&fixup[BPF_FIXUP_LEN - 1]);
diff --git a/arch/powerpc/net/bpf_jit_comp32.c b/arch/powerpc/net/bpf_jit_comp32.c
index c04291517a7e..6ee13a09c70d 100644
--- a/arch/powerpc/net/bpf_jit_comp32.c
+++ b/arch/powerpc/net/bpf_jit_comp32.c
@@ -811,9 +811,13 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 		 * BPF_LDX
 		 */
 		case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + off) */
+		case BPF_LDX | BPF_PROBE_MEM | BPF_B:
 		case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
+		case BPF_LDX | BPF_PROBE_MEM | BPF_H:
 		case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
+		case BPF_LDX | BPF_PROBE_MEM | BPF_W:
 		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
+		case BPF_LDX | BPF_PROBE_MEM | BPF_DW:
 			switch (size) {
 			case BPF_B:
 				EMIT(PPC_RAW_LBZ(dst_reg, src_reg, off));
@@ -832,6 +836,32 @@ int bpf_jit_build_body(struct bpf_prog *fp, u32 *image, struct codegen_context *
 
 			if (size != BPF_DW && !fp->aux->verifier_zext)
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
+				 * emitted for BPF_B/H/W case. So, set ex->insn to the
+				 * instruction that could fault and skip over both
+				 * instructions.
+				 */
+				if (size == BPF_DW || !fp->aux->verifier_zext) {
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
-- 
2.31.1

