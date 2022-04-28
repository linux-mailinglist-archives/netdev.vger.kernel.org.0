Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94A4513D78
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352094AbiD1V0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352090AbiD1V0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BEAAAB65
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF6BD61F49
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 21:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4760C385AD;
        Thu, 28 Apr 2022 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181017;
        bh=hw3dra6UucjUR9klyxo2TrXe94MMpmlywORZyBm8yfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTOGEdgdGA+pgT+P+F93gauln8R6A1o7l9fURqIFE4y5qpCjZ9H1CRDX9zhgEaQIG
         CxcG42VMJAYvF2UHfXJ8fUZHzs499Emh51D0dk7qDLDCXJRK9e28gOFENFKGnKfIfi
         647McCsNz0jvzB50gtcVIJfxFhd6bkb4PcdjxHOulWk15NmMaRTSxIRQZhwwAsKTSE
         rwjHvkZpmOUiuQz43dCnXQjDqyWiFcOz+c0CMT4I59a2us1NMzVPOyq6uC7FysR6z/
         nWGLbo1n2N8QtVlJJaXasyEjEaRAevH9FRh3HfiwPHSVbaJtEP5uaYbVkSxBwpYO1k
         TOXWRzbau0vYw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        steve.glendinning@shawell.net, david.kershner@unisys.com,
        gregkh@linuxfoundation.org, liujunqi@pku.edu.cn,
        sparmaintainer@unisys.com
Subject: [PATCH net-next v2 02/15] eth: smsc: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:10 -0700
Message-Id: <20220428212323.104417-3-kuba@kernel.org>
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
v2: drop the staging part now only smsc gets changed by this patch

CC: steve.glendinning@shawell.net
CC: david.kershner@unisys.com
CC: gregkh@linuxfoundation.org
CC: liujunqi@pku.edu.cn
CC: sparmaintainer@unisys.com
---
 drivers/net/ethernet/smsc/smsc9420.c | 2 +-
 drivers/net/ethernet/smsc/smsc9420.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index d937af18973e..0c68c7f8056d 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -1585,7 +1585,7 @@ smsc9420_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->netdev_ops = &smsc9420_netdev_ops;
 	dev->ethtool_ops = &smsc9420_ethtool_ops;
 
-	netif_napi_add(dev, &pd->napi, smsc9420_rx_poll, NAPI_WEIGHT);
+	netif_napi_add(dev, &pd->napi, smsc9420_rx_poll, NAPI_POLL_WEIGHT);
 
 	result = register_netdev(dev);
 	if (result) {
diff --git a/drivers/net/ethernet/smsc/smsc9420.h b/drivers/net/ethernet/smsc/smsc9420.h
index 409e82b2018a..876410a256c6 100644
--- a/drivers/net/ethernet/smsc/smsc9420.h
+++ b/drivers/net/ethernet/smsc/smsc9420.h
@@ -15,7 +15,6 @@
 /* interrupt deassertion in multiples of 10us */
 #define INT_DEAS_TIME			(50)
 
-#define NAPI_WEIGHT			(64)
 #define SMSC_BAR			(3)
 
 #ifdef __BIG_ENDIAN
-- 
2.34.1

