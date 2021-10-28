Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8BD43E5D0
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 18:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhJ1QNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:13:36 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:33329 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1QNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:13:35 -0400
Received: by mail-lf1-f51.google.com with SMTP id b32so11479638lfv.0;
        Thu, 28 Oct 2021 09:11:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FpcAIXzIJRZanZR1xOZ449nR9Z4CpuYm3hzQzUAM83c=;
        b=T694AEQegNXgAxyhtCkk+UVvZqWC/I7EdUinSsPPl48r5rd9jc5f70XUwXF0aPPWUH
         sLAOGVvUu/M9S4kgZj3peZPqjCntVjg+i1VMMWnazPdpRozCgoCGIwe0ssW2GWLHyLfG
         Eq1+sIVLccQzGsTkQpaW82/FU5Vzzc+KgcN+NqsJrfazUcQKOqW9FgpPc2K0uyUgjptc
         EMJ8oSLC7QusOWq8kmT9Vk/pIgtm2lyMPcIBB4nUCR4IpmcjnL7yY3NRQoU6lOQe79K7
         x2uXtR62JJaK6Kw14PxUQqoXz1bHUiiC4p5roqSJFljffV7TiomjcxHLnhO872P7NxRK
         g7oQ==
X-Gm-Message-State: AOAM5332/O1xwguKkAOGUCZn0u5qsnp4FjinRqX+diPrrZ8UX/iNYk9M
        M1l7KVOxyDFgG2CeINUUsqs=
X-Google-Smtp-Source: ABdhPJwdMZ48TKOvgfFiB9guDpW7x1LA1tIS0H2a86m9DxEaEZrPkOpQmOD9kozfq69jLR8FA3Mi2w==
X-Received: by 2002:a05:6512:3a89:: with SMTP id q9mr5114900lfu.172.1635437467541;
        Thu, 28 Oct 2021 09:11:07 -0700 (PDT)
Received: from kladdkakan.. ([193.138.218.162])
        by smtp.gmail.com with ESMTPSA id o17sm49680lfo.176.2021.10.28.09.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:11:06 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        luke.r.nels@gmail.com, xi.wang@gmail.com,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next v2 2/4] tools build: Add RISC-V to HOSTARCH parsing
Date:   Thu, 28 Oct 2021 18:10:55 +0200
Message-Id: <20211028161057.520552-3-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028161057.520552-1-bjorn@kernel.org>
References: <20211028161057.520552-1-bjorn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add RISC-V to the HOSTARCH parsing, so that ARCH is "riscv", and not
"riscv32" or "riscv64".

This affects the perf and libbpf builds, so that arch specific
includes are correctly picked up for RISC-V.

Signed-off-by: Björn Töpel <bjorn@kernel.org>
---
 tools/scripts/Makefile.arch | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/scripts/Makefile.arch b/tools/scripts/Makefile.arch
index b10b7a27c33f..0c6c7f456887 100644
--- a/tools/scripts/Makefile.arch
+++ b/tools/scripts/Makefile.arch
@@ -4,7 +4,8 @@ HOSTARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
                                   -e /arm64/!s/arm.*/arm/ -e s/sa110/arm/ \
                                   -e s/s390x/s390/ -e s/parisc64/parisc/ \
                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ \
+                                  -e s/riscv.*/riscv/)
 
 ifndef ARCH
 ARCH := $(HOSTARCH)
-- 
2.32.0

