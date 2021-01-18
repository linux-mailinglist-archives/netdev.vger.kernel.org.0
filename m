Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930DD2F9D04
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389216AbhARKnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388567AbhARJSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 04:18:43 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3429CC0613CF;
        Mon, 18 Jan 2021 01:18:03 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id f17so17390521ljg.12;
        Mon, 18 Jan 2021 01:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cWd8g5iVcYDr1/d29WZEwJSUfqGvaqUZK0TPBalRFYk=;
        b=qp26NGkff4zxqdeJ57a8MHHIkyESMbNc47KxCMq8CqS5GyMT1oTVfYOKHRGWokT/Er
         HLcw4kVAZk79J+KfEH56Z7ky0WO1WtMunmcHc1Vt1NM0NoQ4M2zDFnGmuI1J3FLKdiD/
         DaEer3Mzp6coQQkkCNtXxOEqGhb8HXAjqP2h7OYL3xKs1qMbvlfoL20ghDlORxBR/a7H
         8yVr9C0JyNrn1AXbUHClP2hMIjyotkO7cB9nQZ/4kwO669yKAu0tqVP6vxaa6lNzfYBB
         0ZYepYnq2PIpi5gkSNh5YxRJwCRVFw/bQUcx21GGJcQzYKpz7mCvibSpQPeFUV3AiYZA
         mJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cWd8g5iVcYDr1/d29WZEwJSUfqGvaqUZK0TPBalRFYk=;
        b=oG21bxAXK291Q1TIlnW02ThnuyUXF3y0BPshgw/NhmFEEfmvatZrc8Adao/mwsTSpu
         0E2SZet51IKqejqP3hC7uWt+izxknvKZSXMWur83Hr9M3vh0bGPwrLqxZSmz0tUnhq8f
         t6+5aR6zC0FPY6T6GzkJrLt+1T3q8KaQkNfNiUlxVoOD7w+puoCQrPlP145MkbZ2MYeM
         ZI4jAYn5s7ihobHPorJKu5eWTpEvzPREesThA7ZemNK4H9VIkqo68hfqSsX1CeyLAFOS
         hGGB1AOzgSZy118VR03XcOyB5Q2Uhjg4qmcGJUQTXtEWjusqUdubfHE5bTnpi6zXFQ8l
         VSrQ==
X-Gm-Message-State: AOAM531Aq12MdFOYIzVxsQqN3lUO/eZqWxAlduE2ffDX9cPl9mDN/QnD
        +f44DMFU5JX505LFkO9Udxz+AFo/7k4/XA==
X-Google-Smtp-Source: ABdhPJzc3unYISI98MBuo3an4DJeL57OjqfdD4gc0t58gojEKHL4NFayIHjXLKUJN8cX6zTCwS/4lw==
X-Received: by 2002:a05:651c:1356:: with SMTP id j22mr10242027ljb.237.1610961481772;
        Mon, 18 Jan 2021 01:18:01 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id v22sm1841514lfd.4.2021.01.18.01.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 01:18:00 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jackmanb@google.com
Subject: [PATCH bpf-next] samples/bpf: add BPF_ATOMIC_OP macro for BPF samples
Date:   Mon, 18 Jan 2021 10:17:53 +0100
Message-Id: <20210118091753.107572-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Brendan Jackman added extend atomic operations to the BPF instruction
set in commit 7064a7341a0d ("Merge branch 'Atomics for eBPF'"), which
introduces the BPF_ATOMIC_OP macro. However, that macro was missing
for the BPF samples. Fix that by adding it into bpf_insn.h.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/bpf_insn.h | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/bpf_insn.h b/samples/bpf/bpf_insn.h
index db67a2847395..aee04534483a 100644
--- a/samples/bpf/bpf_insn.h
+++ b/samples/bpf/bpf_insn.h
@@ -134,15 +134,31 @@ struct bpf_insn;
 		.off   = OFF,					\
 		.imm   = 0 })
 
-/* Atomic memory add, *(uint *)(dst_reg + off16) += src_reg */
-
-#define BPF_STX_XADD(SIZE, DST, SRC, OFF)			\
+/*
+ * Atomic operations:
+ *
+ *   BPF_ADD                  *(uint *) (dst_reg + off16) += src_reg
+ *   BPF_AND                  *(uint *) (dst_reg + off16) &= src_reg
+ *   BPF_OR                   *(uint *) (dst_reg + off16) |= src_reg
+ *   BPF_XOR                  *(uint *) (dst_reg + off16) ^= src_reg
+ *   BPF_ADD | BPF_FETCH      src_reg = atomic_fetch_add(dst_reg + off16, src_reg);
+ *   BPF_AND | BPF_FETCH      src_reg = atomic_fetch_and(dst_reg + off16, src_reg);
+ *   BPF_OR | BPF_FETCH       src_reg = atomic_fetch_or(dst_reg + off16, src_reg);
+ *   BPF_XOR | BPF_FETCH      src_reg = atomic_fetch_xor(dst_reg + off16, src_reg);
+ *   BPF_XCHG                 src_reg = atomic_xchg(dst_reg + off16, src_reg)
+ *   BPF_CMPXCHG              r0 = atomic_cmpxchg(dst_reg + off16, r0, src_reg)
+ */
+
+#define BPF_ATOMIC_OP(SIZE, OP, DST, SRC, OFF)			\
 	((struct bpf_insn) {					\
 		.code  = BPF_STX | BPF_SIZE(SIZE) | BPF_ATOMIC,	\
 		.dst_reg = DST,					\
 		.src_reg = SRC,					\
 		.off   = OFF,					\
-		.imm   = BPF_ADD })
+		.imm   = OP })
+
+/* Legacy alias */
+#define BPF_STX_XADD(SIZE, DST, SRC, OFF) BPF_ATOMIC_OP(SIZE, BPF_ADD, DST, SRC, OFF)
 
 /* Memory store, *(uint *) (dst_reg + off16) = imm32 */
 

base-commit: 232164e041e925a920bfd28e63d5233cfad90b73
-- 
2.27.0

