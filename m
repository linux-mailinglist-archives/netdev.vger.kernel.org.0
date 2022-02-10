Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BA04B0B1F
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbiBJKmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:42:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239968AbiBJKms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:42:48 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E758FE2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:42:49 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id fy20so14211259ejc.0
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/DgZsZE/HDfyMIGrsvl2Ss1rzvht97lXiIVbHEcuqC0=;
        b=ptmdBux/8jgsJr8usd31KrBACc3pglqzbPrHZ4LVeRMOZhONUsa0hGnMi++0JEr4lO
         jvqr2snZ3/lqi+bkCQ+0xKnMJ8ZvqK0IklWLLDhL5X0TlHuAZeXzcCdFUcVix837yFvs
         WB+2v/M8j1p4vwZkFQZ329rnYG8DdTgYf+WIkCSrNYHAokxedEDMp0dlc+tpHtDwHyfL
         WoacZBtNWY/PpHXYQF0lFJXqCPzygy8kaZDWg+QB8JETZNFzGlWtYxcy3NCxnQzblM09
         ogAVVAaw6wQwNvlZQbLbkq/336sXCnToqR3TL3ZKAUMdXVQ9vKZGpCNXn/60ndmvXwwJ
         n1Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/DgZsZE/HDfyMIGrsvl2Ss1rzvht97lXiIVbHEcuqC0=;
        b=4GvvoCdy47xqq97KjkuMEIGm7FpHrpad9g4kgCoFbsP3VtlGTlAE/kqvwT3lpAjIew
         Y0VUaebImFhFxFO/ht2+YC7XJ3zM8ca7ZzqBza0XZ6aPrlbOmbvCW9el0RIBcmbsu1+Q
         +oJNG+gjCjjQvv8K9aeWW9RphXPN7bxfHz1+C0qiNBBeiBA0AxFqz5syVyGboV9B0dMI
         AE1BRkyhSxtln5nMaxBCcmkRx5yXiH7YyQ34Yv8aFTzy0Omi5U+VBqKwaqorkrh942OO
         ySQR+1hNJDw3fLJEzTe+e/cWViPJbabOgb05hQNcy2r/DZiJaIF/3TIC4df+0v3eVeaK
         pd1A==
X-Gm-Message-State: AOAM531nk1MYVrA/GVWtQGhyiGamdWoNL/mo1D5G5CauM4XhRs0+2sfZ
        5DCoo5YKUBD6y4xxVZWYgRy1yA==
X-Google-Smtp-Source: ABdhPJyLSF2kQZRNV+ztZliqS7rlSkanslbMnZSV/3Xn4n/nnEKVI9v/qMU4QbLSNi8ZvL5B7u2sOg==
X-Received: by 2002:a17:906:8396:: with SMTP id p22mr5784036ejx.153.1644489767400;
        Thu, 10 Feb 2022 02:42:47 -0800 (PST)
Received: from localhost.localdomain ([149.86.70.238])
        by smtp.gmail.com with ESMTPSA id w8sm6111839ejo.18.2022.02.10.02.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 02:42:46 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 2/2] bpftool: Update versioning scheme, align on libbpf's version number
Date:   Thu, 10 Feb 2022 10:42:37 +0000
Message-Id: <20220210104237.11649-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210104237.11649-1-quentin@isovalent.com>
References: <20220210104237.11649-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the notion of versions was introduced for bpftool, it has been
following the version number of the kernel (using the version number
corresponding to the tree in which bpftool's sources are located). The
rationale was that bpftool's features are loosely tied to BPF features
in the kernel, and that we could defer versioning to the kernel
repository itself.

But this versioning scheme is confusing today, because a bpftool binary
should be able to work with both older and newer kernels, even if some
of its recent features won't be available on older systems. Furthermore,
if bpftool is ported to other systems in the future, keeping a
Linux-based version number is not a good option.

Looking at other options, we could either have a totally independent
scheme for bpftool, or we could align it on libbpf's version number
(with an offset on the major version number, to avoid going backwards).
The latter comes with a few drawbacks:

- We may want bpftool releases in-between two libbpf versions. We can
  always append pre-release numbers to distinguish versions, although
  those won't look as "official" as something with a proper release
  number. But at the same time, having bpftool with version numbers that
  look "official" hasn't really been an issue so far.

- If no new feature lands in bpftool for some time, we may move from
  e.g. 6.7.0 to 6.8.0 when libbpf levels up and have two different
  versions which are in fact the same.

- Following libbpf's versioning scheme sounds better than kernel's, but
  ultimately it doesn't make too much sense either, because even though
  bpftool uses the lib a lot, its behaviour is not that much conditioned
  by the internal evolution of the library (or by new APIs that it may
  not use).

Having an independent versioning scheme solves the above, but at the
cost of heavier maintenance. Developers will likely forget to increase
the numbers when adding features or bug fixes, and we would take the
risk of having to send occasional "catch-up" patches just to update the
version number.

Based on these considerations, this patch aligns bpftool's version
number on libbpf's. This is not a perfect solution, but 1) it's
certainly an improvement over the current scheme, 2) the issues raised
above are all minor at the moment, and 3) we can still move to an
independent scheme in the future if we realise we need it.

Given that libbpf is currently at version 0.7.0, and bpftool, before
this patch, was at 5.16, we use an offset of 6 for the major version,
bumping bpftool to 6.7.0. Libbpf does not export its patch number;
leave bpftool's patch number at 0 for now.

It remains possible to manually override the version number by setting
BPFTOOL_VERSION when calling make.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile |  6 ++----
 tools/bpf/bpftool/main.c   | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 83369f55df61..94b2c2f4ad43 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -39,10 +39,6 @@ LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
 LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
 
-ifeq ($(BPFTOOL_VERSION),)
-BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
-endif
-
 $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
 	$(QUIET_MKDIR)mkdir -p $@
 
@@ -83,7 +79,9 @@ CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
 	-I$(srctree)/kernel/bpf/ \
 	-I$(srctree)/tools/include \
 	-I$(srctree)/tools/include/uapi
+ifneq ($(BPFTOOL_VERSION),)
 CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
+endif
 ifneq ($(EXTRA_CFLAGS),)
 CFLAGS += $(EXTRA_CFLAGS)
 endif
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 0f2f8de514a4..e81227761f5d 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -71,6 +71,17 @@ static int do_help(int argc, char **argv)
 	return 0;
 }
 
+#ifndef BPFTOOL_VERSION
+/* bpftool's major and minor version numbers are aligned on libbpf's. There is
+ * an offset of 6 for the version number, because bpftool's version was higher
+ * than libbpf's when we adopted this scheme. The patch number remains at 0
+ * for now. Set BPFTOOL_VERSION to override.
+ */
+#define BPFTOOL_MAJOR_VERSION (LIBBPF_MAJOR_VERSION + 6)
+#define BPFTOOL_MINOR_VERSION LIBBPF_MINOR_VERSION
+#define BPFTOOL_PATCH_VERSION 0
+#endif
+
 static int do_version(int argc, char **argv)
 {
 #ifdef HAVE_LIBBFD_SUPPORT
@@ -88,7 +99,12 @@ static int do_version(int argc, char **argv)
 		jsonw_start_object(json_wtr);	/* root object */
 
 		jsonw_name(json_wtr, "version");
+#ifdef BPFTOOL_VERSION
 		jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
+#else
+		jsonw_printf(json_wtr, "\"%d.%d.%d\"", BPFTOOL_MAJOR_VERSION,
+			     BPFTOOL_MINOR_VERSION, BPFTOOL_PATCH_VERSION);
+#endif
 		jsonw_name(json_wtr, "libbpf_version");
 		jsonw_printf(json_wtr, "\"%d.%d\"",
 			     libbpf_major_version(), libbpf_minor_version());
@@ -104,7 +120,12 @@ static int do_version(int argc, char **argv)
 	} else {
 		unsigned int nb_features = 0;
 
+#ifdef BPFTOOL_VERSION
 		printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
+#else
+		printf("%s v%d.%d.%d\n", bin_name, BPFTOOL_MAJOR_VERSION,
+		       BPFTOOL_MINOR_VERSION, BPFTOOL_PATCH_VERSION);
+#endif
 		printf("using libbpf %s\n", libbpf_version_string());
 		printf("features:");
 		if (has_libbfd) {
-- 
2.32.0

