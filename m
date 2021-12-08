Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A275446CBA5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244003AbhLHDo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243973AbhLHDo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:26 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904CCC061756;
        Tue,  7 Dec 2021 19:40:54 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u1so1573766wru.13;
        Tue, 07 Dec 2021 19:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2SJGM9ouzR0OJAtC1TTZL0Ns4pieplKsZlkIeRm9ng=;
        b=Ha0N4/JFm3gQaWx+TcE83+gIoGMR00avInqEs4GvnQH5jQq2F6m4vM6R96oGu4iHJX
         HNt6TfUQJcbSpEwTQqNTc37VDdJji+8GU/xmVIYevA6UcCm4xR0GI1/KobhXr8+b7CP5
         cDVJmDs2o7UCPWKreIFpia3qw3ojblv1pf3L7q3fS5JQI4dSriSizHcyGbZzxKbJ9xSy
         6YWfwCxqlbLi9BKhhWiO5ca0IIdD7A4AVR6rWn9iwiuwnkVHmO0V9UjU/0YpoJ6WQ51v
         rdbJ6qAAS1ry+qxkOBPYo94kUvmvp0Xm1Sf5QtOBKD8Tg5uyK7k4fIKsXEMzIRCe/Jjb
         q2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2SJGM9ouzR0OJAtC1TTZL0Ns4pieplKsZlkIeRm9ng=;
        b=IpWkQ6HEZa9vSK1OAuyBDaIb97sia5y6xocvUcXBgSZzp+fk0fjorAa/l76Q5Ymq/I
         pt5di/tmAUFcZKK8e5DDXsXEt8HhDMzKKavEQkzw8ZAPYXiKMoYm3xfs3Gg34W+7YW6G
         WMYUwBvZY5UsdjAN3tep+Rt/Fz0vGsoL46pbbjk68e+RGHWJ09FaydNdxkIng2dNHnxw
         t32gwzzmVnwn6lfoMwJStqbm+IZ/NKHy9PILAUz7RhAQ+GCiM8yIqFr4rTN7tE+aN3+k
         smMiqhw2rzsYi7PuwaAadG90DxObbrkru0bfO+6Am3cwKgHYjGPyZdIAMRBTkyVlCnwQ
         XYfA==
X-Gm-Message-State: AOAM531A4xuHSV8Rnl89Wi1iPBbGKIuCcKBun9gRp/HX8Z1/D2WKuJh7
        0AXjvZy6RzGqhgZfCDSapHg=
X-Google-Smtp-Source: ABdhPJy4EMfA66XEX9L/t4em1VUXxLJawVinenXiLFS9h6bS67sAfcOOxrGWyDbhyKvul8NY6EC2qg==
X-Received: by 2002:adf:edc6:: with SMTP id v6mr55991998wro.461.1638934853045;
        Tue, 07 Dec 2021 19:40:53 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:52 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 4/8] net: dsa: tag_qca: move define to include linux/dsa
Date:   Wed,  8 Dec 2021 04:40:36 +0100
Message-Id: <20211208034040.14457-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
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
2.32.0

