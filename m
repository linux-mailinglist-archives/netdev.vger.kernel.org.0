Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F40A2FC47E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbhASXJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbhASXJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:09:05 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B68DC061796
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id bx12so9552377edb.8
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=INibe6ATFiOkyHe/BYMykgqKnyQ7hJMS326AbBxewGg=;
        b=m5Gnf9fMozqOQnFyILLbfeNdAcBtxGVqsm3eEt/wSTtZ26s60zMjRQMkGFEW+rKj9g
         yUfVuB2nT0q+MqbSb3kBSzcH37UO+ogPW0nZbrjkx3WSQrzb32A2Ap41wsZDXxGHWtl8
         sr2rHgl7Fz3q0I6XowsxtJOQvx135k+VHHiWRKuXfolR8gv9cMUSLYV+nukKJqWngykF
         ETCYWjfmBLjSnyFJrrZuFVGtaJ6hZ6Ub1jGjItGkbSZQ9wsQOXLQbifbE/1nNLXW9NaJ
         5M1nz3RJyembkvIckJTZ7rqS6x5N96xyqwAmWVyjxF+6KaTs53fmMnvWwDDxG/eeTun3
         yI4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=INibe6ATFiOkyHe/BYMykgqKnyQ7hJMS326AbBxewGg=;
        b=kcgA6NhBY1TtCpQtKnlyjyPJIsCSHEMUrpbrP+67IkPlZMPwCsiZTx7YqdJcNe7sHt
         dkI+gHO0SpHo1XRbGSc7mz8KDwZtRU+xNmdfzGjbye+WBgWoMR7shA4Zd16t41qLoHPg
         edA0iSzv0c7/Hf+Z/7pmwih/Q4ECn1C4+hkRA9GfQvQuQqMSTA4R9y0HQCKWdfyFEspg
         N5rI376brTvOEWNAxtbclxuXqwpiGzP20pbpAiuLMCUsmaWEQw/xF2rwHsa3cNMWNSQd
         fSZmykEP47PyXb3Ip3uWNnNxndYi7niEN00HQBEgeac6fjdilDMoIOq5uSKcm7uMbbDj
         7afw==
X-Gm-Message-State: AOAM531Il0V5AcEFiLKBW8K09337soKanaK5A1m3F/SbMjn0W34k/fcV
        nVU9WvXmeiwI/hyXN8mSdXgQuOTfs2I=
X-Google-Smtp-Source: ABdhPJxTlE/fjeDP7fVpAKEz9JjU4WRdu+/EINxnNqU/sDGne71vQmMV0pc96fmzgAbXx+rPCSW6sQ==
X-Received: by 2002:a50:fc8c:: with SMTP id f12mr5157323edq.225.1611097694894;
        Tue, 19 Jan 2021 15:08:14 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:14 -0800 (PST)
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
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 10/16] net: mscc: ocelot: better error handling in ocelot_xtr_irq_handler
Date:   Wed, 20 Jan 2021 01:07:43 +0200
Message-Id: <20210119230749.1178874-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
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
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 49089a014dda..4bd3b59eba1b 100644
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

