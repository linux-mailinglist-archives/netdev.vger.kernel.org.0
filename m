Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BDA2FA604
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406587AbhARQXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406166AbhARQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:17 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C79C0613ED
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:54 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so22137892ejc.1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cELJ+WCBcpW1UXde/VhKDhLDKGHrck+LJKYPblBO8Jg=;
        b=st19cQ3K66U/qMwzzIAjWYEbntdrCMTDmnpJO+QubWDyCyjOHHtrIFOH+Yo7znTrlP
         A1Yn1RUWhESWnMZXQ+2yQfBzul2ZVqJcmTJ+tCFmfWQUN0LVVnEbkNpLdKfmVIIbvXE0
         /pn/Qts/jyFP5otZsoXx7RHoPFYqVzs5uXnO85wphA9kGZqhiAxv+ePvH1aY/Nh5DVBe
         c+vFQbpot9082YAJs4zOx9ltrwXCQ7FavGdhuNTuE0skunQQSKlfqPY9RRIoUAjM7p/G
         1RKN0I/MwcdgKOyaRCrjTsqGwd6CEowEPwpksQk76sxOJnU6hpLPt25ED2PhLXLR9ZGQ
         hUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cELJ+WCBcpW1UXde/VhKDhLDKGHrck+LJKYPblBO8Jg=;
        b=l4b6k6Ba4BUHsDY6baYq7+UM5ZHkrIA7OIs+IWLvOaE7tKj+PAmfjDW4YSR+mc9VLL
         4d2hOKfQTh6MUgd/G6BqAnpOFHzx0WRj16p9goi2MoyBpXU+K/0xrALmX4/iWV1J8Xb/
         bcjAEC+Bl0uPelX0zhqAYPbswklO6sNcd8oxFytxrg8cNQ5O4pshLVnxN92fNrXOOGAU
         mxDqFP9mFdBHEu+KI6x1vjAZs/quTEGSEJhPTvZu+HXeBJLDz+Z8Erf0YsSd5M06Jt2T
         LSzayt2O8OnwjNfdOkphv3WiiIO5Fcz+UigmJew4L9h/G43sRRee6udAvOvFEV4wGnFy
         anMQ==
X-Gm-Message-State: AOAM5309w/Ds/+5H7zie4DzCnWVgfpUJqJxK06k7nUvbhtVu0eLv598Z
        imoaiIv7jBzT8ZbVODRF2mo=
X-Google-Smtp-Source: ABdhPJzn14mczS27NLZD9OWlOrax//5lHJLgQdRp9Ex/cd3SXJVf9oKaiiWbbDZ+XI/slJfR4myn0g==
X-Received: by 2002:a17:906:a106:: with SMTP id t6mr300964ejy.63.1610986672747;
        Mon, 18 Jan 2021 08:17:52 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:52 -0800 (PST)
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
Subject: [PATCH v3 net-next 08/15] net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
Date:   Mon, 18 Jan 2021 18:17:24 +0200
Message-Id: <20210118161731.2837700-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
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
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 76fa681b41f4..e5d0dfc0aec5 100644
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
 	if (err < 0) {
 		ocelot_write(ocelot, QS_XTR_FLUSH, BIT(grp));
 		ocelot_write(ocelot, QS_XTR_FLUSH, 0);
-- 
2.25.1

