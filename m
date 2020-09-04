Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9539F25E323
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 22:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgIDU5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 16:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgIDU5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 16:57:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEEDC06124F
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 13:57:16 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j2so8533355wrx.7
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 13:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=To4S7LjyUWtP7KUdnpYu2HjEawfwj/tPoQQdRfIdQL8=;
        b=SsQ50jED4ToQXn1g62l+546zd57QLcVzHkUgoxNC8aBeM+imsO+V8BvFKWfDgqbjX0
         TypAC+OgIePl5vwioohEx/7MlR5JpWigFrLvl0PM+0UT0UzgSFZTlE1DVH9CR9jzEEPi
         WS3+kIT06ZYySC7x9HG2f4JVI1eSRae09Iw4zJqArYYzqCdRJnjrKuLeCIYzmsAZZynE
         UVyNZP/LVs+6ZjZX0+D4HlxqIrNvJaZY49UYgBuNZd01ycH4mnxRNIu4dthQxXMIso2P
         oxdjPHAbBbq8GCQanPjSpVCfd1B1KG3UDDCsc92wbGf1yQz/7R1l3OlwgABwLUS3VDgn
         H4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=To4S7LjyUWtP7KUdnpYu2HjEawfwj/tPoQQdRfIdQL8=;
        b=ZMzdk10R4Icryls1NcDO/D3H/97Vk6dbqbkor538rn4hU4vCrDK0Br7ClheL/FJjRF
         S9VZoUtrOwdjUx6ic+UJxxGLpNdQhRZsm9MbOOhZciuHeoEc/vZ/Av22yhBpYfwwoOMY
         eXUOkBKrlUsBaxJWQ6+KTz0XFUvTyEJoIH+zYkPKzbL5jEKicG9UIU7GxTUUc6NCihXL
         5U9wAaj5Xdb8vhgKOE2qIlh0VnLQZ0rGv0nswfUZmzEk6vGqhJIOXpJb7b08tbA05iUS
         Ubq2C+Z3dAZe0vQuG6uMTnLydh9xrbgrbxu7ACpVm/Dhra6I5RctGK1mokC5rsn0LrTL
         v1PA==
X-Gm-Message-State: AOAM532nGwSURw2HxDNWdA2xlvK9wcSwYk2bmBlEscurb8uQZ4Zhx6eN
        YSdnuE6PZn0aWc+bKuL6fxLLNw==
X-Google-Smtp-Source: ABdhPJzYQ1u4JmSEEIRjbHCIhf823iY+Uy0yhqgxodtqUhYGZ/zdOEL6g2Nk4uies7mXBjT7UtENow==
X-Received: by 2002:adf:9c93:: with SMTP id d19mr9440821wre.275.1599253034223;
        Fri, 04 Sep 2020 13:57:14 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.177])
        by smtp.gmail.com with ESMTPSA id u17sm12985395wmm.4.2020.09.04.13.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 13:57:13 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 3/3] tools: bpftool: automate generation for "SEE ALSO" sections in man pages
Date:   Fri,  4 Sep 2020 21:56:57 +0100
Message-Id: <20200904205657.27922-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200904205657.27922-1-quentin@isovalent.com>
References: <20200904205657.27922-1-quentin@isovalent.com>
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

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
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
index becbb8c52257..86233619215c 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -29,11 +29,21 @@ man8: $(DOC_MAN8)
 
 RST2MAN_DEP := $(shell command -v rst2man 2>/dev/null)
 
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
-	$(QUIET_GEN)rst2man $< > $@
+	$(QUIET_GEN)( cat $< ; printf $(call see_also,$<) ) | rst2man > $@
 
 clean: helpers-clean
 	$(call QUIET_CLEAN, Documentation)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 0020bb55cf7e..b3e909ef6791 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -214,20 +214,3 @@ All the standard ways to specify map or program are supported:
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
index e3b7ff3c09d7..8b4a18463d55 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -275,19 +275,3 @@ and global variables.
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
index 001689efc7fa..8e4e28c1b78a 100644
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
index e06a65cd467e..4fe8632bb3a3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -261,19 +261,3 @@ would be lost as soon as bpftool exits).
 
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

