Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CD26BBA07
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjCOQlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjCOQlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:41:04 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA4A30DA;
        Wed, 15 Mar 2023 09:39:57 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so1686385wmb.3;
        Wed, 15 Mar 2023 09:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678898353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/x+Wo8GJSxYlFZrOvyBDiJziMXbwhDX9RPgPROXl/vk=;
        b=HMc2lP7m+IVCQsXEGouwsbnAhnfXazvAiVaccMhwkaGD8EDUNvrUdL4ZqaIe9lT0OW
         wu6Ya+NgHyLu/5GchMv6UU/26xe0fujDsY7k2WR5sgBcGnlQTpfUiIv+6Xh7u95SvfvB
         mAY2s5kSa+DduI1HnwLb6LavwpvN5HWawqGQ+f4mBNxLl5JhU/Srlor+LKuo0n+RYeOq
         ZSJ6U14hSoAllJsyKU+QbTcHDgaRXxiZcoEnHzLtl8OKZbPtcrL0WJ8iC1BAmxwzqul0
         pSDHmXOICUqOwskdxg7hJELaAk0p/ijVY7BjSidE0j8jpa/MRFB6LUBCdYnCukeQRehq
         wVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678898353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/x+Wo8GJSxYlFZrOvyBDiJziMXbwhDX9RPgPROXl/vk=;
        b=mWG6SqXT4VjLm/fSoSSl9h90ZDajueeVskFbnMxvqdaOYQIos3wGoPiEun9Q7l8oTc
         t6g7rWwo1IDL5Tp1WbQI3zKq2FE6STh5oRJtoRx9Azd+HnYnmLwV7g6w8gXhROq5dDZ2
         DZ6Ej/kb4akgz8OP5M+Si7wTUn6L3F67/ER4ExuuqTa1jw6iraCK6kYUgxnSTWB+cDAj
         2P9YtOFC5N+NQo8PGwPzPFJ5ZDUmz/1xGn5JC6u0mV71z9ifGROQfB+DCk6eahGlMd0m
         gZRDOCydemGT8ksz7BhaGEda+rYAk0vguvX4EdlhHH+/WPYBI9oYbtY3t3ix+TxDvtZm
         q4oA==
X-Gm-Message-State: AO0yUKXGoYXFvNhXkqIV3wG0NwqAHyTwkCu885jKWDulOe+375H1D46h
        AQnwkWWEzY4MXzEVOkjh588=
X-Google-Smtp-Source: AK7set9JVtFNnE2bWhqolAB8s5NcGI1PP0sBsrb84bD1l62s4GxA4bAiyOGTXbWl620Ps6zXvOiBAA==
X-Received: by 2002:a05:600c:ccf:b0:3eb:36fa:b78d with SMTP id fk15-20020a05600c0ccf00b003eb36fab78dmr18796927wmb.23.1678898353229;
        Wed, 15 Mar 2023 09:39:13 -0700 (PDT)
Received: from mars.. ([2a02:168:6806:0:839a:f879:3eb0:8b4e])
        by smtp.gmail.com with ESMTPSA id z17-20020a5d4d11000000b002c5a1bd527dsm5039595wrt.96.2023.03.15.09.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 09:39:13 -0700 (PDT)
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
Subject: [PATCH net-next v4 3/4] net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
Date:   Wed, 15 Mar 2023 17:38:45 +0100
Message-Id: <20230315163846.3114-4-klaus.kudielka@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315163846.3114-1-klaus.kudielka@gmail.com>
References: <20230315163846.3114-1-klaus.kudielka@gmail.com>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---

Notes:
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

