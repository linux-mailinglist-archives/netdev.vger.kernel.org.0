Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12BC2FA5EC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406555AbhARQTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406066AbhARQTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:14 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C33C0613CF
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:49 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s11so10914268edd.5
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9JlBxhSHcFaAqDd996xQadj6B0whk9w1T797bIOpuI4=;
        b=YszWystasQPzBYfzb0nuDEdW0ONjfaTpUiJolJ0rbFYmmnSHH4Jf58N2ce260h5SW1
         T7Jk6M3xObbGBHMAt71dLY3flsUSAT/rA3W57ytATZuVq1+8IZVC/kkXnHGeloKfAAO6
         0rEEwc4nAQsyj2y+cOwtypHnkPrnQmb8B2fnGlaVoV5wJn8YSNNsMHOLoWfJvUCXGwuc
         N7g5DjiB1ajOxAaASRptfRcL/7wi00Ij6NueK57KNeNgsQJcGWWUV+EwqmMVlqDH6x/s
         VAMmEQPLNiDVFTl9jAUNXWjopSJLNp58dpU25W8ygUPl1yfEhTWeSXy0QhY/Lh7QzIQV
         z+pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9JlBxhSHcFaAqDd996xQadj6B0whk9w1T797bIOpuI4=;
        b=R9ddWnnAu2aZ6HPq2O5LmiwE/OThyHrH3SayCWwzOVT0Tc2U8q9FYZbbdUF7fO/VYU
         2NBw1WUFiIf3BDHxgXA+fgos1TYZcaFXS2xXYDvFWa2AE0yGcjHR64sL4pMIen2Qh766
         aKcjx9za4r8yFNEFoxsP+MZBu637sfYijBLAaV19FAfl1xkA9I/9llgs0ZyAD7kfwXvw
         gf0ThBlmzGRvHMm33HoF48T+Fii9P6usfQ8vSX5T/1Zdx3GdgF5vkSOTOCHPTzl4v4Rv
         dWbrJV/ZY61kgxFZF61pC+zfyNCDLx1dJox+X48KZttngeJB+iG31BhNAggYWw7KDUsZ
         GQfQ==
X-Gm-Message-State: AOAM531HK1Qs4ZnFOEGKdHQ+5WYPLL7Yf83kpbNylEp4DEKa/kjYlkvI
        iQZGfLqpVgdBYpV/q1O2/4k=
X-Google-Smtp-Source: ABdhPJwl1dEpZW5HsjhwM2dKQS/Z5IAiozAg8Uaj33EIuSYTcWlXCGhZI6N6V9/uYCp5FCSNW7dlDg==
X-Received: by 2002:a05:6402:1648:: with SMTP id s8mr209936edx.50.1610986668113;
        Mon, 18 Jan 2021 08:17:48 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 05/15] net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
Date:   Mon, 18 Jan 2021 18:17:21 +0200
Message-Id: <20210118161731.2837700-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
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
---
Changes in v2:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 30a38df08a21..917243c4a19d 100644
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

