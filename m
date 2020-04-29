Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D4E1BE170
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgD2OpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 10:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2OpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 10:45:15 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB17C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:45:14 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k1so2879049wrx.4
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DPPOrgBA7YSTdrd+i7ZC6pH/Ktq+pTutZ/a9hfmxBNY=;
        b=Cu8Xcoo9BIhJUKO3/OO3pntl2jZytTlHH0vNoLfclyIkpyfmN0/woDWnHUoL90J2a7
         Dz1G+jhB/GC3ifPy/XfZ3vTXx+roQEZnywH2ztQ7jIZYAXsGIzhKdUIrFe3MgjGqePBq
         4KxzIt20q37UWrtNKnmY1g5BfJBiunqlcAt2WzQF7F6yY0drXmTPFEIKsEHTPrfisxik
         BPfHtRewNFGrYibuVMlKgtavgQVoJPh/K9dRABeXx6n89ZuMtjxLTxKwVvoUhdo4ldfp
         Sf6fBG4ANITGVNDeJezePBBiRFQCrbRjvAm0xjIao+H36fhEHZK4gwh9wjYjIO0tYLyF
         75Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPPOrgBA7YSTdrd+i7ZC6pH/Ktq+pTutZ/a9hfmxBNY=;
        b=XEKEffmMYXZYf30wbbNDJtSCk/+cNbLJxN+sedgIXMhuUJYtvTomvDq0Ro7SEzY1e+
         g84nJJOzEyc1lVFZjx4IXTCkkbBz+Em5Jvr7tYfYX04lJKXgCt6OBoHViWz6lmun2QCi
         fD5BdD+LFHedONeQD7dUoqzikt1EWi661vn9LomdLs/6osMa27e3IIDKA4aHWVPKVaHV
         QFxLETP6ojHTYxn/aI+xrfRSs9lleGcohe3mbmGVOnDIUBFiKwtN2qq/HOSUGVivyR17
         IZ20E1QESPZOcSuoM99CmhPcWiEjffNPMA2/Mi0dAjCj08jYWmNWT9UNuDkCDE9IqsIr
         ppjg==
X-Gm-Message-State: AGi0PuYbQVPcxJQKwE/MUmqUSjTU4lCXZgAsVd3N8KMkBt7DiNc8635f
        ieexXxHCSUhH6U7RIp8adKMSCg==
X-Google-Smtp-Source: APiQypKacRfK99rf6iQOnxtQnKY1aL5+xx4THk8Igo/+4QWdtzZAGWlpf5bor+7yahyBS/O7wTHAmw==
X-Received: by 2002:adf:d091:: with SMTP id y17mr38466279wrh.418.1588171513405;
        Wed, 29 Apr 2020 07:45:13 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.38])
        by smtp.gmail.com with ESMTPSA id a10sm20071739wrg.32.2020.04.29.07.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 07:45:12 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Richard Palethorpe <rpalethorpe@suse.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH bpf-next v3 3/3] tools: bpftool: make libcap dependency optional
Date:   Wed, 29 Apr 2020 15:45:06 +0100
Message-Id: <20200429144506.8999-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429144506.8999-1-quentin@isovalent.com>
References: <20200429144506.8999-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new libcap dependency is not used for an essential feature of
bpftool, and we could imagine building the tool without checks on
CAP_SYS_ADMIN by disabling probing features as an unprivileged users.

Make it so, in order to avoid a hard dependency on libcap, and to ease
packaging/embedding of bpftool.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpftool/Documentation/bpftool-feature.rst |  4 ++-
 tools/bpf/bpftool/Makefile                    | 13 +++++++---
 tools/bpf/bpftool/feature.c                   | 26 +++++++++++++++++++
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index ca085944e4cf..1fa755f55e0c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -55,7 +55,9 @@ DESCRIPTION
 		  that case usually represent a small subset of the parameters
 		  supported by the system. Unprivileged users MUST use the
 		  **unprivileged** keyword: This is to avoid misdetection if
-		  bpftool is inadvertently run as non-root, for example.
+		  bpftool is inadvertently run as non-root, for example. This
+		  keyword is unavailable if bpftool was compiled without
+		  libcap.
 
 	**bpftool feature probe dev** *NAME* [**full**] [**macros** [**prefix** *PREFIX*]]
 		  Probe network device for supported eBPF features and dump
diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 89d7962a4a44..2759f9cc3289 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -55,16 +55,15 @@ ifneq ($(EXTRA_LDFLAGS),)
 LDFLAGS += $(EXTRA_LDFLAGS)
 endif
 
-LIBS = $(LIBBPF) -lelf -lz -lcap
-
 INSTALL ?= install
 RM ?= rm -f
 CLANG ?= clang
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib \
+FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libcap \
+	clang-bpf-global-var
+FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
 	clang-bpf-global-var
-FEATURE_DISPLAY = libbfd disassembler-four-args zlib clang-bpf-global-var
 
 check_feat := 1
 NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
@@ -90,6 +89,12 @@ ifeq ($(feature-reallocarray), 0)
 CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
 endif
 
+LIBS = $(LIBBPF) -lelf -lz
+ifeq ($(feature-libcap), 1)
+CFLAGS += -DUSE_LIBCAP
+LIBS += -lcap
+endif
+
 include $(wildcard $(OUTPUT)*.d)
 
 all: $(OUTPUT)bpftool
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 952f4b1987c0..f54347f55ee0 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -6,7 +6,9 @@
 #include <string.h>
 #include <unistd.h>
 #include <net/if.h>
+#ifdef USE_LIBCAP
 #include <sys/capability.h>
+#endif
 #include <sys/utsname.h>
 #include <sys/vfs.h>
 
@@ -37,7 +39,9 @@ static const char * const helper_name[] = {
 #undef BPF_HELPER_MAKE_ENTRY
 
 static bool full_mode;
+#ifdef USE_LIBCAP
 static bool run_as_unprivileged;
+#endif
 
 /* Miscellaneous utility functions */
 
@@ -475,11 +479,13 @@ probe_prog_type(enum bpf_prog_type prog_type, bool *supported_types,
 		}
 
 	res = bpf_probe_prog_type(prog_type, ifindex);
+#ifdef USE_LIBCAP
 	/* Probe may succeed even if program load fails, for unprivileged users
 	 * check that we did not fail because of insufficient permissions
 	 */
 	if (run_as_unprivileged && errno == EPERM)
 		res = false;
+#endif
 
 	supported_types[prog_type] |= res;
 
@@ -535,12 +541,14 @@ probe_helper_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
 
 	if (supported_type) {
 		res = bpf_probe_helper(id, prog_type, ifindex);
+#ifdef USE_LIBCAP
 		/* Probe may succeed even if program load fails, for
 		 * unprivileged users check that we did not fail because of
 		 * insufficient permissions
 		 */
 		if (run_as_unprivileged && errno == EPERM)
 			res = false;
+#endif
 	}
 
 	if (json_output) {
@@ -738,6 +746,7 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
 
 static int handle_perms(void)
 {
+#ifdef USE_LIBCAP
 	cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
 	bool has_sys_admin_cap = false;
 	cap_flag_value_t val;
@@ -793,6 +802,18 @@ static int handle_perms(void)
 	}
 
 	return res;
+#else
+	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
+	 * We do not use libpcap so let's approximate, and restrict usage to
+	 * root user only.
+	 */
+	if (geteuid()) {
+		p_err("full feature probing requires root privileges");
+		return -1;
+	}
+
+	return 0;
+#endif /* USE_LIBCAP */
 }
 
 static int do_probe(int argc, char **argv)
@@ -852,8 +873,13 @@ static int do_probe(int argc, char **argv)
 				return -1;
 			define_prefix = GET_ARG();
 		} else if (is_prefix(*argv, "unprivileged")) {
+#ifdef USE_LIBCAP
 			run_as_unprivileged = true;
 			NEXT_ARG();
+#else
+			p_err("unprivileged run not supported, recompile bpftool with libcap");
+			return -1;
+#endif
 		} else {
 			p_err("expected no more arguments, 'kernel', 'dev', 'macros' or 'prefix', got: '%s'?",
 			      *argv);
-- 
2.20.1

