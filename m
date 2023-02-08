Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3DB68F2E3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 17:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjBHQKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 11:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjBHQKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 11:10:46 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEC24B185;
        Wed,  8 Feb 2023 08:10:44 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id CF29D6000E;
        Wed,  8 Feb 2023 16:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1675872643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xsfR8ufhoT9fUKkd6fUVNmCkIo3VMbEtV6/x+apmsjA=;
        b=LQV7HKkdJLYiVTlNbslrggRfaG8Ti2n2GggHcbgEK1HR4rIHNBLdXdE628WkVNxcqpcNe3
        d3+BV+F9oEklcvuLCBVKYqJJocc70CWGgC0o/W3mZS3FQ5h66IVsNWoyg0LCmU/nyIEOHP
        z9Vtoy+p4rKFutqpJhLr24kqxCZyfPm0AzgXa8x1ngOfG8bMYmOxly1uU9n9oypOvzVoR5
        X0SaMUj6+qPxmrUTBc/wHPYOypRRi++t/VLV5/fqrn8kFbJuOrE2WaB2gJ0ol6ASljjezF
        KfcG9FukyNQTZdTzXTEcc9O5BQpg6wvxMWhVw9xFAOlaNp6Jy3v79bswBEiUrg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: pcs: rzn1-miic: remove unused struct members and use miic variable
Date:   Wed,  8 Feb 2023 17:12:49 +0100
Message-Id: <20230208161249.329631-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused bulk clocks struct from the miic state and use an already
existing miic variable in miic_config().

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index c1424119e821..323bec5e57f8 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -121,15 +121,11 @@ static const char *index_to_string[MIIC_MODCTRL_CONF_CONV_NUM] = {
  * struct miic - MII converter structure
  * @base: base address of the MII converter
  * @dev: Device associated to the MII converter
- * @clks: Clocks used for this device
- * @nclk: Number of clocks
  * @lock: Lock used for read-modify-write access
  */
 struct miic {
 	void __iomem *base;
 	struct device *dev;
-	struct clk_bulk_data *clks;
-	int nclk;
 	spinlock_t lock;
 };
 
@@ -232,7 +228,7 @@ static int miic_config(struct phylink_pcs *pcs, unsigned int mode,
 	}
 
 	miic_reg_rmw(miic, MIIC_CONVCTRL(port), mask, val);
-	miic_converter_enable(miic_port->miic, miic_port->port, 1);
+	miic_converter_enable(miic, miic_port->port, 1);
 
 	return 0;
 }
-- 
2.39.0

