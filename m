Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6AB50BB0C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 17:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449101AbiDVPEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 11:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449142AbiDVPEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 11:04:13 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B515D1B5
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 08:00:55 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id 3AD69320133;
        Fri, 22 Apr 2022 16:00:55 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1nhumE-0007Bt-SK; Fri, 22 Apr 2022 16:00:54 +0100
Subject: [PATCH net-next 18/28] sfc/siena: Rename loopback_mode in
 net_driver.h to avoid a conflict with sfc
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Fri, 22 Apr 2022 16:00:54 +0100
Message-ID: <165063965473.27138.4156855409627594066.stgit@palantir17.mph.net>
In-Reply-To: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
References: <165063937837.27138.6911229584057659609.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,MAY_BE_FORGED,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For siena use efx_siena_ as the prefix.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx_common.c     |    4 ++--
 drivers/net/ethernet/sfc/siena/ethtool_common.c |    2 +-
 drivers/net/ethernet/sfc/siena/net_driver.h     |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 36f2c24b3c8a..3293221b9e9e 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -73,8 +73,8 @@ static const char *const efx_reset_type_names[] = {
 	STRING_TABLE_LOOKUP(type, efx_reset_type)
 
 /* Loopback mode names (see LOOPBACK_MODE()) */
-const unsigned int efx_loopback_mode_max = LOOPBACK_MAX;
-const char *const efx_loopback_mode_names[] = {
+const unsigned int efx_siena_loopback_mode_max = LOOPBACK_MAX;
+const char *const efx_siena_loopback_mode_names[] = {
 	[LOOPBACK_NONE]		= "NONE",
 	[LOOPBACK_DATA]		= "DATAPATH",
 	[LOOPBACK_GMAC]		= "GMAC",
diff --git a/drivers/net/ethernet/sfc/siena/ethtool_common.c b/drivers/net/ethernet/sfc/siena/ethtool_common.c
index c94a75df0d29..0207d07f54e3 100644
--- a/drivers/net/ethernet/sfc/siena/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/siena/ethtool_common.c
@@ -233,7 +233,7 @@ static void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
 #define EFX_CHANNEL_NAME(_channel) "chan%d", _channel->channel
 #define EFX_TX_QUEUE_NAME(_tx_queue) "txq%d", _tx_queue->label
 #define EFX_LOOPBACK_NAME(_mode, _counter)			\
-	"loopback.%s." _counter, STRING_TABLE_LOOKUP(_mode, efx_loopback_mode)
+	"loopback.%s." _counter, STRING_TABLE_LOOKUP(_mode, efx_siena_loopback_mode)
 
 /**
  * efx_fill_loopback_test - fill in a block of loopback self-test entries
diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index 3fe93f25a569..7e0659be4348 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -606,10 +606,10 @@ enum efx_led_mode {
 #define STRING_TABLE_LOOKUP(val, member) \
 	((val) < member ## _max) ? member ## _names[val] : "(invalid)"
 
-extern const char *const efx_loopback_mode_names[];
-extern const unsigned int efx_loopback_mode_max;
+extern const char *const efx_siena_loopback_mode_names[];
+extern const unsigned int efx_siena_loopback_mode_max;
 #define LOOPBACK_MODE(efx) \
-	STRING_TABLE_LOOKUP((efx)->loopback_mode, efx_loopback_mode)
+	STRING_TABLE_LOOKUP((efx)->loopback_mode, efx_siena_loopback_mode)
 
 enum efx_int_mode {
 	/* Be careful if altering to correct macro below */

