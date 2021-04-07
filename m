Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173DF356F79
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353196AbhDGO51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:57:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:15952 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353138AbhDGO5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:57:25 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FFnVw0j3QzrdJR;
        Wed,  7 Apr 2021 22:55:04 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Wed, 7 Apr 2021 22:57:06 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH net-next] net: fealnx: use module_pci_driver to simplify the code
Date:   Wed, 7 Apr 2021 15:07:12 +0000
Message-ID: <20210407150712.368934-1-weiyongjun1@huawei.com>
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
 drivers/net/ethernet/fealnx.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/fealnx.c b/drivers/net/ethernet/fealnx.c
index c696651dd735..0908771aa9ac 100644
--- a/drivers/net/ethernet/fealnx.c
+++ b/drivers/net/ethernet/fealnx.c
@@ -1948,15 +1948,4 @@ static struct pci_driver fealnx_driver = {
 	.remove		= fealnx_remove_one,
 };
 
-static int __init fealnx_init(void)
-{
-	return pci_register_driver(&fealnx_driver);
-}
-
-static void __exit fealnx_exit(void)
-{
-	pci_unregister_driver(&fealnx_driver);
-}
-
-module_init(fealnx_init);
-module_exit(fealnx_exit);
+module_pci_driver(fealnx_driver);

