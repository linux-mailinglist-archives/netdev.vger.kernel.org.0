Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275047106B
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345897AbhLKCGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345789AbhLKCGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:09 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A6AC061D76;
        Fri, 10 Dec 2021 18:02:27 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id w1so35038344edc.6;
        Fri, 10 Dec 2021 18:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XMNmsVbZ++MHzR0SNpTs4rnf9cjrjDzn4muZEXZ4TMk=;
        b=h2rDtHVCDMnR39f0WCy4t4URa4EXDrJjIN9jRBrs1BLjYmeH2NP5NJIM/CrSrylHo9
         DpjdWoMTRtw92HRcXOLHvkwT5syGfHLmtUiw+9LKRBW14xb2Agq9nQ+j75Se1ZV+FmrM
         R1o7ZCUNPeZsnEbGMm2wBcQVRJmdV3BUcD2iAuni8P3SVuCcLadI55YT6+jSlCT1Z1IS
         +kdkBGodowWCbefN81O9Qqa4mJ+QMwUn7/YYT+cSwFR2E6q1ADqdf2PXhMPvMIACegBo
         f9ayEOtZUPqU4FZ8g7r40uvRhhONOR4deHaps1lyaUVg6DEWgqeZUYhAQvLh4pwy0tNS
         Rynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XMNmsVbZ++MHzR0SNpTs4rnf9cjrjDzn4muZEXZ4TMk=;
        b=44JCzKdne1ezE62Jtdy+IkMQ7crtCpk9DUrAi6ZzaX4A1VGfefpdP3k2wqt+zrXbRD
         tKL40h+jGF7L06bM6k5zXljaE+nXKm01v+kUpH7RZ785Bhs763ms/+eNrtUWH81E9CPA
         0RkA0wLzpI9hjBbNu9UZZ4ExeG+CfbddoszbBwTCqTJ1672ueMM+MZLwYKSx+yQuVeSa
         9CNOiefyYGDizt30rPPC024hKx/MwWjZyMsrwpoFJEQZzQ/zOtic5ydlGOmGv+G0jRv0
         2xXFyiP4kcHMfA2flsZU3tkDqT9HYlDtJzOAAbBxA47hIAtASVhBfs8nihlVK2BRVBeb
         PXqA==
X-Gm-Message-State: AOAM532SgPkd7KPFq2DMg8CQ35W1Lh2UZj0aEZpDi30nAgG9qxmFBbyf
        l6EKkazZA3iav/ttt7Fp2TjUZ5EdbMML9A==
X-Google-Smtp-Source: ABdhPJxdNv8+4oicE/VXmSwpPKKQSX56uGekkvqbt9sCEU8kx2RMLYUqB/p4VVHY7hs/1HKUz7adkw==
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr28419164ejc.391.1639188145947;
        Fri, 10 Dec 2021 18:02:25 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:25 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v3 07/14] net: dsa: tag_qca: add define for handling mdio Ethernet packet
Date:   Sat, 11 Dec 2021 03:01:40 +0100
Message-Id: <20211211020155.10114-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
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

