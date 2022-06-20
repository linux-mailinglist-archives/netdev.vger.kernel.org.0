Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B20C551F27
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 16:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244780AbiFTOkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 10:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244878AbiFTOj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 10:39:57 -0400
Received: from mint-fitpc2.mph.net (unknown [81.168.73.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 81820B53
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 06:59:15 -0700 (PDT)
Received: from palantir17.mph.net (unknown [192.168.0.4])
        by mint-fitpc2.mph.net (Postfix) with ESMTP id B517E320133;
        Mon, 20 Jun 2022 14:59:14 +0100 (BST)
Received: from localhost ([::1] helo=palantir17.mph.net)
        by palantir17.mph.net with esmtp (Exim 4.95)
        (envelope-from <habetsm.xilinx@gmail.com>)
        id 1o3Hvu-0000ob-F2;
        Mon, 20 Jun 2022 14:59:14 +0100
Subject: [PATCH net-next 5/8] sfc: Fix checkpatch warning
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     jonathan.s.cooper@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com
Date:   Mon, 20 Jun 2022 14:59:14 +0100
Message-ID: <165573355435.2982.8611156918090702221.stgit@palantir17.mph.net>
In-Reply-To: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
References: <165573340676.2982.8456666672406894221.stgit@palantir17.mph.net>
User-Agent: StGit/0.19
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

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

WARNING:AVOID_BUG: Avoid crashing the kernel - try using WARN_ON & recovery code
    rather than BUG() or BUG_ON()

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Co-authored-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 08922ba35917..f874835e1764 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -774,7 +774,8 @@ static void efx_unregister_netdev(struct efx_nic *efx)
 	if (!efx->net_dev)
 		return;
 
-	BUG_ON(efx_netdev_priv(efx->net_dev) != efx);
+	if (WARN_ON(efx_netdev_priv(efx->net_dev) != efx))
+		return;
 
 	if (efx_dev_registered(efx)) {
 		strlcpy(efx->name, pci_name(efx->pci_dev), sizeof(efx->name));


