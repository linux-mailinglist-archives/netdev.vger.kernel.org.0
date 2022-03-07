Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501C44CFDE9
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 13:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiCGMOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 07:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiCGMOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 07:14:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4440C48384
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 04:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jH5AYjse+WxNHZmr7RG3+47WmqMY6ScJQoNgOCRWKRc=; b=apx16hHc60W9kgrugYuwOMejnD
        ZyielHE2YocPyBHLjDvyoYdPr+bUUjA+Zr1vEjp8ZlZOIq/5r84GQL2U238HN69+H+fU1qYRe197d
        R3qKgYDIzoSp/jcrow0XKS/9tv3SS0DvDGClu4fgJipR7r6OKH+pdigYKuFomIgIrAXScTGEkmAgr
        /Ydux0eS/1AOMVjJ2GLny39tvjFIfQ4lhQsolLwH/Bwl9MULJywEbXKmB5zmDdMkMQI0b4hsPgKrp
        iJN+SjdmPUSuBzq5SyzXbst5Ml2/FOrensayrTAn4ib4U0y/CMwPsNs0UT4YOEUf5Rbh/XtjLr7/V
        xgT5Rhtw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:49276 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nRCF0-0007IU-QW; Mon, 07 Mar 2022 12:13:30 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nRCF0-00CiXD-7q; Mon, 07 Mar 2022 12:13:30 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH net] net: dsa: mt7530: fix incorrect test in
 mt753x_phylink_validate()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nRCF0-00CiXD-7q@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 07 Mar 2022 12:13:30 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Discussing one of the tests in mt753x_phylink_validate() with Landen
Chao confirms that the "||" should be "&&". Fix this.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
As the mt7530 maintainers are not very responsive to my recent two patch
series, but Landen Chao did state that this should be "&&" not "||", lets
at least get this patch merged.

 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index ff3c267d0f26..a251bc55727f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2936,7 +2936,7 @@ mt753x_phylink_validate(struct dsa_switch *ds, int port,
 
 	phylink_set_port_modes(mask);
 
-	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
+	if (state->interface != PHY_INTERFACE_MODE_TRGMII &&
 	    !phy_interface_mode_is_8023z(state->interface)) {
 		phylink_set(mask, 10baseT_Half);
 		phylink_set(mask, 10baseT_Full);
-- 
2.30.2

