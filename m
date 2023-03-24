Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE686C7B39
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjCXJYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbjCXJX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:23:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF893E3AB
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZYjKbMxs9rrG6Mj1HyNVs5oz5XYx56k9mVjodlQNaFI=; b=WKC4rifSETJBwL9emcA95aCIYI
        kar/QoRMqey7C53q6xCmrdUEuV0dm9mNbnmXDL2PTnca3ZFNp9ZJmDLvrPkSReD6uHsHjTwgQubSo
        elcueJlyh5HytEQgXuxVzxzVWyaFbjNIVVv2VFvs5M4RLFZpymrDzNPe/plahKjSTC2/Azph3Lyk4
        dOjGJj7fkU5xILZgeXZ0vvNVH21u6lT5HU41GPVcptNDHYfJ4fTyH1gO2m+LSqeRTPA4cxl+ubaug
        MWR/uwj91kE/ct+6+xec7dj9okJ7Hy7Vwo9aUqZkIX5f6Z3brbMSjhX6e/mEtDmaVNj8ueJgZ2GwM
        QfVLDq6w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pfdeL-0006k0-Qn; Fri, 24 Mar 2023 09:23:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pfdeL-00EQ6W-5M; Fri, 24 Mar 2023 09:23:53 +0000
In-Reply-To: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
References: <ZB1sBYQnqWbGoasq@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 3/3] net: phy: constify fwnode_get_phy_node() fwnode
 argument
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pfdeL-00EQ6W-5M@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 24 Mar 2023 09:23:53 +0000
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fwnode_get_phy_node() does not motify the fwnode structure, so make
the argument const,

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 2 +-
 include/linux/phy.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c0760cbf534b..917ba84105fc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3057,7 +3057,7 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
  * and "phy-device" are not supported in ACPI. DT supports all the three
  * named references to the phy node.
  */
-struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
+struct fwnode_handle *fwnode_get_phy_node(const struct fwnode_handle *fwnode)
 {
 	struct fwnode_handle *phy_node;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fefd5091bc24..2f83cfc206e5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1546,7 +1546,7 @@ int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id);
 struct mdio_device *fwnode_mdio_find_device(struct fwnode_handle *fwnode);
 struct phy_device *fwnode_phy_find_device(struct fwnode_handle *phy_fwnode);
 struct phy_device *device_phy_find_device(struct device *dev);
-struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode);
+struct fwnode_handle *fwnode_get_phy_node(const struct fwnode_handle *fwnode);
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45);
 int phy_device_register(struct phy_device *phy);
 void phy_device_free(struct phy_device *phydev);
-- 
2.30.2

