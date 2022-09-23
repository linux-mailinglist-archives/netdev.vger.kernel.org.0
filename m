Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66285E779A
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 11:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiIWJr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 05:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiIWJrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 05:47:19 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9771F12D07;
        Fri, 23 Sep 2022 02:47:07 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MYnLZ0SqmzHnY4;
        Fri, 23 Sep 2022 17:44:54 +0800 (CST)
Received: from huawei.com (10.67.175.83) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 23 Sep
 2022 17:47:05 +0800
From:   ruanjinjie <ruanjinjie@huawei.com>
To:     <jes@trained-monkey.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-hippi@sunsite.dk>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] drivers: net: hippi: Add missing pci_disable_device() in rr_init_one()
Date:   Fri, 23 Sep 2022 17:43:20 +0800
Message-ID: <20220923094320.3109154-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing pci_disable_device() if rr_init_one() fails

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
---
 drivers/net/hippi/rrunner.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index 74e845fa2e07..aa8f828a0ae7 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -213,6 +213,7 @@ static int rr_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_iounmap(pdev, rrpriv->regs);
 	if (pdev)
 		pci_release_regions(pdev);
+	pci_disable_device(pdev);
  out2:
 	free_netdev(dev);
  out3:
-- 
2.25.1

