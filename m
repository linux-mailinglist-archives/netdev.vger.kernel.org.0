Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4272C31CCF3
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 16:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBPPbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 10:31:11 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:17960 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhBPPbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 10:31:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613489468; x=1645025468;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=C+qJk8Ou2q0wVZtG8itt1IYlVXNusQEr7Rd0i9/sMf4=;
  b=BpznYkd6/OT47JtcOb5VIJhDBdOmeJ8jHzejNZTTTjVHhcu0auFqpeUX
   fHLBc47tk48NfJQcPwaVPl2ILs2gtWJq1LVlQ7AeT+Eu31uAgn0htucGa
   YZGbUn1jCL0HnWdJY+h7tdzNy5oX62UJup8SvTS+Vpt8qsu+178J+aATU
   P6K+37xf1RX94/aH4ZX24qcsfPr67AzMa0sODr+9f0EH+oVuyAvf3cOSb
   xClNXD3B0HSDYeexCdrsQHniHBk1sfGMguyZd3qr26l5ThtDx7jRO7GY5
   2kpkmvFXY4f2Tb9meZMhfF1H1nbPfzqk7NT5Y6Gz3EVSm/PzF86UZfsh/
   g==;
IronPort-SDR: erI2HTyZYTfIO67Qk0Z4Iq6f7gOAgkM4TbpISfQPKKiLvncq9O5BsffBzrrdRRtn8sidpD5UMy
 vb4gACQUoTbRGPySfZmDtJP/yaPqtHEXXndedlsT3eEqX6HDSlgRAmHQAH+xde45I85jiLv3sL
 5J6+qOzgcw1xLSoZqxoG5pRwPyCm7owX5G/jU7UUyEn2DirAxL0NmfmONPjzetTfgiT/sMX7jy
 Ef+vkk3205XlSm5c6tLqaq8PIuaGIDDbsNWuxrxsgTii+2G8sTzPe6VuSm6PUclBY30O6u5O15
 504=
X-IronPort-AV: E=Sophos;i="5.81,184,1610434800"; 
   d="scan'208";a="103941893"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Feb 2021 08:29:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 16 Feb 2021 08:29:51 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 16 Feb 2021 08:29:49 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v3 0/3] Fixes applied to VCS8514
Date:   Tue, 16 Feb 2021 16:29:41 +0100
Message-ID: <20210216152944.27266-1-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

3 different fixes applied to VSC8514:
LCPLL reset, serdes calibration and coma mode disabled.
Especially the serdes calibration is large and is now placed
in a new file 'mscc_serdes.c' which can act as
a placeholder for future serdes configuration.

v1 -> v2:
  Preserved reversed christmas tree
  Removed forward definitions
  Fixed build issues
  Changed net to net-next

v2 -> v3:
  Added cover letter.
  Removed ena_clk_bypass from function call
  Created mscc_serdes.c and .h for serdes configuration
  Modified coma register config.

Bjarni Jonasson (3):
  net: phy: mscc: adding LCPLL reset to VSC8514
  net: phy: mscc: improved serdes calibration applied to VSC8514
  net: phy: mscc: coma mode disabled for VSC8514

 drivers/net/phy/mscc/Makefile      |   1 +
 drivers/net/phy/mscc/mscc.h        |  28 ++
 drivers/net/phy/mscc/mscc_main.c   | 608 ++++++++++++++++-----------
 drivers/net/phy/mscc/mscc_serdes.c | 650 +++++++++++++++++++++++++++++
 drivers/net/phy/mscc/mscc_serdes.h |  31 ++
 5 files changed, 1063 insertions(+), 255 deletions(-)
 create mode 100644 drivers/net/phy/mscc/mscc_serdes.c
 create mode 100644 drivers/net/phy/mscc/mscc_serdes.h

-- 
2.17.1

