Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9C725FFFC
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgIGQmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730947AbgIGQiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 12:38:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B68C061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 09:38:08 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a9so14755045wmm.2
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 09:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BJoEBQbVWXYlOqLU5cbV6bt1TTlsLV/Qtq4ImP8ofAU=;
        b=RAobz4z02AZSvKr0A+KyMeHCsFsF0y3s/+mTsvhDfALo01MBcgevnctS8DDfNb4r7Z
         FjG+pMGmyXkinfpj23I9Kw8Pg9FUkLHJMWxqpy+g8GCWfqMBDiAy2XbY/wlbLn9QeyVL
         7EzFbvk/hgeQAzsg/qOz7YUxGAjf7syShJQxxt7Mn7KATuFj9BBUbdYuYKUBXXtDZVYi
         1aAeF66YUCChpWFbIItPqaR8eg66It8/7cmGaCH++71D0QFJHJKddSOTGoKBv4/xzbmJ
         SBPPJ0jdaVNpIsgI4lWR1Lw+1kYnQxO6es6jmIzDpGVnOnJqL76sVxPiiv8KdzfJgVe/
         A71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BJoEBQbVWXYlOqLU5cbV6bt1TTlsLV/Qtq4ImP8ofAU=;
        b=MH7Ehl/2syb4fOuPYlef/AafE1ZT084mISHl5PX5SBF7ophdxbojoj4ci4wv88BLWn
         aJ0vdwnVqVqJLFR5rmtNC1vIVQI+u9Qi30jGBqp24+3cp5D3kgWXVhEEfRpeZ/kp1WBH
         lt+DOHMD+PvPJC6HfyylupLRr67aqbYEMTSIFeFtoxwLnIwAx2yqlhOPsvY43Rr/6C/L
         KKDo/W7n5SzOAHjl8ShJGQJTHoZm3uNK3nfF3kfUAalcs99H65iaJCAaAjY9jGhIPdfp
         ufwO041+o9SLbrXCeg3FXKGPtLBYkLQMqS+a21LfWZNBKDePc2T4uAZSvEaJ9ZQuzBkH
         1/kg==
X-Gm-Message-State: AOAM530Jq3RilR0UrXK9crgxv9eWKFXjw25W19sQ7k+IeFShLb4Szl3o
        LHiMmI6qK2KtBwm6tGUKmps4Jw==
X-Google-Smtp-Source: ABdhPJzoXXU77iPYv/YRcJAPo8T9EnX20DwTM7hmEOsDLSTu+6z1evY4R9WjA8MgfCTyhMLeafytTw==
X-Received: by 2002:a7b:c1c3:: with SMTP id a3mr206999wmj.68.1599496687323;
        Mon, 07 Sep 2020 09:38:07 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.17])
        by smtp.gmail.com with ESMTPSA id g12sm26546580wro.89.2020.09.07.09.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 09:38:06 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 1/3] tools: bpftool: print optional built-in features along with version
Date:   Mon,  7 Sep 2020 17:38:02 +0100
Message-Id: <20200907163804.29244-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200907163804.29244-1-quentin@isovalent.com>
References: <20200907163804.29244-1-quentin@isovalent.com>
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
invocation:

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

v2:
- Fix JSON (object instead or array for the features).

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool.rst |  8 ++++++-
 tools/bpf/bpftool/main.c                    | 26 +++++++++++++++++++--
 2 files changed, 31 insertions(+), 3 deletions(-)

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
index 4a191fcbeb82..a47bf5f7562a 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -70,13 +70,35 @@ static int do_help(int argc, char **argv)
 
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
 		printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
+		printf("features: libbfd=%s, skeletons=%s\n",
+		       has_libbfd ? "true" : "false",
+		       has_skeletons ? "true" : "false");
 	}
 	return 0;
 }
-- 
2.25.1

