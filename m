Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E92B46BE89
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbhLGPD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbhLGPD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:03:26 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919FDC061574;
        Tue,  7 Dec 2021 06:59:55 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id o20so58127155eds.10;
        Tue, 07 Dec 2021 06:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnLY6KdcrRoSIU2HsNb3g6e/hZnKqFQfK2cCOCiEGu8=;
        b=FwlswY2kH0PP3CjZJuneVkfGs3NCjIJsQyRrjYR/7s9LpdX01sqKgcq3n2aEGMyo/f
         qjNQHxWkOwqgJqOJNGv4F+/eX90I+OYGhTVIiDpUTG1YZYtwfjvq37vZGP1iagNRglUR
         OW01dVn4KXijRCL/S2XmlLg3hK/pW3LxWm1xGor9bRkup7QKIP+RDMw1CrMNd1YZ+5sQ
         1KsJugM/jsCvcY1r+/TyQAvgbMtTJqo22dfQJeqiXcbIOr63xkmNjGk4N5AtyU7i1YJq
         GEhwg7juvR7QEEmPNhOGL03Bdz1wyPOtGtJV5vz1Nyo6bS5znyNbj/UDgNCLCBeuh/Fx
         jqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnLY6KdcrRoSIU2HsNb3g6e/hZnKqFQfK2cCOCiEGu8=;
        b=pSZBwvAXMYD8YEREZqizFgBQ2QI4oiO61W3b5SU/37IQRoOgOOGaG7c+gxY4hSyEAV
         Pd9n+f1wb2HdttPsHjg2ptmqN9g5keiWcjdPak7KNgE9erHladEZ5ROqnhw4dCR1YUzB
         2TC3YYhh4oviVG7W5ccE3eNKOWbiaDMndlo7iht/v2nZazMG3RoUPlNjyWL6aQ8aYO+c
         54C4vC1+7/RLHtoq5ZbZh4mxwR2+X0wcYWzkE+up9pCkZy0hu3JUHCH+Hk1kI2Xq93//
         MjbqOPGuiCkjWhu1bo68PF4+RXQTIMRi1/Xnqmili5jgN5IrgbF6mpGwt4LGHlvlqQFp
         rBQQ==
X-Gm-Message-State: AOAM533wYdQHBvvicH0tcEOyLOJ+ZXgOXNIbWGKvGwEAK2JOSsSGABBT
        4vEeY55jdJZIOGAJ+3lHOyM=
X-Google-Smtp-Source: ABdhPJzmC2umJwzvGZ/4s0BrQHaubd1tXdCf12pHZVYYNOPKeba6nbpSZxa7R+M9dvFYZs4aZMRyww==
X-Received: by 2002:a05:6402:270a:: with SMTP id y10mr10120374edd.152.1638889194067;
        Tue, 07 Dec 2021 06:59:54 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id i10sm9131821ejw.48.2021.12.07.06.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:59:53 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 1/6] net: dsa: tag_qca: convert to FIELD macro
Date:   Tue,  7 Dec 2021 15:59:37 +0100
Message-Id: <20211207145942.7444-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert driver to FIELD macro to drop redundant define.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/tag_qca.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 1ea9401b8ace..55fa6b96b4eb 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -4,29 +4,24 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/bitfield.h>
 
 #include "dsa_priv.h"
 
 #define QCA_HDR_LEN	2
 #define QCA_HDR_VERSION	0x2
 
-#define QCA_HDR_RECV_VERSION_MASK	GENMASK(15, 14)
-#define QCA_HDR_RECV_VERSION_S		14
-#define QCA_HDR_RECV_PRIORITY_MASK	GENMASK(13, 11)
-#define QCA_HDR_RECV_PRIORITY_S		11
-#define QCA_HDR_RECV_TYPE_MASK		GENMASK(10, 6)
-#define QCA_HDR_RECV_TYPE_S		6
+#define QCA_HDR_RECV_VERSION		GENMASK(15, 14)
+#define QCA_HDR_RECV_PRIORITY		GENMASK(13, 11)
+#define QCA_HDR_RECV_TYPE		GENMASK(10, 6)
 #define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
-#define QCA_HDR_RECV_SOURCE_PORT_MASK	GENMASK(2, 0)
-
-#define QCA_HDR_XMIT_VERSION_MASK	GENMASK(15, 14)
-#define QCA_HDR_XMIT_VERSION_S		14
-#define QCA_HDR_XMIT_PRIORITY_MASK	GENMASK(13, 11)
-#define QCA_HDR_XMIT_PRIORITY_S		11
-#define QCA_HDR_XMIT_CONTROL_MASK	GENMASK(10, 8)
-#define QCA_HDR_XMIT_CONTROL_S		8
+#define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
+
+#define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
+#define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
+#define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
 #define QCA_HDR_XMIT_FROM_CPU		BIT(7)
-#define QCA_HDR_XMIT_DP_BIT_MASK	GENMASK(6, 0)
+#define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
 
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
@@ -40,8 +35,9 @@ static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 	phdr = dsa_etype_header_pos_tx(skb);
 
 	/* Set the version field, and set destination port information */
-	hdr = QCA_HDR_VERSION << QCA_HDR_XMIT_VERSION_S |
-		QCA_HDR_XMIT_FROM_CPU | BIT(dp->index);
+	hdr = FIELD_PREP(QCA_HDR_XMIT_VERSION, QCA_HDR_VERSION);
+	hdr |= QCA_HDR_XMIT_FROM_CPU;
+	hdr |= FIELD_PREP(QCA_HDR_XMIT_DP_BIT, BIT(dp->index));
 
 	*phdr = htons(hdr);
 
@@ -62,7 +58,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	hdr = ntohs(*phdr);
 
 	/* Make sure the version is correct */
-	ver = (hdr & QCA_HDR_RECV_VERSION_MASK) >> QCA_HDR_RECV_VERSION_S;
+	ver = FIELD_GET(QCA_HDR_RECV_VERSION, hdr);
 	if (unlikely(ver != QCA_HDR_VERSION))
 		return NULL;
 
@@ -71,7 +67,7 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 	dsa_strip_etype_header(skb, QCA_HDR_LEN);
 
 	/* Get source port information */
-	port = (hdr & QCA_HDR_RECV_SOURCE_PORT_MASK);
+	port = FIELD_GET(QCA_HDR_RECV_SOURCE_PORT, hdr);
 
 	skb->dev = dsa_master_find_slave(dev, 0, port);
 	if (!skb->dev)
-- 
2.32.0

