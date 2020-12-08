Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009032D2A74
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbgLHMOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:14:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9036 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbgLHMOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:14:18 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CqzbN68LZzhntg;
        Tue,  8 Dec 2020 20:13:04 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 8 Dec 2020 20:13:26 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <pshelar@ovn.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <dev@openvswitch.org>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: openvswitch: conntrack: simplify the return expression of ovs_ct_limit_get_default_limit()
Date:   Tue, 8 Dec 2020 20:13:53 +0800
Message-ID: <20201208121353.9353-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify the return expression.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/openvswitch/conntrack.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4beb96139d77..96a49aa3a128 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2025,15 +2025,11 @@ static int ovs_ct_limit_get_default_limit(struct ovs_ct_limit_info *info,
 					  struct sk_buff *reply)
 {
 	struct ovs_zone_limit zone_limit;
-	int err;
 
 	zone_limit.zone_id = OVS_ZONE_LIMIT_DEFAULT_ZONE;
 	zone_limit.limit = info->default_limit;
-	err = nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
-	if (err)
-		return err;
 
-	return 0;
+	return nla_put_nohdr(reply, sizeof(zone_limit), &zone_limit);
 }
 
 static int __ovs_ct_limit_get_zone_limit(struct net *net,
-- 
2.22.0

