Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93AE563056
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiGAJiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiGAJiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:38:14 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE68E6F
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:38:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o4so2372946wrh.3
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdFNETY1/zZ7EGb3WBInhSzCH+khDV+cVT2dMm/WLTw=;
        b=xCxtJjbnekJf5az/bpktb+9wtumtJA1/+q4zLKxVgdl98RkIlr1Ihy90rHQVUAqHio
         p07wZMR/dtbLLsJN3rlCpa2D26sfEAcvrrkTcpInivXTcHUG/XsAdvZo5nEK3O5HE0XL
         OFQU9K9n8Ucjyb6P40lohEmxRa+A61aOHl9bKn7yxiv6W41bV4bFPAs6fkUpOKqoowQs
         3+sS7V4moBOWrLaHtmzy70iTXP6q993qyOeL7vhRZjrDb1vtqn0UyCddNifB9uWCWco6
         Tx+jS3m4yjh3NteJeo+XKtH/gLIdq5zNNt7ArkG+KHmV5wskTYXm2O64YtqxjoH/v3Hh
         gA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VdFNETY1/zZ7EGb3WBInhSzCH+khDV+cVT2dMm/WLTw=;
        b=E3bQk8GIJaQEkmOKBkkB8ntB2CRxGXlb9umRLAJ34efu0MtMPzJ3fWUyFr186Gm0PB
         O81SBp4WUNnk8a0dAkZ3NXPrgjUOMbL9DTxWCP2C3I0qLOAamxu5FM8xznMA+2aWPKGH
         /zETYAdldgT8EHTTbnYaz76nV08+QHeTqD0TUAsRbjCaDbeVUAli/dOpZTVArVqklRkM
         C4qBsL7dWLHwxswaZ4uTDOWx3p0wSDX6IEXP3PH0LrVNcYYK/a5iU/a3jMja19AybDLi
         NkszFmTTjny1pz9BZwTtDNt5Ur92eEILoSBPOvxf/Tq1j5+tx7wG1qm1R2I+zyFX3Pu0
         anJA==
X-Gm-Message-State: AJIora9tZTDa3vRH9ERkVUwldIikEqQ42jQS+Qkg6sXZXKkJwNg7EVEf
        e3OKzckDaF98OgeNgHNc258w1A==
X-Google-Smtp-Source: AGRyM1vmiSBKI9yoBohB3kex/lGZ5zzECNwsKP50NzNRvsvRdJP61gzEVz1yaB0ddQGto4r26janXw==
X-Received: by 2002:a05:6000:1812:b0:21b:adf8:97c0 with SMTP id m18-20020a056000181200b0021badf897c0mr12948143wrh.672.1656668289643;
        Fri, 01 Jul 2022 02:38:09 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id q13-20020adfcd8d000000b00219b391c2d2sm25943461wrj.36.2022.07.01.02.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 02:38:09 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] bpftool: Rename "bpftool feature list" into "... feature list_builtins"
Date:   Fri,  1 Jul 2022 10:38:05 +0100
Message-Id: <20220701093805.16920-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make it more explicit that the features listed with "bpftool feature
list" are known to bpftool, but not necessary available on the system
(as opposed to the probed features), rename the "feature list" command
into "feature list_builtins".

Note that "bpftool feature list" still works as before given that we
recognise arguments from their prefixes; but the real name of the
subcommand, in particular as displayed in the man page or the
interactive help, will now include "_builtins".

Since we update the bash completion accordingly, let's also take this
chance to redirect error output to /dev/null in the completion script,
to avoid displaying unexpected error messages when users attempt to
tab-complete.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool-feature.rst |  4 ++--
 tools/bpf/bpftool/bash-completion/bpftool           |  8 ++++----
 tools/bpf/bpftool/feature.c                         | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index c08064628d39..e44039f89be7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -24,7 +24,7 @@ FEATURE COMMANDS
 ================
 
 |	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivileged**] [**macros** [**prefix** *PREFIX*]]
-|	**bpftool** **feature list** *GROUP*
+|	**bpftool** **feature list_builtins** *GROUP*
 |	**bpftool** **feature help**
 |
 |	*COMPONENT* := { **kernel** | **dev** *NAME* }
@@ -72,7 +72,7 @@ DESCRIPTION
 		  The keywords **full**, **macros** and **prefix** have the
 		  same role as when probing the kernel.
 
-	**bpftool feature list** *GROUP*
+	**bpftool feature list_builtins** *GROUP*
 		  List items known to bpftool. These can be BPF program types
 		  (**prog_types**), BPF map types (**map_types**), attach types
 		  (**attach_types**), link types (**link_types**), or BPF helper
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index ee177f83b179..dc1641e3670e 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -703,7 +703,7 @@ _bpftool()
                             return 0
                             ;;
                         type)
-                            local BPFTOOL_MAP_CREATE_TYPES="$(bpftool feature list map_types | \
+                            local BPFTOOL_MAP_CREATE_TYPES="$(bpftool feature list_builtins map_types 2>/dev/null | \
                                 grep -v '^unspec$')"
                             COMPREPLY=( $( compgen -W "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
                             return 0
@@ -1032,7 +1032,7 @@ _bpftool()
                     return 0
                     ;;
                 attach|detach)
-                    local BPFTOOL_CGROUP_ATTACH_TYPES="$(bpftool feature list attach_types | \
+                    local BPFTOOL_CGROUP_ATTACH_TYPES="$(bpftool feature list_builtins attach_types 2>/dev/null | \
                         grep '^cgroup_')"
                     local ATTACH_FLAGS='multi override'
                     local PROG_TYPE='id pinned tag name'
@@ -1162,14 +1162,14 @@ _bpftool()
                     _bpftool_once_attr 'full unprivileged'
                     return 0
                     ;;
-                list)
+                list_builtins)
                     [[ $prev != "$command" ]] && return 0
                     COMPREPLY=( $( compgen -W 'prog_types map_types \
                         attach_types link_types helpers' -- "$cur" ) )
                     ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'help list probe' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'help list_builtins probe' -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 576cc6b90c6a..7ecabf7947fb 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -1266,7 +1266,7 @@ static const char *get_helper_name(unsigned int id)
 	return helper_name[id];
 }
 
-static int do_list(int argc, char **argv)
+static int do_list_builtins(int argc, char **argv)
 {
 	const char *(*get_name)(unsigned int id);
 	unsigned int id = 0;
@@ -1319,7 +1319,7 @@ static int do_help(int argc, char **argv)
 
 	fprintf(stderr,
 		"Usage: %1$s %2$s probe [COMPONENT] [full] [unprivileged] [macros [prefix PREFIX]]\n"
-		"       %1$s %2$s list GROUP\n"
+		"       %1$s %2$s list_builtins GROUP\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
@@ -1332,9 +1332,9 @@ static int do_help(int argc, char **argv)
 }
 
 static const struct cmd cmds[] = {
-	{ "probe",	do_probe },
-	{ "list",	do_list },
-	{ "help",	do_help },
+	{ "probe",		do_probe },
+	{ "list_builtins",	do_list_builtins },
+	{ "help",		do_help },
 	{ 0 }
 };
 
-- 
2.34.1

