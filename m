Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C7C6B6089
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCKUc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:32:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCKUcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:32:23 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041546EB8B;
        Sat, 11 Mar 2023 12:32:21 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso8370992wmi.4;
        Sat, 11 Mar 2023 12:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678566740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AiLJyC+6k3bEzF5maSzcooJwMJcf3Q5KbHqa7PEiDPg=;
        b=RSW7uLyydfqSkK+kbYZlAGLLiKXymwFmaDXYkCFJ/HanDlB+S7O4TXVpSqXo8wXGzh
         mv9DqcEpEMJSDhL2zK37QTfTDt0O04R/GUlo17mqW1TGJs5h9ECXYLaCzvEjC1xx1T1w
         m3KIwTLdunLoaE3+3sygLZ4aqd2PC8dg2Z9hSyzd3Uxu2nKo4T8qyupf4bNvzgPBafCZ
         AkKfQKapKI1bZV8SvbzkUEkn/cM0TKfkQp8YOQHpppJTVXDhSDb+5iHxoTrtmj33vh4/
         I+sKIQqbKpZiJulcOMaB9Elly4BTZoYVzukAj8Od42DV1E0Nc912/fSN4t4W/OOX7cW2
         N6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678566740;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AiLJyC+6k3bEzF5maSzcooJwMJcf3Q5KbHqa7PEiDPg=;
        b=ytvVzYbqeCINWeX5JA04stpuXW2JcU+QJkxDSedCiVlSehoeTtF+Kum+XImkIx1AZx
         jcFb25zhsF+brtaK6OdqRtY6VLVDynMaxZzRG4QtSFrjDtubADaX1gG+ecLNlXOHZLCI
         +AXpTghDZ3BXUEYzuZ4vrMOvX1EY4/ILvisH0yIE+UkKQIWvrhsxG4lDs3MjXz2TVrMq
         NkLmlebEso/PV5w9gTyFFSiF4tc7DTHLSiVYWhCVYCzI2qdQCNUMkuAx7U+sBIq+0uav
         d1yqID8b57w0aEqlfj8Y3usuK/6Mwnv+V0JzqtbsUQ77PEWE/bq22uf912MqstcPqIsR
         HeeQ==
X-Gm-Message-State: AO0yUKW2G1VrGTgKBh5O7Uwn/TE6wrdzyyrd51BoxBnktK1UnKhmCapL
        DGRGlOPC7o5lGP2HVKdUHE4=
X-Google-Smtp-Source: AK7set8Mv9KzGDv44Kr2nfG73QRQxsQ0saH5Ma2MOS5ixWnzTH1wFf2yAef1g+2IlNTweYJXQIF9Ww==
X-Received: by 2002:a05:600c:4e87:b0:3eb:38a2:2bcd with SMTP id f7-20020a05600c4e8700b003eb38a22bcdmr6421236wmq.28.1678566739963;
        Sat, 11 Mar 2023 12:32:19 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:cb1:a328:ee29:2bd6])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c451100b003dc434b39c7sm4524319wmo.0.2023.03.11.12.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 12:32:19 -0800 (PST)
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Klaus Kudielka <klaus.kudielka@gmail.com>
Subject: [PATCH net-next v2 2/3] net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
Date:   Sat, 11 Mar 2023 21:31:31 +0100
Message-Id: <20230311203132.156467-3-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230311203132.156467-1-klaus.kudielka@gmail.com>
References: <20230311203132.156467-1-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call the rather expensive mv88e6xxx_mdios_register() at the beginning of
mv88e6xxx_setup(). This avoids the double call via mv88e6xxx_probe()
during boot.

For symmetry, call mv88e6xxx_mdios_unregister() at the end of
mv88e6xxx_teardown().

Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
v2: Extend the cleanup in mv88e6xxx_setup() to remove the mdio bus on failure

 drivers/net/dsa/mv88e6xxx/chip.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 496015baac..29b0f3bb1c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3840,9 +3840,9 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 	}
 }
 
-static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
-				    struct device_node *np)
+static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip)
 {
+	struct device_node *np = chip->dev->of_node;
 	struct device_node *child;
 	int err;
 
@@ -3877,9 +3877,12 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 
 static void mv88e6xxx_teardown(struct dsa_switch *ds)
 {
+	struct mv88e6xxx_chip *chip = ds->priv;
+
 	mv88e6xxx_teardown_devlink_params(ds);
 	dsa_devlink_resources_unregister(ds);
 	mv88e6xxx_teardown_devlink_regions_global(ds);
+	mv88e6xxx_mdios_unregister(chip);
 }
 
 static int mv88e6xxx_setup(struct dsa_switch *ds)
@@ -3889,6 +3892,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	int err;
 	int i;
 
+	err = mv88e6xxx_mdios_register(chip);
+	if (err)
+		return err;
+
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
 
@@ -4015,7 +4022,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-		return err;
+		goto out_mdios;
 
 	/* Have to be called without holding the register lock, since
 	 * they take the devlink lock, and we later take the locks in
@@ -4024,7 +4031,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	 */
 	err = mv88e6xxx_setup_devlink_resources(ds);
 	if (err)
-		return err;
+		goto out_mdios;
 
 	err = mv88e6xxx_setup_devlink_params(ds);
 	if (err)
@@ -4040,6 +4047,8 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 	mv88e6xxx_teardown_devlink_params(ds);
 out_resources:
 	dsa_devlink_resources_unregister(ds);
+out_mdios:
+	mv88e6xxx_mdios_unregister(chip);
 
 	return err;
 }
@@ -7220,18 +7229,12 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out_g1_atu_prob_irq;
 
-	err = mv88e6xxx_mdios_register(chip, np);
-	if (err)
-		goto out_g1_vtu_prob_irq;
-
 	err = mv88e6xxx_register_switch(chip);
 	if (err)
-		goto out_mdio;
+		goto out_g1_vtu_prob_irq;
 
 	return 0;
 
-out_mdio:
-	mv88e6xxx_mdios_unregister(chip);
 out_g1_vtu_prob_irq:
 	mv88e6xxx_g1_vtu_prob_irq_free(chip);
 out_g1_atu_prob_irq:
@@ -7268,7 +7271,6 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 
 	mv88e6xxx_phy_destroy(chip);
 	mv88e6xxx_unregister_switch(chip);
-	mv88e6xxx_mdios_unregister(chip);
 
 	mv88e6xxx_g1_vtu_prob_irq_free(chip);
 	mv88e6xxx_g1_atu_prob_irq_free(chip);
-- 
2.39.2

