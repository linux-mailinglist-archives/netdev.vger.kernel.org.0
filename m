Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9363DA910
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhG2Q3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhG2Q3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:29:48 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E492C0613C1
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id q3so7726074wrx.0
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 09:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o6zlBEmlmQo49Vq2Tj0+VK7wgy0k+CtPllYV76vshxk=;
        b=TdtJOPIbqPTZPcBjl0ZrIsADj9ONGf//8aAZS+gfYHRNAUecuP0wiFUagP4QUfEkE3
         GN1s/FTtG5zJld1+OJ/gJdGhihIVj10s/6HW0aaPimyEJ0wkR+uWf4iJumW0hfpa57oW
         8ZkaizyuSGY01irOhAboSliwpl4vgl5sQOPDmEfuhTbbWNOg9OG62K4wLBkhwNGxGDGb
         636nD5732Htq5jKsM7K6tHO17McZPp0N3S0DUX2E0wcwKZEnYjuqF8NbsYlOe/EEyUbk
         MEnvTi4/0UN/wPrZfu5TpPIAo/8amS0nFlsCR0/ar0JFMo7AxohnJYFw267pZE7BV8Qk
         XDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o6zlBEmlmQo49Vq2Tj0+VK7wgy0k+CtPllYV76vshxk=;
        b=jnVAWFOguPSVApUGBL82jYRy6dIMVjzmzZV2QyHrQt6qEwWaTObikDcUjUliqwLEor
         BhB8LfhjFvoqZfXgM/TXr1uus1cEDyoFKmqVgorMcekHSP43GqFDOaZvGF3AflLYRB+t
         djHLuArlWaZcmG/+eMT4VBXvzPVKet9xiDCxH0MBLr+zMWmivuHWMQDxlRP0th+VjTu7
         vNLeV+VlX4A1RrraPHY5OxtOrAtP+eerollF1uUwqZWAxboKdKGkpJOsJyXGtR1490/G
         e2t9teA6ac1gyhoCewwJUAS/9i+rujRaBVf8a5mVxMHSvd0VN2IhkUA44aqa70C/gbze
         EuKg==
X-Gm-Message-State: AOAM5331cXcjem7+hyFE2FBvrk1bRhTJXHND1WBsKkoOnCx3E109EXqB
        rbdFkKTOj51Fno24oH7DQaEK2g==
X-Google-Smtp-Source: ABdhPJwXX8B1R9rTvAHXREq6Do4/wH9gfCpUJrCl5JjMZsJXwSrxySVqdtX5psGV/Hq+wKjkKJE48Q==
X-Received: by 2002:a5d:5906:: with SMTP id v6mr5898999wrd.194.1627576183666;
        Thu, 29 Jul 2021 09:29:43 -0700 (PDT)
Received: from localhost.localdomain ([149.86.75.13])
        by smtp.gmail.com with ESMTPSA id 140sm3859331wmb.43.2021.07.29.09.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:29:43 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 4/7] tools: bpftool: update and synchronise option list in doc and help msg
Date:   Thu, 29 Jul 2021 17:29:29 +0100
Message-Id: <20210729162932.30365-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210729162932.30365-1-quentin@isovalent.com>
References: <20210729162932.30365-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All bpftool commands support the options for JSON output and debug from
libbpf. In addition, some commands support additional options
corresponding to specific use cases.

The list of options described in the man pages for the different
commands are not always accurate. The messages for interactive help are
mostly limited to HELP_SPEC_OPTIONS, and are even less representative of
the actual set of options supported for the commands.

Let's update the lists:

- HELP_SPEC_OPTIONS is modified to contain the "default" options (JSON
  and debug), and to be extensible (no ending curly bracket).
- All commands use HELP_SPEC_OPTIONS in their help message, and then
  complete the list with their specific options.
- The lists of options in the man pages are updated.
- The formatting of the list for bpftool.rst is adjusted to match
  formatting for the other man pages. This is for consistency, and also
  because it will be helpful in a future patch to automatically check
  that the files are synchronised.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool-btf.rst      |  2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst   |  3 ++-
 tools/bpf/bpftool/Documentation/bpftool-feature.rst  |  2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst      |  2 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst     |  2 ++
 tools/bpf/bpftool/Documentation/bpftool-link.rst     |  3 ++-
 tools/bpf/bpftool/Documentation/bpftool-map.rst      |  3 ++-
 tools/bpf/bpftool/Documentation/bpftool-net.rst      |  2 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst     |  2 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst     |  3 ++-
 .../bpf/bpftool/Documentation/bpftool-struct_ops.rst |  2 +-
 tools/bpf/bpftool/Documentation/bpftool.rst          | 12 ++++++------
 tools/bpf/bpftool/btf.c                              |  2 +-
 tools/bpf/bpftool/cgroup.c                           |  3 ++-
 tools/bpf/bpftool/feature.c                          |  1 +
 tools/bpf/bpftool/gen.c                              |  2 +-
 tools/bpf/bpftool/iter.c                             |  2 ++
 tools/bpf/bpftool/link.c                             |  3 ++-
 tools/bpf/bpftool/main.c                             |  3 ++-
 tools/bpf/bpftool/main.h                             |  3 +--
 tools/bpf/bpftool/map.c                              |  5 +++--
 tools/bpf/bpftool/net.c                              |  1 +
 tools/bpf/bpftool/perf.c                             |  5 ++++-
 tools/bpf/bpftool/prog.c                             |  3 ++-
 tools/bpf/bpftool/struct_ops.c                       |  2 +-
 25 files changed, 45 insertions(+), 28 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index ff4d327a582e..1d37f3809842 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -12,7 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **btf** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | {**-d** | **--debug** } }
 
 	*COMMANDS* := { **dump** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index baee8591ac76..3e4395eede4f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
+		{ **-f** | **--bpffs** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **tree** | **attach** | **detach** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index dd3771bdbc57..ab9f57ee4c3a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -12,7 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **feature** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*COMMANDS* := { **probe** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 7cd6681137f3..709b93fe1da3 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -12,7 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **gen** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*COMMAND* := { **object** | **skeleton** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
index 51f49bead619..471f363a725a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -12,6 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **iter** *COMMAND*
 
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+
 	*COMMANDS* := { **pin** | **help** }
 
 ITER COMMANDS
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index 5f7db2a837cc..0de90f086238 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **link** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
+		{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* := { **show** | **list** | **pin** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index 3d52256ba75f..d0c4abe08aba 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **map** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
+		{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index d8165d530937..1ae0375e8fea 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -12,7 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **net** *COMMAND*
 
-	*OPTIONS* := { [{ **-j** | **--json** }] [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **attach** | **detach** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index e958ce91de72..ce52798a917d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -12,7 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **perf** *COMMAND*
 
-	*OPTIONS* := { [{ **-j** | **--json** }] [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index abf5f4cd7d3e..4b8412fe2c60 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **prog** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
+		{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **dump xlated** | **dump jited** | **pin** | **load**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index 506e70ee78e9..02afc0fc14cb 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -12,7 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **struct_ops** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **dump** | **register** | **unregister** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index e7d949334961..bb23f55bb05a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -18,15 +18,15 @@ SYNOPSIS
 
 	*OBJECT* := { **map** | **program** | **cgroup** | **perf** | **net** | **feature** }
 
-	*OPTIONS* := { { **-V** | **--version** } | { **-h** | **--help** }
-	| { **-j** | **--json** } [{ **-p** | **--pretty** }] }
+	*OPTIONS* := { { **-V** | **--version** } |
+		{ **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*MAP-COMMANDS* :=
-	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext**
-	| **delete** | **pin** | **event_pipe** | **help** }
+	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
+		**delete** | **pin** | **event_pipe** | **help** }
 
-	*PROG-COMMANDS* := { **show** | **list** | **dump jited** | **dump xlated** | **pin**
-	| **load** | **attach** | **detach** | **help** }
+	*PROG-COMMANDS* := { **show** | **list** | **dump jited** | **dump xlated** | **pin** |
+		**load** | **attach** | **detach** | **help** }
 
 	*CGROUP-COMMANDS* := { **show** | **list** | **attach** | **detach** | **help** }
 
diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 385d5c955cf3..ad8374ab6620 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -985,7 +985,7 @@ static int do_help(int argc, char **argv)
 		"       FORMAT  := { raw | c }\n"
 		"       " HELP_SPEC_MAP "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, "btf");
 
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 6e53b1d393f4..c42f437a1015 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -501,7 +501,8 @@ static int do_help(int argc, char **argv)
 		HELP_SPEC_ATTACH_TYPES "\n"
 		"       " HELP_SPEC_ATTACH_FLAGS "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-f|--bpffs} }
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 40a88df275f9..7f36385aa9e2 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -1005,6 +1005,7 @@ static int do_help(int argc, char **argv)
 		"       %1$s %2$s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 1d71ff8c52fa..d4225f7fbcee 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1026,7 +1026,7 @@ static int do_help(int argc, char **argv)
 		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
 		"       %1$s %2$s help\n"
 		"\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, "gen");
 
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index 3b1aad7535dd..84a9b01d956d 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -97,7 +97,9 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %1$s %2$s pin OBJ PATH [map MAP]\n"
 		"       %1$s %2$s help\n"
+		"\n"
 		"       " HELP_SPEC_MAP "\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, "iter");
 
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index e77e1525d20a..8cc3e36f8cc6 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -401,7 +401,8 @@ static int do_help(int argc, char **argv)
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_LINK "\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-f|--bpffs} | {-n|--nomount} }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 3ddfd4843738..02eaaf065f65 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -64,7 +64,8 @@ static int do_help(int argc, char **argv)
 		"       %s version\n"
 		"\n"
 		"       OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-V|--version} }\n"
 		"",
 		bin_name, bin_name, bin_name);
 
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index c1cf29798b99..90caa42aac4c 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -57,8 +57,7 @@ static inline void *u64_to_ptr(__u64 ptr)
 #define HELP_SPEC_PROGRAM						\
 	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG | name PROG_NAME }"
 #define HELP_SPEC_OPTIONS						\
-	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-f|--bpffs} |\n"	\
-	"\t            {-m|--mapcompat} | {-n|--nomount} }"
+	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug}"
 #define HELP_SPEC_MAP							\
 	"MAP := { id MAP_ID | pinned FILE | name MAP_NAME }"
 #define HELP_SPEC_LINK							\
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 09ae0381205b..ab2a8e5e1809 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1466,8 +1466,9 @@ static int do_help(int argc, char **argv)
 		"                 devmap | devmap_hash | sockmap | cpumap | xskmap | sockhash |\n"
 		"                 cgroup_storage | reuseport_sockarray | percpu_cgroup_storage |\n"
 		"                 queue | stack | sk_storage | struct_ops | ringbuf | inode_storage |\n"
-		"		  task_storage }\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"                 task_storage }\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-f|--bpffs} | {-n|--nomount} }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index f836d115d7d6..649053704bd7 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -729,6 +729,7 @@ static int do_help(int argc, char **argv)
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"\n"
 		"Note: Only xdp and tc attachments are supported now.\n"
 		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
diff --git a/tools/bpf/bpftool/perf.c b/tools/bpf/bpftool/perf.c
index ad23934819c7..50de087b0db7 100644
--- a/tools/bpf/bpftool/perf.c
+++ b/tools/bpf/bpftool/perf.c
@@ -231,7 +231,10 @@ static int do_show(int argc, char **argv)
 static int do_help(int argc, char **argv)
 {
 	fprintf(stderr,
-		"Usage: %1$s %2$s { show | list | help }\n"
+		"Usage: %1$s %2$s { show | list }\n"
+		"       %1$s %2$s help }\n"
+		"\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 1ee87225543b..2f0f6c7b2fb9 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2248,7 +2248,8 @@ static int do_help(int argc, char **argv)
 		"       ATTACH_TYPE := { msg_verdict | skb_verdict | stream_verdict |\n"
 		"                        stream_parser | flow_dissector }\n"
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses | itlb_misses | dtlb_misses }\n"
-		"       " HELP_SPEC_OPTIONS "\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-f|--bpffs} | {-m|--mapcompat} | {-n|--nomount} }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index b58b91f62ffb..ab2d2290569a 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -572,8 +572,8 @@ static int do_help(int argc, char **argv)
 		"       %1$s %2$s unregister STRUCT_OPS_MAP\n"
 		"       %1$s %2$s help\n"
 		"\n"
-		"       OPTIONS := { {-j|--json} [{-p|--pretty}] }\n"
 		"       STRUCT_OPS_MAP := [ id STRUCT_OPS_MAP_ID | name STRUCT_OPS_MAP_NAME ]\n"
+		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, argv[-2]);
 
-- 
2.30.2

