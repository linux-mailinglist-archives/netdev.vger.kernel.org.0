Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D77F168A5C
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 00:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgBUX07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 18:26:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39496 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729312AbgBUX06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 18:26:58 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1j5Hh8-0007An-H5; Fri, 21 Feb 2020 23:26:54 +0000
From:   Colin King <colin.king@canonical.com>
To:     Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sameeh Jubran <sameehj@amazon.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ena: ethtool: remove redundant non-zero check on rc
Date:   Fri, 21 Feb 2020 23:26:53 +0000
Message-Id: <20200221232653.33134-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The non-zero check on rc is redundant as a previous non-zero
check on rc will always return and the second check is never
reached, hence it is redundant and can be removed.  Also
remove a blank line.

Addresses-Coverity: ("Logically dead code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/amazon/ena/ena_ethtool.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index ced1d577b62a..1e38930353f2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -674,7 +674,6 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 	 * supports getting/setting the hash function.
 	 */
 	rc = ena_com_get_hash_function(adapter->ena_dev, &ena_func, key);
-
 	if (rc) {
 		if (rc == -EOPNOTSUPP) {
 			key = NULL;
@@ -685,9 +684,6 @@ static int ena_get_rxfh(struct net_device *netdev, u32 *indir, u8 *key,
 		return rc;
 	}
 
-	if (rc)
-		return rc;
-
 	switch (ena_func) {
 	case ENA_ADMIN_TOEPLITZ:
 		func = ETH_RSS_HASH_TOP;
-- 
2.25.0

