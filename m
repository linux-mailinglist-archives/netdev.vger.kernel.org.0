Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E7E39495D
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhE1X4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhE1Xz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F200C061574;
        Fri, 28 May 2021 16:54:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id m190so3722592pga.2;
        Fri, 28 May 2021 16:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Lh4cjVXDCTKkenmqi16kX1wwtaby01C381mbKiAGCaw=;
        b=AHURk11A7mBZ2uA3w3VSsysAccDU/6Jpr5PJVMxIA3nWDGqBM5jVYKbRIar95YGtk+
         cOa2x/cGzhIN+klgKIH0T+/wNx1D1WHYfMyulpDa8OSwNISClh08gBUM4Equf5R81G2K
         PwWMHLADlLaU1Xj0myk4j1GWRHtj5PH5+fg2KbzNMwt4WEGrme9Fp29QEU5KHLWiwmXA
         JbPKxgQ8zlNjk0QHBitosCrpiJsiImMUmiRjd5LfefHgn2INJ7Wz1+/DUPULANRtmXNv
         O9knbWAlvX1zw+bfLs70R16yItxXcK7H9ZH+PUV9cwzvFapsKOkFgX52rrNLJR3I9Rjh
         rnRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Lh4cjVXDCTKkenmqi16kX1wwtaby01C381mbKiAGCaw=;
        b=nyMDAfnvq0M5dROhgz2tuZ/RxN9CqDA8M3/4/6HI8Sh30plAur35XJCY7y6rR8dpkq
         Sg1y+Tx0emdvvnFLO9TplBg1XnIgGpR1j4mHM5kpcyFhD6d+Hh235wScviWSEIsCDt8k
         UkjEyjXFjYi89jKgcMDTt8HiYTMOKrsJqrt7AAuIZLECUWXtNBlTLYJOKFsMZWaH1C7f
         2STDALL9eLivER6FNvo0i5/FfTRAjgFUR14jcBgybm+cmCKZxXTREUXcnGHpckDuzy+l
         teTg9nVKqGzQN4Kmqfhfg6rqhAKFgz3D/xn+xV+NzHsR3759drrnlSHm1f3Usc0Qweva
         q22A==
X-Gm-Message-State: AOAM530fX+iUg686LqxXr9s1ZENo+LRyIEhVcRg0HlAJ8ZdE0VSCwmxU
        jtQwmthSlrS5Po9lRxXC00DQKK/34PE=
X-Google-Smtp-Source: ABdhPJxb1UpMs4d1IKn5D8X3U6f3p76MOn7UEzZVxvZsBY0TjmzzZUuRz16mxPQnYDqX1ZipQ834pA==
X-Received: by 2002:a63:fc11:: with SMTP id j17mr11207453pgi.355.1622246061765;
        Fri, 28 May 2021 16:54:21 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id o6sm5305091pfb.126.2021.05.28.16.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:21 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 13/15] samples: bpf: add new options for xdp samples
Date:   Sat, 29 May 2021 05:22:48 +0530
Message-Id: <20210528235250.2635167-14-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are -i for polling interval and -v for verbose output by default.
Some of these tools already supported -s, but we now use that to enable
performance impacting success case reporting tracepoint. This is
disabled by default, but can be enabled explicitly by user.

Use separators (-z) is also dropped.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_monitor_user.c      | 16 ++++---
 samples/bpf/xdp_redirect_cpu_user.c | 41 ++++++++++++-----
 samples/bpf/xdp_redirect_map_user.c | 71 +++++++++++++++++++++++------
 3 files changed, 96 insertions(+), 32 deletions(-)

diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index 73d6d35f0c65..b37d8f7379ec 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -38,9 +38,10 @@ struct bpf_object *obj;
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
 	{"debug",	no_argument,		NULL, 'D' },
-	{"stats",	no_argument,		NULL, 'S' },
-	{"sec", 	required_argument,	NULL, 's' },
-	{0, 0, NULL,  0 }
+	{"stats",	no_argument,		NULL, 's' },
+	{"interval",	required_argument,	NULL, 'i' },
+	{"verbose",	no_argument,		NULL, 'v' },
+	{}
 };
 
 static void int_exit(int sig)
@@ -121,18 +122,21 @@ int main(int argc, char **argv)
 	int interval = 2;
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hDSs:",
+	while ((opt = getopt_long(argc, argv, "hDi:vs",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'D':
 			debug = true;
 			break;
-		case 'S':
+		case 's':
 			errors_only = false;
 			break;
-		case 's':
+		case 'i':
 			interval = atoi(optarg);
 			break;
+		case 'v':
+			sample_log_level ^= LL_DEBUG - 1;
+			break;
 		case 'h':
 		default:
 			usage(argv);
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 103ac5c24163..d56b89254cd1 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -42,19 +42,20 @@ static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
 	{"dev",		required_argument,	NULL, 'd' },
 	{"skb-mode",	no_argument,		NULL, 'S' },
-	{"sec",		required_argument,	NULL, 's' },
 	{"progname",	required_argument,	NULL, 'p' },
 	{"qsize",	required_argument,	NULL, 'q' },
 	{"cpu",		required_argument,	NULL, 'c' },
 	{"stress-mode", no_argument,		NULL, 'x' },
-	{"no-separators", no_argument,		NULL, 'z' },
 	{"force",	no_argument,		NULL, 'F' },
 	{"mprog-disable", no_argument,		NULL, 'n' },
 	{"mprog-name",	required_argument,	NULL, 'e' },
 	{"mprog-filename", required_argument,	NULL, 'f' },
 	{"redirect-device", required_argument,	NULL, 'r' },
 	{"redirect-map", required_argument,	NULL, 'm' },
-	{0, 0, NULL,  0 }
+	{"interval", required_argument,		NULL, 'i' },
+	{"verbose", no_argument,		NULL, 'v' },
+	{"stats", no_argument,			NULL, 's' },
+	{}
 };
 
 static void int_exit(int sig)
@@ -196,7 +197,7 @@ static void stress_cpumap(struct bpf_cpumap_val *value)
 	create_cpu_entry(1, value, 0, false);
 }
 
-static void __stats_poll(int interval, bool use_separators, char *prog_name,
+static void __stats_poll(int interval, bool redir_suc, char *prog_name,
 			 char *mprog_name, struct bpf_cpumap_val *value,
 			 bool stress_mode)
 {
@@ -210,8 +211,10 @@ static void __stats_poll(int interval, bool use_separators, char *prog_name,
 	sample_stats_collect(mask, record);
 
 	/* Trick to pretty printf with thousands separators use %' */
-	if (use_separators)
-		setlocale(LC_NUMERIC, "en_US");
+	setlocale(LC_NUMERIC, "en_US");
+
+	if (redir_suc)
+		mask |= SAMPLE_REDIRECT_CNT;
 
 	for (;;) {
 		struct timespec ots, nts;
@@ -298,12 +301,12 @@ int main(int argc, char **argv)
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	struct bpf_cpumap_val value;
-	bool use_separators = true;
 	bool stress_mode = false;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	int err = EXIT_FAIL;
 	char filename[256];
+	bool redir = false;
 	int added_cpus = 0;
 	int longindex = 0;
 	int interval = 2;
@@ -356,7 +359,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	while ((opt = getopt_long(argc, argv, "hSd:sp:q:c:xi:vFf:e:r:m:",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
@@ -375,6 +378,9 @@ int main(int argc, char **argv)
 			}
 			break;
 		case 's':
+			redir = true;
+			break;
+		case 'i':
 			interval = atoi(optarg);
 			break;
 		case 'S':
@@ -383,9 +389,6 @@ int main(int argc, char **argv)
 		case 'x':
 			stress_mode = true;
 			break;
-		case 'z':
-			use_separators = false;
-			break;
 		case 'p':
 			/* Selecting eBPF prog to load */
 			prog_name = optarg;
@@ -422,6 +425,9 @@ int main(int argc, char **argv)
 		case 'F':
 			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
 			break;
+		case 'v':
+			sample_log_level ^= LL_DEBUG - 1;
+			break;
 		case 'h':
 		error:
 		default:
@@ -492,7 +498,18 @@ int main(int argc, char **argv)
 	}
 	prog_id = info.id;
 
-	__stats_poll(interval, use_separators, prog_name, mprog_name,
+	if (!redir) {
+		/* The bpf_link[i] depend on the order of
+		 * the functions was defined in _kern.c
+		 */
+		bpf_link__destroy(tp_links[2]);	/* tracepoint/xdp/xdp_redirect */
+		tp_links[2] = NULL;
+
+		bpf_link__destroy(tp_links[3]);	/* tracepoint/xdp/xdp_redirect_map */
+		tp_links[3] = NULL;
+	}
+
+	__stats_poll(interval, redir, prog_name, mprog_name,
 		     &value, stress_mode);
 
 	err = EXIT_OK;
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index ed53dd2cd93a..eb4013fa58cb 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -13,6 +13,7 @@
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
+#include <getopt.h>
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
@@ -28,6 +29,18 @@ static __u32 dummy_prog_id;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 
+static const struct option long_options[] = {
+	{"help",	no_argument,		NULL, 'h' },
+	{"skb-mode",	no_argument,		NULL, 'S' },
+	{"native-mode", no_argument,		NULL, 'N' },
+	{"force",	no_argument,		NULL, 'F' },
+	{"load-egress", no_argument,		NULL, 'X' },
+	{"stats",	no_argument,		NULL, 's' },
+	{"interval",	required_argument,	NULL, 'i' },
+	{"verbose",	no_argument,		NULL, 'v' },
+	{}
+};
+
 static void int_exit(int sig)
 {
 	__u32 curr_prog_id = 0;
@@ -61,16 +74,25 @@ static void int_exit(int sig)
 	sample_exit(EXIT_OK);
 }
 
-static void usage(const char *prog)
+static void usage(char *argv[])
 {
-	fprintf(stderr,
-		"usage: %s [OPTS] <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n\n"
-		"OPTS:\n"
-		"    -S    use skb-mode\n"
-		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n"
-		"    -X    load xdp program on egress\n",
-		prog);
+	int i;
+
+	printf("\n");
+	printf(" Usage: %s (options-see-below)\n",
+	       argv[0]);
+	printf(" Listing options:\n");
+	for (i = 0; long_options[i].name != 0; i++) {
+		printf(" --%-15s", long_options[i].name);
+		if (long_options[i].flag != NULL)
+			printf(" flag (internal value:%d)",
+			       *long_options[i].flag);
+		else
+			printf("short-option: -%c",
+			       long_options[i].val);
+		printf("\n");
+	}
+	printf("\n");
 }
 
 int main(int argc, char **argv)
@@ -88,13 +110,14 @@ int main(int argc, char **argv)
 	char str[2 * IF_NAMESIZE + 1];
 	__u32 info_len = sizeof(info);
 	char ifname_out[IF_NAMESIZE];
-	const char *optstr = "FSNX";
 	char ifname_in[IF_NAMESIZE];
 	struct bpf_object *obj;
 	int ret, opt, key = 0;
 	char filename[256];
+	int interval = 2;
 
-	while ((opt = getopt(argc, argv, optstr)) != -1) {
+	while ((opt = getopt_long(argc, argv, "FSNXi:vs",
+				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
 			xdp_flags |= XDP_FLAGS_SKB_MODE;
@@ -108,8 +131,17 @@ int main(int argc, char **argv)
 		case 'X':
 			xdp_devmap_attached = true;
 			break;
+		case 'i':
+			interval = atoi(optarg);
+			break;
+		case 'v':
+			sample_log_level ^= LL_DEBUG - 1;
+			break;
+		case 's':
+			mask |= SAMPLE_REDIRECT_MAP_CNT;
+			break;
 		default:
-			usage(basename(argv[0]));
+			usage(argv);
 			return 1;
 		}
 	}
@@ -122,7 +154,7 @@ int main(int argc, char **argv)
 	}
 
 	if (argc <= optind + 1) {
-		usage(basename(argv[0]));
+		usage(argv);
 		return 1;
 	}
 
@@ -252,9 +284,20 @@ int main(int argc, char **argv)
 	       ifname_in, ifindex_in, str, ifname_out, ifindex_out,
 	       get_driver_name(ifindex_out) ?: "(err)");
 
+	if ((mask & SAMPLE_REDIRECT_CNT) == 0) {
+		/* The bpf_link[i] depend on the order of
+		 * the functions was defined in _kern.c
+		 */
+		bpf_link__destroy(tp_links[2]);	/* tracepoint/xdp/xdp_redirect */
+		tp_links[2] = NULL;
+
+		bpf_link__destroy(tp_links[3]);	/* tracepoint/xdp/xdp_redirect_map */
+		tp_links[3] = NULL;
+	}
+
 	snprintf(str, sizeof(str), "%s->%s", ifname_in, ifname_out);
 
-	sample_stats_poll(1, mask, str, true);
+	sample_stats_poll(interval, mask, str, true);
 
 	return 0;
 
-- 
2.31.1

