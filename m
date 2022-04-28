Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E413513D7D
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352271AbiD1V1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352235AbiD1V1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:27:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE330BF942;
        Thu, 28 Apr 2022 14:23:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F17B8303C;
        Thu, 28 Apr 2022 21:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908A4C385B0;
        Thu, 28 Apr 2022 21:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651181026;
        bh=0ri35CDlCGa70SrF0yTpZg8swzzuXkfsvA4yg/gpTnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLN1IQg/iS5ARnZ+p/XT0IiQbtyX5TSKlWaPzf+AMoj5GUJtan/yE/p8oP5b9PqPN
         8SEwIt/+p7ptyY+mIaEhgAS7YW7UlDCSOzaMKeJv9DXT7qNq44X9X4tj/Y2VvojXWK
         YHo4NDtimHkARQkqWkW4eg0kc07yAZQl27Nr1eeeH035nfxv8/osmAPxMeqNDXKP95
         gWRtIRYotqkHjoRqfwqnSR/Z/tKphwQd0tVwTeFzm4v5IcqCbUA/yAWARS3T3RdzLH
         xYmHlGsqGPorVAZ2DqnmQIRMLERCi2P0zWFe9k90+CNClbubJMeLmTO5RtTCV/tVk7
         9X9x0L2er4HSg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, wintera@linux.ibm.com,
        wenjia@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH net-next v2 15/15] qeth: remove a copy of the NAPI_POLL_WEIGHT define
Date:   Thu, 28 Apr 2022 14:23:23 -0700
Message-Id: <20220428212323.104417-16-kuba@kernel.org>
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
CC: wintera@linux.ibm.com
CC: wenjia@linux.ibm.com
CC: hca@linux.ibm.com
CC: gor@linux.ibm.com
CC: agordeev@linux.ibm.com
CC: borntraeger@linux.ibm.com
CC: svens@linux.ibm.com
CC: linux-s390@vger.kernel.org
---
 drivers/s390/net/qeth_core.h      | 2 --
 drivers/s390/net/qeth_core_main.c | 2 +-
 drivers/s390/net/qeth_l2_main.c   | 2 +-
 drivers/s390/net/qeth_l3_main.c   | 2 +-
 4 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index de25d7ac41da..1d195429753d 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -801,8 +801,6 @@ struct qeth_priv {
 	u32 brport_features;
 };
 
-#define QETH_NAPI_WEIGHT NAPI_POLL_WEIGHT
-
 struct qeth_card {
 	enum qeth_card_states state;
 	spinlock_t lock;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index d99c5b773e22..ae85179ca49a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -7100,7 +7100,7 @@ int qeth_open(struct net_device *dev)
 	local_bh_disable();
 	qeth_for_each_output_queue(card, queue, i) {
 		netif_tx_napi_add(dev, &queue->napi, qeth_tx_poll,
-				  QETH_NAPI_WEIGHT);
+				  NAPI_POLL_WEIGHT);
 		napi_enable(&queue->napi);
 		napi_schedule(&queue->napi);
 	}
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 303461d70af3..92698f79a4e0 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1133,7 +1133,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 				       PAGE_SIZE * (QDIO_MAX_ELEMENTS_PER_BUFFER - 1));
 	}
 
-	netif_napi_add(card->dev, &card->napi, qeth_poll, QETH_NAPI_WEIGHT);
+	netif_napi_add(card->dev, &card->napi, qeth_poll, NAPI_POLL_WEIGHT);
 	return register_netdev(card->dev);
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d2f422a9a4f7..ea3b6b18aa6e 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1910,7 +1910,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		netif_set_gso_max_size(card->dev,
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
-	netif_napi_add(card->dev, &card->napi, qeth_poll, QETH_NAPI_WEIGHT);
+	netif_napi_add(card->dev, &card->napi, qeth_poll, NAPI_POLL_WEIGHT);
 	return register_netdev(card->dev);
 }
 
-- 
2.34.1

