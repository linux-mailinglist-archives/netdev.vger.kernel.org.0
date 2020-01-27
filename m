Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978F614A2C2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbgA0LPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:15:53 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:44520 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730217AbgA0LPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:15:52 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 33C31407CC;
        Mon, 27 Jan 2020 11:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1580123371; bh=rmlubmDXcPsD8KeTSdEzU0/rEGB6hNMFoYChQwg5Hb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=mYkahSOzNMTatlzFj1EbzYdNgEs4Q0VRwJ4Bpl3gQBBwhfWsqviYjhoDUYoSYdv34
         eS7IXWPTkaWdHWTRb8hN5SPOmbrgMl10DdDRaaV7ULXGC8IW7077nLzlJYv/E4K9Dt
         NUOGP0rjpDfoMeGXWQNDI8e22MpQROMgObMTDWBPOse47wGL3Hd1Pz9Zlh4QWZ9/oL
         8UowTbE0Snf1qlILWqar6MQXJ7zgQafG1xNHnUXQvLTAb5rfYquTAMH1LAMyzrdZrl
         1zV8DDCla9boyWfk3bG5TZ6go8DBcZFVF4LEK0PLVBTC75y4JXa5pyoGUOQaXv6/D/
         pRj7oN5XZ0LpQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id A480AA008F;
        Mon, 27 Jan 2020 11:09:28 +0000 (UTC)
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
Subject: [RFC net-next 3/8] net: stmmac: Switch to phylink_and()/phylink_andnot()
Date:   Mon, 27 Jan 2020 12:09:08 +0100
Message-Id: <25138389972ebd7b01844ae66abdff0a279f7504.1580122909.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1580122909.git.Jose.Abreu@synopsys.com>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the newly introduced helpers to simplify the code.

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
index ff1cbfc834b0..0bbc9e8b7aae 100644
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
+	phylink_and(supported, mac_supported);
+	phylink_andnot(supported, mask);
+
+	phylink_and(state->advertising, mac_supported);
+	phylink_andnot(state->advertising, mask);
 }
 
 static void stmmac_mac_pcs_get_state(struct phylink_config *config,
-- 
2.7.4

