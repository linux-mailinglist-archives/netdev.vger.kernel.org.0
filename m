Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF92FA5F8
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 17:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406628AbhARQVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406349AbhARQTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:19:17 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60955C0613D6
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:52 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id bx12so4197461edb.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 08:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6l/vdhWSH4TgPbD8YeBUASOer/p6FTuLSeoTyml9Oo=;
        b=ety6rXeVJ8E+4SE1UwNlpJgYeSumZ+KnSfZe8o2ehD4BLsO6qIbyg3LuY/7+s7YIxy
         1T8C8n1iwLjJgMCtByDaKkcQ+Yxn4AeAkmjHAuLP4JuYQ+XoQ7bZDZuLeYWHuqYlSMAZ
         M5XiOxr9g9L9uPWVz4tEsE5LM+sBAjGiKaZBf51+54G7tz+XsuZvAAMhSJuG80e2wnbp
         ZhPXWf3MgmjwHhqmsklMhPTHI/uUg/KmvY4YPT975VmjVsGh0nvSEzPwMeFJqc/UPPOz
         QRGB6aLKWEIKT1uJGAZR6jj/R84JgS1qb0n7WeQnrQ0kXDeDMsn9hqwUl7qFK7aPNufr
         w0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6l/vdhWSH4TgPbD8YeBUASOer/p6FTuLSeoTyml9Oo=;
        b=J6v9BSPTj4KFcLLAPKPatYDU+ePq4vEjnh9IxxO0N/cm8s+UKkbCtwan6uvWWKXdyX
         nGcK6c0HboHeb7avejWAW3Bf8n35c0Bcr9gHx0j8n+T7nT3yQ3WRpWS8xsORVK05Prg5
         3Bgjy7QVqma7lGxQyWZcJ9ZZuBhXPh09v9hMcSkoicyiaGrS3l/Y4NKs2hZqTOdxugTq
         gQz8UftnEBES00+uJ7vB05Cnkh/RQ7JPv+bSnntrqXHTQRjo1TpxGV4k42zhYoawZDjv
         w6GRM+Ik8/OBYeH3uvSLwpp4wxtiIK2zxClq+xmeQA1SRYUqYEa1+f+GM3CM29hQhaAO
         KAgg==
X-Gm-Message-State: AOAM530n7x6JNsNl5brleKh9vuFpkEHuSTv7O770w3isRNwo/JHuOnPQ
        jDEOJjRBrFcqGDF7XozsL/k=
X-Google-Smtp-Source: ABdhPJwBq3t7ndObKB9A2JvHPvTQ6zK65wakmdXswKSaKz8QXSAfhTg7oVwDPRWi8+5dHEoqe8yEdA==
X-Received: by 2002:a50:d552:: with SMTP id f18mr193921edj.168.1610986671111;
        Mon, 18 Jan 2021 08:17:51 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u23sm6093781edt.78.2021.01.18.08.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 08:17:50 -0800 (PST)
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
Subject: [PATCH v3 net-next 07/15] net: mscc: ocelot: just flush the CPU extraction group on error
Date:   Mon, 18 Jan 2021 18:17:23 +0200
Message-Id: <20210118161731.2837700-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118161731.2837700-1-olteanv@gmail.com>
References: <20210118161731.2837700-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This procedure should yield the same effect as manually reading out the
extraction data just to discard it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index d4cf6eeff3c9..76fa681b41f4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -701,9 +701,10 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err < 0)
-		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+	if (err < 0) {
+		ocelot_write(ocelot, QS_XTR_FLUSH, BIT(grp));
+		ocelot_write(ocelot, QS_XTR_FLUSH, 0);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1

