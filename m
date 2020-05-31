Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DCB1E9784
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgEaM1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728949AbgEaM1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 08:27:10 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA880C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:09 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g1so4302127edv.6
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 05:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h8MwTlbHi23ioW0K6JaEbD7P9DB5PkxgV9tC8sa9eSY=;
        b=vIa+HVKELz7Dj2qGyHXXGrt56eTaylEbn8r0wm4kQdt4lGjzTAzCKzoPthq7On+Q0w
         NnjelgcdL8DYQKo6CcuHIDkt8r9Pkqs/OZM57jOSGtcLcqESYbcKJwY7Hvbbc7wqSePE
         b/kQlDo2yQpF4qU0IYDzLyNS5NSRQv1JZPBp3rUuOCY7M5b1r/bB6nRqfGedx6OM4Ac0
         8VZMa0RHWnMayu55egUYTAlkJlnpqVZzHP/AL8fxpwrfSSKHM7yrHXl1iCmN7lpLVXAC
         Z1Tg9xOHMBJBac4VTsebu7hdGNBNtnk36FVow1ZFuavhnljPXW/xIP7B6VK6wgc5nIhm
         6Mzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8MwTlbHi23ioW0K6JaEbD7P9DB5PkxgV9tC8sa9eSY=;
        b=XDGSZ1XmkQAhsbklktRujbfkfD5j4ag4m2Jr6afqGXnJ+P7zXjCKsD6KCkKBHUhq7D
         hUEEg8ftGttwHwL7milCgBKIZvzmAPDHKtKm04g2YsLVELIP/qhwxhj+a4waLMrRv0te
         JiFtrRz4RxQx6bsSqv1B025N4LoFB55eHVm2irnQCqx9/sdIzpD3B2SY92OkI5C33Ncv
         NxTAk5xg0T/h7tIY1IacZNtQ8UxzDULGwcWM4JFD0TKrCUh0NU7bptbScKPWnpHW6eKJ
         wh5aQvvuaZJC6vo/TlYHfLVy5Xp8Q7tXIX0nDRvgoEpNVqefrkOmiTz2Yz0ZgqhUvFh1
         IM7Q==
X-Gm-Message-State: AOAM530Kx6GWyCIw11nO2E628xFt5EWh7qiPXcDYehskA1MVEeBmq7Wa
        M+pAeEmLFkBqWg5L2cZ832Y=
X-Google-Smtp-Source: ABdhPJxXHdqdR5sZ2GwSDIyvw/U/KmkgmkoMtl/7U1uZCCLfFVLm1DQXEZ+20sjoQztVgcA/3Zw+/Q==
X-Received: by 2002:aa7:d2d6:: with SMTP id k22mr138804edr.109.1590928028320;
        Sun, 31 May 2020 05:27:08 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id b16sm12870024edu.89.2020.05.31.05.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 05:27:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v3 net-next 04/13] soc/mscc: ocelot: add MII registers description
Date:   Sun, 31 May 2020 15:26:31 +0300
Message-Id: <20200531122640.1375715-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200531122640.1375715-1-olteanv@gmail.com>
References: <20200531122640.1375715-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Kochetkov <fido_max@inbox.ru>

Add the register definitions for the MSCC MIIM MDIO controller in
preparation for seville_vsc9959.c to create its accessors for the
internal MDIO bus.

Since we've introduced elements to ocelot_regfields that are not
instantiated by felix and ocelot, we need to define the size of the
regfields arrays explicitly, otherwise ocelot_regfields_init, which
iterates up to REGFIELD_MAX, will fault on the undefined regfield
entries (if we're lucky).

Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
None.

Changes in v2:
Initialize regfields array with correct size.

 drivers/net/dsa/ocelot/felix_vsc9959.c  | 2 +-
 drivers/net/ethernet/mscc/ocelot_regs.c | 2 +-
 include/soc/mscc/ocelot.h               | 5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b9415cb7bf9c..2a3c2d35165b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -469,7 +469,7 @@ static const struct resource vsc9959_imdio_res = {
 	.name		= "imdio",
 };
 
-static const struct reg_field vsc9959_regfields[] = {
+static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 5),
 	[ANA_ANEVENTS_FLOOD_DISCARD] = REG_FIELD(ANA_ANEVENTS, 30, 30),
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index f74e30087421..efe455c4ebb1 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -299,7 +299,7 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = ocelot_dev_gmii_regmap,
 };
 
-static const struct reg_field ocelot_regfields[] = {
+static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
 	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 79c77aab87e5..85b16f099c8f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -394,6 +394,9 @@ enum ocelot_reg {
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
 	GCB_SOFT_RST = GCB << TARGET_OFFSET,
+	GCB_MIIM_MII_STATUS,
+	GCB_MIIM_MII_CMD,
+	GCB_MIIM_MII_DATA,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
@@ -481,6 +484,8 @@ enum ocelot_regfield {
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
 	GCB_SOFT_RST_SWC_RST,
+	GCB_MIIM_MII_STATUS_PENDING,
+	GCB_MIIM_MII_STATUS_BUSY,
 	REGFIELD_MAX
 };
 
-- 
2.25.1

