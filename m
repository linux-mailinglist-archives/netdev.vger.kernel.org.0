Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBFBD114CFA
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 08:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfLFHy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 02:54:58 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42729 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfLFHy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 02:54:58 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so2920974pfz.9;
        Thu, 05 Dec 2019 23:54:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZCiJ24qa3oPy6lPkJseDSCvDIIYOKBVv7JCU4ZJpe5s=;
        b=q8htx9V/b+/ngJORFZX/U07pQZCNk8SBmwfm+IQ55IaVtK2l1fl2b4FC6OVgq7eXQs
         kabv8jz/VGTVbc3BBELgbHlYSC9ciWJLMrEus9n+8dDmwVd+sHYwkjuuXZ9PGglxojKa
         /BysCeLY3gEMWfiPhTH3Kv7psQ+gHMlNwuRBrYEHHgDtJXVSCFNL//1rMVEaS6Vy5TBI
         S8h73faubsOLqv77kerwNlHbAjcdWT+C8YykvSbjFC4315YepoPzY8/ICTH1Z48mknkG
         uCDJtirnCMR3HRAHTiBYmaaB7I6eefhMgbxTjJoIsBP1YL29cwSRwxi7fV0Ev5mZgqC0
         UNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZCiJ24qa3oPy6lPkJseDSCvDIIYOKBVv7JCU4ZJpe5s=;
        b=JDIWSSabgJFOok6ZP3bpW/gDw6/tl/SrGBDojiIVT1FT3LfSRNn9hwCFjn6tlPdyms
         FXtTSsYgjBN0T/AfF2Q5rKTTC/ZuhgXh+qWeRl0WB1GaB5OIwST8Yt/6DrGFe60cy0UK
         NGSAwVkQB4tpKN7STfcv7hc4QIim3cKiQy/btiyr19i8rgdfYvuf1LwHybgWuDerXqcl
         DtzEiQH80m4oKxkzatOBLJpP8mkeMO2hQ/d36x/zRTAVtQMgnYrh+zBeMd2LyQJfizD7
         2idCN2o5fSVKLIM9uYJQgI6Aa9wSVJM36BYHVJVmFqYYoVtZ7rcZlGcVwXg60wy/uKvW
         I2MA==
X-Gm-Message-State: APjAAAV1bQ8R90m6V6URus3CijLZ21u2o3+jP7xClcYfaGlT1fFMvboW
        XiBG8FoDWTIWXis0T4JH7xw=
X-Google-Smtp-Source: APXvYqz8a0Oe3bR/aUyDCb2/H+kk2LftXinQeSwWAoWZEKLUTTFh5RkYEgZK1KZi8+lQ0jEOkyIr8A==
X-Received: by 2002:a63:504f:: with SMTP id q15mr2068405pgl.8.1575618897418;
        Thu, 05 Dec 2019 23:54:57 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id 136sm13856794pgg.74.2019.12.05.23.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 23:54:56 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] phy: mdio-thunder: add missed pci_release_regions in remove
Date:   Fri,  6 Dec 2019 15:54:46 +0800
Message-Id: <20191206075446.18469-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver forgets to call pci_release_regions() in remove like that
in probe failure.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/phy/mdio-thunder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mdio-thunder.c b/drivers/net/phy/mdio-thunder.c
index b6128ae7f14f..2a97938d1972 100644
--- a/drivers/net/phy/mdio-thunder.c
+++ b/drivers/net/phy/mdio-thunder.c
@@ -129,6 +129,7 @@ static void thunder_mdiobus_pci_remove(struct pci_dev *pdev)
 		mdiobus_free(bus->mii_bus);
 		oct_mdio_writeq(0, bus->register_base + SMI_EN);
 	}
+	pci_release_regions(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
 
-- 
2.24.0

