Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD04A68EE
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbiBBAE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243145AbiBBAEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:25 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A1EC06174A;
        Tue,  1 Feb 2022 16:04:19 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m11so38002726edi.13;
        Tue, 01 Feb 2022 16:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NWpirHr7xz0axhTCxQ8W5MwmXAc22jCIlKyLJIrm6Hc=;
        b=MMukD2AevWbDF/UazU0MletjOoghfvT0Y3xour8aGWT5wtxrvPL82JRSYT1GR4GD3z
         zCN+8QWGMA4LG12v1SsZYj8IJ1GhHCZ25KPFwtmcFFT4M9M63wo30NU2PiZ0XtKi+uX3
         uRw2+cQdDxNpQskqB6N6xFJiJ6D8o/u2xVFq/Ve2nKMcCeFPY4LBYauZN2eeuJldQ/LV
         zG8FR6exCe/MjmH818KcETsbcqr0RwvmanLoTMBfYwgc9sSUC7qrSVyxDb/5kFWi0qrv
         09b6+72GXDR+zBYju9wjq8+mLLn+IP6TLP2+42G1nPTBntc1aGJiXMivn2O7nBY+lyZz
         TlqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NWpirHr7xz0axhTCxQ8W5MwmXAc22jCIlKyLJIrm6Hc=;
        b=Vpi0SjQsC5e+nljWwFN8+w465vlAxRz8wXArOwPOPUJsTHhdtNdWgYZlhXm7FZLO98
         7SCQTjM5fFrfGaNqc3Ebd+c+gnl5neoxnmGidIHOS0sFGUZ2cL34Rk6AdwDBErpwzC62
         SJN7GFjy5SgUAGv4e6RZlrAGvWlPFoz9/GyO53Wow202JKJlbiYTApYnxPMCmniHkXnG
         ecleUtMq8avEXTgp+2UxtvxNJqwdyhwx47WZXJwHgeUxucxVKK1+bfF4kwAIPYVnflKO
         ikGm2Zar6L5sJlUF6O62l4M67hxbhTISDWMc2fFpY33ima2J2X4lyCspsUYUBYimxM4k
         01jA==
X-Gm-Message-State: AOAM532O9X4GcX3XBEfCdb61qsrvn2aLQYygfRT6qgTmpctk/BpOEWou
        Q0lb/JnQj05yrRDZP4VXKWg=
X-Google-Smtp-Source: ABdhPJzLDZjxsK2m0Xr00ADA6dxedIo5gF1460U1oZk/GzQmFgD/EqlysQiutSb7yZvOsDjOdYLNtw==
X-Received: by 2002:aa7:d856:: with SMTP id f22mr27670355eds.324.1643760257819;
        Tue, 01 Feb 2022 16:04:17 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:17 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 06/16] net: dsa: tag_qca: add define for handling mgmt Ethernet packet
Date:   Wed,  2 Feb 2022 01:03:25 +0100
Message-Id: <20220202000335.19296-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/dsa/tag_qca.h | 44 +++++++++++++++++++++++++++++++++++++
 net/dsa/tag_qca.c           | 15 ++++++++++---
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index c02d2d39ff4a..f366422ab7a0 100644
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
+#define QCA_HDR_MGMT_PKT_LEN		(QCA_HDR_MGMT_HEADER_LEN + \
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
+struct qca_mgmt_ethhdr {
+	u32 command;		/* command bit 31:0 */
+	u32 seq;		/* seq 63:32 */
+	u32 mdio_data;		/* first 4byte mdio */
+	__be16 hdr;		/* qca hdr */
+} __packed;
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index f8df49d5956f..f17ed5be20c2 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -32,10 +32,12 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 
 static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 {
-	u8 ver;
-	u16  hdr;
-	int port;
+	u8 ver, pk_type;
 	__be16 *phdr;
+	int port;
+	u16 hdr;
+
+	BUILD_BUG_ON(sizeof(struct qca_mgmt_ethhdr) != QCA_HDR_MGMT_HEADER_LEN + QCA_HDR_LEN);
 
 	if (unlikely(!pskb_may_pull(skb, QCA_HDR_LEN)))
 		return NULL;
@@ -48,6 +50,13 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
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

