Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A2A65B8D5
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 02:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbjACBaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 20:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjACBai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 20:30:38 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C86DCCF4;
        Mon,  2 Jan 2023 17:30:36 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NmFY31stQz4f3v4p;
        Tue,  3 Jan 2023 09:30:31 +0800 (CST)
Received: from localhost.localdomain (unknown [10.67.175.61])
        by APP3 (Coremail) with SMTP id _Ch0CgA3MR84hbNjzHakAw--.49033S2;
        Tue, 03 Jan 2023 09:30:33 +0800 (CST)
From:   Pu Lehui <pulehui@huaweicloud.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Pu Lehui <pulehui@huawei.com>,
        Pu Lehui <pulehui@huaweicloud.com>
Subject: [PATCH bpf-next] bpf, x86: Simplify the parsing logic of structure parameters
Date:   Tue,  3 Jan 2023 09:31:58 +0800
Message-Id: <20230103013158.1945869-1-pulehui@huaweicloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgA3MR84hbNjzHakAw--.49033S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JF1xCFWxZw4xWF1xWrW8Xrb_yoWxAw45pa
        nxu3WSyF4kXrsrWrZ7Xw4kXF1ayaykX347CFWrCa4fCrs8Jr95J3WrKFyFyrWYkryvyF4a
        9rn0vr95Ar1fJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
        Y2ka0xkIwI1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v2
        6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
        UdHUDUUUUU=
X-CM-SenderInfo: psxovxtxl6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

Extra_nregs of structure parameters and nr_args can be
added directly at the beginning, and using a flip flag
to identifiy structure parameters. Meantime, renaming
some variables to make them more sense.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 arch/x86/net/bpf_jit_comp.c | 99 +++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 53 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index e3e2b57e4e13..e7b72299f5a4 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1839,62 +1839,57 @@ st:			if (is_imm8(insn->off))
 	return proglen;
 }
 
-static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
+static void save_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 		      int stack_size)
 {
-	int i, j, arg_size, nr_regs;
+	int i, j, arg_size;
+	bool is_struct = false;
+
 	/* Store function arguments to stack.
 	 * For a function that accepts two pointers the sequence will be:
 	 * mov QWORD PTR [rbp-0x10],rdi
 	 * mov QWORD PTR [rbp-0x8],rsi
 	 */
-	for (i = 0, j = 0; i < min(nr_args, 6); i++) {
-		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG) {
-			nr_regs = (m->arg_size[i] + 7) / 8;
+	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
+		arg_size = m->arg_size[j];
+		if (arg_size > 8) {
 			arg_size = 8;
-		} else {
-			nr_regs = 1;
-			arg_size = m->arg_size[i];
+			is_struct ^= 1;
 		}
 
-		while (nr_regs) {
-			emit_stx(prog, bytes_to_bpf_size(arg_size),
-				 BPF_REG_FP,
-				 j == 5 ? X86_REG_R9 : BPF_REG_1 + j,
-				 -(stack_size - j * 8));
-			nr_regs--;
-			j++;
-		}
+		emit_stx(prog, bytes_to_bpf_size(arg_size),
+			 BPF_REG_FP,
+			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
+			 -(stack_size - i * 8));
+
+		j = is_struct ? j : j + 1;
 	}
 }
 
-static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_args,
+static void restore_regs(const struct btf_func_model *m, u8 **prog, int nr_regs,
 			 int stack_size)
 {
-	int i, j, arg_size, nr_regs;
+	int i, j, arg_size;
+	bool is_struct = false;
 
 	/* Restore function arguments from stack.
 	 * For a function that accepts two pointers the sequence will be:
 	 * EMIT4(0x48, 0x8B, 0x7D, 0xF0); mov rdi,QWORD PTR [rbp-0x10]
 	 * EMIT4(0x48, 0x8B, 0x75, 0xF8); mov rsi,QWORD PTR [rbp-0x8]
 	 */
-	for (i = 0, j = 0; i < min(nr_args, 6); i++) {
-		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG) {
-			nr_regs = (m->arg_size[i] + 7) / 8;
+	for (i = 0, j = 0; i < min(nr_regs, 6); i++) {
+		arg_size = m->arg_size[j];
+		if (arg_size > 8) {
 			arg_size = 8;
-		} else {
-			nr_regs = 1;
-			arg_size = m->arg_size[i];
+			is_struct ^= 1;
 		}
 
-		while (nr_regs) {
-			emit_ldx(prog, bytes_to_bpf_size(arg_size),
-				 j == 5 ? X86_REG_R9 : BPF_REG_1 + j,
-				 BPF_REG_FP,
-				 -(stack_size - j * 8));
-			nr_regs--;
-			j++;
-		}
+		emit_ldx(prog, bytes_to_bpf_size(arg_size),
+			 i == 5 ? X86_REG_R9 : BPF_REG_1 + i,
+			 BPF_REG_FP,
+			 -(stack_size - i * 8));
+
+		j = is_struct ? j : j + 1;
 	}
 }
 
@@ -2120,8 +2115,8 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 				struct bpf_tramp_links *tlinks,
 				void *func_addr)
 {
-	int ret, i, nr_args = m->nr_args, extra_nregs = 0;
-	int regs_off, ip_off, args_off, stack_size = nr_args * 8, run_ctx_off;
+	int i, ret, nr_regs = m->nr_args, stack_size = 0;
+	int regs_off, nregs_off, ip_off, run_ctx_off;
 	struct bpf_tramp_links *fentry = &tlinks[BPF_TRAMP_FENTRY];
 	struct bpf_tramp_links *fexit = &tlinks[BPF_TRAMP_FEXIT];
 	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
@@ -2130,17 +2125,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	u8 *prog;
 	bool save_ret;
 
-	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
-	if (nr_args > 6)
-		return -ENOTSUPP;
-
-	for (i = 0; i < MAX_BPF_FUNC_ARGS; i++) {
+	/* extra registers for struct arguments */
+	for (i = 0; i < m->nr_args; i++)
 		if (m->arg_flags[i] & BTF_FMODEL_STRUCT_ARG)
-			extra_nregs += (m->arg_size[i] + 7) / 8 - 1;
-	}
-	if (nr_args + extra_nregs > 6)
+			nr_regs += (m->arg_size[i] + 7) / 8 - 1;
+
+	/* x86-64 supports up to 6 arguments. 7+ can be added in the future */
+	if (nr_regs > 6)
 		return -ENOTSUPP;
-	stack_size += extra_nregs * 8;
 
 	/* Generated trampoline stack layout:
 	 *
@@ -2154,7 +2146,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	 *                 [ ...             ]
 	 * RBP - regs_off  [ reg_arg1        ]  program's ctx pointer
 	 *
-	 * RBP - args_off  [ arg regs count  ]  always
+	 * RBP - nregs_off [ regs count	     ]  always
 	 *
 	 * RBP - ip_off    [ traced function ]  BPF_TRAMP_F_IP_ARG flag
 	 *
@@ -2166,11 +2158,12 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (save_ret)
 		stack_size += 8;
 
+	stack_size += nr_regs * 8;
 	regs_off = stack_size;
 
-	/* args count  */
+	/* regs count  */
 	stack_size += 8;
-	args_off = stack_size;
+	nregs_off = stack_size;
 
 	if (flags & BPF_TRAMP_F_IP_ARG)
 		stack_size += 8; /* room for IP address argument */
@@ -2198,11 +2191,11 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	EMIT1(0x53);		 /* push rbx */
 
 	/* Store number of argument registers of the traced function:
-	 *   mov rax, nr_args + extra_nregs
-	 *   mov QWORD PTR [rbp - args_off], rax
+	 *   mov rax, nr_regs
+	 *   mov QWORD PTR [rbp - nregs_off], rax
 	 */
-	emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_args + extra_nregs);
-	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -args_off);
+	emit_mov_imm64(&prog, BPF_REG_0, 0, (u32) nr_regs);
+	emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -nregs_off);
 
 	if (flags & BPF_TRAMP_F_IP_ARG) {
 		/* Store IP address of the traced function:
@@ -2213,7 +2206,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -ip_off);
 	}
 
-	save_regs(m, &prog, nr_args, regs_off);
+	save_regs(m, &prog, nr_regs, regs_off);
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		/* arg1: mov rdi, im */
@@ -2243,7 +2236,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	}
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
-		restore_regs(m, &prog, nr_args, regs_off);
+		restore_regs(m, &prog, nr_regs, regs_off);
 
 		if (flags & BPF_TRAMP_F_ORIG_STACK) {
 			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
@@ -2284,7 +2277,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 		}
 
 	if (flags & BPF_TRAMP_F_RESTORE_REGS)
-		restore_regs(m, &prog, nr_args, regs_off);
+		restore_regs(m, &prog, nr_regs, regs_off);
 
 	/* This needs to be done regardless. If there were fmod_ret programs,
 	 * the return value is only updated on the stack and still needs to be
-- 
2.25.1

