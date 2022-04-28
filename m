Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0241513D74
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352120AbiD1V1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352173AbiD1V1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A6BF538
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74AD2B83040
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC201C385A9;
        Thu, 28 Apr 2022 21:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181023;
        bh=oCKeNCN2yICMPChiUphgruZdKfrlQkmr9We7CZOAQBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uy0wLZ0p7ZTgrgVm8RS5gTPIdQ20ODM9W2+/nvSdrPs7qtzZ784XiqgKH+XvSlyzA
         bSzfaOaVSJmp1cEMOOdgujGAY5qp9aaZr4P/K5ve5Hz6azby8TASlp7fL9oYawqvqN
         0YH0/xZ/CIyaylcAC1fHrRkS8I+iKszqxPtibHZ4aFhVKgu2rAUh5IxUkW2j1qEpRH
         gapH4aJYPD+AluL9kuAV1TMMZmFCf4/1upsrEgyHqPjgFqBpwmf+3twYdjkeAfLmlU
         zcM6WNTAqUdWchp2JV94msU9LsuKSx4BGb+Eoity+PIkG1icdpDeKCbP9/SWRTOYMp
         6ZFeIe842rO+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, irusskikh@marvell.com,
        epomozov@marvell.com
Subject: [PATCH net-next v2 09/15] eth: atlantic: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:17 -0700
Message-Id: <20220428212323.104417-10-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428212323.104417-1-kuba@kernel.org>
References: <20220428212323.104417-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defining local versions of NAPI_POLL_WEIGHT with the same
values in the drivers just makes refactoring harder.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: irusskikh@marvell.com
CC: epomozov@marvell.com
---
 drivers/net/ethernet/aquantia/atlantic/aq_cfg.h | 2 --
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
index 8bcda2cb3a2e..7e9c74b141ef 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_cfg.h
@@ -65,8 +65,6 @@
  */
 #define AQ_CFG_RESTART_DESC_THRES   (AQ_CFG_SKB_FRAGS_MAX * 2)
 
-#define AQ_CFG_NAPI_WEIGHT     64U
-
 /*#define AQ_CFG_MAC_ADDR_PERMANENT {0x30, 0x0E, 0xE3, 0x12, 0x34, 0x56}*/
 
 #define AQ_CFG_FC_MODE AQ_NIC_FC_FULL
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 06de19f63287..275324c9e51e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -1218,7 +1218,7 @@ int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
 	atomic_set(&aq_ptp->offset_ingress, 0);
 
 	netif_napi_add(aq_nic_get_ndev(aq_nic), &aq_ptp->napi,
-		       aq_ptp_poll, AQ_CFG_NAPI_WEIGHT);
+		       aq_ptp_poll, NAPI_POLL_WEIGHT);
 
 	aq_ptp->idx_vector = idx_vec;
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
index e839e1002ec7..f0fdf20f01c1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_vec.c
@@ -120,7 +120,7 @@ struct aq_vec_s *aq_vec_alloc(struct aq_nic_s *aq_nic, unsigned int idx,
 	self->rx_rings = 0;
 
 	netif_napi_add(aq_nic_get_ndev(aq_nic), &self->napi,
-		       aq_vec_poll, AQ_CFG_NAPI_WEIGHT);
+		       aq_vec_poll, NAPI_POLL_WEIGHT);
 
 err_exit:
 	return self;
-- 
2.34.1

