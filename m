Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0304378F88
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbhEJNmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:42:12 -0400
Received: from mail.loongson.cn ([114.242.206.163]:56454 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241723AbhEJMx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 08:53:28 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxH+9wLJlguH4UAA--.15168S2;
        Mon, 10 May 2021 20:52:00 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] bpf: arm64: Replace STACK_ALIGN() with round_up() to align stack size
Date:   Mon, 10 May 2021 20:51:59 +0800
Message-Id: <1620651119-5663-1-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
X-CM-TRANSID: AQAAf9DxH+9wLJlguH4UAA--.15168S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Xr4UCF1UAFy3WF4rAFWfGrg_yoWkWwb_tw
        1SkF97Gwn8CrsY9r18Ca15JryIk3ykGa4kXryagr12y343Xw4fAry09ryxur1UXr4DKFWr
        ZFs7GFy2vw42gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsxYjsxI4VWDJwAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I
        6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM2
        8CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z2
        80aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAK
        zVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr1lOx
        8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
        MxkIecxEwVAFwVW5JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s
        026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_
        Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20x
        vEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2
        jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
        ZFpf9x07j7sqXUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the common function round_up() directly to show the align size
explicitly, the function STACK_ALIGN() is needless, remove it.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f7b1948..81c380f 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -178,9 +178,6 @@ static bool is_addsub_imm(u32 imm)
 	return !(imm & ~0xfff) || !(imm & ~0xfff000);
 }
 
-/* Stack must be multiples of 16B */
-#define STACK_ALIGN(sz) (((sz) + 15) & ~15)
-
 /* Tail call offset to jump into */
 #if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
 #define PROLOGUE_OFFSET 8
@@ -255,7 +252,7 @@ static int build_prologue(struct jit_ctx *ctx, bool ebpf_from_cbpf)
 			emit(A64_BTI_J, ctx);
 	}
 
-	ctx->stack_size = STACK_ALIGN(prog->aux->stack_depth);
+	ctx->stack_size = round_up(prog->aux->stack_depth, 16);
 
 	/* Set up function call stack */
 	emit(A64_SUB_I(1, A64_SP, A64_SP, ctx->stack_size), ctx);
-- 
2.1.0

