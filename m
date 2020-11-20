Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9608C2BA916
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 12:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgKTL0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 06:26:02 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:43507 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727070AbgKTL0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 06:26:02 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CcvPK2fpXz3qvrC;
        Fri, 20 Nov 2020 12:25:57 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CcvMy3jFlz2TTL6;
        Fri, 20 Nov 2020 12:24:46 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 20 Nov
 2020 12:23:13 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Kurt Kanzenbach" <kurt.kanzenbach@linutronix.de>,
        Marek Vasut <marex@denx.de>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Christian Eggers" <ceggers@arri.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 3/4] net: dsa: microchip: ksz9477: setup SPI mode
Date:   Fri, 20 Nov 2020 12:21:06 +0100
Message-ID: <20201120112107.16334-4-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120112107.16334-1-ceggers@arri.de>
References: <20201120112107.16334-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201120-122450-4CcvMy3jFlz2TTL6-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should be done in the device driver instead of the device tree.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/dsa/microchip/ksz9477_spi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477_spi.c b/drivers/net/dsa/microchip/ksz9477_spi.c
index 1142768969c2..15bc11b3cda4 100644
--- a/drivers/net/dsa/microchip/ksz9477_spi.c
+++ b/drivers/net/dsa/microchip/ksz9477_spi.c
@@ -48,6 +48,12 @@ static int ksz9477_spi_probe(struct spi_device *spi)
 	if (spi->dev.platform_data)
 		dev->pdata = spi->dev.platform_data;
 
+	/* setup spi */
+	spi->mode = SPI_MODE_3;
+	ret = spi_setup(spi);
+	if (ret)
+		return ret;
+
 	ret = ksz9477_switch_register(dev);
 
 	/* Main DSA driver may not be started yet. */
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

