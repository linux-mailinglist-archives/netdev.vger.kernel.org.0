Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA4A187BE8
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 10:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgCQJT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 05:19:27 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:48682 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbgCQJTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 05:19:11 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 870F940184;
        Tue, 17 Mar 2020 09:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1584436751; bh=VK6M6NynkQutHkNGcSezRWGpOnu7G8uE4UbAW05pHdw=;
        h=From:To:Cc:Subject:Date:From;
        b=jdTQqScirKVGNgC3KqPiJjgx2fay44quEzcZ8Nv3oinH2jd8Xw2kGZw5NMQJ77u7n
         a392Hn0Iplmw1M+f/qUdWmrn/J/OUqFWBrlHbWker6Uucu2Txo+0EhQTIcNebNQ0Mp
         p02DOJKm5pETomSGgj0t+m1Jrmvw0ntnU6ZDbeCW2U5Rqr4bS9W8rMXDZYcSlS3wkv
         ZH2z4ZGf5QEz0OKly2jIm1gExDpDaVEBkw4AScvVEf1a/seizGjPgDqIC+2G88Swi6
         l0mO/3detAyWmkIB+zgPcwCstDym7fxAamm2590i/yrLpbTHp4m337j6MM63HHlrwD
         GzTQJjYcS18Zw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 1C533A005C;
        Tue, 17 Mar 2020 09:19:01 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 0/4] net: stmmac: 100GB Enterprise MAC support
Date:   Tue, 17 Mar 2020 10:18:49 +0100
Message-Id: <cover.1584436401.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds the support for Enterprise MAC IP version which allows operating
speeds up to 100GB.

Patch 1/4, adds the support in XPCS for XLGMII interface that is used in
this kind of Enterprise MAC IPs.

Patch 2/4, adds the XLGMII interface support in stmmac.

Patch 3/4, adds the HW specific support for Enterprise MAC.

We end in patch 4/4, by updating stmmac documentation to mention the
support for this new IP version.

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
---

Jose Abreu (4):
  net: phy: xpcs: Add XLGMII support
  net: stmmac: Add XLGMII support
  net: stmmac: Add support for Enterprise MAC version
  Documentation: networking: stmmac: Mention new XLGMAC support

 .../networking/device_drivers/stmicro/stmmac.rst   |  7 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       | 13 +++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 99 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h    | 22 +++++
 drivers/net/ethernet/stmicro/stmmac/hwif.c         | 45 +++++++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 58 +++++++++++++
 drivers/net/phy/mdio-xpcs.c                        | 98 +++++++++++++++++++++
 8 files changed, 340 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwxlgmac2.h

-- 
2.7.4

