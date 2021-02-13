Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EDE31AE4E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBMWjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBMWjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:01 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07836C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:21 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id jt13so5464950ejb.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0AHpbrruAuFXpach3avugjIAzhX/k4aizf/n8CqcrE=;
        b=czlU5dW91aIkmNBL+P+RLU66qnCS/huyvJ7vK6FKrTxkJUDnY4DkOhfhdLCeovbPgs
         abmVF4jBNUDQd3ocgKX9oGRoLsJauKGQ/cfEvtK8B0GU/vs4OMALpwxDN+jGky6KlwrJ
         RRKTJOamkKgo7EaRWa44PWYX8dL0CEtbHik7l6Fq037LD1IcQjuCQzfcqiJfd5+WVE1N
         s4u284Pp3G80Ctv58HhfCVLMT0+q1W3y6fvrjPC8R8Q8a4HHOLo9Kzk3ka8bSbv29FQu
         EDbBA3zF1X6+GaVsw08aIqAxd+y16toVYJvv1m5Kgme03oRHcz+sY91lT3HFHin3ChiR
         1XLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0AHpbrruAuFXpach3avugjIAzhX/k4aizf/n8CqcrE=;
        b=OcZ/J1SIwq+OSy05WmRVp5S9LKrveOGZAG2UR8S6zoJcEdV0IBk2um5guHFa4gQp6b
         g+zstLPHriu6UGMD4Ex0Je0RS0FSfQxwc7uywVSJBEpy/0sN4+rN+YxpV4p1/kQ8rRau
         s3WZdPyYbNWyTKtQ2jsMf7WQFiKd2O3sfKc2jdaz1p4wyWG4vq3o+x8GxORqGl4lnDPD
         lvFwAKF9gwqk/4RQQ9xpjVBdAs9X3pcEsQ0NDXFvw8a/A6u7bnLG4T15CGnKGjMS0cQK
         skpTZdcx+LO3cPenab4ZmNUfpmfg/C7sYjea9WO9ANLysL8CMGLPmrwwx2pQLuWyctKi
         tvBg==
X-Gm-Message-State: AOAM533H3KF1GUBnW2dwSKBwdi8BPbIu/+oy2xJcOGfN9ZVXSp5szMfw
        VGNqMxKrxFEpKJ3+SVl4KNA=
X-Google-Smtp-Source: ABdhPJx7JdUEZdW6JhBr3c6KwetrfLs8MKhxROjiURfefs85yiPx3GXXfqVYYNHrvX/oj1RwgUBspg==
X-Received: by 2002:a17:907:2a85:: with SMTP id fl5mr8911628ejc.554.1613255899517;
        Sat, 13 Feb 2021 14:38:19 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 01/12] net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
Date:   Sun, 14 Feb 2021 00:37:50 +0200
Message-Id: <20210213223801.1334216-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since the xtr (extraction) IRQ of the ocelot switch is not shared, then
if it fired, it means that some data must be present in the queues of
the CPU port module. So simplify the code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6b6eb92149ba..590297d5e144 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -604,10 +604,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 	int i = 0, grp = 0;
 	int err = 0;
 
-	if (!(ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)))
-		return IRQ_NONE;
-
-	do {
+	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct skb_shared_hwtstamps *shhwtstamps;
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
@@ -702,7 +699,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			netif_rx(skb);
 		dev->stats.rx_bytes += len;
 		dev->stats.rx_packets++;
-	} while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp));
+	}
 
 	if (err)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-- 
2.25.1

