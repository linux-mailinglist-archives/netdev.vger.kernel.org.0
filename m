Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E862D4E7C64
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiCYVhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbiCYVhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:37:04 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BEB4AE18;
        Fri, 25 Mar 2022 14:35:28 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 39CE5223EF;
        Fri, 25 Mar 2022 22:35:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648244126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27yngU6sVEBTcgQiRJF+lH0cl/M6IIi4+XryN4/LJm0=;
        b=c95fINXdR1vegJ6ASBWLXnERZBU/hlTGtisKwNbgl+QdxB+lFGMSykyUpYcvKpTJ1z924J
        vm+ey71g+ew/bUQ1fvys3rJBFgPp9bD+i9fnc76EgWpJG6oEcrMm4c4tQDayBDqaL9/mUz
        5iw/baY8DPQuNl/DiC7F7b6Xtxe5tX0=
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 2/8] net: phy: mscc-miim: add probe_capabilities
Date:   Fri, 25 Mar 2022 22:35:12 +0100
Message-Id: <20220325213518.2668832-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220325213518.2668832-1-michael@walle.cc>
References: <20220325213518.2668832-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver is currently only capable of doing c22 accesses. Add the
corresponding probe_capabilities.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-mscc-miim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 582969751b4c..c9efcfa2a1ce 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -225,6 +225,7 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 	bus->read = mscc_miim_read;
 	bus->write = mscc_miim_write;
 	bus->reset = mscc_miim_reset;
+	bus->probe_capabilities = MDIOBUS_C22;
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mii", dev_name(dev));
 	bus->parent = dev;
 
-- 
2.30.2

