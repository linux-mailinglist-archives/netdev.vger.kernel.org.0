Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194A0265108
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgIJUkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgIJUjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:39:52 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F43C061795
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:39:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l9so1893679wme.3
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocEsbJsYKfTKHSUPNnqmghxK9UPYZCRyMLNH7tBjmL8=;
        b=HfzjxAWtTqzRjUNMqyUvncuCLzXVQCK3M//rtyNC5DB/sY52ZcAroUcY6avtpaQDk4
         fdk6LYFSkHBSIhnmlXg7R/4N84U5GOAAtFKp/sPfy/ic9GFLNYw6V7dvllJ0PXUvhMg5
         V+SBKYMB5S7UQvDxyta44tLXMznVWy3tyPHy0MJg1mv1M7WQQGB7wrz6BYh3JXqzPpMV
         z2SFvFtNDyharTy9Fm86g4NI0MLZnnUQ9fNcM14MBOOeBniCbxsFC0DOXIRtqvUuSQ1L
         vaTlRTB9n2fxyoccqYHNrhvGXXmRsJKq6PFs+sI/Vo5366MjpO1q66UASOL0L8kLLhGW
         F17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ocEsbJsYKfTKHSUPNnqmghxK9UPYZCRyMLNH7tBjmL8=;
        b=K3spAfr9qwyJIvBVRvoa/GUFevb+SH9UoyTSe0AOBC56kBzeVjaDEkYkV5GwsSrQPs
         o+qhtc45kD6qYEAe2Dg9btge/nqHMz0FUuBzMIXKtfOyQMxrBbemAd7JHe14OEphy7VH
         grTZTRPIb+SScQ/7CyCGhMjuK4E2t28ImzjjsRuhTZDjYqxZ2nE9TwzgpWcnV5I5WxtN
         UjfY65l7wvOQIbRiVG5BIRiaHbDb7a5s06eW50bVtWNttirfmY8ALUO4ewS9QQlcXpGj
         5GVYV7nsRsXcItVrzB9Qg9PMOzftLZn15W/HDstV/PIs+bnsi93J2J8KsxEhAhT6GLkQ
         a4Aw==
X-Gm-Message-State: AOAM531TF9A77ZElmVudkOQZzLs2umRgih1igC+wFr8n6B1YqSFjEhNg
        4RKhAFFOfo3kjGa3RwQ4Jtl/pw==
X-Google-Smtp-Source: ABdhPJxtRL8ROieV+0DaG28HrExfNcCCh7t7DfWZtDMrOWebOXG1DcCE3thVrlJ8qKsZXuX0KXBnhw==
X-Received: by 2002:a7b:cb81:: with SMTP id m1mr1909559wmi.140.1599770381549;
        Thu, 10 Sep 2020 13:39:41 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.23])
        by smtp.gmail.com with ESMTPSA id c18sm11279713wrx.63.2020.09.10.13.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 13:39:41 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v4] tools: bpftool: automate generation for "SEE ALSO" sections in man pages
Date:   Thu, 10 Sep 2020 21:39:35 +0100
Message-Id: <20200910203935.25304-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "SEE ALSO" sections of bpftool's manual pages refer to bpf(2),
bpf-helpers(7), then all existing bpftool man pages (save the current
one).

This leads to nearly-identical lists being duplicated in all manual
pages. Ideally, when a new page is created, all lists should be updated
accordingly, but this has led to omissions and inconsistencies multiple
times in the past.

Let's take it out of the RST files and generate the "SEE ALSO" sections
automatically in the Makefile when generating the man pages. The lists
are not really useful in the RST anyway because all other pages are
available in the same directory.

v3:
- Fix conflict with a previous patchset that introduced RST2MAN_OPTS
  variable passed to rst2man.

v2:
- Use "echo -n" instead of "printf" in Makefile, to avoid any risk of
  passing a format string directly to the command.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/Makefile        | 12 +++++++++++-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst | 17 -----------------
 .../bpftool/Documentation/bpftool-cgroup.rst    | 16 ----------------
 .../bpftool/Documentation/bpftool-feature.rst   | 16 ----------------
 tools/bpf/bpftool/Documentation/bpftool-gen.rst | 16 ----------------
 .../bpf/bpftool/Documentation/bpftool-iter.rst  | 16 ----------------
 .../bpf/bpftool/Documentation/bpftool-link.rst  | 17 -----------------
 tools/bpf/bpftool/Documentation/bpftool-map.rst | 16 ----------------
 tools/bpf/bpftool/Documentation/bpftool-net.rst | 17 -----------------
 .../bpf/bpftool/Documentation/bpftool-perf.rst  | 17 -----------------
 .../bpf/bpftool/Documentation/bpftool-prog.rst  | 16 ----------------
 .../Documentation/bpftool-struct_ops.rst        | 17 -----------------
 tools/bpf/bpftool/Documentation/bpftool.rst     | 16 ----------------
 13 files changed, 11 insertions(+), 198 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index 5e3815320dab..4c9dd1e45244 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -30,11 +30,21 @@ man8: $(DOC_MAN8)
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
 RST2MAN_OPTS += --verbose
 
+list_pages = $(sort $(basename $(filter-out $(1),$(MAN8_RST))))
+see_also = $(subst " ",, \
+	"\n" \
+	"SEE ALSO\n" \
+	"========\n" \
+	"\t**bpf**\ (2),\n" \
+	"\t**bpf-helpers**\\ (7)" \
+	$(foreach page,$(call list_pages,$(1)),",\n\t**$(page)**\\ (8)") \
+	"\n")
+
 $(OUTPUT)%.8: %.rst
 ifndef RST2MAN_DEP
 	$(error "rst2man not found, but required to generate man pages")
 endif
-	$(QUIET_GEN)rst2man $(RST2MAN_OPTS) $< > $@
+	$(QUIET_GEN)( cat $< ; echo -n $(call see_also,$<) ) | rst2man $(RST2MAN_OPTS) > $@
 
 clean: helpers-clean
 	$(call QUIET_CLEAN, Documentation)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 52a7b2f6c9cb..ff4d327a582e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -217,20 +217,3 @@ All the standard ways to specify map or program are supported:
 **# bpftool btf dump prog tag b88e0a09b1d9759d**
 
 **# bpftool btf dump prog pinned /sys/fs/bpf/prog_name**
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 3dba89db000e..790944c35602 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -143,19 +143,3 @@ EXAMPLES
 ::
 
     ID       AttachType      AttachFlags     Name
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index f1aae5690e3c..dd3771bdbc57 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -72,19 +72,3 @@ DESCRIPTION
 OPTIONS
 =======
 	.. include:: common_options.rst
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 29d4cf4c3422..84cf0639696f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -279,19 +279,3 @@ and global variables.
   my_static_var: 7
 
 This is a stripped-out version of skeleton generated for above example code.
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
index b688cf11805c..51f49bead619 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -68,19 +68,3 @@ EXAMPLES
 
    Create a file-based bpf iterator from bpf_iter_hashmap.o and map with
    id 20, and pin it to /sys/fs/bpf/my_hashmap
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index ce122be58bae..5f7db2a837cc 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -106,20 +106,3 @@ EXAMPLES
 ::
 
     -rw------- 1 root root 0 Apr 23 21:39 link
-
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 4b42629ade3e..c50017cdc4df 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -264,19 +264,3 @@ would be lost as soon as bpftool exits).
 
   key: 00 00 00 00  value: 22 02 00 00
   Found 1 element
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 56439c32934d..d8165d530937 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -172,20 +172,3 @@ EXAMPLES
 ::
 
       xdp:
-
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index 36d257a36e9b..e958ce91de72 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -63,20 +63,3 @@ EXAMPLES
      {"pid":21765,"fd":5,"prog_id":7,"fd_type":"kretprobe","func":"__x64_sys_nanosleep","offset":0}, \
      {"pid":21767,"fd":5,"prog_id":8,"fd_type":"tracepoint","tracepoint":"sys_enter_nanosleep"}, \
      {"pid":21800,"fd":5,"prog_id":9,"fd_type":"uprobe","filename":"/home/yhs/a.out","offset":1159}]
-
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 9b2b18e2a3ac..358c7309d419 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -326,19 +326,3 @@ EXAMPLES
       40176203 cycles                                                 (83.05%)
       42518139 instructions    #   1.06 insns per cycle               (83.39%)
            123 llc_misses      #   2.89 LLC misses per million insns  (83.15%)
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index 315f1f21f2ba..506e70ee78e9 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -82,20 +82,3 @@ EXAMPLES
 ::
 
    Registered tcp_congestion_ops cubic id 110
-
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index b87f8c2df49d..e7d949334961 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -54,19 +54,3 @@ OPTIONS
 	-n, --nomount
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
-
-SEE ALSO
-========
-	**bpf**\ (2),
-	**bpf-helpers**\ (7),
-	**bpftool-btf**\ (8),
-	**bpftool-cgroup**\ (8),
-	**bpftool-feature**\ (8),
-	**bpftool-gen**\ (8),
-	**bpftool-iter**\ (8),
-	**bpftool-link**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-struct_ops**\ (8)
-- 
2.25.1

