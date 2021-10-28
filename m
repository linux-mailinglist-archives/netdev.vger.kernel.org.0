Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6E43E1EC
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJ1NXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:23:19 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:39932 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhJ1NXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:23:16 -0400
Received: by mail-lf1-f43.google.com with SMTP id l13so13543052lfg.6;
        Thu, 28 Oct 2021 06:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FpcAIXzIJRZanZR1xOZ449nR9Z4CpuYm3hzQzUAM83c=;
        b=XVAWzlD/2JRCwfZwkRyyJ8JLXC1O6uqch3vvvcONWl1ZLOwn1cLhY6aiq4eb1h4Zv5
         41JgjLDjCcR1xNOkznH9otKbxC2S6p45A6NUoYGC0xyXTJK0U0cUQyxe8UTarqYZ35LK
         shLjxNeO7vSSUvkFUAwxctXIda+lTmT3o1qFVBR5Ccmgj+vtcgHTa0Cdp/wCq6Bi6Vwh
         kfrZjBXlhsZTE+/ExXhFeejPI5Iva8ix0SI5gW0ThNMLyhm3jYQj4etnCd/cVT6QIIyd
         2gIFR1zSufKhcJr7nDDbOHXLHZHxYObY0C1aVWbSXvxfXfC/hAwT2lIG56/JsSwmaKox
         W2dw==
X-Gm-Message-State: AOAM53377jd4Mw80y5n6MUHZDCxo8kkyn2qTlqsYJ4iwJcnAW0DSt9GZ
        5r3uxhxjKSVW55pDBMTuu0Q=
X-Google-Smtp-Source: ABdhPJzpoIYhfju6k4/Qfnivw7wHlSlK52r59+vqI6IlaJ3X5/OYjMzzZhfjKSvZC4Rv3XnX0kOmUQ==
X-Received: by 2002:a05:6512:3b20:: with SMTP id f32mr4083761lfv.423.1635427248082;
        Thu, 28 Oct 2021 06:20:48 -0700 (PDT)
Received: from kladdkakan.. ([185.213.154.234])
        by smtp.gmail.com with ESMTPSA id o9sm309616lfk.292.2021.10.28.06.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 06:20:47 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH bpf-next 2/4] tools build: Add RISC-V to HOSTARCH parsing
Date:   Thu, 28 Oct 2021 15:20:39 +0200
Message-Id: <20211028132041.516820-3-bjorn@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211028132041.516820-1-bjorn@kernel.org>
References: <20211028132041.516820-1-bjorn@kernel.org>
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

