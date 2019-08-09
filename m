Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC96186F72
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405079AbfHIBuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:50:25 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4204 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729419AbfHIBuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 21:50:25 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9BB5EBBDB859B5B143DA;
        Fri,  9 Aug 2019 09:50:22 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Fri, 9 Aug 2019
 09:50:14 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <vinicius.gomes@intel.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH v2 net-next] taprio: remove unused variable 'entry_list_policy'
Date:   Fri, 9 Aug 2019 09:49:23 +0800
Message-ID: <20190809014923.69328-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
In-Reply-To: <20190808142623.69188-1-yuehaibing@huawei.com>
References: <20190808142623.69188-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/sched/sch_taprio.c:680:32: warning:
 entry_list_policy defined but not used [-Wunused-const-variable=]

One of the points of commit a3d43c0d56f1 ("taprio: Add support adding
an admin schedule") is that it removes support (it now returns "not
supported") for schedules using the TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY
attribute (which were never used), the parsing of those types of schedules
was the only user of this policy. So removing this policy should be fine.

Reported-by: Hulk Robot <hulkci@huawei.com>
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
v2: respin commit log using Vinicius's explanation.
---
 net/sched/sch_taprio.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c39db50..046fd2c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -677,10 +677,6 @@ static const struct nla_policy entry_policy[TCA_TAPRIO_SCHED_ENTRY_MAX + 1] = {
 	[TCA_TAPRIO_SCHED_ENTRY_INTERVAL]  = { .type = NLA_U32 },
 };
 
-static const struct nla_policy entry_list_policy[TCA_TAPRIO_SCHED_MAX + 1] = {
-	[TCA_TAPRIO_SCHED_ENTRY] = { .type = NLA_NESTED },
-};
-
 static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_PRIOMAP]	       = {
 		.len = sizeof(struct tc_mqprio_qopt)
-- 
2.7.4


