Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B598455205F
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbiFTPNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242487AbiFTPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:12:15 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5741F636
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:57 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id a29so17725901lfk.2
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WfituUDSg5fEW4dKt2h3fMS4b0IrVjkU8185C8pJjBY=;
        b=kFdZRoBhFIxJZLPTayXCJlh5xBCUkR1K1zZ2YflpY7c0rNVWSY5swaSK9jMmPGXzxQ
         1GqoSBU6NUtXhV/7NpOPU415njrI7EcPXH9XBXd4WeC09TyT7aDShPFqectxf2XnTjKY
         X3C+gzqVgKqrfcGzRjiq9IsokgayDx9Kp7GcauUWykhbBQlMsWd8EOV4IaSf6cl1JH9m
         4LnTKNKhmnC3xGA7mV5LH3e8TIDxFESOVT9cCG43VVnWG699CI5DKudZneoExnyrS4LM
         ciWgtqOkaSmQjqfXB8SBoVjO9AlBPTrxQOKUvOTYOrQUx0YFbbDI3XM47H1u7DvEwL6s
         PPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WfituUDSg5fEW4dKt2h3fMS4b0IrVjkU8185C8pJjBY=;
        b=zbFb4rPcsERnY7iAGiA6wvA1KQvbl8SbVJigMhGnEpdvO9sbHB3i9ul9NtOUPjeqyu
         fLCPjlwqgpiUnsZwG4KZPkUni3WHDp5YOv/udfTUDCErAsXIlrxSPXBrQj+L8v1z5co+
         9yujACX1ZGzQ8cE7PETE/Fv03WODl9Ko8OHeEeUXTyNXJNSouT0w2xCfMU/KW0u2jHhC
         nKBjTRgfYIB6Ft6kkxx/UjFYX4AWD4NJXVs8iTdBAWjtm3oTWGcJjvbCQzXqBzU//uJp
         rRJQzxdN7KivG86dIuo7btGO6xkl5HrW8lvE1IU0Kdshrr7CIiYSvTJnPBBqc9QtPovB
         g5QA==
X-Gm-Message-State: AJIora8ck3LPAG3Im8KtoCe3ahU/pXedaqi/wHCg4dxLkpkCcavd+KtR
        fvR9X9hK8tNopqNdQe/6IhhELg==
X-Google-Smtp-Source: AGRyM1vqri5GOOgVM3EWWhhIHFGXwMbDMwQp2NcgRArqY1SeTMY9aLG3jE7fpVm9+Dh+PwPmgb5/Dw==
X-Received: by 2002:a05:6512:214d:b0:47f:5a25:ac11 with SMTP id s13-20020a056512214d00b0047f5a25ac11mr7963474lfr.627.1655737376113;
        Mon, 20 Jun 2022 08:02:56 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id e19-20020a05651236d300b0047f79f7758asm17564lfs.22.2022.06.20.08.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 08:02:55 -0700 (PDT)
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
Subject: [net-next: PATCH 10/12] net: dsa: add ACPI support
Date:   Mon, 20 Jun 2022 17:02:23 +0200
Message-Id: <20220620150225.1307946-11-mw@semihalf.com>
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

Although the recent switch to device_/fwnode_ API covers the most
of modifications required for supporting ACPI, minor additional
changes should be applied:

* Use different subnode names with ACPI for 'ports' and 'mdio':
  * Naming of the nodes in ACPI must conform the namespace
    constraints, with regards to the characters' type
    and ACPI_NAMESEG_SIZE [1]. Because of that, the 'ports'
    subnode name used in device tree case, is not appropriate
    in ACPI world. This patch updates the subnode name depending on
    the hardware description type in runtime.
* Obtain ports indexes from _ADR fields
  * Same as in the MDIO PHY case, use this standard field instead of
    parsing 'reg' property from _DSD object.
* For now cascade topology remains unsupported in ACPI world, so
  disable ports connected to other switch devices.

[1] https://uefi.org/specs/ACPI/6.4/05_ACPI_Software_Programming_Model/ACPI_Software_Programming_Model.html#acpi-namespace

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 net/dsa/dsa2.c | 35 +++++++++++++++++---
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 5e11d66f9057..53837dad1cca 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -6,6 +6,8 @@
  * Copyright (c) 2016 Andrew Lunn <andrew@lunn.ch>
  */
 
+#include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/device.h>
 #include <linux/etherdevice.h>
 #include <linux/err.h>
@@ -854,6 +856,7 @@ static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
+	char mdio_node_name[] = "mdio";
 	struct fwnode_handle *fwnode;
 	struct dsa_port *dp;
 	int err;
@@ -910,9 +913,16 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		dsa_slave_mii_bus_init(ds);
 
-		fwnode = fwnode_get_named_child_node(ds->dev->fwnode, "mdio");
+		/* Update subnode name if operating in the ACPI world. */
+		if (is_acpi_node(fwnode))
+			strncpy(mdio_node_name, "MDIO", ACPI_NAMESEG_SIZE);
 
-		err = of_mdiobus_register(ds->slave_mii_bus, to_of_node(fwnode));
+		fwnode = fwnode_get_named_child_node(ds->dev->fwnode, mdio_node_name);
+
+		if (is_acpi_node(fwnode))
+			err = acpi_mdiobus_register(ds->slave_mii_bus, fwnode);
+		else
+			err = of_mdiobus_register(ds->slave_mii_bus, to_of_node(fwnode));
 		fwnode_handle_put(fwnode);
 		if (err < 0)
 			goto free_slave_mii_bus;
@@ -1374,6 +1384,15 @@ static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
 
 static int dsa_port_parse_dsa(struct dsa_port *dp)
 {
+	/* Cascade switch connection is not supported in ACPI world. */
+	if (is_acpi_node(dp->fwnode)) {
+		dev_warn(dp->ds->dev,
+			 "DSA type is not supported with ACPI, disable port #%d\n",
+			 dp->index);
+		dp->type = DSA_PORT_TYPE_UNUSED;
+		return 0;
+	}
+
 	dp->type = DSA_PORT_TYPE_DSA;
 
 	return 0;
@@ -1524,11 +1543,16 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 				     struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *ports, *port;
+	char ports_node_name[] = "ports";
 	struct dsa_port *dp;
 	int err = 0;
 	u32 reg;
 
-	ports = fwnode_get_named_child_node(fwnode, "ports");
+	/* Update subnode name if operating in the ACPI world. */
+	if (is_acpi_node(fwnode))
+		strncpy(ports_node_name, "PRTS", ACPI_NAMESEG_SIZE);
+
+	ports = fwnode_get_named_child_node(fwnode, ports_node_name);
 	if (!ports) {
 		/* The second possibility is "ethernet-ports" */
 		ports = fwnode_get_named_child_node(fwnode, "ethernet-ports");
@@ -1539,7 +1563,10 @@ static int dsa_switch_parse_ports_of(struct dsa_switch *ds,
 	}
 
 	fwnode_for_each_available_child_node(ports, port) {
-		err = fwnode_property_read_u32(port, "reg", &reg);
+		if (is_acpi_node(port))
+			err = acpi_get_local_address(ACPI_HANDLE_FWNODE(port), &reg);
+		else
+			err = fwnode_property_read_u32(port, "reg", &reg);
 		if (err) {
 			fwnode_handle_put(port);
 			goto out_put_node;
-- 
2.29.0

