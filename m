Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6011F31AE50
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhBMWjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:39:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhBMWjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:03 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2C9C061786
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:22 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u18so3313625ejf.6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NrkdpwjIRrQpuX6I+2ZUgjz0j4ZIZC+ylH1m8HiwDWM=;
        b=q4kqSO0oL/ln7e2TyQdkfCQSmU3HFqNv899hIgMOWCJQo+BUtyZn5bjeI3JyNyvqZv
         99ds94QmzrZwsmhzr5+5adFdbtcn6X3Tigga73l1WSm52yUg/pFA0zkwLJcEBV2jBNvS
         TBi4k1NPsimixblRq/Ehb5Azmxsy/6ZmQpn+R/7ZQH53/IEhg59CLoksdZIbfTTGEMF7
         2AMHmqzW7fjUY977yg2XzLAN76HJxkF/YHmaLELdwE6ZLqOgtLpUfw+puSd7RUVkX2WH
         cfdgoONCId0p2TOVMjrwq5nD5dfAnVUrZxf+u+yeWQmz0mY/vfWgEdPL8XZIiRW2l4YR
         jVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NrkdpwjIRrQpuX6I+2ZUgjz0j4ZIZC+ylH1m8HiwDWM=;
        b=pjv1kyzpKKbQew36G7KtbywFhfCYTpZHxrjx3kSLtydrKglZSWOBPY2fJhkvJlvom4
         V+43ckNN/rcwv4BPL4L/plwLN9nZTGwM/ONjbDaojhpeaZlLkBXgaXriyepOIA1BaA8t
         Pc16jBkLpRxiAq7DZLZgKnuziy7473cb9yELwK4/yU4BOtZxT8yNE2L7yw4daWLI0kJL
         sFCWdwo59oHUO/qvmSUYqk/8UQxWZCzHHdm0uipclckPZz0jCzK3m/5M9gLmRWNFYg5j
         1B1KAVdyPFMEL0VRcTVUS3EF08lBip6NJ9aD5NU2M4Wi14FJn7xey5HAH/RvUnUu3ZaM
         ogeg==
X-Gm-Message-State: AOAM532EsqX2/ga/DHeqIqVWr4hBP9Lp661EPg7uV0ieJ0WHfy06VUgW
        ZI6OMQ0kaaFHPkG0D0lKhDE=
X-Google-Smtp-Source: ABdhPJwO1kD41b0tlG6btNGTSemfIXAAqh99R0L0rWQMFfkX89XSBfjfDXXvhrq1YFYs/5KWh6IQgw==
X-Received: by 2002:a17:906:e18:: with SMTP id l24mr8919052eji.500.1613255901678;
        Sat, 13 Feb 2021 14:38:21 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:21 -0800 (PST)
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
Subject: [PATCH v2 net-next 03/12] net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
Date:   Sun, 14 Feb 2021 00:37:52 +0200
Message-Id: <20210213223801.1334216-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The ocelot_rx_frame_word() function can return a negative error code,
however this isn't being checked for consistently. Errors being ignored
have not been seen in practice though.

Also, some constructs can be simplified by using "goto" instead of
repeated "break" statements.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index d19efbe6ffd3..b075dc13354a 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -619,12 +619,9 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
 			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
 			if (err != 4)
-				break;
+				goto out;
 		}
 
-		if (err != 4)
-			break;
-
 		/* At this point the IFH was read correctly, so it is safe to
 		 * presume that there is no error. The err needs to be reset
 		 * otherwise a frame could come in CPU queue between the while
@@ -645,7 +642,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		if (unlikely(!skb)) {
 			netdev_err(dev, "Unable to allocate sk_buff\n");
 			err = -ENOMEM;
-			break;
+			goto out;
 		}
 		buf_len = info.len - ETH_FCS_LEN;
 		buf = (u32 *)skb_put(skb, buf_len);
@@ -653,12 +650,21 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		len = 0;
 		do {
 			sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+			if (sz < 0) {
+				err = sz;
+				goto out;
+			}
 			*buf++ = val;
 			len += sz;
 		} while (len < buf_len);
 
 		/* Read the FCS */
 		sz = ocelot_rx_frame_word(ocelot, grp, false, &val);
+		if (sz < 0) {
+			err = sz;
+			goto out;
+		}
+
 		/* Update the statistics if part of the FCS was read before */
 		len -= ETH_FCS_LEN - sz;
 
@@ -667,11 +673,6 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 			*buf = val;
 		}
 
-		if (sz < 0) {
-			err = sz;
-			break;
-		}
-
 		if (ocelot->ptp) {
 			ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
 
@@ -701,6 +702,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
+out:
 	if (err < 0)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
-- 
2.25.1

