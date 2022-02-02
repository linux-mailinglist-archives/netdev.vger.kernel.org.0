Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0979C4A68ED
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243100AbiBBAE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243096AbiBBAEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:15 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CBFC061401;
        Tue,  1 Feb 2022 16:04:14 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id k25so58968981ejp.5;
        Tue, 01 Feb 2022 16:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wxmu/gNVJ7h2u3cs1goD2sfMFY17LzbinXKr2isRlQY=;
        b=E6DPJF/0VYmTw1gDfXghVUUH/Fpv7ldh1aVKODmjSjS2joscYq/MYVJNthmUky49C1
         C9RfRkbHpmZudYxdfvPo6sFaiJHQWXhMoVu6xquq5EuWdmLoRpp97pbyNFfr4iLna+ED
         Tl++4b7Ab7hAQ82F9COOQHs4DzZ9xziwB761+WcolQP9gQYWuLCaJd1vxZiAaqy0VzVR
         OEFNZ3LDfYWiLbXQFmWgmifLlrG9X7aDVvBznog2qm5VA4A679SP1SoIpSWcNsarXkaF
         ANvwFJivMIMMlYxxkONepL9uhPmIrY9meBr+fXagi3Ko9qISUAT1b4mz3dBWn0FgmmnS
         YsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxmu/gNVJ7h2u3cs1goD2sfMFY17LzbinXKr2isRlQY=;
        b=XKFdPKIl4wMCN5N7dZYHk1lDQaxaqINJWgHPmTvIEmFLAe87i+3Nv7TPPpxz8oSfi1
         SHpNhXBG3GQrALaOpKZxymeDBimoqjhIufH2ULU7pvp07M8xsRolQomjuYKJhBgI7Nf6
         DOS2ELGhPMwaqyF4xTCD4Am3yfg+JW/75VbyBClodvDshvjRjXzhTs21QQSX8VzLuG8H
         /dwAPxRHeJfGD0aL6+utHEKyD0ddew2waTux3j0HIN7CL1TRuzi+rMQPn9OvCBjV1fkq
         pO/36pfkhGlWm9bU037XnHLb8+hpdmWVJ2VYGw9BTU1HHzkYlqvSkq7Y9gJAugrPXGd9
         AGGg==
X-Gm-Message-State: AOAM530isUPSsFChP0lK/0Mx6yjMCapCqpj7r03xkXxdP3NZU0Eq6JIm
        7APWwFXu0eIsg8sqm9PYOzg=
X-Google-Smtp-Source: ABdhPJxFRql/fj+MDE3qSueAuN9kgPkyhDoVYnhjRpahDzIYpAPY1YlKib+1ZaStVevFIv3a+yXmHQ==
X-Received: by 2002:a17:907:7f04:: with SMTP id qf4mr22824503ejc.152.1643760253286;
        Tue, 01 Feb 2022 16:04:13 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:12 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v8 04/16] net: dsa: tag_qca: move define to include linux/dsa
Date:   Wed,  2 Feb 2022 01:03:23 +0100
Message-Id: <20220202000335.19296-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tag_qca define to include dir linux/dsa as the qca8k require access
to the tagger define to support in-band mdio read/write using ethernet
packet.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/dsa/tag_qca.h | 21 +++++++++++++++++++++
 net/dsa/tag_qca.c           | 16 +---------------
 2 files changed, 22 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/dsa/tag_qca.h

diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
new file mode 100644
index 000000000000..c02d2d39ff4a
--- /dev/null
+++ b/include/linux/dsa/tag_qca.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __TAG_QCA_H
+#define __TAG_QCA_H
+
+#define QCA_HDR_LEN	2
+#define QCA_HDR_VERSION	0x2
+
+#define QCA_HDR_RECV_VERSION		GENMASK(15, 14)
+#define QCA_HDR_RECV_PRIORITY		GENMASK(13, 11)
+#define QCA_HDR_RECV_TYPE		GENMASK(10, 6)
+#define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
+#define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
+
+#define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
+#define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
+#define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
+#define QCA_HDR_XMIT_FROM_CPU		BIT(7)
+#define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
+
+#endif /* __TAG_QCA_H */
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 55fa6b96b4eb..34e565e00ece 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -5,24 +5,10 @@
 
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
+#include <linux/dsa/tag_qca.h>
 
 #include "dsa_priv.h"
 
-#define QCA_HDR_LEN	2
-#define QCA_HDR_VERSION	0x2
-
-#define QCA_HDR_RECV_VERSION		GENMASK(15, 14)
-#define QCA_HDR_RECV_PRIORITY		GENMASK(13, 11)
-#define QCA_HDR_RECV_TYPE		GENMASK(10, 6)
-#define QCA_HDR_RECV_FRAME_IS_TAGGED	BIT(3)
-#define QCA_HDR_RECV_SOURCE_PORT	GENMASK(2, 0)
-
-#define QCA_HDR_XMIT_VERSION		GENMASK(15, 14)
-#define QCA_HDR_XMIT_PRIORITY		GENMASK(13, 11)
-#define QCA_HDR_XMIT_CONTROL		GENMASK(10, 8)
-#define QCA_HDR_XMIT_FROM_CPU		BIT(7)
-#define QCA_HDR_XMIT_DP_BIT		GENMASK(6, 0)
-
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-- 
2.33.1

