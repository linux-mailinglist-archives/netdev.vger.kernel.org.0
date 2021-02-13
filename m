Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFC231A8A7
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhBMAPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhBMAPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:09 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FAAC061756
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:28 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id df22so1867084edb.1
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PsP+HVEooPaJHcrMMWVKuGbQNjneesUyAcPxm+EshNw=;
        b=BfAN/k6c38X0HiXDe7qYDENmd0p7MHYerIfBQT3aGadxF7RG2tMaweZAjSQkufZOKm
         IkF6Ozc4Xdy18x4ewhSgj21J1DjQo7Zw6pw3x0fkHhZkmVOSc2uK55GCMCjHAOOpRLyN
         LWNOhBDBkuJsdBAOToXPUDjRC4FRGkzySwCRUxCiet4G0fmrWYWouwVPrQfg9jlUA/62
         leBQ/gvEtRhhqpMs7wQnFqtqujMBoLF67DiDhXcNTOyvx0a2BfLIg6A/4yh1YqZnplns
         /0el/Ov6Rz2PJxnQjwAlWXFHiXKvdwqqXAXBvp8M/h+D7Iyecxu2npLuAkIm3/NTflvo
         SOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsP+HVEooPaJHcrMMWVKuGbQNjneesUyAcPxm+EshNw=;
        b=sdo/2xFqXZ8C6fTIuzp4SoV42NOwF2PpG3oBT0hvHkGC01NfG3J1cIq61iZCYVznC4
         IxPgKyXn0lfn1rqfvd85VFg7pYiTNcPzn9B0IHPurFCKGK5Opu4rIc2wLPwN3EibZW6q
         9ZhCYyMSzL8J4Vga/IFfexsCKvzol2vBXO2CVSzBGEQkMuL5UvwzJuhzX9BkmByzQQkY
         tAwAO4Yp/SEaVhA7kL5wFtGrapxIdY6HiGVnc9ViPcDMLbBFPCPG7iKN99v08ZDOaKe4
         ONByunQE5HNIbSMc/X4wIa4bThPj7XiC7TfahRpjcphOszIx7RjILJ9B/8G23MxGHXfu
         P9kw==
X-Gm-Message-State: AOAM531dN2vxqslbyl1kY2fLYowO6sqEzwGcIVQSCPFQtvWWcCG5ZBwP
        GSsKQEomjRlOz5IISPsMhAc=
X-Google-Smtp-Source: ABdhPJzVgZI1/po7LFOOO/UpL/eaqDV6QIMFaojtkAHXETvzGLJaCWs+tR7oJfvCV0x+ZZaun9+KBw==
X-Received: by 2002:aa7:cd51:: with SMTP id v17mr3230165edw.194.1613175267398;
        Fri, 12 Feb 2021 16:14:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:27 -0800 (PST)
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
Subject: [PATCH net-next 01/12] net: mscc: ocelot: stop returning IRQ_NONE in ocelot_xtr_irq_handler
Date:   Sat, 13 Feb 2021 02:14:01 +0200
Message-Id: <20210213001412.4154051-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
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

