Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB142A5B51
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfIBQ0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45862 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfIBQ0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:07 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so14562409wrj.12
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sjBdwVxrvZqyZGaJREUft2EHYv1VT1dfO7NKAh3nW8U=;
        b=USzG0JdSFASjzyZBz3VZtt+EwVmEEw+TQT+N7VOuvMAJpkY8nHsVMEoepTHhUu5XiI
         7YAqGBbgPOIHGZYHslNJ/Ic42suSNT9wcHR+h06R5d+okVt/cUjLAlOq9PFia1XDaltL
         F5etl5poIhAilJCQLzPMsCEis5I9dkFrrW3qvUGw5LDdDAtU3LH7zCfjt+z/K3WWYrhy
         VHt36P+mC8jaycLJy7eoj0kQe5G6kEv6WZd9BasU35fwruf3cIAglfONFxenX3icjRh0
         Jd4npJtiQZ2LKv/CS5sPKb6IzJO+vaIgP69N6tS4VvqKiLRVTVp3O6Yw6Ul17wx/N0zo
         CBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sjBdwVxrvZqyZGaJREUft2EHYv1VT1dfO7NKAh3nW8U=;
        b=X5UV2vyiFIT91w7uKc7ix8VzD+XDKrVQu/B8Brh5FUEPn10wQSiXqw3vs3MlxgYOGJ
         a6592lVyMLPH/loapu+cEQignzaYhxjH4shMq7SDf97vJ111iqU/J2NYwrCibZj3axch
         4WZ8cFyDET63Z69tV4102swBd956xwB78GPDIB/PZK3jeO/0q3NqO/iKk2UHMyMd6t4e
         Q3hzjuqK5tYTqweaInKNI64Jy7nIKYIK81IPhVKKUmPAQSnh+xX3nfm7+qF9GPaZWjg+
         pFuTeM/XSdLTYNf9O3pY9zPhfO2eT6Of5ecrA6yL1c6PIfviybA2gaoNgKq0vCMfnCBx
         3q8A==
X-Gm-Message-State: APjAAAXeeiGrDTROPrhGaWQ/RB83dutTi5NkKk9aZmq4WhjD9YRFGm+O
        bcoRg/CO6ZGxepLJ3PQtQLw=
X-Google-Smtp-Source: APXvYqztn74UrAITdmKFEq0/Bd+bNPCGf3a/jGWA5qcKuv0szXvIHNNjGB8kIH9+18X47gx5IGFoXw==
X-Received: by 2002:adf:dc0f:: with SMTP id t15mr2865051wri.258.1567441566092;
        Mon, 02 Sep 2019 09:26:06 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 02/15] net: dsa: sja1105: Get rid of global declaration of struct ptp_clock_info
Date:   Mon,  2 Sep 2019 19:25:31 +0300
Message-Id: <20190902162544.24613-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
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
Changes since RFC:
- None.

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

