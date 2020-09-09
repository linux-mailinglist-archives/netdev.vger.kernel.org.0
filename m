Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6577B2631A9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731041AbgIIQXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730959AbgIIQXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:23:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B350C0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:22:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id c18so3612592wrm.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0jB7YDfWeL0yhNH+AB7wsbwPBZkx4fR9TlB1ZNRvmc=;
        b=ISFL2M6TX5LesvnAsTisLumGNCQJaFiODGwy/XuPQ5M7N2wTUtLsw/FLpS2x2Fuk/P
         p7gJTYujZ2Dpycga+My5JJar3frkcy+vz6O+ihAEA3EkGmdd/4VUD8289yzqBJ2jjZNp
         v0MDU7gdya/4Y71uguWGuZwOeT24Xg3CDtfj3IL75yd9mOAVxF1N3Gb1dUhbyPKh3jfl
         qVIopbtm8CazJAt5O477Pj3+33cLbnWed6ERuCmM6+HLAQWEmrqyK0qjPdNaLsZwjBRU
         jrkc6FuOmTeC38XNZtSMczYAj0K9OUAdF+FyUd1DW2VHP8NHlSZw7ovWJUYQ6f6xGPpb
         nACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0jB7YDfWeL0yhNH+AB7wsbwPBZkx4fR9TlB1ZNRvmc=;
        b=hI2edZU7YXwSyB+szrpgnHBOwpFwzwMV4eHfB7hqhtgb2gqUQM5IfT5fV47Y69288X
         sfMWaH2XjXq+JZIjGRvAXSOggR5nEkErBMRgDIgzk9fv2yqcRwGv0lG66pC6ndVJNXs4
         1BXqHDAl1q/2RJx56HN4hxgRsiRApDwCnOIsDR0PfLSfI0EjRIBtSA5D3ugqPUEkCxiU
         hk6SXqvoQJVrT2ClDRl030GJN+iPV8HNFhnvv8aFR4TuVxjhGAR6aaU/15dwyLf0EdWE
         1LF5y/abBjSLW0Gb31p2nVy4A9EGvhTcoiHBqiPGk6F0OGtOsVIPmhZdjLoqN8FNgiKX
         p2wA==
X-Gm-Message-State: AOAM5315CkeCgo+jF+C5xl7+k6ZwvDf5sUe96BHYDL4aq2cYnNULhk0B
        6bSR/gRtjb0i5z6fD1+9hBKwU+Lp+uFshC9jFQk=
X-Google-Smtp-Source: ABdhPJzbcaryeKOzvSIsxfeVSiseXUL8nrmPCd+wwr116qY41EIg1K+hl/eKtfAk1WFWdX0lrQSErw==
X-Received: by 2002:a05:6000:1003:: with SMTP id a3mr4802353wrx.258.1599668574685;
        Wed, 09 Sep 2020 09:22:54 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.149])
        by smtp.gmail.com with ESMTPSA id m1sm4747787wmc.28.2020.09.09.09.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:22:54 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v2 1/2] tools: bpftool: log info-level messages when building bpftool man pages
Date:   Wed,  9 Sep 2020 17:22:50 +0100
Message-Id: <20200909162251.15498-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909162251.15498-1-quentin@isovalent.com>
References: <20200909162251.15498-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To build man pages for bpftool (and for eBPF helper functions), rst2man
can log different levels of information. Let's make it log all levels
to keep the RST files clean.

Doing so, rst2man complains about double colons, used for literal
blocks, that look like underlines for section titles. Let's add the
necessary blank lines.

v2:
- Use "--verbose" instead of "-r 1" (same behaviour but more readable).
- Pass it through a RST2MAN_OPTS variable so we can easily pass other
  options too.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/Makefile        | 3 ++-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst | 3 +++
 tools/bpf/bpftool/Documentation/bpftool-gen.rst | 4 ++++
 tools/bpf/bpftool/Documentation/bpftool-map.rst | 3 +++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index 815ac9804aee..a45b51d98468 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -28,12 +28,13 @@ man: man8 helpers
 man8: $(DOC_MAN8)
 
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
+RST2MAN_OPTS += --verbose
 
 $(OUTPUT)%.8: %.rst
 ifndef RST2MAN_DEP
 	$(error "rst2man not found, but required to generate man pages")
 endif
-	$(QUIET_GEN)rst2man $< > $@
+	$(QUIET_GEN)rst2man $(RST2MAN_OPTS) $< > $@
 
 clean: helpers-clean
 	$(call QUIET_CLEAN, Documentation)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 896f4c6c2870..864553e62af4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -91,6 +91,7 @@ OPTIONS
 EXAMPLES
 ========
 **# bpftool btf dump id 1226**
+
 ::
 
   [1] PTR '(anon)' type_id=2
@@ -104,6 +105,7 @@ EXAMPLES
 This gives an example of default output for all supported BTF kinds.
 
 **$ cat prog.c**
+
 ::
 
   struct fwd_struct;
@@ -144,6 +146,7 @@ This gives an example of default output for all supported BTF kinds.
   }
 
 **$ bpftool btf dump file prog.o**
+
 ::
 
   [1] PTR '(anon)' type_id=2
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index df85dbd962c0..d52b03a352d7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -146,6 +146,7 @@ OPTIONS
 EXAMPLES
 ========
 **$ cat example.c**
+
 ::
 
   #include <stdbool.h>
@@ -187,6 +188,7 @@ This is example BPF application with two BPF programs and a mix of BPF maps
 and global variables.
 
 **$ bpftool gen skeleton example.o**
+
 ::
 
   /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
@@ -241,6 +243,7 @@ and global variables.
   #endif /* __EXAMPLE_SKEL_H__ */
 
 **$ cat example_user.c**
+
 ::
 
   #include "example.skel.h"
@@ -283,6 +286,7 @@ and global variables.
   }
 
 **# ./example_user**
+
 ::
 
   my_map name: my_map
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 083db6c2fc67..8f187c6416cd 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -182,6 +182,7 @@ OPTIONS
 EXAMPLES
 ========
 **# bpftool map show**
+
 ::
 
   10: hash  name some_map  flags 0x0
@@ -203,6 +204,7 @@ The following three commands are equivalent:
 
 
 **# bpftool map dump id 10**
+
 ::
 
   key: 00 01 02 03  value: 00 01 02 03 04 05 06 07
@@ -210,6 +212,7 @@ The following three commands are equivalent:
   Found 2 elements
 
 **# bpftool map getnext id 10 key 0 1 2 3**
+
 ::
 
   key:
-- 
2.25.1

