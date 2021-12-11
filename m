Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1A14715F6
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhLKT64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhLKT6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:23 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C92C061751;
        Sat, 11 Dec 2021 11:58:22 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e3so40718760edu.4;
        Sat, 11 Dec 2021 11:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2SJGM9ouzR0OJAtC1TTZL0Ns4pieplKsZlkIeRm9ng=;
        b=D5POlYC87sNcN1SAqxd67C/hMGGltiIbtvkXQySbXOZHa84FT7QSbJ7LnghTY2wJ/I
         +lbJJ5n3YnYWyTHCp4jJN2TR86NM6XgqIgPVsxVTJYNXKrToHNexwEcqP0X1TycUKPPq
         oYLqDzHLXgTq4u/1EhTyHsn3/HNkLRQxoLpSyqlGJ0TPPVxEnlEBh4U5GHYeUUoJCzKG
         sHL4IWbDOroR6hf1tVOkcnDGgfg+mR+z/y2udnXZAN9qPVfeEec55PaWrQre/dV+guAY
         qFW/6t9w/+IN+uZxIuKk92YQ0kfQsriic1TzvPp5T1QR56GZdvccam18EopHpTnl3uRi
         /FLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2SJGM9ouzR0OJAtC1TTZL0Ns4pieplKsZlkIeRm9ng=;
        b=FCzX8nkqw+DuZRTqZn3oAhf/5036ZnHyOd0FgTlKL47zx4XebWUyBpe4LbyehrSp46
         M4w30zQmYIagZ++uNwmsqxO4nKZR7O/Nwp98uIp6S/FfwQ16pZgwiDBowWwqWkCpxqYR
         xVW2Nv/vqgGsuhiXt/OJBBTAADC5jrIxuaUjeLFxZ3jtlQ0ytB19tseyUHaTu33JIh/h
         s9lnzd1tLHqg+YvqInZtZAhLEqTf1p3lbwknH4xx1zdP8EJxIZJRJ9pbas3KMgpM1vqU
         qtaAtVq4bCex2KyUQGzRn2oDaJbpzB90WVmqj/fcaYL0AW/c8aCVMsGy98mHvLRwAL8v
         KtXA==
X-Gm-Message-State: AOAM532rmNP9X65SE0xq+KJMw6bzEZopc949j+ht93eetejGBqm6Vgoh
        rg6008Q9rGXc4swpW5Rj0Pkllbv7mC7f8Q==
X-Google-Smtp-Source: ABdhPJzFVP6qvGbykM6AC5yFSlPfI2tlUYubPtrqiVKVbypKdr3ErFYWmALt2XbMeZfMT2Q7Y1PdAA==
X-Received: by 2002:a17:906:d152:: with SMTP id br18mr32430130ejb.287.1639252700906;
        Sat, 11 Dec 2021 11:58:20 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:20 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v4 06/15] net: dsa: tag_qca: move define to include linux/dsa
Date:   Sat, 11 Dec 2021 20:57:49 +0100
Message-Id: <20211211195758.28962-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
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

