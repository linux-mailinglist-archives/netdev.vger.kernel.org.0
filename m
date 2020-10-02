Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E5628185C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 18:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388161AbgJBQy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 12:54:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56379 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgJBQy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 12:54:29 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kOOK6-0000so-UM; Fri, 02 Oct 2020 16:54:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Dan Murphy <dmurphy@ti.com>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: phy: dp83869: fix unsigned comparisons against less than zero values
Date:   Fri,  2 Oct 2020 17:54:22 +0100
Message-Id: <20201002165422.94328-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the comparisons of u16 integers value and sopass_val with
less than zero for error checking is always false because the values
are unsigned. Fix this by making these variables int.  This does not
affect the shift and mask operations performed on these variables

Addresses-Coverity: ("Unsigned compared against zero")
Fixes: 49fc23018ec6 ("net: phy: dp83869: support Wake on LAN")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/phy/dp83869.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 0aee5f645b71..cf6dec7b7d8e 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -305,7 +305,7 @@ static int dp83869_set_wol(struct phy_device *phydev,
 static void dp83869_get_wol(struct phy_device *phydev,
 			    struct ethtool_wolinfo *wol)
 {
-	u16 value, sopass_val;
+	int value, sopass_val;
 
 	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
 			WAKE_MAGICSECURE);
-- 
2.27.0

