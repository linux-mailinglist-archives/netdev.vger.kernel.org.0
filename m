Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C4526D722
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgIQIti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIQItd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:49:33 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9BCC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:49:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q13so2124800ejo.9
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 01:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZD6uiMISg/fpcyTy88cLwJ4vqsBUwMi3b4vpK88cUM=;
        b=kFhLAcUMkbF4edZ9eKREh3+VZQMUJqW2YJ+W+d+1k5RC4KmEycQqotxAqYVrui1zOu
         MJurHSUWV1vZlmxaqTPDpScrPArADgfONJE4ONU+wHD27zlesJH7APjnnNeL5Hyu8WCh
         C4fAqUlrVL5xqk0pz3tov56HVHYZmf5VCIdsjY2I5SB8pvcSOCrGAb17Do3/DLu50IPO
         mQldNKHsLCwdf3fv8ko9VHUai0K1tzD0WXJCags87pS/U9JC0JbwOg9o7zo0OqlVM/9s
         H5HLr6QwoggBU4u78jV79dGO5WzBVs+WlIm8sXgNUkULCC9AM+0lmKxwzf4BSrjqA0u2
         Zkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/ZD6uiMISg/fpcyTy88cLwJ4vqsBUwMi3b4vpK88cUM=;
        b=S3cumbQPj7NqEW3d07dW/b/McvYsdE+rgrMB3bbfZHurU3rFkp+Y/zXD+A/rBJtjdq
         TfmDCQDtLb5WEnxcX073Ggf7+tR0Vac0cPrhS/FYVWiITC28z63j/QtI3H//xXjo/JE7
         QBXlWkA+a02alQZ6CH/HMAlc+bN9SJ6Il+L2uQIkmK6UOAYdudywA9Tc/uiLNZzm8LXD
         TqO+qVHdl7bHgBKcjfppyD4ZShhJyH/m0p/JIfaYRu0yXxWZczCFu3j22GsMpM7OCD0x
         p+Xcps/k/RP3e+atCsc9ojgOv21l5SWEfLP6/9PlKx6wnIjqK2WFm6+UnuVK9bdICKjq
         KLYg==
X-Gm-Message-State: AOAM5330WSV7xu2wtUsz80DIUK6MU/zMEASHAot7peqRtN/vtKF1xmuz
        2oH86tlbCAoNz8Za1oicpARyqA==
X-Google-Smtp-Source: ABdhPJyNRfp0OtisgQ1SdFHWwaIMZS2PexUPwtv9uoGERRa6Db+PA/QE5xxnZ7iO6FUZ0pih+rf/PA==
X-Received: by 2002:a17:906:52c2:: with SMTP id w2mr30212544ejn.389.1600332570250;
        Thu, 17 Sep 2020 01:49:30 -0700 (PDT)
Received: from apalos.home ([2a02:587:4615:c071:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id y24sm15822393eds.35.2020.09.17.01.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 01:49:29 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     bpf@vger.kernel.org
Cc:     ardb@kernel.org, naresh.kamboju@linaro.org, xi.wang@gmail.com,
        luke.r.nels@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] arm64: bpf: Fix branch offset in JIT
Date:   Thu, 17 Sep 2020 11:49:25 +0300
Message-Id: <20200917084925.177348-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running the eBPF test_verifier leads to random errors looking like this:

[ 6525.735488] Unexpected kernel BRK exception at EL1
[ 6525.735502] Internal error: ptrace BRK handler: f2000100 [#1] SMP
[ 6525.741609] Modules linked in: nls_utf8 cifs libdes libarc4 dns_resolver fscache binfmt_misc nls_ascii nls_cp437 vfat fat aes_ce_blk crypto_simd cryptd aes_ce_cipher ghash_ce gf128mul efi_pstore sha2_ce sha256_arm64 sha1_ce evdev efivars efivarfs ip_tables x_tables autofs4 btrfs blake2b_generic xor xor_neon zstd_compress raid6_pq libcrc32c crc32c_generic ahci xhci_pci libahci xhci_hcd igb libata i2c_algo_bit nvme realtek usbcore nvme_core scsi_mod t10_pi netsec mdio_devres of_mdio gpio_keys fixed_phy libphy gpio_mb86s7x
[ 6525.787760] CPU: 3 PID: 7881 Comm: test_verifier Tainted: G        W         5.9.0-rc1+ #47
[ 6525.796111] Hardware name: Socionext SynQuacer E-series DeveloperBox, BIOS build #1 Jun  6 2020
[ 6525.804812] pstate: 20000005 (nzCv daif -PAN -UAO BTYPE=--)
[ 6525.810390] pc : bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
[ 6525.815613] lr : bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
[ 6525.820832] sp : ffff8000130cbb80
[ 6525.824141] x29: ffff8000130cbbb0 x28: 0000000000000000
[ 6525.829451] x27: 000005ef6fcbf39b x26: 0000000000000000
[ 6525.834759] x25: ffff8000130cbb80 x24: ffff800011dc7038
[ 6525.840067] x23: ffff8000130cbd00 x22: ffff0008f624d080
[ 6525.845375] x21: 0000000000000001 x20: ffff800011dc7000
[ 6525.850682] x19: 0000000000000000 x18: 0000000000000000
[ 6525.855990] x17: 0000000000000000 x16: 0000000000000000
[ 6525.861298] x15: 0000000000000000 x14: 0000000000000000
[ 6525.866606] x13: 0000000000000000 x12: 0000000000000000
[ 6525.871913] x11: 0000000000000001 x10: ffff8000000a660c
[ 6525.877220] x9 : ffff800010951810 x8 : ffff8000130cbc38
[ 6525.882528] x7 : 0000000000000000 x6 : 0000009864cfa881
[ 6525.887836] x5 : 00ffffffffffffff x4 : 002880ba1a0b3e9f
[ 6525.893144] x3 : 0000000000000018 x2 : ffff8000000a4374
[ 6525.898452] x1 : 000000000000000a x0 : 0000000000000009
[ 6525.903760] Call trace:
[ 6525.906202]  bpf_prog_c3d01833289b6311_F+0xc8/0x9f4
[ 6525.911076]  bpf_prog_d53bb52e3f4483f9_F+0x38/0xc8c
[ 6525.915957]  bpf_dispatcher_xdp_func+0x14/0x20
[ 6525.920398]  bpf_test_run+0x70/0x1b0
[ 6525.923969]  bpf_prog_test_run_xdp+0xec/0x190
[ 6525.928326]  __do_sys_bpf+0xc88/0x1b28
[ 6525.932072]  __arm64_sys_bpf+0x24/0x30
[ 6525.935820]  el0_svc_common.constprop.0+0x70/0x168
[ 6525.940607]  do_el0_svc+0x28/0x88
[ 6525.943920]  el0_sync_handler+0x88/0x190
[ 6525.947838]  el0_sync+0x140/0x180
[ 6525.951154] Code: d4202000 d4202000 d4202000 d4202000 (d4202000)
[ 6525.957249] ---[ end trace cecc3f93b14927e2 ]---

The reason is the offset[] creation and later usage, while building
the eBPF body. The code currently omits the first instruction, since
build_insn() will increase our ctx->idx before saving it.
That was fine up until bounded eBPF loops were introduced. After that
introduction, offset[0] must be the offset of the end of prologue which
is the start of the 1st insn while, offset[n] holds the
offset of the end of n-th insn.

When "taken loop with back jump to 1st insn" test runs, it will
eventually call bpf2a64_offset(-1, 2, ctx). Since negative indexing is
permitted, the current outcome depends on the value stored in
ctx->offset[-1], which has nothing to do with our array.
If the value happens to be 0 the tests will work. If not this error
triggers.

commit 7c2e988f400e ("bpf: fix x64 JIT code generation for jmp to 1st insn")
fixed an indentical bug on x86 when eBPF bounded loops were introduced.

So let's fix it by creating the ctx->offset[] differently. Track the
beginning of instruction and account for the extra instruction while
calculating the arm instruction offsets.

Fixes: 2589726d12a1 ("bpf: introduce bounded loops")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Jiri Olsa <jolsa@kernel.org>
Co-developed-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Co-developed-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
Changes since v1: 
 - Added Co-developed-by, Reported-by and Fixes tags correctly
 - Describe the expected context of ctx->offset[] in comments
Changes since v2:
 - Drop the change of behavior for 16-byte eBPF instructions. This won't
 currently cause any problems and can go in on a different patch
 - simplify bpf2a64_offset()

 arch/arm64/net/bpf_jit_comp.c | 43 +++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f8912e45be7a..ef9f1d5e989d 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -143,14 +143,17 @@ static inline void emit_addr_mov_i64(const int reg, const u64 val,
 	}
 }
 
-static inline int bpf2a64_offset(int bpf_to, int bpf_from,
+static inline int bpf2a64_offset(int bpf_insn, int off,
 				 const struct jit_ctx *ctx)
 {
-	int to = ctx->offset[bpf_to];
-	/* -1 to account for the Branch instruction */
-	int from = ctx->offset[bpf_from] - 1;
-
-	return to - from;
+	/* BPF JMP offset is relative to the next instruction */
+	bpf_insn++;
+	/*
+	 * Whereas arm64 branch instructions encode the offset
+	 * from the branch itself, so we must subtract 1 from the
+	 * instruction offset.
+	 */
+	return ctx->offset[bpf_insn + off] - (ctx->offset[bpf_insn] - 1);
 }
 
 static void jit_fill_hole(void *area, unsigned int size)
@@ -642,7 +645,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
-		jmp_offset = bpf2a64_offset(i + off, i, ctx);
+		jmp_offset = bpf2a64_offset(i, off, ctx);
 		check_imm26(jmp_offset);
 		emit(A64_B(jmp_offset), ctx);
 		break;
@@ -669,7 +672,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP32 | BPF_JSLE | BPF_X:
 		emit(A64_CMP(is64, dst, src), ctx);
 emit_cond_jmp:
-		jmp_offset = bpf2a64_offset(i + off, i, ctx);
+		jmp_offset = bpf2a64_offset(i, off, ctx);
 		check_imm19(jmp_offset);
 		switch (BPF_OP(code)) {
 		case BPF_JEQ:
@@ -908,10 +911,21 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 	const struct bpf_prog *prog = ctx->prog;
 	int i;
 
+	/*
+	 * - offset[0] offset of the end of prologue,
+	 *   start of the 1st instruction.
+	 * - offset[1] - offset of the end of 1st instruction,
+	 *   start of the 2nd instruction
+	 * [....]
+	 * - offset[3] - offset of the end of 3rd instruction,
+	 *   start of 4th instruction
+	 */
 	for (i = 0; i < prog->len; i++) {
 		const struct bpf_insn *insn = &prog->insnsi[i];
 		int ret;
 
+		if (ctx->image == NULL)
+			ctx->offset[i] = ctx->idx;
 		ret = build_insn(insn, ctx, extra_pass);
 		if (ret > 0) {
 			i++;
@@ -919,11 +933,16 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 				ctx->offset[i] = ctx->idx;
 			continue;
 		}
-		if (ctx->image == NULL)
-			ctx->offset[i] = ctx->idx;
 		if (ret)
 			return ret;
 	}
+	/*
+	 * offset is allocated with prog->len + 1 so fill in
+	 * the last element with the offset after the last
+	 * instruction (end of program)
+	 */
+	if (ctx->image == NULL)
+		ctx->offset[i] = ctx->idx;
 
 	return 0;
 }
@@ -1002,7 +1021,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	memset(&ctx, 0, sizeof(ctx));
 	ctx.prog = prog;
 
-	ctx.offset = kcalloc(prog->len, sizeof(int), GFP_KERNEL);
+	ctx.offset = kcalloc(prog->len + 1, sizeof(int), GFP_KERNEL);
 	if (ctx.offset == NULL) {
 		prog = orig_prog;
 		goto out_off;
@@ -1089,7 +1108,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	prog->jited_len = prog_size;
 
 	if (!prog->is_func || extra_pass) {
-		bpf_prog_fill_jited_linfo(prog, ctx.offset);
+		bpf_prog_fill_jited_linfo(prog, ctx.offset + 1);
 out_off:
 		kfree(ctx.offset);
 		kfree(jit_data);
-- 
2.28.0

