Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F0826F68C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 09:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIRHP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 03:15:57 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13289 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgIRHP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 03:15:56 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C4E81EF374C192D02997;
        Fri, 18 Sep 2020 15:15:54 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 18 Sep 2020 15:15:47 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <pshelar@ovn.org>, <davem@davemloft.net>
CC:     Zeng Tao <prime.zeng@hisilicon.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <dev@openvswitch.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: openswitch: reuse the helper variable to improve the code readablity
Date:   Fri, 18 Sep 2020 15:14:30 +0800
Message-ID: <1600413270-38398-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function ovs_ct_limit_exit, there is already a helper vaibale
which could be reused to improve the readability, so i fix it in this
patch.

Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
---
 net/openvswitch/conntrack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index a3f1204..e86b960 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1901,8 +1901,8 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 					 lockdep_ovsl_is_held())
 			kfree_rcu(ct_limit, rcu);
 	}
-	kfree(ovs_net->ct_limit_info->limits);
-	kfree(ovs_net->ct_limit_info);
+	kfree(info->limits);
+	kfree(info);
 }
 
 static struct sk_buff *
-- 
2.8.1

