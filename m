Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738C54BC844
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 12:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiBSLrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 06:47:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbiBSLro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 06:47:44 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BB21E549C
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 03:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2ufcz81bIM/qxAJ8OIMauIDGcp22GILNHfGj77rB0e4=; b=wDcoVzy0Q5vFbDZCP4trHJuRBj
        fNmGFTYTj4t9YmxkJZqVkdQdxd20F80YlJXsJRaxOlEUm3LaHn1cZsA/Q8JqTtDSBaAXx2Flz/5JG
        LOFXMKgiVGWFDhcu9x8jKURBSp0Yr2AvS6QWEWZ2ssVBMotLQ15RithuK62fwttHr6PQv/usqVTVK
        fjLQ+UhABFrUduxQCdNSQdq2PdvMXGVzvSqUvtOY8K2V5PdZ2ObxITlR8kX19gQpwoQ3QPTCYkmGG
        DPHa9/sJbFHfz1TNCzQYLgcBx7IEzGRy9VniFINv5+c7t2BoA6rHXXf8qriAoZxKuf1dziVD7zTLk
        vBsUQ/nw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51436 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nLOCx-00072l-3v; Sat, 19 Feb 2022 11:47:23 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nLOCw-009eFc-HP; Sat, 19 Feb 2022 11:47:22 +0000
In-Reply-To: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
References: <YhDYpHEBHGCVo+2z@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 2/2] net: phylink: remove phylink_config's pcs_poll
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nLOCw-009eFc-HP@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sat, 19 Feb 2022 11:47:22 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_config's pcs_poll is no longer used, let's get rid of it.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 3 +--
 include/linux/phylink.h   | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5b53a3e23c89..26f1219a005f 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1300,7 +1300,7 @@ void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
 
 	if (!pl->phylink_disable_state &&
 	    pl->cfg_link_an_mode == MLO_AN_INBAND) {
-		if (pl->config->pcs_poll || pcs->poll)
+		if (pcs->poll)
 			mod_timer(&pl->link_poll, jiffies + HZ);
 		else
 			del_timer(&pl->link_poll);
@@ -1673,7 +1673,6 @@ void phylink_start(struct phylink *pl)
 		poll |= pl->config->poll_fixed_state;
 		break;
 	case MLO_AN_INBAND:
-		poll |= pl->config->pcs_poll;
 		if (pl->pcs)
 			poll |= pl->pcs->poll;
 		break;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index cca149f78d35..9ef9b7047f19 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -86,7 +86,6 @@ enum phylink_op_type {
  * @type: operation type of PHYLINK instance
  * @legacy_pre_march2020: driver has not been updated for March 2020 updates
  *	(See commit 7cceb599d15d ("net: phylink: avoid mac_config calls")
- * @pcs_poll: MAC PCS cannot provide link change interrupt
  * @poll_fixed_state: if true, starts link_poll,
  *		      if MAC link is at %MLO_AN_FIXED mode.
  * @ovr_an_inband: if true, override PCS to MLO_AN_INBAND
@@ -100,7 +99,6 @@ struct phylink_config {
 	struct device *dev;
 	enum phylink_op_type type;
 	bool legacy_pre_march2020;
-	bool pcs_poll;
 	bool poll_fixed_state;
 	bool ovr_an_inband;
 	void (*get_fixed_state)(struct phylink_config *config,
-- 
2.30.2

