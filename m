Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC4731B108
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 16:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhBNPzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 10:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhBNPzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 10:55:15 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEDFC061788
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:34 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id n13so714240ejx.12
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 07:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TeW8leO2RtVwcrBK4HHYpFHToiAaWhWUx4BN3kGRZR0=;
        b=KdnLLooEJBGFqYOPATupqYHXE/JvBi2ZKeokRaYfO4lCsXmHpHOe11Ui5GIYC7Jo31
         PBS12wz5G/N8tcP4QqiH6R4Noe9f8MY/00+nhDoocnhr9HtlQNCwgfqoLDbzbK7dgx6C
         JAYFueua/V9vgooUOwHi/GR6Z/OxkyhvPOUOyJzAYAOVIkdberUg7fSeUor9x+tOxozp
         fjHphhxzih/edKzCwIRzek+LReYPNKuyme2iVGh5Jc2flGiL0TB2nnga+GKrAYzR5G7Y
         imoouBrzhmoWxrGfhSgqBuRGdolPp8eEs8Be4J+oWI78zfpH2kjsMhfjXa2J/bpaEQxm
         yAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TeW8leO2RtVwcrBK4HHYpFHToiAaWhWUx4BN3kGRZR0=;
        b=V26yBtAfAUPCz4obqPVgEuexhhB1FTDm7dZUlxIMU5sYhsYJsDjb8UP8sB38+stqAe
         taqvnVk62+Vzk22uQMB7+LbFaqxTnPyIv/K/EhkC5C5vPM5pStJQIOk2JpYqh1037YPt
         Ke0kZEfB+KTBGYGVTIv1fcfv5P7uHYrIUJw49NV//uFqm68N7YUk3Pjfhq04+VxybjwB
         R8N6cODAhoLyzQxtKNG+bG02JvonTaFD2k09Wm06F3PZddhn3ZmTz/3+Rk6A/AE8/qaN
         ZreWQhhDJ51YJxiZtuMeAwg+kRosePQ/lAw6Q+zAAq3M3JUZod7T2QSg9fFO0NL/o5bU
         JEWQ==
X-Gm-Message-State: AOAM530ZdJRfr4Y3HSl3uoVvPswNSbtByPeceTRcl6P66hoYu5Tw02+q
        RIraDmEESl7aG5DNV5jS9Eo=
X-Google-Smtp-Source: ABdhPJxHIsKCitmWzsEVkeZl0ZXxMm5kC9+lfReeUJiw1hxJ0v+u/sd2CSd+ppZ3Z0nKXADA9Ri6xg==
X-Received: by 2002:a17:907:aa9:: with SMTP id bz9mr11596374ejc.528.1613318073209;
        Sun, 14 Feb 2021 07:54:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id cn18sm8576003edb.66.2021.02.14.07.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 07:54:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH net-next 4/4] net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
Date:   Sun, 14 Feb 2021 17:53:26 +0200
Message-Id: <20210214155326.1783266-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210214155326.1783266-1-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA has gained the recent ability to deal gracefully with upper
interfaces it cannot offload, such as the bridge, bonding or team
drivers. When such uppers exist, the ports are still in standalone mode
as far as the hardware is concerned.

But when we deliver packets to the software bridge in order for that to
do the forwarding, there is an unpleasant surprise in that the bridge
will refuse to forward them. This is because we unconditionally set
skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
were already forwarded in hardware by us.

Since dp->bridge_dev is populated only when there is hardware offload
for it, but not in the software fallback case, let's introduce a new
helper that can be called from the tagger data path which sets the
skb->offload_fwd_mark accordingly to zero when there is no hardware
offload for bridging. This lets the bridge forward packets back to other
interfaces of our switch, if needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h         | 14 ++++++++++++++
 net/dsa/tag_brcm.c         |  2 +-
 net/dsa/tag_dsa.c          |  9 +++++----
 net/dsa/tag_hellcreek.c    |  2 +-
 net/dsa/tag_ksz.c          |  2 +-
 net/dsa/tag_lan9303.c      |  4 +++-
 net/dsa/tag_mtk.c          |  2 +-
 net/dsa/tag_ocelot.c       |  2 +-
 net/dsa/tag_ocelot_8021q.c |  2 +-
 net/dsa/tag_rtl4_a.c       |  2 +-
 net/dsa/tag_sja1105.c      |  4 ++--
 net/dsa/tag_xrs700x.c      |  3 +--
 12 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7b0dd2d5f3f8..4226ce1967d3 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -326,6 +326,20 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
 	return skb;
 }
 
+/* If the ingress port offloads the bridge, we mark the frame as autonomously
+ * forwarded by hardware, so the software bridge doesn't forward in twice, back
+ * to us, because we already did. However, if we're in fallback mode and we do
+ * software bridging, we are not offloading it, therefore the dp->bridge_dev
+ * pointer is not populated, and flooding needs to be done by software (we are
+ * effectively operating in standalone ports mode).
+ */
+static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+
+	skb->offload_fwd_mark = !!(dp->bridge_dev);
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e2577a7dcbca..a8880b3bb106 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -150,7 +150,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 7e7b7decdf39..91f405b59f75 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -162,8 +162,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
+	bool trap = false, trunk = false;
 	int source_device, source_port;
-	bool trunk = false;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -174,8 +174,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	cmd = dsa_header[0] >> 6;
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
-		skb->offload_fwd_mark = 1;
-
 		trunk = !!(dsa_header[1] & 7);
 		break;
 
@@ -194,7 +192,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 			 * device (like a bridge) that forwarding has
 			 * already been done by hardware.
 			 */
-			skb->offload_fwd_mark = 1;
 			break;
 		case DSA_CODE_MGMT_TRAP:
 		case DSA_CODE_IGMP_MLD_TRAP:
@@ -202,6 +199,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 			/* Traps have, by definition, not been
 			 * forwarded by hardware, so don't mark them.
 			 */
+			trap = true;
 			break;
 		default:
 			/* Reserved code, this could be anything. Drop
@@ -235,6 +233,9 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
+	if (!trap)
+		dsa_default_offload_fwd_mark(skb);
+
 	/* If the 'tagged' bit is set; convert the DSA tag to a 802.1Q
 	 * tag, and delete the ethertype (extra) if applicable. If the
 	 * 'tagged' bit is cleared; delete the DSA tag, and ethertype
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index a09805c8e1ab..c1ee6eefafe4 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -44,7 +44,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
 
-	skb->offload_fwd_mark = true;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 4820dbcedfa2..8eee63a5b93b 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -24,7 +24,7 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, skb->len - len);
 
-	skb->offload_fwd_mark = true;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index aa1318dccaf0..3fd85139a3a6 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -115,7 +115,9 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_pull_rcsum(skb, 2 + 2);
 	memmove(skb->data - ETH_HLEN, skb->data - (ETH_HLEN + LAN9303_TAG_LEN),
 		2 * ETH_ALEN);
-	skb->offload_fwd_mark = !(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU);
+
+	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
+		dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 38dcdded74c0..08387fa37d17 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -97,7 +97,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	/* Only unicast or broadcast frames are offloaded */
 	if (likely(!is_multicast_skb))
-		skb->offload_fwd_mark = 1;
+		dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 16a1afd5b8e1..7f0898569876 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -225,7 +225,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 		 */
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 	skb->priority = qos_class;
 
 	/* Ocelot switches copy frames unmodified to the CPU. However, it is
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 8991ebf098a3..a9ad03626b2e 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -48,7 +48,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 	skb->priority = qos_class;
 
 	return skb;
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 2646abe5a69e..c942d8697ed8 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -101,7 +101,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
 		2 * ETH_ALEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 50496013cdb7..45cdf64f0e88 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -295,8 +295,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-	skb->offload_fwd_mark = 1;
-
 	if (is_tagged) {
 		/* Normal traffic path. */
 		skb_push_rcsum(skb, ETH_HLEN);
@@ -339,6 +337,8 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	dsa_default_offload_fwd_mark(skb);
+
 	if (subvlan)
 		sja1105_decode_subvlan(skb, subvlan);
 
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index 858cdf9d2913..215ecceea89e 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -45,8 +45,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (pskb_trim_rcsum(skb, skb->len - 1))
 		return NULL;
 
-	/* Frame is forwarded by hardware, don't forward in software. */
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
-- 
2.25.1

