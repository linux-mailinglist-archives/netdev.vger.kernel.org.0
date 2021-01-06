Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67B22EBE4D
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbhAFNLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbhAFNLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:11:17 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC8CC06135C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:10:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id ga15so4973466ejb.4
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P4meT77TCaBjctaliqtHAU/6WAIjqV/US7V1kqVTudg=;
        b=fQVAG5NKJPPEf9pFsIQzyEonUgrA+Zi0tWj2d4l7QmmhsI0IOZbW0a+p5uBT4Glkn9
         ZK4bpc9PrLeDQ+a49CSvZGS9gDQIV3BzptLLu3WE4D94d8R9aT+iFCJEQoCAR3aLZ0uV
         ecJKJcfk6Zd7vx8X4XrF00oVh8mpCRaNxQ/glNZNoD47qNeba0arj6XhLklyH9ZzCtWn
         e1RqhTswa+XVvspoZCITrN/wElUJnuUdXmDyYaOkHE3UuCd4YT83QZouWCN4NksmYMf8
         8FccWTSLY8uO0sjmscTUdpLCwJ+VBMcize91igl4qvTthhTVO3U7MbjOpAcsPDk7J6oO
         +U7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P4meT77TCaBjctaliqtHAU/6WAIjqV/US7V1kqVTudg=;
        b=pDNO0OAvwBY4b5uNWD1nJ+XQdeAaHbfWCwopbymfDRgx4Q5eTF2xWmQMfEdtBsNPMS
         sFLJWOi0P2Wr2AZyFbNhsXqx2QYzM2rDt3xUhDl8mO3hh748lCYcnw78JIqTzlN33Nmt
         UnMfeEjQ/U65IYP3RZ1c1yc+9/zi6kHHCVlXwZKix7lozn+OC/hr6DuUc38aPkF1K8DY
         w/lvLGcgMU2O4Jv1DZOmDyorcNL1Xn/nhp9Z0MY0mrmmEGNqLq1Z+IauZqpqBWG5mZw7
         QKS0+Ot4WQiaTv3r1oozz/Sn93Lat5c904qnKxmdqN8dyTRT2N4TWWPVLAtCzyPtQsJS
         zbBQ==
X-Gm-Message-State: AOAM532FREPg1ydb51maT7gLTcaMn9gkUiMw5HX2n9NcsM8XFnDyzznx
        +w5ynPtX7ESOs3nP9aUNh4g=
X-Google-Smtp-Source: ABdhPJy1hz1jU2Fj6/CKfslxU26xweLg0u9zZjd8bQJ6Pm2YVjq5LxOCeaCvKOWGLfk8+4RAlc0XZA==
X-Received: by 2002:a17:906:7f0b:: with SMTP id d11mr2891501ejr.7.1609938624965;
        Wed, 06 Jan 2021 05:10:24 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id p22sm1241858ejx.59.2021.01.06.05.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:10:24 -0800 (PST)
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
Subject: [PATCH v2 net-next 05/10] net: dsa: remove the transactional logic from ageing time notifiers
Date:   Wed,  6 Jan 2021 15:10:01 +0200
Message-Id: <20210106131006.577312-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106131006.577312-1-olteanv@gmail.com>
References: <20210106131006.577312-1-olteanv@gmail.com>
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

