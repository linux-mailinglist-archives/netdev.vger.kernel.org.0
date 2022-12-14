Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B788764D364
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiLNX2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiLNX2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:28:06 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B412249B6B;
        Wed, 14 Dec 2022 15:26:14 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id D8F5A32008C0;
        Wed, 14 Dec 2022 18:26:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 14 Dec 2022 18:26:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1671060372; x=1671146772; bh=KB
        GCcVFV9pdga3P7P36DjTI4Zsnw96kBATcVDh8ugd0=; b=KeHjTp6oF8Buv9l5WR
        Q50uzwI+/AEohr4Z19sGhlRkJyONAzTBQ+a4nDMkms78SDfSk/4yDw2CvQAUUXvx
        gbOuWuwxYwXD7Ueof3vbPUfowBPoMTXrt6iNM3sPe9dFpZ0lg35Cc7LS7vkTtqDe
        eOZhe1D2q3GCPGDeKLctuiiJB+xtnj5zIqd6PJpBM2g624DiNGQj1Q4mdvz++8OD
        YpGp+p+Dyuajt0ZmgWrGGfXRu4hEg7aGneshXiAvbG1MqOmQhVIlNbOKKEDc3Q0T
        2OEZ04WZ3n8amJDxqQvPlAE40nr46mRIqU2XWvs2RKVCYmikbuw+RfSoLLxzErUA
        Dm+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1671060372; x=1671146772; bh=KBGCcVFV9pdga
        3P7P36DjTI4Zsnw96kBATcVDh8ugd0=; b=ZbY8sZhJ/ZesGsBcEXE9DgB1vzmZI
        cpA59ckz9VBBGhlAmxEIqdoK7VV04RSWc+ZY7UvlifczSiarh7wEyh5K21UqGrDq
        fzBIb9FJqlkdHkIz7RQ6PjArWg/clyIAn/UIevHj5y2H0VOFh0AKfKUf8ibNRTva
        OtkISjca6mBBV9xvkMuq8oxQo+qBgeIsLcnBz4qvf1SsFHPLhyZ6AhPbT5hF88bO
        nWWZvLSZjmuabsggwAauGpHSuC4heLXPBkhJip0em3OyEZyaIMI4mej5qk0DAbru
        f7ZAeTBmNmwWUp+L26t4+p8Szh91tt0azKYJRVzDT7kaFdXfEVKAvzU5w==
X-ME-Sender: <xms:lFuaY1iy23eDuMvThIlVt2MApXC6h9YSBKyFXXcHI_-o8GqaWLU5QA>
    <xme:lFuaY6Ab3GuOULx_XawC1amAUJvUGvFaGFQ9fypfxUQYyGeIHnJ_q3ieAzUik9HPp
    X-XlsqTyeiKmSPSLA>
X-ME-Received: <xmr:lFuaY1HbadwSUsUAhF-BWvkLYHI4g0mBW8Ulvp1RA97z7Unt-CIVNqhN0AnVvwIyYQAhymSZCs80sKUZh3gLBqMUHf2yoatwnfiP_s3EKOk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeggddtiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdejtddmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpefgfefggeejhfduieekvdeuteffleeifeeuvdfhheejleejjeek
    gfffgefhtddtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:lFuaY6STrKUlkBU7WvkjneOx4JkJeHg8DRuaBT_FCdOMqozEp6jXIw>
    <xmx:lFuaYyz5kyZlkU7ri_VVsWR20xdmhxLfhkdXB54rscc9kmwy08hk9Q>
    <xmx:lFuaYw48Vbxy-vs3pmUCm4ftSNNhte1omatUiwXnXyuQ1yDNUf-FnQ>
    <xmx:lFuaY2flXe2e8w6f2P8ABZVxDJBrfrsHTAnh-LQufYgOc5TlnZw9PA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Dec 2022 18:26:11 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     ppenkov@aviatrix.com, dbird@aviatrix.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/6] bpf, net, frags: Add bpf_ip_check_defrag() kfunc
Date:   Wed, 14 Dec 2022 16:25:30 -0700
Message-Id: <1f48a340a898c4d22d65e0e445dbf15f72081b9a.1671049840.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1671049840.git.dxu@dxuuu.xyz>
References: <cover.1671049840.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
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
index 144bdfbb25af..14f1e69a6523 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -679,6 +679,7 @@ enum ip_defrag_users {
 	IP_DEFRAG_VS_FWD,
 	IP_DEFRAG_AF_PACKET,
 	IP_DEFRAG_MACVLAN,
+	IP_DEFRAG_BPF,
 };
 
 /* Return true if the value of 'user' is between 'lower_bond'
@@ -692,6 +693,16 @@ static inline bool ip_defrag_user_in_between(u32 user,
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
index af7d2cf490fb..749da1599933 100644
--- a/net/ipv4/Makefile
+++ b/net/ipv4/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_TCP_CONG_ILLINOIS) += tcp_illinois.o
 obj-$(CONFIG_NET_SOCK_MSG) += tcp_bpf.o
 obj-$(CONFIG_BPF_SYSCALL) += udp_bpf.o
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
+obj-$(CONFIG_DEBUG_INFO_BTF) += ip_fragment_bpf.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o xfrm4_protocol.o
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 7406c6b6376d..467aa8ace9fb 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -757,5 +757,7 @@ void __init ipfrag_init(void)
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
2.39.0

