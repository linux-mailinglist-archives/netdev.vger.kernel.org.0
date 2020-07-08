Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74AC217E86
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 06:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgGHEpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 00:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgGHEpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 00:45:18 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E29C061755;
        Tue,  7 Jul 2020 21:45:17 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc9so639229pjb.2;
        Tue, 07 Jul 2020 21:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gLMAmNiCMy+RT8bhIKeBL8qkBrB4WwNlrcJSH73HzN0=;
        b=p50GyBOZKlfNiyvxDDGngs3VwL9oXRNknv7Af1c/isxdBBP5eWfSksKeEH/4kbYo4Q
         csIlvswDKMhYBszKDPpyBV0zRaaGXLbtKpnqn/8K7oO9pxxBlyYzURiPh+isYm9N1KR8
         RkIT3kA0NJ2f/shHMS1RVtfg+6CrTsgcWJAexT2RLuVjDbjn7MR8s7wvzmbf+GOhoVre
         xJFpJpmt7zgh2EFsih2pLdnWCCPHwelxemfJIw7iPTzNUpviTVTVUg8CdJCeo7hmNU31
         8vKz/qX64Yi3w///Qb3S2EOtiI7ALSnNUGRK7E0Pb5dFhRwPQ6Xr9CjjL9oWRH1ETAD6
         qKzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gLMAmNiCMy+RT8bhIKeBL8qkBrB4WwNlrcJSH73HzN0=;
        b=m/7fdQPZmIgn2tZFKc3sLvYNgpSONsyppN4rbXcytzF2oLcAue3jmKsm+aufsFez8C
         GjimTERM8KUtRoi6p/SIJp2tvcxiSqk91P9LMyfxhb4Hamy2tHEZb1qBr/VQNK9DnJBU
         NddnHL9kZMzvj4myFDDxSsMg/t71tlQqcgOCVNyx1vh3M+iSBRGrpxsOW4f7l03bFAzQ
         HgypTCGQPE0IRgZMl+EyNMY2ZOpXoBrYIZMBUdtJdpK+CIWGhK1wAxvnrNv5JiOPIDIU
         ZRqXnLWuF5uuBTjIZ58du/HI0woRdKdr7AhIzvTvEUj7MioJPcgNICv0U8233y2Qq3yR
         Guxw==
X-Gm-Message-State: AOAM530Uwh+SyeOu1dHSOLavt1Yx1C50mQDcnDZrGb28lNvh73mU5idb
        CQw1pjlD+c6ffjhFitG1pKh+cy2t
X-Google-Smtp-Source: ABdhPJyD1Y4B+XDDpURNCpOXp/veAoK0yjPsf5GCHKSZwT3YFUbp65bRQUZtJ5WI4DXgtVQOO8NfxQ==
X-Received: by 2002:a17:902:d203:: with SMTP id t3mr50095838ply.168.1594183516962;
        Tue, 07 Jul 2020 21:45:16 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s30sm2425986pgn.34.2020.07.07.21.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 21:45:16 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: loop: Print when registration is successful
Date:   Tue,  7 Jul 2020 21:45:13 -0700
Message-Id: <20200708044513.91534-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a number of error conditions that can lead to the driver not
probing successfully, move the print when we are sure
dsa_register_switch() has suceeded. This avoids repeated prints in case
of probe deferral for instance.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/dsa_loop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index 400207c5c7de..f8bc85a6e670 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -280,13 +280,11 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 	struct dsa_loop_pdata *pdata = mdiodev->dev.platform_data;
 	struct dsa_loop_priv *ps;
 	struct dsa_switch *ds;
+	int ret;
 
 	if (!pdata)
 		return -ENODEV;
 
-	dev_info(&mdiodev->dev, "%s: 0x%0x\n",
-		 pdata->name, pdata->enabled_ports);
-
 	ds = devm_kzalloc(&mdiodev->dev, sizeof(*ds), GFP_KERNEL);
 	if (!ds)
 		return -ENOMEM;
@@ -311,7 +309,12 @@ static int dsa_loop_drv_probe(struct mdio_device *mdiodev)
 
 	dev_set_drvdata(&mdiodev->dev, ds);
 
-	return dsa_register_switch(ds);
+	ret = dsa_register_switch(ds);
+	if (!ret)
+		dev_info(&mdiodev->dev, "%s: 0x%0x\n",
+			 pdata->name, pdata->enabled_ports);
+
+	return ret;
 }
 
 static void dsa_loop_drv_remove(struct mdio_device *mdiodev)
-- 
2.25.1

