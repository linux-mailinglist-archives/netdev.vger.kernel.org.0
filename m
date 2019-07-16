Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE766A2B5
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 09:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfGPHQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 03:16:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2269 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726385AbfGPHQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 03:16:30 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 053F02014B24A30DB212;
        Tue, 16 Jul 2019 15:16:28 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 16 Jul 2019
 15:16:21 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net/sched: Make NET_ACT_CT depends on NF_NAT
Date:   Tue, 16 Jul 2019 15:16:02 +0800
Message-ID: <20190716071602.27276-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If NF_NAT is m and NET_ACT_CT is y, build fails:

net/sched/act_ct.o: In function `tcf_ct_act':
act_ct.c:(.text+0x21ac): undefined reference to `nf_ct_nat_ext_add'
act_ct.c:(.text+0x229a): undefined reference to `nf_nat_icmp_reply_translation'
act_ct.c:(.text+0x233a): undefined reference to `nf_nat_setup_info'
act_ct.c:(.text+0x234a): undefined reference to `nf_nat_alloc_null_binding'
act_ct.c:(.text+0x237c): undefined reference to `nf_nat_packet'

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/sched/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index dd55b9a..afd2ba1 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -942,7 +942,7 @@ config NET_ACT_TUNNEL_KEY
 
 config NET_ACT_CT
         tristate "connection tracking tc action"
-        depends on NET_CLS_ACT && NF_CONNTRACK
+        depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
         help
 	  Say Y here to allow sending the packets to conntrack module.
 
-- 
2.7.4


