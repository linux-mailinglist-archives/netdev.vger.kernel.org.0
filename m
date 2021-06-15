Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D563A8442
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 17:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhFOPqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 11:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhFOPq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 11:46:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFD7C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:44:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id ce15so23298477ejb.4
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 08:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyaBQFr19p/UgK4A32K8o8j5nham1TGRriUztxZwBHw=;
        b=uRZ2ZoEPd/1Ehappo8YXBSjfFohQMxoFh514UnGNvOCZSrX7zg8z7Os0miSwM9Jnc5
         IdbiVG3H25vGqiFcTndx5Ozj/vYzXF8yWrg+wdJ5JG1Bb6BXFqG032aj0BkWWm3ydgGc
         0Wgxrc2sIobHcIbeL37W/+orDmuatJ9OV31CmKAAzOXwI2Ipyv0N/VxsliBZEmOxCl1d
         LOGYVQ5f20Fv+PRpYxoEIE+d2gj6WfeawuGfbX8dzAoY1kGcZdvXXBQ++Cn3SISlT/da
         jJSBllfffc3uKmCxLgaeH1FWhOFJOOUprJPeWBarDEA/03FcNBWxcCZsohQtSB/AjVHP
         diFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyaBQFr19p/UgK4A32K8o8j5nham1TGRriUztxZwBHw=;
        b=tV3vAIvInpGAVbiOJD5GQjIRMFViH9m/uxxlyCVuWNNOBu7CTCpX1IEPJzuaxbIKIs
         0KGaOLbXlr6d3G6nMhtfXBKeQdPRY+Cudj4DSpKNatlIEkBOC3cVD9hu0XtS281mXl42
         +ALh6m3AGo16ahu2eceX/wZdHJ0J8OaMtuKYz82YQQsOoOH4shSwA1iNx3kPtsB62zdl
         RrZ3PhkUFklpxFl4v6LMZzxZA0WD1QJqkfxZHjIlxHnEURpZnc9cJkhEqhdkLm7ggNF4
         E9iDvGmgU7JJ9g8wtla4xczyocEfBozIGE7fSvdS6BsUwF4/8f0vu9e4xxmizglDCJBP
         Msnw==
X-Gm-Message-State: AOAM531YhLcA7LawEopmQXF98QHu5s/JhmwU0v5WUnjeyFG6SWIu0m7o
        BkdGxIiVDoZuI7pRvemHmjQ=
X-Google-Smtp-Source: ABdhPJzS7tibbgWii+oeZ9UjhqmbJaSWNfA3+H4qh1887kOueEw/CoqIy4uIo4mtEc1Y8rOtQiHIBw==
X-Received: by 2002:a17:907:9620:: with SMTP id gb32mr152072ejc.127.1623771861899;
        Tue, 15 Jun 2021 08:44:21 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id a3sm2765547edu.61.2021.06.15.08.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 08:44:21 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Date:   Tue, 15 Jun 2021 18:44:01 +0300
Message-Id: <20210615154401.1274322-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

By mistake, the of_node of the MDIO device was not setup in the patch
linked below. As a consequence, any PHY driver that depends on the
of_node in its probe callback was not be able to successfully finish its
probe on a PHY, thus the Generic PHY driver was used instead.

Fix this by actually setting up the of_node.

Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/mdio/fwnode_mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index e96766da8de4..283ddb1185bd 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -65,6 +65,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 	 * can be looked up later
 	 */
 	fwnode_handle_get(child);
+	phy->mdio.dev.of_node = to_of_node(child);
 	phy->mdio.dev.fwnode = child;
 
 	/* All data is now stored in the phy struct;
-- 
2.31.1

