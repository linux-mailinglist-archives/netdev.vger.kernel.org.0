Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656F8356F73
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353116AbhDGO5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:57:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16389 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345804AbhDGO5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:57:23 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FFnWH4PqXzlW91;
        Wed,  7 Apr 2021 22:55:23 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 22:57:02 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Moritz Fischer <mdf@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Vaibhav Gupta" <vaibhavgupta40@gmail.com>,
        Lucy Yan <lucyyan@google.com>
CC:     <netdev@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] tulip: de2104x: use module_pci_driver to simplify the code
Date:   Wed, 7 Apr 2021 15:07:08 +0000
Message-ID: <20210407150708.364091-1-weiyongjun1@huawei.com>
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
 .../net/ethernet/dec/tulip/de2104x.c    | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index c3cbe55205a7..b018195f0243 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2193,15 +2193,4 @@ static struct pci_driver de_driver = {
 	.driver.pm	= &de_pm_ops,
 };
 
-static int __init de_init (void)
-{
-	return pci_register_driver(&de_driver);
-}
-
-static void __exit de_exit (void)
-{
-	pci_unregister_driver (&de_driver);
-}
-
-module_init(de_init);
-module_exit(de_exit);
+module_pci_driver(de_driver);

