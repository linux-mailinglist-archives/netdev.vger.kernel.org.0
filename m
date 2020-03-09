Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D7917DB17
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgCIIgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:36:45 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42366 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725796AbgCIIgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:45 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 040D8C04C4;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743004; bh=dc3zNRxIMYMIKBzMEXxh/j1E4vNfqQ6AWVSQKmWIUcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Eo7qJcwYYUmEdUtf+0FJcirK9r/5tDUxKGaNjXIJTglj9FcoOHRHD2Do1Nuu4sg0u
         JANozNro853SAl8ZPCZ8+8gdSFe0/uNTeZ/CSnQLKmL1v5R17VF3PoldzpVVRluMBB
         Ibsft2LAu2IB3sO+vVMC99t1sPohFfnckbjHbxsDY0g5VqB6EiYn2OrxAfq6OyTlf6
         x1s4SkNPkn6B6sJuv2aoai/01imYDfL96pRpaagCl8vHHGMReg7sVJCyHrgxVZsv4y
         5M3jCfQ/TdpheFfmrxkNg+feAL2lcMqdChLoC+Rii66eWwKQdXQjuAkBNEgKVYViMW
         lkq9qqBkAFz+A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4B76CA0069;
        Mon,  9 Mar 2020 08:36:41 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/8] net: stmmac: Fallback to dev_fwnode() if needed
Date:   Mon,  9 Mar 2020 09:36:22 +0100
Message-Id: <7eb9df9f6f05f08c11b6095087d7f86f5662e041.1583742615.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_OF is not enabled, of_fwnode_handle() will return NULL, even
though we can have a FW handle from a given device.

Fallback to dev_fwnode() helper if needed.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cf184241b85e..8e555f4e82d7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1043,6 +1043,9 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	priv->phylink_config.dev = &priv->dev->dev;
 	priv->phylink_config.type = PHYLINK_NETDEV;
 
+	if (!fwnode)
+		fwnode = dev_fwnode(priv->device);
+
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
 	if (IS_ERR(phylink))
-- 
2.7.4

