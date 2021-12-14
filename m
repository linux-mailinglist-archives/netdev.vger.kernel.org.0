Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60A474D01
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbhLNVKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237785AbhLNVKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:34 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA40C06173E;
        Tue, 14 Dec 2021 13:10:34 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y12so66605635eda.12;
        Tue, 14 Dec 2021 13:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FPHCW224dbQX+hfHQkJaGaEhoEvlqsOfdITuUUKo/eY=;
        b=EgFwugC1oHn163etsCh8z5tl+4ck4vlcdUk9qCpZT7TTxAlrXtu2MWn8bZfMkneGEk
         THzeGvpwXKJvSGgT68jbQ+jGfqF1mVrAOT48AaYIDmj1yHC8ZqHKsd1BqBjme0eQNxfS
         nSMgni57HUUifx0iW2XyLkxchrVYx0doBBnB7ESEsky7rzHoSbFrTKtvCnkqm3g6hpiN
         CsLvuaI/4owVpESyTVQUz/D3QZIoexjxy6LgxXvkdBoXzouOGvVRHvj29SgFs7A/1vkG
         YKhOBJpsYCb4Vs66+fA/TQnHO5xh/5BGwSWQeTgQK/6uFgCY6vkr8LIOqW53KilwNwPY
         GMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FPHCW224dbQX+hfHQkJaGaEhoEvlqsOfdITuUUKo/eY=;
        b=Q7KISjL013N5Q2j/p/7eXRUBim0P3eYdgm61wG3qJQMJMD8R0rVT0XUchlEetUEeJf
         jecP5w4ILBJDoKGYzcKXYuR9EF6sYLXPIz75ZqW+J4Wo7Ow72a1Z54fuAaXU6M+Ljwgj
         N6u2NhdTddnV/ULpbCiLxieVHD+komAfir8VXuC7Nyl8GIlsyCDzeUzInN2308NcbUCk
         Ro3Gmznylyo4yW3UJpPsr3FkdShI497U8Ht2QobbFRWdaLp4oJ7qmRf8JKLs7Tzq+vpV
         IK1kc2nmApu6j/XS8r19fCXAGFYfxzwerHTnfQusFjLWH2oFbys7i4UFr4mEPkOSmvn+
         N+jA==
X-Gm-Message-State: AOAM531hv1noZwTB9eN+96eu6IPquB8gexZPbgE6S79QJFkegIGmQTB4
        TC0UNmBmGqUraBmSgOxTtvU=
X-Google-Smtp-Source: ABdhPJyBB5Uu8l69bdgpR9Gxgbm+UD53msMqRS/h3x5KbGJebX2fJ2g9YXhktXkEOnpxtkYWK0Px1A==
X-Received: by 2002:a17:906:5ada:: with SMTP id x26mr2865306ejs.720.1639516231974;
        Tue, 14 Dec 2021 13:10:31 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:31 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 05/16] net: dsa: tag_qca: convert to FIELD macro
Date:   Tue, 14 Dec 2021 22:10:00 +0100
Message-Id: <20211214211011.24850-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
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

