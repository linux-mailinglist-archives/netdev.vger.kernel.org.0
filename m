Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E765427949
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 12:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244688AbhJILAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 07:00:12 -0400
Received: from mail.loongson.cn ([114.242.206.163]:36348 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231718AbhJILAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 07:00:08 -0400
Received: from linux.localdomain (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Dxv2q0dWFhcgkXAA--.21276S4;
        Sat, 09 Oct 2021 18:58:01 +0800 (CST)
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
Subject: [PATCH bpf-next 2/2] bpf, mips: Modify check condition about tail call count
Date:   Sat,  9 Oct 2021 18:57:56 +0800
Message-Id: <1633777076-17256-3-git-send-email-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1633777076-17256-1-git-send-email-yangtiezhu@loongson.cn>
References: <1633777076-17256-1-git-send-email-yangtiezhu@loongson.cn>
X-CM-TRANSID: AQAAf9Dxv2q0dWFhcgkXAA--.21276S4
X-Coremail-Antispam: 1UD129KBjvJXoW7XrW5CFWkCF4fZF4UGF1ftFb_yoW8JrWfpa
        45G3ZrKr1qg34UXF4rAFW8Xr1IgFs8XF47CF92kayxA3Z0v3ZIqF15K345GF90vrW8tayf
        XryUKrs8ua93A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUPG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
        x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
        8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
        xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
        vE14v26r1Y6r17McIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
        Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
        xKxwCY02Avz4vE14v_Gw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
        x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
        v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
        x2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87
        Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIF
        yTuYvjfUwjjgUUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In emit_tail_call() of bpf_jit_comp32.c, "blez t2" (t2 <= 0) is not
consistent with the comment "t2 < 0", modify the check condition to
keep consistency.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/mips/net/bpf_jit_comp32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/net/bpf_jit_comp32.c b/arch/mips/net/bpf_jit_comp32.c
index 9d7041a..b887c01 100644
--- a/arch/mips/net/bpf_jit_comp32.c
+++ b/arch/mips/net/bpf_jit_comp32.c
@@ -1312,12 +1312,12 @@ static int emit_tail_call(struct jit_context *ctx)
 	emit(ctx, sltu, t1, ind, t1);            /* t1 = ind < t1            */
 	emit(ctx, beqz, t1, get_offset(ctx, 1)); /* PC += off(1) if t1 == 0  */
 						 /* (next insn delay slot)   */
-	/* if (TCC-- <= 0) goto out */
+	/* if (--TCC < 0) goto out */
 	emit(ctx, lw, t2, ctx->stack_size, MIPS_R_SP);  /* t2 = *(SP + size) */
 	emit_load_delay(ctx);                     /* Load delay slot         */
-	emit(ctx, blez, t2, get_offset(ctx, 1));  /* PC += off(1) if t2 < 0  */
 	emit(ctx, addiu, t2, t2, -1);             /* t2-- (delay slot)       */
 	emit(ctx, sw, t2, ctx->stack_size, MIPS_R_SP);  /* *(SP + size) = t2 */
+	emit(ctx, bltz, t2, get_offset(ctx, 1));  /* PC += off(1) if t2 < 0  */
 
 	/* prog = ary->ptrs[ind] */
 	off = offsetof(struct bpf_array, ptrs);
-- 
2.1.0

