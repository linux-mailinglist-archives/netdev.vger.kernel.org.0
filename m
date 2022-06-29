Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B170560B22
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiF2Ugq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiF2Ugo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:36:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EB23AA5D
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:36:43 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id r20so24186061wra.1
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ttD/svoirIxXxLwqSgiy25UwXzGhj+wZ4JgpAPoFz9E=;
        b=KgDiNniiYWBisspGSMN9xQ63GID+vC+UlaWOOZmi45qZRlDgwS0luI+CYOQFT0blfV
         dDLZLJMwk4I27vn+KYMEPVeCb+b4yJ5hIFV9ZxgKaOuUvNJCjSYQC3KD/DjwYCWeQSD7
         JUx0H/lzWCe5vuEBBW5/MgKMG40WKh5DsKET1jOMPU1FhEVze4iIL0nHJ62zxQrkadnF
         QVBDlMONIjC/m91AhARsjG4ChRpdGyOaI9xXcZtVg42bmV3DTfZ7gvVutm7VkPS71MbN
         n9bWRbiHW8/r5KiZw2+5hg7gAn3mEwzLFXy+MVps2uvPPTUe2sL273shLvW/7FUe7PCL
         /jfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ttD/svoirIxXxLwqSgiy25UwXzGhj+wZ4JgpAPoFz9E=;
        b=BBSE/OkkD42lBSCXNOreIk0Gi2YsA2Qd0oqH1f6sWv983Rn26bErNkYLLaXGu+FLEQ
         ZFmaWjEwiTV/KwSnhFMvwEB7dF905Y4lXpkBoj1KyqhFUVFr4tf3e9A5r+8fyxfqdKdV
         eJoIzqhg9eOBXBgfa117v6HH6S2GwyRZt5RNeOgg2wV2nMc32wj0qE/SjQUYmsPsRCXY
         FWXdnv8WSGc9z29A6KLIHRS2ULUkJJvXqfhMFPJ9da8sjzrDQKyyWx9C/xekPv3WhFsd
         1YH7kYsQYI5K7nUWspPsoiLGoyx2vy1NMNuJs83QFViUiRXDfAodugmDmiozuEPdRnzR
         92/A==
X-Gm-Message-State: AJIora965fCbo2hA4yjHhikY9MRaOSd4uDqrFm/COOyAl5koEHgfeRAQ
        2MgEN1vWDB89CMTk12TZjR5tNPf50K/xS8IEB7E=
X-Google-Smtp-Source: AGRyM1tQKG+Jh3QEDjiSJ9ky+EG7wHmknbGdBqxfMG+ZkeEUK3jTMDqKqcMMtPM+MfMhjw5IF0qp4Q==
X-Received: by 2002:a05:6000:1888:b0:21d:151c:92a0 with SMTP id a8-20020a056000188800b0021d151c92a0mr4813311wri.609.1656535002161;
        Wed, 29 Jun 2022 13:36:42 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c4f1500b003a02b9c47e4sm246986wmq.27.2022.06.29.13.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 13:36:41 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>
Subject: [PATCH bpf-next v2 1/2] bpftool: Add feature list (prog/map/link/attach types, helpers)
Date:   Wed, 29 Jun 2022 21:36:36 +0100
Message-Id: <20220629203637.138944-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629203637.138944-1-quentin@isovalent.com>
References: <20220629203637.138944-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Add a "bpftool feature list" subcommand to list BPF "features".
Contrarily to "bpftool feature probe", this is not about the features
available on the system. Instead, it lists all features known to bpftool
from compilation time; in other words, all program, map, attach, link
types known to the libbpf version in use, and all helpers found in the
UAPI BPF header.

The first use case for this feature is bash completion: running the
command provides a list of types that can be used to produce the list of
candidate map types, for example.

Now that bpftool uses "standard" names provided by libbpf for the
program, map, link, and attach types, having the ability to list these
types and helpers could also be useful in scripts to loop over existing
items.

Sample output:

    # bpftool feature list prog_types | grep -vw unspec | head -n 6
    socket_filter
    kprobe
    sched_cls
    sched_act
    tracepoint
    xdp

    # bpftool -p feature list map_types | jq '.[1]'
    "hash"

    # bpftool feature list attach_types | grep '^cgroup_'
    cgroup_inet_ingress
    cgroup_inet_egress
    [...]
    cgroup_inet_sock_release

    # bpftool feature list helpers | grep -vw bpf_unspec | wc -l
    207

The "unspec" types and helpers are not filtered out by bpftool, so as to
remain closer to the enums, and to preserve the indices in the JSON
arrays (e.g. "hash" at index 1 == BPF_MAP_TYPE_HASH in map types list).

v2: Add missing "link_types" to the list of GROUPs in man page.

Acked-by: Daniel Müller <deso@posteo.net>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpftool/Documentation/bpftool-feature.rst | 12 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  7 ++-
 tools/bpf/bpftool/feature.c                   | 55 +++++++++++++++++++
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 4ce9a77bc1e0..c08064628d39 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -24,9 +24,11 @@ FEATURE COMMANDS
 ================
 
 |	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivileged**] [**macros** [**prefix** *PREFIX*]]
+|	**bpftool** **feature list** *GROUP*
 |	**bpftool** **feature help**
 |
 |	*COMPONENT* := { **kernel** | **dev** *NAME* }
+|	*GROUP* := { **prog_types** | **map_types** | **attach_types** | **link_types** | **helpers** }
 
 DESCRIPTION
 ===========
@@ -70,6 +72,16 @@ DESCRIPTION
 		  The keywords **full**, **macros** and **prefix** have the
 		  same role as when probing the kernel.
 
+	**bpftool feature list** *GROUP*
+		  List items known to bpftool. These can be BPF program types
+		  (**prog_types**), BPF map types (**map_types**), attach types
+		  (**attach_types**), link types (**link_types**), or BPF helper
+		  functions (**helpers**). The command does not probe the system, but
+		  simply lists the elements that bpftool knows from compilation time,
+		  as provided from libbpf (for all object types) or from the BPF UAPI
+		  header (list of helpers). This can be used in scripts to iterate over
+		  BPF types or helpers.
+
 	**bpftool feature help**
 		  Print short help message.
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 91f89a9a5b36..9cef6516320b 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -1175,9 +1175,14 @@ _bpftool()
                     _bpftool_once_attr 'full unprivileged'
                     return 0
                     ;;
+                list)
+                    [[ $prev != "$command" ]] && return 0
+                    COMPREPLY=( $( compgen -W 'prog_types map_types \
+                        attach_types link_types helpers' -- "$cur" ) )
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'help probe' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'help list probe' -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index bac4ef428a02..576cc6b90c6a 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -1258,6 +1258,58 @@ static int do_probe(int argc, char **argv)
 	return 0;
 }
 
+static const char *get_helper_name(unsigned int id)
+{
+	if (id >= ARRAY_SIZE(helper_name))
+		return NULL;
+
+	return helper_name[id];
+}
+
+static int do_list(int argc, char **argv)
+{
+	const char *(*get_name)(unsigned int id);
+	unsigned int id = 0;
+
+	if (argc < 1)
+		usage();
+
+	if (is_prefix(*argv, "prog_types")) {
+		get_name = (const char *(*)(unsigned int))libbpf_bpf_prog_type_str;
+	} else if (is_prefix(*argv, "map_types")) {
+		get_name = (const char *(*)(unsigned int))libbpf_bpf_map_type_str;
+	} else if (is_prefix(*argv, "attach_types")) {
+		get_name = (const char *(*)(unsigned int))libbpf_bpf_attach_type_str;
+	} else if (is_prefix(*argv, "link_types")) {
+		get_name = (const char *(*)(unsigned int))libbpf_bpf_link_type_str;
+	} else if (is_prefix(*argv, "helpers")) {
+		get_name = get_helper_name;
+	} else {
+		p_err("expected 'prog_types', 'map_types', 'attach_types', 'link_types' or 'helpers', got: %s", *argv);
+		return -1;
+	}
+
+	if (json_output)
+		jsonw_start_array(json_wtr);	/* root array */
+
+	while (true) {
+		const char *name;
+
+		name = get_name(id++);
+		if (!name)
+			break;
+		if (json_output)
+			jsonw_string(json_wtr, name);
+		else
+			printf("%s\n", name);
+	}
+
+	if (json_output)
+		jsonw_end_array(json_wtr);	/* root array */
+
+	return 0;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -1267,9 +1319,11 @@ static int do_help(int argc, char **argv)
 
 	fprintf(stderr,
 		"Usage: %1$s %2$s probe [COMPONENT] [full] [unprivileged] [macros [prefix PREFIX]]\n"
+		"       %1$s %2$s list GROUP\n"
 		"       %1$s %2$s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
+		"       GROUP := { prog_types | map_types | attach_types | link_types | helpers }\n"
 		"       " HELP_SPEC_OPTIONS " }\n"
 		"",
 		bin_name, argv[-2]);
@@ -1279,6 +1333,7 @@ static int do_help(int argc, char **argv)
 
 static const struct cmd cmds[] = {
 	{ "probe",	do_probe },
+	{ "list",	do_list },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.34.1

