Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A499F3375F9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 15:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233882AbhCKOmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 09:42:42 -0500
Received: from mail-co1nam11on2082.outbound.protection.outlook.com ([40.107.220.82]:62304
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233621AbhCKOmV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 09:42:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LuG7QLM49RNVM0Le9t6ezO2GabUZH2pg/aeBz6c6L5sf6C9NMfMqx4lqYMmWmuG/o/ebzb42uYioBj5bFZu9f9anoFvqmhQ4B6Nn3rJ4IROUgJNaNumGl0iEkqOnMosl0W5HHITzw81sWQ0eFP4EYIxzIU6W+UQW4dOHTJrWlwC1WRqmaETmrOc28Iu8US8Iqs9KvwporlADVh27NwIufKjOoDimwuWtDaFb4wuvrXVLfVPWAUR+nA/qyB62IJJ07o+QC7fs7kZWj8h1nrN14F0P4IuMvuxh/S8BwvVj1zb1EcoSEOqgw9cxheT0d9pPNaw86mP08X/YkuVnYCVX9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBSGgD+3gCAmkz/V3Eto0HnZXQx6DZRPv/vcjo7dMes=;
 b=UdW40mgfvtWoeMJLQE7MDcrGqbR/VPSv2CNld2AmUivHFHicgaRu7wVcXlEZldAQ4v1ewfC2ClFe8PRlB2FBfXgVND2ZBSziLmimYb198aT9X2WcLAwyvauc+x2DzGkghKEI5O5KowWzaegI3lNowWiRbSPJgvLUc3Y4Zvbsbsg//IQWbUJfMMI1Zt+mtrt+gtXzYNrBneND8qGj6lMKlpELAaDxxzkeXd/GDU/+i17ah4Cn+xk6nidDhM9PQ/WTI3Sf7nxuDaiN5e1vUnEVZcWCYszzMnkwB7A2MSkUYeDLDtMZr+9yzlq/eu5mXtuKThF8z3NfaSX5W0Hp8DL9rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uBSGgD+3gCAmkz/V3Eto0HnZXQx6DZRPv/vcjo7dMes=;
 b=EaNAcoyoMG/dYikGGT9ZOeU6N1SPAlcG9JY2c3/9B1PFkopc33qV5FzMiJ+EaKXYDbDU4nTA8iiNbVr6ZzUN1kOqLnbwMfEv56gjIHib4c5mH/rLX34zTWTJRcMWWMFRwOMvO6qVu4aenSwR86lOrzT6I9efiuLBSWE31ZVJK+KqbxydZe0snm1udgwGJHFWn3lRryDfKxtffJPMJKlrTeY2HebJOc0UhE8ffLEVBt9BR/8mpCIQ/Hsj9jYwhZ/RGB9+HmAnr/2QD4Lnni15kzludyQrnhaLk5y5slo3YZppgDUMuGZy/ynj8SKfw02k3mFhtMGD/Hr5f/H+44DOIA==
Received: from BN9PR03CA0150.namprd03.prod.outlook.com (2603:10b6:408:fe::35)
 by DM6PR12MB3226.namprd12.prod.outlook.com (2603:10b6:5:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Thu, 11 Mar
 2021 14:42:19 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::22) by BN9PR03CA0150.outlook.office365.com
 (2603:10b6:408:fe::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 14:42:18 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:42:17 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:42:17 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Mar 2021 14:42:14 +0000
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
Subject: [PATCH net 2/2] sch_htb: Fix offload cleanup in htb_destroy on htb_init failure
Date:   Thu, 11 Mar 2021 16:42:06 +0200
Message-ID: <20210311144206.2135872-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210311144206.2135872-1-maximmi@nvidia.com>
References: <20210311144206.2135872-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aea3f522-742f-402d-1699-08d8e49bdf08
X-MS-TrafficTypeDiagnostic: DM6PR12MB3226:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3226DD245228EEB0304A9064DC909@DM6PR12MB3226.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AnUuaZX3pMohK3YVfKRSttZ47Hv8U2G2Fi79ViIVn2p//SeivXQygH5aw5f6px0CSkGcDwqApjT5Wy8zxzNS3TMi66NdI4kctIxp3aCJk36ls7wimvupSk2etcO+LAqBaf1gSEaMlSIZyAlF0g1IQcOYW5QX4ZQkcDD4vHOCfyM5OWVDq0D65clyYP7bwBklbouz79WaRrNTdlw1TCQXxd3Bna+8LfjQLJWOsB2gkpZ3FoBxvZ8wNzU6T0FWesgQg5y4qM1qV4kmhnAinnE2i+ZKqdCZyNRsa/2H5GnneFZJCYGwvxbyuqSDLm2ImL8IJyWB8sQo5exT7pZNK8gx7sT4oItgwt6OCe5OpLYSQDNNcn0SWgC9GPdY5u4CPQsL37oiajdUxf4NB+7A2XAJbZnyUpmD26uXpR4920QjXXnUBGjwiAZfV9OEZRBXzOdH0s7LbG003NShYX4HYeex5+ZTsXguDt17eDg9EOHJliBajWElB+UiEThWs2QyyL74FUv9xMailwhxRVFZ+MjdG51tMquNkPdxBLHkGXpgBQtfxL4jK55WA2046tsGYf9Sm4PPMSOw9XvI5nPsbf27MQTJHI6O7L3ITkyL+ZrHtOqpWRF6B82qmJgdxrP/jK9/OO2XXxdBxzF+6GTn6VtwEArChvIl7quVKvqBSX6263s+M7g2GY38kcS8VWYHFkQX
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(46966006)(47076005)(26005)(186003)(5660300002)(82740400003)(2906002)(2616005)(34070700002)(83380400001)(478600001)(36860700001)(426003)(356005)(336012)(4326008)(8936002)(7636003)(86362001)(54906003)(8676002)(6666004)(110136005)(36906005)(316002)(1076003)(7696005)(70586007)(70206006)(82310400003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:42:18.4319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aea3f522-742f-402d-1699-08d8e49bdf08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3226
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

htb_init may fail to do the offload if it's not supported or if a
runtime error happens when allocating direct qdiscs. In those cases
TC_HTB_CREATE command is not sent to the driver, however, htb_destroy
gets called anyway and attempts to send TC_HTB_DESTROY.

It shouldn't happen, because the driver didn't receive TC_HTB_CREATE,
and also because the driver may not support ndo_setup_tc at all, while
q->offload is true, and htb_destroy mistakenly thinks the offload is
supported. Trying to call ndo_setup_tc in the latter case will lead to a
NULL pointer dereference.

This commit fixes the issues with htb_destroy by deferring assignment of
q->offload until after the TC_HTB_CREATE command. The necessary cleanup
of the offload entities is already done in htb_init.

Reported-by: syzbot+b53a709f04722ca12a3c@syzkaller.appspotmail.com
Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/sched/sch_htb.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index b23203159996..62e12cb41a3e 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1020,6 +1020,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_HTB_MAX + 1];
 	struct tc_htb_glob *gopt;
 	unsigned int ntx;
+	bool offload;
 	int err;
 
 	qdisc_watchdog_init(&q->watchdog, sch);
@@ -1044,9 +1045,9 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	if (gopt->version != HTB_VER >> 16)
 		return -EINVAL;
 
-	q->offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
+	offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
 
-	if (q->offload) {
+	if (offload) {
 		if (sch->parent != TC_H_ROOT)
 			return -EOPNOTSUPP;
 
@@ -1076,7 +1077,7 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 		q->rate2quantum = 1;
 	q->defcls = gopt->defcls;
 
-	if (!q->offload)
+	if (!offload)
 		return 0;
 
 	for (ntx = 0; ntx < q->num_direct_qdiscs; ntx++) {
@@ -1107,12 +1108,14 @@ static int htb_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err)
 		goto err_free_qdiscs;
 
+	/* Defer this assignment, so that htb_destroy skips offload-related
+	 * parts (especially calling ndo_setup_tc) on errors.
+	 */
+	q->offload = true;
+
 	return 0;
 
 err_free_qdiscs:
-	/* TC_HTB_CREATE call failed, avoid any further calls to the driver. */
-	q->offload = false;
-
 	for (ntx = 0; ntx < q->num_direct_qdiscs && q->direct_qdiscs[ntx];
 	     ntx++)
 		qdisc_put(q->direct_qdiscs[ntx]);
-- 
2.25.1

