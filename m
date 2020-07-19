Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA74E225478
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 00:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGSWV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 18:21:26 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:45781 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgGSWV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 18:21:26 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 3B01022FEC;
        Mon, 20 Jul 2020 00:21:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1595197282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GprRQMSqzcQafQRSdhotKqPmaypQWFoRj7Y9BoPQMdM=;
        b=jmbPlZd4MS7gjAvMTyI3Rq6Todl3k5iF5hrrSf9EMhvC++aoM4oR0vLoAUBavmcAa3E3Vp
        6Qha47uFx312M/0i6EFcZw0h0h6YrbiE9UTw0aT401eLVEH6ppgFr0Spy96a1EsUW7seh8
        lMkkLOV6WzpKhu3PJ/OTNYU5qZvRzac=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next] net: phy: add constant for USXGMII bit 0
Date:   Mon, 20 Jul 2020 00:21:11 +0200
Message-Id: <20200719222111.19705-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the last missing constant of the USXGMII UsxgmiiChannelInfo field.
Unfortunately, there is no meaningful name in the USXGMII Singleport
Copper Interface specification. The specification just describe that
it has to be set to 1. The corresponding SGMII macros has two
different defines, ADVERTISE_SGMII and LPA_SGMII, depending on the
direction. The USXGMII is symmetrical thus just call it
MDIO_USXGMII_ADVERTISE.

Signed-off-by: Michael Walle <michael@walle.cc>
---
This is flagged as RFC to prevent the autobuilder bots from picking up this
patch because it depends on the following series:
https://lore.kernel.org/netdev/20200719220336.6919-1-michael@walle.cc/

I'm sending this as a separate patch because Russell put his Reviewed-by:
tag on everything else but this.

 include/uapi/linux/mdio.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 3f302e2523b2..3107751d2b99 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -325,6 +325,7 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
 }
 
 /* UsxgmiiChannelInfo[15:0] for USXGMII in-band auto-negotiation.*/
+#define MDIO_USXGMII_ADVERTISE		0x0001	/* must always be set */
 #define MDIO_USXGMII_EEE_CLK_STP	0x0080	/* EEE clock stop supported */
 #define MDIO_USXGMII_EEE		0x0100	/* EEE supported */
 #define MDIO_USXGMII_SPD_MASK		0x0e00	/* USXGMII speed mask */
-- 
2.20.1

