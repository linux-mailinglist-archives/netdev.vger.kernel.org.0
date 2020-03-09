Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2E317DB19
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgCIIhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:37:01 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42482 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726389AbgCIIgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:46 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0698BC04C7;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743004; bh=sdFOgGRqnWlm6LxUiszwcGSqpMz+rX6fzqX2yGl6yKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=fYa+tb2P/P8bo3WgSzN8N3/P1jPIEW4Z603V6O8EDg+XK4pqkt9sdrUrrX/dzksg0
         Xob4ezbP/4SpqPQqD687joXsn8lMRginiuf6GGJQt9zLBisu8sPL27neU7R2ILgOEK
         zr8I/q6HAeUyRfOdXUEoMqTYd6D9iFq5uQf4HoGHnocqTrey0z7vj5Qh0PjIySFfBG
         o1rVLVmIY0dcwJSki9KgH3t0/n65zfMRA1hAyoBY8MfpTRXKyYS6sD2pNuUeNNxo0k
         puQQFzL8GDRK/0+YA4QBt7N8g9fRt1QWwMIDsFe4tdBDCS1ms1V+Yf2wyQrWAXX7iK
         kqrbUIx4jNhXg==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 415F7A0064;
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
Subject: [PATCH net-next 2/8] net: stmmac: Switch to linkmode_and()/linkmode_andnot()
Date:   Mon,  9 Mar 2020 09:36:21 +0100
Message-Id: <35064f17a0a0dee90fe29da85345343085bd111a.1583742615.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the linkmode_and()/linkmode_andnot() helpers to simplify the code.

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
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cb7a5bad4cfe..cf184241b85e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -858,14 +858,11 @@ static void stmmac_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseT_Half);
 	}
 
-	bitmap_and(supported, supported, mac_supported,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_andnot(supported, supported, mask,
-		      __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mac_supported,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_andnot(state->advertising, state->advertising, mask,
-		      __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mac_supported);
+	linkmode_andnot(supported, supported, mask);
+
+	linkmode_and(state->advertising, state->advertising, mac_supported);
+	linkmode_andnot(state->advertising, state->advertising, mask);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
-- 
2.7.4

