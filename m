Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AA04FBAE2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245225AbiDKL3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbiDKL3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:29:35 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD5B642A00
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:27:21 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id ECA4B320259;
        Mon, 11 Apr 2022 12:27:20 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1ndsCW-0004bS-Ni; Mon, 11 Apr 2022 12:27:20 +0100
Subject: [PATCH net-next 3/3] sfc: Remove global definition of
 efx_reset_type_names
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 11 Apr 2022 12:27:20 +0100
Message-ID: <164967644058.17602.17132670619750522093.stgit@palantir17.mph.net>
In-Reply-To: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
References: <164967635861.17602.16525009567130361754.stgit@palantir17.mph.net>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,KHOP_HELO_FCRDNS,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strings are only used in efx_common.c so the definitions
can be static in there.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx_common.c |    4 ++--
 drivers/net/ethernet/sfc/net_driver.h |    5 -----
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index af37c990217e..f6577e74d6e6 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -51,8 +51,8 @@ static unsigned int efx_monitor_interval = 1 * HZ;
 /* Default stats update time */
 #define STATS_PERIOD_MS_DEFAULT 1000
 
-const unsigned int efx_reset_type_max = RESET_TYPE_MAX;
-const char *const efx_reset_type_names[] = {
+static const unsigned int efx_reset_type_max = RESET_TYPE_MAX;
+static const char *const efx_reset_type_names[] = {
 	[RESET_TYPE_INVISIBLE]          = "INVISIBLE",
 	[RESET_TYPE_ALL]                = "ALL",
 	[RESET_TYPE_RECOVER_OR_ALL]     = "RECOVER_OR_ALL",
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index c75dc75e2857..318db906a154 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -612,11 +612,6 @@ extern const unsigned int efx_loopback_mode_max;
 #define LOOPBACK_MODE(efx) \
 	STRING_TABLE_LOOKUP((efx)->loopback_mode, efx_loopback_mode)
 
-extern const char *const efx_reset_type_names[];
-extern const unsigned int efx_reset_type_max;
-#define RESET_TYPE(type) \
-	STRING_TABLE_LOOKUP(type, efx_reset_type)
-
 enum efx_int_mode {
 	/* Be careful if altering to correct macro below */
 	EFX_INT_MODE_MSIX = 0,

