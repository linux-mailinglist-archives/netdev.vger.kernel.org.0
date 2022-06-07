Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCBA53FD7B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbiFGL3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241918AbiFGL2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:28:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E876FA23
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S08rCPmkZUHH2/YWZCX8RnMx6pd2IRzMvurKJf7LmgI=; b=MJsBH5VNR+/TLwnhthbtC6Hx0c
        DGu2gE/1t1dFnM/QozdOqg32SNwbsuwV1LYiK6ASij/qztpSeDAeZ3ZY1A6viosJfayjv//Ev6U4H
        yJ7AI62OLXdQOjZfkwfE06L2RCpPVBicFxytxbxCRUYMwBe14OP12SrEtUxPrGCpIYq/C0ynCAvPF
        SH2Ofn07invwHT6sNuYK0+coiOdBMEyZPqsALHm52H4fYGPqClTI+Tzk+HNk1u8eyOYYeTx0kPSXY
        8q8Y0J3w3uapid6zFbJbXmKe3luGlKx32wCWE6GPD7z0RX0UDosztEH9WED5UDJwINB6Sdksbdm05
        L7NKPa6Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54760 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nyXOC-0003KB-DM; Tue, 07 Jun 2022 12:28:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nyXOB-00GPyR-OL; Tue, 07 Jun 2022 12:28:47 +0100
In-Reply-To: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
References: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net 2/3] net: dsa: mv88e6xxx: fix BMSR error to be consistent
 with others
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nyXOB-00GPyR-OL@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Jun 2022 12:28:47 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Other errors accessing the registers in mv88e6352_serdes_pcs_get_state()
print "PHY " before the register name, except for the BMSR. Make this
consistent with the other error messages.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 1a19c5284f2c..47bf87d530b0 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -191,7 +191,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 
 	err = mv88e6352_serdes_read(chip, MII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes PHY BMSR: %d\n", err);
 		return err;
 	}
 
-- 
2.30.2

