Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56650295F5
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390676AbfEXKhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:37:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54899 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390527AbfEXKg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 06:36:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id i3so8824581wml.4
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 03:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OTSFjqFNx6AklxBnrgr6pYSauz+rBQwYZ3SCLe2/oOg=;
        b=HoWiMtga0FYpzrgMI8fLVM27m2rdCr2PvnomDtDRImJEr0aZ+zOBjYbAZz5GvQ9lMG
         qh60Y169iZLaEe9IqJpgMy0LdBv4Js9cTga6cpG+CNDR0ZMXT96osZTlG9JDcBnnIwSi
         gmzguZDpA0Z7Cbehn5ZbRoFxc3kEaVdRAQHFuZWek8UZM7msEETfH/QRE60Hjk8chbd8
         l7tcn3aBJ1bhFr0VeGoBsnQtqhi5HosFalSaFMBjZylgZ5oEezVNfmdd6Hz+IPw5iu/W
         CQhvo4sK3P0gfeLhmn47qCoVEoSRB8Uk1d2kb94n5Q134caZZRNUQXEO6s65+yPM2PeE
         JJSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OTSFjqFNx6AklxBnrgr6pYSauz+rBQwYZ3SCLe2/oOg=;
        b=KEaEYNTaGcswHRDULziBZWO+sx5hfrBEGECQjsHGz18txrFPZNrXx+XTb8aXfOQjL1
         b/qcKZd1Pz/zvg2Gjba+r0wxJcLvxl59Wok9lN30K+GeLEBBLKiKbLpybZtvv9NWXMxO
         RPfUBxhSyxtcBnEtp988WlDJ3mSX+OdPQ5RWBxJ1aI2paEBg3Gb9/OHWHFAtn+bv5DFW
         cte83G7uAkhuNaKVkYbpj4hsw0JT+NGu8LZ0kxJXUoYNHeCCxMzyw6GJy9ZbYePkThBa
         JMc2Muk0wFUlN68HS04G+EpTobtRR31jHE7kb/JewM9P4qgLbqX9iqj+VgmN0QxAOeoo
         kLoQ==
X-Gm-Message-State: APjAAAW1AuQboVFjFOWamSwuaxuwcKo0SnLzg7+PTvPb5w6hhW+SULM9
        QwkzNOR290GHlHshqLYWhtU1oQ==
X-Google-Smtp-Source: APXvYqxBm1A8rlKT79VJSvH1oxHUtdz3TZzb9FUecalHSIhC/kk7JN8l+w7vLa9oEni29yxHVubcjQ==
X-Received: by 2002:a1c:4083:: with SMTP id n125mr14869445wma.54.1558694215462;
        Fri, 24 May 2019 03:36:55 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id g2sm1955759wru.37.2019.05.24.03.36.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 03:36:54 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 1/3] tools: bpftool: add -d option to get debug output from libbpf
Date:   Fri, 24 May 2019 11:36:46 +0100
Message-Id: <20190524103648.15669-2-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190524103648.15669-1-quentin.monnet@netronome.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf has three levels of priority for output messages: warn, info,
debug. By default, debug output is not printed to the console.

Add a new "--debug" (short name: "-d") option to bpftool to print libbpf
logs for all three levels.

Internally, we simply use the function provided by libbpf to replace the
default printing function by one that prints logs regardless of their
level.

v2:
- Remove the possibility to select the log-levels to use (v1 offered a
  combination of "warn", "info" and "debug").
- Rename option and offer a short name: -d|--debug.
- Add option description to all bpftool manual pages (instead of
  bpftool-prog.rst only), as all commands use libbpf.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |  4 ++++
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |  4 ++++
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |  4 ++++
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |  4 ++++
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |  4 ++++
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |  4 ++++
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |  4 ++++
 tools/bpf/bpftool/Documentation/bpftool.rst        |  3 +++
 tools/bpf/bpftool/bash-completion/bpftool          |  2 +-
 tools/bpf/bpftool/main.c                           | 14 +++++++++++++-
 10 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 2dbc1413fabd..00668df1bf7a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -67,6 +67,10 @@ OPTIONS
 	-p, --pretty
 		  Generate human-readable JSON output. Implies **-j**.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 EXAMPLES
 ========
 **# bpftool btf dump id 1226**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index ac26876389c2..36807735e2a5 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -113,6 +113,10 @@ OPTIONS
 	-f, --bpffs
 		  Show file names of pinned programs.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 EXAMPLES
 ========
 |
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 14180e887082..4d08f35034a2 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -73,6 +73,10 @@ OPTIONS
 	-p, --pretty
 		  Generate human-readable JSON output. Implies **-j**.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 SEE ALSO
 ========
 	**bpf**\ (2),
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 13ef27b39f20..490b4501cb6e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -152,6 +152,10 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 EXAMPLES
 ========
 **# bpftool map show**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 934580850f42..d8e5237a2085 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -65,6 +65,10 @@ OPTIONS
 	-p, --pretty
 		  Generate human-readable JSON output. Implies **-j**.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 EXAMPLES
 ========
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index 0c7576523a21..e252bd0bc434 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -53,6 +53,10 @@ OPTIONS
 	-p, --pretty
 		  Generate human-readable JSON output. Implies **-j**.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 EXAMPLES
 ========
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index e8118544d118..9a92614569e6 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -174,6 +174,10 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
+
 EXAMPLES
 ========
 **# bpftool prog show**
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 3e562d7fd56f..43dba0717953 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -66,6 +66,9 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
+	-d, --debug
+		  Print all logs available from libbpf, including debug-level
+		  information.
 
 SEE ALSO
 ========
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 50e402a5a9c8..3a476e25d046 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -181,7 +181,7 @@ _bpftool()
 
     # Deal with options
     if [[ ${words[cword]} == -* ]]; then
-        local c='--version --json --pretty --bpffs --mapcompat'
+        local c='--version --json --pretty --bpffs --mapcompat --debug'
         COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
         return 0
     fi
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 1ac1fc520e6a..d74293938a05 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -10,6 +10,7 @@
 #include <string.h>
 
 #include <bpf.h>
+#include <libbpf.h>
 
 #include "main.h"
 
@@ -77,6 +78,13 @@ static int do_version(int argc, char **argv)
 	return 0;
 }
 
+static int __printf(2, 0)
+print_all_levels(__maybe_unused enum libbpf_print_level level,
+		 const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
 int cmd_select(const struct cmd *cmds, int argc, char **argv,
 	       int (*help)(int argc, char **argv))
 {
@@ -317,6 +325,7 @@ int main(int argc, char **argv)
 		{ "bpffs",	no_argument,	NULL,	'f' },
 		{ "mapcompat",	no_argument,	NULL,	'm' },
 		{ "nomount",	no_argument,	NULL,	'n' },
+		{ "debug",	no_argument,	NULL,	'd' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -332,7 +341,7 @@ int main(int argc, char **argv)
 	hash_init(map_table.table);
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "Vhpjfmn",
+	while ((opt = getopt_long(argc, argv, "Vhpjfmnd",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -362,6 +371,9 @@ int main(int argc, char **argv)
 		case 'n':
 			block_mount = true;
 			break;
+		case 'd':
+			libbpf_set_print(print_all_levels);
+			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
-- 
2.17.1

