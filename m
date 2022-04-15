Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8941D5033BA
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347534AbiDOXdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356522AbiDOXc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80BD46B29;
        Fri, 15 Apr 2022 16:30:28 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y10so173568ejw.8;
        Fri, 15 Apr 2022 16:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5nDzaaAHa7/WeJJ4E62iP/cCLjk44LELpCyD9uJYd+s=;
        b=Er6MHtpc4IdPXf5rUA2twJd83mpeYG8RTPD1ynVEcyTIsmSGpg5fzOQMKggdCaZ7Ns
         SDlRro9MmrPzqwd64tsuRwUVT9sOON87buwPW8GsoBqtT0yp8hyy0l7+p0R5N0VdQMbd
         ++FhrfYN8vPOJ0jwfKFMMmb8ctecs2kFxjZkNAtrKMIDDZ7Wir8fQH0FCLmWo4uEWMzO
         5yw+5r6C0qUpmAOUqcYDyjVjp+/5Mnex1eZmGtHtGcU3XhjnV/zuBPxpKpLJM9srMm5r
         fu0OGUNAUHJfn/v5eCno5j15gb/iYfC1zcxVor245Sd0q8bP4idIpwkzjv9DuwXMUCTu
         4Lkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5nDzaaAHa7/WeJJ4E62iP/cCLjk44LELpCyD9uJYd+s=;
        b=ZLef2j9jt8USlm397V7XCWRAJeSiEQcl6KNuD0ThjXwIC8TWubik3fBVehbWCcKcOS
         Mk88A9V0vtDhoWuzWQ2rnsm765DdEO3SKla+hc7bbgCuTa9m3i6gaQjyfdH4Sbfp+MX3
         6wNQN88F+Aw0aZa6m68PkSoWl8ADtZDhAKJrNNff2XSGBUrNaxA3QzvLuObVtr1eaD8G
         ZbqaVOyhte9v5gJ/PGsODUNBIyGC8au8CCccXW24sFTmzTo8RXqMSYhqxu6Bcjj9TwSu
         Y9rcnh7xjya7hqPdCe+p9aiRVJ6eD1mqDTWy28McBILRl3sKeB9f6LLIWl8HNqnBcfvF
         dC5Q==
X-Gm-Message-State: AOAM530ntxW3wV7n3gKcorAwuPLgz5iGb0/ujbs04lrs2941t26gH7D9
        4WVWgL9vVPeR9lj4edEqNyU=
X-Google-Smtp-Source: ABdhPJy5w+y12JaFpUfY7+rbhIopdcIzKnPNaEPw/Yn0VtjgDutavo3bdBPD9bXKy9IZ/uJBMCPt1A==
X-Received: by 2002:a17:906:2991:b0:6cf:6b24:e92f with SMTP id x17-20020a170906299100b006cf6b24e92fmr943076eje.748.1650065427310;
        Fri, 15 Apr 2022 16:30:27 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:26 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 6/6] net: dsa: qca8k: unify bus id naming with legacy and OF mdio bus
Date:   Sat, 16 Apr 2022 01:30:17 +0200
Message-Id: <20220415233017.23275-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for multiple switch with OF mdio bus declaration.
Unify the bus id naming and use the same logic for both legacy and OF
mdio bus.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4fb1486795c4..2727d3169c25 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1323,6 +1323,8 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 		return -ENOMEM;
 
 	bus->priv = (void *)priv;
+	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d.%d",
+		 ds->dst->index, ds->index);
 	bus->parent = ds->dev;
 	bus->phy_mask = ~ds->phys_mii_mask;
 	ds->slave_mii_bus = bus;
@@ -1330,7 +1332,6 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 	/* Check if the devicetree declare the port:phy mapping */
 	mdio = of_get_child_by_name(priv->dev->of_node, "mdio");
 	if (of_device_is_available(mdio)) {
-		snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d", ds->index);
 		bus->name = "qca8k slave mii";
 		bus->read = qca8k_internal_mdio_read;
 		bus->write = qca8k_internal_mdio_write;
@@ -1340,8 +1341,6 @@ qca8k_mdio_register(struct qca8k_priv *priv)
 	/* If a mapping can't be found the legacy mapping is used,
 	 * using the qca8k_port_to_phy function
 	 */
-	snprintf(bus->id, MII_BUS_ID_SIZE, "qca8k-%d.%d",
-		 ds->dst->index, ds->index);
 	bus->name = "qca8k-legacy slave mii";
 	bus->read = qca8k_legacy_mdio_read;
 	bus->write = qca8k_legacy_mdio_write;
-- 
2.34.1

