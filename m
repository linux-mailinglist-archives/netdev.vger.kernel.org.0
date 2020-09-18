Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A026FB0E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgIRK6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgIRK6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:13 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2DDC06174A
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:13 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e22so5647713edq.6
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gpqp8ycCucRqCIela9f8rkuSPifC0Oj0vgUbXhB/mpc=;
        b=eOs2EkDnZMbyLCdMnyEf3nWDcNZvABb9ATag+ehEjIJBvcZy3tfjt+a2bnopW73OqD
         SxaOvEPdqsMuFzzggl+patBjbbILb5qDc3bIc7SDAZfRP5hzFjwqPMs5WrqdlKL0tRwi
         kCNsf1gB7PtE+bfisbPDBNYlFnCvdjuudOKwIh5AGMDqPoDJhjNMkq153wUjGRALYm7b
         zDbxsXfQhg4eUfLyMfZf9ugo4Sy6TQZ/QfTuqQZ9bEZk79feQyGMKe96OeofmrCi0J3/
         YVUrsma22lB+dUAIcgWTMk6Gqq6TCMHQo4cWmUjtCAKjFqkLF6ZdmuVQ/cWx8d7VecV1
         AsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gpqp8ycCucRqCIela9f8rkuSPifC0Oj0vgUbXhB/mpc=;
        b=H0JH6i/ya9AwIWuEZjy6AwjKaXF2ayL0pFqw8EourmUeNOFJS6ui/MpFEIEpOvjyNs
         rCGvElgVpDg1xwTLoXGKFbvyrZ9CI9i+Lm2G/I1O6ySUOazBVP4EnTgKxLylNkVOY4nY
         htS18VxfKx6T3GKzJ8KfNKardnYFN0VL4GM0TogwOMFFdVfvTx8BMtPebbeqeEZaN2r9
         EYRs2SRzbmX2FW8qmb8HbElHIWUgyLtcd5i1zpeoGj5SvEQTzEJf4VvUkcfUMgcUMlHc
         /eSEm2Opd5I3VF1tbqcDjhT0WJkA900ErJ+ZX4Ma/1/YvqO1dwuibWkLVjSUcWviGP45
         VvHQ==
X-Gm-Message-State: AOAM531cvnyX1Yx2ZgkFp2rTqyrplGNYw3rkFkSdD1cWbY92SmejF6xd
        4xyjELXYLyTCNmnPlhVT8p0=
X-Google-Smtp-Source: ABdhPJz5HdjEXznlTMLCr30j5bTaVtmHF+CkTvq87iGoziNFWd/NklWBKQGcbhbt8xxBosjJZw9Knw==
X-Received: by 2002:a50:f1cf:: with SMTP id y15mr38601434edl.204.1600426692189;
        Fri, 18 Sep 2020 03:58:12 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 08/11] net: dsa: seville: duplicate vsc9959_mdio_bus_free
Date:   Fri, 18 Sep 2020 13:57:50 +0300
Message-Id: <20200918105753.3473725-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

While we don't plan on making any changes to this function, currently
this is the only remaining dependency between felix and seville, after
the PCS has been refactored out into pcs-lynx.c.

Duplicate this function in seville to break the dependency completely.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.h           |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c | 19 ++++++++++++++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 807f18b74847..1d41eeda126e 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -55,6 +55,4 @@ struct felix {
 	resource_size_t			imdio_base;
 };
 
-void vsc9959_mdio_bus_free(struct ocelot *ocelot);
-
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4dbc3283f7ea..b198fe9cb62b 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -936,7 +936,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	return 0;
 }
 
-void vsc9959_mdio_bus_free(struct ocelot *ocelot)
+static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port;
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 224f7326ddb6..23f66bb1ab4e 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -981,6 +981,23 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	return 0;
 }
 
+static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct lynx_pcs *pcs = felix->pcs[port];
+
+		if (!pcs)
+			continue;
+
+		mdio_device_free(pcs->mdio);
+		lynx_pcs_destroy(pcs);
+	}
+	mdiobus_unregister(felix->imdio);
+}
+
 static void vsc9953_xmit_template_populate(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1014,7 +1031,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
-	.mdio_bus_free		= vsc9959_mdio_bus_free,
+	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
 	.xmit_template_populate	= vsc9953_xmit_template_populate,
-- 
2.25.1

