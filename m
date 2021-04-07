Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3043B356F6E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345708AbhDGO5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:57:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16387 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345663AbhDGO5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:57:19 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FFnWF2d1gzlW8s;
        Wed,  7 Apr 2021 22:55:21 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 22:56:59 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] enic: use module_pci_driver to simplify the code
Date:   Wed, 7 Apr 2021 15:07:05 +0000
Message-ID: <20210407150705.360840-1-weiyongjun1@huawei.com>
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
 .../net/ethernet/cisco/enic/enic_main.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index f04ec53544ae..f48957a17c3a 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -3040,15 +3040,4 @@ static struct pci_driver enic_driver = {
 	.remove = enic_remove,
 };
 
-static int __init enic_init_module(void)
-{
-	return pci_register_driver(&enic_driver);
-}
-
-static void __exit enic_cleanup_module(void)
-{
-	pci_unregister_driver(&enic_driver);
-}
-
-module_init(enic_init_module);
-module_exit(enic_cleanup_module);
+module_pci_driver(enic_driver);

