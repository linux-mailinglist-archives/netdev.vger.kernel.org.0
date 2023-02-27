Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D403B6A4BA5
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjB0Twn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjB0Twi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:52:38 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B6528862;
        Mon, 27 Feb 2023 11:52:08 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 3A8BB32000CC;
        Mon, 27 Feb 2023 14:52:07 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 27 Feb 2023 14:52:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1677527526; x=1677613926; bh=vq
        OPrU2USs/DBPvfuObiynBOOBEeIGTPg/9yydmeqQo=; b=Z4tJwqYA3DJV7CLlHF
        7zSwAocfWfQRFbAqGuQoL5985PQMS5/0JARZfs3EXUuR9aFTrdRXq1Oo/NG0TQ0h
        X6eiWPj4ZSjaDnO2Ki7LDkbpTOjP8iezX6lptw/qMQ9l9UxVj82lzaLTubx+cIGS
        bCxCqpNoDAoTzwhJNXOCZK8L1i1BbGA16brgEWyvtimafxgXqqqLVYwqMjssjyef
        KJ27IJld+I/yiF61lRbOvSG18Xi/ZBZJO4kgLMVr9j821R9peqyuEwipqQda5XjY
        LHw8MxV7ra+m048qp/aNJcrAmk/yZY0GUa1H05nza1/EvNy6vtPuYdMK61DhaQev
        NKsA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1677527526; x=1677613926; bh=vqOPrU2USs/DB
        PvfuObiynBOOBEeIGTPg/9yydmeqQo=; b=AkgaaiB3NcAsUn39bFP5FEK1KYKtC
        0Srry3tuLsNTT5VGRt1UTw4FCSDipnYaCv5P5amMz8xm/2OvxBy+FsFk49V4roT+
        1O+yYA+1wq56WMAt15gQtE4nsLQOliDgft2FArQBC0L/hGnsaIDgTBliSKUOlPou
        Odw+LxCoze55Yk5df+46TxmmsnRrdJ8Jc/5gqgsKWDS4q3PNxl8esSGhEIVvxWq+
        TpWfAawj/osjSm3h2378povMNUjEIL3JBg/kuDx/QL64FpkDdUYESdR9nZYaedKc
        39G2JmkkOwICZWEGigQ3mJiSCrMmXplQg827LBJDP32Sg++p/fACDnxZQ==
X-ME-Sender: <xms:5gn9Y111kAbp_CGwuTMvEE_hKbPP6hkzUGH0BD9GeDF4CEz6QJjiFw>
    <xme:5gn9Y8GipbSJeogOuitI2W4X_HztM0xtPhOxqMsb6juByNB99t1FP4btiobOF7E4p
    rMYsyGUiruLt2HrJA>
X-ME-Received: <xmr:5gn9Y14KDBrivMivyifThXh6dREedEEUjWyiZE_aKNmbIQkeA1ab6VWQXeYEzI45-xMKAHw7ArNp3DxmihaPS_UTh2F0hcUUli0OOLX1pfmRQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:5gn9Yy1K_D806yHIiiMgXGqp2Dy1YyiClVQ8Tl4usrxEmNM9PYpfVg>
    <xmx:5gn9Y4HHz4xvMbH_H8cGAGVemo186rIgeCs_cVYi9k4mtDT9RAFnrw>
    <xmx:5gn9Yz90iOu3h61Bn27CdaI9CoeOJF1gYEOHG6s4B_wllOchwXz6OA>
    <xmx:5gn9Y97rKYWRskIXFLEDSChKWCI8yLBLijsf9YcEIonxeIM97hBj2g>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Feb 2023 14:52:05 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 5/8] bpf: net: ipv6: Add bpf_ipv6_frag_rcv() kfunc
Date:   Mon, 27 Feb 2023 12:51:07 -0700
Message-Id: <bce083a4293eefb048a700b5a6086e8d8c957700.1677526810.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677526810.git.dxu@dxuuu.xyz>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper is used to defragment IPv6 packets. Similar to the previous
bpf_ip_check_defrag() kfunc, this kfunc:

* Returns 0 on defrag + skb update success
* Returns < 0 on error
* Takes care to ensure ctx (skb) remains valid no matter what the
  underlying call to _ipv6_frag_rcv() does
* Is only callable from TC clsact progs

Please see bpf_ip_check_defrag() commit for more details / suggestions.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/ipv6_frag.h   |   1 +
 include/net/transp_v6.h   |   1 +
 net/ipv6/Makefile         |   1 +
 net/ipv6/af_inet6.c       |   4 ++
 net/ipv6/reassembly_bpf.c | 143 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 150 insertions(+)
 create mode 100644 net/ipv6/reassembly_bpf.c

diff --git a/include/net/ipv6_frag.h b/include/net/ipv6_frag.h
index 7321ffe3a108..cf4763cd3886 100644
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -15,6 +15,7 @@ enum ip6_defrag_users {
 	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
 	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
 	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
+	IP6_DEFRAG_BPF,
 };
 
 /*
diff --git a/include/net/transp_v6.h b/include/net/transp_v6.h
index d27b1caf3753..244123a74349 100644
--- a/include/net/transp_v6.h
+++ b/include/net/transp_v6.h
@@ -20,6 +20,7 @@ int ipv6_exthdrs_init(void);
 void ipv6_exthdrs_exit(void);
 int ipv6_frag_init(void);
 void ipv6_frag_exit(void);
+int register_ipv6_reassembly_bpf(void);
 
 /* transport protocols */
 int pingv6_init(void);
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 3036a45e8a1e..6e90ff1d20c0 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -26,6 +26,7 @@ ipv6-$(CONFIG_IPV6_SEG6_LWTUNNEL) += seg6_iptunnel.o seg6_local.o
 ipv6-$(CONFIG_IPV6_SEG6_HMAC) += seg6_hmac.o
 ipv6-$(CONFIG_IPV6_RPL_LWTUNNEL) += rpl_iptunnel.o
 ipv6-$(CONFIG_IPV6_IOAM6_LWTUNNEL) += ioam6_iptunnel.o
+ipv6-$(CONFIG_DEBUG_INFO_BTF) += reassembly_bpf.o
 
 obj-$(CONFIG_INET6_AH) += ah6.o
 obj-$(CONFIG_INET6_ESP) += esp6.o
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 38689bedfce7..39663de75fbd 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1174,6 +1174,10 @@ static int __init inet6_init(void)
 	if (err)
 		goto ipv6_frag_fail;
 
+	err = register_ipv6_reassembly_bpf();
+	if (err)
+		goto ipv6_frag_fail;
+
 	/* Init v6 transport protocols. */
 	err = udpv6_init();
 	if (err)
diff --git a/net/ipv6/reassembly_bpf.c b/net/ipv6/reassembly_bpf.c
new file mode 100644
index 000000000000..c6c804d4f636
--- /dev/null
+++ b/net/ipv6/reassembly_bpf.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Unstable ipv6 fragmentation helpers for TC-BPF hook
+ *
+ * These are called from SCHED_CLS BPF programs. Note that it is allowed to
+ * break compatibility for these functions since the interface they are exposed
+ * through to BPF programs is explicitly unstable.
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/filter.h>
+#include <linux/netdevice.h>
+#include <net/ipv6.h>
+#include <net/ipv6_frag.h>
+#include <net/ipv6_stubs.h>
+
+static int set_dst(struct sk_buff *skb, struct net *net)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct dst_entry *dst;
+
+	struct flowi6 fl6 = {
+		.flowi6_flags = FLOWI_FLAG_ANYSRC,
+		.flowi6_mark  = skb->mark,
+		.flowlabel    = ip6_flowinfo(ip6h),
+		.flowi6_iif   = skb->skb_iif,
+		.flowi6_proto = ip6h->nexthdr,
+		.daddr	      = ip6h->daddr,
+		.saddr	      = ip6h->saddr,
+	};
+
+	dst = ipv6_stub->ipv6_dst_lookup_flow(net, NULL, &fl6, NULL);
+	if (IS_ERR(dst))
+		return PTR_ERR(dst);
+
+	skb_dst_set(skb, dst);
+
+	return 0;
+}
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in reassembly BTF");
+
+/* bpf_ipv6_frag_rcv - Defragment an ipv6 packet
+ *
+ * This helper takes an skb as input. If this skb successfully reassembles
+ * the original packet, the skb is updated to contain the original, reassembled
+ * packet.
+ *
+ * Otherwise (on error or incomplete reassembly), the input skb remains
+ * unmodified.
+ *
+ * Parameters:
+ * @ctx		- Pointer to program context (skb)
+ * @netns	- Child network namespace id. If value is a negative signed
+ *		  32-bit integer, the netns of the device in the skb is used.
+ *
+ * Return:
+ * 0 on successfully reassembly or non-fragmented packet. Negative value on
+ * error or incomplete reassembly.
+ */
+int bpf_ipv6_frag_rcv(struct __sk_buff *ctx, u64 netns)
+{
+	struct sk_buff *skb = (struct sk_buff *)ctx;
+	struct sk_buff *skb_cpy;
+	struct net *caller_net;
+	unsigned int foff;
+	struct net *net;
+	int mac_len;
+	void *mac;
+	int err;
+
+	if (unlikely(!((s32)netns < 0 || netns <= S32_MAX)))
+		return -EINVAL;
+
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+	if ((s32)netns < 0) {
+		net = caller_net;
+	} else {
+		net = get_net_ns_by_id(caller_net, netns);
+		if (unlikely(!net))
+			return -EINVAL;
+	}
+
+	err = set_dst(skb, net);
+	if (err < 0)
+		return err;
+
+	mac_len = skb->mac_len;
+	skb_cpy = skb_copy(skb, GFP_ATOMIC);
+	if (!skb_cpy)
+		return -ENOMEM;
+
+	/* _ipv6_frag_rcv() expects skb->transport_header to be set to start of
+	 * the frag header and nhoff to be set.
+	 */
+	err = ipv6_find_hdr(skb_cpy, &foff, NEXTHDR_FRAGMENT, NULL, NULL);
+	if (err < 0)
+		return err;
+	skb_set_transport_header(skb_cpy, foff);
+	IP6CB(skb_cpy)->nhoff = offsetof(struct ipv6hdr, nexthdr);
+
+	/* inet6_protocol handlers return >0 on success, 0 on out of band
+	 * consumption, <0 on error. We never expect to see 0 here.
+	 */
+	err = _ipv6_frag_rcv(net, skb_cpy, IP6_DEFRAG_BPF);
+	if (err < 0)
+		return err;
+	else if (err == 0)
+		return -EINVAL;
+
+	skb_morph(skb, skb_cpy);
+	kfree_skb(skb_cpy);
+
+	/* _ipv6_frag_rcv() does not maintain mac header, so push empty header
+	 * in so prog sees the correct layout. The empty mac header will be
+	 * later pulled from cls_bpf.
+	 */
+	skb->mac_len = mac_len;
+	mac = skb_push(skb, mac_len);
+	memset(mac, 0, mac_len);
+	bpf_compute_data_pointers(skb);
+
+	return 0;
+}
+
+__diag_pop()
+
+BTF_SET8_START(ipv6_reassembly_kfunc_set)
+BTF_ID_FLAGS(func, bpf_ipv6_frag_rcv, KF_CHANGES_PKT)
+BTF_SET8_END(ipv6_reassembly_kfunc_set)
+
+static const struct btf_kfunc_id_set ipv6_reassembly_bpf_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &ipv6_reassembly_kfunc_set,
+};
+
+int register_ipv6_reassembly_bpf(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
+					 &ipv6_reassembly_bpf_kfunc_set);
+}
-- 
2.39.1

