Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336B747105D
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 03:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345835AbhLKCGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 21:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbhLKCGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 21:06:09 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1289DC061D5E;
        Fri, 10 Dec 2021 18:02:24 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id x15so36045140edv.1;
        Fri, 10 Dec 2021 18:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnLY6KdcrRoSIU2HsNb3g6e/hZnKqFQfK2cCOCiEGu8=;
        b=HJlumZ+HefxSOJVV5UjMjjMxPwMEYipl5oxLFM9krlRNnZ6cEDqhjBUI4eHkWIevZM
         c2PsUiKye2JkIrhjLVhbKpQoQBm7CLrCpd1qzs4EqHUOxKitRAhVyzF2Jf7U1ouX5Tpb
         tmzZUZnZLa6ESlNVIEZPWJSaApJLjBcZViQ9DT7XrpK3i6TVoVmqgxsRAZ8+jI/QsJtT
         a1RwkbO38zay8dKowIKvBh479HIMN0w/AjWSLH244c2VOMxToTHgUxh4Fb5dVHufq2Px
         YjZkbPnJi4z7mNcYp2jrXwC/GdCLCesBZFeG2+bbjIx4FFfcOxp5lQN9a+Ez4crSz6JJ
         jDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnLY6KdcrRoSIU2HsNb3g6e/hZnKqFQfK2cCOCiEGu8=;
        b=qfHqEQzlb2roef17/5QnkA4qD1Sp8y7VZfZUTeffpYRt9dCBp/Cjl21SIWs+krmuda
         W/Y6X6PXGQk55G11Y13oeETifC3LhOrKLqBI5Isd7d6z042vMWL2f/OqeDlQUKeB5nI+
         utN9W881MViKNlzBUkX7JYb19I4TMs5diCvkeU6ijyBXCw6mHmF+fKjqiEtrbuEH0YMz
         OjeFR70F2AFXjRn/mH8IZrkWb+O7hPEXJDD/x109HYWdQhY5NqQDvEETxgo/7RN6uUZI
         M9diIKtJQtctamN+qChtg3ea7uAgQ4pNgIU7seMaDR9hc39JzAISQTEtNXIj94B3ch6U
         132A==
X-Gm-Message-State: AOAM5323dnzy/r6flGYynWturoG5t6goDSCR69hSNl3sdTPIiCk+3Myf
        ZVPa/PL7emXJKJINxZ6kkJg=
X-Google-Smtp-Source: ABdhPJxKtTH3raEYOBoNGofyuITcbYcMbec8BbxAFqHMZNmSsbGYiSOZw4Od63Vmu3JrAk3DrtMzWg==
X-Received: by 2002:a05:6402:169a:: with SMTP id a26mr44863761edv.292.1639188142511;
        Fri, 10 Dec 2021 18:02:22 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id p13sm2265956eds.38.2021.12.10.18.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 18:02:22 -0800 (PST)
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
Subject: [net-next RFC PATCH v3 05/15] net: dsa: tag_qca: convert to FIELD macro
Date:   Sat, 11 Dec 2021 03:01:37 +0100
Message-Id: <20211211020155.10114-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211020155.10114-1-ansuelsmth@gmail.com>
References: <20211211020155.10114-1-ansuelsmth@gmail.com>
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

