Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFB61878C6
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 05:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgCQEyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 00:54:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40826 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgCQEyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 00:54:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id z12so11241084wmf.5
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 21:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Z/pLHqEymmI8qdYZpx02WBRLipjnKwZXZVqV8m8MSSY=;
        b=Hu9yeveSk7lvKAgkYqMZGbJjupqBFlO1hDJJn/f26IzkoN9kOnt+c1715OgLvVXhX6
         SIXcVljSb2WE4ejla8A/dMxdUYQiO1PDZlEEa1fiKMEqWZho5cMEJYzTCs2sbjlRn+bg
         0AQ/kJixJH546JWh2HbJ63TNz4z5jQgMIAvwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Z/pLHqEymmI8qdYZpx02WBRLipjnKwZXZVqV8m8MSSY=;
        b=gsW7K2mDIjuKOpDUk5MjkbQ5CUVjgAZ/fDEKoidyfM2d2bsKJfH+PYeIAFiQapiFas
         ONZAa5VuN6Wm3SdJKEPFlfly5WQ7vSLnXgw53XdaROxxL19b6VTJGpD7jMRlBowrbOc7
         XyeYBaytl4RbI/VzGZ6Ga+soKuNG9EBbxzCJpduY4AC8bhCFNn69JjfdH0hWRHJix8rN
         BS5QGMlwOadg9y4qq19qvWSApMGaTcsDm2tph6oapdnT0+6ytThNnSZC+nGimmvlz82y
         dvXEhwsD2vDUnaLK8wSGfuowsWmWkPL5A8WYxOOn5LGgKz6U1QihNtdDYYSFLyy3eDis
         MWRg==
X-Gm-Message-State: ANhLgQ1G8hWzniD98vl6xQatjrFgBvqr1AuioM/kKGB5iINP1QAJXfD8
        g0srVrBfMkThtrF609Zsi3H00w==
X-Google-Smtp-Source: ADFU+vtloprSXesJvtRnEjLPOoV7EqcOa08m/oOOJVTgeOAFV+HVZ4G4S3W0WCB1yQtt7cfGvfhQRA==
X-Received: by 2002:a1c:7207:: with SMTP id n7mr2819390wmc.138.1584420888626;
        Mon, 16 Mar 2020 21:54:48 -0700 (PDT)
Received: from rayagonda.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i67sm2874498wri.50.2020.03.16.21.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 21:54:47 -0700 (PDT)
From:   Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Subject: [PATCH v1 1/1] net: phy: mdio-mux-bcm-iproc: check clk_prepare_enable() return value
Date:   Tue, 17 Mar 2020 10:24:35 +0530
Message-Id: <20200317045435.29975-1-rayagonda.kokatanur@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check clk_prepare_enable() return value.

Fixes: 2c7230446bc9 ("net: phy: Add pm support to Broadcom iProc mdio mux driver")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
---
 drivers/net/phy/mdio-mux-bcm-iproc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio-mux-bcm-iproc.c b/drivers/net/phy/mdio-mux-bcm-iproc.c
index 88d409e48c1f..aad6809ebe39 100644
--- a/drivers/net/phy/mdio-mux-bcm-iproc.c
+++ b/drivers/net/phy/mdio-mux-bcm-iproc.c
@@ -288,8 +288,13 @@ static int mdio_mux_iproc_suspend(struct device *dev)
 static int mdio_mux_iproc_resume(struct device *dev)
 {
 	struct iproc_mdiomux_desc *md = dev_get_drvdata(dev);
+	int rc;
 
-	clk_prepare_enable(md->core_clk);
+	rc = clk_prepare_enable(md->core_clk);
+	if (rc) {
+		dev_err(md->dev, "failed to enable core clk\n");
+		return rc;
+	}
 	mdio_mux_iproc_config(md);
 
 	return 0;
-- 
2.17.1

