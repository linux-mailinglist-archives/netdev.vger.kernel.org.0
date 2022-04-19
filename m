Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F464506961
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350825AbiDSLGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiDSLGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:06:49 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF001FCF7;
        Tue, 19 Apr 2022 04:04:07 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id j9so5684076qkg.1;
        Tue, 19 Apr 2022 04:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vzYr1S8B3ykiafw9TGsT2lWFse4CJI9qXSIwB6EZ7fM=;
        b=CuPGoJg0Tkqcmky31cjUtHFBSwFEegEal1WLsRDYQawtKTRu/DZyIeUoIhe5gksmDa
         th1vIUgGzkyCxjwYX42xFL8TrkLzgWrVCT0eQWwwCCS0sPw2eh/8fRWANBjlKLMYxz3E
         avoIGV31visQ1udkeKf4xwifsD8nLRtXtDXrcPPIdaT7XhV4CTYWHCSOZ0ZC0onJnyYy
         /Pr8qXt7ecH5qCy6iYkeM4oMv3VY5fct300pk8lj7kGdwjjOptdsrw7M/Ejbs97KOshu
         bB2zFIWZHinhQkwqgDlNgk4yHbWgt3WTrf6ZhVTSrl1y89JPW/fA8XqJY764jOkXQ6DX
         juHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vzYr1S8B3ykiafw9TGsT2lWFse4CJI9qXSIwB6EZ7fM=;
        b=U4HK+wD0r45BfxN7gBoXfP13KiqFXrEkyrmIUCoqKblafBw9HABwV6uULoa3G2q0hg
         wGtkwRb/9wVkRgVNFBKTNW1TO1L0kzojrLear57eCVgXcC8mxu2TU0UPxaqmNThB4NCK
         /TXPwiT7IP0s8LulUK6Ws/7gosUQygTQOHauCq3TyBtM0hfQBvTCycVSI4srO7w5Dq9K
         bmIue2vK0VIlnINiLUGxnEZSEtjkIaMtxhDtVhTZ0ODtED+MHLdzvnS1XbU46d5OfQgN
         V5g73P7dRYK06eU8mex0rybtlIZgAxvWsVaz38IIwLPL/gPmgRT1ALLt/nnvJ/Zi6eJt
         kHqQ==
X-Gm-Message-State: AOAM530rBS8wYLmvFkOb10b43H1HZTFnHMAin2s75kaWhthErs6qOIpO
        gzAzwNw9I+fF+6NNd1k1T5g=
X-Google-Smtp-Source: ABdhPJyK2oBv72c8synSiIcWW7zvziwwnPmNG9MJnBYXKU1NpZPi5aVBbVhWfblavqnS8yzRsy9LvQ==
X-Received: by 2002:a05:620a:2544:b0:680:a53b:ec1a with SMTP id s4-20020a05620a254400b00680a53bec1amr9366341qko.544.1650366246398;
        Tue, 19 Apr 2022 04:04:06 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id d71-20020a379b4a000000b0069e687cbe48sm5561616qke.89.2022.04.19.04.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 04:04:05 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ethernet: ti: am65-cpsw-ethtool: use pm_runtime_resume_and_get
Date:   Tue, 19 Apr 2022 11:03:52 +0000
Message-Id: <20220419110352.2574359-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. This change is just to simplify the code, no
actual functional changes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
index 72acdf802258..abc1e4276cf0 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-ethtool.c
@@ -380,11 +380,9 @@ static int am65_cpsw_ethtool_op_begin(struct net_device *ndev)
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
 	int ret;
 
-	ret = pm_runtime_get_sync(common->dev);
-	if (ret < 0) {
+	ret = pm_runtime_resume_and_get(common->dev);
+	if (ret < 0)
 		dev_err(common->dev, "ethtool begin failed %d\n", ret);
-		pm_runtime_put_noidle(common->dev);
-	}
 
 	return ret;
 }
-- 
2.25.1

