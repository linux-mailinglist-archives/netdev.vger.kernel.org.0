Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177D0263258
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731077AbgIIQkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730463AbgIIQZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:25:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1770C0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:25:05 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id b79so2995835wmb.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQtxUYP5GhaLNZ/6o/s9sGOPVdWVrrwBq5iKWI5eYnQ=;
        b=FFi/zOfaYud8aObDAWbGE2DadlDRDOhM5b5oR3KEpWnlBt7GysEEVBiAlde7GEhtDi
         Q+/3uJKAp7sP907Mfp2QapZMFcJLHSEB8ujqcjLAv9GC6MjylooGIGr6fStPL7tIdaJP
         amWDfnWEJeQMsC9nQkeXQap6gQlp/wmQV+G+v9UzOIYt5+k8msHY2MGLB+Nxswxf2LiO
         /GXFTpeKWXEp8S2BhbzLBNPnN3NR/veptMg+NVLy+zufuWY/9QPZM1j56bSieQ6fYMwY
         HHpIgcHWTLCUyJV4K/LoPD+GD0AC+y+9WklhvN70m6SmUlirfoNasUXB2CmjxALkcpDg
         Xbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQtxUYP5GhaLNZ/6o/s9sGOPVdWVrrwBq5iKWI5eYnQ=;
        b=ZsFbSJfEJ4ADl7XUvGy84yebHfB2ksWRJCluGlN8xCDdR10WHpNSpB+bI5RmQbcqQ2
         vQCqyTyJLsvUxPXTCTuztzZ8W0JVVVNSvdNLyWZgOuXkuxBsBpMadcKhbeGVtRJL7Gdf
         4gBDK6yxbH3V2IT98lNaT4mn9CZRnqJxxHtJ1GalM+4ikiIsLbBgUAigNhV4e30nHOVU
         h9WyQNfX8MMGS96ySufEedLgMeTcG6F7zrZO0oDYRudwAqpg5box0fVJfjxetMvPxOnG
         7tETwWvCDnfpD9vGxB5jmnQ3/7fq/vJhKdNVA5fJVVDluU6Hezt8Yjl0W8RdXZOuJBl4
         2I2g==
X-Gm-Message-State: AOAM533rfXnJSoI6hy8j5JVw7+fPpg9ri1oXAhiVwC8r7B6zV5PuUwBq
        LXkrn7FbhufAHL6VX7ARKQlUOg==
X-Google-Smtp-Source: ABdhPJxYH0+muYPied7VRVFFKxuTwkWGOwpePUUpePjFGqQdN3YydCThmwxwJkwfUgEOWILsFhhh0Q==
X-Received: by 2002:a1c:cc05:: with SMTP id h5mr4152554wmb.129.1599668704005;
        Wed, 09 Sep 2020 09:25:04 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.56])
        by smtp.gmail.com with ESMTPSA id d3sm4821445wrr.84.2020.09.09.09.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:25:03 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3 1/3] tools: bpftool: print optional built-in features along with version
Date:   Wed,  9 Sep 2020 17:24:58 +0100
Message-Id: <20200909162500.17010-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909162500.17010-1-quentin@isovalent.com>
References: <20200909162500.17010-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bpftool has a number of features that can be included or left aside
during compilation. This includes:

- Support for libbfd, providing the disassembler for JIT-compiled
  programs.
- Support for BPF skeletons, used for profiling programs or iterating on
  the PIDs of processes associated with BPF objects.

In order to make it easy for users to understand what features were
compiled for a given bpftool binary, print the status of the two
features above when showing the version number for bpftool ("bpftool -V"
or "bpftool version"). Document this in the main manual page. Example
invocations:

    $ bpftool version
    ./bpftool v5.9.0-rc1
    features: libbfd, skeletons

    $ bpftool -p version
    {
        "version": "5.9.0-rc1",
        "features": {
            "libbfd": true,
            "skeletons": true
        }
    }

Some other parameters are optional at compilation
("DISASM_FOUR_ARGS_SIGNATURE", LIBCAP support) but they do not impact
significantly bpftool's behaviour from a user's point of view, so their
status is not reported.

Available commands and supported program types depend on the version
number, and are therefore not reported either. Note that they are
already available, albeit without JSON, via bpftool's help messages.

v3:
- Use a simple list instead of boolean values for plain output.

v2:
- Fix JSON (object instead or array for the features).

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool.rst |  8 ++++-
 tools/bpf/bpftool/main.c                    | 33 +++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 420d4d5df8b6..a3629a3f1175 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -50,7 +50,13 @@ OPTIONS
 		  Print short help message (similar to **bpftool help**).
 
 	-V, --version
-		  Print version number (similar to **bpftool version**).
+		  Print version number (similar to **bpftool version**), and
+		  optional features that were included when bpftool was
+		  compiled. Optional features include linking against libbfd to
+		  provide the disassembler for JIT-ted programs (**bpftool prog
+		  dump jited**) and usage of BPF skeletons (some features like
+		  **bpftool prog profile** or showing pids associated to BPF
+		  objects may rely on it).
 
 	-j, --json
 		  Generate JSON output. For commands that cannot produce JSON, this
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 4a191fcbeb82..682daaa49e6a 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -70,13 +70,42 @@ static int do_help(int argc, char **argv)
 
 static int do_version(int argc, char **argv)
 {
+#ifdef HAVE_LIBBFD_SUPPORT
+	const bool has_libbfd = true;
+#else
+	const bool has_libbfd = false;
+#endif
+#ifdef BPFTOOL_WITHOUT_SKELETONS
+	const bool has_skeletons = false;
+#else
+	const bool has_skeletons = true;
+#endif
+
 	if (json_output) {
-		jsonw_start_object(json_wtr);
+		jsonw_start_object(json_wtr);	/* root object */
+
 		jsonw_name(json_wtr, "version");
 		jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
-		jsonw_end_object(json_wtr);
+
+		jsonw_name(json_wtr, "features");
+		jsonw_start_object(json_wtr);	/* features */
+		jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
+		jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
+		jsonw_end_object(json_wtr);	/* features */
+
+		jsonw_end_object(json_wtr);	/* root object */
 	} else {
+		unsigned int nb_features = 0;
+
 		printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
+		printf("features:");
+		if (has_libbfd) {
+			printf(" libbfd");
+			nb_features++;
+		}
+		if (has_skeletons)
+			printf("%s skeletons", nb_features++ ? "," : "");
+		printf("\n");
 	}
 	return 0;
 }
-- 
2.25.1

