Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E336127746F
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 16:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgIXO44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 10:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728215AbgIXO44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 10:56:56 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26FC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:56:56 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so3945028wmi.0
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 07:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nuviainc-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6yPFNtIiNDwenWSl4jKSzojOEJkNHZPx8Pw2/zKzpY=;
        b=HJEQczAnnhWJuMYOuV8tfr/kJCu9O1e0P5JqrJALrUn7aHT7Bh/xXkr/5pLvwH9fbm
         tGTGJU3j4Ja8cN8tWr3gXSJpsEpHbdPCuiwQ8t0uTlvWW/LinTB0AjzTy06OonGFM6vN
         8UPV0g42tEoAT19VAUt3+x7NJ09rS8Iqm1GLKf+6KzQr2hc8pN0xHq4fxNXKO06hDeGf
         g31LqPQC4RjSUWdQ/fg8KnLKSESuGsy7t28MmfoNgaahMTUVYqhv0+tbFoRq2NpITCn2
         Ckx3mCSheK1HZnMyHRtjdK/iZ8TSks3RHhydfLdmAFlNxlJgPXTunyfrlWGAB/BWaL80
         926w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E6yPFNtIiNDwenWSl4jKSzojOEJkNHZPx8Pw2/zKzpY=;
        b=mJ0xVVjiqyn3T39WL7zVIFuAYCcc6X8kmSQ7qNWb2egEur0ddHeXDYmymepH89nHAs
         rNl+q0qaPXZV/Y10IU7jccOOc49g7Hu/hF+Jjvt6VqPvTMx23zzeCEqdvzzriR8559c4
         3mzdDA2QhCecKUEz6rkGB0BrY7DV+kKj4zM8cIxBUcEgx05rV5s6E8KNmLTJb4N8npds
         6/92i33O2ETxLw7TG0N4OtMix3+kgFESI2IlVARPyrPeaMGKU4ctEwcGamoeson5Cn8W
         K1ZIash7lTQsOcwHZxaZ4umbExo0vb6ZJm8xAY60MoEt1hxurgkahYSis0+2xYB2Lu/X
         Piog==
X-Gm-Message-State: AOAM530MeMylaMZ/j8U7p72RrfEX8KgSnJ7Kc9uNtNInxMytoI58LJDq
        ODEuOSSP/ukxDgUN+HZgM2uWzWkL3G5+ooQ5iEX9IF/jRBNwfhwc9Nv/o2u7iprpz+CORoGhIf6
        APHrXDk55hFPLR2y0pLgxHv+VYcfwOuOvjC8XVj6Wehz0akOQfWpi7K2x7iYHvHerDt7Wjw==
X-Google-Smtp-Source: ABdhPJzRfPsPweNyCtw9NMjMMk3ISmtvIjz6jX4kvl5twR0e8m7O3xpN2TyFAYRmCUdlozroaJgZeg==
X-Received: by 2002:a7b:cb81:: with SMTP id m1mr5563174wmi.140.1600959414172;
        Thu, 24 Sep 2020 07:56:54 -0700 (PDT)
Received: from localhost ([82.44.17.50])
        by smtp.gmail.com with ESMTPSA id r206sm3939859wma.47.2020.09.24.07.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 07:56:53 -0700 (PDT)
From:   Jamie Iles <jamie@nuviainc.com>
To:     netdev@vger.kernel.org
Cc:     Jamie Iles <jamie@nuviainc.com>,
        Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH] net/fsl: quieten expected MDIO access failures
Date:   Thu, 24 Sep 2020 15:56:45 +0100
Message-Id: <20200924145645.1789724-1-jamie@nuviainc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO reads can happen during PHY probing, and printing an error with
dev_err can result in a large number of error messages during device
probe.  On a platform with a serial console this can result in
excessively long boot times in a way that looks like an infinite loop
when multiple busses are present.  Since 0f183fd151c (net/fsl: enable
extended scanning in xgmac_mdio) we perform more scanning so there are
potentially more failures.

Reduce the logging level to dev_dbg which is consistent with the
Freescale enetc driver.

Cc: Jeremy Linton <jeremy.linton@arm.com>
Signed-off-by: Jamie Iles <jamie@nuviainc.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index 98be51d8b08c..bfa2826c5545 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -229,7 +229,7 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	/* Return all Fs if nothing was there */
 	if ((xgmac_read32(&regs->mdio_stat, endian) & MDIO_STAT_RD_ER) &&
 	    !priv->has_a011043) {
-		dev_err(&bus->dev,
+		dev_dbg(&bus->dev,
 			"Error while reading PHY%d reg at %d.%hhu\n",
 			phy_id, dev_addr, regnum);
 		return 0xffff;
-- 
2.25.1

