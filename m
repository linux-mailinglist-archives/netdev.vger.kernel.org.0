Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E0F3405A9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 13:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhCRMjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 08:39:32 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45134 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhCRMjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 08:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616071158; x=1647607158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=UaO4DrW2FryTq+JeBvRegRfUsbSOYDlJb8uSOeoNGf0=;
  b=axBm4QaTbC04c+lbPTgQzHElKdWkL/fPR08hSuDBK+FTzhJtjr9w4cHS
   qrl5hojpgEYK1FHw/j9J7VItYXytmHTw/10PGZmxZnU0T9S7g91weO67T
   KoXhMDEgzIYveaJakJ3b5QfWtXeV2PvDJ3qBuAMGJrVes8wkz5QSotAUr
   wmVETqyQRVueXq2yOVJv9/IYU42sg7hvR6qAN/9GZxThY7XmwG2cMq7Bb
   CR38mCP1qOP2k9L1QczwIfuwJ7fTeREBpUFzXDKPG3rtGpqutknAT/jsA
   eCKHZoBor5m1QDrn8FHmGZvpHEgcyayZ2GNSbwnzAkfoxsg8xrn53P7+S
   g==;
IronPort-SDR: EMrxOwvwPve9wMjg53tGk78BqJV9d6doMVFZCNGaQFDnepXIWTBFOpe0Q06dql8EmoJFmSG1Qi
 oVB7qUZMgtrEApQk//axgBHRwswSXzB/fjd5kFO7wmNq75OodcF+y5/F9mbUn9Uo2LPMpTC+xG
 3qA9EhMNtXJyh4sskGcZdTydgn1cm6Mds/02YYOhoM7cGW1OkltN3ss6XNL9K9qHmVhafM9Q1X
 qSSGXetAud0EQn6Z7fyaAAV+/PQr1Q2HcQgZlFuE1VPSElDH38XEQoD5ax9xYbkT2dYgsVxsFi
 2SA=
X-IronPort-AV: E=Sophos;i="5.81,258,1610434800"; 
   d="scan'208";a="48023962"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2021 05:39:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 05:39:15 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 18 Mar 2021 05:39:12 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v1 3/3] net: phy: mscc: coma mode disabled for VSC8584
Date:   Thu, 18 Mar 2021 13:38:51 +0100
Message-ID: <20210318123851.10324-4-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
References: <20210318123851.10324-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch releases coma mode for VSC8584 as done for VSC8514 in
commit ca0d7fd0a58d ("net: phy: mscc: coma mode disabled for VSC8514")

Fixes: a5afc1678044a ("net: phy: mscc: add support for VSC8584 PHYY.")
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/mscc/mscc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 254d882490f7..6badb594b4e2 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1737,6 +1737,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 			ret = vsc8584_config_host_serdes(phydev);
 			if (ret)
 				goto err;
+			vsc85xx_coma_mode_release(phydev);
 			break;
 		default:
 			ret = -EINVAL;
-- 
2.17.1

