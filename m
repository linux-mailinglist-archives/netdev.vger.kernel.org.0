Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBBC31A8AA
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbhBMAPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhBMAPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:15:11 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF398C061786
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:30 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id i8so2039582ejc.7
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 16:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JYYIQCTUI+8T32ZH2My+L2WEWetddGycYNPeiV+/iCU=;
        b=gOT4IqXQAbbGgoFkDgtFxZR7kNeNPbGXmLWcVv1G5Ygi1fw1z6xQ1HQQq0kN99Cdoo
         WS23XoTqMA1Spj6vHhmrD/IZAzDFbgLPgPgD9YkroYKt2zngGGS4VO507/kkSa7EJMy+
         9u2EzZijn9Rf4UidpNRj2j0eehQ/cD9/SHiJBIT2cjdVXwR+xb0ZIXSqS+l7JEUJVNad
         ZzfvOEoPjzQjLFPd98tm1lZEr35XET2kA9UrdxyClPyVN62GSEAM3KWnBiml5tTZwJK7
         cIjMStENFVoh8s6xe1ZcEvT+zmAzqjFmH5Vci37MCKr9q9Slk72p+J2Qj4jokGLicpVk
         XY3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JYYIQCTUI+8T32ZH2My+L2WEWetddGycYNPeiV+/iCU=;
        b=HeFlxlGIJGnYkxlmWZY9iQa4old/9KxuqGO80J0FDmM9g1JYDfqEr5yVrTVcimfy4t
         IUPbKUQGZE1nthALiyDMEWJmc334HVJNKWLgJ+CWYF0OIxv3AU2fzXW1Pk+w4Ty4xNMX
         OFYm1r+B0nkwj5HBx1G7cW62ZyOXyAqjTyf5Fz08GBaVNtY2YbueaXhLeygy10xO/Qlu
         ZBoakxsh4xebQRBVwMBEjzJ9h62Iw+L3vldxZOZSbytg6lq2uihyZ0LK8reiGJB3Gn/h
         SmEUoI9rWDuRSn8COpBMZ+kaMUA8nn1FmjaLfX15FvNb7wMmypZmfogzbVlWgWr9UXJ5
         n4vA==
X-Gm-Message-State: AOAM533Y3pwNmyXETjSGDCwTIJdWOjayuGl9sw8ctGslBEvttduO3cF0
        sobV6ANrKJ0Ik0TEREad+CU=
X-Google-Smtp-Source: ABdhPJz/QgxpdgUyJRDJ22bmQvFo0sLE8mYquRKfUnhrdNWWHy3NVBsje3jl2i332STvwUjRyM9eOA==
X-Received: by 2002:a17:906:17d5:: with SMTP id u21mr5493877eje.541.1613175269675;
        Fri, 12 Feb 2021 16:14:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id c1sm7015606eja.81.2021.02.12.16.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 16:14:29 -0800 (PST)
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
Subject: [PATCH net-next 03/12] net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
Date:   Sat, 13 Feb 2021 02:14:03 +0200
Message-Id: <20210213001412.4154051-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213001412.4154051-1-olteanv@gmail.com>
References: <20210213001412.4154051-1-olteanv@gmail.com>
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

