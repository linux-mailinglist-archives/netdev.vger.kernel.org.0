Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1F7D139003
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 12:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgAMLZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 06:25:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:44152 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbgAMLZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 06:25:11 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A0E33B4E9EDF1334A4EF;
        Mon, 13 Jan 2020 19:25:08 +0800 (CST)
Received: from localhost.localdomain (10.175.124.28) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Mon, 13 Jan 2020 19:24:59 +0800
From:   Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
To:     <linux-net-drivers@solarflare.com>, <ecree@solarflare.com>,
        <amaftei@solarflare.com>, <davem@davemloft.net>,
        <mhabets@solarflare.com>, <zhangxiaoxu5@huawei.com>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] sfc/ethtool_common: Make some function to static
Date:   Mon, 13 Jan 2020 19:24:11 +0800
Message-ID: <20200113112411.28090-1-zhangxiaoxu5@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warning:

drivers/net/ethernet/sfc/ethtool_common.c
  warning: symbol 'efx_fill_test' was not declared. Should it be static?
  warning: symbol 'efx_fill_loopback_test' was not declared.
           Should it be static?
  warning: symbol 'efx_describe_per_queue_stats' was not declared.
           Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 drivers/net/ethernet/sfc/ethtool_common.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 3d7f75cc5cf0..b8d281ab6c7a 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -147,9 +147,9 @@ void efx_ethtool_get_pauseparam(struct net_device *net_dev,
  *
  * Fill in an individual self-test entry.
  */
-void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
-		   int *test, const char *unit_format, int unit_id,
-		   const char *test_format, const char *test_id)
+static void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
+			  int *test, const char *unit_format, int unit_id,
+			  const char *test_format, const char *test_id)
 {
 	char unit_str[ETH_GSTRING_LEN], test_str[ETH_GSTRING_LEN];
 
@@ -189,10 +189,11 @@ void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
  * Fill in a block of loopback self-test entries.  Return new test
  * index.
  */
-int efx_fill_loopback_test(struct efx_nic *efx,
-			   struct efx_loopback_self_tests *lb_tests,
-			   enum efx_loopback_mode mode,
-			   unsigned int test_index, u8 *strings, u64 *data)
+static int efx_fill_loopback_test(struct efx_nic *efx,
+				  struct efx_loopback_self_tests *lb_tests,
+				  enum efx_loopback_mode mode,
+				  unsigned int test_index,
+				  u8 *strings, u64 *data)
 {
 	struct efx_channel *channel =
 		efx_get_channel(efx, efx->tx_channel_offset);
@@ -293,7 +294,7 @@ int efx_ethtool_fill_self_tests(struct efx_nic *efx,
 	return n;
 }
 
-size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
+static size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
 {
 	size_t n_stats = 0;
 	struct efx_channel *channel;
-- 
2.17.2

