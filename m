Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D7313DB90
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAPNXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:23:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52071 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727026AbgAPNWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 08:22:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579180941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dddkGyog6/ukNzxfITycfkaFpImnWg5YZpf57HIco9g=;
        b=JPk1IALQ4iON3jTpKc9aPujw/uuB2qQ8jMmIK16RC4Eyj7Ikuz9rVd1wnOGl7ARyltgLIV
        sS4ErMtapyDa8+scEBhfvHIldGUR5ezEKWkoOgrO91UVTwMfGS4STlyfmiLpo6W173+XgD
        N8vS64q7iAuSEyHseqvj+wUeztQnypg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-SAg_UAdrOoqO6QZqgYpHAw-1; Thu, 16 Jan 2020 08:22:20 -0500
X-MC-Unique: SAg_UAdrOoqO6QZqgYpHAw-1
Received: by mail-lj1-f200.google.com with SMTP id r14so5126356ljc.18
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 05:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=dddkGyog6/ukNzxfITycfkaFpImnWg5YZpf57HIco9g=;
        b=dFw5v9f4p026HAQvqlNfs21bUDOzuB+1fA4UNQWV+agTYQxsDORbVvbFRGQ1+zGH2T
         LWdsvlwLmSw9IZ/HwLCTE2ch+3QtIuT+X/AxxAWJ28ZQEvGJCyxTpU7g1ZBIuAkyDJyG
         EQzZsdEsSjECacb3hcHWFeOmzVqYHyxhQ+FUNCwL0Vt1l9v/ECqEyAm3/NTTmOSUr4iX
         UqdtmQZTQ4fS/7vGx9qhw6yyWUezcHY4n0HU1wsrmdgQa+SbzOpssF6sfJT5LrwPVrTx
         zjux/uKOVg/DiIwufTE8uiUp7Wk9Wx7VnVXsGcV1c9bAZN0ygTyTLdta8K/bKk4tWgLF
         DSeg==
X-Gm-Message-State: APjAAAWdYbZYq8aS9LHwgKjIrtXPABc6AvG297+VrsA2+hp+K4E9AH6v
        EmvfaQyHjdGMVUO/70aiO/KCv1yPCUujwhnbkOWDcNW1MDQIr+c5KIFKZm+X4GyZbPeVNn1srFD
        TPG3XqEyyoRxLKfvB
X-Received: by 2002:a19:3f51:: with SMTP id m78mr2377253lfa.70.1579180938889;
        Thu, 16 Jan 2020 05:22:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqxHM8ojNS2+z7RRp2C22+OxchWf4eKxJheokOyRKS33/7g/+IOIFCtNATZQpBdA7df3Cna3AQ==
X-Received: by 2002:a19:3f51:: with SMTP id m78mr2377225lfa.70.1579180938699;
        Thu, 16 Jan 2020 05:22:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 140sm10713621lfk.78.2020.01.16.05.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:22:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 39AED1804D7; Thu, 16 Jan 2020 14:22:16 +0100 (CET)
Subject: [PATCH bpf-next v3 04/11] tools/runqslower: Use consistent include
 paths for libbpf
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Thu, 16 Jan 2020 14:22:16 +0100
Message-ID: <157918093613.1357254.10230277763921623892.stgit@toke.dk>
In-Reply-To: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Fix the runqslower tool to include libbpf header files with the bpf/
prefix, to be consistent with external users of the library. Also ensure
that all includes of exported libbpf header files (those that are exported
on 'make install' of the library) use bracketed includes instead of quoted.

To not break the build, keep the old include path until everything has been
changed to the new one; a subsequent patch will remove that.

Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are taken from selftests dir")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/bpf/runqslower/Makefile         |    5 +++--
 tools/bpf/runqslower/runqslower.bpf.c |    2 +-
 tools/bpf/runqslower/runqslower.c     |    4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
index 89fb7cd30f1a..c0512b830805 100644
--- a/tools/bpf/runqslower/Makefile
+++ b/tools/bpf/runqslower/Makefile
@@ -5,6 +5,7 @@ LLC := llc
 LLVM_STRIP := llvm-strip
 DEFAULT_BPFTOOL := $(OUTPUT)/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
+LIBBPF_INCLUDE := -I$(abspath ../../lib) -I$(abspath ../../lib/bpf)
 LIBBPF_SRC := $(abspath ../../lib/bpf)
 CFLAGS := -g -Wall
 
@@ -57,13 +58,13 @@ $(OUTPUT)/%.skel.h: $(OUTPUT)/%.bpf.o | $(BPFTOOL)
 
 $(OUTPUT)/%.bpf.o: %.bpf.c $(OUTPUT)/libbpf.a | $(OUTPUT)
 	$(call msg,BPF,$@)
-	$(Q)$(CLANG) -g -O2 -target bpf -I$(OUTPUT) -I$(LIBBPF_SRC)	      \
+	$(Q)$(CLANG) -g -O2 -target bpf -I$(OUTPUT) $(LIBBPF_INCLUDE)	      \
 		 -c $(filter %.c,$^) -o $@ &&				      \
 	$(LLVM_STRIP) -g $@
 
 $(OUTPUT)/%.o: %.c | $(OUTPUT)
 	$(call msg,CC,$@)
-	$(Q)$(CC) $(CFLAGS) -I$(LIBBPF_SRC) -I$(OUTPUT) -c $(filter %.c,$^) -o $@
+	$(Q)$(CC) $(CFLAGS) $(LIBBPF_INCLUDE) -I$(OUTPUT) -c $(filter %.c,$^) -o $@
 
 $(OUTPUT):
 	$(call msg,MKDIR,$@)
diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
index 623cce4d37f5..48a39f72fadf 100644
--- a/tools/bpf/runqslower/runqslower.bpf.c
+++ b/tools/bpf/runqslower/runqslower.bpf.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
 #include "vmlinux.h"
-#include <bpf_helpers.h>
+#include <bpf/bpf_helpers.h>
 #include "runqslower.h"
 
 #define TASK_RUNNING 0
diff --git a/tools/bpf/runqslower/runqslower.c b/tools/bpf/runqslower/runqslower.c
index 996f0e2c560e..d89715844952 100644
--- a/tools/bpf/runqslower/runqslower.c
+++ b/tools/bpf/runqslower/runqslower.c
@@ -6,8 +6,8 @@
 #include <string.h>
 #include <sys/resource.h>
 #include <time.h>
-#include <libbpf.h>
-#include <bpf.h>
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
 #include "runqslower.h"
 #include "runqslower.skel.h"
 

