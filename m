Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975333F57B6
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 07:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhHXFvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 01:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhHXFvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 01:51:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1A3C061575;
        Mon, 23 Aug 2021 22:50:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w6so11560201plg.9;
        Mon, 23 Aug 2021 22:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+gSDqXBdeSRky6h/E1OhzdBjGEqrt1+vEPvVVQ4fmdY=;
        b=fkEVVaTV2+cKJJTlepLZ+0uRX9rphvYYfm69e6vR0mmyT45p0tH4xcrDtLDjUJ0IWj
         B5Pk6Rf63UvqGjwmtNPuqFriO9Cmk/8zLn6bIr218PYLHhLzm0dtRS+lmndoYqgSVdnO
         Y6l1pl9z8Y8YeCJ03gCEKEqeB0BPaRUEgwIRJ0QDfJdOQK8vHgcK48T/rLHQlaeLBTIV
         y2mIs/vttXwW5aXJAqi9EdhYpZwReJp2gUgaSrWpgIRbHG70pL2ejANsWYu1lubgUmf6
         WwFWwm4Kw9K76q9qx9VU/OHB1OhXiIPTA4NFZIqhaeLLr/jXV5cXLs6Rr7QRbxpfAPoD
         Scew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+gSDqXBdeSRky6h/E1OhzdBjGEqrt1+vEPvVVQ4fmdY=;
        b=XteW6DRjZz+BJWf1Amoh9SzpC/7/1DroneA5VzsaxxwVEd7JW9Wx31QGAgzt3u9jo2
         1jKqjriJqGPgQklnrCww+LzS/RBhMQomHKUDovH6xF1GDobjjFkvrazwAL4Irqt0THhr
         rg/mp3V0im8vXXpe/9EkqH+wO7ZKA0/UjQcpoe9J434PgzN9SSVQw6SdrqjivTMv8OW0
         NgAL+cHS9UfelTbx7UQxqjtmO06GVKfOwtIg/e5EBDYUzNLug3u775aux+ewuHg8vVPy
         ucR/JN42Pepl0T+iXPs6UlULe3Bhb0tZI0fTeEeRP1t2vQv9+jtMXA1QT/8Nf6zqL+Na
         uFMg==
X-Gm-Message-State: AOAM532zGf7gscBeLPYbAGjDKrZ2THkcfikrGSycXYc0Q+AqqNJeA4pS
        4ZLpZjszpjtnQ9yPxhPAmD3GapAB/LJk1OJ/
X-Google-Smtp-Source: ABdhPJxVYFJEp7CkpwK0eGclGAm8CLw2ohd2D9rXLv5HSKLtdOEkciNduvW28N51frgsTWS87ms+rQ==
X-Received: by 2002:a17:902:aa02:b0:134:b387:facc with SMTP id be2-20020a170902aa0200b00134b387faccmr6828783plb.22.1629784231961;
        Mon, 23 Aug 2021 22:50:31 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id s32sm18278054pfw.84.2021.08.23.22.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 22:50:31 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     stable@vger.kernel.org
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:MEDIATEK SWITCH DRIVER),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 5.10.y] net: dsa: mt7530: disable learning on standalone ports
Date:   Tue, 24 Aug 2021 13:50:19 +0800
Message-Id: <20210824055020.1315672-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a partial backport of commit 5a30833b9a16f8d1aa15de06636f9317ca51f9df
("net: dsa: mt7530: support MDB and bridge flag operations") upstream.

Make sure that the standalone ports start up with learning disabled.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 3fa2f81c8b47..c9c02da3382d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1083,6 +1083,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 			   PCR_MATRIX_MASK, PCR_MATRIX(port_bitmap));
 	priv->ports[port].pm |= PCR_MATRIX(port_bitmap);
 
+	mt7530_clear(priv, MT7530_PSC_P(port), SA_DIS);
+
 	mutex_unlock(&priv->reg_mutex);
 
 	return 0;
@@ -1183,6 +1185,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
 	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
 
+	mt7530_set(priv, MT7530_PSC_P(port), SA_DIS);
+
 	mutex_unlock(&priv->reg_mutex);
 }
 
@@ -1636,9 +1640,13 @@ mt7530_setup(struct dsa_switch *ds)
 			ret = mt753x_cpu_port_enable(ds, i);
 			if (ret)
 				return ret;
-		} else
+		} else {
 			mt7530_port_disable(ds, i);
 
+			/* Disable learning by default on all user ports */
+			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+		}
+
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
@@ -1792,9 +1800,13 @@ mt7531_setup(struct dsa_switch *ds)
 			ret = mt753x_cpu_port_enable(ds, i);
 			if (ret)
 				return ret;
-		} else
+		} else {
 			mt7530_port_disable(ds, i);
 
+			/* Disable learning by default on all user ports */
+			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+		}
+
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
-- 
2.25.1

