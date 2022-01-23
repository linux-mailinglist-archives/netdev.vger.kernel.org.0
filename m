Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59BD0496F6F
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiAWBdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235248AbiAWBds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:48 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4362C06173D;
        Sat, 22 Jan 2022 17:33:46 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id d10so11125914eje.10;
        Sat, 22 Jan 2022 17:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UQqyudjWUYakbtmLPfiby0mM1HOmbin85GmwvIa72zk=;
        b=KJnDxkTbw3Oy47Hx+Ujn6NqsHU4rCWwWLvXg71EHSCfh77V+iEDL9bkPVv2MKvqBFl
         4XfpjiOme04IReTn6y/Uoncq1ljZf4L/tHK4iwgNo2/do0bY9+BgFu4mINoD3FK41Ury
         Mhiw9IN6dhcEBFllGkCYuoLhx5dq2YfDjJdeOPdmeASWwD5IAS6XxRFeUTMKaiIb0TeZ
         JXcEDjyiRn0gSglh8CUcC1Fq/A72EQC0Z0kHYiRXTt5+RiuIkcN1puYKADM3cpowCFx8
         nPoCFOVjiBpW+dAUdA9WDUGiGxXARZSucnbewBJwfwsGzjqlDk1guFjvtsQ8oUhvBhYT
         O8lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UQqyudjWUYakbtmLPfiby0mM1HOmbin85GmwvIa72zk=;
        b=LZZG/MNrUIkbZ/ijtBgZ/eNP8NcXWOd6A4bmIpegD+YvnX5CfKfPpo1j1gtwiwiBuE
         z3/rvLxEE1KlEgWgEH0YM4UdwenQFssLZfhaQuptdchA3hlo2XYj4mqfRKkGDp5A/6r/
         Vh+724DwEVIAfFbZ81RGqydVzOiObx5ogHytXES7PDIEPmp6HEawVajRRdLjNTRn7za4
         p1evQYRjPRyanBavZJmzxinqmFmJLkcFgD+222rZfl/VRXmDinaTT8gagap4knSXrTEv
         JpQOE25iuyTLQXwMZzI5VyQ0DnbATs3lBgP+IHTYJgYIXR2H70iTm1M9cWQx/2qiy99F
         6SyA==
X-Gm-Message-State: AOAM531H/YPvDJJJK6QmM6BqGMoHhR1acADfIpZqLQ1Wi5aySA5WqxwF
        OhdqPFuEUdsHrxV116O3B0QdSj2JfWY=
X-Google-Smtp-Source: ABdhPJypfBv+Xj+vtvAHuU0nDrQryMWIPq9FcVkCR0yxnxzs0us8iV/O6OWKKxaxF5R0p6PDnK8l/w==
X-Received: by 2002:a17:906:58c8:: with SMTP id e8mr8012924ejs.444.1642901625461;
        Sat, 22 Jan 2022 17:33:45 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:45 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 04/16] net: dsa: tag_qca: move define to include linux/dsa
Date:   Sun, 23 Jan 2022 02:33:25 +0100
Message-Id: <20220123013337.20945-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tag_qca define to include dir linux/dsa as the qca8k require access
to the tagger define to support in-band mdio read/write using ethernet
packet.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
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

