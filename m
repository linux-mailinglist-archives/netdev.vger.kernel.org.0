Return-Path: <netdev+bounces-1657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 280C86FEA22
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 05:22:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2655B1C20ECC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F57F17747;
	Thu, 11 May 2023 03:22:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C887FC
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:22:29 +0000 (UTC)
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2B7E79;
	Wed, 10 May 2023 20:22:28 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.west.internal (Postfix) with ESMTP id CEE813200124;
	Wed, 10 May 2023 23:22:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 10 May 2023 23:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm3; t=1683775344; x=1683861744; bh=xnc1TcPVHV
	pnczpRt1vWXwHTMM/FbKZZeCxkHt/7q6Q=; b=GL6BXyaomMgSBnzOSORIOkgcWW
	41Af/LZsYQVD870jpNkqs6PhJSEz4/NtexFvfz2pW39E9r85r67DBcu+AP5DOSs3
	ELJ5s+313oX0H6kEWe0zoeif8q6AZ3P3npqjgFsXwW3gNm46PMp5ts1Ew0YIOnp7
	NbYhKaUQGaaKR4FqbVIi74w4hcp41n4qQ6lR1OALQ8+6dpQylWi22IMNSemSwgG+
	gaTcXu8vckaBDu4fFvnWjOtQ93M0Ki2Gb24uyBLpDHXDzKai+S2NvTvJdo0mJMSf
	WULDgD7hwk+LPIz8MvemmOwftnRJ84bZ0g/PdpBEObYSjcJKxtU54zJr7rKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683775344; x=1683861744; bh=xnc1TcPVHVpnc
	zpRt1vWXwHTMM/FbKZZeCxkHt/7q6Q=; b=jCJNnLTCyHW55Pl3uQ1ZZSLd3CPbO
	xF7eiUDmtv0LKEITi3ZlLqdoBOiAky63WoSn6nlD8TwX0/A/yLNANgkVraWvGa9c
	wZWV6ren+foSeXNhJn1yE8RNN4AQa2naTsu21s+m/9gAyNXVi/Rph5LB9+K5Nk/E
	qssVU027TIiNlu9JZrzN062XZHtjV40Tx50UlpmcPWLdk7F+Oi1dkEppKyJQQ+S4
	FqoSi6O7bAMtE75fdKHQkxGKh03saLzaxhWH5yNyqbLvRGACPaA/h0fgrxZwKmUC
	RphpaAyMub4Bd1KkGM0VpvPuRbPlKyaaLkBI17FJeEyIELMnovIzkupuQ==
X-ME-Sender: <xms:cF9cZFGteI9aZV-jLHKxwz8sqOw54GppA85iNY1MEQgByrRF4owk4Q>
    <xme:cF9cZKWtus4X7Y0U6bhefOFLINkPPl_950odh1eBEVuModBbX2aW3ou73jfdsXrSK
    UYJrjRJslsgqitpywM>
X-ME-Received: <xmr:cF9cZHKF-t6Del2rj-_jURV2uIRb9tsbhdpT1kzCSdbJhQz1GpP1faIceOVnDR09bDBOg5QJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegjedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:cF9cZLGpiirOE0FQDZuJE8c_Tn97wFQImWYlTuWz0F8v0SwUWP04JQ>
    <xmx:cF9cZLUK79pnqwufRRKLaJEidVXWVNUjSCrtgRDzMsDpZluWvYayPw>
    <xmx:cF9cZGPJKFGn7movYEiZr-K41zHpQ47aXImA9-3LWMATwLTiZvLRGQ>
    <xmx:cF9cZIWlWxKe_8bsrpdpCn0w8JeCHjwBVSDrDeRH9q-SZYH0XWqwmw>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 May 2023 23:22:19 -0400 (EDT)
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com,
	razor@blackwall.org,
	idosch@nvidia.com,
	liuhangbin@gmail.com,
	eyal.birger@gmail.com,
	jtoppins@redhat.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org,
	Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v8 1/2] vxlan: Add nolocalbypass option to vxlan.
Date: Thu, 11 May 2023 11:22:09 +0800
Message-Id: <20230511032210.9146-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

If a packet needs to be encapsulated towards a local destination IP,
the packet will be injected into the Rx path as if it was received by
the target VXLAN device without undergoing encapsulation. If such a
device does not exist, the packet will be dropped.

There are scenarios where we do not want to drop such packets and
instead want to let them be encapsulated and locally received by a user
space program that post-processes these VXLAN packets.

To that end, add a new VXLAN device attribute that controls whether such
packets are dropped or not. When set ("localbypass") packets are
dropped and when unset ("nolocalbypass") the packets are encapsulated
and locally delivered to the listening user space application. Default
to "localbypass" to maintain existing behavior.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 drivers/net/vxlan/vxlan_core.c | 21 +++++++++++++++++++--
 include/net/vxlan.h            |  4 +++-
 include/uapi/linux/if_link.h   |  1 +
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..78744549c1b3 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2352,7 +2352,8 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 #endif
 	/* Bypass encapsulation if the destination is local */
 	if (rt_flags & RTCF_LOCAL &&
-	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
+	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST)) &&
+	    vxlan->cfg.flags & VXLAN_F_LOCALBYPASS) {
 		struct vxlan_dev *dst_vxlan;
 
 		dst_release(dst);
@@ -3172,6 +3173,7 @@ static void vxlan_raw_setup(struct net_device *dev)
 }
 
 static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
+	[IFLA_VXLAN_UNSPEC]     = { .strict_start_type = IFLA_VXLAN_LOCALBYPASS },
 	[IFLA_VXLAN_ID]		= { .type = NLA_U32 },
 	[IFLA_VXLAN_GROUP]	= { .len = sizeof_field(struct iphdr, daddr) },
 	[IFLA_VXLAN_GROUP6]	= { .len = sizeof(struct in6_addr) },
@@ -3202,6 +3204,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
 	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
+	[IFLA_VXLAN_LOCALBYPASS]	= NLA_POLICY_MAX(NLA_U8, 1),
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -4011,6 +4014,17 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
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
@@ -4232,6 +4246,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
+		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
 		0;
 }
 
@@ -4308,7 +4323,9 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
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
2.35.8

--
Fastmail.


