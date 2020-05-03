Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57991C2FF1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgECWVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729171AbgECWVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:21:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EC8C061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:21:46 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id i10so18654880wrv.10
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tXgnENA/Rd/xwYCRK4VH2ZA9UzaySaOxFP1El6ScOHo=;
        b=c2TxvgV4F83yOkS+BZ8HRZhRNx6umTwcoNRl7IXzt4SVZ12ADmNqQegENShgpqMBTL
         goDchLd5Bl3ROqPl5yDtTP4wYfH8YCr7AY3ySG8nPBlleuA/M7md4oEYLVy4Gk4qIJHB
         knvEzKkHx+qkg25u6AbX4b3O5qN2fUJSp0hfwRdldcHrG4joe61JS38lymscYAzB75yA
         Na9TeZNoMGNBKwWmXZwzdjHW5d227TK/WY4SVI7TktElwRJt9XoMaXSVgb6lSH6sKUSe
         Jru9lMrxBi7MzYbRWFuQ2gFRcihjupnjbNpQxywjLpJoja8Tr6DXVkCCV/wN83mIB8MH
         +ljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tXgnENA/Rd/xwYCRK4VH2ZA9UzaySaOxFP1El6ScOHo=;
        b=U4d5O83KkOoqOtOsYryEV7/Gttso+lvZ+Qm6fsPMns4HyIVy2g3lXM4u3owmt+Oa9k
         7bac1PRnh1/GNTpieXZKCTAvybUQUU2mE28oZNWZ1tv1OAfR+A+gOrWqXMIjFI0c3uo+
         p4fY2QRZ3P+sgdHiL+LUT7NcQyvpddtIXIbgfy+VoZgRiiKVYlAyUbDa1dtd6Bwm6DuQ
         LB775wqKc/IQZXNnFbjBfZmyaYbBgvbFvrATuLX2XdW7ZAn5/B95TCkaIK4cBmVZV2cR
         MhqL1bPK4afDCh1cXbrCNoxtTn7uNhBFU832BKNy9xPsIOdbrREjm6/caazPbbNAk8it
         8vog==
X-Gm-Message-State: AGi0PuYicjMa3wi32ukzn0XMi8NQATlkDp9Li+LnBGN0mqUR7Uw4vlfc
        /aBX9Si6smVnFhrT3j6WRSE=
X-Google-Smtp-Source: APiQypJpfU92Zf9+QfIEuFpIb4yq17RcSKOB0H/x1C40ieGeREv1psY1dsjOzx+4OoIIfeBgBCX2Dg==
X-Received: by 2002:adf:f641:: with SMTP id x1mr15643978wrp.151.1588544505280;
        Sun, 03 May 2020 15:21:45 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i19sm15405847wrb.16.2020.05.03.15.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:21:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net 2/2] net: mscc: ocelot: ANA_AUTOAGE_AGE_PERIOD holds a value in seconds, not ms
Date:   Mon,  4 May 2020 01:20:27 +0300
Message-Id: <20200503222027.12991-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503222027.12991-1-olteanv@gmail.com>
References: <20200503222027.12991-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

One may notice that automatically-learnt entries 'never' expire, even
though the bridge configures the address age period at 300 seconds.

Actually the value written to hardware corresponds to a time interval
1000 times higher than intended, i.e. 83 hours.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 186ac4cd2ce6..5e47fed8a426 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1464,8 +1464,15 @@ static void ocelot_port_attr_stp_state_set(struct ocelot *ocelot, int port,
 
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs)
 {
-	ocelot_write(ocelot, ANA_AUTOAGE_AGE_PERIOD(msecs / 2),
-		     ANA_AUTOAGE);
+	unsigned int age_period = ANA_AUTOAGE_AGE_PERIOD(msecs / 2000);
+
+	/* Setting AGE_PERIOD to zero effectively disables automatic aging,
+	 * which is clearly not what our intention is. So avoid that.
+	 */
+	if (!age_period)
+		age_period = 1;
+
+	ocelot_rmw(ocelot, age_period, ANA_AUTOAGE_AGE_PERIOD_M, ANA_AUTOAGE);
 }
 EXPORT_SYMBOL(ocelot_set_ageing_time);
 
-- 
2.17.1

