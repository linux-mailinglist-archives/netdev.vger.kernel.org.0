Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E7222C061
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 10:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgGXICI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 04:02:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:46390 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgGXICG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 04:02:06 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E54441A0F40;
        Fri, 24 Jul 2020 10:02:04 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DE8931A01F1;
        Fri, 24 Jul 2020 10:02:04 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4C528202CD;
        Fri, 24 Jul 2020 10:02:04 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, andrew@lunn.ch, linux@armlinux.org.uk,
        f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 3/5] net: mdiobus: add clause 45 mdiobus write accessor
Date:   Fri, 24 Jul 2020 11:01:41 +0300
Message-Id: <20200724080143.12909-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724080143.12909-1-ioana.ciornei@nxp.com>
References: <20200724080143.12909-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the locked variant of the clause 45 mdiobus write accessor -
mdiobus_c45_write().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v4:
 - none

 include/linux/mdio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 898cbf00332a..3a88b699b758 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -358,6 +358,12 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
 	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
 }
 
+static inline int mdiobus_c45_write(struct mii_bus *bus, int prtad, int devad,
+				    u16 regnum, u16 val)
+{
+	return mdiobus_write(bus, prtad, mdiobus_c45_addr(devad, regnum), val);
+}
+
 int mdiobus_register_device(struct mdio_device *mdiodev);
 int mdiobus_unregister_device(struct mdio_device *mdiodev);
 bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
-- 
2.25.1

