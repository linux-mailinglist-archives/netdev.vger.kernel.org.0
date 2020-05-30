Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F521E90F1
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgE3Lw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728944AbgE3LwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:22 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E985C08C5CA
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id s19so3715595edt.12
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dt1XKktXzRDTOYngwahrTX9WYDjvsKF6b5PDuFG6dHM=;
        b=niJbK9fsdsigUUxnpuSp+myF2goSH+8qcbPTLxdSLWQzZZrbf0E1lIo2nkQDGUnzeJ
         vy71DlRZbblwK+QCLyIcWvYCQIRPDTWPqgVH8Va8JOhcKkOVkc8iFK4lBSqiMLiJCNO3
         kaqVfOXfCYWE5l1a5OWVY05GUHpujzbClU15lPcabaNK3jKMWotW0m+El8QVy7PupMO/
         Wcp3NU86REc9vJwJWRaoNI9AVZVUem9frnzvIc1Aan8pRZHahjdy98AsKaiw5dSq+ytQ
         pX8BYi+gijFzAvJ4V5YJescRrbrMoCoIUPVq68lQ39xEgRhxsvD1LgFnPYT5Bc33/MQE
         wxCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dt1XKktXzRDTOYngwahrTX9WYDjvsKF6b5PDuFG6dHM=;
        b=Y+/BY7NI5Xazjfc7sYlHXVSfPnEw4zbk/URMn2PwM324Tl1YAgIuRdl1iybt7A8kXg
         MPoFMxdhnmhDnL7uA9E1mXwlUjUQK93WDP7acszkcKMvYOwuPBBBEwL33eBN/+cn8kmI
         dObAdcPt6yiIj4uO0uPIeFb8aWOqtAPwikuFvFk9OE4aOuT8MLT7qwAwiphZgEbOOInP
         WlEv2QSqU8jgEoVjaRyZBaF9SiOTEciCtvUVqcJ9QtHqDMzcjU65pmm8eApM+JiT7UMM
         vHkLLoZttvpVDAEsu37XSHUxq7DwcddnfiebcAi1omBQq9LYud05MMdKHwNZLUxbWBrl
         Eztw==
X-Gm-Message-State: AOAM532/5dMqsokKf0HVtDHXnU2fCdc1miR6KSiWsSnE/f+0kJPeOrnH
        gabFqO2I+0IOR5I78Aph9Vs=
X-Google-Smtp-Source: ABdhPJzV+MoFAi9F7URrldk4M/0lFO950CINKfua8XIJS0FXA1UBt677Vc6Gv81r4yLjFyf+MZj3NQ==
X-Received: by 2002:a50:eacb:: with SMTP id u11mr12489326edp.162.1590839540911;
        Sat, 30 May 2020 04:52:20 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 04/13] soc/mscc: ocelot: add MII registers description
Date:   Sat, 30 May 2020 14:51:33 +0300
Message-Id: <20200530115142.707415-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
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
---
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

