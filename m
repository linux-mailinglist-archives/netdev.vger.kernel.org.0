Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1DC3AB383
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 14:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhFQM21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 08:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhFQM2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 08:28:25 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBD8C06175F;
        Thu, 17 Jun 2021 05:26:17 -0700 (PDT)
Received: from [2a02:610:7501:feff:1ccf:41ff:fe50:18b9] (helo=localhost.localdomain)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1ltr61-0001Wc-HA; Thu, 17 Jun 2021 15:26:09 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, jesse.brandeburg@intel.com,
        dchickles@marvell.com, tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gatis Peisenieks <gatis@mikrotik.com>
Subject: [PATCH net] atl1c: improve reliability of mdio ops on Mikrotik 10/25G NIC
Date:   Thu, 17 Jun 2021 15:25:53 +0300
Message-Id: <20210617122553.2970190-1-gatis@mikrotik.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO ops on Mikrotik 10/25G NIC can occasionally take longer
to complete. This increases the timeout from 1.2 to 12ms.

Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
index c567c920628f..15523077490f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_hw.h
@@ -290,7 +290,7 @@ void atl1c_post_phy_linkchg(struct atl1c_hw *hw, u16 link_speed);
 #define MDIO_CTRL_REG_SHIFT		16
 #define MDIO_CTRL_DATA_MASK		0xFFFFUL
 #define MDIO_CTRL_DATA_SHIFT		0
-#define MDIO_MAX_AC_TO			120	/* 1.2ms timeout for slow clk */
+#define MDIO_MAX_AC_TO			1200	/* 12ms timeout for slow clk */
 
 /* for extension reg access */
 #define REG_MDIO_EXTN			0x1448
-- 
2.31.1

