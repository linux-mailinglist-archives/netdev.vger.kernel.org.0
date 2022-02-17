Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5BF4BA844
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbiBQSbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:31:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244334AbiBQSbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:31:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AF538AA
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uuH/P0b/x5pam3oboXHs9EarL947cqa+8giB8dNzqg8=; b=muXebsNqKqyKth43EhYdRwZaW1
        33u/VlSkeyLMUyTtmwHwijQGED3IbeDQNTSVuiM8VRQ7X/oIZKlusEYoLYdCAcm4lt4MvmGt/eSaC
        0bcgvzQzmvhj+ud8cHFQPb9M1EB79tm1/aIS63kW7XSlRlKs5KkUbtPb2xsRQ9Jh5MicEkznKfPRz
        VhCueT4Kyg6rFeLtwYh3a0DWTbUdZ2pmfSSgp/0ErXSPxE71L5ivVI1ORr1ZyHJYtrsevSzpGF+hm
        wTRHdjra1fY1/IAWkA+duYdYuQhWHvzFIsQKA4Lv1dj4KQuHaFwd3Nm1V+NDCWFeT4J5Nt6/ygCx8
        vv2VWs2A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34450 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nKlYT-0005Gv-SA; Thu, 17 Feb 2022 18:31:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nKlYT-009aLN-9c; Thu, 17 Feb 2022 18:31:01 +0000
In-Reply-To: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 6/6] net: dsa: qca8k: mark as non-legacy
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nKlYT-009aLN-9c@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 17 Feb 2022 18:31:01 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qca8k driver does not make use of the speed, duplex, pause or
advertisement in its phylink_mac_config() implementation, so it can be
marked as a non-legacy driver.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2f8b03ff748c..04fa21e37dfa 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1814,6 +1814,8 @@ static void qca8k_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100 | MAC_1000FD;
+
+	config->legacy_pre_march2020 = false;
 }
 
 static void
-- 
2.30.2

