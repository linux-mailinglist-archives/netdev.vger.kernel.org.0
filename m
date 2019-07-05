Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153BF605B2
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 14:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbfGEMJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 08:09:22 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:40053 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbfGEMJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 08:09:18 -0400
Received: from mc-bl-xps13.lan (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 51EF7200017;
        Fri,  5 Jul 2019 12:09:16 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com
Subject: [PATCH net-next 2/2] net: mvpp2: cls: Add support for ETHER_FLOW
Date:   Fri,  5 Jul 2019 14:09:13 +0200
Message-Id: <20190705120913.25013-3-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
References: <20190705120913.25013-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Users can specify classification actions based on the 'ether' flow type.
In that case, this will apply to all ethernet traffic, superseeding
flows such as 'udp4' or 'tcp6'.

Add support for this flow type in the PPv2 classifier, by mapping the
ETHER_FLOW value to the corresponding entries in the classifier.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index 6c088c903c15..35478cba2aa5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -548,6 +548,8 @@ void mvpp2_cls_c2_read(struct mvpp2 *priv, int index,
 static int mvpp2_cls_ethtool_flow_to_type(int flow_type)
 {
 	switch (flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
+	case ETHER_FLOW:
+		return MVPP22_FLOW_ETHERNET;
 	case TCP_V4_FLOW:
 		return MVPP22_FLOW_TCP4;
 	case TCP_V6_FLOW:
-- 
2.20.1

