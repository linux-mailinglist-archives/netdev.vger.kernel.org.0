Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C9C1D88C0
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgERUDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 16:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgERUDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 16:03:06 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9183DC061A0C;
        Mon, 18 May 2020 13:03:06 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c20so9000896ilk.6;
        Mon, 18 May 2020 13:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=hGopJ23Awe8jxA58mwcFFf07exvBHSCVePFTn+MGlQQ=;
        b=Y61lJUBmeumknlNq+e891qmunLIGNScJ8uK218PAslIp7gr7/zt/YsCop/t94uow6j
         2PjB774TQw4Q6MUB3pvDfpSO0v1mdUD+i5cmh/Yh0CE4LCzNSOQBrT/FLJ1ZlWd/y8Ta
         yZZp14DzGJ2PrIEtl2aEl0oqktBkb6TmEgkQIOYM3r1wLFFLNOSmDc0IK4oclCu7CtPK
         BYxGZffhDNcyS3Wf91C0ISdXdrUQyES2LFk6wNWyCzW2bPpaHEF1ClTAhR9zC3eWXCgu
         1UcY6R0pe0ZYb+vMJrBLDlQ7E4Ri2KC0wTIAuW9zFwVm1hxlFptaQmB9WrqpzlEsaZN0
         EWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=hGopJ23Awe8jxA58mwcFFf07exvBHSCVePFTn+MGlQQ=;
        b=bTSOqqsQ2HHrByhLe3XW6/N9tUy78mNi721Tua3nlxubxY0HcdVhVyAAHIpg/s9I67
         Rh9WJCY4ptq2Pw+3BRtoEaJkihnyN0dptEd/dZ0Oy0GtzV26pt0hUO8RjAcKwL7pCk5p
         OW6RubjN2CR9aiu21P2v+3WyXv/5zO0nmoC3U6T7KIjGp9dz6LclHIdg0Q6m+8TknzEb
         EB3oBgWh3cAdJa2gyPjB1OqXmmpO58Ovzv117RH6ii3H13tBYl5DccZd+cTE7ZSOgTDj
         0/FT0+Ban0EQFlzDkvD8hjpQ8HIGkGFM7Y07ERpj0JTfcs5RJqKEnRDI7mh1yvQ8jB0h
         4zVA==
X-Gm-Message-State: AOAM532TrifGaMmq2es64XY0XrWTt/IatVOg3Ru42SQ7FwA6+u1Rog4f
        eR1MT+wadD/MB8MOO5O861Ph6IcG
X-Google-Smtp-Source: ABdhPJyfalBY6xuYwLp0myvWtGzvIc2Han1BgetJDOYK6K3p7slHWsx8d6RymXcamnMwD8W+NMM4fA==
X-Received: by 2002:a92:3cd0:: with SMTP id j77mr19117788ilf.112.1589832185727;
        Mon, 18 May 2020 13:03:05 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o17sm5129335ilo.75.2020.05.18.13.02.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 May 2020 13:03:05 -0700 (PDT)
Subject: [bpf-next PATCH 2/4] bpf: selftests,
 verifier case for non null pointer check branch taken
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Mon, 18 May 2020 13:02:52 -0700
Message-ID: <158983217236.6512.3045049444791726995.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have pointer type that is known to be non-null we only follow
the non-null branch. This adds tests to cover this case for reference
tracking.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/verifier/ref_tracking.c b/tools/testing/selftests/bpf/verifier/ref_tracking.c
index 604b461..d8f7c04 100644
--- a/tools/testing/selftests/bpf/verifier/ref_tracking.c
+++ b/tools/testing/selftests/bpf/verifier/ref_tracking.c
@@ -821,3 +821,19 @@
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

