Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716732468DF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgHQO4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:56:02 -0400
Received: from mail.intenta.de ([178.249.25.132]:41309 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728651AbgHQOzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=intenta.de; s=dkim1;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:CC:To:From:Date; bh=e+JuQEgudjxEqJ4POxNZjjdRN38gAQFwV66LQ6iG2Ao=;
        b=T3IOscIIfXlyenJf68uGExzPC8ATVbU8vOiEzmtwDHNyMeMGiN3kzePQ0m0+885bnkZtU9wMoJhz+vRdSDDgnWh0c6dvolEeBf+8OQ6c/BnYWLOJ81sjbFfNNZd3TTdli/IuKKbNZa2KkYaEoJ5+6yIl/elHZ6ltXyP/IlbV2P15qG+c7R8pBBECHaHi8R4SLfztfor8h3jTiEs2S7PoIdBOV+Eb0YTu3aOMSh+cZmGmqkTnFX3sDfZ3k3rcNfvlipr3TVRzdl9HVVU1yPLwUvvFdMvk6E2z5G+nCzlmmDQWULhK8SxHXqELjbyEqIM4F72jYVBv+fNQDIQ0bI1DYg==;
Date:   Mon, 17 Aug 2020 16:55:28 +0200
From:   Helmut Grohne <helmut.grohne@intenta.de>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2 1/6] net: dsa: microchip: delete unused member ksz_port.phy
Message-ID: <07566406b6957fc6e9dd434933aa111ed25a2115.1597675604.git.helmut.grohne@intenta.de>
References: <20200725174130.GL1472201@lunn.ch>
 <cover.1597675604.git.helmut.grohne@intenta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1597675604.git.helmut.grohne@intenta.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ICSMA002.intenta.de (10.10.16.48) To ICSMA002.intenta.de
 (10.10.16.48)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Link: https://lore.kernel.org/netdev/20200721083300.GA12970@laureti-dev/
Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>
---
 drivers/net/dsa/microchip/ksz8795.c    | 1 -
 drivers/net/dsa/microchip/ksz9477.c    | 8 +-------
 drivers/net/dsa/microchip/ksz_common.h | 1 -
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index 8f1d15ea15d9..e62d54306765 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1007,7 +1007,6 @@ static void ksz8795_config_cpu_port(struct dsa_switch *ds)
 		if (i == dev->port_cnt)
 			break;
 		p->on = 1;
-		p->phy = 1;
 	}
 	for (i = 0; i < dev->phy_port_cnt; i++) {
 		p = &dev->ports[i];
diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index dc999406ce86..c548894553bc 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -1305,14 +1305,8 @@ static void ksz9477_config_cpu_port(struct dsa_switch *ds)
 		p->member = dev->port_mask;
 		ksz9477_port_stp_state_set(ds, i, BR_STATE_DISABLED);
 		p->on = 1;
-		if (i < dev->phy_port_cnt)
-			p->phy = 1;
-		if (dev->chip_id == 0x00947700 && i == 6) {
+		if (dev->chip_id == 0x00947700 && i == 6)
 			p->sgmii = 1;
-
-			/* SGMII PHY detection code is not implemented yet. */
-			p->phy = 0;
-		}
 	}
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 206838160f49..0432cd38bf0b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -31,7 +31,6 @@ struct ksz_port {
 	struct phy_device phydev;
 
 	u32 on:1;			/* port is not disabled by hardware */
-	u32 phy:1;			/* port has a PHY */
 	u32 fiber:1;			/* port is fiber */
 	u32 sgmii:1;			/* port is SGMII */
 	u32 force:1;
-- 
2.20.1

