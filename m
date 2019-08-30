Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3278FA2B9A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfH3Aqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:46:55 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38481 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfH3Aqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:46:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id e16so5207755wro.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L/28Tt0OL3o5o3i1aVj6mT3MYze2NgArhQFp6Loydec=;
        b=pJes8jHo51ZQdUaDTmqyD/qLu+4dAid00I/1nyRGwtIeGCAcPUiDKrzlJNZyt86wCn
         69yq3vFSTxe9CzO5230Jp4JlrrR/hpzEt1n56x3MknMq/2fYM+Rr0eIdxiFUVZhgAywW
         /BGga2R2yzZ0K+kzZ1esveP4mMaL9a/NC+/5PqYUbXvTrUvXN5RLe6izlvCti9iIer0M
         rAM5Pr5plohIH2eGJR/5jCY7p3ESoOHR5TODArV7CzEqsTWortwws1zfWJrmYNmA0GS4
         +oNYorMn8b7AtKQq2AgOjnNbIbXp4B4Ul44B4qUnkBm7VSYIazq1E9X1BdPb/vOzUvgj
         fDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L/28Tt0OL3o5o3i1aVj6mT3MYze2NgArhQFp6Loydec=;
        b=eQYSNNToLHI0WDmrCPcb35l/yF72pMskPEKVizbfVfzcfzBMap1cV4ZLWdLqxWmGS6
         gGpYwz5vOThTjcxXe5x6fGHqWQb/5bF+WyzcWz1d7xDWIu3jv1FXuTnOVdEso6uSY5yC
         HFxYyClQ499DTGYiJ8tWenJGHCvLgaznCUVxE7c6khPedI2Cb6iiOAzppuCrTG6MSMBb
         nSOWcHDp6Awaby5ff0BtG2i/IaJd5fbYW/92WqyDFJY6HvMJ31MxcGYPLjzbsTAyoOAw
         UjGhlMurIusYFYbYDG2tbfgcg3xaQknWF8VObWNqb4mW6ir/+WFZHR95sTlx6RlrblsV
         /ZrQ==
X-Gm-Message-State: APjAAAWZH2lVaAPWBofwmX9Ubi+w+DVgUuDFHz8xFgAhx+oCddpPuPDt
        MSJdOuacgTGTkJ5yOzPjMbk=
X-Google-Smtp-Source: APXvYqyEl+2gcbsmX1yJFHeH5wN+SlAxpaskmDw6zijNjGJS80g1crjIl7IDHAxs1cvsCkv+yRM9HQ==
X-Received: by 2002:adf:eb8c:: with SMTP id t12mr13866127wrn.84.1567126010633;
        Thu, 29 Aug 2019 17:46:50 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id y3sm9298442wmg.2.2019.08.29.17.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:46:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        --to=jhs@mojatatu.com, --to=xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH v2 net-next 02/15] net: dsa: sja1105: Get rid of global declaration of struct ptp_clock_info
Date:   Fri, 30 Aug 2019 03:46:22 +0300
Message-Id: <20190830004635.24863-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190830004635.24863-1-olteanv@gmail.com>
References: <20190830004635.24863-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need priv->ptp_caps to hold a structure and not just a pointer,
because we use container_of in the various PTP callbacks.

Therefore, the sja1105_ptp_caps structure declared in the global memory
of the driver serves no further purpose after copying it into
priv->ptp_caps.

So just populate priv->ptp_caps with the needed operations and remove
sja1105_ptp_caps.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 29 +++++++++++++--------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 07374ba6b9be..13f9f5799e46 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -343,29 +343,28 @@ static void sja1105_ptp_overflow_check(struct work_struct *work)
 	schedule_delayed_work(&priv->refresh_work, SJA1105_REFRESH_INTERVAL);
 }
 
-static const struct ptp_clock_info sja1105_ptp_caps = {
-	.owner		= THIS_MODULE,
-	.name		= "SJA1105 PHC",
-	.adjfine	= sja1105_ptp_adjfine,
-	.adjtime	= sja1105_ptp_adjtime,
-	.gettime64	= sja1105_ptp_gettime,
-	.settime64	= sja1105_ptp_settime,
-	.max_adj	= SJA1105_MAX_ADJ_PPB,
-};
-
 int sja1105_ptp_clock_register(struct sja1105_private *priv)
 {
 	struct dsa_switch *ds = priv->ds;
 
 	/* Set up the cycle counter */
 	priv->tstamp_cc = (struct cyclecounter) {
-		.read = sja1105_ptptsclk_read,
-		.mask = CYCLECOUNTER_MASK(64),
-		.shift = SJA1105_CC_SHIFT,
-		.mult = SJA1105_CC_MULT,
+		.read		= sja1105_ptptsclk_read,
+		.mask		= CYCLECOUNTER_MASK(64),
+		.shift		= SJA1105_CC_SHIFT,
+		.mult		= SJA1105_CC_MULT,
+	};
+	priv->ptp_caps = (struct ptp_clock_info) {
+		.owner		= THIS_MODULE,
+		.name		= "SJA1105 PHC",
+		.adjfine	= sja1105_ptp_adjfine,
+		.adjtime	= sja1105_ptp_adjtime,
+		.gettime64	= sja1105_ptp_gettime,
+		.settime64	= sja1105_ptp_settime,
+		.max_adj	= SJA1105_MAX_ADJ_PPB,
 	};
+
 	mutex_init(&priv->ptp_lock);
-	priv->ptp_caps = sja1105_ptp_caps;
 
 	priv->clock = ptp_clock_register(&priv->ptp_caps, ds->dev);
 	if (IS_ERR_OR_NULL(priv->clock))
-- 
2.17.1

