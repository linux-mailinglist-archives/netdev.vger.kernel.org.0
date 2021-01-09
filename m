Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C975F2EFBF7
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbhAIADd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbhAIADc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:03:32 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA977C0613D6
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 16:02:21 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id t16so16682277ejf.13
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 16:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0XvRoWLxcXXKL6ZnCozca2zCG4GDQSmj3Xglalqtgik=;
        b=OSvbKf6GvDiQoAukhioyFziniEmxbfSOH7zALfYzePVNbRxl/wBdikCVNOH0Nt1F53
         K4xiN+yooQZ07MqziV9Hgg4pivNuL/pShhtF1JWQ+uL/ZIL35W5mSBTBGUZabrsU+UIS
         s1hJePLfFkjXkfwiYHoRmqYgTF3/8ZrfdXzPcdkSCYhiQ/VD5mUmEnlTnxYeazR8iUkp
         7YMQGkqBwNRc4alYq3I0TjI4UIHx23xpwmYXIgooFG76hIXQZf9t0YRPt3b2Ny3JDO6R
         p00lt9D4IaBy27vv0pJIVLZus74Zcz3V6fkFd3jgVx0IM89vLUivM/7SLPsWqKNSrti+
         4lcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0XvRoWLxcXXKL6ZnCozca2zCG4GDQSmj3Xglalqtgik=;
        b=F1UJteuAg06Fvr0KCyhalC/6oHiFip/qkFzvSC/ozwhifRQnQQDBDegVi49ltZuP6m
         9mn1qgUYwKowojPVk35ZLVrDOFky8QYNDo6I3YFYS8+xNTSpZz0JUXJvnnCx6RnKWWNe
         WM5MtZktSHCj6Ku4oXApOYWniGlw/VOlp95qodoQk6TJ8MKRet7FDGzzv1azv8+kbxQr
         582ijTFO2iREKkMzc1PYJiK2Xeu8HMO0klPKRcZTcjPtIiSRjdXjjOZAh19arVP9bwQX
         iX67AhTY718tZL/DKKCMGsPyKO8g1Gzjlt3vfcIgfhaJlZv4ZudhN1ka2CQQmLzFGusk
         hEYA==
X-Gm-Message-State: AOAM5313VAYH++cRuU/1OoyWZVXit+pK0Foy1odVhH8R+Vl5uXbshXZb
        pj29Lr7BuKPEDZjA7vfI2HM=
X-Google-Smtp-Source: ABdhPJw1ut+Xvu4dwGm8Wmlvp70+vefRsyYi5a7KwIrHz+EcwBkLIhx+A4U8Ul5oRFgVNAfFx8GLRg==
X-Received: by 2002:a17:906:b793:: with SMTP id dt19mr4150175ejb.120.1610150540736;
        Fri, 08 Jan 2021 16:02:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id dx7sm4045346ejb.120.2021.01.08.16.02.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 16:02:20 -0800 (PST)
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
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH v4 net-next 06/11] net: dsa: remove the transactional logic from ageing time notifiers
Date:   Sat,  9 Jan 2021 02:01:51 +0200
Message-Id: <20210109000156.1246735-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210109000156.1246735-1-olteanv@gmail.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
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
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 net/dsa/dsa_priv.h |  1 -
 net/dsa/port.c     |  6 +-----
 net/dsa/switch.c   | 15 ++++++---------
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d1071c9fdaa1..7c0570075160 100644
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

