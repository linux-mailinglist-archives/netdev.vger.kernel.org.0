Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A221C43E1EA
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJ1NXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:23:15 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:37846 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhJ1NXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:23:14 -0400
Received: by mail-lf1-f41.google.com with SMTP id i13so3989528lfe.4;
        Thu, 28 Oct 2021 06:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O/AJBEW3vyVrTUMTRP/ONhgseLgot5lKkfZZ3GS+nfA=;
        b=Lqf4GNnMWhcPwFyovZNRaUD5HI4MoHernK5aLV1kYF0aNBfiz017NRSmMkgpKZdMQz
         G+M2J1bdsbV3l3RsG8mtq3ZTRFk8cOn7G3VUkjjTWBYtWYLpQbR+IRgyEQzPPkxF+JMy
         /uz8lZo0G7gbPCq18YDX08w8UBBq1jLb4450JkKrzTVqMfrbKPal5N8mSemauWWFZYWy
         G/6/1rbx0368spS6IM8UWsMctqX30FvLDnPM4kcIj5wqlzfMXu7zL1jr1yjOhTzvz8kw
         7ivxwSLvvEUvgLMp55w0NdcODTRde1heEnzUor4qHpdeVKMZU0uteNawRPFVVzploWSC
         nqCA==
X-Gm-Message-State: AOAM533OLdXwaKAsjgNGarCSBiNqo1UWUXwZAJjTDPA0aIqXnIMRfUt1
        PtED/qj+dJ82cXNjTl0hrdo=
X-Google-Smtp-Source: ABdhPJxZcJ13N8X0a3vFeqXrp6hDAqd5+pSCoHgE77DOaEKKyBW0zArRRHgSPWuy87B3rp/8uizNtw==
X-Received: by 2002:a05:6512:2184:: with SMTP id b4mr4206060lft.663.1635427246654;
        Thu, 28 Oct 2021 06:20:46 -0700 (PDT)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id o9sm309616lfk.292.2021.10.28.06.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:20:45 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 1/4] riscv, bpf: Increase the maximum number of iterations
Date:   Thu, 28 Oct 2021 15:20:38 +0200
Message-Id: <20211028132041.516820-2-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028132041.516820-1-bjorn@kernel.org>
References: <20211028132041.516820-1-bjorn@kernel.org>
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

