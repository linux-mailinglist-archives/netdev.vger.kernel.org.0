Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F833474E28
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbhLNWpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234614AbhLNWoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:30 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED2DC061748;
        Tue, 14 Dec 2021 14:44:29 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id z5so68865493edd.3;
        Tue, 14 Dec 2021 14:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UQqyudjWUYakbtmLPfiby0mM1HOmbin85GmwvIa72zk=;
        b=jOtXT8pOgjjZ1SYCvdjrC+zahO95rpsJ7DLwTjnTjQdSdeTgkBFrxvx6+E58LAwS7c
         seI3fMV3jOdE1ZnSw/5BjjZvDlQ9DcnBYYRooB2QWwtQrDdi0Xd2GZU2eCALVPf2C5Jh
         9IJsyrBbQA2ceujXVEGNIAKjCrWgnUbP6d7mphkacjBE5+EvDdbracvLgtSUOvDqn6fG
         ziyOsDYBDY1T64VoT9ilJLgunhhlGfpNVnsB7zAmMFBQoHxN9D3NnXCidVAsjpkSIquP
         ZJasGV7oLz7OeCEq2PoxXDAi48EiJHArF8PCH66NFRzdzfHs6Upet3NP7izaIAbwMGZf
         cO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UQqyudjWUYakbtmLPfiby0mM1HOmbin85GmwvIa72zk=;
        b=jgHzeq17hPza3Jb4fTLOb5ONptDYojF9xbCvFpYpohnzOOSUxTTpDdLfZFj30AwslT
         9Rkt8OhR/ky5X0c/B34VdnP1kTxp7mB16ArYP+cp2BgIDgl6BRS5Xn1KM0Lr6T4ptKAr
         YIhwIzmU26VeXNO0E3HHukjrdRncUjaSY1qbjIriR0ruVr2nFVnYDinbz1WQ6gYE/Xel
         f4S1qT4oVmAuNBtn9Zh33Cl7+1JZx+cuaWESKnthkuRrnhTJDBnNjUf0QYeUPwNxJgWs
         UsZH0AtbzJd8oO0kARxYn/gFAKVrh6Ft67e8+wD67avcadsqnsWYpDB/gDwWQEmdSVlK
         QzvQ==
X-Gm-Message-State: AOAM531Gzi6rqAmzn27K78RT8vOq1FpsyJ2tMhA0/YeUNCTb5igLlshJ
        aDcp5qDLy8o4NIvqgBAKxss=
X-Google-Smtp-Source: ABdhPJz9B0JTzyPkVFz5W/MUgjAdUHsZEhpxRy+/q11XHA4B+gNl5KQHph+LpNxNJdfa9PIvhizBAg==
X-Received: by 2002:a17:906:4793:: with SMTP id cw19mr8375935ejc.387.1639521867541;
        Tue, 14 Dec 2021 14:44:27 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:27 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v6 06/16] net: dsa: tag_qca: move define to include linux/dsa
Date:   Tue, 14 Dec 2021 23:43:59 +0100
Message-Id: <20211214224409.5770-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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

