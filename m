Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72981474463
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhLNOE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbhLNOEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 09:04:24 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23335C06173F;
        Tue, 14 Dec 2021 06:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=AndMJtNBDj/DfCGwsjr0dZYv5SJb1l3y/jbvjwJTRuM=; b=vuJgLZzkIPGRx8uvy4uHmvv+t+
        JAuAed32KX+XXASY22CkEQw7s/stenI4Sxseu/ZFxZS+xdCrD0u8TwlCT/JipBqpW/9BO7Cv3Bo4O
        U/Y8YRlTiVzSJKO0m5yhSfes7NuUwLnSW8C8/RiWV8weDVcJq/RNiTpC+2z+qcbtwK029egamqwRi
        17LwsB4kikmCFzjNXeMdfl9p65ohy6SeAhHoc5DpwTNC+bH4+ObEWS1SMoioaIFrLYPl7y78n1LHK
        aZVkgiucAj0eiYD2hVCnJVqY3TQ3Ih/QF8YjeAvgMZjqhX+liHptQfXCMnmepm2EPaLWjXLyQzvvn
        QuM5NFqA==;
Received: from [2001:4bb8:180:a1c8:4ccb:3bf7:77a2:141f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx8PY-00DlVL-UQ; Tue, 14 Dec 2021 14:04:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 3/4] bpf, docs: Only document eBPF in instruction-set.rst
Date:   Tue, 14 Dec 2021 15:04:01 +0100
Message-Id: <20211214140402.288101-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211214140402.288101-1-hch@lst.de>
References: <20211214140402.288101-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turn instruction-set.rst into a documentation purely for eBPF and
drop the bits that try to explain classic BPF in the same flow.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/bpf/instruction-set.rst | 125 +++++++++++---------------
 1 file changed, 54 insertions(+), 71 deletions(-)

diff --git a/Documentation/bpf/instruction-set.rst b/Documentation/bpf/instruction-set.rst
index fa5eaaf7d27c3..3967842e00234 100644
--- a/Documentation/bpf/instruction-set.rst
+++ b/Documentation/bpf/instruction-set.rst
@@ -22,9 +22,8 @@ necessary across calls.
 eBPF opcode encoding
 ====================
 
-eBPF is reusing most of the opcode encoding from classic to simplify conversion
-of classic BPF to eBPF. For arithmetic and jump instructions the 8-bit 'code'
-field is divided into three parts::
+For arithmetic and jump instructions the 8-bit 'opcode' field is divided into
+three parts::
 
   +----------------+--------+--------------------+
   |   4 bits       |  1 bit |   3 bits           |
@@ -34,39 +33,29 @@ field is divided into three parts::
 
 Three LSB bits store instruction class which is one of:
 
-  ===================     ===============
-  Classic BPF classes     eBPF classes
-  ===================     ===============
-  BPF_LD    0x00          BPF_LD    0x00
-  BPF_LDX   0x01          BPF_LDX   0x01
-  BPF_ST    0x02          BPF_ST    0x02
-  BPF_STX   0x03          BPF_STX   0x03
-  BPF_ALU   0x04          BPF_ALU   0x04
-  BPF_JMP   0x05          BPF_JMP   0x05
-  BPF_RET   0x06          BPF_JMP32 0x06
-  BPF_MISC  0x07          BPF_ALU64 0x07
-  ===================     ===============
+  ========= =====
+  class     value
+  ========= =====
+  BPF_LD    0x00
+  BPF_LDX   0x01
+  BPF_ST    0x02
+  BPF_STX   0x03
+  BPF_ALU   0x04
+  BPF_JMP   0x05
+  BPF_JMP32 0x06
+  BPF_ALU64 0x07
+  ========= =====
 
 When BPF_CLASS(code) == BPF_ALU or BPF_JMP, 4th bit encodes source operand ...
 
-    ::
-
-	BPF_K     0x00
-	BPF_X     0x08
-
- * in classic BPF, this means::
-
-	BPF_SRC(code) == BPF_X - use register X as source operand
-	BPF_SRC(code) == BPF_K - use 32-bit immediate as source operand
-
- * in eBPF, this means::
+::
 
-	BPF_SRC(code) == BPF_X - use 'src_reg' register as source operand
-	BPF_SRC(code) == BPF_K - use 32-bit immediate as source operand
+  BPF_K     0x00 /* use 32-bit immediate as source operand */
+  BPF_X     0x08 /* use 'src_reg' register as source operand */
 
 ... and four MSB bits store operation code.
 
-If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 [ in eBPF ], BPF_OP(code) is one of::
+If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 BPF_OP(code) is one of::
 
   BPF_ADD   0x00
   BPF_SUB   0x10
@@ -79,45 +68,43 @@ If BPF_CLASS(code) == BPF_ALU or BPF_ALU64 [ in eBPF ], BPF_OP(code) is one of::
   BPF_NEG   0x80
   BPF_MOD   0x90
   BPF_XOR   0xa0
-  BPF_MOV   0xb0  /* eBPF only: mov reg to reg */
-  BPF_ARSH  0xc0  /* eBPF only: sign extending shift right */
-  BPF_END   0xd0  /* eBPF only: endianness conversion */
+  BPF_MOV   0xb0  /* mov reg to reg */
+  BPF_ARSH  0xc0  /* sign extending shift right */
+  BPF_END   0xd0  /* endianness conversion */
 
-If BPF_CLASS(code) == BPF_JMP or BPF_JMP32 [ in eBPF ], BPF_OP(code) is one of::
+If BPF_CLASS(code) == BPF_JMP or BPF_JMP32 BPF_OP(code) is one of::
 
   BPF_JA    0x00  /* BPF_JMP only */
   BPF_JEQ   0x10
   BPF_JGT   0x20
   BPF_JGE   0x30
   BPF_JSET  0x40
-  BPF_JNE   0x50  /* eBPF only: jump != */
-  BPF_JSGT  0x60  /* eBPF only: signed '>' */
-  BPF_JSGE  0x70  /* eBPF only: signed '>=' */
-  BPF_CALL  0x80  /* eBPF BPF_JMP only: function call */
-  BPF_EXIT  0x90  /* eBPF BPF_JMP only: function return */
-  BPF_JLT   0xa0  /* eBPF only: unsigned '<' */
-  BPF_JLE   0xb0  /* eBPF only: unsigned '<=' */
-  BPF_JSLT  0xc0  /* eBPF only: signed '<' */
-  BPF_JSLE  0xd0  /* eBPF only: signed '<=' */
-
-So BPF_ADD | BPF_X | BPF_ALU means 32-bit addition in both classic BPF
-and eBPF. There are only two registers in classic BPF, so it means A += X.
-In eBPF it means dst_reg = (u32) dst_reg + (u32) src_reg; similarly,
-BPF_XOR | BPF_K | BPF_ALU means A ^= imm32 in classic BPF and analogous
-src_reg = (u32) src_reg ^ (u32) imm32 in eBPF.
-
-Classic BPF is using BPF_MISC class to represent A = X and X = A moves.
-eBPF is using BPF_MOV | BPF_X | BPF_ALU code instead. Since there are no
-BPF_MISC operations in eBPF, the class 7 is used as BPF_ALU64 to mean
-exactly the same operations as BPF_ALU, but with 64-bit wide operands
-instead. So BPF_ADD | BPF_X | BPF_ALU64 means 64-bit addition, i.e.:
-dst_reg = dst_reg + src_reg
-
-Classic BPF wastes the whole BPF_RET class to represent a single ``ret``
-operation. Classic BPF_RET | BPF_K means copy imm32 into return register
-and perform function exit. eBPF is modeled to match CPU, so BPF_JMP | BPF_EXIT
-in eBPF means function exit only. The eBPF program needs to store return
-value into register R0 before doing a BPF_EXIT. Class 6 in eBPF is used as
+  BPF_JNE   0x50  /* jump != */
+  BPF_JSGT  0x60  /* signed '>' */
+  BPF_JSGE  0x70  /* signed '>=' */
+  BPF_CALL  0x80  /* function call */
+  BPF_EXIT  0x90  /*  function return */
+  BPF_JLT   0xa0  /* unsigned '<' */
+  BPF_JLE   0xb0  /* unsigned '<=' */
+  BPF_JSLT  0xc0  /* signed '<' */
+  BPF_JSLE  0xd0  /* signed '<=' */
+
+So BPF_ADD | BPF_X | BPF_ALU means::
+
+  dst_reg = (u32) dst_reg + (u32) src_reg;
+
+Similarly, BPF_XOR | BPF_K | BPF_ALU means::
+
+  src_reg = (u32) src_reg ^ (u32) imm32
+
+eBPF is using BPF_MOV | BPF_X | BPF_ALU to represent A = B moves.  BPF_ALU64
+is used to mean exactly the same operations as BPF_ALU, but with 64-bit wide
+operands instead. So BPF_ADD | BPF_X | BPF_ALU64 means 64-bit addition, i.e.::
+
+  dst_reg = dst_reg + src_reg
+
+BPF_JMP | BPF_EXIT means function exit only. The eBPF program needs to store
+the return value into register R0 before doing a BPF_EXIT. Class 6 is used as
 BPF_JMP32 to mean exactly the same operations as BPF_JMP, but with 32-bit wide
 operands for the comparisons instead.
 
@@ -136,29 +123,27 @@ Size modifier is one of ...
   BPF_W   0x00    /* word */
   BPF_H   0x08    /* half word */
   BPF_B   0x10    /* byte */
-  BPF_DW  0x18    /* eBPF only, double word */
+  BPF_DW  0x18    /* double word */
 
 ... which encodes size of load/store operation::
 
  B  - 1 byte
  H  - 2 byte
  W  - 4 byte
- DW - 8 byte (eBPF only)
+ DW - 8 byte
 
 Mode modifier is one of::
 
-  BPF_IMM     0x00  /* used for 32-bit mov in classic BPF and 64-bit in eBPF */
+  BPF_IMM     0x00  /* used for 64-bit mov */
   BPF_ABS     0x20
   BPF_IND     0x40
   BPF_MEM     0x60
-  BPF_LEN     0x80  /* classic BPF only, reserved in eBPF */
-  BPF_MSH     0xa0  /* classic BPF only, reserved in eBPF */
-  BPF_ATOMIC  0xc0  /* eBPF only, atomic operations */
+  BPF_ATOMIC  0xc0  /* atomic operations */
 
 eBPF has two non-generic instructions: (BPF_ABS | <size> | BPF_LD) and
 (BPF_IND | <size> | BPF_LD) which are used to access packet data.
 
-They had to be carried over from classic to have strong performance of
+They had to be carried over from classic BPF to have strong performance of
 socket filters running in eBPF interpreter. These instructions can only
 be used when interpreter context is a pointer to ``struct sk_buff`` and
 have seven implicit operands. Register R6 is an implicit input that must
@@ -180,7 +165,7 @@ For example::
     R0 = ntohl(*(u32 *) (((struct sk_buff *) R6)->data + src_reg + imm32))
     and R1 - R5 were scratched.
 
-Unlike classic BPF instruction set, eBPF has generic load/store operations::
+eBPF has generic load/store operations::
 
     BPF_MEM | <size> | BPF_STX:  *(size *) (dst_reg + off) = src_reg
     BPF_MEM | <size> | BPF_ST:   *(size *) (dst_reg + off) = imm32
@@ -235,5 +220,3 @@ zero.
 eBPF has one 16-byte instruction: ``BPF_LD | BPF_DW | BPF_IMM`` which consists
 of two consecutive ``struct bpf_insn`` 8-byte blocks and interpreted as single
 instruction that loads 64-bit immediate value into a dst_reg.
-Classic BPF has similar instruction: ``BPF_LD | BPF_W | BPF_IMM`` which loads
-32-bit immediate value into a register.
-- 
2.30.2

