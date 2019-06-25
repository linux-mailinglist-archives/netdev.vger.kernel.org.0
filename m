Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FB55202C
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbfFYA5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:57:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40541 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728340AbfFYA5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:57:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id a15so16603072qtn.7
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 17:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NCDQ2ItaLdjU1MysfV10yrLcotvguvpykGzXVNrZ+to=;
        b=B1Vbr3/phWu/Ec3l9M/Q0IdLqbdjOGoibpd3/uSfnb5jGBQJvunkOZKN7+LG/1SQu2
         4wz/xCBJcMffQw+4Ifpw2xwCTpFMX1qBLtVG7QyoXlx7jKrg7qPAvQFFP2ZTmg2ZrxM7
         fWYgkGJ/4KGAFYetoBxAUhc8KvHBbO7iNeq9Jyfqth7wd85W4GsZUMvSTTQEa9I4sDCt
         mssOJ9+l9FQkG2xeAxLYuhtb2jw580aMOamOLVoe7aUTHVr+D4zht/GLOTqyhJlg+arR
         kfzkEc0R/DUOTT9hwx1q7IjMMIlkT8/aRrfFiGK5E+VkFH0oT0JXd+wgw/DELyTbq2NE
         IY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NCDQ2ItaLdjU1MysfV10yrLcotvguvpykGzXVNrZ+to=;
        b=Ok3fQXvg1vjQLVFWMyopC+OXsHiZzOBuLxjXmdWTjjVoWGf89gcOZOR36ryn8byVDT
         hqgpPTFjWfyahZ8o2sEvB08TCEW1zjCKbz4C86BTXRHoTQELrIFfNSz72UT8VpYASHXS
         LQVQ1m1gD22qkpDz0fyWyf+UMSDeyCH2yNbgvR/lILCSgeUK/OUw/z5+7E8dERez+wp5
         m0V38g1WpSoXdQ1W0Y6y/icdWO3avmH5fMMEaR0WlF5+svxf1ksoXASi9IJZw2649JYg
         h3S0v5UwM7VhaTVftJ8vUtv02U1YRl4dymsjDihjekAQyf8qZg1TNyoJ6RQ7qlUuefwm
         QMlg==
X-Gm-Message-State: APjAAAU/sGxpwjVxI61YJ+1TBNi7xXoziCyLA5lOwmU0gfp6I2CylnOc
        2LVn23p0iyFEnQrhrL8sATVuCXHZpZk=
X-Google-Smtp-Source: APXvYqw76C9GfnG/7PhLaO5xi9gti8Dvbr08xvUR+JyD8QU8A959H5bxMVQyHCf43ANO+zmFOw/upg==
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr127243032qtf.204.1561424265676;
        Mon, 24 Jun 2019 17:57:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id a21sm6793552qkg.47.2019.06.24.17.57.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 17:57:45 -0700 (PDT)
Date:   Mon, 24 Jun 2019 17:57:40 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Message-ID: <20190624175740.5cccea9b@cakuba.netronome.com>
In-Reply-To: <20190624174726.2dda122b@cakuba.netronome.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
        <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
        <20190624145111.49176d8e@cakuba.netronome.com>
        <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
        <20190624154309.5ef3357b@cakuba.netronome.com>
        <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
        <20190624171641.73cd197d@cakuba.netronome.com>
        <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
        <20190624173005.06430163@cakuba.netronome.com>
        <01c2c76b-5a45-aab0-e698-b5a66ab6c2e7@fb.com>
        <20190624174726.2dda122b@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jun 2019 17:47:26 -0700, Jakub Kicinski wrote:
> I see.  The local flag would not an option in getopt_long() sense, what
> I was thinking was about adding an "effective" keyword:

Something like this, untested:

--->8------------

The BPF_F_QUERY_EFFECTIVE is a syscall flag, and fits nicely
as a subcommand option.  We want to move away from global
options, anyway.

We need a global variable because of nftw limitations.
Clean this flag on every invocations in case we run in
batch mode.

NOTE the argv[1] use on the error path in do_show() looks
like a bug on it's own.
---
 .../bpftool/Documentation/bpftool-cgroup.rst  | 24 +++----
 tools/bpf/bpftool/Documentation/bpftool.rst   |  6 +-
 tools/bpf/bpftool/bash-completion/bpftool     | 17 ++---
 tools/bpf/bpftool/cgroup.c                    | 62 ++++++++++++-------
 tools/bpf/bpftool/main.c                      |  7 +--
 tools/bpf/bpftool/main.h                      |  3 +-
 6 files changed, 66 insertions(+), 53 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 324df15bf4cc..4fde3dfad395 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -12,8 +12,7 @@ SYNOPSIS
 
 	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** }
-	| { **-e** | **--effective** } }
+	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **tree** | **attach** | **detach** | **help** }
@@ -21,8 +20,8 @@ SYNOPSIS
 CGROUP COMMANDS
 ===============
 
-|	**bpftool** **cgroup { show | list }** *CGROUP*
-|	**bpftool** **cgroup tree** [*CGROUP_ROOT*]
+|	**bpftool** **cgroup { show | list }** *CGROUP* [**effective**]
+|	**bpftool** **cgroup tree** [*CGROUP_ROOT*] [**effective**]
 |	**bpftool** **cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*]
 |	**bpftool** **cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
 |	**bpftool** **cgroup help**
@@ -35,13 +34,17 @@ CGROUP COMMANDS
 
 DESCRIPTION
 ===========
-	**bpftool cgroup { show | list }** *CGROUP*
+	**bpftool cgroup { show | list }** *CGROUP* [**effective**]
 		  List all programs attached to the cgroup *CGROUP*.
 
 		  Output will start with program ID followed by attach type,
 		  attach flags and program name.
 
-	**bpftool cgroup tree** [*CGROUP_ROOT*]
+		  If **effective** is specified retrieve effective programs that
+		  will execute for events within a cgroup. This includes
+		  inherited along with attached ones.
+
+	**bpftool cgroup tree** [*CGROUP_ROOT*] [**effective**]
 		  Iterate over all cgroups in *CGROUP_ROOT* and list all
 		  attached programs. If *CGROUP_ROOT* is not specified,
 		  bpftool uses cgroup v2 mountpoint.
@@ -50,6 +53,10 @@ DESCRIPTION
 		  commands: it starts with absolute cgroup path, followed by
 		  program ID, attach type, attach flags and program name.
 
+		  If **effective** is specified retrieve effective programs that
+		  will execute for events within a cgroup. This includes
+		  inherited along with attached ones.
+
 	**bpftool cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*]
 		  Attach program *PROG* to the cgroup *CGROUP* with attach type
 		  *ATTACH_TYPE* and optional *ATTACH_FLAGS*.
@@ -122,11 +129,6 @@ OPTIONS
 		  Print all logs available from libbpf, including debug-level
 		  information.
 
-	-e, --effective
-		  Retrieve effective programs that will execute for events
-		  within a cgroup. This includes inherited along with attached
-		  ones.
-
 EXAMPLES
 ========
 |
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index d2f76b55988d..6a9c52ef84a9 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -19,7 +19,7 @@ SYNOPSIS
 	*OBJECT* := { **map** | **program** | **cgroup** | **perf** | **net** | **feature** }
 
 	*OPTIONS* := { { **-V** | **--version** } | { **-h** | **--help** }
-	| { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-e** | **--effective** } }
+	| { **-j** | **--json** } [{ **-p** | **--pretty** }] }
 
 	*MAP-COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext**
@@ -71,10 +71,6 @@ OPTIONS
 		  includes logs from libbpf as well as from the verifier, when
 		  attempting to load programs.
 
-	-e, --effective
-		  Retrieve effective programs that will execute for events
-		  within a cgroup. This includes inherited along with attached ones.
-
 SEE ALSO
 ========
 	**bpf**\ (2),
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index c98cb99867f6..de84ae06ae4e 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -187,7 +187,7 @@ _bpftool()
 
     # Deal with options
     if [[ ${words[cword]} == -* ]]; then
-        local c='--version --json --pretty --bpffs --mapcompat --debug --effective'
+        local c='--version --json --pretty --bpffs --mapcompat --debug'
         COMPREPLY=( $( compgen -W "$c" -- "$cur" ) )
         return 0
     fi
@@ -678,12 +678,15 @@ _bpftool()
             ;;
         cgroup)
             case $command in
-                show|list)
-                    _filedir
-                    return 0
-                    ;;
-                tree)
-                    _filedir
+                show|list|tree)
+                    case $cword in
+                        3)
+                            _filedir
+                            ;;
+                        4)
+                            COMPREPLY=( $( compgen -W 'effective' -- "$cur" ) )
+                            ;;
+                    esac
                     return 0
                     ;;
                 attach|detach)
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 1bb2a751107a..88b80616d47b 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -28,6 +28,8 @@
 	"                        connect6 | sendmsg4 | sendmsg6 |\n"           \
 	"                        recvmsg4 | recvmsg6 | sysctl }"
 
+static unsigned int query_flags;
+
 static const char * const attach_type_strings[] = {
 	[BPF_CGROUP_INET_INGRESS] = "ingress",
 	[BPF_CGROUP_INET_EGRESS] = "egress",
@@ -104,8 +106,8 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 	__u32 prog_cnt = 0;
 	int ret;
 
-	ret = bpf_prog_query(cgroup_fd, type, query_flags, NULL, NULL,
-			     &prog_cnt);
+	ret = bpf_prog_query(cgroup_fd, type, query_flags, NULL,
+			     NULL, &prog_cnt);
 	if (ret)
 		return -1;
 
@@ -156,20 +158,30 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 static int do_show(int argc, char **argv)
 {
 	enum bpf_attach_type type;
+	const char *path;
 	int cgroup_fd;
 	int ret = -1;
 
-	if (argc < 1) {
-		p_err("too few parameters for cgroup show");
-		goto exit;
-	} else if (argc > 1) {
-		p_err("too many parameters for cgroup show");
-		goto exit;
+	query_flags = 0;
+
+	if (!REQ_ARGS(1))
+		return -1;
+	path = GET_ARG();
+
+	while (argc) {
+		if (is_prefix(*argv, "effective")) {
+			query_flags |= BPF_F_QUERY_EFFECTIVE;
+			NEXT_ARG();
+		} else {
+			p_err("expected no more arguments, 'effective', got: '%s'?",
+			      *argv);
+			return -1;
+		}
 	}
 
-	cgroup_fd = open(argv[0], O_RDONLY);
+	cgroup_fd = open(path, O_RDONLY);
 	if (cgroup_fd < 0) {
-		p_err("can't open cgroup %s", argv[1]);
+		p_err("can't open cgroup %s", path);
 		goto exit;
 	}
 
@@ -295,23 +307,29 @@ static int do_show_tree(int argc, char **argv)
 	char *cgroup_root;
 	int ret;
 
-	switch (argc) {
-	case 0:
+	query_flags = 0;
+
+	if (!argc) {
 		cgroup_root = find_cgroup_root();
 		if (!cgroup_root) {
 			p_err("cgroup v2 isn't mounted");
 			return -1;
 		}
-		break;
-	case 1:
-		cgroup_root = argv[0];
-		break;
-	default:
-		p_err("too many parameters for cgroup tree");
-		return -1;
+	} else {
+		cgroup_root = GET_ARG();
+
+		while (argc) {
+			if (is_prefix(*argv, "effective")) {
+				query_flags |= BPF_F_QUERY_EFFECTIVE;
+				NEXT_ARG();
+			} else {
+				p_err("expected no more arguments, 'effective', got: '%s'?",
+				      *argv);
+				return -1;
+			}
+		}
 	}
 
-
 	if (json_output)
 		jsonw_start_array(json_wtr);
 	else
@@ -457,8 +475,8 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } CGROUP\n"
-		"       %s %s tree [CGROUP_ROOT]\n"
+		"Usage: %s %s { show | list } CGROUP [**effective**]\n"
+		"       %s %s tree [CGROUP_ROOT] [**effective**]\n"
 		"       %s %s attach CGROUP ATTACH_TYPE PROG [ATTACH_FLAGS]\n"
 		"       %s %s detach CGROUP ATTACH_TYPE PROG\n"
 		"       %s %s help\n"
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 42e9ddfbbbe0..4879f6395c7e 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -27,7 +27,6 @@ bool json_output;
 bool show_pinned;
 bool block_mount;
 bool verifier_logs;
-unsigned int query_flags;
 int bpf_flags;
 struct pinned_obj_table prog_table;
 struct pinned_obj_table map_table;
@@ -328,7 +327,6 @@ int main(int argc, char **argv)
 		{ "mapcompat",	no_argument,	NULL,	'm' },
 		{ "nomount",	no_argument,	NULL,	'n' },
 		{ "debug",	no_argument,	NULL,	'd' },
-		{ "effective",	no_argument,	NULL,	'e' },
 		{ 0 }
 	};
 	int opt, ret;
@@ -344,7 +342,7 @@ int main(int argc, char **argv)
 	hash_init(map_table.table);
 
 	opterr = 0;
-	while ((opt = getopt_long(argc, argv, "Vhpjfmnde",
+	while ((opt = getopt_long(argc, argv, "Vhpjfmnd",
 				  options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -378,9 +376,6 @@ int main(int argc, char **argv)
 			libbpf_set_print(print_all_levels);
 			verifier_logs = true;
 			break;
-		case 'e':
-			query_flags = BPF_F_QUERY_EFFECTIVE;
-			break;
 		default:
 			p_err("unrecognized option '%s'", argv[optind - 1]);
 			if (json_output)
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index fddec15c454a..28a2a5857e14 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -45,7 +45,7 @@
 	"PROG := { id PROG_ID | pinned FILE | tag PROG_TAG }"
 #define HELP_SPEC_OPTIONS						\
 	"OPTIONS := { {-j|--json} [{-p|--pretty}] | {-f|--bpffs} |\n"	\
-	"\t            {-m|--mapcompat} | {-n|--nomount} | {-e|--effective} }"
+	"\t            {-m|--mapcompat} | {-n|--nomount} }"
 #define HELP_SPEC_MAP							\
 	"MAP := { id MAP_ID | pinned FILE }"
 
@@ -92,7 +92,6 @@ extern bool json_output;
 extern bool show_pinned;
 extern bool block_mount;
 extern bool verifier_logs;
-extern unsigned int query_flags;
 extern int bpf_flags;
 extern struct pinned_obj_table prog_table;
 extern struct pinned_obj_table map_table;
-- 
2.21.0

