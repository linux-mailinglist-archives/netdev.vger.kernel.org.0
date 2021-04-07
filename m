Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DD5357075
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbhDGPgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:36:52 -0400
Received: from mail-bn8nam11on2080.outbound.protection.outlook.com ([40.107.236.80]:57313
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243477AbhDGPgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:36:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ojb+ZrPcq3ZVrt+1bNKYZ5VPFxCBbAQQcxd1GfRowaO056UnUCQ0Z73y+mR3SAhh3jkeT5oDrSSrd30B5BbHbLRaIdpf3CN1JQinr8BU+3bvpHLetaN1fwEPVXlmXP8sFYPJUvJUF1aodmi6pufRKL8YHPKGSZU8o9aFawwP/t+5XXIsBHR80brnUMVPQyyuXwtcJoZDEeyI4pnWQAlqrXwOIugAusDuxgox0KOyMI+JjFJd15iDKtojWX5qaFSEmWe61yhlRAfT41Xorj3T/PtMQU6eX8hl/WEXP6KMy2WoNLyWVm424UrGDPrJCwyiMxVx8t/FGhByHoU5seM/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOfIe9gxnRRrWCs9x3ma1TQIoFwY+vgBSDrQeQlaks0=;
 b=ZGhSizPvswEXfkiLSqfyaWZtkmY41XGW4RmLEyPN8Ulz2UFAcY4IvYgZL8lYLTgMNfdfKcvGPrN1U7r1tD+e6cR+Z0iJpnsNRC7sNyP/zMT10XaocAWVEdxXF2RgaupiH+DE/so/li3/eK6zOnugYql863zSycoKehDi092q5z6ONTp0Ku4H3LN6VEJSrVmV6/VeKTY292OMQffXznoj++mUsJL970PQhxZYuyN5HrkqIMs2gTN8X9Zt1C14uUbOAiY98qb+6N2XZr3zIGH+yEtasyU6p7ufYloPmVAe5ETZJY3TBoPUGfLo00KiylPxqlL8mv8pQrwGYpLTcBzdUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOfIe9gxnRRrWCs9x3ma1TQIoFwY+vgBSDrQeQlaks0=;
 b=ofJZ43tW0wwtRosRipDYlDKxr/ImtmT31OyKYorbWIIzFRFaHG0nNeB8N546G9/m42WwSL3chlU8LLco026hbecE0B29QEhFlZfKD28hdjDBUMMIX2t0mUCBf7iOrZmPDQyJJPvOIDo8TzayUl19Ff3PLikoC5UqXmWfER2/b2oIoxEwdN5C9W32mGk4jTaVgc9jkgepeaBeakuO/Z3tkhwBIdIAM+VGfcfoxnS8zdnGn5SX/JN1ZKpyYuFuDgEti9wcJzGbStbU+mWHwwoHt4N+GB13WY49M4SUEbJp1e6Swa+o+Y6a33BcUtMxJg8PY/9ESO8McmxZfcs/biUTUw==
Received: from DS7PR03CA0300.namprd03.prod.outlook.com (2603:10b6:5:3ad::35)
 by DM6PR12MB4763.namprd12.prod.outlook.com (2603:10b6:5:36::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 7 Apr
 2021 15:36:38 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::48) by DS7PR03CA0300.outlook.office365.com
 (2603:10b6:5:3ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:36:37 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:36:37 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:36:34 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net v2 1/3] Revert "net: sched: bump refcount for new action in ACT replace mode"
Date:   Wed, 7 Apr 2021 18:36:02 +0300
Message-ID: <20210407153604.1680079-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407153604.1680079-1-vladbu@nvidia.com>
References: <20210407153604.1680079-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 819fdd9a-d3c3-4bc3-d8f4-08d8f9daef02
X-MS-TrafficTypeDiagnostic: DM6PR12MB4763:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4763C449C339039571BED069A0759@DM6PR12MB4763.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:27;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48KbCj4zq9NxcM1sW4Lk7q/1FCMgxfeqkK2CHoHGC9/zIHjA8H/ndJ9pAhYgixuaDmiSKQM4Y4/+9gbnyGSBWuICCKY8pnrkzK5nf/FzQp0duYTItKBQq1yi0ZByBlFUjr8WfMquUarZp4McLiMVXumM7CVubWkGWlvkx7FGAL+mubrc5PT+sDuySifS2V5IZoG02PWZEh/KaSyXhzB7MnDjCC5rR5wdfsIcCw4B7SKVpONw8n7dXxb3vrMUrMtROBcEHbJoYVbHbi8J0KodozE+nUtAfXU95Og3NoaAugWhLz1u29+sZtW9oD0nrNlQj1cA1mqQ0WI3xUgzBN+CmZCwa5uspHfS9jFob4mRMxV/JkNmNFf1wtLAQJ/Gm+6PUK5rFamhbXmzm/PPd3J6wwMo2sFbzsutLoGlWPDCwkECQbJ7IewZ4wmp2Xckn8q1zmDoubLDRpswJgEtg/yXhrfcemrCzckiIT5qyWBrcOQswiZVmrosIjC3WgSIs3TTITh/nukgsbXVbRKwvSxABvaoS797bU0gro2UQsNeWiI9o0O4MgEReHQ4uz2aVXbZuivlH9F5XUMvOv/g4KQ85Y2qEN1Cvl2oAPePah/CkkGDVGjDWFWCnEdAYOJMLnPeqkcQW1yn1cb7RVmrYt8wiAxT+wZmaXEsphrRa3zEpPw=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(39860400002)(36840700001)(46966006)(316002)(2906002)(8676002)(7696005)(8936002)(54906003)(7416002)(6666004)(5660300002)(478600001)(6916009)(86362001)(82740400003)(47076005)(36860700001)(4326008)(70586007)(82310400003)(1076003)(7636003)(4744005)(107886003)(36756003)(2616005)(186003)(336012)(70206006)(426003)(26005)(83380400001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:36:37.9943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 819fdd9a-d3c3-4bc3-d8f4-08d8f9daef02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4763
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149.

Following commit in series fixes the issue without introducing regression
in error rollback of tcf_action_destroy().

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_api.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 43cceb924976..b919826939e0 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1042,9 +1042,6 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	if (err != ACT_P_CREATED)
 		module_put(a_o->owner);
 
-	if (!bind && ovr && err == ACT_P_CREATED)
-		refcount_set(&a->tcfa_refcnt, 2);
-
 	return a;
 
 err_out:
-- 
2.29.2

