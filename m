Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B771341E42
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 14:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCSNaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 09:30:10 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29495 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbhCSN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 09:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616160577; x=1647696577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=VgP3lAUI1Mrs5K1f8vqeSNnirPC+X0homcl6GyUVxVk=;
  b=In56a1AXd08GqSQQFUvY/gIgEbMRXS5zV5cSPkUIImXtADYCM803FrY9
   Wp2NIxVpEwenKNPKdVRCInL2CMc++uv7pvPpmZy7UjDM6ykeTDvBoJ/e8
   7w1aEJuNT9MAXH9DlqZCQv0fCRfnVKTUhQAEMs5gKzs5tETXQNWOZcsT4
   lpfRbc5YCGLU8e7Utxpugd0+ULPmbIVVLwXyBK+Hq7LNzBjlCY9x/XqPM
   AlN0Zhy/HqVBlTM9GHB74xWTb59XmCDA6EpCvnpQZFFX7C84MYmVWQToR
   EXFSFZiWM0lYqMi/GtlU0G6UzAUlUpjP5IiWtamdutt80WGIJOeTFs5u+
   Q==;
IronPort-SDR: 3kC2tAgC7JzPHKii64AIwHkqKCf7JVgqxXdTtF3MywSfSb+ZkMhtGu+ZU22pK3hvOA1DcmIx7T
 gRnZ5LOo8Tfe5S7pubzkWyY/rcHnafYis7YEhLVMSPXoa5I8q6ilYIuJJWOEYGRoHqO9txIKRm
 jicYQppStpiv5GyW+MrK7ZWOPHmSgg8EJ1luwmz18Zmsa1STpW1EoAf1m4j0rQoR8QPUQN7QqO
 iDWXI4SAmbUerKHjlIkDav73mcL0G/5JKmGADRPZHkzQDT6ikxNREYhIdWQBdJwxGG5/ymLfVL
 WXI=
X-IronPort-AV: E=Sophos;i="5.81,261,1610434800"; 
   d="scan'208";a="110624610"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Mar 2021 06:29:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 06:29:25 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 19 Mar 2021 06:29:22 -0700
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
        Michael Walle <michael@walle.cc>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 3/3] net: phy: mscc: coma mode disabled for VSC8584
Date:   Fri, 19 Mar 2021 14:29:05 +0100
Message-ID: <20210319132905.9846-4-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
References: <20210319132905.9846-1-bjarni.jonasson@microchip.com>
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
index 2f105dafb6cc..6e32da28e138 100644
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

