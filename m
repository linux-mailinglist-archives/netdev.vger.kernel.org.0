Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA56D1DD800
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgEUUIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUUIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:08:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F39C061A0E;
        Thu, 21 May 2020 13:08:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id u5so3771249pgn.5;
        Thu, 21 May 2020 13:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=jEH0Av+/h2ap9TKD35Gd3IZLyPPmODgO6Lkjc2gXzJM=;
        b=atShi6piwwU9fnDvasB2qiC0HZlLLS9ByPNWNXWFrBPYaf8FLdcfm4nCW/D6NK7+ov
         M51Xp+uUbT7nvwXOSQEM8KzW2SgoN7YmnbM42LUXxQZYYObL/h+6JBsfCoE8nhZ42zLv
         xT1UuY4goX0GiSQLTnNu7tSonc20z4WzCQjx1B6nKLtCL1WA+szNzF5Ze8q8IOWyeckQ
         d80n+D7fewF6Z6Gw+IWrT2DNoRq8zyjfPKuzN3ckGLzNZ5538fDz6sZA843+glLuatz6
         FH3c1haUMlJMCYIRfjMZf1G3MfOx0MDKAOSBUprkDKnk4/X7q0usSNqDG32SPE5X/Hy7
         5Hxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jEH0Av+/h2ap9TKD35Gd3IZLyPPmODgO6Lkjc2gXzJM=;
        b=LCY+X1dCE9QtzOsRgDVuEiA/3WRoo8fwaFS6Zw/LmZaQM8PYuNrJBi9LbPgyuwaWkF
         URewPaDm1PDEDOwVM+qp5l3I0U7zYMp6Cz3qZXjKxnX5bBOO0pTC2AE4RfcHn6f92V9o
         dlkgZBMoaPe0saCgR+rVwxC0mJCkPabeNOU9w/0bgXWPrtygkOyEHrrDuXWRXSwd6hC2
         cKR542OYsTQPp5VU/lnfyYN6vn+tVsxO8o8a4UEEJhvB+Ls+oGSuNC1gslMTD2XB1hQV
         7Xb07QIgYj/pvh74fZtq1hugTUvC0tQZKo/SzUj3eTr26XzBrA2uhIlRrPL4x5/tDDXq
         HcDA==
X-Gm-Message-State: AOAM533fiOBs5F+WQy4p10Hq6i6ulr4vgA83M3Ay28HXuDZQN39znEAV
        h9l+mZ71TPu0/GW12uq4BuNCnhSf
X-Google-Smtp-Source: ABdhPJzp3QkWxEcYmLscwq26nfzfkF4FEUIlw8sQ0HUyM37ViW/3VpVtjJhJCbm/z8GqNHV6vLv8PA==
X-Received: by 2002:a62:e10e:: with SMTP id q14mr392127pfh.88.1590091680385;
        Thu, 21 May 2020 13:08:00 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o14sm5156276pfp.89.2020.05.21.13.07.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 13:07:59 -0700 (PDT)
Subject: [bpf-next PATCH v2 2/4] bpf: selftests,
 verifier case for non null pointer check branch taken
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 21 May 2020 13:07:46 -0700
Message-ID: <159009166599.6313.1593680633787453767.stgit@john-Precision-5820-Tower>
In-Reply-To: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
References: <159009128301.6313.11384218513010252427.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have pointer type that is known to be non-null and comparing
against zero we only follow the non-null branch. This adds tests to
cover this case for reference tracking. Also add the other case when
comparison against a non-zero value and ensure we still fail with
unreleased reference.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 604b461..056e027 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -821,3 +821,36 @@
 	.result = REJECT,
 	.errstr = "invalid mem access",
 },
+{
+	"reference tracking: branch tracking valid pointer null comparison",
+	.insns = {
+	BPF_SK_LOOKUP(sk_lookup_tcp),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 0, 1),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 2),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_EMIT_CALL(BPF_FUNC_sk_release),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+},
+{
+	"reference tracking: branch tracking valid pointer value comparison",
+	.insns = {
+	BPF_SK_LOOKUP(sk_lookup_tcp),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_MOV64_IMM(BPF_REG_3, 1),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 4),
+	BPF_MOV64_IMM(BPF_REG_3, 0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 1234, 2),
+	BPF_MOV64_REG(BPF_REG_1, BPF_REG_6),
+	BPF_EMIT_CALL(BPF_FUNC_sk_release),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.errstr = "Unreleased reference",
+	.result = REJECT,
+},

