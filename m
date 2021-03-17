Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB8733EE4F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhCQKaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhCQK3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:29:31 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D443EC06175F;
        Wed, 17 Mar 2021 03:29:30 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k8so1245019wrc.3;
        Wed, 17 Mar 2021 03:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TPC5hiXs4U7eKpmJ6kbI/9E6CX/coyn3imzMMNXx7ms=;
        b=PY7BQxydny5nwobVyPf5Ogsq5ONCh64CrjrIpIyizj5SmJLCpoNG3YDdt+uA2VpcIa
         Th+UqUgdIqRhJgRnxbekdlUjqGaUKDE1K6F8UhFlve19jGf+9JQ2ah/yE2TBK/1JNwbI
         rMsPrIOVr/jbPMS+nkCNMU/gyyPooumc5xhZfONW1e/5xkDBiYz3SRodKXJPkTyY7+Y+
         6q0v7O9jorglAo2W9Ru3gopP0Wot//haOdr2nhitDK5pmCotuh6K9Z50BPcORa2n9RE3
         kUHTFF0teugJzCK+3Fd5Cl/cplvHzfkUfFSo/ehbgt2OxgcPDriVRXOBizdPyRxyxYhT
         4MGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPC5hiXs4U7eKpmJ6kbI/9E6CX/coyn3imzMMNXx7ms=;
        b=WgVHLb0TMC33XY0T7Z8LslzMjnTX2c6ZINAMcXfycGjbKrsRhivq12XvTSVFJqEQjH
         8aPJ9hyiaqFY/fepWFipPkRMkbYMz9MjFYRVRX3zsmS5cVBYASTQWgB540bfHLmUCMwL
         iKCYNET4MriJh8vhXkPOMd3yPbMQmcmYRaL8wZe+2lRrxTdENKxql8fx9Nu9vnF9ehX6
         ZqnFBi4zM5gv4JJzKFGh6cEJc4WKk6wCGcG96VoTq9CM3EH0Vsw1RcN3aC/+yJkkDkXD
         H8Zl8aCVyq14DsWE8VSaJmoju0Jg5+Q4Ex4nvWutNDU7Px8J6WFr7T9rLRhSVTOYz034
         10pA==
X-Gm-Message-State: AOAM531dymTWbX8y315yK/D+6aBVYhU/zhiXOjac/O+5+n7X3g7apn2B
        TEnyW1XpiWUlntbdORJetIHMHLllrec0aQ==
X-Google-Smtp-Source: ABdhPJwcQyGsTkUFvMEoyBzVRP3LR0c6NK3Yh6n5OlezWuVIWjdMEzP1kRBxpIgW4NrwUgiIjQOSmA==
X-Received: by 2002:adf:fb8a:: with SMTP id a10mr3575820wrr.365.1615976969528;
        Wed, 17 Mar 2021 03:29:29 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id y18sm25342493wrw.39.2021.03.17.03.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 03:29:29 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 net-next 1/2] net: dsa: tag_brcm: add support for legacy tags
Date:   Wed, 17 Mar 2021 11:29:26 +0100
Message-Id: <20210317102927.25605-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210317102927.25605-1-noltari@gmail.com>
References: <20210317102927.25605-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for legacy Broadcom tags, which are similar to DSA_TAG_PROTO_BRCM.
These tags are used on BCM5325, BCM5365 and BCM63xx switches.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 v2: introduce changes requested by Florian and Vladimir.

 include/net/dsa.h  |   2 +
 net/dsa/Kconfig    |   7 +++
 net/dsa/tag_brcm.c | 107 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..dac303edd33d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -49,10 +49,12 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
+#define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
 	DSA_TAG_PROTO_BRCM		= DSA_TAG_PROTO_BRCM_VALUE,
+	DSA_TAG_PROTO_BRCM_LEGACY	= DSA_TAG_PROTO_BRCM_LEGACY_VALUE,
 	DSA_TAG_PROTO_BRCM_PREPEND	= DSA_TAG_PROTO_BRCM_PREPEND_VALUE,
 	DSA_TAG_PROTO_DSA		= DSA_TAG_PROTO_DSA_VALUE,
 	DSA_TAG_PROTO_EDSA		= DSA_TAG_PROTO_EDSA_VALUE,
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 58b8fc82cd3c..aaf8a452fd5b 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -48,6 +48,13 @@ config NET_DSA_TAG_BRCM
 	  Say Y if you want to enable support for tagging frames for the
 	  Broadcom switches which place the tag after the MAC source address.
 
+config NET_DSA_TAG_BRCM_LEGACY
+	tristate "Tag driver for Broadcom legacy switches using in-frame headers"
+	select NET_DSA_TAG_BRCM_COMMON
+	help
+	  Say Y if you want to enable support for tagging frames for the
+	  Broadcom legacy switches which place the tag after the MAC source
+	  address.
 
 config NET_DSA_TAG_BRCM_PREPEND
 	tristate "Tag driver for Broadcom switches using prepended headers"
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e2577a7dcbca..40e9f3098c8d 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -12,9 +12,26 @@
 
 #include "dsa_priv.h"
 
-/* This tag length is 4 bytes, older ones were 6 bytes, we do not
- * handle them
- */
+/* Legacy Broadcom tag (6 bytes) */
+#define BRCM_LEG_TAG_LEN	6
+
+/* Type fields */
+/* 1st byte in the tag */
+#define BRCM_LEG_TYPE_HI	0x88
+/* 2nd byte in the tag */
+#define BRCM_LEG_TYPE_LO	0x74
+
+/* Tag fields */
+/* 3rd byte in the tag */
+#define BRCM_LEG_UNICAST	(0 << 5)
+#define BRCM_LEG_MULTICAST	(1 << 5)
+#define BRCM_LEG_EGRESS		(2 << 5)
+#define BRCM_LEG_INGRESS	(3 << 5)
+
+/* 6th byte in the tag */
+#define BRCM_LEG_PORT_ID	(0xf)
+
+/* Newer Broadcom tag (4 bytes) */
 #define BRCM_TAG_LEN	4
 
 /* Tag is constructed and desconstructed using byte by byte access
@@ -195,6 +212,87 @@ DSA_TAG_DRIVER(brcm_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM);
 #endif
 
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
+static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 *brcm_tag;
+
+	/* The Ethernet switch we are interfaced with needs packets to be at
+	 * least 64 bytes (including FCS) otherwise they will be discarded when
+	 * they enter the switch port logic. When Broadcom tags are enabled, we
+	 * need to make sure that packets are at least 70 bytes
+	 * (including FCS and tag) because the length verification is done after
+	 * the Broadcom tag is stripped off the ingress packet.
+	 *
+	 * Let dsa_slave_xmit() free the SKB
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN + BRCM_LEG_TAG_LEN, false))
+		return NULL;
+
+	skb_push(skb, BRCM_LEG_TAG_LEN);
+
+	memmove(skb->data, skb->data + BRCM_LEG_TAG_LEN, 2 * ETH_ALEN);
+
+	brcm_tag = skb->data + 2 * ETH_ALEN;
+
+	/* Broadcom tag type */
+	brcm_tag[0] = BRCM_LEG_TYPE_HI;
+	brcm_tag[1] = BRCM_LEG_TYPE_LO;
+
+	/* Broadcom tag value */
+	brcm_tag[2] = BRCM_LEG_EGRESS;
+	brcm_tag[3] = 0;
+	brcm_tag[4] = 0;
+	brcm_tag[5] = dp->index & BRCM_LEG_PORT_ID;
+
+	return skb;
+}
+
+static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
+					struct net_device *dev,
+					struct packet_type *pt)
+{
+	int source_port;
+	u8 *brcm_tag;
+
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
+		return NULL;
+
+	brcm_tag = skb->data - 2;
+
+	source_port = brcm_tag[5] & BRCM_LEG_PORT_ID;
+
+	skb->dev = dsa_master_find_slave(dev, 0, source_port);
+	if (!skb->dev)
+		return NULL;
+
+	/* Remove Broadcom tag and update checksum */
+	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
+
+	skb->offload_fwd_mark = 1;
+
+	/* Move the Ethernet DA and SA */
+	memmove(skb->data - ETH_HLEN,
+		skb->data - ETH_HLEN - BRCM_LEG_TAG_LEN,
+		2 * ETH_ALEN);
+
+	return skb;
+}
+
+static const struct dsa_device_ops brcm_legacy_netdev_ops = {
+	.name = "brcm-legacy",
+	.proto = DSA_TAG_PROTO_BRCM_LEGACY,
+	.xmit = brcm_leg_tag_xmit,
+	.rcv = brcm_leg_tag_rcv,
+	.overhead = BRCM_LEG_TAG_LEN,
+};
+
+DSA_TAG_DRIVER(brcm_legacy_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY);
+#endif /* CONFIG_NET_DSA_TAG_BRCM_LEGACY */
+
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
 static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
 					     struct net_device *dev)
@@ -227,6 +325,9 @@ static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
 	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
 #endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
+	&DSA_TAG_DRIVER_NAME(brcm_legacy_netdev_ops),
+#endif
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
 	&DSA_TAG_DRIVER_NAME(brcm_prepend_netdev_ops),
 #endif
-- 
2.20.1

