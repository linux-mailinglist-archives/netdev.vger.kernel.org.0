Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3E9560355
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbiF2Oke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiF2Oka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:40:30 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522F7381B1
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:29 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so5746163wmb.3
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 07:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V65gkuE95550YJjRx52ZjJytf4+TcCOGZdYdBtsFvhc=;
        b=vX4ShwjGvrk9MOmVyJ3jUHJJrtHwGoe4FOjValwtSMFK9XUIFvlkdbRP9YkzON9vMH
         Yc8bxRBklEivhx00BExdaSi8rxCG+yJZrWkUeAtctQJAbU46d8lxQY6zTfSkx0KItj3J
         gSMu3ZgdXvQKpYj3gafycCTYSwsAqMyrxqAfEg1R6D8Hz3zrEL6hRrVTt7T9X9P07jYh
         /PO2JVie1/KGtgLxFgSKV0GRjgQjyyhf24/LKU6vZdDD2epYBmuQZ4b8l/mXYEp3SK97
         4zxQT4O8OmWzOQCmIVdCqorZ620wfzqgIlzUIseDXggcRXoMttbZrtUefk1klmFyQVEq
         7kUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V65gkuE95550YJjRx52ZjJytf4+TcCOGZdYdBtsFvhc=;
        b=w+/xWdanEZJtRxiFCEntq6reQBmZ652UY7QF1PQa6/a6qe4lCKt5jfFIseb6Vjr+kE
         SWbhCgRC0/7sWdnedFaybVRxylNGSGy/cJ3eO0g9UybTt14DRLdl8GrJa9owdJYDCLkF
         Vhy5PlzeH8YbYRmCPugjQqwQDeqVpLfUSTC6ynTAeOFjjveJgVrA8YDufUNbS9SNkc2L
         hk9vxpq6NMcXkfx9EG8iSYLNzydekgh11Kg/X9G885cD3R3sHsdXJOiLq8YlS18a7HhB
         BDFoFPk7n5d6qb7ZML048IgDaYHMWfsgFWyCUvHQ2W3iTEXf00Wcn8gVG/tH3Dhq0glM
         vS0Q==
X-Gm-Message-State: AJIora/NhIFMYxxMLQh8BhAdFo2qfXxUh5OEFCpaxWEVjNtWdCjhmUAo
        h4YLUcLdTZwBT/0AiVRhZFnM5Q==
X-Google-Smtp-Source: AGRyM1vFrdNOO1W1iP+svLoZp0KNPnk5wqaeZV8Ngy2dYy/O/JWOpUUJ915KM7HCTodUvWzdZRoPBA==
X-Received: by 2002:a05:600c:3542:b0:3a1:6855:1153 with SMTP id i2-20020a05600c354200b003a168551153mr3919943wmq.121.1656513627850;
        Wed, 29 Jun 2022 07:40:27 -0700 (PDT)
Received: from harfang.fritz.box ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id h13-20020adff4cd000000b002103aebe8absm16770518wrp.93.2022.06.29.07.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 07:40:27 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] bpftool: Add feature list (prog/map/link/attach types, helpers)
Date:   Wed, 29 Jun 2022 15:40:18 +0100
Message-Id: <20220629144019.75181-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629144019.75181-1-quentin@isovalent.com>
References: <20220629144019.75181-1-quentin@isovalent.com>
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

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpftool/Documentation/bpftool-feature.rst | 12 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  7 ++-
 tools/bpf/bpftool/feature.c                   | 55 +++++++++++++++++++
 3 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 4ce9a77bc1e0..4bf1724d0e8c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -24,9 +24,11 @@ FEATURE COMMANDS
 ================
 
 |	**bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivileged**] [**macros** [**prefix** *PREFIX*]]
+|	**bpftool** **feature list** *GROUP*
 |	**bpftool** **feature help**
 |
 |	*COMPONENT* := { **kernel** | **dev** *NAME* }
+|	*GROUP* := { **prog_types** | **map_types** | **attach_types** | **helpers** }
 
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

