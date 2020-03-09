Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF59317DB12
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 09:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgCIIgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 04:36:52 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:42518 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbgCIIgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 04:36:46 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 0BE24C04C9;
        Mon,  9 Mar 2020 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1583743005; bh=l4GGId4B8ITZnEheuBbnHxTOMeyOh89oiemUVnP91n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=B+6fx6mpT48iBw+hv1r49pCI4sDvO0ntudaH96Ju2bucqI2sISfbhq9UK6ipq74ro
         /9ho3uv6t+uNhyhNNw8zFG0ao9C0loxXG6IJaeyQtSBnaJZ9hJkfwRDIBU1eGwv2pO
         Izl3i+Qls8rLIddtLQPz/ZhwkYsER3iQb6PnTsKZqgaLnHprNKellxK+XHh9UURhBO
         /VF/UvIMrCmxqEy7n8skzKOvpS/XvT9QtPNeLeUySJInolU8B64evWfdDlSmkkbc4o
         RJMs64BpjrEjiKeDOFEzE3nFKGBNMLNFVCki8bcJ5fTmZpRQcC1N1y0AXCIsret235
         j4166sK961YwQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 676CAA0075;
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
Subject: [PATCH net-next 6/8] net: phylink: Test if MAC/PCS support Autoneg
Date:   Mon,  9 Mar 2020 09:36:25 +0100
Message-Id: <001bd169362fa564d515d423ca6d42640a35df6a.1583742616.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1583742615.git.Jose.Abreu@synopsys.com>
References: <cover.1583742615.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We may have cases where MAC or PCS do not support Autoneg. Check if it
is supported after validate callback is called.

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
 drivers/net/phy/phylink.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 47f4ce02d7bc..19db68d74cb4 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -340,6 +340,9 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 				    "failed to validate link configuration for in-band status\n");
 			return -EINVAL;
 		}
+
+		/* Check if MAC/PCS also supports Autoneg. */
+		pl->link_config.an_enabled = phylink_test(pl->supported, Autoneg);
 	}
 
 	return 0;
-- 
2.7.4

