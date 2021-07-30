Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F28D3DC08A
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 23:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhG3V41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 17:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbhG3VzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 17:55:06 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D2AC06175F
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:55:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id z4so13037610wrv.11
        for <netdev@vger.kernel.org>; Fri, 30 Jul 2021 14:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fmtZXztgdivZuZVeDYWYFm4zcq2kb3dpj5IVSOyysdA=;
        b=M0BdIT8AzrYP2HlKUqnaHgu7dmHK1t4ySJR5SGxvg4ooXb5iQIj7lz5bIqHePcipRo
         i7rWTYJU6bhukoffQyl+C5/7kp+FsSQDd4aoMHGz8E0w7Q6qG5ocjfKTRVXdbAJiHiuY
         8yom8/akWZ9zaWLLw6Se4ZVFNgoBAAXPWHFjzakr8qhmTVND4IDrJIBtLDa4h5pxeErY
         uR0jTm2HkcT53oIj48z28IsqsDEB67EnFHANUyzoldHnLGpS8hZyO1qu/r0nnaMSU7f/
         Up+GiLxa/6mkJI4hAnJYgBdQT/Yerf7+1DCrDwyyNOEEXcCbj5iATog1JgRAHH3MuZKo
         3orQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fmtZXztgdivZuZVeDYWYFm4zcq2kb3dpj5IVSOyysdA=;
        b=DKpKWZvDyPFyW7Ce2KajuuWn+c1JoN3WAAoP8fi2OFkIK4nGL7rfP+XetHSsSEFXxi
         SrmcfNaZrPFSMQO8SNq+HQkxvZTV49qKJ2DB09freWZXn8affBwy8hRPiUGgQhJvbznQ
         eE3+01QXyVqPKPMT1BWUAb4X71PKOQjS1bSBgPAk0uaqlhkdT+WjJcw76iw2o2BuOz+2
         MHeIROuYp75AJPm+cOAA2wHkxJBM7yNEY4XFFQcP9lQsJwgDr7YpZrUT81HO9I/5HvBn
         hs/xfO7Si33MRn4bw3sNWIKCnMZ6z80iC6VCTTenW+Dx2TE+ZnERxSsGEZ1sF+8H4eMk
         OHeg==
X-Gm-Message-State: AOAM532vW0CxdJ5r0+5lmxZ1fTjVVDSJTui+4oWN/8LkwqBrdp2kZWB5
        onN7D9LzN6fSaEht+sgE1b0aifyQ6ZXwXhRj
X-Google-Smtp-Source: ABdhPJy7QDWX3+ceiDjNysihMQH/I3TD93bIB34S9/eYtTnRucJZSvgdpy+gqJf3nFUR6neCG1Glmg==
X-Received: by 2002:adf:f2cd:: with SMTP id d13mr5324595wrp.315.1627682099389;
        Fri, 30 Jul 2021 14:54:59 -0700 (PDT)
Received: from localhost.localdomain ([149.86.78.245])
        by smtp.gmail.com with ESMTPSA id v15sm3210871wmj.39.2021.07.30.14.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 14:54:58 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 6/7] tools: bpftool: document and add bash completion for -L, -B options
Date:   Fri, 30 Jul 2021 22:54:34 +0100
Message-Id: <20210730215435.7095-7-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730215435.7095-1-quentin@isovalent.com>
References: <20210730215435.7095-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The -L|--use-loader option for using loader programs when loading, or
when generating a skeleton, did not have any documentation or bash
completion. Same thing goes for -B|--base-btf, used to pass a path to a
base BTF object for split BTF such as BTF for kernel modules.

This patch documents and adds bash completion for those options.

Fixes: 75fa1777694c ("tools/bpftool: Add bpftool support for split BTF")
Fixes: d510296d331a ("bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst | 48 ++++++++++++++++++-
 .../bpf/bpftool/Documentation/bpftool-gen.rst |  9 +++-
 .../bpftool/Documentation/bpftool-prog.rst    | 30 +++++++++++-
 tools/bpf/bpftool/bash-completion/bpftool     |  8 ++--
 tools/bpf/bpftool/btf.c                       |  3 +-
 tools/bpf/bpftool/cgroup.c                    |  2 +-
 tools/bpf/bpftool/gen.c                       |  3 +-
 tools/bpf/bpftool/prog.c                      |  3 +-
 8 files changed, 96 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 1d37f3809842..88b28aa7431f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **btf** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | {**-d** | **--debug** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | {**-d** | **--debug** } |
+		{ **-B** | **--base-btf** } }
 
 	*COMMANDS* := { **dump** | **help** }
 
@@ -73,6 +74,20 @@ OPTIONS
 =======
 	.. include:: common_options.rst
 
+	-B, --base-btf *FILE*
+		  Pass a base BTF object. Base BTF objects are typically used
+		  with BTF objects for kernel modules. To avoid duplicating
+		  all kernel symbols required by modules, BTF objects for
+		  modules are "split", they are built incrementally on top of
+		  the kernel (vmlinux) BTF object. So the base BTF reference
+		  should usually point to the kernel BTF.
+
+		  When the main BTF object to process (for example, the
+		  module BTF to dump) is passed as a *FILE*, bpftool attempts
+		  to autodetect the path for the base object, and passing
+		  this option is optional. When the main BTF object is passed
+		  through other handles, this option becomes necessary.
+
 EXAMPLES
 ========
 **# bpftool btf dump id 1226**
@@ -217,3 +232,34 @@ All the standard ways to specify map or program are supported:
 **# bpftool btf dump prog tag b88e0a09b1d9759d**
 
 **# bpftool btf dump prog pinned /sys/fs/bpf/prog_name**
+
+|
+| **# bpftool btf dump file /sys/kernel/btf/i2c_smbus**
+| (or)
+| **# I2C_SMBUS_ID=$(bpftool btf show -p | jq '.[] | select(.name=="i2c_smbus").id')**
+| **# bpftool btf dump id ${I2C_SMBUS_ID} -B /sys/kernel/btf/vmlinux**
+
+::
+
+  [104848] STRUCT 'i2c_smbus_alert' size=40 vlen=2
+          'alert' type_id=393 bits_offset=0
+          'ara' type_id=56050 bits_offset=256
+  [104849] STRUCT 'alert_data' size=12 vlen=3
+          'addr' type_id=16 bits_offset=0
+          'type' type_id=56053 bits_offset=32
+          'data' type_id=7 bits_offset=64
+  [104850] PTR '(anon)' type_id=104848
+  [104851] PTR '(anon)' type_id=104849
+  [104852] FUNC 'i2c_register_spd' type_id=84745 linkage=static
+  [104853] FUNC 'smbalert_driver_init' type_id=1213 linkage=static
+  [104854] FUNC_PROTO '(anon)' ret_type_id=18 vlen=1
+          'ara' type_id=56050
+  [104855] FUNC 'i2c_handle_smbus_alert' type_id=104854 linkage=static
+  [104856] FUNC 'smbalert_remove' type_id=104854 linkage=static
+  [104857] FUNC_PROTO '(anon)' ret_type_id=18 vlen=2
+          'ara' type_id=56050
+          'id' type_id=56056
+  [104858] FUNC 'smbalert_probe' type_id=104857 linkage=static
+  [104859] FUNC 'smbalert_work' type_id=9695 linkage=static
+  [104860] FUNC 'smbus_alert' type_id=71367 linkage=static
+  [104861] FUNC 'smbus_do_alert' type_id=84827 linkage=static
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 709b93fe1da3..2ef2f2df0279 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -12,7 +12,8 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **gen** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
+		{ **-L** | **--use-loader** } }
 
 	*COMMAND* := { **object** | **skeleton** | **help** }
 
@@ -152,6 +153,12 @@ OPTIONS
 =======
 	.. include:: common_options.rst
 
+	-L, --use-loader
+		  For skeletons, generate a "light" skeleton (also known as "loader"
+		  skeleton). A light skeleton contains a loader eBPF program. It does
+		  not use the majority of the libbpf infrastructure, and does not need
+		  libelf.
+
 EXAMPLES
 ========
 **$ cat example1.bpf.c**
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 4b8412fe2c60..2ea5df30ff21 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -13,7 +13,8 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **prog** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } }
+		{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } |
+		{ **-L** | **--use-loader** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **dump xlated** | **dump jited** | **pin** | **load**
@@ -224,6 +225,20 @@ OPTIONS
 		  Do not automatically attempt to mount any virtual file system
 		  (such as tracefs or BPF virtual file system) when necessary.
 
+	-L, --use-loader
+		  Load program as a "loader" program. This is useful to debug
+		  the generation of such programs. When this option is in
+		  use, bpftool attempts to load the programs from the object
+		  file into the kernel, but does not pin them (therefore, the
+		  *PATH* must not be provided).
+
+		  When combined with the **-d**\ \|\ **--debug** option,
+		  additional debug messages are generated, and the execution
+		  of the loader program will use the **bpf_trace_printk**\ ()
+		  helper to log each step of loading BTF, creating the maps,
+		  and loading the programs (see **bpftool prog tracelog** as
+		  a way to dump those messages).
+
 EXAMPLES
 ========
 **# bpftool prog show**
@@ -327,3 +342,16 @@ EXAMPLES
       40176203 cycles                                                 (83.05%)
       42518139 instructions    #   1.06 insns per cycle               (83.39%)
            123 llc_misses      #   2.89 LLC misses per million insns  (83.15%)
+
+|
+| Output below is for the trace logs.
+| Run in separate terminals:
+| **# bpftool prog tracelog**
+| **# bpftool prog load -L -d file.o**
+
+::
+
+    bpftool-620059  [004] d... 2634685.517903: bpf_trace_printk: btf_load size 665 r=5
+    bpftool-620059  [004] d... 2634685.517912: bpf_trace_printk: map_create sample_map idx 0 type 2 value_size 4 value_btf_id 0 r=6
+    bpftool-620059  [004] d... 2634685.517997: bpf_trace_printk: prog_load sample insn_cnt 13 r=7
+    bpftool-620059  [004] d... 2634685.517999: bpf_trace_printk: close(5) = 0
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 1521a725f07c..134135424e7f 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -260,7 +260,8 @@ _bpftool()
 
     # Deal with options
     if [[ ${words[cword]} == -* ]]; then
-        local c='--version --json --pretty --bpffs --mapcompat --debug'
+        local c='--version --json --pretty --bpffs --mapcompat --debug \
+	       --use-loader --base-btf'
         COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
         return 0
     fi
@@ -278,7 +279,7 @@ _bpftool()
             _sysfs_get_netdevs
             return 0
             ;;
-        file|pinned)
+        file|pinned|-B|--base-btf)
             _filedir
             return 0
             ;;
@@ -291,7 +292,8 @@ _bpftool()
     # Remove all options so completions don't have to deal with them.
     local i
     for (( i=1; i < ${#words[@]}; )); do
-        if [[ ${words[i]::1} == - ]]; then
+        if [[ ${words[i]::1} == - ]] &&
+            [[ ${words[i]} != "-B" ]] && [[ ${words[i]} != "--base-btf" ]]; then
             words=( "${words[@]:0:i}" "${words[@]:i+1}" )
             [[ $i -le $cword ]] && cword=$(( cword - 1 ))
         else
diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 3c5fc9b25c30..f7e5ff3586c9 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -981,7 +981,8 @@ static int do_help(int argc, char **argv)
 		"       FORMAT  := { raw | c }\n"
 		"       " HELP_SPEC_MAP "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
-		"       " HELP_SPEC_OPTIONS " }\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-B|--base-btf} }\n"
 		"",
 		bin_name, "btf");
 
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index c42f437a1015..3571a281c43f 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -502,7 +502,7 @@ static int do_help(int argc, char **argv)
 		"       " HELP_SPEC_ATTACH_FLAGS "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
-		"                    {-f|--bpffs} }
+		"                    {-f|--bpffs} }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index d4225f7fbcee..d40d92bbf0e4 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1026,7 +1026,8 @@ static int do_help(int argc, char **argv)
 		"       %1$s %2$s skeleton FILE [name OBJECT_NAME]\n"
 		"       %1$s %2$s help\n"
 		"\n"
-		"       " HELP_SPEC_OPTIONS " }\n"
+		"       " HELP_SPEC_OPTIONS " |\n"
+		"                    {-L|--use-loader} }\n"
 		"",
 		bin_name, "gen");
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index a205f7124b38..9c3e343b7d87 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2260,7 +2260,8 @@ static int do_help(int argc, char **argv)
 		"                        stream_parser | flow_dissector }\n"
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses | itlb_misses | dtlb_misses }\n"
 		"       " HELP_SPEC_OPTIONS " |\n"
-		"                    {-f|--bpffs} | {-m|--mapcompat} | {-n|--nomount} }\n"
+		"                    {-f|--bpffs} | {-m|--mapcompat} | {-n|--nomount} |\n"
+		"                    {-L|--use-loader} }\n"
 		"",
 		bin_name, argv[-2]);
 
-- 
2.30.2

