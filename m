Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FDA64D5AC
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 04:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiLODsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 22:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLODsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 22:48:12 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFD34385E;
        Wed, 14 Dec 2022 19:48:11 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1p5fE5-0003wP-G6; Thu, 15 Dec 2022 04:48:05 +0100
Date:   Thu, 15 Dec 2022 03:47:59 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH net v3] net: dsa: mt7530: remove redundant assignment
Message-ID: <Y5qY7x6la5TxZxzX@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell King correctly pointed out that the MAC_2500FD capability is
already added for port 5 (if not in RGMII mode) and port 6 (which only
supports SGMII) by mt7531_mac_port_get_caps. Remove the reduntant
setting of this capability flag which was added by a previous commit.

Fixes: e19de30d2080 ("net: dsa: mt7530: add support for in-band link status")
Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
Changes since v2: correct commit title 'reduntant' -> 'redundant'
Changes since v1: Use 12 chars for fixes tag, fix Russell's contact

 drivers/net/dsa/mt7530.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index e74c6b406172..908fa89444c9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2919,9 +2919,6 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 				   MAC_10 | MAC_100 | MAC_1000FD;
 
-	if ((priv->id == ID_MT7531) && mt753x_is_mac_port(port))
-		config->mac_capabilities |= MAC_2500FD;
-
 	/* This driver does not make use of the speed, duplex, pause or the
 	 * advertisement in its mac_config, so it is safe to mark this driver
 	 * as non-legacy.

base-commit: 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91
-- 
2.39.0

