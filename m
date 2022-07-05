Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7484256625D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 06:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbiGEEZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 00:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiGEEZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 00:25:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B1D012612
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 21:25:24 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w24so11006532pjg.5
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 21:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVyR42g71SiMG4Cqfp8CFfZUQ1JtKc/2IZgcv2zayEw=;
        b=SnKmaLBVj7WeXQwZzvVkvsuw060eDikQVZc7gJhOfQ3yJP1TzVctLgMvP3aNclYJdn
         7LBuyuLEp4ghAopk4JWkULo6/Z3Oz4f2YuCUQYYESDB3ToKDnvyf89zaqbUYD0AOXA3k
         SUStXKvRLDy9l/tRPGH5laPBosxozV8jXqOha0wgyoIM1IiHb201zVJqFkf/I4KyH+u3
         ddHS7N7v1iq7tTbzbw5Q5v6D4xDTUP3BfJnYllrELtzRfaRt5m/sw5cre88G8lsDnzUy
         SMDFhEXCcz9yC5rtCt81OawFeIL5d4eioh4uGawsFNDxh+HeRTrA5hWcJzamIcO+9KjD
         a7Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVyR42g71SiMG4Cqfp8CFfZUQ1JtKc/2IZgcv2zayEw=;
        b=PkvKGSifEVrEvjmToi3cMv51QisLcC1WVuh2FelaEpDES9Q9P7rWua0CjlrwbzC4lR
         dTd435oVvW2u50wiCJNhyu1Z8Jo9XcaG3hFuTWxZY5TG9Nlc6EdMoDZUURtjHxFHVO1N
         P6uIN8W99+qA25minIUPWoTlaWvFvxXcK+Yp9ugfT6zWcWd28JG5mzLL1wsSdZBJz1ua
         aCDp3g/IrAuAFttD0d6hqXkZBPZxvcpLrDElWjDa8J8m63UUYOuvULrrevdGw8psx0IJ
         hGykSyBWoANdcFfcTjligREQdvA71jPaQHCPjQ6L8juEBUcrPCI8tyZb4M+YUM1gtGZn
         +4aA==
X-Gm-Message-State: AJIora96gd/CLrktu+cPcQY2z/AdQe3D8o4WkJW144hNj774AVRXQCDp
        240icx9mXa6pyU41p3R7axN7cSowYRY=
X-Google-Smtp-Source: AGRyM1sb2L3at/0APQdodl9JXuuiqCHAGVqQL4aZCZ3wOtgie/67LeGJUyhTmZm3EuJtuwZjs77hDg==
X-Received: by 2002:a17:903:1111:b0:16a:acf4:e94e with SMTP id n17-20020a170903111100b0016aacf4e94emr38812372plh.59.1656995123674;
        Mon, 04 Jul 2022 21:25:23 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r3-20020a170903020300b0016a11b7472csm22015769plh.166.2022.07.04.21.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 21:25:23 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Ahern <dsahern@kernel.org>, toke@redhat.com,
        stephen@networkplumber.org, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next] libbpf: add xdp program name support
Date:   Tue,  5 Jul 2022 12:25:01 +0800
Message-Id: <20220705042501.187198-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bpf program, only the program name is unique. Before this patch, if there
are multiple programs with the same section name, only the first program
will be attached. With program name support, users could specify the exact
program they want to attach.

Note this feature is only supported when iproute2 build with libbpf.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 include/bpf_util.h    |  1 +
 ip/iplink.c           |  4 ++++
 lib/bpf_legacy.c      | 11 +++++++++--
 lib/bpf_libbpf.c      | 26 +++++++++++++++++++++++---
 man/man8/ip-link.8.in |  9 ++++++++-
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/bpf_util.h b/include/bpf_util.h
index abb96275..6a5f8ec6 100644
--- a/include/bpf_util.h
+++ b/include/bpf_util.h
@@ -68,6 +68,7 @@ enum bpf_mode {
 struct bpf_cfg_in {
 	const char *object;
 	const char *section;
+	const char *prog_name;
 	const char *uds;
 	enum bpf_prog_type type;
 	enum bpf_mode mode;
diff --git a/ip/iplink.c b/ip/iplink.c
index c64721bc..b98c1694 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -107,7 +107,11 @@ void iplink_usage(void)
 		"			 [ node_guid EUI64 ]\n"
 		"			 [ port_guid EUI64 ] ]\n"
 		"		[ { xdp | xdpgeneric | xdpdrv | xdpoffload } { off |\n"
+#ifdef HAVE_LIBBPF
+		"			  object FILE [ { section | program } NAME ] [ verbose ] |\n"
+#else
 		"			  object FILE [ section NAME ] [ verbose ] |\n"
+#endif
 		"			  pinned FILE } ]\n"
 		"		[ master DEVICE ][ vrf NAME ]\n"
 		"		[ nomaster ]\n"
diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 9bf7c1c4..4fabdcc8 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -831,7 +831,7 @@ static int bpf_obj_pinned(const char *pathname, enum bpf_prog_type type)
 
 static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 {
-	const char *file, *section, *uds_name;
+	const char *file, *section, *uds_name, *prog_name;
 	bool verbose = false;
 	int i, ret, argc;
 	char **argv;
@@ -862,7 +862,7 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	}
 
 	NEXT_ARG();
-	file = section = uds_name = NULL;
+	file = section = uds_name = prog_name = NULL;
 	if (cfg->mode == EBPF_OBJECT || cfg->mode == EBPF_PINNED) {
 		file = *argv;
 		NEXT_ARG_FWD();
@@ -899,6 +899,12 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 			NEXT_ARG_FWD();
 		}
 
+		if (argc > 0 && strcmp(*argv, "program") == 0) {
+			NEXT_ARG();
+			prog_name = *argv;
+			NEXT_ARG_FWD();
+		}
+
 		if (__bpf_prog_meta[cfg->type].may_uds_export) {
 			uds_name = getenv(BPF_ENV_UDS);
 			if (argc > 0 && !uds_name &&
@@ -936,6 +942,7 @@ static int bpf_do_parse(struct bpf_cfg_in *cfg, const bool *opt_tbl)
 	cfg->argc    = argc;
 	cfg->argv    = argv;
 	cfg->verbose = verbose;
+	cfg->prog_name = prog_name;
 
 	return ret;
 }
diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index 7b16ee71..e1c211a1 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -254,6 +254,22 @@ static bool bpf_map_is_offload_neutral(const struct bpf_map *map)
 	return bpf_map__type(map) == BPF_MAP_TYPE_PERF_EVENT_ARRAY;
 }
 
+static bool find_prog_to_attach(struct bpf_program *prog,
+				struct bpf_program *exist_prog,
+				const char *section, const char *prog_name)
+{
+	if (exist_prog)
+		return false;
+
+	/* We have default section name 'prog'. So do not check
+	 * section name if there already has program name.
+	 */
+	if (prog_name)
+		return !strcmp(bpf_program__name(prog), prog_name);
+	else
+		return !strcmp(get_bpf_program__section_name(prog), section);
+}
+
 static int load_bpf_object(struct bpf_cfg_in *cfg)
 {
 	struct bpf_program *p, *prog = NULL;
@@ -278,8 +294,9 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	}
 
 	bpf_object__for_each_program(p, obj) {
-		bool prog_to_attach = !prog && cfg->section &&
-			!strcmp(get_bpf_program__section_name(p), cfg->section);
+		bool prog_to_attach = find_prog_to_attach(p, prog,
+							  cfg->section,
+							  cfg->prog_name);
 
 		/* Only load the programs that will either be subsequently
 		 * attached or inserted into a tail call map */
@@ -304,7 +321,10 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
 	}
 
 	if (!prog) {
-		fprintf(stderr, "object file doesn't contain sec %s\n", cfg->section);
+		if (cfg->prog_name)
+			fprintf(stderr, "object file doesn't contain prog %s\n", cfg->prog_name);
+		else
+			fprintf(stderr, "object file doesn't contain sec %s\n", cfg->section);
 		return -ENOENT;
 	}
 
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 3dbcdbb6..c45c1062 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -149,7 +149,7 @@ ip-link \- network device configuration
 .in +8
 .BR object
 .IR FILE
-.RB "[ " section
+.RB "[ { " section " | " program " } "
 .IR NAME " ]"
 .RB "[ " verbose " ] |"
 .br
@@ -2342,6 +2342,13 @@ to be passed with the
 .B object
 option.
 
+.BI program " NAME "
+- Specifies the BPF program name that need to be attached. When the program
+name is specified, the section name parameter will be ignored. This option
+only works when iproute2 build with
+.B libbpf
+support.
+
 .BI verbose
 - Act in verbose mode. For example, even in case of success, this will
 print the verifier log in case a program was loaded from a BPF ELF file.
-- 
2.35.1

