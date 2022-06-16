Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74C54D969
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 06:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348371AbiFPEfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 00:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244181AbiFPEfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 00:35:42 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903A55AA40
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 21:35:39 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LNq8t6YsDzDrCm;
        Thu, 16 Jun 2022 12:35:10 +0800 (CST)
Received: from container.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 16 Jun 2022 12:35:37 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next] ice: Remove unnecessary NULL check before dev_put
Date:   Thu, 16 Jun 2022 12:52:59 +0800
Message-ID: <20220616045259.1130087-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit b37a46683739 ("netdevice: add the case if dev is NULL"),
dev_put(NULL) is safe, check NULL before dev_put() is not needed.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/ethernet/intel/ice/ice_lag.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lag.c b/drivers/net/ethernet/intel/ice/ice_lag.c
index 4f954db01b92..c9f7393b783d 100644
--- a/drivers/net/ethernet/intel/ice/ice_lag.c
+++ b/drivers/net/ethernet/intel/ice/ice_lag.c
@@ -447,11 +447,9 @@ void ice_deinit_lag(struct ice_pf *pf)
 	if (lag->pf)
 		ice_unregister_lag_handler(lag);
 
-	if (lag->upper_netdev)
-		dev_put(lag->upper_netdev);
+	dev_put(lag->upper_netdev);
 
-	if (lag->peer_netdev)
-		dev_put(lag->peer_netdev);
+	dev_put(lag->peer_netdev);
 
 	kfree(lag);
 
-- 
2.25.1

