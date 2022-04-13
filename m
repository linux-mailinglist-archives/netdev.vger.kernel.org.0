Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D6D4FFBCD
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbiDMQ40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 12:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiDMQ4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 12:56:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC7C69CE2
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 09:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S08rCPmkZUHH2/YWZCX8RnMx6pd2IRzMvurKJf7LmgI=; b=iPguD7JgsyQ75S+OdbfuyOT3q8
        iukuWebcQFE5iu/ixQWRnPr0wZOZ87Zc6ZK/SRmxh0llxm8k23xttT/nKaQvyyCeaW3vBOeBNisgO
        cysHrCWQbPAF+HFRZ8YcpkQP8qVnYiRTyY6mj4Tt3KTK8dC6aWZifm5oObbdzI/IJCTaTj2sfHU4I
        Fg2IhHUdxvmVKmTC2K1Ogdc1mmhhrvHzF6FT4UFxDt67sLvRxwAa2pkqjwM36AFMcZsy+3L+LXTEO
        TNrHVsPmjl6dkn0ZqdJ2f/akLsuHu7SdZETrGB0pu8iv3kvb+I3QOkTJ8luiQnMI3X4nbgua8WP9T
        16V6AFuA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34512 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1negFi-0003Qa-Mg; Wed, 13 Apr 2022 17:53:58 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1negFh-005tSw-HG; Wed, 13 Apr 2022 17:53:57 +0100
In-Reply-To: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
References: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH net 2/3] net: dsa: mv88e6xxx: fix BMSR error to be consistent
 with others
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1negFh-005tSw-HG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 13 Apr 2022 17:53:57 +0100
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

