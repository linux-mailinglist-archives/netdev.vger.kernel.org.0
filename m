Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560F934BF72
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 23:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhC1VrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 17:47:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41964 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231521AbhC1Vqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 17:46:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lQdFA-0006bn-8y; Sun, 28 Mar 2021 21:46:48 +0000
From:   Colin King <colin.king@canonical.com>
To:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] lan743x: remove redundant intializations of pointers adapter and phydev
Date:   Sun, 28 Mar 2021 22:46:47 +0100
Message-Id: <20210328214647.66220-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointers adapter and phydev are being initialized with values that
are never read and are being updated later with a new value. The
initialization is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/microchip/lan743x_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index c5de8f46cdd3..91a755efe2e6 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -730,8 +730,8 @@ static int lan743x_ethtool_get_eee(struct net_device *netdev,
 static int lan743x_ethtool_set_eee(struct net_device *netdev,
 				   struct ethtool_eee *eee)
 {
-	struct lan743x_adapter *adapter = netdev_priv(netdev);
-	struct phy_device *phydev = NULL;
+	struct lan743x_adapter *adapter;
+	struct phy_device *phydev;
 	u32 buf = 0;
 	int ret = 0;
 
-- 
2.30.2

