Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDF8511DD4
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240268AbiD0Pow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240147AbiD0Pop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:44:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23123193D
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 08:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89830618F8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 15:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1796C385AF;
        Wed, 27 Apr 2022 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074087;
        bh=rJ5yWuLoK/eWz3GNHUjb3cNFuO2uTbwzriSzlW94+bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pcdQQqsI9k3UNIm3olX5Ut3Nj93Sfr7fAe9iSH7GKcsCbX0jXj+sdvIxA8Vo8CbUF
         4k3ntSF2pd2+sSL0Bx4GLZz4/wTg62OP4qazCWJ0EXemYCwfRSvvW/OaEgVRG7IhHN
         59Da+wNA1F0rVmjcCmljb9fs7xVB9S+ckFBrQkeRNIy108joCYiLoo2QXHaaF1/VD1
         AllKpI53q2ODBZpF0TBig/KxBryjalfGY03ETlSj0tEzwUMdvAoxyMdGF8Y8QMKc2v
         ZHrCR9Yuakrma3nyfG/6nDy1LjSJ8PJ682DLXyJDWEtPGzJw+doOh2lL8qPhiKyEaT
         9pqQ2rSL1wbsw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com
Subject: [PATCH net-next 10/14] eth: benet: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Wed, 27 Apr 2022 08:41:07 -0700
Message-Id: <20220427154111.529975-11-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220427154111.529975-1-kuba@kernel.org>
References: <20220427154111.529975-1-kuba@kernel.org>
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

