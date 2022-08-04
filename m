Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5D258A097
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbiHDSjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238734AbiHDSjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:39:48 -0400
Received: from mx02lb.world4you.com (mx02lb.world4you.com [81.19.149.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF6F6C115
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BPzxHVmrJhRqaMNs4wSF1PsLKps+XYfIthZcuZ8kdvo=; b=iRnF8gT5WOwYnXHajozPH700fB
        kksM0Q01xGXr1+twb/sedoYUBTuNPlJ52jfqeM51QGU91lW0ZD/E2FQF1YR6RW0gkunS/s46eVyEg
        O/wfH5/wyJ8q139iEqY3feOXgqeErPLI2O/xzoJB97ti/JaiBcdYSlmbeQRBcMYVVyKo=;
Received: from 88-117-54-219.adsl.highway.telekom.at ([88.117.54.219] helo=hornet.engleder.at)
        by mx02lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oJfkz-0003IC-NT; Thu, 04 Aug 2022 20:39:41 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next 1/2] tsnep: Fix unused warning for 'tsnep_of_match'
Date:   Thu,  4 Aug 2022 20:39:34 +0200
Message-Id: <20220804183935.73763-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220804183935.73763-1-gerhard@engleder-embedded.com>
References: <20220804183935.73763-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index cb069a0af7b9..d98199f3414b 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1282,7 +1282,7 @@ MODULE_DEVICE_TABLE(of, tsnep_of_match);
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

