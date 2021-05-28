Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D1039494D
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhE1Xze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhE1Xza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:55:30 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBF0C061574;
        Fri, 28 May 2021 16:53:54 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id j12so3699035pgh.7;
        Fri, 28 May 2021 16:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eo+mNprptPl7srpNm0OMmFfBSNsoaoCtntagOadHIHQ=;
        b=Z0PPNl2UeIx7fncayz/zJQk3p5eqzRoCGOzlwi4NTJWgsUjcU6ftgwVA7eBNsVnGpZ
         icMjeveAq/k1ZNaZRod0N+EkGwnWA/UrD3zF0r5incCQfj1rNnbwXKz4/tObSutVOmw+
         M+vrgdOJ+jx/KSQBa8+kb+TeqQQ8ErTHedifVVhcgbGD9lLD8NBcE1zD7cr6Hu/WCgff
         A/ZLUz9a0/0jkJqVdkFo/FA+IIhn57w0YfqtiBjq2uGwDllODmOmGLOgY4iACI6eHRhi
         lMJsZz6Mw6Eq5AqClgNt1uANaV5ZtBVoOyd8O+tFDEv7P9IDOdHqe0EfYXvjnze6WUwz
         NHRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eo+mNprptPl7srpNm0OMmFfBSNsoaoCtntagOadHIHQ=;
        b=cYkN5ds5LlFFVG5YGAQywZugN0mtgLl2UhUYoO085HpZBzMFxJqtyOwveG5XNmi2/D
         ptPkPAs2H+RZ/Swd07vzVPstRU0dc9EisCsTVNXzue4MnDJcEWuSSH9Mmp/aCGU2OgGn
         Aps0sCb29C5saeIwVYWk7sAMzxOmvDwFD9vc9cvNp8CTKEBbSmJSzraCayEPC5yWWwBw
         oqgGpEmNI4G72nHVh4E/4L7TmUz56JQRDm+PhuaXvGzIqHktsybRSEylG4x8M7jy42Mu
         E0qKFC+cVAYCiLSal7gjWRtLz08jllnmt7k3y1MWvODLUINIf+S9JozaaYeEq+Q6AfjF
         S1aw==
X-Gm-Message-State: AOAM5313FKSfpiiUVrwlXnGf1whAqWAQgjgR/Bje2zN2DfX/Gr8LdQ+5
        YDkEyzZslEqhzm+zg3bi9tTi+5vTmkA=
X-Google-Smtp-Source: ABdhPJwpPa3Tnjfr7PH9HrVwL8HXIOO/5T5vKRALoN+LCGhxb/BPekgB2t7Xf+yg/QByhOlA7d/3pA==
X-Received: by 2002:a63:e709:: with SMTP id b9mr11398198pgi.153.1622246033625;
        Fri, 28 May 2021 16:53:53 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id f9sm4890398pfc.42.2021.05.28.16.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:53:53 -0700 (PDT)
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
Subject: [PATCH RFC bpf-next 05/15] samples: bpf: convert xdp_redirect_map to use xdp_samples
Date:   Sat, 29 May 2021 05:22:40 +0530
Message-Id: <20210528235250.2635167-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This uses the xdp_sample_* reorg we did in the past commits to report
more statistics than just the per second packet count.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                |  2 +-
 samples/bpf/xdp_redirect_map_kern.c | 23 +++----
 samples/bpf/xdp_redirect_map_user.c | 96 +++++++++++------------------
 3 files changed, 44 insertions(+), 77 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index c0c02e12e28b..ea7100c8b760 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -99,8 +99,8 @@ xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
-xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
+xdp_redirect_map-objs := xdp_redirect_map_user.o xdp_sample_user.o
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o xdp_sample_user.o
 xdp_monitor-objs := xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
index a92b8e567bdd..cf8b8f6d15da 100644
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map_kern.c
@@ -19,6 +19,8 @@
 #include <linux/ipv6.h>
 #include <bpf/bpf_helpers.h>
 
+#include "xdp_sample_kern.h"
+
 /* The 2nd xdp prog on egress does not support skb mode, so we define two
  * maps, tx_port_general and tx_port_native.
  */
@@ -36,16 +38,6 @@ struct {
 	__uint(max_entries, 100);
 } tx_port_native SEC(".maps");
 
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, long);
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
 /* map to store egress interface mac address */
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
@@ -75,7 +67,7 @@ static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_m
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data = (void *)(long)ctx->data;
 	struct ethhdr *eth = data;
-	int rc = XDP_DROP;
+	struct datarec *rec;
 	long *value;
 	u32 key = 0;
 	u64 nh_off;
@@ -83,15 +75,16 @@ static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_m
 
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
-		return rc;
+		return XDP_DROP;
 
 	/* constant virtual port */
 	vport = 0;
 
 	/* count packet in global counter */
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (!rec)
+		return XDP_ABORTED;
+	rec->processed++;
 
 	swap_src_dst_mac(data);
 
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index ad3cdc4c07d3..42893385ba96 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -13,15 +13,11 @@
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
-#include <sys/ioctl.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
 
 #include "bpf_util.h"
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include "xdp_sample_user.h"
 
 static int ifindex_in;
 static int ifindex_out;
@@ -31,7 +27,6 @@ static __u32 prog_id;
 static __u32 dummy_prog_id;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static int rxcnt_map_fd;
 
 static void int_exit(int sig)
 {
@@ -62,56 +57,8 @@ static void int_exit(int sig)
 		else
 			printf("program on iface OUT changed, not removing\n");
 	}
-	exit(0);
-}
 
-static void poll_stats(int interval, int ifindex)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	__u64 values[nr_cpus], prev[nr_cpus];
-
-	memset(prev, 0, sizeof(prev));
-
-	while (1) {
-		__u64 sum = 0;
-		__u32 key = 0;
-		int i;
-
-		sleep(interval);
-		assert(bpf_map_lookup_elem(rxcnt_map_fd, &key, values) == 0);
-		for (i = 0; i < nr_cpus; i++)
-			sum += (values[i] - prev[i]);
-		if (sum)
-			printf("ifindex %i: %10llu pkt/s\n",
-			       ifindex, sum / interval);
-		memcpy(prev, values, sizeof(values));
-	}
-}
-
-static int get_mac_addr(unsigned int ifindex_out, void *mac_addr)
-{
-	char ifname[IF_NAMESIZE];
-	struct ifreq ifr;
-	int fd, ret = -1;
-
-	fd = socket(AF_INET, SOCK_DGRAM, 0);
-	if (fd < 0)
-		return ret;
-
-	if (!if_indextoname(ifindex_out, ifname))
-		goto err_out;
-
-	strcpy(ifr.ifr_name, ifname);
-
-	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
-		goto err_out;
-
-	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
-	ret = 0;
-
-err_out:
-	close(fd);
-	return ret;
+	sample_exit(EXIT_OK);
 }
 
 static void usage(const char *prog)
@@ -128,6 +75,8 @@ static void usage(const char *prog)
 
 int main(int argc, char **argv)
 {
+	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
+		   SAMPLE_EXCEPTION_CNT;
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
@@ -136,8 +85,11 @@ int main(int argc, char **argv)
 	int tx_port_map_fd, tx_mac_map_fd;
 	struct bpf_devmap_val devmap_val;
 	struct bpf_prog_info info = {};
+	char str[2 * IF_NAMESIZE + 1];
 	__u32 info_len = sizeof(info);
+	char ifname_out[IF_NAMESIZE];
 	const char *optstr = "FSNX";
+	char ifname_in[IF_NAMESIZE];
 	struct bpf_object *obj;
 	int ret, opt, key = 0;
 	char filename[256];
@@ -182,14 +134,17 @@ int main(int argc, char **argv)
 	if (!ifindex_out)
 		ifindex_out = strtoul(argv[optind + 1], NULL, 0);
 
-	printf("input: %d output: %d\n", ifindex_in, ifindex_out);
-
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 	prog_load_attr.file = filename;
 
 	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
 		return 1;
 
+	if (sample_init(obj) < 0) {
+		fprintf(stderr, "Failed to initialize sample\n");
+		return 1;
+	}
+
 	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
 		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_general");
 		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
@@ -210,8 +165,7 @@ int main(int argc, char **argv)
 	}
 
 	tx_mac_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_mac");
-	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (tx_mac_map_fd < 0 || rxcnt_map_fd < 0) {
+	if (tx_mac_map_fd < 0) {
 		printf("bpf_object__find_map_fd_by_name failed\n");
 		return 1;
 	}
@@ -281,8 +235,28 @@ int main(int argc, char **argv)
 		goto out;
 	}
 
-	poll_stats(2, ifindex_out);
+	if (!if_indextoname(ifindex_in, ifname_in)) {
+		perror("if_nametoindex");
+		goto out;
+	}
+
+	if (!if_indextoname(ifindex_out, ifname_out)) {
+		perror("if_nametoindex");
+		goto out;
+	}
+
+	strncpy(str, get_driver_name(ifindex_in) ?: "(err)", sizeof(str));
+
+	printf("Redirecting from %s (ifindex %d; driver %s) to %s (ifindex %d; driver %s)\n",
+	       ifname_in, ifindex_in, str, ifname_out, ifindex_out,
+	       get_driver_name(ifindex_out) ?: "(err)");
+
+	snprintf(str, sizeof(str), "%s->%s", ifname_in, ifname_out);
+
+	sample_stats_poll(1, mask, str, true);
 
-out:
 	return 0;
+
+out:
+	return 1;
 }
-- 
2.31.1

