Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E4F3AB393
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhFQMbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhFQMbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:31:32 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA32C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:24 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb32so1412124ejc.2
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 05:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WoIE5QZD5IuxoqB5V73GZYqkl6kX3xpPcUZhCY+T7mY=;
        b=ZNWlGvPsN55AyNsAuKBnIgOz8N+HaZprZeI4xiXgs7tYxx2fsIHRs5dK7CkCcMZaBa
         4Zhhl/IbuKLr2KLEFB4sore5lvuxFw5LUffT1anv94F97QNNsRjtI6GI1+7FU6ggBaqP
         k+JMprDA36/Tmxx6DG24YKQBzvTXn5C71vbfhCC7uqymtY803WN2XcXKlxcU56YCxVsk
         aJa4XLcueJwrjrPjDH/uf1eYMkjv1WW8mo8w6Sr9ZNPhhYblqiuZ+rbnJBigCd+3uONN
         0tO7cCn5n1kvfFr3zJB//k/UqY/nD45Rlsc+uZwtVUC3spg3DJi0/Mh2oRmr28llfbVq
         SjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WoIE5QZD5IuxoqB5V73GZYqkl6kX3xpPcUZhCY+T7mY=;
        b=VR9imlZ5Eh5AAvbpGqCBIoNjKEC7785SE5U1jZNk6WJ66aPhawHSsm3u8SSTxqbsV9
         i4GCVOQYrRiAxCkn32bw3btYAB/puirMmt5KIipbcH/xm+p5r17v1b73kenMqNdekc0y
         GwHH+uZX7VxxHbUOWVk6tC0j2OeoS4GaoVW1t5102QPPOwi09sKdO2r89Wtr1QLY6gVo
         5iUIN5dROFS+OPtgHUp/gcU0TEAAsYLUCIh6ev6z2ueXpRyugZygJCsh56g/Mi1ZcHM6
         9JWpDvYlBi24+ys/nuZsrP8B6SYGtnnnDc0nCBYDT1flpkwCEDRP6RfnZDTV4W/5aJhB
         oJpA==
X-Gm-Message-State: AOAM532ve8CE9bUGe/CtVopKez/CJ+uO9x0/pQ1HhtjMk7D6It3Kdvey
        /Nmd7KoTwKuJ3mIVQOumDzE=
X-Google-Smtp-Source: ABdhPJxqlmYt9aF9VxxKSn6zQh9MBPS9Cu55W5FH+QXvAshpHzdP1He8ta249bYFYaWSZQxjyzBrNQ==
X-Received: by 2002:a17:906:dbf3:: with SMTP id yd19mr4987335ejb.399.1623932962989;
        Thu, 17 Jun 2021 05:29:22 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id de10sm3706179ejc.65.2021.06.17.05.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 05:29:22 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        gregkh@linuxfoundation.org, rafael@kernel.org,
        grant.likely@arm.com, calvin.johnson@oss.nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 1/3] net: mdio: setup of_node for the MDIO device
Date:   Thu, 17 Jun 2021 15:29:03 +0300
Message-Id: <20210617122905.1735330-2-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617122905.1735330-1-ciorneiioana@gmail.com>
References: <20210617122905.1735330-1-ciorneiioana@gmail.com>
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
Changes in v2:
 - none


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

