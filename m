Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5271D18C7
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgEMPK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389089AbgEMPKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:10:25 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC32BC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:10:25 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y25so8126969pfn.5
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 08:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/7y6hmshkKKSxjyTdVHPwU97L1AeKQYF3Z/95TQkF6E=;
        b=I4cIJIiqP11iNmQOWCGXBg1RMnKnIA0aR9YIDFQ0IprLyoBboMt1zn8/Y3Q26eCk6L
         nMbetA5UQ5Yf8eAbhubx9oQcqnMYzT5vDndVkfb/PXCh+0CiBwKTIUvTTOctEe2AdgZs
         mzMkLySNhCRMROBTpab9Gwum1nwrqbY21KohvMuHQLb0H1tQqTeK0HtHiF5Leu9/xFaI
         VG31UdZqq7RSmj9SL9ac3zFTdLNL9mcQKYbTDcRIM6OndE18waWIruxQ3rNAUiivFQ/m
         zspW88bmGIScP2zdWnSTqbniZtNz4m6PzOdzE3X8+nCljjEl8aFpx9aUZ1DQrZmDmHjd
         NXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/7y6hmshkKKSxjyTdVHPwU97L1AeKQYF3Z/95TQkF6E=;
        b=HcaMoceZQmS84bcw5FJhTqi92m2MJK9G8QzMYHcN9eOd4pBGcG+AsPOn/7mlSBhf/C
         ntHqpdsa0amAgz3gipXBbgIIo7ZWlCGS8a50MQ3P9AfAMW4JTvb0okfKBZJAT8epEbMU
         KlM5opzZihyCf6+8dQKHYa8Sk4CGD/b9jUjJD4uBdgKFibpFsCDXNKPHHZJSQQk3/r1h
         rKxiTyyQhyVkxbhiB9fjs7Oapm0UN5ukCueq1VyZ6ZWqNennSIPRv2IsKAHh6NL2iVl0
         zYBZaDiEbrBlioK3ZR+W4YDyVbcIGDqAm+ZRRyfG0yVdOV7sJa9/24XlKVa/aGKW19wj
         Cyog==
X-Gm-Message-State: AGi0Pubgp674hKMTfoqMMVU0McQUsUYaOiEIYu70wUcNXqPeGiumdPmv
        BztImxDxx/rZ5mB/ciDCr0Pw7sAi/aq/v4Vh
X-Google-Smtp-Source: APiQypKEowcdBOXq7xLrN0JxB381N9q9dLQualzp3aF9uW4/Ra26tVujPXdesm1UT6wgcsu4mVq0NQ==
X-Received: by 2002:a63:130c:: with SMTP id i12mr23686286pgl.122.1589382624957;
        Wed, 13 May 2020 08:10:24 -0700 (PDT)
Received: from P65xSA.lan ([2402:f000:1:1501::3b2a:1e89])
        by smtp.gmail.com with ESMTPSA id t188sm14909829pfb.185.2020.05.13.08.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 08:10:23 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Tom James <tj17@me.com>,
        Stijn Segers <foss@volatilesystems.org>,
        riddlariddla@hotmail.com, Szabolcs Hubai <szab.hu@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH REPOST] net: dsa: mt7530: fix roaming from DSA user ports
Date:   Wed, 13 May 2020 23:10:16 +0800
Message-Id: <20200513151016.14376-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a client moves from a DSA user port to a software port in a bridge,
it cannot reach any other clients that connected to the DSA user ports.
That is because SA learning on the CPU port is disabled, so the switch
ignores the client's frames from the CPU port and still thinks it is at
the user port.

Fix it by enabling SA learning on the CPU port.

To prevent the switch from learning from flooding frames from the CPU
port, set skb->offload_fwd_mark to 1 for unicast and broadcast frames,
and let the switch flood them instead of trapping to the CPU port.
Multicast frames still need to be trapped to the CPU port for snooping,
so set the SA_DIS bit of the MTK tag to 1 when transmitting those frames
to disable SA learning.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
Reposting as non-RFC

 drivers/net/dsa/mt7530.c |  9 ++-------
 drivers/net/dsa/mt7530.h |  1 +
 net/dsa/tag_mtk.c        | 15 +++++++++++++++
 3 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 5c444cd722bd..34e4aadfa705 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -628,11 +628,8 @@ mt7530_cpu_port_enable(struct mt7530_priv *priv,
 	mt7530_write(priv, MT7530_PVC_P(port),
 		     PORT_SPEC_TAG);
 
-	/* Disable auto learning on the cpu port */
-	mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
-
-	/* Unknown unicast frame fordwarding to the cpu port */
-	mt7530_set(priv, MT7530_MFC, UNU_FFP(BIT(port)));
+	/* Unknown multicast frame forwarding to the cpu port */
+	mt7530_rmw(priv, MT7530_MFC, UNM_FFP_MASK, UNM_FFP(BIT(port)));
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
@@ -1294,8 +1291,6 @@ mt7530_setup(struct dsa_switch *ds)
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
-	mt7530_clear(priv, MT7530_MFC, UNU_FFP_MASK);
-
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
 		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 979bb6374678..82af4d2d406e 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -31,6 +31,7 @@ enum {
 #define MT7530_MFC			0x10
 #define  BC_FFP(x)			(((x) & 0xff) << 24)
 #define  UNM_FFP(x)			(((x) & 0xff) << 16)
+#define  UNM_FFP_MASK			UNM_FFP(~0)
 #define  UNU_FFP(x)			(((x) & 0xff) << 8)
 #define  UNU_FFP_MASK			UNU_FFP(~0)
 #define  CPU_EN				BIT(7)
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index b5705cba8318..d6619edd53e5 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -15,6 +15,7 @@
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
 #define MTK_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
 #define MTK_HDR_XMIT_DP_BIT_MASK	GENMASK(5, 0)
+#define MTK_HDR_XMIT_SA_DIS		BIT(6)
 
 static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
@@ -22,6 +23,9 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	u8 *mtk_tag;
 	bool is_vlan_skb = true;
+	unsigned char *dest = eth_hdr(skb)->h_dest;
+	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
+				!is_broadcast_ether_addr(dest);
 
 	/* Build the special tag after the MAC Source Address. If VLAN header
 	 * is present, it's required that VLAN header and special tag is
@@ -47,6 +51,10 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 		     MTK_HDR_XMIT_UNTAGGED;
 	mtk_tag[1] = (1 << dp->index) & MTK_HDR_XMIT_DP_BIT_MASK;
 
+	/* Disable SA learning for multicast frames */
+	if (unlikely(is_multicast_skb))
+		mtk_tag[1] |= MTK_HDR_XMIT_SA_DIS;
+
 	/* Tag control information is kept for 802.1Q */
 	if (!is_vlan_skb) {
 		mtk_tag[2] = 0;
@@ -61,6 +69,9 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	int port;
 	__be16 *phdr, hdr;
+	unsigned char *dest = eth_hdr(skb)->h_dest;
+	bool is_multicast_skb = is_multicast_ether_addr(dest) &&
+				!is_broadcast_ether_addr(dest);
 
 	if (unlikely(!pskb_may_pull(skb, MTK_HDR_LEN)))
 		return NULL;
@@ -86,6 +97,10 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
+	/* Only unicast or broadcast frames are offloaded */
+	if (likely(!is_multicast_skb))
+		skb->offload_fwd_mark = 1;
+
 	return skb;
 }
 
-- 
2.26.2

