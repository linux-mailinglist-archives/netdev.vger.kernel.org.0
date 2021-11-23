Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA887459FAB
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 11:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhKWKDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 05:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbhKWKDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 05:03:37 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDD5C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 02:00:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qTGDaNQC8dzlK7EnxMVipMoSGhh3jfdSBn/mQjw1NJw=; b=vQyZmHOFMEP749C7l9bAHqV755
        qedpKIxajNJc8B0BMyYjGhimcCF8zEEkbA/OxagFs1zEfeDL2wbV6CSSu61t5AJPS2VdgGiq3g7tY
        kUxqts6yexqEgyWmYSvUHcIvwdt9zqG4rMF0n+KawC+/8uZB8vh1dV2BkDAEuXlXgY2N4jNv7duH5
        hmUI0dNg8HEel2ERGrtbi21OWgjq2Y5v04sn+f/VvP/dzmciuovcxBhJp+93J4Tfwcwz8ntAzMqVP
        Re/a8oOShJ1X+BWoCz/5LL4SJwS57rhHrNQ9jt7/tLYXvt6Q8900hNU63+slzlplRZf4QLInu8wge
        w4rUeHpw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36038 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSbB-0007i6-5F; Tue, 23 Nov 2021 10:00:25 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSbA-00BXob-MG; Tue, 23 Nov 2021 10:00:24 +0000
In-Reply-To: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 3/8] net: dsa: mark DSA phylink as
 legacy_pre_march2020
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpSbA-00BXob-MG@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 23 Nov 2021 10:00:24 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As DSA doesn't make use of the PCS support, but it does have PCS, it
must be marked as a pre-March 2020 driver to maintain the old phylink
behaviour.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index eaa66114924b..cfb48dc57f73 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1091,6 +1091,13 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	if (err)
 		mode = PHY_INTERFACE_MODE_NA;
 
+	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
+	 * an indicator of a legacy phylink driver.
+	 */
+	if (ds->ops->phylink_mac_link_state ||
+	    ds->ops->phylink_mac_an_restart)
+		dp->pl_config.legacy_pre_march2020 = true;
+
 	if (ds->ops->phylink_get_interfaces)
 		ds->ops->phylink_get_interfaces(ds, dp->index,
 					dp->pl_config.supported_interfaces);
-- 
2.30.2

