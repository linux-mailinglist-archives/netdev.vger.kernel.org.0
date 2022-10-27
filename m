Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58E1C60FB21
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 17:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbiJ0PFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbiJ0PFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 11:05:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068047B1ED
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:05:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AAE201F8D4;
        Thu, 27 Oct 2022 15:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666883128; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J00Ghbnv623mIPpo4w+TzeyZUDKZpCJ7S3nmynAlyKA=;
        b=lar+olNVHjjxio2JKsJKyNABsl91RRI2bkTgIlK2x2zBJyWFVBJET+nVb0vwIUSK4kQrMN
        umA//kC/D83TOSXFIfRjsFgIzcDvzgCmN7HQT0uWu7YJmN1YgiY1Uuzx4NLPE9OqhNwJIG
        PEqDLsrJXfRhbIZrSqb0cDDJwgPha5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666883128;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J00Ghbnv623mIPpo4w+TzeyZUDKZpCJ7S3nmynAlyKA=;
        b=X3BS9Ticnlz6ELPHfQhZtNThtZ1NFuab/1ubyk73421lujpMfJrn6l/fMLP+EmqkG4ga3j
        aYgadne4P/87NsBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 37A9B134CA;
        Thu, 27 Oct 2022 15:05:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N7loCDieWmM/JgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 27 Oct 2022 15:05:28 +0000
Message-ID: <4bca2d92-e966-81d7-d5a6-2c4240194ff4@suse.de>
Date:   Thu, 27 Oct 2022 18:05:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From:   Denis Kirjanov <dkirjanov@suse.de>
Subject: [net-next] phy: convert to boolean for the mac_managed_pm flag
To:     netdev@vger.kernel.org
Content-Language: en-US
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dennis Kirjanov <dkirjanov@suse.de>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 drivers/net/usb/asix_devices.c            | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98d5cd313fdd..4d38a297ec00 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2226,7 +2226,7 @@ static int fec_enet_mii_probe(struct net_device *ndev)
 	fep->link = 0;
 	fep->full_duplex = 0;
 
-	phy_dev->mac_managed_pm = 1;
+	phy_dev->mac_managed_pm = true;
 
 	phy_attached_info(phy_dev);
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a73d061d9fcb..5bc1181f829b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5018,7 +5018,7 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 		return -EUNATCH;
 	}
 
-	tp->phydev->mac_managed_pm = 1;
+	tp->phydev->mac_managed_pm = true;
 
 	phy_support_asym_pause(tp->phydev);
 
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 11f60d32be82..02941d97d034 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -700,7 +700,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 	}
 
 	phy_suspend(priv->phydev);
-	priv->phydev->mac_managed_pm = 1;
+	priv->phydev->mac_managed_pm = true;
 
 	phy_attached_info(priv->phydev);
 
@@ -720,7 +720,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 		return -ENODEV;
 	}
 
-	priv->phydev_int->mac_managed_pm = 1;
+	priv->phydev_int->mac_managed_pm = true;
 	phy_suspend(priv->phydev_int);
 
 	return 0;
-- 
2.16.4
