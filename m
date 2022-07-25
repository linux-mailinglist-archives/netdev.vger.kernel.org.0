Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DB75800CA
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiGYOdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiGYOc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:32:59 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489D417A9F
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:58 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k11so15787209wrx.5
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xJRtKzZh4YAASphocIV+FMs7Bp3+I3tVnHMfvS4XvB8=;
        b=QEzXRXMq3fG3hJct4TYLUZr/WR+3yS2Fhn71EZ3vAHso2CfjKtoZ7ZVUQRLB6v0l6e
         um1zf++CFgAcCjJ3FjMwSeJJMV7GrJzeFJwDNaLyz072xweMKzqVsFYXLRtDJ5K7ykc1
         htJ3ImOIwmXntVVAuD4mbNEfvGv/9ZT+xCYoLF5q1ODARvdJqXGTGeGn2YkIVr9ZmPrr
         MIB3jeuKja3+9WZ4QYwibq1c7XyHmR7QghgfLC6H6C8h+xJgiCDn3LwqG6QSrpBL/RPD
         DCgHvZuol7PcLamOXdzcl0zIK1LCIwvMAqM0+NemaIH+bAT0y+T/Uxpjg7HZql5NtDdz
         BlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xJRtKzZh4YAASphocIV+FMs7Bp3+I3tVnHMfvS4XvB8=;
        b=dmZi48A44O/fD54klwgZEPEbHG9HWGROPWuJnt3k1+L9HLlWU1eHUgDhb5y4IH2yqH
         x6NLPXg3vQFjBy96PKiT8XQFxiFDka+uRd70Ynwzpfx2gNgoLlCAFTpeI133ZgE3B7ID
         Gx9XDgwGt56nP6YqC+8RhX7ATo0OCLMBNh1i39SDGxTUsAEIgxE1srn0oIJDaYNc91tl
         8FQu5dV112yCEwKEhTCwHSMQdSBHiY15y1EqHKTjQfXcul/RQl5xrWx/P9A2VVx+7fki
         mDk8xiLQMmad4okbatKjE0RJLwkFpPVacnzUFH0B+XTcHAKtGvHXFz+gohwnRA/qJ+BH
         kLBw==
X-Gm-Message-State: AJIora/p+wdZe5WhW2zO1W2W+KOwVTI4DaXZUzd/S/MEk+8r7nZ9wB+f
        4nqyYClK7tXfYE0WixtTmsS/
X-Google-Smtp-Source: AGRyM1sfGH32Ar/UiL1CH12pzb9Bkl48yS7kmzKcmSxd8BBKa+ya9fqXO+XtXy5V/Cz3OypxRutGCw==
X-Received: by 2002:a5d:64eb:0:b0:21d:75bb:a2f3 with SMTP id g11-20020a5d64eb000000b0021d75bba2f3mr8069597wri.118.1658759576553;
        Mon, 25 Jul 2022 07:32:56 -0700 (PDT)
Received: from Mem (pop.92-184-116-22.mobile.abo.orange.fr. [92.184.116.22])
        by smtp.gmail.com with ESMTPSA id q9-20020adfaa49000000b0021e7e050404sm7291871wrd.117.2022.07.25.07.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:32:56 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:32:53 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v3 5/5] selftests/bpf: Don't assign outer source IP
 to host
Message-ID: <4addde76eaf3477a58975bef15ed2788c44e5f55.1658759380.git.paul@isovalent.com>
References: <cover.1658759380.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1658759380.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit fixed a bug in the bpf_skb_set_tunnel_key helper to
avoid dropping packets whose outer source IP address isn't assigned to a
host interface. This commit changes the corresponding selftest to not
assign the outer source IP address to an interface.

Not assigning the source IP to an interface causes two issues in the
existing test:
1. The ARP requests will fail for that IP address so we need to add the
   ARP entry manually.
2. The encapsulated ICMP echo reply traffic will not reach the VXLAN
   device. It will be dropped by the stack before, because the
   outer destination IP is unknown.

To solve 2., we have two choices. Either we perform decapsulation
ourselves in a BPF program attached at veth1 (the base device for the
VXLAN device), or we switch the outer destination address when we
receive the packet at veth1, such that the stack properly demultiplexes
it to the VXLAN device afterward.

This commit implements the second approach, where we switch the outer
destination address from the unassigned IP address to the assigned one,
only for VXLAN traffic ingressing veth1.

Then, at the vxlan device, the BPF program that checks the output of
bpf_skb_get_tunnel_key needs to be updated as the expected local IP
address is now the unassigned one.

Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 .../selftests/bpf/prog_tests/test_tunnel.c    | 17 +++-
 .../selftests/bpf/progs/test_tunnel_kern.c    | 80 ++++++++++++++++---
 2 files changed, 86 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
index 3bba4a2a0530..eea274110267 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -82,6 +82,7 @@
 
 #define MAC_TUNL_DEV0 "52:54:00:d9:01:00"
 #define MAC_TUNL_DEV1 "52:54:00:d9:02:00"
+#define MAC_VETH1 "52:54:00:d9:03:00"
 
 #define VXLAN_TUNL_DEV0 "vxlan00"
 #define VXLAN_TUNL_DEV1 "vxlan11"
@@ -108,10 +109,9 @@
 static int config_device(void)
 {
 	SYS("ip netns add at_ns0");
-	SYS("ip link add veth0 type veth peer name veth1");
+	SYS("ip link add veth0 address " MAC_VETH1 " type veth peer name veth1");
 	SYS("ip link set veth0 netns at_ns0");
 	SYS("ip addr add " IP4_ADDR1_VETH1 "/24 dev veth1");
-	SYS("ip addr add " IP4_ADDR2_VETH1 "/24 dev veth1");
 	SYS("ip link set dev veth1 up mtu 1500");
 	SYS("ip netns exec at_ns0 ip addr add " IP4_ADDR_VETH0 "/24 dev veth0");
 	SYS("ip netns exec at_ns0 ip link set dev veth0 up mtu 1500");
@@ -140,6 +140,8 @@ static int add_vxlan_tunnel(void)
 	    VXLAN_TUNL_DEV0, IP4_ADDR_TUNL_DEV0);
 	SYS("ip netns exec at_ns0 ip neigh add %s lladdr %s dev %s",
 	    IP4_ADDR_TUNL_DEV1, MAC_TUNL_DEV1, VXLAN_TUNL_DEV0);
+	SYS("ip netns exec at_ns0 ip neigh add %s lladdr %s dev veth0",
+	    IP4_ADDR2_VETH1, MAC_VETH1);
 
 	/* root namespace */
 	SYS("ip link add dev %s type vxlan external gbp dstport 4789",
@@ -277,6 +279,17 @@ static void test_vxlan_tunnel(void)
 	if (attach_tc_prog(&tc_hook, get_src_prog_fd, set_src_prog_fd))
 		goto done;
 
+	/* load and attach bpf prog to veth dev tc hook point */
+	ifindex = if_nametoindex("veth1");
+	if (!ASSERT_NEQ(ifindex, 0, "veth1 ifindex"))
+		goto done;
+	tc_hook.ifindex = ifindex;
+	set_dst_prog_fd = bpf_program__fd(skel->progs.veth_set_outer_dst);
+	if (!ASSERT_GE(set_dst_prog_fd, 0, "bpf_program__fd"))
+		goto done;
+	if (attach_tc_prog(&tc_hook, set_dst_prog_fd, -1))
+		goto done;
+
 	/* load and attach prog set_md to tunnel dev tc hook point at_ns0 */
 	nstoken = open_netns("at_ns0");
 	if (!ASSERT_OK_PTR(nstoken, "setns src"))
diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index 17f2f325b3f3..df0673c4ecbe 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -14,15 +14,24 @@
 #include <linux/if_packet.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <linux/icmp.h>
 #include <linux/types.h>
 #include <linux/socket.h>
 #include <linux/pkt_cls.h>
 #include <linux/erspan.h>
+#include <linux/udp.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
 #define log_err(__ret) bpf_printk("ERROR line:%d ret:%d\n", __LINE__, __ret)
 
+#define VXLAN_UDP_PORT 4789
+
+/* Only IPv4 address assigned to veth1.
+ * 172.16.1.200
+ */
+#define ASSIGNED_ADDR_VETH1 0xac1001c8
+
 struct geneve_opt {
 	__be16	opt_class;
 	__u8	type;
@@ -33,6 +42,11 @@ struct geneve_opt {
 	__u8	opt_data[8]; /* hard-coded to 8 byte */
 };
 
+struct vxlanhdr {
+	__be32 vx_flags;
+	__be32 vx_vni;
+} __attribute__((packed));
+
 struct vxlan_metadata {
 	__u32     gbp;
 };
@@ -369,14 +383,8 @@ int vxlan_get_tunnel_src(struct __sk_buff *skb)
 	int ret;
 	struct bpf_tunnel_key key;
 	struct vxlan_metadata md;
+	__u32 orig_daddr;
 	__u32 index = 0;
-	__u32 *local_ip = NULL;
-
-	local_ip = bpf_map_lookup_elem(&local_ip_map, &index);
-	if (!local_ip) {
-		log_err(ret);
-		return TC_ACT_SHOT;
-	}
 
 	ret = bpf_skb_get_tunnel_key(skb, &key, sizeof(key), 0);
 	if (ret < 0) {
@@ -390,11 +398,10 @@ int vxlan_get_tunnel_src(struct __sk_buff *skb)
 		return TC_ACT_SHOT;
 	}
 
-	if (key.local_ipv4 != *local_ip || md.gbp != 0x800FF) {
+	if (key.local_ipv4 != ASSIGNED_ADDR_VETH1 || md.gbp != 0x800FF) {
 		bpf_printk("vxlan key %d local ip 0x%x remote ip 0x%x gbp 0x%x\n",
 			   key.tunnel_id, key.local_ipv4,
 			   key.remote_ipv4, md.gbp);
-		bpf_printk("local_ip 0x%x\n", *local_ip);
 		log_err(ret);
 		return TC_ACT_SHOT;
 	}
@@ -402,6 +409,61 @@ int vxlan_get_tunnel_src(struct __sk_buff *skb)
 	return TC_ACT_OK;
 }
 
+SEC("tc")
+int veth_set_outer_dst(struct __sk_buff *skb)
+{
+	struct ethhdr *eth = (struct ethhdr *)(long)skb->data;
+	__u32 assigned_ip = bpf_htonl(ASSIGNED_ADDR_VETH1);
+	void *data_end = (void *)(long)skb->data_end;
+	struct udphdr *udph;
+	struct iphdr *iph;
+	__u32 index = 0;
+	int ret = 0;
+	int shrink;
+	__s64 csum;
+
+	if ((void *)eth + sizeof(*eth) > data_end) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+
+	if (eth->h_proto != bpf_htons(ETH_P_IP))
+		return TC_ACT_OK;
+
+	iph = (struct iphdr *)(eth + 1);
+	if ((void *)iph + sizeof(*iph) > data_end) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+	if (iph->protocol != IPPROTO_UDP)
+		return TC_ACT_OK;
+
+	udph = (struct udphdr *)(iph + 1);
+	if ((void *)udph + sizeof(*udph) > data_end) {
+		log_err(ret);
+		return TC_ACT_SHOT;
+	}
+	if (udph->dest != bpf_htons(VXLAN_UDP_PORT))
+		return TC_ACT_OK;
+
+	if (iph->daddr != assigned_ip) {
+		csum = bpf_csum_diff(&iph->daddr, sizeof(__u32), &assigned_ip,
+				     sizeof(__u32), 0);
+		if (bpf_skb_store_bytes(skb, ETH_HLEN + offsetof(struct iphdr, daddr),
+					&assigned_ip, sizeof(__u32), 0) < 0) {
+			log_err(ret);
+			return TC_ACT_SHOT;
+		}
+		if (bpf_l3_csum_replace(skb, ETH_HLEN + offsetof(struct iphdr, check),
+					0, csum, 0) < 0) {
+			log_err(ret);
+			return TC_ACT_SHOT;
+		}
+		bpf_skb_change_type(skb, PACKET_HOST);
+	}
+	return TC_ACT_OK;
+}
+
 SEC("tc")
 int ip6vxlan_set_tunnel_dst(struct __sk_buff *skb)
 {
-- 
2.25.1

