Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEB05B7A8D
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiIMTGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbiIMTGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:06:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3258C41D13
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qCsX/xN42KYqVE2yJErZi0A7J2IJ0A6upMriekPak6o=; b=EknwukHBYrBzl+2olSAXO1095K
        Uq1c7y8HbLEwr6+09yFM14Jn6LM6FpvIdjOOUxysW1vW9ntVCJYJeySaxaIWImAT+pwdc648tK5cD
        y2GNUE35zcxysDswP+CmLgqsutido2xl35hEb4nrZFAL7aC/Ed7UZLjKhUJ2RPc1/QDe0sI3d5uox
        DLt7V0WsPzm4fxFwVZkPAZ7B0LCj4O0Rf60hGzKMdvffQoGnwqAHst6vV25TH0Kqs22xWsiS18M2S
        75mOAyWzsbsVEF5g/3IfUxUAs2naLfQH8/GPLDqyh24UfuJ0fBVWXFXOLPajadwMji+rF59p8m7bk
        mHwEPgVg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:45320 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oYBF0-0003R2-CU; Tue, 13 Sep 2022 20:06:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oYBEz-006kCE-Q5; Tue, 13 Sep 2022 20:06:37 +0100
In-Reply-To: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
References: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Josef Schlehofer <pepe.schlehofer@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/5] net: sfp: move Alcatel Lucent 3FE46541AA fixup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oYBEz-006kCE-Q5@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 13 Sep 2022 20:06:37 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new fixup mechanism to the SFP quirks, and use it for this
module.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 14 +++++++++-----
 drivers/net/phy/sfp.h |  1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 3901919e4a3f..2ef7bb4c00d1 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -311,6 +311,11 @@ static const struct of_device_id sfp_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sfp_of_match);
 
+static void sfp_fixup_long_startup(struct sfp *sfp)
+{
+	sfp->module_t_start_up = T_START_UP_BAD_GPON;
+}
+
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 				unsigned long *modes)
 {
@@ -341,6 +346,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "ALCATELLUCENT",
 		.part = "3FE46541AA",
 		.modes = sfp_quirk_2500basex,
+		.fixup = sfp_fixup_long_startup,
 	}, {
 		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
 		// NRZ in their EEPROM
@@ -2003,11 +2009,7 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (sfp->gpio[GPIO_LOS])
 		sfp->state_hw_mask |= SFP_F_LOS;
 
-	if (!memcmp(id.base.vendor_name, "ALCATELLUCENT   ", 16) &&
-	    !memcmp(id.base.vendor_pn, "3FE46541AA      ", 16))
-		sfp->module_t_start_up = T_START_UP_BAD_GPON;
-	else
-		sfp->module_t_start_up = T_START_UP;
+	sfp->module_t_start_up = T_START_UP;
 
 	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
 	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
@@ -2016,6 +2018,8 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		sfp->tx_fault_ignore = false;
 
 	sfp->quirk = sfp_lookup_quirk(&id);
+	if (sfp->quirk && sfp->quirk->fixup)
+		sfp->quirk->fixup(sfp);
 
 	return 0;
 }
diff --git a/drivers/net/phy/sfp.h b/drivers/net/phy/sfp.h
index 03f1d47fe6ca..7ad06deae76c 100644
--- a/drivers/net/phy/sfp.h
+++ b/drivers/net/phy/sfp.h
@@ -10,6 +10,7 @@ struct sfp_quirk {
 	const char *vendor;
 	const char *part;
 	void (*modes)(const struct sfp_eeprom_id *id, unsigned long *modes);
+	void (*fixup)(struct sfp *sfp);
 };
 
 struct sfp_socket_ops {
-- 
2.30.2

