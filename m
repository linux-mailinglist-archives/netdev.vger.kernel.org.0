Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF765568AC0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 16:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiGFODx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 10:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiGFODs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 10:03:48 -0400
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E732824BC3;
        Wed,  6 Jul 2022 07:03:35 -0700 (PDT)
From:   Yixun Lan <dlan@gentoo.org>
To:     linux-riscv@lists.infradead.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        bpf@vger.kernel.org
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Hengqi Chen <chenhengqi@outlook.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yixun Lan <dlan@gentoo.org>
Subject: [PATCH] riscv, libbpf: use a0 for RC register
Date:   Wed,  6 Jul 2022 22:02:04 +0800
Message-Id: <20220706140204.47926-1-dlan@gentoo.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the RISC-V calling convention register usage here[1],
a0 is used as return value register, so rename it to make it consistent
with the spec.

[1] section 18.2, table 18.2
https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf

Fixes: 589fed479ba1 ("riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h")
Signed-off-by: Yixun Lan <dlan@gentoo.org>

---

I'm adding a Fixes tag here, although the original version may just work fine,
and shouldn't be considered as a real error. But, the benefit is that we could
make it consistent with RISC-V spec, and all other tools will follow the same usage.

thanks, and let's me if there is any issue that I may not noticed..
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 01ce121c302df..11f9096407fc4 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -233,7 +233,7 @@ struct pt_regs___arm64 {
 #define __PT_PARM5_REG a4
 #define __PT_RET_REG ra
 #define __PT_FP_REG s0
-#define __PT_RC_REG a5
+#define __PT_RC_REG a0
 #define __PT_SP_REG sp
 #define __PT_IP_REG pc
 /* riscv does not select ARCH_HAS_SYSCALL_WRAPPER. */
-- 
2.35.1

