Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77D9CB5B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfHZIOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:14:50 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:42666 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730448AbfHZIOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:14:48 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: YEfLqn/Rqwk5+HQ/Fg5B3zwYB8WzeYiMuwS73e8BXSVZzSi9Q1AobPH5b074WLxDicJssEBnf/
 wQ8QVtRaEbcj5bSbCMMqr1fsHvoK8WzZMduy1kDzTcEN5+JK+xiU39269Dr3LqGpdloKOd5o8o
 wYGMy2ohiQZhh7PzvkETsO6PGfyD26UuMudXE2xTdI6aAYCiHaUKvVdF+Flvv77N9iRaZ2etem
 4LpmrEyPBz+Paqeg2rhu7gR9f7y+arbQkDvJkVofFCr101XjgtQIKHwz9UequhZwcmOuexoH43
 IwQ=
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="45573027"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2019 01:14:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 26 Aug 2019 01:14:47 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 26 Aug 2019 01:14:44 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <allan.nielsen@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 2/3] net: mscc: Use NETIF_F_HW_BR_CAP
Date:   Mon, 26 Aug 2019 10:11:14 +0200
Message-ID: <1566807075-775-3-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
References: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable NETIF_F_HW_BR_CAP feature for ocelot.
Because the HW can learn and flood the frames, so there is no need for SW
bridge to do this.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4d1bce4..7d7c94b 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2017,8 +2017,10 @@ int ocelot_probe_port(struct ocelot *ocelot, u8 port,
 	dev->ethtool_ops = &ocelot_ethtool_ops;
 
 	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_RXFCS |
-		NETIF_F_HW_TC;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC;
+		NETIF_F_HW_TC | NETIF_F_HW_BR_CAP;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_TC |
+		NETIF_F_HW_BR_CAP;
+	dev->priv_flags |= IFF_UNICAST_FLT;
 
 	memcpy(dev->dev_addr, ocelot->base_mac, ETH_ALEN);
 	dev->dev_addr[ETH_ALEN - 1] += port;
-- 
2.7.4

