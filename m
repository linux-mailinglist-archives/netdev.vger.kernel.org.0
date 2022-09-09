Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30565B2C2B
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 04:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiIICfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 22:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiIICfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 22:35:18 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF716B647;
        Thu,  8 Sep 2022 19:35:16 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MP0Nr1qkfzlVrZ;
        Fri,  9 Sep 2022 10:31:24 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 10:35:15 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600010.china.huawei.com
 (7.193.23.86) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 9 Sep
 2022 10:35:14 +0800
From:   Sun Ke <sunke32@huawei.com>
To:     <joyce.ooi@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <sunke32@huawei.com>
Subject: [PATCH v2] net: ethernet: altera: TSE: fix error return code in altera_tse_probe()
Date:   Fri, 9 Sep 2022 10:46:17 +0800
Message-ID: <20220909024617.2584200-1-sunke32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sun Ke <sunke32@huawei.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 89ae6d1623aa..3cf409bdb283 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1411,6 +1411,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 				       priv->phy_iface, &alt_tse_phylink_ops);
 	if (IS_ERR(priv->phylink)) {
 		dev_err(&pdev->dev, "failed to create phylink\n");
+		ret = PTR_ERR(priv->phylink);
 		goto err_init_phy;
 	}
 
-- 
2.31.1

