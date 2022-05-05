Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD1651B85F
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 09:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245401AbiEEHFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 03:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245404AbiEEHFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 03:05:13 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA62434BE;
        Thu,  5 May 2022 00:01:35 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id g3so2983280pgg.3;
        Thu, 05 May 2022 00:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oEvUp+vyk+kyHOCOgG5usVRVDzAYyII5UrneuqC2py4=;
        b=hu5dI2n2abFL5Y/r9WUshvPOufEMDyAeODTu4+O1ig0EQwvbOtz8MVQeTUC0OPTg7l
         LiLUmbi+zV3CvgNbMX6uErOp51yu+q1lcktssO6ivbgVZDsi0qdgJGGXQ1XMybSJzUPv
         OrcKgubG8Rd01IsLd1pb4E4Hokyjj68ccJh992BcKqCu0QpliUXSjfmXhjDS44atZwuJ
         tDZZuu0Wbl3IJXncYzJQnsCE6uX3pUnm8zSmuTnLVBDQZwfQja1mlytSusYCHwB7be1e
         Sj6zlVf1K1e8sIROdkS2TK3PEbTPaWYIk7qsJHWbfp/xPVZ52DBFOZvO7S5YYoy9sPSx
         RyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oEvUp+vyk+kyHOCOgG5usVRVDzAYyII5UrneuqC2py4=;
        b=rV7B/WDzQoiu5ys5UDS3N2LfxLumrBzjisG7arys+5J7g95RPEjWg2Q5DlkNYl4FMQ
         WNBZPcsvnZby2vD68gFkTRz5sP5OLncGCYUjen8Yai6Lfrt55X7RsZMn8njWXPVD2p+X
         75WifSpmMCfE89U2H4ZS2eskEACpPz1UoeCpeKbFa9ay2/yusIzYzLPHl+el7rEHQzDC
         4+6CrZJcUeunvdUJi8UjbPc7X6q2Dd+k2bTMitKfP/Ls1lGoBmwFya++ikOdJRP8bxd4
         /HYfI+2vBoL14evYQnufM7tfq5Asb/EIYXd3jqRwFMpWsuOGLGOtgQ7fTVTbnb01rgAP
         uomg==
X-Gm-Message-State: AOAM53071a40xW/67MzGwSzamcqHx8erTlNmYVQHh4Lyqe81mIoO/j14
        jPOa/2dTqzZ33RRhH0IJVt4=
X-Google-Smtp-Source: ABdhPJyKkwxHEJ4b2LiA5QyIppB7tZm5pMxXjWWTNuOhyfNUbj6PXzcVAZRNwaLGdwGbDcRzYbvnyg==
X-Received: by 2002:a63:570f:0:b0:39d:2648:261d with SMTP id l15-20020a63570f000000b0039d2648261dmr20550623pgb.551.1651734094739;
        Thu, 05 May 2022 00:01:34 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id l8-20020a170902f68800b0015e8d4eb213sm716386plg.93.2022.05.05.00.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 00:01:33 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>
Subject: [PATCH bpf-next] bpf: Remove unused parameter from find_kfunc_desc_btf()
Date:   Thu,  5 May 2022 15:01:14 +0800
Message-Id: <20220505070114.3522522-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The func_id parameter in find_kfunc_desc_btf() is not used, get rid of it.

Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
---
 kernel/bpf/verifier.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 813f6ee80419..c27fee73a2cb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1815,8 +1815,7 @@ void bpf_free_kfunc_btf_tab(struct bpf_kfunc_btf_tab *tab)
 	kfree(tab);
 }
 
-static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
-				       u32 func_id, s16 offset)
+static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env, s16 offset)
 {
 	if (offset) {
 		if (offset < 0) {
@@ -1891,7 +1890,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		prog_aux->kfunc_btf_tab = btf_tab;
 	}
 
-	desc_btf = find_kfunc_desc_btf(env, func_id, offset);
+	desc_btf = find_kfunc_desc_btf(env, offset);
 	if (IS_ERR(desc_btf)) {
 		verbose(env, "failed to find BTF for kernel function\n");
 		return PTR_ERR(desc_btf);
@@ -2360,7 +2359,7 @@ static const char *disasm_kfunc_name(void *data, const struct bpf_insn *insn)
 	if (insn->src_reg != BPF_PSEUDO_KFUNC_CALL)
 		return NULL;
 
-	desc_btf = find_kfunc_desc_btf(data, insn->imm, insn->off);
+	desc_btf = find_kfunc_desc_btf(data, insn->off);
 	if (IS_ERR(desc_btf))
 		return "<error>";
 
@@ -7237,7 +7236,7 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 	if (!insn->imm)
 		return 0;
 
-	desc_btf = find_kfunc_desc_btf(env, insn->imm, insn->off);
+	desc_btf = find_kfunc_desc_btf(env, insn->off);
 	if (IS_ERR(desc_btf))
 		return PTR_ERR(desc_btf);
 
-- 
2.36.0

