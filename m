Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E721DE06
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgGMQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbgGMQ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:58:57 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A68C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:56 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so14279580edz.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CksVli2OnvKnB+mNAg0TZeXHD3eDBj1L91uCayvo5iE=;
        b=boujeM53+VegiCR98d5OJ2hkXgdXagJI40CqixahM8xay4FMetQqQYgtK5fMTDfDFm
         e+iYHscbZtb7x0clUqsxE0IdWyExA2UQygsU7j8NueN4QjnjEc002enqkTBti6ekRW4D
         0oRyQq7PL4MluCL3xHj6Xd/uHCtjo6jx6YWhj25C45jhmbXp0sk/GSE39Ly2HbJgqJcX
         zanAHXY87epvMh148GvMlX+d6j+kWjhlKAqJ+ac3/kDPiYetuRYMiOSuEDyL/DGR7FiP
         Oapx2sIBX2H2ihtVpy1MXMCAz/+COk0vk4wbFxHLbv1CU8A+UM/mqe7ATFy9GXfG6ytb
         fsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CksVli2OnvKnB+mNAg0TZeXHD3eDBj1L91uCayvo5iE=;
        b=hYG766O0Mm6fPPZ+mBqkY94elOF05AvxNjIWrUN3Clgc9Ghuu4nXN8muevJ4LmXazJ
         F0Upbm8JcmbHRKKM42/zWt4cuF+v6wN+14+8GzShzzABHubsgNAXBAQYXhMZ6zTg43gV
         F/iK2yQ0X6hXynufROynpDJRxB81k6BPiJNJLG9dyFuATl88BB2eUxI4v0EJse/YZv4y
         nh2SUuHY63CkF6wBUosIZGPY3qvS06h9wuKZL1zs/MAvvgsTgIAnWOa5lr3f3XJO6ifb
         JnpkqNOERWecjjHz0EcYLnSkKOxE+aSDUsAFhv30aksfe5cqUM4Hf38SUGu7kH4ljZjC
         /6tA==
X-Gm-Message-State: AOAM532ke75DcKixu1lXgTDBX5Y1464R+o7JSgbvR8LTnrOaQ+XGWg8q
        yajEzpM8T2EZav0zqUETnl4=
X-Google-Smtp-Source: ABdhPJxZm2lMhWe2QgfA0hA25amnHN939rh3GPbhT+mQG1wU5WZJ+y6r3Vt+40WJ/mL+Eg/S8TXA7A==
X-Received: by 2002:aa7:c3d6:: with SMTP id l22mr362256edr.148.1594659535562;
        Mon, 13 Jul 2020 09:58:55 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:58:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 02/11] soc: mscc: ocelot: add MII registers description
Date:   Mon, 13 Jul 2020 19:57:02 +0300
Message-Id: <20200713165711.2518150-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
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
Changes in v4:
Rebased on top of patch "net: mscc: ocelot: move ocelot_regs.c into
ocelot_vsc7514.c" which was merged since last submission.

Changes in v3:
None.

Changes in v2:
Initialize regfields array with correct size.

 drivers/net/dsa/ocelot/felix_vsc9959.c     | 2 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 include/soc/mscc/ocelot.h                  | 5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 0c54d67a4039..b97c12a783eb 100644
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
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 63af145e744c..83c17c689641 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -316,7 +316,7 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[DEV_GMII] = ocelot_dev_gmii_regmap,
 };
 
-static const struct reg_field ocelot_regfields[] = {
+static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 11, 11),
 	[ANA_ADVLEARN_LEARN_MIRROR] = REG_FIELD(ANA_ADVLEARN, 0, 10),
 	[ANA_ANEVENTS_MSTI_DROP] = REG_FIELD(ANA_ANEVENTS, 27, 27),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index c2a2d0165ef1..348fa26a349c 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -409,6 +409,9 @@ enum ocelot_reg {
 	PTP_CLK_CFG_ADJ_CFG,
 	PTP_CLK_CFG_ADJ_FREQ,
 	GCB_SOFT_RST = GCB << TARGET_OFFSET,
+	GCB_MIIM_MII_STATUS,
+	GCB_MIIM_MII_CMD,
+	GCB_MIIM_MII_DATA,
 	DEV_CLOCK_CFG = DEV_GMII << TARGET_OFFSET,
 	DEV_PORT_MISC,
 	DEV_EVENTS,
@@ -496,6 +499,8 @@ enum ocelot_regfield {
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
 	GCB_SOFT_RST_SWC_RST,
+	GCB_MIIM_MII_STATUS_PENDING,
+	GCB_MIIM_MII_STATUS_BUSY,
 	REGFIELD_MAX
 };
 
-- 
2.25.1

