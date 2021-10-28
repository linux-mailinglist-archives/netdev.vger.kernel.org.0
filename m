Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C200B43E5CE
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ1QNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:13:34 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:43964 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1QNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:13:34 -0400
Received: by mail-lj1-f173.google.com with SMTP id d23so10264018ljj.10;
        Thu, 28 Oct 2021 09:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/AJBEW3vyVrTUMTRP/ONhgseLgot5lKkfZZ3GS+nfA=;
        b=ooGGK89noFSnU1DAheZ0DSB3atmiCKDMaJgTeCNTSyOsETEJQT2iw/PvihUp9tmn1h
         CBK40eWR5H2exxdRUVPOkt3b31EvyeuMuUYkXc6nn6U+REvU8LBLfbPghcKph6qZ21yV
         bZECthLetk4NNZ/vtoodf7N2Izvsa2iy3j89soeekgAx62NTgPJAPt9ihaHnceji01py
         Cz0AzW6QYBiPmIx/RA1K6EtoAbocpBsNHgxLpjnw3xRZ3OLhM5kTVshYCbFin+a6OCwu
         KxaiHIfcLqMG+5rZFQMmzxZzuAcoX3wFiGznCSMi4eaRv57ZU48AQ+3M8BHcKhNyZ/b0
         6sQg==
X-Gm-Message-State: AOAM531g4rXlgzZ7NZSMG3/XTc6p2j9rA3Fk59cxou4Fb+wN+9+0vTJI
        JjaubyjGCnwSHcmW1Zc8vZY=
X-Google-Smtp-Source: ABdhPJwOcY43NhUimT65dqUn5i4ibaVElLDvmVmk/6S/JSjYT0ktZxz3YwxE28cPmSRryVx3sGI3mw==
X-Received: by 2002:a2e:a7c7:: with SMTP id x7mr5647795ljp.8.1635437465726;
        Thu, 28 Oct 2021 09:11:05 -0700 (PDT)
Received: from kladdkakan.. ([193.138.218.162])
        by smtp.gmail.com with ESMTPSA id o17sm49680lfo.176.2021.10.28.09.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:11:04 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v2 1/4] riscv, bpf: Increase the maximum number of iterations
Date:   Thu, 28 Oct 2021 18:10:54 +0200
Message-Id: <20211028161057.520552-2-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028161057.520552-1-bjorn@kernel.org>
References: <20211028161057.520552-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that BPF programs can be up to 1M instructions, it is not uncommon
that a program requires more than the current 16 iterations to
converge.

Bump it to 32, which is enough for selftests/bpf, and test_bpf.ko.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 arch/riscv/net/bpf_jit_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_core.c b/arch/riscv/net/bpf_jit_core.c
index 7ccc809f2c19..ef9fcf6ea749 100644
--- a/arch/riscv/net/bpf_jit_core.c
+++ b/arch/riscv/net/bpf_jit_core.c
@@ -11,7 +11,7 @@
 #include "bpf_jit.h"
 
 /* Number of iterations to try until offsets converge. */
-#define NR_JIT_ITERATIONS	16
+#define NR_JIT_ITERATIONS	32
 
 static int build_body(struct rv_jit_context *ctx, bool extra_pass, int *offset)
 {
-- 
2.32.0

