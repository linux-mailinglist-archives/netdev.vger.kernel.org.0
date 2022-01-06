Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBB2486AC0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243517AbiAFT7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:59:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243518AbiAFT7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:59:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641499190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aoLaE9BXF9xi/RxYq35dBNB0Vrs2rbKVmjZLUTMCaBI=;
        b=UIYRmYfFebm/6Oyx8SfBpEGtHrR9xEHtayYYOihTpN3Evv7teTP0TIJgGXVr/u8NVVWG52
        t0oO2w7GypeIu0fCO8pHKM065TKM+1YPTR9Wko6FzxPeOJGYTREw8xZiIRkm/gxwPCPvNg
        RxH1dIopEuJFPE3cJ48jtLSPXJbh84U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-txzlk2xHPkqKUZvIgWxp5Q-1; Thu, 06 Jan 2022 14:59:49 -0500
X-MC-Unique: txzlk2xHPkqKUZvIgWxp5Q-1
Received: by mail-ed1-f70.google.com with SMTP id s7-20020a056402520700b003f841380832so2786194edd.5
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 11:59:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aoLaE9BXF9xi/RxYq35dBNB0Vrs2rbKVmjZLUTMCaBI=;
        b=o+3xu0OU3OTTMAwHEx84QY9a5x6lQK+7xWCRVY7l1OhuXTDjS2Vnrnw+QBeoXoWrT+
         wCKYRyw1UgghVOVvKGZvYL4Ox2iea8OJMUUkHi+Xu2rRnM7P0Ywk+DHsozC+8ytYyUaq
         XGoRi0sayQJ0B0PPJTQWLHQfC2ekIajDiVLSM9/TXrJ+bxnMI2jrHxw19Z6CToNQpSTD
         NSXU/63h5rZZgp+8d7fcofq7VMENu86Xv50TvaYKC5wo/xkFw4TW4mlwnELZedDIOAaf
         htYFkjRgzwLaFAhtaIjFpJEg4nrSHmV7OJQmmIAm/WX4c/9m1T8AP4K77X5k4Z8AKWWG
         MFkQ==
X-Gm-Message-State: AOAM531rzHtwQJfnXrhg4EkWmTVpVFcCTCK2hkrj8UxxqhWFDIx9OkI5
        cj+Ncw1i5bt/lL9pZFDup4+8fX6purem2DhKkv9pbzq5Y8cy29/Xw7tPk16UnhPwKzkE3cQPJY3
        /j0td9wqKcoaTKNG+
X-Received: by 2002:a17:906:6a90:: with SMTP id p16mr3577593ejr.115.1641499187330;
        Thu, 06 Jan 2022 11:59:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxDEOePU5d6dtGUXLefKuzIYupBdvXVDp+3tHdv3ItS1kLk1LB8Ohb2zOLSCTJC5xf0cYRSBw==
X-Received: by 2002:a17:906:6a90:: with SMTP id p16mr3577507ejr.115.1641499185134;
        Thu, 06 Jan 2022 11:59:45 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g16sm738652ejt.202.2022.01.06.11.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 11:59:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AE8EF181F2C; Thu,  6 Jan 2022 20:59:41 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v6 3/3] selftests/bpf: Add selftest for XDP_REDIRECT in bpf_prog_run()
Date:   Thu,  6 Jan 2022 20:59:38 +0100
Message-Id: <20220106195938.261184-4-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106195938.261184-1-toke@redhat.com>
References: <20220106195938.261184-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a selftest for the XDP_REDIRECT facility in bpf_prog_run, that
redirects packets into a veth and counts them using an XDP program on the
other side of the veth pair and a TC program on the local side of the veth.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../bpf/prog_tests/xdp_do_redirect.c          | 151 ++++++++++++++++++
 .../bpf/progs/test_xdp_do_redirect.c          |  78 +++++++++
 2 files changed, 229 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
new file mode 100644
index 000000000000..3789c380f24e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <net/if.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ipv6.h>
+#include <linux/in6.h>
+#include <linux/udp.h>
+#include <bpf/bpf_endian.h>
+#include "test_xdp_do_redirect.skel.h"
+
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto out;				\
+	})
+
+struct udp_packet {
+	struct ethhdr eth;
+	struct ipv6hdr iph;
+	struct udphdr udp;
+	__u8 payload[64 - sizeof(struct udphdr)
+		     - sizeof(struct ethhdr) - sizeof(struct ipv6hdr)];
+} __packed;
+
+static struct udp_packet pkt_udp = {
+	.eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
+	.eth.h_dest = {0x00, 0x11, 0x22, 0x33, 0x44, 0x55},
+	.eth.h_source = {0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb},
+	.iph.version = 6,
+	.iph.nexthdr = IPPROTO_UDP,
+	.iph.payload_len = bpf_htons(sizeof(struct udp_packet)
+				     - offsetof(struct udp_packet, udp)),
+	.iph.hop_limit = 2,
+	.iph.saddr.s6_addr16 = {bpf_htons(0xfc00), 0, 0, 0, 0, 0, 0, bpf_htons(1)},
+	.iph.daddr.s6_addr16 = {bpf_htons(0xfc00), 0, 0, 0, 0, 0, 0, bpf_htons(2)},
+	.udp.source = bpf_htons(1),
+	.udp.dest = bpf_htons(1),
+	.udp.len = bpf_htons(sizeof(struct udp_packet)
+			     - offsetof(struct udp_packet, udp)),
+	.payload = {0x42}, /* receiver XDP program matches on this */
+};
+
+static int attach_tc_prog(struct bpf_tc_hook *hook, int fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle = 1, .priority = 1, .prog_fd = fd);
+	int ret;
+
+	ret = bpf_tc_hook_create(hook);
+	if (!ASSERT_OK(ret, "create tc hook"))
+		return ret;
+
+	ret = bpf_tc_attach(hook, &opts);
+	if (!ASSERT_OK(ret, "bpf_tc_attach")) {
+		bpf_tc_hook_destroy(hook);
+		return ret;
+	}
+
+	return 0;
+}
+
+#define NUM_PKTS 10
+void test_xdp_do_redirect(void)
+{
+	int err, xdp_prog_fd, tc_prog_fd, ifindex_src, ifindex_dst;
+	char data[sizeof(pkt_udp) + sizeof(__u32)];
+	struct test_xdp_do_redirect *skel = NULL;
+	struct nstoken *nstoken = NULL;
+	struct bpf_link *link;
+
+	struct xdp_md ctx_in = { .data = sizeof(__u32),
+				 .data_end = sizeof(data) };
+	DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
+			    .data_in = &data,
+			    .data_size_in = sizeof(data),
+			    .ctx_in = &ctx_in,
+			    .ctx_size_in = sizeof(ctx_in),
+			    .flags = BPF_F_TEST_XDP_LIVE_FRAMES,
+			    .repeat = NUM_PKTS,
+		);
+	DECLARE_LIBBPF_OPTS(bpf_tc_hook, tc_hook,
+			    .attach_point = BPF_TC_INGRESS);
+
+	memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
+	*((__u32 *)data) = 0x42; /* metadata test value */
+
+	skel = test_xdp_do_redirect__open();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		return;
+
+	/* The XDP program we run with bpf_prog_run() will cycle through all
+	 * three xmit (PASS/TX/REDIRECT) return codes starting from above, and
+	 * ending up with PASS, so we should end up with two packets on the dst
+	 * iface and NUM_PKTS-2 in the TC hook. We match the packets on the UDP
+	 * payload.
+	 */
+	SYS("ip netns add testns");
+	nstoken = open_netns("testns");
+	if (!ASSERT_OK_PTR(nstoken, "setns"))
+		goto out;
+
+	SYS("ip link add veth_src type veth peer name veth_dst");
+	SYS("ip link set dev veth_src up");
+	SYS("ip link set dev veth_dst up");
+
+	ifindex_src = if_nametoindex("veth_src");
+	ifindex_dst = if_nametoindex("veth_dst");
+	if (!ASSERT_NEQ(ifindex_src, 0, "ifindex_src") ||
+	    !ASSERT_NEQ(ifindex_dst, 0, "ifindex_dst"))
+		goto out;
+
+	memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
+	skel->rodata->ifindex_out = ifindex_src; /* redirect back to the same iface */
+	skel->rodata->ifindex_in = ifindex_src;
+	ctx_in.ingress_ifindex = ifindex_src;
+	tc_hook.ifindex = ifindex_src;
+
+	if (!ASSERT_OK(test_xdp_do_redirect__load(skel), "load"))
+		goto out;
+
+	link = bpf_program__attach_xdp(skel->progs.xdp_count_pkts, ifindex_dst);
+	if (!ASSERT_OK_PTR(link, "prog_attach"))
+		goto out;
+	skel->links.xdp_count_pkts = link;
+
+	tc_prog_fd = bpf_program__fd(skel->progs.tc_count_pkts);
+	if (attach_tc_prog(&tc_hook, tc_prog_fd))
+		goto out;
+
+	xdp_prog_fd = bpf_program__fd(skel->progs.xdp_redirect);
+	err = bpf_prog_test_run_opts(xdp_prog_fd, &opts);
+	if (!ASSERT_OK(err, "prog_run"))
+		goto out_tc;
+
+	/* wait for the packets to be flushed */
+	kern_sync_rcu();
+
+	ASSERT_EQ(skel->bss->pkts_seen_xdp, 2, "pkt_count_xdp");
+	ASSERT_EQ(skel->bss->pkts_seen_tc, NUM_PKTS - 2, "pkt_count_tc");
+
+out_tc:
+	bpf_tc_hook_destroy(&tc_hook);
+out:
+	if (nstoken)
+		close_netns(nstoken);
+	system("ip netns del testns");
+	test_xdp_do_redirect__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
new file mode 100644
index 000000000000..cdb0ddb691c9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define ETH_ALEN 6
+const volatile int ifindex_out;
+const volatile int ifindex_in;
+const volatile __u8 expect_dst[ETH_ALEN];
+volatile int pkts_seen_xdp = 0;
+volatile int pkts_seen_tc = 0;
+volatile int retcode = XDP_REDIRECT;
+
+SEC("xdp")
+int xdp_redirect(struct xdp_md *xdp)
+{
+	__u32 *metadata = (void *)(long)xdp->data_meta;
+	void *data = (void *)(long)xdp->data;
+	int ret = retcode;
+
+	if (xdp->ingress_ifindex != ifindex_in)
+		return XDP_ABORTED;
+
+	if (metadata + 1 > data)
+		return XDP_ABORTED;
+
+	if (*metadata != 0x42)
+		return XDP_ABORTED;
+
+	if (bpf_xdp_adjust_meta(xdp, 4))
+		return XDP_ABORTED;
+
+	if (retcode > XDP_PASS)
+		retcode--;
+
+	if (ret == XDP_REDIRECT)
+		return bpf_redirect(ifindex_out, 0);
+
+	return ret;
+}
+
+static bool check_pkt(void *data, void *data_end)
+{
+	struct ethhdr *eth = data;
+	struct ipv6hdr *iph = (void *)(eth + 1);
+	struct udphdr *udp = (void *)(iph + 1);
+	__u8 *payload = (void *)(udp + 1);
+
+	if (payload + 1 > data_end)
+		return false;
+
+	return iph->nexthdr == IPPROTO_UDP && *payload == 0x42;
+}
+
+SEC("xdp")
+int xdp_count_pkts(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	void *data_end = (void *)(long)xdp->data_end;
+
+	if (check_pkt(data, data_end))
+		pkts_seen_xdp++;
+
+	return XDP_PASS;
+}
+
+SEC("tc")
+int tc_count_pkts(struct __sk_buff *skb)
+{
+	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(long)skb->data_end;
+
+	if (check_pkt(data, data_end))
+		pkts_seen_tc++;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

