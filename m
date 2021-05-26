Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1FF391D76
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbhEZRDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:03:11 -0400
Received: from mail-dm3nam07on2045.outbound.protection.outlook.com ([40.107.95.45]:31407
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233676AbhEZRDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 13:03:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oelGHGqR88MCPubB4/6QzQ+9rLEBa7l8Si2y2p8wWMGRRfeQFrBXorMCQG/3WWI2v4I16NsDHcZTCXrVd0KFSJlcNCXM9ufJwtWQWtEpbitRJksHY3gaTcLAo45CLcVV0pnKi7is2VClWEpsAQgk25swwq9pTHQD7iJ7KF+s3XfEuVYY1mWvtrAG9RiIbpk+3a89PaQPqPEQ+Oy7YreavV0aCdyYyKXVQikofdPUekoemyG9fQYzBbuTZxLs48IR9StAN6NzVAo9BSV+ABhCejluhrJ0FNNdV5bNb0u5jkhs9Grv1nWqKVQDpT3wb8rfDwnEBWRIQvwVp/cFnfWwHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6YWkcz5ETQZOYZqI6yR8dGwyMqKBJZs/WOmjsHyOio=;
 b=b7C2s7JPONNgO7KtmwhVja7PXVay/JWO2ABYrozMgakzMKaOa++utzYRuGCLLzyu68UKmjpE5vVSk636B8GCOoh1P3eDWFSvnMx5cIgGvk+uJsI2+yb+HXWwbOnbtp+KSqWA2Z6sHBW6qTHFsSeluatoE/QcPcp0l517ct9Z/4WLc/08aJgFNxMr+bMQGIksnOQUQS/mMz8bJv0ES7i+dfJY45idcR6Vqnpsgd7iY5UT6eKUprkPtEIsufT3vh4sgNgzashh6I+pD+lKaNUjXGxaW2/zogNFoXZQ2k0vcleihwAkmwugayBes1Lr02mbX+Z3jvTN0V2Q12MIhcYKGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6YWkcz5ETQZOYZqI6yR8dGwyMqKBJZs/WOmjsHyOio=;
 b=o3biiz2+BiftHIhpD4QGgb5H89146s8Scu87f4G4LEHA1iyOZ3UUkGmlE8Usy0g9ZHQPyXS8LSdqnQU5NN4IFcQPH6Aj6A3fqXJvqYYiosqnmPhczCb5qRPTvP3fR4om7O7R3JOF13yxsenCjpjd7uHxKjn9cSWD40kgAZEBOLmQ5w9ORe1d0bqNclDEAfkd7OuTnz3oi/Pf1XRWjF1iAMB97ZXAJAYFBtVOFv4SCGE3RpMGqH2Y3eSAw33P89dDYHO1DAPZgIOcdcLw88DMOjGTL1eCqbvLmXm5UUygtnMs2ovFYMsc9JBYq1j2hQVu1SdG82M87x3HbgD607sxSg==
Received: from BN9PR03CA0061.namprd03.prod.outlook.com (2603:10b6:408:fc::6)
 by PH0PR12MB5402.namprd12.prod.outlook.com (2603:10b6:510:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 17:01:37 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::4d) by BN9PR03CA0061.outlook.office365.com
 (2603:10b6:408:fc::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 26 May 2021 17:01:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 17:01:36 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 10:01:35 -0700
Received: from gen-l-vrt-029.mtl.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 17:01:34 +0000
From:   Ariel Levkovich <lariel@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <marcelo.leitner@gmail.com>, <paulb@nvidia.com>,
        <jiri@resnulli.us>, "Ariel Levkovich" <lariel@nvidia.com>
Subject: [PATCH net] net/sched: act_ct: Fix ct template allocation for zone 0
Date:   Wed, 26 May 2021 20:01:10 +0300
Message-ID: <20210526170110.54864-1-lariel@nvidia.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d06ca670-d8a3-4ae4-bad8-08d92067ec48
X-MS-TrafficTypeDiagnostic: PH0PR12MB5402:
X-Microsoft-Antispam-PRVS: <PH0PR12MB54024E642FBDD75377E6ED3FB7249@PH0PR12MB5402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6VtpjqJGI0kE94bcLxlX4WqEQ/QfjjYeXs5fZ3QgyC+92C1m9Q5LvjrNw6uuPmmVFJu2eEGdtQ6cUXlLD4Ef3Ti3h0af4zMFRy+eM2z5BZv4bABtC7NL1NfkO4/Rb2+vmLOyKX11fifS7lsRGiHKjGSQTqyUeQFLP6GU/AnC7Wqqow+42OtMm9+sIEube09U4sQawVi0oMXDOIj3GwXpGoLTKCuwYEhwukg28NH7VRy1gBeyOFV/0JyWlkpug9rzRXAgj49AXetkv20nLtuwduw0Conj4SYfFt6xfGQMJC2zpk4otmWOKn1SWzgwQjdyx3ninJLyPujbXbdeEwInnN+Dgk66pQuBUCpt/JQhf9yx2HyONMmw2FRNvZxm3qEOwXOvbDC0XxdTuk1tq4Sc1EvgtB/o9sqLIIUpZ7NxJ645b2FM4M7c5uvbeBFrPWY4/uQVQe4GyDykJR2RbX4C6KNp8l43NboXXCmZ2pbFTnEk0Z8xSrNuiMbTmwRPQLBUmrIm3RMHNx6C6BW8x4uH9u2uu6X4gS6zoQhnYdHrLLkL3zXbvhCwKRF+7PopcQU1N+vmUTP/0lQpU59GrAfsSa5dsNQ1jtihBrGHTuDhFwDIfHmvLM+4tK6G2l2PyOQ5Y7P4c3gRrFQ3tT7dBvY947DvaCkMwxTSAFeucASUus=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(36840700001)(46966006)(82740400003)(7636003)(356005)(83380400001)(86362001)(54906003)(1076003)(82310400003)(2906002)(36756003)(47076005)(6916009)(8676002)(36860700001)(2616005)(8936002)(4326008)(316002)(478600001)(70586007)(426003)(336012)(107886003)(6666004)(70206006)(5660300002)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 17:01:36.5756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d06ca670-d8a3-4ae4-bad8-08d92067ec48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5402
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix current behavior of skipping template allocation in case the
ct action is in zone 0.

Skipping the allocation may cause the datapath ct code to ignore the
entire ct action with all its attributes (commit, nat) in case the ct
action in zone 0 was preceded by a ct clear action.

The ct clear action sets the ct_state to untracked and resets the
skb->_nfct pointer. Under these conditions and without an allocated
ct template, the skb->_nfct pointer will remain NULL which will
cause the tc ct action handler to exit without handling commit and nat
actions, if such exist.

For example, the following rule in OVS dp:
recirc_id(0x2),ct_state(+new-est-rel-rpl+trk),ct_label(0/0x1), \
in_port(eth0),actions:ct_clear,ct(commit,nat(src=10.11.0.12)), \
recirc(0x37a)

Will result in act_ct skipping the commit and nat actions in zone 0.

The change removes the skipping of template allocation for zone 0 and
treats it the same as any other zone.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
---
 net/sched/act_ct.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ec7a1c438df9..dfdfb677e6a9 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1202,9 +1202,6 @@ static int tcf_ct_fill_params(struct net *net,
 				   sizeof(p->zone));
 	}
 
-	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
-		return 0;
-
 	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
 	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
 	if (!tmpl) {
-- 
2.25.2

