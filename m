Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B945C58938B
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237566AbiHCUuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238626AbiHCUuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:50:09 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C845C962
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 13:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PySY/ReSQj+mt7SIxYcdmJz+ASeBO3Eswc7kAD33UHg=; b=ABCON8hFmR2kQOyyh43j7yyBMM
        lvQonN5TWVHHKQUNdoAZfB7h2LVPcpmUzAUVynJdM6bQYkoaRv9TuSCA9pDjkHgbj2wFoxPrVBY1z
        jm72y6AfmgpUtsK8B5UZ3GxJ5zhgaevgDkjTdFNih0Sq33VEqlSHsJwxb0E0F8HLRPAw=;
Received: from 88-117-54-219.adsl.highway.telekom.at ([88.117.54.219] helo=hornet.engleder.at)
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJLJb-0001TF-1V; Wed, 03 Aug 2022 22:50:03 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 2/6] tsnep: Fix unused warning for 'tsnep_of_match'
Date:   Wed,  3 Aug 2022 22:49:43 +0200
Message-Id: <20220803204947.52789-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220803204947.52789-1-gerhard@engleder-embedded.com>
References: <20220803204947.52789-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel test robot found the following warning:

drivers/net/ethernet/engleder/tsnep_main.c:1254:34: warning:
'tsnep_of_match' defined but not used [-Wunused-const-variable=]

of_match_ptr() compiles into NULL if CONFIG_OF is disabled.
tsnep_of_match exists always so use of of_match_ptr() is useless.
Fix warning by dropping of_match_ptr().

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index fcc605a347c4..203039671040 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1319,7 +1319,7 @@ MODULE_DEVICE_TABLE(of, tsnep_of_match);
 static struct platform_driver tsnep_driver = {
 	.driver = {
 		.name = TSNEP,
-		.of_match_table = of_match_ptr(tsnep_of_match),
+		.of_match_table = tsnep_of_match,
 	},
 	.probe = tsnep_probe,
 	.remove = tsnep_remove,
-- 
2.30.2

