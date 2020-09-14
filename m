Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EBF26874B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgINIg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgINIgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:36:51 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A37C06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 01:36:50 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so17713678wrx.7
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 01:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XocWBvr/wpI0xYVxfd6SkL7Z8etNiS2BwYzO/1XPVHg=;
        b=IVsQ3IuuNi2hhysVA+2+GTorRddoaCd9NLr8I554ayl2U6q4IDUEzkr1INk6XpKMJ1
         uqxB8sR8Uqq5pSNEB8kbZZzoddkojBObzgnXEXwY+Dtyne9Qxs83HhOX9FcTbwEDi8Vl
         qBl+L0gnG04GIzXYF8eeHblOyNBvxMrNg9QPBJGRC1AvcpWBnNo3QOreZxY/C51/E7Qs
         Sn8CV0llz+Pf/KtvyD5VFR/wwhM7fiaZhnp1elS1n2Adw/C1ACGXQbPPF6P0Id1ponz9
         YJQDezMhO5kR81ku/tLAQ6ZxPMN3c/fFkw/GDRtyc40D31kHwySXAVUhRWoDF5Hwa1T1
         5Alw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XocWBvr/wpI0xYVxfd6SkL7Z8etNiS2BwYzO/1XPVHg=;
        b=Y89drPe77UpD66B3A3ZRrxk/IocIPmhgyFPQGs7iPE2kGIxSdFuSfi2MKtSeX0G2FL
         lM4hDgIpnvU+ZhtXdwRZqvAFlYiFt/mLPRq6nzoMlwJnJbgZsFMpkKRGUGE0/AlTptYx
         WBVMsJjCCUr9sG1cif+qx/BY2O8eyoJII/TkHkHI2TlL9yobu2C1O3APfufawU4m+QrL
         V5mWX5WDfS9rqTm3+TsS1rA0FPi18fkaECKV+23AU5UMSineM1MJmSemSI4K4tLfU2he
         teb4eZO1V3JbbhTVfAj3IYJCeGj6wwGzkxZdLdSSHjjasoINGRKPz9VP8Qo/Hq9bMWUb
         u+Yw==
X-Gm-Message-State: AOAM531LiOtNXJonSFqBxL4JYLHKtlCmaUqFPVxBda2Pg3QmQYMuiRvl
        UPIXgYnplWaPgvlJlzYCgp2HvA==
X-Google-Smtp-Source: ABdhPJyUqOi2jNQEC2gkhbdbotbQDpErc+C5q1RJUrhpZo+s2UVOm60Lp1X2XTE+4KE2XRndSAgxXg==
X-Received: by 2002:adf:f0c7:: with SMTP id x7mr14423737wro.315.1600072609210;
        Mon, 14 Sep 2020 01:36:49 -0700 (PDT)
Received: from apalos.home ([2a02:587:4633:88b0:2e56:dcff:fe9a:8f06])
        by smtp.gmail.com with ESMTPSA id q192sm20015597wme.13.2020.09.14.01.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 01:36:48 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     bpf@vger.kernel.org
Cc:     ardb@kernel.org, naresh.kamboju@linaro.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Subject: [PATCH] arm64: bpf: Fix branch offset in JIT
Date:   Mon, 14 Sep 2020 11:36:21 +0300
Message-Id: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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

The reason seems to be the offset[] creation and usage ctx->offset[]
while building the eBPF body.  The code currently omits the first 
instruction, since build_insn() will increase our ctx->idx before saving 
it.  When "taken loop with back jump to 1st insn" test runs it will
eventually call bpf2a64_offset(-1, 2, ctx). Since negative indexing is
permitted, the current outcome depends on the value stored in
ctx->offset[-1], which has nothing to do with our array.
If the value happens to be 0 the tests will work. If not this error
triggers.

So let's fix it by creating the ctx->offset[] correctly in the first
place and account for the extra instruction while calculating the arm
instruction offsets.

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Yauheni Kaliuta <yauheni.kaliuta@redhat.com>
---
 arch/arm64/net/bpf_jit_comp.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f8912e45be7a..5891733a9f39 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -143,9 +143,13 @@ static inline void emit_addr_mov_i64(const int reg, const u64 val,
 	}
 }
 
-static inline int bpf2a64_offset(int bpf_to, int bpf_from,
+static inline int bpf2a64_offset(int bpf_insn, int off,
 				 const struct jit_ctx *ctx)
 {
+	/* arm64 offset is relative to the branch instruction */
+	int bpf_from = bpf_insn + 1;
+	/* BPF JMP offset is relative to the next instruction */
+	int bpf_to = bpf_insn + off + 1;
 	int to = ctx->offset[bpf_to];
 	/* -1 to account for the Branch instruction */
 	int from = ctx->offset[bpf_from] - 1;
@@ -642,7 +646,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 
 	/* JUMP off */
 	case BPF_JMP | BPF_JA:
-		jmp_offset = bpf2a64_offset(i + off, i, ctx);
+		jmp_offset = bpf2a64_offset(i, off, ctx);
 		check_imm26(jmp_offset);
 		emit(A64_B(jmp_offset), ctx);
 		break;
@@ -669,7 +673,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 	case BPF_JMP32 | BPF_JSLE | BPF_X:
 		emit(A64_CMP(is64, dst, src), ctx);
 emit_cond_jmp:
-		jmp_offset = bpf2a64_offset(i + off, i, ctx);
+		jmp_offset = bpf2a64_offset(i, off, ctx);
 		check_imm19(jmp_offset);
 		switch (BPF_OP(code)) {
 		case BPF_JEQ:
@@ -912,18 +916,21 @@ static int build_body(struct jit_ctx *ctx, bool extra_pass)
 		const struct bpf_insn *insn = &prog->insnsi[i];
 		int ret;
 
+		if (ctx->image == NULL)
+			ctx->offset[i] = ctx->idx;
+
 		ret = build_insn(insn, ctx, extra_pass);
 		if (ret > 0) {
 			i++;
 			if (ctx->image == NULL)
-				ctx->offset[i] = ctx->idx;
+				ctx->offset[i] = ctx->offset[i - 1];
 			continue;
 		}
-		if (ctx->image == NULL)
-			ctx->offset[i] = ctx->idx;
 		if (ret)
 			return ret;
 	}
+	if (ctx->image == NULL)
+		ctx->offset[i] = ctx->idx;
 
 	return 0;
 }
@@ -1002,7 +1009,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	memset(&ctx, 0, sizeof(ctx));
 	ctx.prog = prog;
 
-	ctx.offset = kcalloc(prog->len, sizeof(int), GFP_KERNEL);
+	ctx.offset = kcalloc(prog->len + 1, sizeof(int), GFP_KERNEL);
 	if (ctx.offset == NULL) {
 		prog = orig_prog;
 		goto out_off;
@@ -1089,7 +1096,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 	prog->jited_len = prog_size;
 
 	if (!prog->is_func || extra_pass) {
-		bpf_prog_fill_jited_linfo(prog, ctx.offset);
+		bpf_prog_fill_jited_linfo(prog, ctx.offset + 1);
 out_off:
 		kfree(ctx.offset);
 		kfree(jit_data);
-- 
2.28.0

