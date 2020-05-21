Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5741DD802
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730042AbgEUUIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgEUUIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 16:08:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2868DC061A0E;
        Thu, 21 May 2020 13:08:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id v63so3936128pfb.10;
        Thu, 21 May 2020 13:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XlSWxuTl8RjEPaaS0nAI4JGOmMxJguYdjCUdlJurYag=;
        b=PWo2KMZwDNbRJSev/kbOT/GF1wUZY6kZfMRdhCGAOLlqZsvgOgSVCp1Cd4jm2OkHbO
         XNCHBZHyB2e2mDvQrClWw7C0SWyKoZPFOYu/vdtG3k7CyAfFRDsGv9KRSct6DWf7Jqm7
         ZCDfDedXOetN+eFaGvNZD+/doq/F1dRikc8YwpiRDgOMi1v+IuLqe7/UYvlla3fjV9lK
         ZLZvYVIIDH8iXOgvyaQIrzTiQZFC/PNg0I7Evo1K+uh54D8VIPZw3og9VJFO0izapgsW
         Uatc1qIt0blStgwS988+Dp7Q4QRV4Xz+UEfnqp7s7f4TCaxvx4kkZJ7/Mv428Ylvii5W
         +23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XlSWxuTl8RjEPaaS0nAI4JGOmMxJguYdjCUdlJurYag=;
        b=Q7mXI7xBKqhgIqX1R5gQwE2xaKuhBK2fIhtRaduUlw6CKNBy+lLtVKblYYnZbYrfUe
         gYagnINXYvSHV2B0+zsDzKlCY49MqKpwZFNGl/ZGyqqAlRRAvg8pLkf8XRgI4gjqs/eh
         0wGcEogyKFcn6lygotuA5WLMYw8rFeDJtGQLBaPjnWrYJxZh1IUY1KdLiNej8fcFW0ra
         Uh2S42fmbxfvaGYqkX6mcF3UM1MgvYU3IvexR0ieG4IwBMBlKfI/0f/AObvHsk7kzCg6
         4BnYp+a6KneBUyjEwKDzNNJ7yCOLQAUTils6weu1Uhj/Xnt57DlHTQAS+x+7VSn0znnT
         kgzg==
X-Gm-Message-State: AOAM531zbzsNsjX/BYm2SF4gLS2AsAQjVXeplgAhwRJ49xkjKWAxP2YT
        oNJJuon+gHcG3miseM8mFWI=
X-Google-Smtp-Source: ABdhPJwKnCFrNUy+vKYuUveKy8VR2bdYCGhEHCEL1yGDzUfcROQ4ecKTwOjvDzkNo4eLcCCkgXxRxQ==
X-Received: by 2002:a63:cf17:: with SMTP id j23mr8541974pgg.373.1590091699768;
        Thu, 21 May 2020 13:08:19 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d18sm5123513pfq.136.2020.05.21.13.08.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 13:08:18 -0700 (PDT)
Subject: [bpf-next PATCH v2 3/4] bpf: selftests,
 verifier case for non null pointer map value branch
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Thu, 21 May 2020 13:08:06 -0700
Message-ID: <159009168650.6313.7434084136067263554.stgit@john-Precision-5820-Tower>
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

When we have pointer type that is known to be non-null we only follow
the non-null branch. This adds tests to cover the map_value pointer
returned from a map lookup. To force an error if both branches are
followed we do an ALU op on R10.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/value_or_null.c b/tools/testing/selftests/bpf/verifier/value_or_null.c
index 860d4a7..3ecb70a 100644
--- a/tools/testing/selftests/bpf/verifier/value_or_null.c
+++ b/tools/testing/selftests/bpf/verifier/value_or_null.c
@@ -150,3 +150,22 @@
 	.result_unpriv = REJECT,
 	.flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,
 },
+{
+	"map lookup and null branch prediction",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_1, 10),
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_1, -8),
+	BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+	BPF_LD_MAP_FD(BPF_REG_1, 0),
+	BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_map_lookup_elem),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	BPF_JMP_IMM(BPF_JEQ, BPF_REG_6, 0, 2),
+	BPF_JMP_IMM(BPF_JNE, BPF_REG_6, 0, 1),
+	BPF_ALU64_IMM(BPF_ADD, BPF_REG_10, 10),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_8b = { 4 },
+	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
+	.result = ACCEPT,
+},

