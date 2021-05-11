Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6454379C96
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbhEKCKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhEKCJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D59C061351;
        Mon, 10 May 2021 19:07:36 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s8so18492974wrw.10;
        Mon, 10 May 2021 19:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zAlY5keo6dMeqjouY2ExueSej8KsU/tYQKdfgfdPQeg=;
        b=KLRwlaeI51XvhIGty9JgAJSaGuULIhvKJdrRI1JQnANUIvIpTJrCmhxI+C1gXbzA7V
         YfUlQ1hds1YmchlId9P4LIYr3BWYsifC1C3Ex0me7tlFfaYGhnEDfXPJOQZFwnhuAI7u
         m3GFpqjdd7TlfKtfIhQdmdEbc4vfFTkZoqfwUqPlr+GF7Og3bHQqWJGnuEwl0/BQ9zwh
         qPl5k5DCFpBd/5dYf/CYu3xICc/gJ/Rc9mJhQQEut+8N8SLHtkw1QYsCxl0HE9gsWSqo
         a6L7CbWk2oHFfkWcapwGr8B7V/SliBU/5TxVhwnUhEL6CMOw0Wxms9wSClqlgwPWpEdW
         I79Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zAlY5keo6dMeqjouY2ExueSej8KsU/tYQKdfgfdPQeg=;
        b=AMjziceNGUJrgrpxGxruYAtc5bj5LhHevK72xvgi9J6NHDJISUljRx960nF5cKvxWE
         cvQYH4/eRxGgltCE//88TOi+ViSRKSMIxhRDRKJDhrH6KqQqQh/7U1otFO/Wysg9f+ya
         ud3Rd6vbZ1lzi5E6rSn1Dzhg+IHj4pEK+BraOdKaATcc4OOea0GOr800JU08umW7p2rX
         x3j6Ky1do5WMf5qf2rkV/EzdM0Qf3TBYUlDSdrwoUEePf/py0hqAowmEbJ4fc/Xp1vRe
         HLD/ggfhBT+7MqorhLYABc79Fr2zB5pP9jFdP0rm/24mnjVLAZtGF7eCJVcpBVzk5E6Z
         blyw==
X-Gm-Message-State: AOAM533K5aD+JEsirm1j7AweThWwN133wDSAmhqKK8COjoMexMVo3Dq7
        vBFHd6UDG492loExvr2PJuI=
X-Google-Smtp-Source: ABdhPJzKIj5yWqT1naLx+KEZ1eQpOaLGmC7StIVDe0NMsT4INPy64o+SAVFWbGHEq7SrTYcR22Dhmg==
X-Received: by 2002:a5d:4452:: with SMTP id x18mr35394143wrr.286.1620698855334;
        Mon, 10 May 2021 19:07:35 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:35 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 13/25] net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
Date:   Tue, 11 May 2021 04:04:48 +0200
Message-Id: <20210511020500.17269-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
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

