Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DADB565E9E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 22:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiGDUpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 16:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiGDUpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 16:45:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D95DF80
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 13:45:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a50v+XikkdQeO+5NJSyCO5mzKPDMf9M44pqQ40RhuiRaJISQxZVu0LMdSKKwVxbtOy6MdtTQ4fWxXHAQciYT5chRFr8fXfuVQgNLTy8Z1hmfcxdEHi5OwRYpD73qdRjiwqfQkv5Re0VwWMZVcdEe1V4UpYL5Ui+JZfsubRkUtPajeoGWUJ5C4nLRDaFxZbVwiQsUgTm0oy8ctpfMaB5l7ebRjEPfrx+vZxaMHfxn5dRBIpV1Q+qyIJ9Q+XROS3M2H4wfSy5/Kollj30H0prhl/RSZIBWIMa37bSZp52RnZxGq4UIIlVEUq/QorNQ/MWuAoh3oYhbm9+xxxcyxbjtTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKIzGVmm2iNOk/pR8iWCM0u7SkRPzV6n+vY43b43CB4=;
 b=oBw0Evmng7P72MXqWDgAlClw5XrUVFv2eahKtdtvpG63hbaj4pjZhg8O9BXxlQevHCKD2O21ysnAM7iwSEEtsQ2Vp1qaJRi/jB2TGpQHLo6Q3ArzfGI3GEWRJV2304tl5uNULequX15gfyfcFI0krH2dQqsNoTrIEi0HE55AfoBmnh0UGJNpndFHoJOvYLn5HsOBWCJf5S3o+U1OzCff0PKUxKiyGue+HNjq3lBAnPYHOKkl3Glj8T8x50mcgU1pOmfuOtugDrYwsgmXBKqa9h1b0lnwYuASP3N9wDCf+11TChnWGBRyzcdFBMJd6bnduaAB83VeUgRn65WPHahH6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKIzGVmm2iNOk/pR8iWCM0u7SkRPzV6n+vY43b43CB4=;
 b=Wp5SVvXPVt8XgNEwRfrwqrDBr/e9Bq6PQJ6NJ5lXQcr9DiJ/FW/bw0a2d3TyNqLmUHArxZxclACjEN1t10zbZKKLI45QYae4oofPN4ixxwx9YaSeMwWDk2TjPy26dcFCY7SgnGHNiJi3Ubqj4tI+W9Bbl4P+2x6oMd3rlr8E7UJSITO0vg/c3lZ8MaNyUdmZ1vKGjzHVykbz44EDNZxorOXcB09/213IuBuLIz/nFPSprisRWEKU+jYqMHsr4eZYwqGYbhCamJaHdfGVmdwmxXYmz+aXovtRIhYgkjr/rlk/5NrLHiQFfD4IsPTbPu5cPzYBzFdI6gMGWwySeKGn4Q==
Received: from BN0PR02CA0009.namprd02.prod.outlook.com (2603:10b6:408:e4::14)
 by BY5PR12MB3826.namprd12.prod.outlook.com (2603:10b6:a03:1a1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 20:45:45 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::ea) by BN0PR02CA0009.outlook.office365.com
 (2603:10b6:408:e4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Mon, 4 Jul 2022 20:45:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Mon, 4 Jul 2022 20:45:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 4 Jul
 2022 20:45:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 4 Jul 2022
 13:45:43 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 4 Jul
 2022 13:45:40 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@nvidia.com>
CC:     <jianbol@nvidia.com>, <idosch@nvidia.com>,
        <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 2/2] net/mlx5e: Fix matchall police parameters validation
Date:   Mon, 4 Jul 2022 22:44:05 +0200
Message-ID: <20220704204405.2563457-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704204405.2563457-1-vladbu@nvidia.com>
References: <20220704204405.2563457-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ce92f47-9332-46b1-e20c-08da5dfe2ad0
X-MS-TrafficTypeDiagnostic: BY5PR12MB3826:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yMS1rzApU3a10QEZoxaSMYcjoyOInOQkWha2uClIUUJGb0tiEmf2WXxwzNGXMMno6XL/yCZqOAyVVC0MC1r/WM+K+vUj4qCPh/IEgy+Z4f+bDSE5iBaPCCQ4qPgeH6pDJbOGG1Ay4rxB3L8wew99Np8yNKm4qseDJd05zAyqmtTA/XiYtWSzTuE0Pg5uhIgWrhtBgQzE1NUPdBbdCcYtR/V327HCaPkzSukSuSAz/zv1fsT6n+dEQbY1adI+0Q4tIGIOyy4Oj9ELWPo6VcEiVoOjwu4jGm1mClGq9GR7izc5L1PUkeCM8qExmdtnXsk4czwaC2+g6SMncuJ0mlMNDdUzVrd+AXloe7ez9mwjgdvW2uDe0O37GlgqPYIA2JNX5DBcmT1xrwBdGbJviLOhH4ELhADNgOk2P5Ykq/PsK17YoHy8S0iLyWwsg3tppXJHGZ9a4y/4Jlfll7vExycp/SQ4pcLUOiWL88HkowSLb84ahgqqFjcTIF4CzCZT7wBdX8t9ZfCP4GjBaMUQgLgiq9lByVF6A0aocjbMGmm4fE2pZt9BrY2hRlX93oVEMyxnqlctLLQkOP1wcMm0zr62XPOuwOTY+hH00GJIIZit7jXK3ZSMk/xKDulUCXCj19mt2n4ydBTdGKPprXBErUWWw2lrpRQeW8nK0S8ogdzJIV6nvVc9XkDHHpPCeeUFJNmMyf5TlmmPQG/JOioxSLvUmcz1HdlSMFkL/iZ1aVuSRS3Zwr8R2d/CMsGPS6mGTMxfteM6oh21PRsBY/2lB2c3LBjmSPa/HvdgOOqfuBiziu3EW8nJHWbGPeUYZqiXFn1ziGsN7Yv9z2Si7duVWjxPonQ9HqbTx7ZRVWYL5PNCERg=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(46966006)(40470700004)(36840700001)(70206006)(6666004)(41300700001)(8936002)(316002)(478600001)(6636002)(8676002)(4326008)(70586007)(82310400005)(40480700001)(110136005)(356005)(36860700001)(54906003)(83380400001)(47076005)(86362001)(426003)(81166007)(82740400003)(186003)(1076003)(26005)(7696005)(336012)(107886003)(2616005)(5660300002)(36756003)(2906002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 20:45:44.6036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce92f47-9332-46b1-e20c-08da5dfe2ad0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3826
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Referenced commit prepared the code for upcoming extension that allows mlx5
to offload police action attached to flower classifier. However, with
regard to existing matchall classifier offload validation should be
reversed as FLOW_ACTION_CONTINUE is the only supported notexceed police
action type. Fix the problem by allowing FLOW_ACTION_CONTINUE for police
action and extend scan_tc_matchall_fdb_actions() to only allow such actions
with matchall classifier.

Fixes: d97b4b105ce7 ("flow_offload: reject offload for all drivers with invalid police parameters")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 34bf11cdf90f..3a39a50146dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4529,13 +4529,6 @@ static int mlx5e_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
-	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Offload not supported when conform action is not pipe or ok");
-		return -EOPNOTSUPP;
-	}
-
 	if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
 	    !flow_action_is_last_entry(action, act)) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -4586,6 +4579,12 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Offload not supported when conform action is not continue");
+				return -EOPNOTSUPP;
+			}
+
 			err = mlx5e_policer_validate(flow_action, act, extack);
 			if (err)
 				return err;
-- 
2.36.1

