Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8262306D1
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgG1Jp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:45:29 -0400
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:23103
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728571AbgG1Jp1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:45:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhoLiC6y7M/45LqLiK0OTOaDaacxlOnWhQxLmoay4sE1LTBJaP4f2q8+HwctKDfToyDzzVF3wbXn4XyjYzFP6BkRCJY1waPVAOX041ouuH5dajetEVPrjm4Hv6Hb0WmwHb9J4HuXdQe6YIzsB1Zm37Cb7PQhvMkpHGveTclCLYlCBitsKMzySIHB/zdoSa70wDCVi5Aw7zbFQjA6RngCt/rpfGq0lKhxHo+udG3EvbCT8nZu95xKL7DTTAMdKZNhKk4KxJdYr8GGJxwN5RloeR4u1C44syWCeguO6gJwkuapmikcy5MzjnLvgagOHdMd2vKZM3jCUL2sUh3Yc1MHrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oINQjGNiYXdueHdS7BuYvLo6C67s5CSosdmE1qRMG5c=;
 b=cYItnl1JroWIcyyO5EyWRvU9+ydCsdzEbKJDy9fwog+smPKQWTOfdgB6xTESnZxAhhKb6AAcDtY+vY48OGmtT8f9+rAJlAN6XWyr+lRDOrBrnqG60aX7BgJYMzfJjAZC6z15S9zL8EDXC3pDNlpob0+Iy3DuhcIX3U5YF4P9LXyV/SZ7xiEPMIy84bRJP4P7dJwAn690FCElu2r9HoQ/uswTp2OAC3/tpCsN0wTVh5tGIJm9N3HIIkdkkwHqKoK0WbVFTmzmQMjX70eNVj6oR5ur7KGww3x8ebXl/zK6LEfqS6unt3AIDIDSVBrv5S/1hGfJYQM/Dxj9MxaoY4Dglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oINQjGNiYXdueHdS7BuYvLo6C67s5CSosdmE1qRMG5c=;
 b=GGBEOd+V5g43XCQZY6uEdBGvcKmeMnpDcb35tb3Ku6xtqeEpJqcoYlsNupopeKsH7A4dDjceQn28R/FZK1458+CQa7dnV/JTsl9dw1DfSBRikGkvk1a8/AmphPPCxg1kFDegnIYO9tTyHUT+iQ8JVZzHdvCFTmaHXGe1ED83Ak8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:45:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:45:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/13] net/mlx5: drop unnecessary list_empty
Date:   Tue, 28 Jul 2020 02:44:11 -0700
Message-Id: <20200728094411.116386-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728094411.116386-1-saeedm@mellanox.com>
References: <20200728094411.116386-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:45:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 56d620d5-605c-4403-7938-08d832dae768
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB71179C3FA8AC88E7D4245FFEBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jdkfRwiASfOannQUAxJByxJhtVh6tzOJGPPDORCQJ3bAATWeNqpSrjkmyN8MsoaT+xU110Y+5XUKnbUU5QZh+1UJwznylxEL0I4Tgva5Ked+pAdZFRMyfk0KfMikchffZ3q79bdeZDFwJObHb1LQj07Kd58YfgLNmMd+rhBkDiA0wOWWfWAOFuY+mIU9ySuNUO8sgPyNLlMSiw17Hk9OqnOY/H8m7iU6V0zrsruzcbPlom6pf5GC1nyZvdPKLbsQasfqjlisKLMSFBS/iChCKujT2FRhB4dCBiz0eO1k6gGdDf9iRmYr6f4YNdyYmm+U9FfZeaBEQnndu8BFYZJfAp815G3MRFYYhzfiaivUAgXJY1NWI/rS2J/TNi4MtlsStJsxTnaJZ6WOcZRKDO59nq6AjDT6CCWgtIK96oTys2SuH5GukGPsUxJPYO6bhZj3T6BFFTgeL1wmscRr7ZRLnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(110136005)(54906003)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: o58aitkpoTrtHd6DRrAFi9geki55VwyPJUDH32/Kc/svKaBKEF+Snb7O827PZ5NuJYuR/H93yAtUeP12YggI5WdrsG9w8DEqbXq2JlKxvk/nJJ3aFRpYU/OpfmYJhIvGUPZJ9Ozg1DAo8UivuU2OPNNCRqI8crsWLXfGRW+DvbrXqvIIdQeH9zdAoWjiBVtNBI2Htu5lwcDStzlVLb+37OUkuwoxiExlaq7VAT3eWdgzRyzhyrwMS5ulc/JiFeJPcD2A2HtO2tnXFqz/JDo4HcKELAR/kJLIOdixEX2q4wkKWYKVQsPD2Mu1WvopocsyCBiHoxnC5AnSXhcVI9h1jx3BMF1ysJIAkXI3jHtok2WPR0ZcDpZa3CaXBtgo2vf82wbjl7lO9TsPv7VgDq7KptH1dkZOREj63b3M9KmoknoVLTwOFy0VRxNk1nYizzmcGfhQ7RbPdfnWcXRnvHM0DB/95z3vLEk0ftaDviCfMqc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d620d5-605c-4403-7938-08d832dae768
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:45:04.6105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehU+A1kqYgKpSgTrxRL7OFTidVbnBxOzMMlbvT1O9fE8Fn/xOSk4CYiGkRmeb3n4ffX/AUy6XooQ0tFQJostbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julia Lawall <Julia.Lawall@inria.fr>

list_for_each_entry is able to handle an empty list.
The only effect of avoiding the loop is not initializing the
index variable.
Drop list_empty tests in cases where these variables are not
used.

Note that list_for_each_entry is defined in terms of list_first_entry,
which indicates that it should not be used on an empty list.  But in
list_for_each_entry, the element obtained by list_first_entry is not
really accessed, only the address of its list_head field is compared
to the address of the list head, so the list_first_entry is safe.

The semantic patch that makes this change is as follows (with another
variant for the no brace case): (http://coccinelle.lip6.fr/)

<smpl>
@@
expression x,e;
iterator name list_for_each_entry;
statement S;
identifier i;
@@

-if (!(list_empty(x))) {
   list_for_each_entry(i,x,...) S
- }
 ... when != i
? i = e
</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c        | 13 ++++++-------
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c  |  5 ++---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 6960aedd33cb8..c63f727273d8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -474,14 +474,13 @@ static int dr_matcher_add_to_tbl(struct mlx5dr_matcher *matcher)
 	int ret;
 
 	next_matcher = NULL;
-	if (!list_empty(&tbl->matcher_list))
-		list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
-			if (tmp_matcher->prio >= matcher->prio) {
-				next_matcher = tmp_matcher;
-				break;
-			}
-			first = false;
+	list_for_each_entry(tmp_matcher, &tbl->matcher_list, matcher_list) {
+		if (tmp_matcher->prio >= matcher->prio) {
+			next_matcher = tmp_matcher;
+			break;
 		}
+		first = false;
+	}
 
 	prev_matcher = NULL;
 	if (next_matcher && !first)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index cd708dcc2e3a3..6ec5106bc4724 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -574,9 +574,8 @@ void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *ste,
 {
 	struct mlx5dr_rule_member *rule_mem;
 
-	if (!list_empty(&ste->rule_list))
-		list_for_each_entry(rule_mem, &ste->rule_list, use_ste_list)
-			rule_mem->ste = new_ste;
+	list_for_each_entry(rule_mem, &ste->rule_list, use_ste_list)
+		rule_mem->ste = new_ste;
 }
 
 static void dr_rule_clean_rule_members(struct mlx5dr_rule *rule,
-- 
2.26.2

