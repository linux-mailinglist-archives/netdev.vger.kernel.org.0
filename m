Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1824513D7B
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352245AbiD1V1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352199AbiD1V1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9C6B53E4
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9803B8303C
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FFADC385AD;
        Thu, 28 Apr 2022 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181023;
        bh=rJ5yWuLoK/eWz3GNHUjb3cNFuO2uTbwzriSzlW94+bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlzwtTUulUh+FEpZWyWnM4dpDbBhUiFLubrG6pFMmbgyB+Y3FDhmzUbpgmdtl3bfg
         rcGAjOKPbu/dI6KNRSDJZpU85nXad7fIhHtMZQLmsSnY8fUfL6u80J+ggmoZe0Jc5L
         itz11GsCutNBX49ZnvF6ojWGyCJiFxESok26mzm/T2nFROEqkXKRYobbLYZDUxtyiw
         BNNDL1kzXPm2r85fcHQigX5zqBOqEjSYS7fe3MtHZvwuz23NJRX4obPeFrXXR4klL7
         JhPaKkClcFFFyYoZn3MVt75te1+3X3H8iI75xFfoJ6U4h+kB+UPDM5BfeaZw4Jwxsh
         +H9uKXMZmrBfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com
Subject: [PATCH net-next v2 10/15] eth: benet: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:18 -0700
Message-Id: <20220428212323.104417-11-kuba@kernel.org>
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
CC: ajit.khaparde@broadcom.com
CC: sriharsha.basavapatna@broadcom.com
CC: somnath.kotur@broadcom.com
---
 drivers/net/ethernet/emulex/benet/be.h      | 3 +--
 drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be.h b/drivers/net/ethernet/emulex/benet/be.h
index 8689d4a51fe5..61fe9625bed1 100644
--- a/drivers/net/ethernet/emulex/benet/be.h
+++ b/drivers/net/ethernet/emulex/benet/be.h
@@ -101,8 +101,7 @@
 #define MAX_ROCE_EQS		5
 #define MAX_MSIX_VECTORS	32
 #define MIN_MSIX_VECTORS	1
-#define BE_NAPI_WEIGHT		64
-#define MAX_RX_POST		BE_NAPI_WEIGHT /* Frags posted at a time */
+#define MAX_RX_POST		NAPI_POLL_WEIGHT /* Frags posted at a time */
 #define RX_FRAGS_REFILL_WM	(RX_Q_LEN - MAX_RX_POST)
 #define MAX_NUM_POST_ERX_DB	255u
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index d0c262f2695a..5939068a8f62 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2983,7 +2983,7 @@ static int be_evt_queues_create(struct be_adapter *adapter)
 		cpumask_set_cpu(cpumask_local_spread(i, numa_node),
 				eqo->affinity_mask);
 		netif_napi_add(adapter->netdev, &eqo->napi, be_poll,
-			       BE_NAPI_WEIGHT);
+			       NAPI_POLL_WEIGHT);
 	}
 	return 0;
 }
-- 
2.34.1

