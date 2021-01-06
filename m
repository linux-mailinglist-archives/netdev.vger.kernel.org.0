Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C246F2EC6BF
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbhAFXTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbhAFXTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 18:19:08 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC0FC061357
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 15:17:57 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id d17so7259851ejy.9
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 15:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/22oCd/VpJqZUvA8p9jlsZJDNzZETvpQkgVALpueew=;
        b=JNGgapwB+i/oNlrMJoCGfSlAvOAIbcG2j3HURjaw/gOIMq7eMXp9/DcTcT/TEBRI7o
         OhnQBPGKsuBrTtu+AELeCht+ifstSgNHALLhRlWRCXY2Y1NGZhhwiuBMGEaS4Il1fSUU
         BghuqLY4KmLMO1MhN6tdqJG44AqbQj+jTTQPWiqiFN7ikH+RvsFRvByLpwHsWV9peunR
         iffAS1KR5PmDYdxjTqZbx7c7ErSzi2d2I1MbT+tAYjCVx6Ify9BgH2HJdYOYgs29fHyF
         euSZIY/msnNHixBjNXeH2WO3qC+XQaGqD2CCO4f8jvdqgCQs3nsYhlmrNWKCmG4ZUmpT
         1nhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/22oCd/VpJqZUvA8p9jlsZJDNzZETvpQkgVALpueew=;
        b=lgD0MFhiDSBsotkn3FjIW1AdCqzs5fUGE20DjSQFmA0UHua+vAjo1EAidd2KCorP1r
         5jhfZ3pG13GChdCke/9Tr5M/34dvNBabzsAQobqnVIgSTrgXvNdfngFdV0Z8pKrxSHhG
         Xo3LBia75vEtUlwn++KA33E9wfYKFAfbjFXgKzGPGtTp78GhbTyGi6fIu93XhYJu0z9f
         HKu51GGecehUmm++p7r+WO7dX2gomwV3hxoz3KyPtdlynv151kjJrutS5JRLVpB4tWxY
         50kjdMmWau8GvG1+8NH5gntlbpAyP3BzzJkh79qpGWSd5nxIWz4xk7TdVomDTGx8JFlJ
         5oPQ==
X-Gm-Message-State: AOAM53144YQgKAa8gK2CpB4QjJjANi9h0KKftpmaQxA/XG2+YpFqGiBr
        8U6/qDOQa43BNqU5mt4wCUM=
X-Google-Smtp-Source: ABdhPJzK4ahHT1VuVSxP6sauPtNjDSBBZ53hXxX698QWOnmdJXUvk66LkgLsp3FXV4HC7U2EQa21gw==
X-Received: by 2002:a17:906:af5a:: with SMTP id ly26mr4452376ejb.416.1609975076367;
        Wed, 06 Jan 2021 15:17:56 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm1958263edv.74.2021.01.06.15.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:17:55 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v3 net-next 06/11] net: dsa: remove the transactional logic from ageing time notifiers
Date:   Thu,  7 Jan 2021 01:17:23 +0200
Message-Id: <20210106231728.1363126-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106231728.1363126-1-olteanv@gmail.com>
References: <20210106231728.1363126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Remove the shim introduced in DSA for offloading the bridge ageing time
from switchdev, by first checking whether the ageing time is within the
range limits requested by the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Jiri Pirko <jiri@nvidia.com>
---
Changes in v3:
None.

Changes in v2:
None.

 net/dsa/dsa_priv.h |  1 -
 net/dsa/port.c     |  6 +-----
 net/dsa/switch.c   | 15 ++++++---------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c626fed62541..5bd2327d519f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -29,7 +29,6 @@ enum {
 
 /* DSA_NOTIFIER_AGEING_TIME */
 struct dsa_notifier_ageing_time_info {
-	struct switchdev_trans *trans;
 	unsigned int ageing_time;
 };
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 14bf0053ae01..e59bf66c4c0d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -310,21 +310,17 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock);
 	unsigned int ageing_time = jiffies_to_msecs(ageing_jiffies);
 	struct dsa_notifier_ageing_time_info info;
-	struct switchdev_trans trans;
 	int err;
 
 	info.ageing_time = ageing_time;
-	info.trans = &trans;
 
-	trans.ph_prepare = true;
 	err = dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
 	if (err)
 		return err;
 
 	dp->ageing_time = ageing_time;
 
-	trans.ph_prepare = false;
-	return dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
+	return 0;
 }
 
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 17979956d756..c6b3ac93bcc7 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -33,15 +33,12 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 				  struct dsa_notifier_ageing_time_info *info)
 {
 	unsigned int ageing_time = info->ageing_time;
-	struct switchdev_trans *trans = info->trans;
-
-	if (switchdev_trans_ph_prepare(trans)) {
-		if (ds->ageing_time_min && ageing_time < ds->ageing_time_min)
-			return -ERANGE;
-		if (ds->ageing_time_max && ageing_time > ds->ageing_time_max)
-			return -ERANGE;
-		return 0;
-	}
+
+	if (ds->ageing_time_min && ageing_time < ds->ageing_time_min)
+		return -ERANGE;
+
+	if (ds->ageing_time_max && ageing_time > ds->ageing_time_max)
+		return -ERANGE;
 
 	/* Program the fastest ageing time in case of multiple bridges */
 	ageing_time = dsa_switch_fastest_ageing_time(ds, ageing_time);
-- 
2.25.1

