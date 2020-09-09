Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9FA2631C1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgIIQZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730550AbgIIQZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:25:08 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9A5C061799
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 09:25:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x23so2881187wmi.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 09:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2xWEMPcmt/iqgsnU6EN8PE8BpQh8kn2V7/tuMrBBZM=;
        b=QyajJeYtNpPlLIRoU8QH+8VmlagQwr9m4UFin/rtuuTpWfFnExmv0zDO61M/UGyd1K
         X2Zfdr4Dobfyq5ak1jQAhHhCEt9dzmEDPyD5Tc0Ckz4jwO8CiL+bBwRnfXL+tEF9NwXS
         IjGEa13nBc6Dz4tRp18KOY9Q1822l9HkQKopYDD4iZVGYmDc108etDIutxvhecqgroAG
         vjd1IsjN89gJT4PvXh5Vrpp/9pVRQMKN7LNmPCTiBAnDS/hIXShCq/KC2x21kRpZgeqc
         Aky9O5Bgh7mA8PCOAzn3s/jKq9AgZ1TDxNFqijgPWPFtGSBzKv254iwtl0kN9yQ7cW6T
         aWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2xWEMPcmt/iqgsnU6EN8PE8BpQh8kn2V7/tuMrBBZM=;
        b=jxqUe5Y1Z5uJ9LzxSmfq7zLn8L2yuZ2f/3oa2BmwbYnPAL/m6dKj6A7urLYiG4r3Pj
         pmhg+KWX0l+xJwg7BG5GUfnihIIkKKE7AFqWY+snTixrZdwjT3cBwaYU9cPXGpKV62sc
         b2hbhx/viCmAQ2LaLUXTpOdTdG9OLTfTwrwVmincKtKZ8M3yBETEr+NFdh28OhIH55Vl
         jpY9TWFY05xyZEb7ZurQ82I4m9fcvdUFLwz/8kgkWyxJMLDV0WWvVO502/rWVCyefJPq
         9LzzD53RaFqCAXJukBslluEtqnwhkAC2bUjzLKFs6HX0psrY7AUDdDdZ2k9oCB64NIFt
         0Bag==
X-Gm-Message-State: AOAM531FU0gh3NnyXK8AoLqr1mDMhY2bBCVI4cVLgXxWVd1RLV0g70+s
        ZDKkc1w+gLnCBy/9JysoSh590+WQAxJoEJ39boc=
X-Google-Smtp-Source: ABdhPJz88/tr/11aCGm6/i1HjmR1rjZ8leMOUUqHYZjGr1+WcJdA338AHc8RNgGqOtIqkp+WQZqFSQ==
X-Received: by 2002:a1c:7e83:: with SMTP id z125mr4330468wmc.32.1599668705298;
        Wed, 09 Sep 2020 09:25:05 -0700 (PDT)
Received: from localhost.localdomain ([194.35.119.56])
        by smtp.gmail.com with ESMTPSA id d3sm4821445wrr.84.2020.09.09.09.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 09:25:04 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 2/3] tools: bpftool: include common options from separate file
Date:   Wed,  9 Sep 2020 17:24:59 +0100
Message-Id: <20200909162500.17010-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909162500.17010-1-quentin@isovalent.com>
References: <20200909162500.17010-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nearly all man pages for bpftool have the same common set of option
flags (--help, --version, --json, --pretty, --debug). The description is
duplicated across all the pages, which is more difficult to maintain if
the description of an option changes. It may also be confusing to sort
out what options are not "common" and should not be copied when creating
new manual pages.

Let's move the description for those common options to a separate file,
which is included with a RST directive when generating the man pages.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/Makefile      |  2 +-
 .../bpf/bpftool/Documentation/bpftool-btf.rst | 17 +------------
 .../bpftool/Documentation/bpftool-cgroup.rst  | 17 +------------
 .../bpftool/Documentation/bpftool-feature.rst | 17 +------------
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 17 +------------
 .../bpftool/Documentation/bpftool-iter.rst    | 11 +--------
 .../bpftool/Documentation/bpftool-link.rst    | 17 +------------
 .../bpf/bpftool/Documentation/bpftool-map.rst | 17 +------------
 .../bpf/bpftool/Documentation/bpftool-net.rst | 17 +------------
 .../bpftool/Documentation/bpftool-perf.rst    | 17 +------------
 .../bpftool/Documentation/bpftool-prog.rst    | 18 +-------------
 .../Documentation/bpftool-struct_ops.rst      | 18 +-------------
 tools/bpf/bpftool/Documentation/bpftool.rst   | 24 +------------------
 .../bpftool/Documentation/common_options.rst  | 22 +++++++++++++++++
 14 files changed, 35 insertions(+), 196 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/common_options.rst

diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
index 815ac9804aee..becbb8c52257 100644
--- a/tools/bpf/bpftool/Documentation/Makefile
+++ b/tools/bpf/bpftool/Documentation/Makefile
@@ -19,7 +19,7 @@ man8dir = $(mandir)/man8
 # Load targets for building eBPF helpers man page.
 include ../../Makefile.helpers
 
-MAN8_RST = $(filter-out $(HELPERS_RST),$(wildcard *.rst))
+MAN8_RST = $(wildcard bpftool*.rst)
 
 _DOC_MAN8 = $(patsubst %.rst,%.8,$(MAN8_RST))
 DOC_MAN8 = $(addprefix $(OUTPUT),$(_DOC_MAN8))
diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 896f4c6c2870..0020bb55cf7e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -71,22 +71,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
-
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+	.. include:: common_options.rst
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index a226aee3574f..3dba89db000e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -116,26 +116,11 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
+	.. include:: common_options.rst
 
 	-f, --bpffs
 		  Show file names of pinned programs.
 
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
-
 EXAMPLES
 ========
 |
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 8609f06e71de..f1aae5690e3c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -71,22 +71,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
-
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+	.. include:: common_options.rst
 
 SEE ALSO
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index df85dbd962c0..e3b7ff3c09d7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -126,22 +126,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON,
-		  this option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
-
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+	.. include:: common_options.rst
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
index 070ffacb42b5..b688cf11805c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -51,16 +51,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-d, --debug
-		  Print all logs available, even debug-level information. This
-		  includes logs from libbpf as well as from the verifier, when
-		  attempting to load programs.
+	.. include:: common_options.rst
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index dc7693b5e606..ce122be58bae 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -62,18 +62,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
+	.. include:: common_options.rst
 
 	-f, --bpffs
 		  When showing BPF links, show file names of pinned
@@ -83,10 +72,6 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
-	-d, --debug
-		  Print all logs available, even debug-level information. This
-		  includes logs from libbpf.
-
 EXAMPLES
 ========
 **# bpftool link show**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 083db6c2fc67..e06a65cd467e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -155,18 +155,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
+	.. include:: common_options.rst
 
 	-f, --bpffs
 		  Show file names of pinned maps.
@@ -175,10 +164,6 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
-
 EXAMPLES
 ========
 **# bpftool map show**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index aa7450736179..56439c32934d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -75,22 +75,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
-
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+	.. include:: common_options.rst
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index 9c592b7c6775..36d257a36e9b 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -40,22 +40,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
-
-	-d, --debug
-		  Print all logs available from libbpf, including debug-level
-		  information.
+	.. include:: common_options.rst
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 82e356b664e8..9b2b18e2a3ac 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -210,18 +210,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
+	.. include:: common_options.rst
 
 	-f, --bpffs
 		  When showing BPF programs, show file names of pinned
@@ -234,11 +223,6 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
-	-d, --debug
-		  Print all logs available, even debug-level information. This
-		  includes logs from libbpf as well as from the verifier, when
-		  attempting to load programs.
-
 EXAMPLES
 ========
 **# bpftool prog show**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index d93cd1cb8b0f..315f1f21f2ba 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -60,23 +60,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short generic help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
-
-	-d, --debug
-		  Print all logs available, even debug-level information. This
-		  includes logs from libbpf as well as from the verifier, when
-		  attempting to load programs.
+	.. include:: common_options.rst
 
 EXAMPLES
 ========
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index a3629a3f1175..b87f8c2df49d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -46,24 +46,7 @@ DESCRIPTION
 
 OPTIONS
 =======
-	-h, --help
-		  Print short help message (similar to **bpftool help**).
-
-	-V, --version
-		  Print version number (similar to **bpftool version**), and
-		  optional features that were included when bpftool was
-		  compiled. Optional features include linking against libbfd to
-		  provide the disassembler for JIT-ted programs (**bpftool prog
-		  dump jited**) and usage of BPF skeletons (some features like
-		  **bpftool prog profile** or showing pids associated to BPF
-		  objects may rely on it).
-
-	-j, --json
-		  Generate JSON output. For commands that cannot produce JSON, this
-		  option has no effect.
-
-	-p, --pretty
-		  Generate human-readable JSON output. Implies **-j**.
+	.. include:: common_options.rst
 
 	-m, --mapcompat
 		  Allow loading maps with unknown map definitions.
@@ -72,11 +55,6 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
-	-d, --debug
-		  Print all logs available, even debug-level information. This
-		  includes logs from libbpf as well as from the verifier, when
-		  attempting to load programs.
-
 SEE ALSO
 ========
 	**bpf**\ (2),
diff --git a/tools/bpf/bpftool/Documentation/common_options.rst b/tools/bpf/bpftool/Documentation/common_options.rst
new file mode 100644
index 000000000000..05d06c74dcaa
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/common_options.rst
@@ -0,0 +1,22 @@
+-h, --help
+	  Print short help message (similar to **bpftool help**).
+
+-V, --version
+	  Print version number (similar to **bpftool version**), and optional
+	  features that were included when bpftool was compiled. Optional
+	  features include linking against libbfd to provide the disassembler
+	  for JIT-ted programs (**bpftool prog dump jited**) and usage of BPF
+	  skeletons (some features like **bpftool prog profile** or showing
+	  pids associated to BPF objects may rely on it).
+
+-j, --json
+	  Generate JSON output. For commands that cannot produce JSON, this
+	  option has no effect.
+
+-p, --pretty
+	  Generate human-readable JSON output. Implies **-j**.
+
+-d, --debug
+	  Print all logs available, even debug-level information. This includes
+	  logs from libbpf as well as from the verifier, when attempting to
+	  load programs.
-- 
2.25.1

