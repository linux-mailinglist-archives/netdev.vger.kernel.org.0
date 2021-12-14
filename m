Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68861474E24
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhLNWpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhLNWob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:31 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9E4FC06173E;
        Tue, 14 Dec 2021 14:44:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so67337504edb.8;
        Tue, 14 Dec 2021 14:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x5ytspfYRqVU3RtWAvC1Q4PzIaOo9sudFVOwJXe4gcg=;
        b=EtdwBl5SPttEJc8XxFn/3XItEPjM9mmvT1EJxLmjShUGvo+C4yPsJlO9K0ES1iZj7n
         8OOaygmUHKBPrayut+9LJ3KyZRFhz3L+6lqiraLRvuIYCX7sCSv+IRYC/CZ69lD0dtTp
         4Rua0wUH1DQtnmMf/ID054uxxSevgE8mZXriruFI0XMVlyyF4j3NEKS764g+gL0vFK30
         v7Gw2oyJhn3dr01n0aZ+M2JIIMSH2GdS4Sal+k9zBOw9yRXcUSIgowbNeJ+cCq4J0LVB
         HPAHKitXoPIdaZhuzN0ZasPZQMajF5Ib7x20U2ufFkSb0kelA0WUGVsWNdA8odhOSj2I
         7Qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5ytspfYRqVU3RtWAvC1Q4PzIaOo9sudFVOwJXe4gcg=;
        b=f00U2shcwqLrGIISKVyGaesgqmX8k0nOyf67tx2oyqmPopSTOe+XJlyu9VmanMGG+7
         a6QoND2Dy/cYxUJle2Fnr+Ln1ez3oVjALiHVaM3B0+0ffhXv3d14UlnJzPNCgrLOuchF
         EH9mu4g20TWzZWvgC0PBmZHgt3Av/as9azs8YQxdn1Q1AybQFTKPlhSTswoq1dVbRZvJ
         TcBLPdXVUwBs3W5aJCnD4zk7c7ZfTgBi85VEfZu+s7SNo8vBo8FbsnljojF35bW0N6AG
         XNL1vkGo7gNgXkCsaJGHczeITVgNiedjPI+qMhKKO1BBkNPugpwYea894wgO6V4DuEhS
         MjKA==
X-Gm-Message-State: AOAM533f2bYeCblCfPQtD8gxLvhyxQowS9yKBMazZCr5YWzb5kz9dMtY
        9T208RuOQmJFh/fmj+/bUnZZN1/UtGqc+g==
X-Google-Smtp-Source: ABdhPJyXdtlRjuP9hasI2Jr2L1Qeh0dQzjOGAQtLsfM0M7EFGb6GyhcPVMGmwmw41HjZThdvGXPRrA==
X-Received: by 2002:a17:906:3ed0:: with SMTP id d16mr680304ejj.636.1639521869272;
        Tue, 14 Dec 2021 14:44:29 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:29 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 08/16] net: dsa: tag_qca: add define for handling mdio Ethernet packet
Date:   Tue, 14 Dec 2021 23:44:01 +0100
Message-Id: <20211214224409.5770-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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
index c02d2d39ff4a..21cd0db5acc2 100644
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
+	__be16 hdr;		/* qca hdr */
+} __packed;
+
 #endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index f8df49d5956f..d30249b5205d 100644
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
+	/* Ethernet MDIO read/write packet */
+	if (pk_type == QCA_HDR_RECV_TYPE_RW_REG_ACK)
+		return NULL;
+
 	/* Remove QCA tag and recalculate checksum */
 	skb_pull_rcsum(skb, QCA_HDR_LEN);
 	dsa_strip_etype_header(skb, QCA_HDR_LEN);
-- 
2.33.1

