Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F70B3AA3EE
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbhFPTKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbhFPTKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:10:37 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A45C0617AF
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:29 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id r5so6060871lfr.5
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJlskXXqPukoUIiMaWjgnuEmfc7b1Qye4aSSYHDeJ90=;
        b=j6UvX9zq/sPizWvzFQ1T0u4GCMD2XjPHC82VcPSaJaKiBAcneookTY3Ed1d02CaGrd
         7dIFeO4QpfuK14mdUlK5ACdVgDNO9Tads/4fiOTUp46WubLTThwTtqyJBpaTw2ozwf98
         kVFXdNqARq0/KzDDbnsPyhO0Q7kFR4z1uUouFCjO81jhMnN4JHGkltf4iYJKs91ZKtOU
         hlTKE9Zsm8ug4xTDHHQ4nfSgj+8RoDlwMSJe8nYjgWDGqHLoWKka/mazzDVT82VfNJrM
         Dl8fVLHuAA6racPJi0+YyHoW9cZDPQJ9s1juS5QqLvoLpul8e1h35NX0FvuZHqTV23UX
         KVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJlskXXqPukoUIiMaWjgnuEmfc7b1Qye4aSSYHDeJ90=;
        b=L29Ke9thBkeKxOelyLhKij2Ot5S3IjvpG+zzq1QMj7OkTyLotbP0G1Yud82jPBEHOh
         OWAFAjeTTj4DhfCRJb21DQeIIB1zji1HrXbfkK2FvmKh8zyjHdqfk5Yt5NiazY649TzZ
         vF2e1/keF3ZqRVijHdmWJ5FUhHQzkPAxk+rvVPuOrvg1gXIZprh9pyoErV0w4jrZiDN9
         1XjFaYv3J4H906oA0Tx+ZCwsQrMRWptEHImmrw2OOGTSn3seHYNexEy57zQUi8taSHF3
         4icD4uXABJ80OX0pMduzwgFAN+BPISq+EfSpe5fGTWBWUphXXmEbQhkcVeqSvxXz68yH
         R8IA==
X-Gm-Message-State: AOAM530mQGlDBk49EJkf2U1/5UY52IUL7O1EXCNnuSg3+HJil14NZwtu
        d9TQ+KNeEAVpbP5wstsN9igb1w==
X-Google-Smtp-Source: ABdhPJwdwrSxllmvf4YfPOQkJpoCeiA8FUGeCt7NkwLbEr7swjLDXq2ri/thhPsM39fORUQAZYi3dw==
X-Received: by 2002:ac2:51b3:: with SMTP id f19mr937764lfk.218.1623870507506;
        Wed, 16 Jun 2021 12:08:27 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id h22sm406939ljl.126.2021.06.16.12.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:08:26 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v2 6/7] net: mvpp2: enable using phylink with ACPI
Date:   Wed, 16 Jun 2021 21:07:58 +0200
Message-Id: <20210616190759.2832033-7-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210616190759.2832033-1-mw@semihalf.com>
References: <20210616190759.2832033-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the MDIO and phylink are supported in the ACPI
world, enable to use them in the mvpp2 driver. Ensure a backward
compatibility with the firmware whose ACPI description does
not contain the necessary elements for the proper phy handling
and fall back to relying on the link interrupts instead.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 22 +++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9bca8c8f9f8d..a66ed3194015 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4793,9 +4793,8 @@ static int mvpp2_open(struct net_device *dev)
 		goto err_cleanup_txqs;
 	}
 
-	/* Phylink isn't supported yet in ACPI mode */
-	if (port->of_node) {
-		err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
+	if (port->phylink) {
+		err = phylink_fwnode_phy_connect(port->phylink, port->fwnode, 0);
 		if (err) {
 			netdev_err(port->dev, "could not attach PHY (%d)\n",
 				   err);
@@ -6703,6 +6702,19 @@ static void mvpp2_acpi_start(struct mvpp2_port *port)
 			  SPEED_UNKNOWN, DUPLEX_UNKNOWN, false, false);
 }
 
+/* In order to ensure backward compatibility for ACPI, check if the port
+ * firmware node comprises the necessary description allowing to use phylink.
+ */
+static bool mvpp2_use_acpi_compat_mode(struct fwnode_handle *port_fwnode)
+{
+	if (!is_acpi_node(port_fwnode))
+		return false;
+
+	return (!fwnode_property_present(port_fwnode, "phy-handle") &&
+		!fwnode_property_present(port_fwnode, "managed") &&
+		!fwnode_get_named_child_node(port_fwnode, "fixed-link"));
+}
+
 /* Ports initialization */
 static int mvpp2_port_probe(struct platform_device *pdev,
 			    struct fwnode_handle *port_fwnode,
@@ -6921,8 +6933,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
 	dev->dev.of_node = port_node;
 
-	/* Phylink isn't used w/ ACPI as of now */
-	if (port_node) {
+	if (!mvpp2_use_acpi_compat_mode(port_fwnode)) {
 		port->phylink_config.dev = &dev->dev;
 		port->phylink_config.type = PHYLINK_NETDEV;
 
@@ -6934,6 +6945,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		}
 		port->phylink = phylink;
 	} else {
+		dev_warn(&pdev->dev, "Use link irqs for port#%d. FW update required\n", port->id);
 		port->phylink = NULL;
 	}
 
-- 
2.29.0

