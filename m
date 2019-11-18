Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC5271004AB
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 12:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfKRLsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 06:48:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55102 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfKRLsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 06:48:40 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iWfWF-0007lC-T9; Mon, 18 Nov 2019 11:48:35 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Murphy <dmurphy@ti.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: phy: dp83869: fix return of uninitialized variable ret
Date:   Mon, 18 Nov 2019 11:48:35 +0000
Message-Id: <20191118114835.39494-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where the call to phy_interface_is_rgmii returns zero
the variable ret is left uninitialized and this is returned at
the end of the function dp83869_configure_rgmii.  Fix this by
returning 0 instead of the uninitialized value in ret.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/dp83869.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index fcd418716c10..1c7a7c57dec3 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -239,7 +239,7 @@ static int dp83869_configure_rgmii(struct phy_device *phydev,
 			       dp83869->io_impedance &
 			       DP83869_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
 
-	return ret;
+	return 0;
 }
 
 static int dp83869_configure_mode(struct phy_device *phydev,
-- 
2.24.0

