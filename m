Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92296610092
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiJ0SpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiJ0SpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:45:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E498F1A234
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:45:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B2D2421A0E;
        Thu, 27 Oct 2022 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666896303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ug/qC6R3h4KhwbzNKRGkcocRM/DhbE7HIrnlpKmDFJE=;
        b=ysX3fk1SoBIM9vOcqoRoaRCAwxp4mUG2GBzxIDicR3ZKuHE1menr+DaY73z4U60HplPm4I
        aEBjv/3wbyE8D/WC1Hkklru0IQ2Pbs6vaC8V8U2rtUgKchREBrvh3K+VRgUAHXSvNGTA2F
        21yh935cXuTnc79aGEGvGIBZmNugulo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666896303;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ug/qC6R3h4KhwbzNKRGkcocRM/DhbE7HIrnlpKmDFJE=;
        b=hmA6tWg2mI31UbtNjYr3tt1UMWUwmrRCLK9khVmYeINQSnJ7dt0K7TTvoxmGxQNbFMXdP2
        DaqlILkLFeyV8DAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6579A13357;
        Thu, 27 Oct 2022 18:45:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IuU7Ea/RWmMbFQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 27 Oct 2022 18:45:03 +0000
Message-ID: <74e1ed89-c3b7-1cbc-6880-9ca5dc5c3876@suse.de>
Date:   Thu, 27 Oct 2022 21:45:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From:   Denis Kirjanov <dkirjanov@suse.de>
Subject: [PATCH net-next v2] drivers: net: convert to boolean for the
 mac_managed_pm flag
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Language: en-US
Cc:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
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
v2: adjust the subject
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
