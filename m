Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6666C202A32
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 13:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729924AbgFULAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 07:00:31 -0400
Received: from inva020.nxp.com ([92.121.34.13]:48332 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbgFULAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 07:00:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D09591A16DC;
        Sun, 21 Jun 2020 13:00:16 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C3D641A16D9;
        Sun, 21 Jun 2020 13:00:16 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 4A9AD203C2;
        Sun, 21 Jun 2020 13:00:16 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com, olteanv@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 3/5] net: mdiobus: add clause 45 mdiobus write accessor
Date:   Sun, 21 Jun 2020 14:00:03 +0300
Message-Id: <20200621110005.23306-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200621110005.23306-1-ioana.ciornei@nxp.com>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the locked variant of the clause 45 mdiobus write accessor -
mdiobus_c45_write().

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none


 include/linux/mdio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 36d2e0673d03..323f1d1fa271 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -357,6 +357,12 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
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

