Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F5474D0D
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 22:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhLNVKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 16:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbhLNVKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 16:10:34 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA87C06173F;
        Tue, 14 Dec 2021 13:10:34 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id t5so67319897edd.0;
        Tue, 14 Dec 2021 13:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UQqyudjWUYakbtmLPfiby0mM1HOmbin85GmwvIa72zk=;
        b=Fz6cTg5bONcWGPXN73L/qbEDHVosMOYze71DWq0XEeRq3G84lsNYFjGoQm7AgbhyH+
         TTePn8e0CzAMuXi2E8Pc8re4r6X8o+xp2KZehgGWJjfyafrdIB13LDW9pXVguDWE1vLT
         fdc6/RX8hV3SWdzjvqEz985GJOppgZD6T6TFpf3g0XJ4cjaICyRbxxp1NVTKyxeTrD12
         xlkK98JQBDrVVnweWrsveTYABmyXKXmy4y9wDmqZRFup+P15Kp5en3BasHVBE7Diq9Vk
         omnjt+LFK2pZX/ZkDjBPg8OWNsMaNgQ2ScSBrVlchZmun0U2h0upw12W4PpEwA5tei/6
         gULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UQqyudjWUYakbtmLPfiby0mM1HOmbin85GmwvIa72zk=;
        b=0RPFebEW6GFtpOnyw2xjk8ouC1cBOhbqCYmeIxejzgDhgzEYO4unUX/P3KE2fqFgkY
         5kg7wgQN2fdE5yEkcJjCmlahdVyESgXHDVFfpy6tO4IgR3+PKmOKP8BYN9wWeFu17Jyb
         sAjhbe5cXRoAqLu0+ITwZxwdGkojp+AC6Ss3fZ/3/wZV3VYLULMvx9muhnfk/ETQkxbZ
         idYj9tRdeuBbuZEPh4gnnQ3fHq8bWU0rkZAoJ+ykN+fmc4P69+Y4a5O+Dwnt8ZWUKS59
         EYJjKZUN4+/VzXtNFllYDu9nbZg5gaBQ5x+ue01fA/UuYMJ7cu5Sm+2Y8+UHajJ0hHQy
         4hUw==
X-Gm-Message-State: AOAM533B62xafxxiWNsU9vE2FPEgVW1QOJX0ah6I+BGfFKOtOLek8OGf
        iOrKcagC2ea3tP3K/impIPQ=
X-Google-Smtp-Source: ABdhPJyjJLmfk5VHky3q+PV5Kk25S/6Ylfyr3MRLzhy6qlnvxwrmSLFvel4fYREEdGNPw3chi201Lg==
X-Received: by 2002:a17:907:7b98:: with SMTP id ne24mr8111732ejc.14.1639516232881;
        Tue, 14 Dec 2021 13:10:32 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b4sm261034ejl.206.2021.12.14.13.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 13:10:32 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH RFC v5 06/16] net: dsa: tag_qca: move define to include linux/dsa
Date:   Tue, 14 Dec 2021 22:10:01 +0100
Message-Id: <20211214211011.24850-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214211011.24850-1-ansuelsmth@gmail.com>
References: <20211214211011.24850-1-ansuelsmth@gmail.com>
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

