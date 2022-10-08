Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA9F5F8440
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 10:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJHIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJHIXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 04:23:20 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C63564CF
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 01:23:19 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mkyjn3MzpzHv8v;
        Sat,  8 Oct 2022 16:18:21 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 8 Oct 2022 16:23:17 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 8 Oct
 2022 16:23:17 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <vladimir.oltean@nxp.com>, <jiri@nvidia.com>, <kuba@kernel.org>
Subject: [PATCH net] net: dsa: fix wrong pointer passed to PTR_ERR() in dsa_port_phylink_create()
Date:   Sat, 8 Oct 2022 16:39:42 +0800
Message-ID: <20221008083942.3244411-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix wrong pointer passed to PTR_ERR() in dsa_port_phylink_create() to print
error message.

Fixes: cf5ca4ddc37a ("net: dsa: don't leave dangling pointers in dp->pl when failing")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/dsa/port.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index e4a0513816bb..208168276995 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1681,7 +1681,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
 			    mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(pl)) {
-		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(dp->pl));
+		pr_err("error creating PHYLINK: %ld\n", PTR_ERR(pl));
 		return PTR_ERR(pl);
 	}
 
-- 
2.25.1

