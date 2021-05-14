Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE67A381254
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhENVCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbhENVBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:01:46 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC15C06175F;
        Fri, 14 May 2021 14:00:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b17so111894ede.0;
        Fri, 14 May 2021 14:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zAlY5keo6dMeqjouY2ExueSej8KsU/tYQKdfgfdPQeg=;
        b=Q5Xrry2UvfUKGdDfevydZUFSwAmZtbVW/5ETJ/nNALi2yXfUCFy1sqDQn8ICQZbLrS
         dOvaPaKvGXGtXPaXs2ARXbsA3OSutIIfcCqsoPXGF+/9fdUGdN0WiZqk0sgvpN+9RnpS
         0KhBUuwC4yFoY78uiWTZpMiChWX0YiQuzv4ImO1d/tA6Hgj6IbvoVSH5HU+WDX3R+Ham
         e2zcrwOMPW0/3QswzWR1u8//dACLoCjFuJdkzCHdVdiXWj4KMTtRVQQlE+pkayYMD6s/
         rhPs7Z4zsJsMviDhbETbq4bnMLJJo/iDkcVIPhS/5KR1iO4uGyIQxIThF7fAhAeGOqor
         U3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zAlY5keo6dMeqjouY2ExueSej8KsU/tYQKdfgfdPQeg=;
        b=HKpumwz4KeG9whwnz4wwjWTre5wTN+J6Rm7++rdzy/iyfKAJsUxdYdhxMjX41vlTqR
         EVwC3WiSIukOReBrRHcQ98whMQjXspimV5bjdpDKnX/ISH261hk2AjB1u3kWFWdx31s9
         zFZbJVmpjT5bvb3OuXb574jc5w9LherCTaGcDj7itpJlP+moTZZtsvC5xhpMdNi7d6AR
         G7SLj+2kxmsMt2iTHfor3RtD0K5RyHRJBgxrEp3hYlXI14agYy++nrgJ3hoxBWCaRAF2
         1Dm52VVJrHtpsW8lmSiL2ND38fCDIPsmCVNFjrWjaR2VaJ8jS+S20Vm8aX3mVmGv2SS/
         y8Rg==
X-Gm-Message-State: AOAM533ufdCNoyqK13so0Al82QfJnwVTHDS5Bk9wuvQjZsFvONIliriI
        ejCraeWe9pOuJ6LF2EY+Lkc=
X-Google-Smtp-Source: ABdhPJxLAmtlN6qlhuFUPzS/SI/EHk/tXJzSukq4oA2b5ljraRg6nqCwF/cnkmE7+DFYRMcWmLh0lQ==
X-Received: by 2002:a05:6402:3481:: with SMTP id v1mr16294023edc.312.1621026029169;
        Fri, 14 May 2021 14:00:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:28 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 13/25] net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
Date:   Fri, 14 May 2021 23:00:03 +0200
Message-Id: <20210514210015.18142-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch qca8327 needs special settings for the GLOBAL_FC_THRES regs.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 10 ++++++++++
 drivers/net/dsa/qca8k.h |  6 ++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index b598930190e1..10e3e1ca7e95 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -930,6 +930,16 @@ qca8k_setup(struct dsa_switch *ds)
 		}
 	}
 
+	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
+	if (priv->switch_id == QCA8K_ID_QCA8327) {
+		mask = QCA8K_GLOBAL_FC_GOL_XON_THRES(288) |
+		       QCA8K_GLOBAL_FC_GOL_XOFF_THRES(496);
+		qca8k_rmw(priv, QCA8K_REG_GLOBAL_FC_THRESH,
+			  QCA8K_GLOBAL_FC_GOL_XON_THRES_S |
+			  QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S,
+			  mask);
+	}
+
 	/* Setup our port MTUs to match power on defaults */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++)
 		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 42d90836dffa..eceeacfe2c5d 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -168,6 +168,12 @@
 #define   QCA8K_PORT_LOOKUP_STATE			GENMASK(18, 16)
 #define   QCA8K_PORT_LOOKUP_LEARN			BIT(20)
 
+#define QCA8K_REG_GLOBAL_FC_THRESH			0x800
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES(x)		((x) << 16)
+#define   QCA8K_GLOBAL_FC_GOL_XON_THRES_S		GENMASK(24, 16)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES(x)		((x) << 0)
+#define   QCA8K_GLOBAL_FC_GOL_XOFF_THRES_S		GENMASK(8, 0)
+
 #define QCA8K_REG_PORT_HOL_CTRL0(_i)			(0x970 + (_i) * 0x8)
 #define   QCA8K_PORT_HOL_CTRL0_EG_PRI0_BUF		GENMASK(3, 0)
 #define   QCA8K_PORT_HOL_CTRL0_EG_PRI0(x)		((x) << 0)
-- 
2.30.2

