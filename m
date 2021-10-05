Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557A14220C7
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 10:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhJEIcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 04:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbhJEIcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 04:32:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824FBC061745;
        Tue,  5 Oct 2021 01:30:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so1364821pjb.2;
        Tue, 05 Oct 2021 01:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DAGNoLYAM13FCAsShiHivQ1p6RlYfr33Xe38II2bD8U=;
        b=cBDmZU424tuQmQIoC3gjJYq5sHDqh+yCBNy2EH1IMKIbT5rkl9vk+5RTjfb8AQ7MFI
         dC2ULIApzwL8Wk1GHv9W9SXUogddOGtt1oFvKrVuQQg8ucZcztM1fJYzdfzRsSG6r/GE
         QDaMLodiHKPyOMm+iFfzxrjhs4A/dHn34XWXbRUPfql3ACKK7JG3LIQFA6ADa1s5/R65
         bB8d3hTaqQ/cAc6apMOpbiycNiA9pYskY+XC96U9eKL+lnoNRvT9Mioelkkf640EoQhz
         l+hn8d0lgu3KoJ5yGaUHs/6nEOJ5DDlNsbR757s6pUqSMZhE1Y+g+TvO/xZltr79xca5
         5dng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DAGNoLYAM13FCAsShiHivQ1p6RlYfr33Xe38II2bD8U=;
        b=GpqIbrh+2hAm9jxdl6tykLu1nMyWh+lPCCJkGRvP3or/IHsJqcnQEXD0UbiJjNnd5Y
         gl1MsLaE4jMH4PXKZ2Oa64imLu7LPBwzJyulXNboi+ufoSTlfWZzIS4TjdY4Kk2ZGfWe
         NV1NxAGzr+CbSo3Pg39eX9XWCXohIPyMyOknZtl4XfMo4TYPBpFE5dn63vXtfw8+BL9q
         1LGkhKDNPPNYBF6F+UWnTOwXVJyRmJFHQcx1qfhjJhf49zgrrqyxdZEvgYhAeeg/vXKb
         lA8DCPfB4VZV8Kuclbp13+XxfGelhvZknpzG0imlTCYQAtgzzvus77To7xxMx87Y2Wzl
         kB+Q==
X-Gm-Message-State: AOAM531Pq8u8J25zMhhml3QSpfWLDjNzwUrO4qztSwzWVTh74moz/xXq
        tR/2vuuQ6M/v0pxLDzu/Icn//Eo9xT/bRw==
X-Google-Smtp-Source: ABdhPJz/t0tF4B5I4040OsOvyCt2OxNMZtEY5lMth30IA55yWXN5QOuG8MDZSgY1PeOduk0kdTtOiQ==
X-Received: by 2002:a17:90b:3901:: with SMTP id ob1mr2329767pjb.12.1633422658158;
        Tue, 05 Oct 2021 01:30:58 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:78ba:4bcc:a59a:2284])
        by smtp.gmail.com with ESMTPSA id a15sm4941257pfg.53.2021.10.05.01.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 01:30:57 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-mips@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Hassan Naveed <hnaveed@wavecomp.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [RFC PATCH bpf-next v2 07/16] MIPS: eBPF: fix MOD64 insn on R6 ISA
Date:   Tue,  5 Oct 2021 01:26:51 -0700
Message-Id: <ee566ff333843f6ff734f4c12a3c6c86793c9101.1633392335.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633392335.git.Tony.Ambardar@gmail.com>
References: <cover.1625970383.git.Tony.Ambardar@gmail.com> <cover.1633392335.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF_ALU64 | BPF_MOD implementation is broken on MIPS64R6 due to use of
a 32-bit "modu" insn, as shown by the test_verifier failures:

  455/p MOD64 overflow, check 1 FAIL retval 0 != 1 (run 1/1)
  456/p MOD64 overflow, check 2 FAIL retval 0 != 1 (run 1/1)

Resolve by using the 64-bit "dmodu" instead.

Fixes: 6c2c8a188868 ("MIPS: eBPF: Provide eBPF support for MIPS64R6")
Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 arch/mips/net/ebpf_jit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/net/ebpf_jit.c b/arch/mips/net/ebpf_jit.c
index b8dc6cebefab..00dc20bc0def 100644
--- a/arch/mips/net/ebpf_jit.c
+++ b/arch/mips/net/ebpf_jit.c
@@ -800,7 +800,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			if (bpf_op == BPF_DIV)
 				emit_instr(ctx, ddivu_r6, dst, dst, MIPS_R_AT);
 			else
-				emit_instr(ctx, modu, dst, dst, MIPS_R_AT);
+				emit_instr(ctx, dmodu, dst, dst, MIPS_R_AT);
 			break;
 		}
 		emit_instr(ctx, ddivu, dst, MIPS_R_AT);
@@ -882,7 +882,7 @@ static int build_one_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 					emit_instr(ctx, ddivu_r6,
 							dst, dst, src);
 				else
-					emit_instr(ctx, modu, dst, dst, src);
+					emit_instr(ctx, dmodu, dst, dst, src);
 				break;
 			}
 			emit_instr(ctx, ddivu, dst, src);
-- 
2.25.1

