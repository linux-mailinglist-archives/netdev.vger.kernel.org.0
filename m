Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AC36F3384
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 18:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbjEAQZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 12:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjEAQZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 12:25:53 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E6110C2;
        Mon,  1 May 2023 09:25:50 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AC42A5C00F8;
        Mon,  1 May 2023 12:25:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 01 May 2023 12:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1682958348; x=1683044748; bh=Nz5Xnxw/7J
        2sF+q9FPIvfyE3450jMyFjzhPQAFBwYNE=; b=adEG38EkqyO0YWE1v8SYH8HGNy
        uD16IJWOh3nWm3h6E7oKkiFFvCgfhRzFbChaCXWhMFR4uhzFEdJimS+s9+VUBdF4
        ykyz3v5qv0YMH4pf9+8DnKIOR+sNSUott0GgBwl7dp1kq+9LcMFrcEgC3MvuEJZp
        38fXnM8Z1TX1EaVR5zR4iujxjjkzqnVbGBmw6ft+veeM2RlmbqAHLCrEdacMujl8
        OZffIBHkEs75uqxfTcWfy6lKxLdwCsQDd548I8ZIcLidv7ham1YC5mHRwfX8wvtS
        8lTqw5ZZL9e/h6PfcsdvAaF3alQJNWs6/Qm1dduhxRmqjqWpqb0m/0FHREdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682958348; x=1683044748; bh=Nz5Xnxw/7J2sF
        +q9FPIvfyE3450jMyFjzhPQAFBwYNE=; b=QhMct696puj8W1+YX768jUfzFcM6C
        xhwz+X2jk9pjdIneWLjk35VxLLgIx6/saOkzo5qOV47CtZApqnBiDgvMRzE1I1F4
        JBr8GzKieS6lZkW3/UOYs3wroKn3AcPfYiq6AkcGL06g6CPK2uhAS3YUz+rY4Gt0
        r0OFrZUpZjS7rwy17EYKh6QKul6gQTkTcJk5VxmxS2cjK5Vjamj1GFMYNtR8hNkw
        ePlFazL54a448zu40OgYtWgFiO6gvUgumb8KTaF3fIJT4JP+CjpwolvPtreot3OT
        0aa/ncVKT+ok4XeTRaeNGJPRcj/Cci723OouJnlIuNiMlmttpTSg5LsKg==
X-ME-Sender: <xms:DOhPZGalPxWsR1Ph-GhGkdYH1M77F2r0-bV32vl_go3ZC-Fm7dA31g>
    <xme:DOhPZJYssXBJIwjfQmeJNPy1AdEIb7oW542WP38wIp3b4l8IrtUPhn_A8Bf00G9EV
    4RQLvY7OoUB1DKyunk>
X-ME-Received: <xmr:DOhPZA8YJ0_W993DsIUDyXJauqxQktw1HUu0B5UmOKMu9BiomWLJBgj9S7P87GPbso-Y_0Qt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvgedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepgghlrgguihhmihhrucfpihhk
    ihhshhhkihhnuceovhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrf
    grthhtvghrnhepveejteeffeethfffleevgfetleeiheevheegledtteetvddtkeffleeg
    geeitdevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epvhhlrgguihhmihhrsehnihhkihhshhhkihhnrdhpfi
X-ME-Proxy: <xmx:DOhPZIok-kd08eszBVX6n5WMq640OA69K9vkrCcx_pkv4iZ_UVHPMg>
    <xmx:DOhPZBpP0fkSmugSD41u7FG97OqOSylNwdu1KxzGmh1HWhKfqt33Qg>
    <xmx:DOhPZGSmDmQFKVf0FZJLMk5bnocWxZAwwv7QSVmjbNAXO3WvDF0ooQ>
    <xmx:DOhPZC4BBKNvSrcX34UngVI7MB2PCJ7g4xzjYoW5UQK4SErbhHRjsg>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 May 2023 12:25:44 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
        liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com,
        shuah@kernel.org, linux-kselftest@vger.kernel.org,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v7 1/2] Add nolocalbypass option to vxlan.
Date:   Tue,  2 May 2023 00:25:29 +0800
Message-Id: <20230501162530.26414-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a packet needs to be encapsulated towards a local destination IP and
a VXLAN device that matches the destination port and VNI exists, then
the packet will be injected into the Rx path as if it was received by
the target VXLAN device without undergoing encapsulation. If such a
device does not exist, the packet will be dropped.

There are scenarios where we do not want to drop such packets and
instead want to let them be encapsulated and locally received by a user
space program that post-processes these VXLAN packets.

To that end, add a new VXLAN device attribute that controls whether such
packets are dropped or not. When set ("localbypass") these packets are
dropped and when unset ("nolocalbypass") the packets are encapsulated
and locally delivered to the listening user space application. Default
to "localbypass" to maintain existing behavior.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 drivers/net/vxlan/vxlan_core.c | 24 +++++++++++++++++++++---
 include/net/vxlan.h            |  4 +++-
 include/uapi/linux/if_link.h   |  1 +
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..ede98b879257 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2355,11 +2355,13 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 		struct vxlan_dev *dst_vxlan;
 
-		dst_release(dst);
 		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
 					   daddr->sa.sa_family, dst_port,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
+			if (!(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS))
+				return 0;
+			dst_release(dst);
 			dev->stats.tx_errors++;
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_ERRORS, 0);
@@ -2367,6 +2369,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 
 			return -ENOENT;
 		}
+		dst_release(dst);
 		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
 		return 1;
 	}
@@ -2568,7 +2571,6 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		if (!info) {
 			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
-
 			err = encap_bypass_if_local(skb, dev, vxlan, dst,
 						    dst_port, ifindex, vni,
 						    ndst, rt6i_flags);
@@ -3172,6 +3174,7 @@ static void vxlan_raw_setup(struct net_device *dev)
 }
 
 static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
+	[IFLA_VXLAN_UNSPEC]     = { .strict_start_type = IFLA_VXLAN_LOCALBYPASS },
 	[IFLA_VXLAN_ID]		= { .type = NLA_U32 },
 	[IFLA_VXLAN_GROUP]	= { .len = sizeof_field(struct iphdr, daddr) },
 	[IFLA_VXLAN_GROUP6]	= { .len = sizeof(struct in6_addr) },
@@ -3202,6 +3205,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
 	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
+	[IFLA_VXLAN_LOCALBYPASS]	= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -4011,6 +4015,17 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
 	}
 
+	if (data[IFLA_VXLAN_LOCALBYPASS]) {
+		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_LOCALBYPASS,
+				    VXLAN_F_LOCALBYPASS, changelink,
+				    true, extack);
+		if (err)
+			return err;
+	} else if (!changelink) {
+		/* default to local bypass on a new device */
+		conf->flags |= VXLAN_F_LOCALBYPASS;
+	}
+
 	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
@@ -4232,6 +4247,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
+		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
 		0;
 }
 
@@ -4308,7 +4324,9 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_TX,
 		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_TX)) ||
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_RX,
-		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)))
+		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)) ||
+	    nla_put_u8(skb, IFLA_VXLAN_LOCALBYPASS,
+		       !!(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS)))
 		goto nla_put_failure;
 
 	if (nla_put(skb, IFLA_VXLAN_PORT_RANGE, sizeof(ports), &ports))
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 20bd7d893e10..0be91ca78d3a 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -328,6 +328,7 @@ struct vxlan_dev {
 #define VXLAN_F_TTL_INHERIT		0x10000
 #define VXLAN_F_VNIFILTER               0x20000
 #define VXLAN_F_MDB			0x40000
+#define VXLAN_F_LOCALBYPASS		0x80000
 
 /* Flags that are used in the receive path. These flags must match in
  * order for a socket to be shareable
@@ -348,7 +349,8 @@ struct vxlan_dev {
 					 VXLAN_F_UDP_ZERO_CSUM6_TX |	\
 					 VXLAN_F_UDP_ZERO_CSUM6_RX |	\
 					 VXLAN_F_COLLECT_METADATA  |	\
-					 VXLAN_F_VNIFILTER)
+					 VXLAN_F_VNIFILTER         |    \
+					 VXLAN_F_LOCALBYPASS)
 
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4ac1000b0ef2..0f6a0fe09bdb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -828,6 +828,7 @@ enum {
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
 	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
-- 
2.35.7

--
Fastmail.

