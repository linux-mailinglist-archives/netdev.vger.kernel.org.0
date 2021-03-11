Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCF23375F8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 15:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhCKOmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 09:42:40 -0500
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:48993
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230259AbhCKOmR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 09:42:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehki8zxOK4xC2GSo+Dx36ZiQwPaGO24xwSHDdS8GXSw1TLpbbbp3zu11Ig9wBN/uaXkb8pSk2nZfM6TqXWtrs3M1iitBdtxPE81r55ZF6hO4q0vb/ZagbQZojPuMmIoe8eVJOE9/pzHZVmlFRAeVEEKikBUUWgYOW2UUzWWVvuYvKj/xelkkefCbGl0AmGchf4rpxbPhCwr7mvjdVOw5741D1RC0I9RxrtgZFKzJswnxz6XiMbnPAoR/GoiyHA8nOOtpHRnV5lj0RpolSXUSPK10/tiK8FOCoZu4+MjjlFMyl1xd4FhH926A9E/cp/Ir2+0Mgl5KNoPt4rSeJmbyJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQcWCbdoRpAnEMsg0bWI0ctQ9+0BuTe44xk+PRTXJiY=;
 b=YGkQPqqDPewgqV7UWvA/Lp3iySN2dmkoWR8Edd6ONr0UDguAzvI8fBJ9Im27SMrMXbG+v9jT2WiARaKnP8IQrCsQqnHffgY8gDtvtXY6FPULr/9RJq2HD7Pu1QM2dAb5PhDluccePaoy06JAge5FzaMUTlKvDRZNaL23+gW1u7ZpiFN+Iv7AC6dpxGh2OxL1EwIhl7mAhnru1UL3LctPkVDun7GDSSqIwmiLK4XgpH+7mOcHUwXPvfPdm2G2XeLD8bLgrQdXoiYY3/YMcO1HodrSktIo6+FfzQOeAM5d1vPDYdWbBAWseXtAYrtddIRHASTf/Nf+kE0hM3xxH5Suyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQcWCbdoRpAnEMsg0bWI0ctQ9+0BuTe44xk+PRTXJiY=;
 b=YxnL9lmzaJe7vXej+pAkauRvO/XkGPh4oQiAgE1UfL0dQW2viM9G2eUAzi4QXH0nKREpDoJ1zamvR+cn3BfB6BjIuulsXELYSKNd6y3RbeKl0GCtGUglLJ88jFlITnmEWwVcyI97hyqvznj52hVzPdcSRW7ai8co8COY8WREkGyLYvXMq1PadDnPSk/PLeSavyOK7RT8/gz43Fwbn4J63OdCuYeMRZXNxNZLwmJKQcHZW5o6k6btpe8xKXkE/os4HYBRE1UYMpoH/Gfivb6juNpB6N5M8LeRxGLcEx+PP0kmqBQVj0y9raHd51WDDfHVy8hSoWQlkUzsoZjGdxamrA==
Received: from MWHPR12CA0065.namprd12.prod.outlook.com (2603:10b6:300:103::27)
 by DM6PR12MB3098.namprd12.prod.outlook.com (2603:10b6:5:11c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Thu, 11 Mar
 2021 14:42:15 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::72) by MWHPR12CA0065.outlook.office365.com
 (2603:10b6:300:103::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 14:42:14 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:42:14 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:42:14 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:11 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, Maxim Mikityanskiy <maximmi@nvidia.com>,
        <syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com>
Subject: [PATCH net 1/2] sch_htb: Fix select_queue for non-offload mode
Date:   Thu, 11 Mar 2021 16:42:05 +0200
Message-ID: <20210311144206.2135872-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311144206.2135872-1-maximmi@nvidia.com>
References: <20210311144206.2135872-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c25d8169-e7d9-46c1-c7c6-08d8e49bdce3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3098:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3098601934FA43939A2EAFC3DC909@DM6PR12MB3098.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YW0OGJOrPMagqOEEHfu1RVJgdA+/oBVPZ+GrC8qTYl1PAZAM1HkZV4XIi1gGXjTa7alWXGFKX3VuoTWu8OvKGzJVVs12jQ1RpbEiIkEN8misZ4b8VH7HjnrvJmMQe8MltRm0tHsM+K2mTxnbUHJYUbCynNbHxfMwudX12ci7++rjrNrbeF2xWBVe7yd2sahvwNZqVwrM1zTIP7lkKZxKtd5KKVJAM1A4azFTP7S+12HiJle49b0psteWRPMuc4YJ+Zqo8gsWslTLjLeM9hZR1tLMcEgw+WSbQ9G7fsbppQx7MVS1wdCFdv1cn/a9+I16f+4rYcOw4IH3RGCEWRs8AEq0ZQpEkvJQpq4c9qYlHU+QECa/5h325DaDPyPPMMdLfQbQ+yaO0SIJqQnIIwkaLpM/cDeO3qVmAbwsLJ/m/vlJrvY3Nwg9/euWwtztIVfqqR5C+dI95jN8lBp9nQUMW7gqDpPnWBdyhl6Ixg+tQDlX7wWT/XLZaLcZGAE0cn/9kXv6S25gy1bOdMLEstxPZPkYii68tqfVm5RNtkX1vhXsZ+f385wQtAz+USCoVhk7gjPTf/IdGxns+czaSq2gmksLxq3YURfSdEW86x0U4gLc+Jcz1VbqZts/aDgJENyXXZEVsoVhDQR/cL0NRXVVIFDCMzPUlAkc1WMwoy3JgLp5zYPMrv5AAYD2pDt23yTZ
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(46966006)(36840700001)(186003)(54906003)(2906002)(2616005)(110136005)(26005)(6666004)(316002)(336012)(36906005)(356005)(36756003)(47076005)(7636003)(82310400003)(86362001)(4326008)(8936002)(70586007)(478600001)(70206006)(8676002)(34070700002)(7696005)(82740400003)(36860700001)(5660300002)(426003)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:42:14.8824
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c25d8169-e7d9-46c1-c7c6-08d8e49bdce3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

htb_select_queue assumes it's always the offload mode, and it ends up in
calling ndo_setup_tc without any checks. It may lead to a NULL pointer
dereference if ndo_setup_tc is not implemented, or to an error returned
from the driver, which will prevent attaching qdiscs to HTB classes in
the non-offload mode.

This commit fixes the bug by adding the missing check to
htb_select_queue. In the non-offload mode it will return sch->dev_queue,
mimicking tc_modify_qdisc's behavior for the case where select_queue is
not implemented.

Reported-by: syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com
Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index dff3adf5a915..b23203159996 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1340,8 +1340,12 @@ htb_select_queue(struct Qdisc *sch, struct tcmsg *tcm)
 {
 	struct net_device *dev = qdisc_dev(sch);
 	struct tc_htb_qopt_offload offload_opt;
+	struct htb_sched *q = qdisc_priv(sch);
 	int err;
 
+	if (!q->offload)
+		return sch->dev_queue;
+
 	offload_opt = (struct tc_htb_qopt_offload) {
 		.command = TC_HTB_LEAF_QUERY_QUEUE,
 		.classid = TC_H_MIN(tcm->tcm_parent),
-- 
2.25.1

