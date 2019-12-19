Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAA126046
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfLSLAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:42 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:60207 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbfLSLAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:40 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id D286F1C0015;
        Thu, 19 Dec 2019 11:00:37 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 14/15] net: macsec: allow to reference a netdev from a MACsec context
Date:   Thu, 19 Dec 2019 11:55:14 +0100
Message-Id: <20191219105515.78400-15-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows to reference a net_device from a MACsec context. This
is needed to allow implementing MACsec operations in net device drivers.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/net/macsec.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index a08f19099c7a..1b4de64d7fef 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -179,7 +179,10 @@ struct macsec_secy {
  * struct macsec_context - MACsec context for hardware offloading
  */
 struct macsec_context {
-	struct phy_device *phydev;
+	union {
+		struct net_device *netdev;
+		struct phy_device *phydev;
+	};
 	enum macsec_offload offload;
 
 	struct macsec_secy *secy;
-- 
2.24.1

