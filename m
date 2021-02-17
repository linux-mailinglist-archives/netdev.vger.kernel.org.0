Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156A031D3A8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhBQBLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhBQBJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:46 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA48C061356;
        Tue, 16 Feb 2021 17:09:01 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a24so6482605plm.11;
        Tue, 16 Feb 2021 17:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MNhCRc2GDeasyRbwo0O5IIW2sQmDlpog5LT65h+9PRk=;
        b=JpCYdxlyW95RjiZUbReMdnBgSVsTjSPc6zv/iVoYOlyEwC+66tXG4BHVep1YcmzR5w
         8DzTWwMgqt/Wg7XuBxjyckL1UUX+nZcQver2h/Qo3syG3sa7PMp4AnfqPlnrrO+2wzu3
         7oryBVvplwAotyQpNJRqsrQvc6hEIn+Sr0C22awd/9o7MvRgTEtaNyCD+VW2GrRo4OgS
         Upoki3j/vVvxNRkRNflFmGf/gMb7FjjriymFJZPzbZPi1WG70010h/fNPA1UOOBjK7mw
         tdZ06WjNmW+xrBsDuzrhq9C9OjTsDhSsdZXNi4Yxa/9mIv2ZUV00yD3Kr2UnJkdTVclt
         D93g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MNhCRc2GDeasyRbwo0O5IIW2sQmDlpog5LT65h+9PRk=;
        b=jmJXtATQrxCHlWiYW8U6wnhEQ0Ch7bUFDzZYx/rbHcYXqCU8uiV6Xjk1HkI/rJ/wYb
         khNA00F2PpVzlA2NusxyaasyoM1vDc7VbIAS9+2KyI45X8clMXq1ORbVjdafmmuK4UeG
         b435Ev87LgGCgY90ZTGKMmcndmdlgzsvIAvprz2kJrBXYkBPbeTpxUT0Vv0rDEyPpXEo
         dKBD4v0rH1Z7OHtANo1P3+W2/RtOpfkz+QWOfjONan3kywLr7FtgE9IngigSVl2ACBmE
         waZ+9bdi9KO4aLHAOKhhx8JQOLrAgqVhuU6xIh7MAVlh3zkYCTQYGcAycK2WeMP10zZF
         AhQg==
X-Gm-Message-State: AOAM533ZHhJi/9tou3zLRCck0+pkhlv4LjXq4Ho3ISRk23mCyFa0Dsgg
        hu/vc3p0leZbMasW48Vheb3MXMD8eVvvrA==
X-Google-Smtp-Source: ABdhPJza3X35TyluBMjnuRZ4jXxdo+/2hoN/6FY/wDYY5xRQeCsZ5jevNQi6N2RQ/oY6k3aGYLvxLA==
X-Received: by 2002:a17:902:d694:b029:e3:906a:61f8 with SMTP id v20-20020a170902d694b02900e3906a61f8mr848456ply.36.1613524140665;
        Tue, 16 Feb 2021 17:09:00 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:09:00 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 16/17] docs/bpf: Add bpf() syscall command reference
Date:   Tue, 16 Feb 2021 17:08:20 -0800
Message-Id: <20210217010821.1810741-17-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Generate the syscall command reference from the UAPI header file and
include it in the main bpf docs page.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 Documentation/Makefile             |  2 ++
 Documentation/bpf/Makefile         | 28 ++++++++++++++++++++++++++++
 Documentation/bpf/bpf_commands.rst |  5 +++++
 Documentation/bpf/index.rst        | 14 +++++++++++---
 4 files changed, 46 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/bpf/Makefile
 create mode 100644 Documentation/bpf/bpf_commands.rst

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 9c42dde97671..408542825cc2 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -73,6 +73,7 @@ loop_cmd = $(echo-cmd) $(cmd_$(1)) || exit;
 
 quiet_cmd_sphinx = SPHINX  $@ --> file://$(abspath $(BUILDDIR)/$3/$4)
       cmd_sphinx = $(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/userspace-api/media $2 && \
+	$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/bpf $2 && \
 	PYTHONDONTWRITEBYTECODE=1 \
 	BUILDDIR=$(abspath $(BUILDDIR)) SPHINX_CONF=$(abspath $(srctree)/$(src)/$5/$(SPHINX_CONF)) \
 	$(PYTHON3) $(srctree)/scripts/jobserver-exec \
@@ -133,6 +134,7 @@ refcheckdocs:
 
 cleandocs:
 	$(Q)rm -rf $(BUILDDIR)
+	$(Q)$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/bpf clean
 	$(Q)$(MAKE) BUILDDIR=$(abspath $(BUILDDIR)) $(build)=Documentation/userspace-api/media clean
 
 dochelp:
diff --git a/Documentation/bpf/Makefile b/Documentation/bpf/Makefile
new file mode 100644
index 000000000000..4f14db0891cc
--- /dev/null
+++ b/Documentation/bpf/Makefile
@@ -0,0 +1,28 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# Rules to convert a .h file to inline RST documentation
+
+SRC_DIR = $(srctree)/Documentation/bpf
+PARSER = $(srctree)/scripts/bpf_doc.py
+UAPI = $(srctree)/include/uapi/linux
+
+TARGETS = $(BUILDDIR)/bpf/bpf_syscall.rst
+
+$(BUILDDIR)/bpf/bpf_syscall.rst: $(UAPI)/bpf.h
+	$(PARSER) syscall > $@
+
+.PHONY: all html epub xml latex linkcheck clean
+
+all: $(IMGDOT) $(BUILDDIR)/bpf $(TARGETS)
+
+html: all
+epub: all
+xml: all
+latex: $(IMGPDF) all
+linkcheck:
+
+clean:
+	-rm -f -- $(TARGETS) 2>/dev/null
+
+$(BUILDDIR)/bpf:
+	$(Q)mkdir -p $@
diff --git a/Documentation/bpf/bpf_commands.rst b/Documentation/bpf/bpf_commands.rst
new file mode 100644
index 000000000000..da388ffac85b
--- /dev/null
+++ b/Documentation/bpf/bpf_commands.rst
@@ -0,0 +1,5 @@
+**************************
+bpf() subcommand reference
+**************************
+
+.. kernel-include:: $BUILDDIR/bpf/bpf_syscall.rst
diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
index 4f2874b729c3..631d02d4dc49 100644
--- a/Documentation/bpf/index.rst
+++ b/Documentation/bpf/index.rst
@@ -12,9 +12,6 @@ BPF instruction-set.
 The Cilium project also maintains a `BPF and XDP Reference Guide`_
 that goes into great technical depth about the BPF Architecture.
 
-The primary info for the bpf syscall is available in the `man-pages`_
-for `bpf(2)`_.
-
 BPF Type Format (BTF)
 =====================
 
@@ -35,6 +32,17 @@ Two sets of Questions and Answers (Q&A) are maintained.
    bpf_design_QA
    bpf_devel_QA
 
+Syscall API
+===========
+
+The primary info for the bpf syscall is available in the `man-pages`_
+for `bpf(2)`_.
+
+.. toctree::
+   :maxdepth: 1
+
+   bpf_commands
+
 
 Helper functions
 ================
-- 
2.27.0

