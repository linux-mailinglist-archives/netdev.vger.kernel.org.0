Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCF356F7D
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353215AbhDGO5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:57:30 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:16816 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345797AbhDGO5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:57:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FFnVt6gWWz9x5N;
        Wed,  7 Apr 2021 22:55:02 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 22:57:04 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: sundance: use module_pci_driver to simplify the code
Date:   Wed, 7 Apr 2021 15:07:09 +0000
Message-ID: <20210407150709.365762-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the module_pci_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/dlink/sundance.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/dlink/sundance.c b/drivers/net/ethernet/dlink/sundance.c
index df0eab479d51..ce61f79f3b7c 100644
--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -1982,17 +1982,4 @@ static struct pci_driver sundance_driver = {
 	.driver.pm	= &sundance_pm_ops,
 };
 
-static int __init sundance_init(void)
-{
-	return pci_register_driver(&sundance_driver);
-}
-
-static void __exit sundance_exit(void)
-{
-	pci_unregister_driver(&sundance_driver);
-}
-
-module_init(sundance_init);
-module_exit(sundance_exit);
-
-
+module_pci_driver(sundance_driver);

