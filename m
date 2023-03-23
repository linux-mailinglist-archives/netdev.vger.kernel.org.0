Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E90E6C5DE7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 05:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCWE01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 00:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCWE00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 00:26:26 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8157ACDCA
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 21:26:24 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F21395C01A8;
        Thu, 23 Mar 2023 00:26:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 23 Mar 2023 00:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1679545581; x=1679631981; bh=3v/z7CqmnA
        D5jx5/HaHvEZhbXuBHVkGN2N+hz8caQUI=; b=frtJnk6TI1E+EtYIVP8JCQkYLs
        aAJUD9uw6VZVSX25KEJGJ5dLumDuukCOX910vITP0dwPsComD8zmioGa7iBoYRsV
        hctGzktvkz6AqKnUuAV05kVw06frXIykBuXxTiSfGAEOZNUd/sYhqcRc1C6hNzJx
        E0eJ5xTyupGZJmWFJKbkqHMXCUVRRrnPZ6iBL3+ou/+ut4KIxAQPV0TeGvHq07dd
        XIFGaTAwvflVLqEXPJYZqIEaOmawE8e/g0nZJKGq7KPuVx0ymHaeg2sfjpk8i3is
        2WBFqOcRVldcD+5IT8cCnOLsF6YuAjBhh5Ed92wwYBt+JEX5+DoxHFjA+sHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679545581; x=1679631981; bh=3v/z7CqmnAD5j
        x5/HaHvEZhbXuBHVkGN2N+hz8caQUI=; b=Txt0qov2R8CpjxMD4LePynupmVmm9
        MntyIUbeQbjCh0Zo2/OTK6XOe749RVPjqhMhJ1R1xuiizk4Z59aow3sinhsUyOiK
        Kt9q1vCYN36xiM8BlC4moA6w5vIxEV0z+MYpoBXbYbe1IhJoYOdos88eRr7tUH3A
        7a8kt/sarG2O2qzS6dtBXbzhzPatGbx4t1YX+VkUxXqxY8hDwklSNylV16c7V2s0
        sg0axZmLWpnj8KcfZzJ4Wkgtnm0I0C6+hNyLkdk2G4o7lytFyvilteXTeb0CeEbn
        2kR/+MM9aqgnSW+kl6fIyvdiF7FEnj7bf9dtxJZfboFFwuHzIKMAN+s0A==
X-ME-Sender: <xms:7dQbZKSbPAPieHyk66wd_HtfL63KYg2tZ7yin98S0MauZeSQZtzxQg>
    <xme:7dQbZPy4yc-1WHw7wM7-3PLWjEmtUwjH-ZKrdeOiE55uhb0GZz2A5JNopgVCz_OZN
    BzsJr3gpadHUMYBGx8>
X-ME-Received: <xmr:7dQbZH2DxrxdBWk55ME2mT7sorVUIVBZfBHish7jEJoKX3iCHJUz5jiSydK8qICDLeSkFkY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdegfedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    evufffkffoggfgsedtkeertdertddtnecuhfhrohhmpegglhgrughimhhirhcupfhikhhi
    shhhkhhinhcuoehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphifqeenucggtffrrg
    htthgvrhhnpeevjeetfeeftefhffelvefgteelieehveehgeeltdettedvtdekffelgeeg
    iedtveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:7dQbZGC2x5wLEo0Bin3XluN4Leuf9eJZCJ6mf0NrtB0s6TcPWHikNg>
    <xmx:7dQbZDirpssaCO4vU51xIoY5fuWDVZtJQx9NooJd_LDmJKKWCmESRA>
    <xmx:7dQbZCrTUVxDmJkKkb61rHa5_-1xQmQtld2x6pazle4Qvk8JpSz9-A>
    <xmx:7dQbZDh6Q5qNIeIOi0hIsQCM7rqKCxdqxJX9hbVfqvw_nWcsHAsSJg>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Mar 2023 00:26:18 -0400 (EDT)
From:   Vladimir Nikishkin <vladimir@nikishkin.pw>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
        gnault@redhat.com, razor@blackwall.org,
        Vladimir Nikishkin <vladimir@nikishkin.pw>
Subject: [PATCH net-next v5] vxlan: try to send a packet normally if local bypass fails
Date:   Thu, 23 Mar 2023 12:26:08 +0800
Message-Id: <20230323042608.17573-1-vladimir@nikishkin.pw>
X-Mailer: git-send-email 2.35.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vxlan_core, if an fdb entry is pointing to a local
address with some port, the system tries to get the packet to
deliver the packet to the vxlan directly, bypassing the network
stack.

This patch makes it still try canonical delivery, if there is no
linux kernel vxlan listening on this port. This will be useful
for the cases when there is some userspace daemon expecting
vxlan packets for post-processing, or some other implementation
of vxlan.

Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
---
 drivers/net/vxlan/vxlan_core.c     | 34 ++++++++++++++++++++++++------
 include/net/vxlan.h                |  4 +++-
 include/uapi/linux/if_link.h       |  1 +
 tools/include/uapi/linux/if_link.h |  2 ++
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5..cef7a9aec24b 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2341,7 +2341,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 				 union vxlan_addr *daddr,
 				 __be16 dst_port, int dst_ifindex, __be32 vni,
 				 struct dst_entry *dst,
-				 u32 rt_flags)
+				 u32 rt_flags, bool localbypass)
 {
 #if IS_ENABLED(CONFIG_IPV6)
 	/* IPv6 rt-flags are checked against RTF_LOCAL, but the value of
@@ -2355,18 +2355,21 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 	    !(rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))) {
 		struct vxlan_dev *dst_vxlan;
 
-		dst_release(dst);
 		dst_vxlan = vxlan_find_vni(vxlan->net, dst_ifindex, vni,
 					   daddr->sa.sa_family, dst_port,
 					   vxlan->cfg.flags);
-		if (!dst_vxlan) {
+		if (!dst_vxlan && localbypass) {
+			dst_release(dst);
 			dev->stats.tx_errors++;
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_ERRORS, 0);
 			kfree_skb(skb);
 
 			return -ENOENT;
+		} else if (!dst_vxlan && !localbypass) {
+			return 0;
 		}
+		dst_release(dst);
 		vxlan_encap_bypass(skb, vxlan, dst_vxlan, vni, true);
 		return 1;
 	}
@@ -2393,6 +2396,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	int err;
 	u32 flags = vxlan->cfg.flags;
 	bool udp_sum = false;
+	bool localbypass = true;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
 	__be32 vni = 0;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -2494,9 +2498,11 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		if (!info) {
 			/* Bypass encapsulation if the destination is local */
+			localbypass =	!(flags & VXLAN_F_LOCALBYPASS);
 			err = encap_bypass_if_local(skb, dev, vxlan, dst,
 						    dst_port, ifindex, vni,
-						    &rt->dst, rt->rt_flags);
+						    &rt->dst, rt->rt_flags,
+						    localbypass);
 			if (err)
 				goto out_unlock;
 
@@ -2568,10 +2574,10 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		if (!info) {
 			u32 rt6i_flags = ((struct rt6_info *)ndst)->rt6i_flags;
-
+			localbypass =  !(flags & VXLAN_F_LOCALBYPASS);
 			err = encap_bypass_if_local(skb, dev, vxlan, dst,
 						    dst_port, ifindex, vni,
-						    ndst, rt6i_flags);
+						    ndst, rt6i_flags, localbypass);
 			if (err)
 				goto out_unlock;
 		}
@@ -3202,6 +3208,7 @@ static const struct nla_policy vxlan_policy[IFLA_VXLAN_MAX + 1] = {
 	[IFLA_VXLAN_TTL_INHERIT]	= { .type = NLA_FLAG },
 	[IFLA_VXLAN_DF]		= { .type = NLA_U8 },
 	[IFLA_VXLAN_VNIFILTER]	= { .type = NLA_U8 },
+	[IFLA_VXLAN_LOCALBYPASS]	= { .type = NLA_U8 },
 };
 
 static int vxlan_validate(struct nlattr *tb[], struct nlattr *data[],
@@ -4011,6 +4018,16 @@ static int vxlan_nl2conf(struct nlattr *tb[], struct nlattr *data[],
 			conf->flags |= VXLAN_F_UDP_ZERO_CSUM_TX;
 	}
 
+	if (data[IFLA_VXLAN_LOCALBYPASS]) {
+		if (changelink) {
+			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_LOCALBYPASS],
+					    "Cannot change LOCALBYPASS flag");
+			return -EOPNOTSUPP;
+		}
+		if (!nla_get_u8(data[IFLA_VXLAN_LOCALBYPASS]))
+			conf->flags |= VXLAN_F_LOCALBYPASS;
+	}
+
 	if (data[IFLA_VXLAN_UDP_ZERO_CSUM6_TX]) {
 		err = vxlan_nl2flag(conf, data, IFLA_VXLAN_UDP_ZERO_CSUM6_TX,
 				    VXLAN_F_UDP_ZERO_CSUM6_TX, changelink,
@@ -4232,6 +4249,7 @@ static size_t vxlan_get_size(const struct net_device *dev)
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_UDP_ZERO_CSUM6_RX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_TX */
 		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_REMCSUM_RX */
+		nla_total_size(sizeof(__u8)) + /* IFLA_VXLAN_LOCALBYPASS */
 		0;
 }
 
@@ -4308,7 +4326,9 @@ static int vxlan_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_TX,
 		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_TX)) ||
 	    nla_put_u8(skb, IFLA_VXLAN_REMCSUM_RX,
-		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)))
+		       !!(vxlan->cfg.flags & VXLAN_F_REMCSUM_RX)) ||
+	    nla_put_u8(skb, IFLA_VXLAN_LOCALBYPASS,
+		       !(vxlan->cfg.flags & VXLAN_F_LOCALBYPASS)))
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
index 57ceb788250f..4e3a3d295056 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -826,6 +826,7 @@ enum {
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
 	IFLA_VXLAN_VNIFILTER, /* only applicable with COLLECT_METADATA mode */
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 901d98b865a1..3d9a1fd6f7e7 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -747,6 +747,8 @@ enum {
 	IFLA_VXLAN_GPE,
 	IFLA_VXLAN_TTL_INHERIT,
 	IFLA_VXLAN_DF,
+	IFLA_VXLAN_VNIFILTER,
+	IFLA_VXLAN_LOCALBYPASS,
 	__IFLA_VXLAN_MAX
 };
 #define IFLA_VXLAN_MAX	(__IFLA_VXLAN_MAX - 1)
-- 
2.35.7

--
Fastmail.

