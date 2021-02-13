Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30C231AE4F
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBMWjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhBMWjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 17:39:02 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE00CC0613D6
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:21 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id hs11so5454941ejc.1
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 14:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQDO2O+0Trf4HhRZzdy2yi8zwuH+JART3ET5gMNa4PA=;
        b=GE0Y9GROyi9cdCEghWEOI7ISvFutg4UnAwi5Iro73YSyBcgHtvVmQYNsRaCTHYGD6y
         VkdQy/Mx/fxqSSrspUKfnUQ3nx+ahp+hSHBN91p2Xnby9FWHqtzXVFBYbp3fMNv5fvAw
         0fR/aebXwZbAH6ndyON0y64032eNKfnPYWrhfHmRTWX8rdXmbzERQcKl+oGzpe+Joh9B
         1KV0qkxOLmF6aJ7vOzKdim3yRkW7jiEI71hyXrkhbFoUwTZKVsOGgxmPOErKrKGdRhGV
         stLhJvquLrp4h1ghYBH8qwk8rR2SuVDUqEhFbpbGbcJD/p3y1k50guScRz95qJ8F/9HT
         5F2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQDO2O+0Trf4HhRZzdy2yi8zwuH+JART3ET5gMNa4PA=;
        b=kMVfbcqdKpiw1HC2W7hsBZhmaw/h34Xf6S1k0xcaV06NBr0TQqCM2Dm2oltG2MhDBq
         ZLbceJza1I/rkYuN3/qJwOQ9lkl3BAFziUWuo/GbKNPoPX0SgAsDA3Eai5z6ViodDokR
         pCpEfamvDpDklN0bzuo6h7fLAn7c2uWN2jQENlr0hIdqVHvcRii8k8MhsOSDsjQ4rMvf
         3u3mSUUNxdyTFPYv/+eXc3Ynh4pbWy2/FY8gwDWhDKv1bdohb/ebBYUAiQE/AGetUERo
         9edDNQ89doT0sSjDUvLbmRvBcuaKqGViplSlihAho8pY119bnXbCCAKa8lfXb+AT9Vyo
         Wb8g==
X-Gm-Message-State: AOAM531SQUJDnEmPcUF3hVXTnodmIspJGI2fl3m0x3T0Bw+gtcQIgOEV
        RFnpbv1ls8XNssgAqhqezHI=
X-Google-Smtp-Source: ABdhPJz7OVkjMnyhQzkGlFyFXWxFPmLfQLXkm6Njna18IrJd6QPwqoUuQAeiaXIKGNExc1OHryvR0Q==
X-Received: by 2002:a17:907:770d:: with SMTP id kw13mr9246915ejc.219.1613255900565;
        Sat, 13 Feb 2021 14:38:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h3sm7662582edw.18.2021.02.13.14.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 14:38:20 -0800 (PST)
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
Subject: [PATCH v2 net-next 02/12] net: mscc: ocelot: only drain extraction queue on error
Date:   Sun, 14 Feb 2021 00:37:51 +0200
Message-Id: <20210213223801.1334216-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210213223801.1334216-1-olteanv@gmail.com>
References: <20210213223801.1334216-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It appears that the intention of this snippet of code is to not exit
ocelot_xtr_irq_handler() while in the middle of extracting a frame.
The problem in extracting it word by word is that future extraction
attempts are really easy to get desynchronized, since the IRQ handler
assumes that the first 16 bytes are the IFH, which give further
information about the frame, such as frame length.

But during normal operation, "err" will not be 0, but 4, set from here:

		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
			if (err != 4)
				break;
		}

		if (err != 4)
			break;

In that case, draining the extraction queue is a no-op. So explicitly
make this code execute only on negative err.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 590297d5e144..d19efbe6ffd3 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -701,7 +701,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err)
+	if (err < 0)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
 
-- 
2.25.1

