Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5FC4CEE32
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 23:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbiCFWfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 17:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234370AbiCFWfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 17:35:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C59F45ACC
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 14:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646606054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=obAgtHC8PNa/dlwOtD8Z+tCM7YnU2u+ax6BodzM+0nY=;
        b=Qsh/FAf5qfh5FXzBs/JM+1pdiWcCvkjYz0WVNPGRgxlay2RMOkPHV4vdFFTwAtO3JG14q0
        kGdq3zexUGuOcP2XPoUJd43+WN5+TA6XMTtfHJddYnB4osjMXAjdY45BcIlMNLEO7sFXZc
        LWQ8DEit3yliHk+BTe/+CvmI3H1LJuw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-bO5Ne2snMiGShzTOP3aosQ-1; Sun, 06 Mar 2022 17:34:13 -0500
X-MC-Unique: bO5Ne2snMiGShzTOP3aosQ-1
Received: by mail-ed1-f70.google.com with SMTP id da28-20020a056402177c00b00415ce4b20baso6521685edb.17
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 14:34:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=obAgtHC8PNa/dlwOtD8Z+tCM7YnU2u+ax6BodzM+0nY=;
        b=P72lUaj9xX20sZREFdbF9WtGGP5VZj8adNFfF/x7IiQzASFtXc9lL51h89+5X5qrrB
         g2kBOI0FwNQEqqZIA7BgshlCsLe7u0FOHpdObvUITDrxRW1jMkO4dY9X/1d81WzxW+KY
         v2hbxSblf1cCaSXND1EssTDj/4ifb9UfrW1WnpL4o+yb9lN3afM1K5PRyuwq0JSi7nJk
         WRTbeEfuFDffgY8r0EqkpG1prNdRSTrJ9xDQQ+UnimmtCu4wVHtbQtE9tCcHkIQ8gnzH
         /l8iQ/Af/nT1XNH9Rf0VTAZhBLFXKOOlusRDekGLsOws6zbcG2/uEYztUoFBVNg6Egz0
         6TqA==
X-Gm-Message-State: AOAM533FMhHrXqdmwPskGY7XqO+IstSqM//wHDjXRZ5AdE+DgqNAeZ7G
        9QnTxSkqZN/wxj/gLfC4lDihdeI9UBC2yXWdQMajWjYYkm9EKVE8JZm2FtCqpIGqXzCRoAHp+vh
        Lo9jjQ5EJPNAh/hjm
X-Received: by 2002:a05:6402:5304:b0:413:8a0c:c54a with SMTP id eo4-20020a056402530400b004138a0cc54amr8467704edb.172.1646606051509;
        Sun, 06 Mar 2022 14:34:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGX8OCNLb9G8ImXccJ6oUKz4acyj6OEiqqgrZ3rYR6p9cAgsG51PVm+YBL6E7rz/4YvZAHtg==
X-Received: by 2002:a05:6402:5304:b0:413:8a0c:c54a with SMTP id eo4-20020a056402530400b004138a0cc54amr8467676edb.172.1646606051047;
        Sun, 06 Mar 2022 14:34:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g2-20020aa7c842000000b0041314b98872sm5244176edt.22.2022.03.06.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 14:34:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B2590131DF5; Sun,  6 Mar 2022 23:34:08 +0100 (CET)
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
Subject: [PATCH bpf-next v9 5/5] selftests/bpf: Add selftest for XDP_REDIRECT in BPF_PROG_RUN
Date:   Sun,  6 Mar 2022 23:34:04 +0100
Message-Id: <20220306223404.60170-6-toke@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220306223404.60170-1-toke@redhat.com>
References: <20220306223404.60170-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a selftest for the XDP_REDIRECT facility in BPF_PROG_RUN, that
redirects packets into a veth and counts them using an XDP program on the
other side of the veth pair and a TC program on the local side of the veth.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../bpf/prog_tests/xdp_do_redirect.c          | 176 ++++++++++++++++++
 .../bpf/progs/test_xdp_do_redirect.c          |  92 +++++++++
 2 files changed, 268 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
new file mode 100644
index 000000000000..9024bb24c204
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -0,0 +1,176 @@
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
+#define NUM_PKTS 1000000
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
+			    .batch_size = 64,
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
+	SYS("ip link set dev veth_src address 00:11:22:33:44:55");
+	SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
+	SYS("ip link set dev veth_src up");
+	SYS("ip link set dev veth_dst up");
+	SYS("ip addr add dev veth_src fc00::1/64");
+	SYS("ip addr add dev veth_dst fc00::2/64");
+	SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb");
+
+	/* We enable forwarding in the test namespace because that will cause
+	 * the packets that go through the kernel stack (with XDP_PASS) to be
+	 * forwarded back out the same interface (because of the packet dst
+	 * combined with the interface addresses). When this happens, the
+	 * regular forwarding path will end up going through the same
+	 * veth_xdp_xmit() call as the XDP_REDIRECT code, which can cause a
+	 * deadlock if it happens on the same CPU. There's a local_bh_disable()
+	 * in the test_run code to prevent this, but an earlier version of the
+	 * code didn't have this, so we keep the test behaviour to make sure the
+	 * bug doesn't resurface.
+	 */
+	SYS("sysctl -qw net.ipv6.conf.all.forwarding=1");
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
+	/* There will be one packet sent through XDP_REDIRECT and one through
+	 * XDP_TX; these will show up on the XDP counting program, while the
+	 * rest will be counted at the TC ingress hook (and the counting program
+	 * resets the packet payload so they don't get counted twice even though
+	 * they are re-xmited out the veth device
+	 */
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
index 000000000000..d785f48304ea
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define ETH_ALEN 6
+#define HDR_SZ (sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + sizeof(struct udphdr))
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
+	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(long)xdp->data;
+
+	__u8 *payload = data + HDR_SZ;
+	int ret = retcode;
+
+	if (payload + 1 > data_end)
+		return XDP_ABORTED;
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
+	*payload = 0x42;
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
+	struct ipv6hdr *iph = data + sizeof(struct ethhdr);
+	__u8 *payload = data + HDR_SZ;
+
+	if (payload + 1 > data_end)
+		return false;
+
+	if (iph->nexthdr != IPPROTO_UDP || *payload != 0x42)
+		return false;
+
+	/* reset the payload so the same packet doesn't get counted twice when
+	 * it cycles back through the kernel path and out the dst veth
+	 */
+	*payload = 0;
+	return true;
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
+	return XDP_DROP;
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
2.35.1

