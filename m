Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A652A434847
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhJTJus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhJTJuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:50:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B25C061746
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:48:31 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 186-20020a1c01c3000000b0030d8315b593so43683wmb.5
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ougTqSI43mpGEeXGGeV7HdH0kcNeLAHBNKcw/aNxG0Q=;
        b=b9VIkLl2FKsPXXxC0LoBkICKqF/6ewaqbHX0OrRlH/k651tDOplC8ta20geQDjMJFa
         SBwbY4ElBbzCOh2weKYrXj8MK4PmJfzPlrnuSCbaQ/H85p7k3Gtvegn0oO+vruKhhTh8
         ufTb04S72GOzYmPRnMqoD7A7egn+zlj8JGb04bbnkDdDLHSPOp/PSaoTynmrQUQHsHIs
         tk3CU0+umkpjGjVr3SFb/sPGiJGyEevN32LqU9gLMTmuzKquCwTUJzL9zMZ8PdCnyCAC
         8Frv6xssDkqGXNfktPShCU0Wo620LO+Iut0w5eoGfNpkb8zS+YQT+sAI9iEzfJQ9ibHp
         diGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ougTqSI43mpGEeXGGeV7HdH0kcNeLAHBNKcw/aNxG0Q=;
        b=x5xRIiDS85h3B8mNlWqlcaEFBUAxjvOk6ZepqZOYI21QzzzTCfRee1nj6RfkxZ2nez
         8B85sZnCYeZLAqUbD5W8P8r+i+S0MGDQCqEV6K4Lrj4khaEfFDBeEfx9N3NDiIDWnTGm
         8ZacVoSG9b86f9Mv/GT0goSY1ioBf+3KR1/FQIWbc3Nh3ki8Bmy/r2ykQFOXJsaOSogE
         ljYaiJvvfof9Zgf6/y2NQc7R9Fzzt9BVeRz0gNMmcSo95IGxf2SUTBdx7zHmWXOAmW7N
         gbDaMOmMybZ0DDL4QZn3wasnEmFf85vEHLd8YV4q2hUjLGVS99yOWEhZVpYegQA3vlNJ
         /xtw==
X-Gm-Message-State: AOAM530+AH0I3VkmAc0dEtuLZ+AQFeAUkLMFmgODbR9v+j3YtmdWUWrh
        zGaO9Fvle2fWrc+GGDMS2Bc68Q==
X-Google-Smtp-Source: ABdhPJy/CzoTxj+QZZDk1GlgYzq8p1gpOuW7IIGVTwniW042eJfBVNe4akk+8mjOQ5dywpWd2T7RtQ==
X-Received: by 2002:adf:f1cd:: with SMTP id z13mr51246252wro.101.1634723310488;
        Wed, 20 Oct 2021 02:48:30 -0700 (PDT)
Received: from localhost.localdomain ([149.86.71.75])
        by smtp.gmail.com with ESMTPSA id n12sm1767020wri.22.2021.10.20.02.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 02:48:30 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpftool: remove useless #include to <perf-sys.h> from map_perf_ring.c
Date:   Wed, 20 Oct 2021 10:48:26 +0100
Message-Id: <20211020094826.16046-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header is no longer needed since the event_pipe implementation
was updated to rely on libbpf's perf_buffer. This makes bpftool free of
dependencies to perf files, and we can update the Makefile accordingly.

Fixes: 9b190f185d2f ("tools/bpftool: switch map event_pipe to libbpf's perf_buffer")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile        | 3 +--
 tools/bpf/bpftool/map_perf_ring.c | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index abcef1f72d65..098d762e111a 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -73,8 +73,7 @@ CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(LIBBPF_INCLUDE) \
 	-I$(srctree)/kernel/bpf/ \
 	-I$(srctree)/tools/include \
-	-I$(srctree)/tools/include/uapi \
-	-I$(srctree)/tools/perf
+	-I$(srctree)/tools/include/uapi
 CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
 ifneq ($(EXTRA_CFLAGS),)
 CFLAGS += $(EXTRA_CFLAGS)
diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
index 825f29f93a57..b98ea702d284 100644
--- a/tools/bpf/bpftool/map_perf_ring.c
+++ b/tools/bpf/bpftool/map_perf_ring.c
@@ -22,7 +22,6 @@
 #include <sys/syscall.h>
 
 #include <bpf/bpf.h>
-#include <perf-sys.h>
 
 #include "main.h"
 
-- 
2.30.2

