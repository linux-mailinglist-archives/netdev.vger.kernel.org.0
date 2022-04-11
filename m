Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB8D4FBADF
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236755AbiDKL3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344286AbiDKL3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:29:30 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7195B42A2A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 04:27:16 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id B360E320259;
        Mon, 11 Apr 2022 12:27:15 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.89)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1ndsCR-0004bA-GE; Mon, 11 Apr 2022 12:27:15 +0100
Subject: [PATCH net-next 2/3] sfc: Remove duplicate definition of
 efx_xmit_done
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 11 Apr 2022 12:27:15 +0100
Message-ID: <164967643534.17602.3715294418662045578.stgit@palantir17.mph.net>
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

It is defined both in efx.h and tx_common.h.
Remove the definition in efx.h.

Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx.h   |    1 -
 drivers/net/ethernet/sfc/farch.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
index daf0c00c1242..c05a83da9e44 100644
--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -28,7 +28,6 @@ static inline netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct
 			       ef100_enqueue_skb, __efx_enqueue_skb,
 			       tx_queue, skb);
 }
-void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
 void efx_xmit_done_single(struct efx_tx_queue *tx_queue);
 int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 		 void *type_data);
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index 148dcd48b58d..9599123bc28d 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -16,6 +16,7 @@
 #include "bitfield.h"
 #include "efx.h"
 #include "rx_common.h"
+#include "tx_common.h"
 #include "nic.h"
 #include "farch_regs.h"
 #include "sriov.h"

