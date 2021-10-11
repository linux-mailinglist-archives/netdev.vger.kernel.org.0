Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555FF42847E
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233097AbhJKBVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:21:25 -0400
Received: from mail.loongson.cn ([114.242.206.163]:34094 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231390AbhJKBVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 21:21:22 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9DxP2oPkWNh8sYXAA--.22187S4;
        Mon, 11 Oct 2021 09:19:14 +0800 (CST)
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Paul Burton <paulburton@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH bpf-next v2 2/2] bpf, mips: Fix comment on tail call count limiting
Date:   Mon, 11 Oct 2021 09:19:10 +0800
Message-Id: <1633915150-13220-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
References: <1633915150-13220-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9DxP2oPkWNh8sYXAA--.22187S4
X-Coremail-Antispam: 1UD129KBjvdXoW7XrW5CFWfGr1rAr13Xr4xZwb_yoWDXFcEqF
        1Iyan7twnYqry5Aw43ur1rtFn5C345CF1xZFs29F42y390ya1rJFZYqry8Z3sxWr4qvrW5
        Xr1kG34S9ayIgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbyAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXwA2048vs2IY02
        0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
        8EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
        M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
        v20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4U
        M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
        kIc2xKxwCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8
        JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1V
        AFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xII
        jxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4
        A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU
        0xZFpf9x0JUZzVbUUUUU=
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In emit_tail_call() of bpf_jit_comp32.c, "blez t2" (t2 <= 0) is
not consistent with the comment "t2 < 0", update the comment to
keep consistency.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/mips/net/bpf_jit_comp32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/net/bpf_jit_comp32.c b/arch/mips/net/bpf_jit_comp32.c
index 9d7041a..bd996ed 100644
--- a/arch/mips/net/bpf_jit_comp32.c
+++ b/arch/mips/net/bpf_jit_comp32.c
@@ -1315,7 +1315,7 @@ static int emit_tail_call(struct jit_context *ctx)
 	/* if (TCC-- <= 0) goto out */
 	emit(ctx, lw, t2, ctx->stack_size, MIPS_R_SP);  /* t2 = *(SP + size) */
 	emit_load_delay(ctx);                     /* Load delay slot         */
-	emit(ctx, blez, t2, get_offset(ctx, 1));  /* PC += off(1) if t2 < 0  */
+	emit(ctx, blez, t2, get_offset(ctx, 1));  /* PC += off(1) if t2 <= 0 */
 	emit(ctx, addiu, t2, t2, -1);             /* t2-- (delay slot)       */
 	emit(ctx, sw, t2, ctx->stack_size, MIPS_R_SP);  /* *(SP + size) = t2 */
 
-- 
2.1.0

