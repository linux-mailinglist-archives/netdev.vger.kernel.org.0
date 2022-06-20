Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B465B55203D
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbiFTPOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243340AbiFTPMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:23 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC5D1FA4F
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:03:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id s21so7154947lfs.13
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=79HyXuMDzSUSAqm9LJDxm1QulLKFCMJuKULtDaG7pgg=;
        b=nFzaIAZullAM5QpV7lhiewLkjFv18wWs2j2rGdYzDLGAKqfmRPytd4UVWA0Sfl8EJ2
         9d5m4M40GMi7QHDQ9TRwYn4Z9lkJNm2cUfefT8nA9Q/zGr4agzJ1BBbVQ9jKfFyEHmtx
         ePBznUBHD79+Z1j+mba+bqQTBIH2bJUV38tvJfn/nNjom4f3tYypl9LBWzsfCiDgjYX/
         7p1zgdkbcrzfnDn1XpWzPxkn1j/Z1oI0UWMzZtzVwFfMLXUWB6/cXOE5cCHUSYk0sgBk
         AWdAp5D8krh12xI1gZlvwuFmpn7/ZqcR8oTGJ9FEQf5A2tG5dpHH6vd84+ZI5slXizXb
         dcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79HyXuMDzSUSAqm9LJDxm1QulLKFCMJuKULtDaG7pgg=;
        b=JvyebKjOGqjiWhcYLzfGqK5ykb2aIkEGiuvhSIaCSAIqMH3vXZXFxmIXbyuNO5UIsg
         Jaaa/vrpfMsoi9sncVIg4SHahpSkoYG6QwWodBxc6jwe9LIEZrsgBOcjdd02pLelFS9F
         BBBCGaIdzRACkhdw3o2RSna9/1LY0f1gpO+MmxsCRdgN24Esh0CBPTyhJdI8JS6FZUMu
         Deetq9Ttu3rzAP50lJriZn9CYabSM3bm1Hhbeu+Mws/MNskSWj4EQ2TqPMgfSE2SQLjQ
         2DpCJstrItR1eCWUY5oYmSy7xa6sJuos+LOiXA0wz/TfRDTXXXC2gAlfbYVb3IZNeHJs
         vubA==
X-Gm-Message-State: AJIora8GGtNw2ItOKmNDT4/QKTB5VzfzZsMJ/5wkrFHAkqy0iNzggOul
        ETFOZJPUwYg2vAnrEibE1ZUH8Q==
X-Google-Smtp-Source: AGRyM1sZjX433uIfDuDxIJjCxeAulm4JqpTHnUDqeXfKIxktT74nYmgA/6lU+5nPFAWsS0NTA+T+Pg==
X-Received: by 2002:a05:6512:3c87:b0:47f:70a0:b8f2 with SMTP id h7-20020a0565123c8700b0047f70a0b8f2mr2584155lfv.407.1655737378368;
        Mon, 20 Jun 2022 08:02:58 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:58 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        lenb@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        mw@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: [net-next: PATCH 12/12] net: dsa: mv88e6xxx: add ACPI support
Date:   Mon, 20 Jun 2022 17:02:25 +0200
Message-Id: <20220620150225.1307946-13-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patches dropped the strict dependency on the OF_* API
in both generic DSA subsystem and the mv88e6xxx driver.
As a result the ACPI support can be introduced by adding
the necessary ID's in the acpi_match_table and a two
minor required adjustments, i.e. different mdiobus registration
and MDIO subnode name, so to conform ACPI namespace requirements [1].

[1] https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#acpi-namespace

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 ++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 556defa4379d..a74e528184aa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -10,6 +10,8 @@
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  */
 
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/dsa/mv88e6xxx.h>
@@ -3913,7 +3915,10 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 			goto out;
 	}
 
-	err = of_mdiobus_register(bus, np);
+	if (is_acpi_node(fwnode))
+		err = acpi_mdiobus_register(bus, fwnode);
+	else
+		err = of_mdiobus_register(bus, np);
 	if (err) {
 		dev_err(chip->dev, "Cannot register MDIO bus (%d)\n", err);
 		mv88e6xxx_g2_irq_mdio_free(chip, bus);
@@ -3952,14 +3957,19 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 				    struct fwnode_handle *fwnode)
 {
+	char mdio_node_name[] = "mdio";
 	struct fwnode_handle *child;
 	int err;
 
+	/* Update subnode name if operating in the ACPI world. */
+	if (is_acpi_node(fwnode))
+		strncpy(mdio_node_name, "MDIO", ACPI_NAMESEG_SIZE);
+
 	/* Always register one mdio bus for the internal/default mdio
 	 * bus. This maybe represented in the device tree, but is
 	 * optional.
 	 */
-	child = fwnode_get_named_child_node(fwnode, "mdio");
+	child = fwnode_get_named_child_node(fwnode, mdio_node_name);
 	err = mv88e6xxx_mdio_register(chip, child, false);
 	fwnode_handle_put(child);
 	if (err)
@@ -7177,6 +7187,16 @@ static const struct of_device_id mv88e6xxx_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, mv88e6xxx_of_match);
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id sdhci_mv88e6xxx_acpi_ids[] = {
+	{ .id = "MRVL0120", (kernel_ulong_t)&mv88e6xxx_table[MV88E6085]},
+	{ .id = "MRVL0121", (kernel_ulong_t)&mv88e6xxx_table[MV88E6190]},
+	{ .id = "MRVL0122", (kernel_ulong_t)&mv88e6xxx_table[MV88E6250]},
+	{}
+};
+MODULE_DEVICE_TABLE(acpi, sdhci_mv88e6xxx_acpi_ids);
+#endif
+
 static struct mdio_driver mv88e6xxx_driver = {
 	.probe	= mv88e6xxx_probe,
 	.remove = mv88e6xxx_remove,
@@ -7184,6 +7204,7 @@ static struct mdio_driver mv88e6xxx_driver = {
 	.mdiodrv.driver = {
 		.name = "mv88e6085",
 		.of_match_table = mv88e6xxx_of_match,
+		.acpi_match_table = ACPI_PTR(sdhci_mv88e6xxx_acpi_ids),
 		.pm = &mv88e6xxx_pm_ops,
 	},
 };
-- 
2.29.0

