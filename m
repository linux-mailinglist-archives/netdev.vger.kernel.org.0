Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03263513D75
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346544AbiD1V1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352230AbiD1V1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C643BF538
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8CBFB8303B
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342E9C385AD;
        Thu, 28 Apr 2022 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181024;
        bh=nyS/qzNVzmEkSaJ3nVwgO/8/CzgNMfDoJNAtOdzapMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEmHpEq7nG3TllXLo3njBecbk4bzYKin6TfPn6Tg5vQ54YHJocmwY1zGeEnmwwAFx
         R26kjdUo4AWhpIxeowyr1vO89EwDC42sY/yEdP+7bSMRpgQ1x4MPgQmitv3VBXbIv6
         OT0Auon3b3NGqQMRFqJapDhW62BGkXXOK3LZqmn5qtLnkrq04xTlrFuFARuA/j+ZGU
         mX4u7EznW7u62gGaJH6tvns8VnWOgbPzz5X3DZQ4mOpz+cwd7Za7KyO0yM63TUpyFX
         H1LV75PQKMJzmE5O5m1e4B4G8D4JL9WxFQBgr+Pev9YejEYqxUzBMtkivsQO0acupX
         tqWyoIoNfc6hw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, jdmason@kudzu.us,
        zhengyongjun3@huawei.com, christophe.jaillet@wanadoo.fr
Subject: [PATCH net-next v2 12/15] eth: vxge: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:20 -0700
Message-Id: <20220428212323.104417-13-kuba@kernel.org>
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
CC: jdmason@kudzu.us
CC: zhengyongjun3@huawei.com
CC: christophe.jaillet@wanadoo.fr
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c | 2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index aa7c093f1f91..db4dfae8c01d 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4351,7 +4351,7 @@ vxge_probe(struct pci_dev *pdev, const struct pci_device_id *pre)
 	}
 	ll_config->tx_steering_type = TX_MULTIQ_STEERING;
 	ll_config->intr_type = MSI_X;
-	ll_config->napi_weight = NEW_NAPI_WEIGHT;
+	ll_config->napi_weight = NAPI_POLL_WEIGHT;
 	ll_config->rth_steering = RTH_STEERING;
 
 	/* get the default configuration parameters */
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.h b/drivers/net/ethernet/neterion/vxge/vxge-main.h
index 63f65193dd49..da9d2c191828 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.h
@@ -167,8 +167,6 @@ struct macInfo {
 struct vxge_config {
 	int		tx_pause_enable;
 	int		rx_pause_enable;
-
-#define	NEW_NAPI_WEIGHT	64
 	int		napi_weight;
 	int		intr_type;
 #define INTA	0
-- 
2.34.1

