Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99228496F6A
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbiAWBdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiAWBdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:46 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE91EC06173B;
        Sat, 22 Jan 2022 17:33:45 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ah7so11082701ejc.4;
        Sat, 22 Jan 2022 17:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPHCW224dbQX+hfHQkJaGaEhoEvlqsOfdITuUUKo/eY=;
        b=jgsqe1o0sN5fWZbFEy/0obs+MBB6lXyQEgErvq54F+PJ3qNurAmM1Tfd9VSzwPfbwD
         2zqc9aG3dPLJ5lA38/kFtWOTtGlyZ7EKnmFdQs0RxkOVEo7TwKujTicZrQRS4IJ4f/+d
         75lfi/BMoYji5uqc066cdeqKZC+wiUdhdWbOPSru+ocpWrMssTeoM1VqcOdAa13pk9n1
         6xsTDFMY08V3wW0r6WxrAtnYFwXNzJ7GKNTZwNwURzruYnpxH7Gi49tXsTFTXYUeemRP
         8oukSOnVnPjTehOeZbzly3/PWIOTxR0e5TDkbEuV1w7SnwYdkYmGq+JDbOYjdqXMotfZ
         xFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPHCW224dbQX+hfHQkJaGaEhoEvlqsOfdITuUUKo/eY=;
        b=bLdL2Hh3FNSrIzKOz9XhBd81MMc3GCY4MhBVeiDDyOcbaDOvIUP/glXhMbZvk6R9bl
         uoNOuqzrGXUF/W0pO3hv3qPj3Hx7edelnihuz+RNabiGARF33DueVUxJOOemsD+RTBIT
         4gd4X7mUsaIEVZ2j2dZaFlwhmwbsWRfJr6An4r/CAjMIxiglN0HRCFkqq9JwBnpv/s29
         C2CRqQYZiJhh7BQHdTzewBLFo/ta2882GZUWomWuNfwqGfD+pXG1E2YiPCvynyYhS7Qz
         HLr98AI0uy58tDOgye/rtGGe7bj37qo9nXa7O4WMqfMnJgpWapMO2SRdBZ41AVb0e1Rg
         Xkpg==
X-Gm-Message-State: AOAM530wQFihDDlXZslz+KhkKS0IcW3+z+HMN8UtrBdwWUzn8W9AEJoW
        SMYXxxAIA/5mTRiCAp7QHy0=
X-Google-Smtp-Source: ABdhPJwZOpf2kv1TPcd0/i/LZfHhrIoQQ2WIu3iUGuEU633D71PkyaOUGZUd2j2128JQGcdqsJ4nWQ==
X-Received: by 2002:a17:906:6148:: with SMTP id p8mr7886242ejl.254.1642901624498;
        Sat, 22 Jan 2022 17:33:44 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:44 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 03/16] net: dsa: tag_qca: convert to FIELD macro
Date:   Sun, 23 Jan 2022 02:33:24 +0100
Message-Id: <20220123013337.20945-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
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
2.33.1

