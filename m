Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE752B2D7
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 09:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbiERG6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 02:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiERG6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 02:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC6E30557
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 23:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ADFD60DBE
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 06:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C024CC385A5;
        Wed, 18 May 2022 06:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652857112;
        bh=Bruy2hIK2dqmKdWK8UNYsAPLinYCMAacDRh3nsF46ow=;
        h=From:To:Cc:Subject:Date:From;
        b=o+rpb9P4e/n2RsSNfPIDELGDy918gQGMyzMgyiEwhJOlCPJXExbJEOvv8dMyjVCrj
         JsGY1q8yFmMTFCFyARbnqUNLVgAI11opwK8Qhf+b09t2PUiXYSlP5GiuMJGoxfww7u
         ESmRo5dpEeSSd8byz0T8GO662tM6CTguZ6O9Y+y/H9npslGZ6ZBa7roqA04Zh8le38
         u4MVqO4yomi/IVmaacDQojglOFfN3iv+mMaJvOtIliPshXSGgjotjSh3zIN2ddfgYA
         gn/BTnHmc46R+m1nxeDuWjSPI/1Fvw1+T36/0PGBIjkMStFuFbc4VHBdKJc9lhRR7F
         HY3VMUawdqbVQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: [PATCH net-next] sfc: siena: Have a unique wrapper ifndef for efx channels header
Date:   Tue, 17 May 2022 23:58:20 -0700
Message-Id: <20220518065820.131611-1-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Both sfc/efx_channels.h and sfc/siena/efx_channels.h used the same
wrapper #ifndef EFX_CHANNELS_H, this patch changes the siena define to be
EFX_SIENA_CHANNELS_H to avoid build system confusion.

This fixes the following build break:
drivers/net/ethernet/sfc/ptp.c:2191:28:
error: ‘efx_copy_channel’ undeclared here (not in a function); did you mean ‘efx_ptp_channel’?
  2191 |  .copy                   = efx_copy_channel,

Fixes: 6e173d3b4af9 ("sfc: Copy shared files needed for Siena (part 1)")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Cc: Edward Cree <ecree.xilinx@gmail.com>
Cc: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/siena/efx_channels.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/siena/efx_channels.h b/drivers/net/ethernet/sfc/siena/efx_channels.h
index 10d78049b885..c4b95a2d770f 100644
--- a/drivers/net/ethernet/sfc/siena/efx_channels.h
+++ b/drivers/net/ethernet/sfc/siena/efx_channels.h
@@ -8,8 +8,8 @@
  * by the Free Software Foundation, incorporated herein by reference.
  */
 
-#ifndef EFX_CHANNELS_H
-#define EFX_CHANNELS_H
+#ifndef EFX_SIENA_CHANNELS_H
+#define EFX_SIENA_CHANNELS_H
 
 extern unsigned int efx_siena_interrupt_mode;
 extern unsigned int efx_siena_rss_cpus;
-- 
2.36.1

