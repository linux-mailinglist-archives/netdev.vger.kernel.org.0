Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6525221A734
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGISnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgGISno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:43:44 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E1BC08C5CE;
        Thu,  9 Jul 2020 11:43:43 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so1397366pfi.2;
        Thu, 09 Jul 2020 11:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zrAh6RYH46bGf89a0AIXAF4lgmMCYC94Zg5yeKwIb90=;
        b=K5VfzWBrCKorOTK9sywIZ2ezQEBFSf68ClRpb62R75JqyiSC0cigFG4M12kwfnkZJB
         YS1znwCzMogJ9A4CzZoFJ4PzglUzTeS/cav8KLyh83v2x/jGKPR+biiouY7Sys8W5PO+
         U5nFN3YHXYehFlg/d3nwC51Qy8CrQ5m10Yp7zaNraD4ZvUM0nNYVEnjGkJkdqmsIzj9g
         4ARnHW87kYuL/IJCgIjC5rERRzRry1K1uFIPXvp2gO4k+Nxf3S25yOMZ6Qju4XtPox5w
         W3CtPIsuRPGQ9KMr8k0ZLossjF5TXKsGlKeGvhaXQ7arERslDeEkWFY6SNdeLUGIBwJD
         KdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zrAh6RYH46bGf89a0AIXAF4lgmMCYC94Zg5yeKwIb90=;
        b=jponwZNtfzbSYb3ofS6TcelvnPE13oHKNBRjCSVSh2VQqBxzSB5lkpwknslhn/Jh9K
         jmg8gkUHF/P9A1u4Dovx4dyG3YYE2v/XlWaMpVJtN0RoLsMCTEJFD4Goh/ko9kYvhz18
         YvTPdl/dtCYwF8Ggcw2IJxn92vHj+I4m5B6yTyu68KkBnpHxY6KPQkW/S8gF3Riq8wF2
         /OymuNLnSceiEGWkFK+Tgtxs7KnOTvqHeWSzW4DfeC6PRxdr7Gk4gyGJ30LMxDsI85Qe
         B98thCC2WzODZsryVhKwOVDeObBPnkf5VXZCLwYwhUWozcdZDSBCJ8URTmk+vYY7hMHX
         9eiQ==
X-Gm-Message-State: AOAM5303UXb3Q/1Cf+IzITu+8EwIrEqymTs2az10viNUysoLUWZxVdmU
        +ORqE2Wh06SD1FyBD4EINcU=
X-Google-Smtp-Source: ABdhPJwu5oDS2DXNshKPqNoq+4Y55IgTBjP8/9OTn6H0r/sEvI8hDdQDCjjuDo8uACUiWYd5RoHW5A==
X-Received: by 2002:a65:4c0b:: with SMTP id u11mr53908414pgq.383.1594320223339;
        Thu, 09 Jul 2020 11:43:43 -0700 (PDT)
Received: from localhost.localdomain.com ([2605:e000:160b:911f:a2ce:c8ff:fe03:6cb0])
        by smtp.gmail.com with ESMTPSA id s22sm3553999pfm.164.2020.07.09.11.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:43:42 -0700 (PDT)
From:   Chris Healy <cphealy@gmail.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Chris Healy <cphealy@gmail.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Add serdes read/write dynamic debug
Date:   Thu,  9 Jul 2020 11:43:18 -0700
Message-Id: <20200709184318.4192-1-cphealy@gmail.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add deb_dbg print statements in both serdes_read and serdes_write
functions.

Signed-off-by: Chris Healy <cphealy@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9c07b4f3d345..756b34343547 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -20,14 +20,25 @@
 static int mv88e6352_serdes_read(struct mv88e6xxx_chip *chip, int reg,
 				 u16 *val)
 {
-	return mv88e6xxx_phy_page_read(chip, MV88E6352_ADDR_SERDES,
+	int err;
+
+	err =  mv88e6xxx_phy_page_read(chip, MV88E6352_ADDR_SERDES,
 				       MV88E6352_SERDES_PAGE_FIBER,
 				       reg, val);
+
+	if (err)
+		return err;
+
+	dev_dbg(chip->dev, "serdes <- reg: 0x%.2x val: 0x%.2x\n", reg, *val);
+
+	return 0;
 }
 
 static int mv88e6352_serdes_write(struct mv88e6xxx_chip *chip, int reg,
 				  u16 val)
 {
+	dev_dbg(chip->dev, "serdes -> reg: 0x%.2x val: 0x%.2x\n", reg, val);
+
 	return mv88e6xxx_phy_page_write(chip, MV88E6352_ADDR_SERDES,
 					MV88E6352_SERDES_PAGE_FIBER,
 					reg, val);
@@ -37,8 +48,17 @@ static int mv88e6390_serdes_read(struct mv88e6xxx_chip *chip,
 				 int lane, int device, int reg, u16 *val)
 {
 	int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
+	int err;
+
+	err = mv88e6xxx_phy_read(chip, lane, reg_c45, val);
+	if (err)
+		return err;
+
+	dev_dbg(chip->dev, "serdes <- lane: %.2d device: 0x%.2x reg_c45: 0x%.4x val: 0x%.4x\n",
+		lane, device, reg_c45, *val);
+
+	return 0;
 
-	return mv88e6xxx_phy_read(chip, lane, reg_c45, val);
 }
 
 static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
@@ -46,6 +66,9 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 {
 	int reg_c45 = MII_ADDR_C45 | device << 16 | reg;
 
+	dev_dbg(chip->dev, "serdes -> lane: %.2d device: 0x%.2x reg_c45: 0x%.4x val: 0x%.4x\n",
+		lane, device, reg_c45, val);
+
 	return mv88e6xxx_phy_write(chip, lane, reg_c45, val);
 }
 
-- 
2.21.3

