Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7872F1294
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbhAKMve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbhAKMve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:51:34 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA21EC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 04:50:53 -0800 (PST)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4DDtqJ0N83z1rx85;
        Mon, 11 Jan 2021 13:50:52 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4DDtqJ02STz1qql6;
        Mon, 11 Jan 2021 13:50:51 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id gOBt3tICngUe; Mon, 11 Jan 2021 13:50:51 +0100 (CET)
X-Auth-Info: CEW7mSu/r6I4tczv+scVYoARhnnGW4hde0zloOFo1xk=
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Mon, 11 Jan 2021 13:50:51 +0100 (CET)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH net-next] net: ks8851: Select PHYLIB and MICREL_PHY in Kconfig
Date:   Mon, 11 Jan 2021 13:50:46 +0100
Message-Id: <20210111125046.36326-1-marex@denx.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PHYLIB must be selected to provide mdiobus_*() functions, and the
MICREL_PHY is necessary too, as that is the only possible PHY attached
to the KS8851 (it is the internal PHY).

Fixes: ef3631220d2b ("net: ks8851: Register MDIO bus and the internal PHY")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
---
 drivers/net/ethernet/micrel/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index 42bc014136fe..93df3049cdc0 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -31,6 +31,8 @@ config KS8851
 	select MII
 	select CRC32
 	select EEPROM_93CX6
+	select PHYLIB
+	select MICREL_PHY
 	help
 	  SPI driver for Micrel KS8851 SPI attached network chip.
 
@@ -40,6 +42,8 @@ config KS8851_MLL
 	select MII
 	select CRC32
 	select EEPROM_93CX6
+	select PHYLIB
+	select MICREL_PHY
 	help
 	  This platform driver is for Micrel KS8851 Address/data bus
 	  multiplexed network chip.
-- 
2.29.2

