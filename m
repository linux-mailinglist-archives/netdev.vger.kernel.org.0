Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5F06A4B9F
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjB0TwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjB0TwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:52:18 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4F528D05;
        Mon, 27 Feb 2023 11:52:00 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 9A9E03200949;
        Mon, 27 Feb 2023 14:51:58 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 27 Feb 2023 14:51:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1677527518; x=1677613918; bh=4a
        9g+C87bs/Akd4lBTjV68zWx7r6qrL4D2J7Om59rgI=; b=vsSHyw1cIo8PHT7ex6
        GGlJP075ADctVIXghE0sCUsAtGOFFBO+VwFQxCZvyNZCyE5GadWe5HrnWzn0/gg+
        D89EqQfUWbx11dKqxxSgTgzxRQQoUBoZNIT4em4wDtFZuyOKq2r+5bz1Eotc0sqQ
        YzWNNwpNCQiALYBqbzJWzedBClJHSNuyYlEEfRsb2NxadwdacoGNVzakQhkbCAhl
        l59+J7KBDWUgLYN6Oo9tJixAI6z73JnXutxP17RBNoGJi+VyglG4g8/EAad5xXnT
        h9y/OVwi98Ld3fN62JtE1184sUgsL301AHDXMnVOLsYdcl+deZUuQvsVbLcB9W/f
        cN6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1677527518; x=1677613918; bh=4a9g+C87bs/Ak
        d4lBTjV68zWx7r6qrL4D2J7Om59rgI=; b=GtsmOpkLjdwfN5spl9E5aRHSZ0xrt
        Bg0TpCSc+wJAfEKuxff6UsoDX+Iv0gMYq9q7h1A4oIbzPr2YDQZgF6Gcfayej1rm
        XWmo5Y7f1iwqSbsSxf04p8g7axBBVJltqpuN/xesdD9KUy9SwdMUlyohG+0S6O91
        WG2F+QPTncOndkpKCYXV33daIZCj+jdtmg4gTnCG6m3O0X0iHpyBo+JgdY91vojs
        HihX1yxYPp7iwYFXdGob9cJEMAEv3oowm1uuEt/Owz+eBDAUPXiY6Pd0cSGD2pah
        eVXB7zw87tXCQldVF/e4vSq96DnBSeGaBVu0Bvz/TYp0V8AGSWVA2Q+Wg==
X-ME-Sender: <xms:3gn9Yw_Y4ezUNvvinmOCoRVOCn19jvQ5YqdmwoT3ESvBPT7Q8XJNvQ>
    <xme:3gn9Y4uUEDzaZZn7vkT5ZDWaZuFy9gFvw2VLuo_zbuuguh882e_na1U5ASgBs0Xrm
    3RfQksqlKhtGNVGZA>
X-ME-Received: <xmr:3gn9Y2B5COoraMSwZ6AbEciq514VEDqPu-1dtaT42gkMgI_pmF7-nMlQSw2b73B-4J3eDs5QGMv9qOg0fbP1VBuyRwTBbpczM_468NBfumxPlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:3gn9YwdaC6w7nxxF18yJJ5_uBGpc_EE8JE8VaqnVETjcs-nQkdrBfQ>
    <xmx:3gn9Y1Njb8A745EVdT4RW5pXPgsh-MSdHBOjCiDlwJ90eYUI4uwTJw>
    <xmx:3gn9Y6l4FA7agCfOGJKFGKhayD7sfa9ScpC4H29n8hRSaVn4NQ9hAg>
    <xmx:3gn9YxBfQRvUSHJBWxCeaYCa5ux4KdJv6xMetNMlyQSeCZW6ahpF8w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Feb 2023 14:51:57 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, pabeni@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 3/8] bpf, net, frags: Add bpf_ip_check_defrag() kfunc
Date:   Mon, 27 Feb 2023 12:51:05 -0700
Message-Id: <7145c9891791db1c868a326476fef590f22b352b.1677526810.git.dxu@dxuuu.xyz>
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

This kfunc is used to defragment IPv4 packets. The idea is that if you
see a fragmented packet, you call this kfunc. If the kfunc returns 0,
then the skb has been updated to contain the entire reassembled packet.

If the kfunc returns an error (most likely -EINPROGRESS), then it means
the skb is part of a yet-incomplete original packet. A reasonable
response to -EINPROGRESS is to drop the packet, as the ip defrag
infrastructure is already hanging onto the frag for future reassembly.

Care has been taken to ensure the prog skb remains valid no matter what
the underlying ip_check_defrag() call does. This is in contrast to
ip_defrag(), which may consume the skb if the skb is part of a
yet-incomplete original packet.

So far this kfunc is only callable from TC clsact progs.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/ip.h           | 11 +++++
 net/ipv4/Makefile          |  1 +
 net/ipv4/ip_fragment.c     |  2 +
 net/ipv4/ip_fragment_bpf.c | 98 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 112 insertions(+)
 create mode 100644 net/ipv4/ip_fragment_bpf.c

diff --git a/include/net/ip.h b/include/net/ip.h
index c3fffaa92d6e..f3796b1b5cac 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -680,6 +680,7 @@ enum ip_defrag_users {
 	IP_DEFRAG_VS_FWD,
 	IP_DEFRAG_AF_PACKET,
 	IP_DEFRAG_MACVLAN,
+	IP_DEFRAG_BPF,
 };
 
 /* Return true if the value of 'user' is between 'lower_bond'
@@ -693,6 +694,16 @@ static inline bool ip_defrag_user_in_between(u32 user,
 }
 
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user);
+
+#ifdef CONFIG_DEBUG_INFO_BTF
+int register_ip_frag_bpf(void);
+#else
+static inline int register_ip_frag_bpf(void)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_INET
 struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user);
 #else
diff --git a/net/ipv4/Makefile b/net/ipv4/Makefile
index 880277c9fd07..950efb166d37 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -65,6 +65,7 @@ obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
+obj-$(CONFIG_DEBUG_INFO_BTF) += ip_fragment_bpf.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o xfrm4_protocol.o
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 959d2c4260ea..e3fda5203f09 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -759,5 +759,7 @@ void __init ipfrag_init(void)
 	if (inet_frags_init(&ip4_frags))
 		panic("IP: failed to allocate ip4_frags cache\n");
 	ip4_frags_ctl_register();
+	if (register_ip_frag_bpf())
+		panic("IP: bpf: failed to register ip_frag_bpf\n");
 	register_pernet_subsys(&ip4_frags_ops);
 }
diff --git a/net/ipv4/ip_fragment_bpf.c b/net/ipv4/ip_fragment_bpf.c
new file mode 100644
index 000000000000..a9e5908ed216
--- /dev/null
+++ b/net/ipv4/ip_fragment_bpf.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Unstable ipv4 fragmentation helpers for TC-BPF hook
+ *
+ * These are called from SCHED_CLS BPF programs. Note that it is allowed to
+ * break compatibility for these functions since the interface they are exposed
+ * through to BPF programs is explicitly unstable.
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf_ids.h>
+#include <linux/ip.h>
+#include <linux/filter.h>
+#include <linux/netdevice.h>
+#include <net/ip.h>
+#include <net/sock.h>
+
+__diag_push();
+__diag_ignore_all("-Wmissing-prototypes",
+		  "Global functions as their definitions will be in ip_fragment BTF");
+
+/* bpf_ip_check_defrag - Defragment an ipv4 packet
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
+int bpf_ip_check_defrag(struct __sk_buff *ctx, u64 netns)
+{
+	struct sk_buff *skb = (struct sk_buff *)ctx;
+	struct sk_buff *skb_cpy, *skb_out;
+	struct net *caller_net;
+	struct net *net;
+	int mac_len;
+	void *mac;
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
+	mac_len = skb->mac_len;
+	skb_cpy = skb_copy(skb, GFP_ATOMIC);
+	if (!skb_cpy)
+		return -ENOMEM;
+
+	skb_out = ip_check_defrag(net, skb_cpy, IP_DEFRAG_BPF);
+	if (IS_ERR(skb_out))
+		return PTR_ERR(skb_out);
+
+	skb_morph(skb, skb_out);
+	kfree_skb(skb_out);
+
+	/* ip_check_defrag() does not maintain mac header, so push empty header
+	 * in so prog sees the correct layout. The empty mac header will be
+	 * later pulled from cls_bpf.
+	 */
+	mac = skb_push(skb, mac_len);
+	memset(mac, 0, mac_len);
+	bpf_compute_data_pointers(skb);
+
+	return 0;
+}
+
+__diag_pop()
+
+BTF_SET8_START(ip_frag_kfunc_set)
+BTF_ID_FLAGS(func, bpf_ip_check_defrag, KF_CHANGES_PKT)
+BTF_SET8_END(ip_frag_kfunc_set)
+
+static const struct btf_kfunc_id_set ip_frag_bpf_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &ip_frag_kfunc_set,
+};
+
+int register_ip_frag_bpf(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS,
+					 &ip_frag_bpf_kfunc_set);
+}
-- 
2.39.1

