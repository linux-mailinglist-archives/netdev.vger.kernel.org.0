Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D67D5A74B1
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 06:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiHaEKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 00:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiHaEKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 00:10:15 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B4842ACB;
        Tue, 30 Aug 2022 21:10:12 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MHVwb4Lnpz1N7hq;
        Wed, 31 Aug 2022 12:06:23 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 31 Aug 2022 12:10:02 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <morbo@google.com>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>
Subject: [PATCH next-next 1/2] net: vlan: remove unnecessary err variable in vlan_init_net()
Date:   Wed, 31 Aug 2022 12:09:56 +0800
Message-ID: <e68a18f6bfeeb5d05c1506da65f308e8e3d29013.1661916732.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661916732.git.william.xuanziyang@huawei.com>
References: <cover.1661916732.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return vlan_init_net() directly in vlan_init_net(), remove unnecessary
err variable. Thus code looks more concise.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/8021q/vlan.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index e40aa3e3641c..aaef80fdd852 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -658,13 +658,10 @@ static int vlan_ioctl_handler(struct net *net, void __user *arg)
 static int __net_init vlan_init_net(struct net *net)
 {
 	struct vlan_net *vn = net_generic(net, vlan_net_id);
-	int err;
 
 	vn->name_type = VLAN_NAME_TYPE_RAW_PLUS_VID_NO_PAD;
 
-	err = vlan_proc_init(net);
-
-	return err;
+	return vlan_proc_init(net);
 }
 
 static void __net_exit vlan_exit_net(struct net *net)
-- 
2.25.1

