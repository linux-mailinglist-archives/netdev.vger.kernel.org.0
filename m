Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E616496F6B
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbiAWBdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235250AbiAWBdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F2BC06173B;
        Sat, 22 Jan 2022 17:33:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jx6so11145843ejb.0;
        Sat, 22 Jan 2022 17:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yEOkwNspPx3lKpy8AeAYGfMOyn3+W//EP56OLlBrqys=;
        b=X1Uwhken5/yfP2SYg6vFmMqbNZh261wMwVHfqE6t0ix397QZUKRRrOMg378PnvkrzD
         6tACmZaoRbDTq9OC8cG6HCNZJUiIC2BWpumCD+EGlmW8urrnvj6IenCfO+wjDpOtcA+6
         n9FDdRS6dkYrJaGug+ykmcmSYMBK/ZgSetNnda8KeqjxU5ahZyDYjoRTQNVH/Hre1bkx
         BrbN6MK8lQOy0KWV/CxWXVyOn2BJrkUXsMsQeIAowcDOuaGjkLKmwO859l0CimQENxRy
         gvK8gn5FlOVeODmKS3YybI+1MouMo8aIfQrqQ98UWu7zprRwk0cIp32ut9K38r1qEicA
         W9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yEOkwNspPx3lKpy8AeAYGfMOyn3+W//EP56OLlBrqys=;
        b=0DHfGROTJeJ9Qw3hGE5fNYMpmQT/wb/C+hfIE+q4THDd7XkpF7JHOqkwzZbWTKQw8O
         1vxyqe+GKx6zqj8SNjCTMsa8NwHCJfsAX3Pjfnr50hCZYBbGn6MD/F46yjXZS6AKCdqw
         DCIs2Cebgy2iDPM9nik866mIK2iv+mUeNjrchcwt7nxkyBmBa47OPzeSo1x6vJ04ovSE
         AUjJObJ3Q3S5DGODgjmPNy0jou59yLfRzsB8FjhyQQBPJMATdW1g7sYE82X5xlC8SJNp
         EV3NteKJHaqtqHl2TK+G+akpYSMf0bKfl8tnZYvUEZUBUs7qbCtLa3q5VkjdEahX4I8S
         AvEQ==
X-Gm-Message-State: AOAM532/hlQ4gbO2PTGYKrgLWAZ4ne0x9CjHodCF1vSfJTDabHf3lqz7
        KZ4qWCncMFhMwmED/fw7xAk=
X-Google-Smtp-Source: ABdhPJwNJDy/0vTw1jho44XtoiMub7wQwLq9wyohKkBRDfNaFkuz8YMkQ05D15kTVIc8m/A9HxWzYg==
X-Received: by 2002:a17:907:7253:: with SMTP id ds19mr8285854ejc.26.1642901627337;
        Sat, 22 Jan 2022 17:33:47 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:47 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 06/16] net: dsa: tag_qca: add define for handling mgmt Ethernet packet
Date:   Sun, 23 Jan 2022 02:33:27 +0100
Message-Id: <20220123013337.20945-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add all the required define to prepare support for mgmt read/write in
Ethernet packet. Any packet of this type has to be dropped as the only
use of these special packet is receive ack for an mgmt write request or
receive data for an mgmt read request.
A struct is used that emulates the Ethernet header but is used for a
different purpose.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/linux/dsa/tag_qca.h | 44 +++++++++++++++++++++++++++++++++++++
 net/dsa/tag_qca.c           | 13 ++++++++---
 2 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index c02d2d39ff4a..1a02f695f3a3 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -12,10 +12,54 @@
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
+/* Check code for a valid mgmt packet. Switch will ignore the packet
+ * with this wrong.
+ */
+#define QCA_HDR_MGMT_CHECK_CODE_VAL	0x5
+
+/* Specific define for in-band MDIO read/write with Ethernet packet */
+#define QCA_HDR_MGMT_SEQ_LEN		4 /* 4 byte for the seq */
+#define QCA_HDR_MGMT_COMMAND_LEN	4 /* 4 byte for the command */
+#define QCA_HDR_MGMT_DATA1_LEN		4 /* First 4 byte for the mdio data */
+#define QCA_HDR_MGMT_HEADER_LEN		(QCA_HDR_MGMT_SEQ_LEN + \
+					QCA_HDR_MGMT_COMMAND_LEN + \
+					QCA_HDR_MGMT_DATA1_LEN)
+
+#define QCA_HDR_MGMT_DATA2_LEN		12 /* Other 12 byte for the mdio data */
+#define QCA_HDR_MGMT_PADDING_LEN	34 /* Padding to reach the min Ethernet packet */
+
+#define QCA_HDR_MGMT_PKG_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
+					QCA_HDR_LEN + \
+					QCA_HDR_MGMT_DATA2_LEN + \
+					QCA_HDR_MGMT_PADDING_LEN)
+
+#define QCA_HDR_MGMT_SEQ_NUM		GENMASK(31, 0)  /* 63, 32 */
+#define QCA_HDR_MGMT_CHECK_CODE		GENMASK(31, 29) /* 31, 29 */
+#define QCA_HDR_MGMT_CMD		BIT(28)		/* 28 */
+#define QCA_HDR_MGMT_LENGTH		GENMASK(23, 20) /* 23, 20 */
+#define QCA_HDR_MGMT_ADDR		GENMASK(18, 0)  /* 18, 0 */
+
+/* Special struct emulating a Ethernet header */
+struct mgmt_ethhdr {
+	u32 command;		/* command bit 31:0 */
+	u32 seq;		/* seq 63:32 */
+	u32 mdio_data;		/* first 4byte mdio */
+	__be16 hdr;		/* qca hdr */
+} __packed;
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index f8df49d5956f..c57d6e1a0c0c 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,10 +32,10 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	u8 ver;
-	u16  hdr;
-	int port;
+	u16 hdr, pk_type;
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
+	/* Ethernet MDIO read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+		return NULL;
+
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
 	dsa_strip_etype_header(skb, QCA_HDR_LEN);
-- 
2.33.1

