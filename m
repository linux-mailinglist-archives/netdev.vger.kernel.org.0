Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F79446CBA7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243989AbhLHDo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243970AbhLHDo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:26 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0A9C061574;
        Tue,  7 Dec 2021 19:40:55 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 133so861824wme.0;
        Tue, 07 Dec 2021 19:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XMNmsVbZ++MHzR0SNpTs4rnf9cjrjDzn4muZEXZ4TMk=;
        b=LzxOMCctLA4n6xsLsMi5+j4ym2ObaBzoow/5Tisghk/TGNWsVyYWvTX1kpPWcltEUq
         Chq+Ay+D50fplVboRswIBW8KOVPAzsiTB+cZkqj14GWkSM62FnVG7NbwJncdGYhLCgyW
         RzcIZaFNB+AoMEXuq4muHrlLxzlppfeSZp01/xaUAntgbRqaImDTyaELv1XQQV99ImzI
         6UzZQJxhXX3J3I4+6Z6BLSZmB5F79aE2ecuSUGgXYI1pV0e2Bo+i5ul07QUYCCnnr5Io
         z0n/XxmJzYKthYXRt0dCIGXuNhDNuC756VsVG5Ax4OO+rLVDDrl7zpQFH4aXpydf+MGS
         C13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XMNmsVbZ++MHzR0SNpTs4rnf9cjrjDzn4muZEXZ4TMk=;
        b=LQFBy8RRwhn9sCgD9DEPyZUzlhrVeDcB/xBqqUa/02sEvy+INcDP4Q60a9OhJ0hotE
         CHNDXuQZ+9pAtqFvTm8bzi/XKF7aRGR4bnwIX4Q8tM9enpG8DW+GYSBXvSvinemkIvds
         1iTZcXRWHVY8FFasH9vnCGTF2gsyM+kuesFsVpzsTTj+ix9F/N/iGfWWq2fZvV7T2zpW
         u9JzZFm9oTi7ru0J6cd2befLrIYW5z1NT1Wj7QEGwXInrX1RfC1vEBU6ALqvrxfhFqOs
         /GaWwEVX8v1A0I0WwbYJWfg0R+EyaL9dJVRHX2j5ajArU4cUOfRY1vW1F00TstUP+/51
         Xcxw==
X-Gm-Message-State: AOAM531AYCY2gc1IdcSImNNjdzMGIj1lI7O2gCyGvk4TKG6WWEAYMjCO
        Z8oWIKglCH5jkN+8b0NQX5M=
X-Google-Smtp-Source: ABdhPJz9Mk0xxcFDXK1tjwepugJ+8YAEA67ceRW2Uq+fP4nidTmTlk0CfpI/ZzKahry5tnm3Nrr31w==
X-Received: by 2002:a05:600c:a0b:: with SMTP id z11mr12611391wmp.147.1638934853900;
        Tue, 07 Dec 2021 19:40:53 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:53 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 5/8] net: dsa: tag_qca: add define for mdio read/write in ethernet packet
Date:   Wed,  8 Dec 2021 04:40:37 +0100
Message-Id: <20211208034040.14457-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all the required define to prepare support for mdio read/write in
Ethernet packet. Any packet of this type has to be dropped as the only
use of these special packet is receive ack for an mdio write request or
receive data for an mdio read request.
A struct is used that emulates the Ethernet header but is used for a
different purpose.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/linux/dsa/tag_qca.h | 41 +++++++++++++++++++++++++++++++++++++
 net/dsa/tag_qca.c           | 13 +++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index c02d2d39ff4a..578a4aeafd92 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -12,10 +12,51 @@
 #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
 #define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
 
+/* Packet type for recv */
+#define QCA_HDR_RECV_TYPE_NORMAL	0x0
+#define QCA_HDR_RECV_TYPE_MIB		0x1
+#define QCA_HDR_RECV_TYPE_RW_REG_ACK	0x2
+
 #define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
 #define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
 #define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
 #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
 #define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
 
+/* Packet type for xmit */
+#define QCA_HDR_XMIT_TYPE_NORMAL	0x0
+#define QCA_HDR_XMIT_TYPE_RW_REG	0x1
+
+#define MDIO_CHECK_CODE_VAL		0x5
+
+/* Specific define for in-band MDIO read/write with Ethernet packet */
+#define QCA_HDR_MDIO_SEQ_LEN		4 /* 4 byte for the seq */
+#define QCA_HDR_MDIO_COMMAND_LEN	4 /* 4 byte for the command */
+#define QCA_HDR_MDIO_DATA1_LEN		4 /* First 4 byte for the mdio data */
+#define QCA_HDR_MDIO_HEADER_LEN		(QCA_HDR_MDIO_SEQ_LEN + \
+					QCA_HDR_MDIO_COMMAND_LEN + \
+					QCA_HDR_MDIO_DATA1_LEN)
+
+#define QCA_HDR_MDIO_DATA2_LEN		12 /* Other 12 byte for the mdio data */
+#define QCA_HDR_MDIO_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
+
+#define QCA_HDR_MDIO_PKG_LEN		(QCA_HDR_MDIO_HEADER_LEN + \
+					QCA_HDR_LEN + \
+					QCA_HDR_MDIO_DATA2_LEN + \
+					QCA_HDR_MDIO_PADDING_LEN)
+
+#define QCA_HDR_MDIO_SEQ_NUM		GENMASK(31, 0)  /* 63, 32 */
+#define QCA_HDR_MDIO_CHECK_CODE		GENMASK(31, 29) /* 31, 29 */
+#define QCA_HDR_MDIO_CMD		BIT(28)		/* 28 */
+#define QCA_HDR_MDIO_LENGTH		GENMASK(23, 20) /* 23, 20 */
+#define QCA_HDR_MDIO_ADDR		GENMASK(18, 0)  /* 18, 0 */
+
+/* Special struct emulating a Ethernet header */
+struct mdio_ethhdr {
+	u32 command;		/* command bit 31:0 */
+	u32 seq;		/* seq 63:32 */
+	u32 mdio_data;		/* first 4byte mdio */
+	u16 hdr;		/* qca hdr */
+} __packed;
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 34e565e00ece..b8b05d54a74c 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,10 +32,10 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	u8 ver;
-	u16  hdr;
-	int port;
+	u16  hdr, pk_type;
 	__be16 *phdr;
+	int port;
+	u8 ver;
 
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
@@ -48,6 +48,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	if (unlikely(ver != QCA_HDR_VERSION))
 		return NULL;
 
+	/* Get pk type */
+	pk_type = FIELD_GET(QCA_HDR_RECV_TYPE, hdr);
+
+	/* MDIO read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+		return NULL;
+
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
 	dsa_strip_etype_header(skb, QCA_HDR_LEN);
-- 
2.32.0

