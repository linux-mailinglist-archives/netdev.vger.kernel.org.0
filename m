Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2154BF594
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiBVKQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiBVKQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:16:46 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C2413EF83
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 02:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1OEms46dU74qLWGA0INHwPED/HIKfZFFAClQYerDQqI=; b=nV9WOqew0IGuqDPkasi5FL9Six
        rnxjfpcLMCOIdtoM6Mfl9qmb0ur9V8kPyqKQDslDMVrpvHcWli1dOCWH7zarlrgU6jBxVYtQrSstj
        e+bMb776H6uscnocer9dqxZFkRarEHeDhnn4cb/Budc97XfD61mJWKTcGSe5E/1cxiS0LPji/lQ/V
        NI+HH5PcrNszGETkSCvwJKBUI4VhuMLOOvKKfJlob8dvWL+h3BGTx21Jv0H377SU5vkAjBlLURy2r
        DyjSgEUbSxqiMvf7rZU1d6M3dflVDEoe/NdCVdi7KKLWRxJ98j/6dvUYcKA7KoU99U5otpGPHlJdz
        KJadx/yQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:48110 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nMSDS-0001Pp-PT; Tue, 22 Feb 2022 10:16:18 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nMSDS-00A2Ru-6J; Tue, 22 Feb 2022 10:16:18 +0000
In-Reply-To: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 5/5] net: dsa: b53: mark as non-legacy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nMSDS-00A2Ru-6J@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 22 Feb 2022 10:16:18 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The B53 driver does not make use of the speed, duplex, pause or
advertisement in its phylink_mac_config() implementation, so it can be
marked as a non-legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 50a372dc32ae..83bf30349c26 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1346,6 +1346,12 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
 	/* Get the implementation specific capabilities */
 	if (dev->ops->phylink_get_caps)
 		dev->ops->phylink_get_caps(dev, port, config);
+
+	/* This driver does not make use of the speed, duplex, pause or the
+	 * advertisement in its mac_config, so it is safe to mark this driver
+	 * as non-legacy.
+	 */
+	config->legacy_pre_march2020 = false;
 }
 
 int b53_phylink_mac_link_state(struct dsa_switch *ds, int port,
-- 
2.30.2

