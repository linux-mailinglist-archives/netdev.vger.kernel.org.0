Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C57B4715F0
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhLKT61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhLKT6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:25 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47613C061370;
        Sat, 11 Dec 2021 11:58:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x10so22639091edd.5;
        Sat, 11 Dec 2021 11:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ghuRnkH4HtqhvLP+gWI52+wo0xajxLGtqW/dt5vEnHs=;
        b=KlA5fa81MUQTgzm486MoAc3E0qyCi++oXr1Ff0AUD1g3Bqs72wPdHfg24sTTFEaREy
         D+Ati339LNUrwB/CGyFsvkpfmtMemXy3HqsAmCOG/HX4L9rLUgUP3zJe/kMipWNmg1jV
         y3tWfSmQm1Y3/1KEFf1BPcc5L49BpG7liqLcQ3TI1ddoLquqMpmAhhte39OMsqy1cgz4
         X9ul+E5pSL9TZIhE9tKHtYcbRfQJUp0Pq7xhRkxONYswPmRe0WnjgQlVKdzpisGGh+kg
         iGupVonoHH/oJyq7xL5QfI+EGO9i9wouiq+II7srsQ8Ev2D3Cpf0Vnt/B4M0++gQjmp2
         7klw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ghuRnkH4HtqhvLP+gWI52+wo0xajxLGtqW/dt5vEnHs=;
        b=go2v9biiloflWZJPFZ/IgF0c1kZwxMnnHn2FEsJgxSEv42/kF+sqYsJbENKkkNjBAr
         EhmMAUM+waCrVmJ8Ka6ucKdRhR4XqqJ88/DQWkzkwAsJordJN5727TFEBNV1LigslaOc
         J4dV8Vb2SKx4ONyoqGReIsyX/wvabhDClkzRds5uJFux9t/NxdVSm1tE+wzop215e5C2
         U9H6ZVqNrU7UY/Px+BZ7wkVZPdape7hXoETt+wq3+oGH6RbZZEcjkAAeW/CjRr9mbxeN
         N16rBM4Pb1WM/GswsvzHcyU57RaTg6V/V65oufmMbwYsxw3Rg0/sLqQ7nLGarEvfy2b1
         Gw4g==
X-Gm-Message-State: AOAM532ERwfZOHgqEQRWXivHNUE9b/FwPX8HEgRxex7OFlmS1ptNC3g7
        9xvZI/bdHKpOHpoiBpq3c5s=
X-Google-Smtp-Source: ABdhPJw0XZsuDMlsR+Lsqbg+u8IuzTVdIwQSOyVhc3eB6/3KhiCGHxYP4EoO4E2sGgK9E5zNizzntA==
X-Received: by 2002:a17:907:3d94:: with SMTP id he20mr35119532ejc.75.1639252702743;
        Sat, 11 Dec 2021 11:58:22 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:22 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 08/15] net: dsa: tag_qca: add define for handling mdio Ethernet packet
Date:   Sat, 11 Dec 2021 20:57:51 +0100
Message-Id: <20211211195758.28962-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
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
index f8df49d5956f..b91f9f1b2deb 100644
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

