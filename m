Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2B826FB0A
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIRK6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgIRK6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:09 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E028CC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:08 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lo4so7494465ejb.8
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q3J/co0vkI6zAikSCuzCN/o51hkGLFwBzZE9TXL3a7g=;
        b=rL6zrW6bp2ThS94wMBbQ8A2udj6NhEjuMGlz3t5C26N8Qlx/Boe/g8oPgL6ruRgEX7
         r4+ph1D6MmDj49EsycPZqqsOQWlmbFQQjBka76vF8s5fqcLT207j2UXWG7nu5SNJsSu4
         b11NywqLXGJhkCNjukkSgWx8jqBJhn/z5F45S8UHQSANfagDALAzSZAF0e6QSAHAGnRw
         eQCk5OgKDQFO5k8uxADLk+1ONA3cNTFCOgPQtYlfPSM/pvR8hAPlDVhWsPhib/16/Rz9
         i0CGaZMEb7yoFCQzHh/rJLsB7TPlao+Q1bwra61Ie9l3xAzAUpzXuj/9u8WHFPzDqIis
         b34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q3J/co0vkI6zAikSCuzCN/o51hkGLFwBzZE9TXL3a7g=;
        b=Md1rrheqp4mnyp7TQwqOnELZ1ZfL1nD1p6z+HxZvMPgLbar0LTm4uXT/zCj9qmM0j5
         Ywc0PEq6Fo4ok9fxWs5HXqtdfmOYrsJxuTG1Uth9zBAgfhxYR1k6mWVEmvHquA5DiCfQ
         mhrwLrryaIqridzlDUKNiWyKmSbyTprouWJo2tgr1vQP9qtiAHRIjj5ptJhUEEOzuQXu
         H4yNDBIK68VfhAy+uikW7OzURTuzl3QDzux66UxThQD8o2Cl25z50FqNiDHz/KDzOvnn
         UjGywSaYiQ2mJcTALBvRt3DHx5ug7u9+D5s3TtblqiA1lQ8crZ4sLl076uZbEUcUFq1U
         aoTg==
X-Gm-Message-State: AOAM530Mo6kFGT3OlGSkf8uo7waLGFUQaETa18e3MqJ2DCfdsYJYVSWN
        ByGjOEbSh+BwtSvaEI8Yrdg=
X-Google-Smtp-Source: ABdhPJyH8gsMzr2sHANNZlta2lycixEqFbWcNUWi8VirgMXbo727/A4ZAYaux1nMCmUugwK5haeewg==
X-Received: by 2002:a17:906:474f:: with SMTP id j15mr37432998ejs.468.1600426687580;
        Fri, 18 Sep 2020 03:58:07 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 04/11] net: dsa: ocelot: document why reset procedure is different for felix/seville
Date:   Fri, 18 Sep 2020 13:57:46 +0300
Message-Id: <20200918105753.3473725-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The overall idea (issue soft reset, enable memories, initialize
memories, enable core) is the same, so it would make sense that an
attempt is made to unify the procedures.

It is not immediately obvious that the fields are not part of the same
register targets, though. So add a comment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 3 +++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 397d24c9f7c2..6f6e4ef299c3 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -737,6 +737,9 @@ static int vsc9959_sys_ram_init_status(struct ocelot *ocelot)
 	return ocelot_read(ocelot, SYS_RAM_INIT);
 }
 
+/* CORE_ENA is in SYS:SYSTEM:RESET_CFG
+ * RAM_INIT is in SYS:RAM_CTRL:RAM_INIT
+ */
 static int vsc9959_reset(struct ocelot *ocelot)
 {
 	int val, err;
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index a1f25f5e0efc..dfc9a1b2a504 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -820,6 +820,10 @@ static int vsc9953_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 	return err;
 }
 
+/* CORE_ENA is in SYS:SYSTEM:RESET_CFG
+ * MEM_INIT is in SYS:SYSTEM:RESET_CFG
+ * MEM_ENA is in SYS:SYSTEM:RESET_CFG
+ */
 static int vsc9953_reset(struct ocelot *ocelot)
 {
 	int val, err;
-- 
2.25.1

