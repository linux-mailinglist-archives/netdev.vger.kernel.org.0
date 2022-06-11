Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB145471C0
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 06:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348539AbiFKEJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 00:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiFKEJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 00:09:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6500F32;
        Fri, 10 Jun 2022 21:09:08 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LKknV4htvzjXKR;
        Sat, 11 Jun 2022 12:07:42 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 11 Jun
 2022 12:09:06 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <illusionist.neo@gmail.com>, <linux@armlinux.org.uk>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <johan.almbladh@anyfinetworks.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] bpf, arm: Remove unused function emit_a32_alu_r()
Date:   Sat, 11 Jun 2022 12:09:04 +0800
Message-ID: <20220611040904.8976-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b18bea2a45b1 ("ARM: net: bpf: improve 64-bit ALU implementation")
this is unused anymore, so can remove it.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 arch/arm/net/bpf_jit_32.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
index 9e457156ad4d..6a1c9fca5260 100644
--- a/arch/arm/net/bpf_jit_32.c
+++ b/arch/arm/net/bpf_jit_32.c
@@ -712,22 +712,6 @@ static inline void emit_alu_r(const u8 dst, const u8 src, const bool is64,
 	}
 }
 
-/* ALU operation (32 bit)
- * dst = dst (op) src
- */
-static inline void emit_a32_alu_r(const s8 dst, const s8 src,
-				  struct jit_ctx *ctx, const bool is64,
-				  const bool hi, const u8 op) {
-	const s8 *tmp = bpf2a32[TMP_REG_1];
-	s8 rn, rd;
-
-	rn = arm_bpf_get_reg32(src, tmp[1], ctx);
-	rd = arm_bpf_get_reg32(dst, tmp[0], ctx);
-	/* ALU operation */
-	emit_alu_r(rd, rn, is64, hi, op, ctx);
-	arm_bpf_put_reg32(dst, rd, ctx);
-}
-
 /* ALU operation (64 bit) */
 static inline void emit_a32_alu_r64(const bool is64, const s8 dst[],
 				  const s8 src[], struct jit_ctx *ctx,
-- 
2.17.1

