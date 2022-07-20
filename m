Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487F057AB6B
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiGTBLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:11:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbiGTBKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:10:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4634BD18;
        Tue, 19 Jul 2022 18:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B086C6171C;
        Wed, 20 Jul 2022 01:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04B6C341C6;
        Wed, 20 Jul 2022 01:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279448;
        bh=geJPDdQ7ApT76PWUo/eMmnGiDSRWmu9OjCz9xBHRNgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VKOlTufDyZHOyqD0D1ykcFS4vjr0srp9gzN+3UCIco4vU7eymqY6sxDaR/xWcrTli
         MGKQ4CRKXUM791bmxzV882lcPwhNCJ6Wy/LGRisdYuOHxTos2W8Std7y6b4Mbp4/Ri
         U4Q0bS6WZ/z1Jt63j8a+cTBEma1cRXVcsRulj+0Z45QeyeAt4RbUw+7L6yEwVPEzNT
         L+Rvjv0aDezVDWet11rZK8u80dz8aWsNrRSRUja3wmMlV8Rvui9xVcXxmaitUswhYd
         Up9wlxn9/HA9hYyy8FBofIOP0gvCN2Z3VzNk9QySpHpOr4eKjSDKwW1MRZ2v+DuekX
         wbpdtLD4RIlmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        pawan.kumar.gupta@linux.intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 05/54] x86/retpoline: Cleanup some #ifdefery
Date:   Tue, 19 Jul 2022 21:09:42 -0400
Message-Id: <20220720011031.1023305-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 369ae6ffc41a3c1137cab697635a84d0cc7cdcea ]

On it's own not much of a cleanup but it prepares for more/similar
code.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/disabled-features.h | 9 ++++++++-
 arch/x86/include/asm/nospec-branch.h     | 7 +++----
 arch/x86/net/bpf_jit_comp.c              | 7 +++----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 1231d63f836d..f5db93822fc1 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,13 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_RETPOLINE
+# define DISABLE_RETPOLINE	0
+#else
+# define DISABLE_RETPOLINE	((1 << (X86_FEATURE_RETPOLINE & 31)) | \
+				 (1 << (X86_FEATURE_RETPOLINE_LFENCE & 31)))
+#endif
+
 #ifdef CONFIG_INTEL_IOMMU_SVM
 # define DISABLE_ENQCMD		0
 #else
@@ -82,7 +89,7 @@
 #define DISABLED_MASK8	0
 #define DISABLED_MASK9	(DISABLE_SMAP|DISABLE_SGX)
 #define DISABLED_MASK10	0
-#define DISABLED_MASK11	0
+#define DISABLED_MASK11	(DISABLE_RETPOLINE)
 #define DISABLED_MASK12	0
 #define DISABLED_MASK13	0
 #define DISABLED_MASK14	0
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index da251a5645b0..5728539a3e77 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -120,17 +120,16 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
-#ifdef CONFIG_RETPOLINE
-
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
+extern retpoline_thunk_t __x86_indirect_thunk_array[];
+
+#ifdef CONFIG_RETPOLINE
 
 #define GEN(reg) \
 	extern retpoline_thunk_t __x86_indirect_thunk_ ## reg;
 #include <asm/GEN-for-each-reg.h>
 #undef GEN
 
-extern retpoline_thunk_t __x86_indirect_thunk_array[];
-
 #ifdef CONFIG_X86_64
 
 /*
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 4c71fa04e784..2ad01c75863e 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -407,16 +407,15 @@ static void emit_indirect_jump(u8 **pprog, int reg, u8 *ip)
 {
 	u8 *prog = *pprog;
 
-#ifdef CONFIG_RETPOLINE
 	if (cpu_feature_enabled(X86_FEATURE_RETPOLINE_LFENCE)) {
 		EMIT_LFENCE();
 		EMIT2(0xFF, 0xE0 + reg);
 	} else if (cpu_feature_enabled(X86_FEATURE_RETPOLINE)) {
 		OPTIMIZER_HIDE_VAR(reg);
 		emit_jump(&prog, &__x86_indirect_thunk_array[reg], ip);
-	} else
-#endif
-	EMIT2(0xFF, 0xE0 + reg);
+	} else {
+		EMIT2(0xFF, 0xE0 + reg);
+	}
 
 	*pprog = prog;
 }
-- 
2.35.1

