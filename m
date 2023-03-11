Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5A6B5A36
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 10:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjCKJnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 04:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbjCKJm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 04:42:59 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C9714051C;
        Sat, 11 Mar 2023 01:42:32 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id j3so4912075wms.2;
        Sat, 11 Mar 2023 01:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678527751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pTRSyVCFXv4DeTX1dIB8XAxlhgF6IWiFZQle1EOSkfQ=;
        b=ZyE8ZcS+xA4PQEXEm2Gl34kdOyE0631m3uRzyzWkOK8N/XzU8ZC57FjbzwoTZDZ6l5
         uiuUfNuGdxfsRK2hEsOx+agMk2kPwPXC2cQ2mxud5+x1+laoLG2DbUIgvp3sPETIMM5M
         c6oJfV/qlZG4vYHr1t73LO/SA5BMiWlZQItt1coQcJZmuogZR+djN4J7cKzVdmG16vcO
         5s3f0nmTfniFHgidCk4w113qsszYnJ98umwuiOdTI5+G0fMb0Jbe8Khez4LZQLxDL3jx
         J7iRuRwKOWAY7H7lb0VsYJEjcJr7r9Za73UD75/3b8TAMtoG0WvOMZuomeNwxBEkEpQ9
         +t3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678527751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pTRSyVCFXv4DeTX1dIB8XAxlhgF6IWiFZQle1EOSkfQ=;
        b=wZczZpAp5EDLkVeOEiXBwthytV1pGVbssFS2TIN4c1Z8LpULffGn35hRMZSKRHYobK
         xHz3ZtsfV9H0hLD1MFhac+4to68a825zWEaHNIyvztulFNYxW8g/ZmGQAUSrfC/MmbkK
         J7tQvqxd9leJo5D6ESrLJdJsBus1y5dClCXbvvZg6iYr3Y5RXpzLZz+015sEKQ0rcIyb
         9maHeZ8HPV/zbchXg9UeJ68R0iLCgcNQv3CMBVXkCbLC1WcumvjyizDI5Un1tdx47qrV
         hSXKLlR2oLcQiX7lY4AXyfumqB1L6KZ/o7IVmMgakF356O5dmiWwssug3HgeMmr5L4Oo
         8i+A==
X-Gm-Message-State: AO0yUKVAXYDpbzL0mNTnMvhBtMVB1SRfIUXemfye/kNp/nUnglzjsjRr
        qlEeFNiCLntiUXYnSTmtXRE=
X-Google-Smtp-Source: AK7set/AmI42LiS/akZGGBnTXlLAIkiPwQBH1ZlSzopEgemx7Zpf/WlQK56HJ712RH/IhwEf5K6UGg==
X-Received: by 2002:a05:600c:548a:b0:3df:e21f:d705 with SMTP id iv10-20020a05600c548a00b003dfe21fd705mr5135223wmb.28.1678527751147;
        Sat, 11 Mar 2023 01:42:31 -0800 (PST)
Received: from mars.. ([2a02:168:6806:0:c51d:786:86a8:fd19])
        by smtp.gmail.com with ESMTPSA id n19-20020a1c7213000000b003eb39e60ec9sm2275043wmc.36.2023.03.11.01.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 01:42:31 -0800 (PST)
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
Subject: [PATCH 2/2] net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
Date:   Sat, 11 Mar 2023 10:41:41 +0100
Message-Id: <20230311094141.34578-2-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230311094141.34578-1-klaus.kudielka@gmail.com>
References: <20230311094141.34578-1-klaus.kudielka@gmail.com>
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

From commit 1a136ca2e089 ("net: mdio: scan bus based on bus capabilities
for C22 and C45") onwards, mdiobus_scan_bus_c45() is being called on buses
with MDIOBUS_NO_CAP. On a Turris Omnia (Armada 385, 88E6176 switch), this
causes a significant increase of boot time, from 1.6 seconds, to 6.3
seconds. The boot time stated here is until start of /init.

Further testing revealed that the C45 scan is indeed expensive (around
2.7 seconds, due to a huge number of bus transactions), and called twice.

It was suggested, to call mv88e6xxx_mdios_register() at the beginning of
mv88e6xxx_setup(), and mv88e6xxx_mdios_unregister() at the end of
mv88e6xxx_teardown(). This is accomplished by this patch.

Testing on the Turris Omnia revealed, that this improves the situation.
Now mdiobus_scan_bus_c45() is called only once, ending up in a boot time
of 4.3 seconds.

Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 496015baac..8c0fa4cfcd 100644
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
 
@@ -7220,18 +7227,12 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
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
@@ -7268,7 +7269,6 @@ static void mv88e6xxx_remove(struct mdio_device *mdiodev)
 
 	mv88e6xxx_phy_destroy(chip);
 	mv88e6xxx_unregister_switch(chip);
-	mv88e6xxx_mdios_unregister(chip);
 
 	mv88e6xxx_g1_vtu_prob_irq_free(chip);
 	mv88e6xxx_g1_atu_prob_irq_free(chip);
-- 
2.39.2

