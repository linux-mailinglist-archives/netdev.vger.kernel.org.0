Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F4346BE8A
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhLGPD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233407AbhLGPD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:03:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747EDC061574;
        Tue,  7 Dec 2021 06:59:56 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id w1so57969741edc.6;
        Tue, 07 Dec 2021 06:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2SJGM9ouzR0OJAtC1TTZL0Ns4pieplKsZlkIeRm9ng=;
        b=pGf7H40ilmzfKA5BiyZ8BInO9/zFbSHC6DyMPToeHCjcs1iC8sYSR5k42h7gIG2eF0
         HURD9pJLAJdIVyvGcFYxWY/MDwjaRqVRuFGUfwgD62nD4ONUZgkb/m/kNcT6dDKhmlnp
         YRepioA4ZMCxu6HZfignOVNX+tEHrybPgudyzcXiDnDWvRqKUJyjgVbBnd6y9zUygAHf
         muxzqPCTFETTks+cQRRIApQPdQp7ZLHhVkDOhwmyI/+riu0FLrhHi0elA5eHiK6Adm4G
         jFGBWki8gg72qxS+UwCOpSOU7YSFI4+xGGeZlmq5faDV2rNAagEdlRPcNYe4lLUl5P+t
         ifFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2SJGM9ouzR0OJAtC1TTZL0Ns4pieplKsZlkIeRm9ng=;
        b=LA0nYQcGj4LTwJ/bkcEYMbEwu2Q6Z83qpuiPMKhmrqXi+wx03IWfW2f80zUtslvlaY
         uQDC4fz9fd6jYxX5p40I++Cw2IVzFfvYsTKap1p6RqLn0Y5/L3YuzKCm5w98q6GM2EVk
         +XYPfWTz+aSW5+n0trdWjAGeRiZ//VejjZdKb/so86lkUdf2KH3frwhBYbC6javZ7Tu1
         5GauEOyXRxi7tnQndaavQ5hpuuxjnGcsqE+wG48cyX/dqOLQyABT3qc/Rr37/L6oB+VP
         hjc4TEJt2R48jsvRn44yCeqapJlREeaBnBECjbuB0G2p51ew4+NMZE3D/xT4470EmXWY
         QseQ==
X-Gm-Message-State: AOAM531+8S1MpWExRW1zCovKDa84jvHTWr0py0KxiINYyDACIPGFXxwo
        a/mxJiZSvXziFpT0dEtoyLQ=
X-Google-Smtp-Source: ABdhPJweeFt/ZPrgh2Y5Nr0ff9MsoFdo/yOH+vZRzlT8J6RyKyIMQ1JjyX/dPtj/JfYS+RbLrNOKoQ==
X-Received: by 2002:a05:6402:1911:: with SMTP id e17mr9773679edz.43.1638889194892;
        Tue, 07 Dec 2021 06:59:54 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id i10sm9131821ejw.48.2021.12.07.06.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:59:54 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH 2/6] net: dsa: tag_qca: move define to include linux/dsa
Date:   Tue,  7 Dec 2021 15:59:38 +0100
Message-Id: <20211207145942.7444-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207145942.7444-1-ansuelsmth@gmail.com>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
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

