Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DA82778A7
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgIXSpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgIXSpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:45:34 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5536C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 11:45:34 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id n61so4124512ota.10
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 11:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Pp99UhxGop9ixvcK8ljKNI/v9IifEBTq/Hj5ua1ja8o=;
        b=hUbijHWPMqA4Mx1oDxYfYRGwVKGcxzjr3XAU4EdsA5pUMR8GGAj9chb7JpDtprkvKf
         BWpphlAsSo4aeJITPu5DAuO7voKCefm3CXIp7og+mW5QQ7/qy9f8WxhDcniIHheIH7dV
         5NLCaNFYpzf7Z76ZCTnrHXtbIjpQNLtdR4xPQ4/HcNwPJk2joXGbog9VG0ZwEqYMkUCG
         ujqXBijUhq7z1qMATABL//Os7qJVOFyqSSP1vltMvZb7bdKgN5+a6QmHCmZ2Gr1FZGK7
         hLl5w9FEyWIWYIgQXc6ZjJQD7uuKrgt/q9MwiK767qpcuaUSwdQuZgOYBtvnH110hsXv
         pHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Pp99UhxGop9ixvcK8ljKNI/v9IifEBTq/Hj5ua1ja8o=;
        b=pDdqbCiE4IqbtM4XFuZTkdlcKI3WwmTe9AMdaxhotKs0+pSIAhlD1HSEsgBnxckfUn
         4ZIyB7wU7z05j8FF9eRE2EFnOM+R2rE7fIl3kxy0hDNQxj+NoXf376eVzqnXD1HqfZeX
         9bcw1/MnN4bu3GXJnXz1oiHQC4p1OwoDWOvQt/lBOWxpSpRir/knIlB5INvFBESCC9Hs
         Zeb1Ltq8LptJI7AiDH/M7BQLOIjPNx//BeI9hH786hFtsgAE6lHW0rdnoiQHTC2REgX4
         8Uqa+1iddbRxc7ZOwWtfT4oVJyZwyvPurCZGBXKuldZDfGsxivvWZ2QF21FSlNBMVN62
         TT4A==
X-Gm-Message-State: AOAM533qbWTwIIJEU/xOl68N6xnfKULRjivCWjrGPmdZorRvpmHiVK7z
        1+HTXgoNlRcVvaSy8pB5RHje7B+L9BA1LA==
X-Google-Smtp-Source: ABdhPJzG/EoFi72TruqVW1+Ncc8nkce6ePClNFjyGyvwdk+mKh2+znkd4X398/PCOm3mc0lXXL7SXg==
X-Received: by 2002:a9d:4e1a:: with SMTP id p26mr388350otf.197.1600973133349;
        Thu, 24 Sep 2020 11:45:33 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j10sm25945oif.36.2020.09.24.11.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 11:45:32 -0700 (PDT)
Subject: [bpf-next PATCH 2/2] bpf: Add AND verifier test case where 32bit
 and 64bit bounds differ
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com
Date:   Thu, 24 Sep 2020 11:45:22 -0700
Message-ID: <160097312263.12106.17437529842919754724.stgit@john-Precision-5820-Tower>
In-Reply-To: <160097310597.12106.6191783180902126213.stgit@john-Precision-5820-Tower>
References: <160097310597.12106.6191783180902126213.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we AND two values together that are known in the 32bit subregs, but not
known in the 64bit registers we rely on the tnum value to report the 32bit
subreg is known. And do not use mark_reg_known() directly from
scalar32_min_max_and()

Add an AND test to cover the case with known 32bit subreg, but unknown
64bit reg.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/verifier/and.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/and.c b/tools/testing/selftests/bpf/verifier/and.c
index d781bc86e100..ca8fdb1b3f01 100644
--- a/tools/testing/selftests/bpf/verifier/and.c
+++ b/tools/testing/selftests/bpf/verifier/and.c
@@ -48,3 +48,19 @@
 	.result = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"check known subreg with unknown reg",
+	.insns = {
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_get_prandom_u32),
+	BPF_ALU64_IMM(BPF_LSH, BPF_REG_0, 32),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 1),
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_0, 0xFFFF1234),
+	/* Upper bits are unknown but AND above masks out 1 zero'ing lower bits */
+	BPF_JMP32_IMM(BPF_JLT, BPF_REG_0, 1, 1),
+	BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 512),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.retval = 0
+},

