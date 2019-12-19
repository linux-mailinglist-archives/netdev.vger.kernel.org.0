Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0985A12603C
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfLSLAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:00:17 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:33445 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLSLAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:00:15 -0500
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id A86F0FF804;
        Thu, 19 Dec 2019 11:00:12 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com, Igor.Russkikh@aquantia.com,
        jakub.kicinski@netronome.com
Subject: [PATCH net-next v4 03/15] net: macsec: introduce MACsec ops
Date:   Thu, 19 Dec 2019 11:55:03 +0100
Message-Id: <20191219105515.78400-4-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219105515.78400-1-antoine.tenart@bootlin.com>
References: <20191219105515.78400-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces MACsec ops for drivers to support offloading
MACsec operations.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/net/macsec.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/net/macsec.h b/include/net/macsec.h
index 8882379d68ac..4d0afb79259e 100644
--- a/include/net/macsec.h
+++ b/include/net/macsec.h
@@ -196,4 +196,28 @@ struct macsec_context {
 	u8 prepare:1;
 };
 
+/**
+ * struct macsec_ops - MACsec offloading operations
+ */
+struct macsec_ops {
+	/* Device wide */
+	int (*mdo_dev_open)(struct macsec_context *ctx);
+	int (*mdo_dev_stop)(struct macsec_context *ctx);
+	/* SecY */
+	int (*mdo_add_secy)(struct macsec_context *ctx);
+	int (*mdo_upd_secy)(struct macsec_context *ctx);
+	int (*mdo_del_secy)(struct macsec_context *ctx);
+	/* Security channels */
+	int (*mdo_add_rxsc)(struct macsec_context *ctx);
+	int (*mdo_upd_rxsc)(struct macsec_context *ctx);
+	int (*mdo_del_rxsc)(struct macsec_context *ctx);
+	/* Security associations */
+	int (*mdo_add_rxsa)(struct macsec_context *ctx);
+	int (*mdo_upd_rxsa)(struct macsec_context *ctx);
+	int (*mdo_del_rxsa)(struct macsec_context *ctx);
+	int (*mdo_add_txsa)(struct macsec_context *ctx);
+	int (*mdo_upd_txsa)(struct macsec_context *ctx);
+	int (*mdo_del_txsa)(struct macsec_context *ctx);
+};
+
 #endif /* _NET_MACSEC_H_ */
-- 
2.24.1

