Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFDF517CB7
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiECErQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbiECErK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AA53E5D2
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHC1w5p2ldwxaq4XZt0tmNkOV+xlXXaAvgPgfIwuvJcsMXm5w9ZUAVgnCodmvMYBI7xXwd9wsfpxVHWe08ERSdayE7tZSIoyPAx6O8VPLureTJg2El0I/lpLprtOfpt5Ig4VpKo3ee19w01U56lCVijsrYJwRTbq7g53x75kH/VlA7tyzey3ipzdPrEW+2OHvIdymnvbbRgfBL8+rKSGm5d+zUhZdrmB2rYx7Wtll9v/Dhib6wcCzd+6rgpr9cS5zy0TInr1CJhLALQQzRKmHqYYK32unwoGFR6T0Sqy09p7DfaEDQVwnldQ6Hkeqy+yU7Z5vRBWLVtw1rPnUWFreg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1hXnfAxQBr0WWZHLEymTrH3cdaMZfqzjClCNk84SB4=;
 b=YexAcujgQ2kxiZUy6UFKmGaCP6HQgW8Kkmdo+JYX66TPjIQ29GsQJrK7OtmihNg1IW6Jameih00P1dcXdbhyjh1Bk2euVbLZXP8iUuEbwbgKwjQDt0GRRZx3y+cjbNlYmixGkyjFSRdkPaFOW5w2MrNDIjBGky00tL6X1tPstLw9jFcuIhGUJDyafPfA5J3WkqDEX3jnceASAk2TdOl8w5v7vlZ1JdNlBx6Xs3QkmP8yjQ8BFum7N6eLps/87noucwIPALSZiQblM3rbFPoyzTnuRRc3gjYYJiT2RvAGdXwHQVo0fr0iQ0trxU7PuP1+MWwXd8t9VcPmsoAEfWV9hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1hXnfAxQBr0WWZHLEymTrH3cdaMZfqzjClCNk84SB4=;
 b=k+IyR4jKlBQnHqj7VV3020nAyYy+4YRDvUJVG+iWshfqE3VGk7f0vPSveNR5xqf9KW0ZLAPIgQPs8MjTcpYbZBB7JB1e4AS9Zo86iQuxbBp3oqCdNUhFudJHkbzKvTteVEnbyRisbangF3B/Ha39nniay3IfDbz+WFVmt5nd9Lmhn790RAVOnogSUvc0lVonz3/2CMDU9jvoAce3sGBF2Kkn6BtQxyBM0eazYR9exqcd4byXjArqUmud3YATTnS+AG6OigOG6sNwjvQ4DOuwzgYE+1ebwCbQM+mQD2YFnhbeqo3T5Pw2/ZP6wLdvp6PJWO2DQyjCwtgGAIjL4rA4MA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:34 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:34 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5: fs, delete the FTE when there are no rules attached to it
Date:   Mon,  2 May 2022 21:42:07 -0700
Message-Id: <20220503044209.622171-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0127.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::12) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 255697e9-f916-46f3-8ac5-08da2cbf7af0
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322000E45670D2B6164589FB3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztC458U+/CHRx+0Dl7vhUgD8lSuEtkNtQYyrOd2aWF9gUY1to4/UiZ+cHYbnxp9XYwhwWSjtajhlTr+lEfzce1W9ynB/vBF8eurMnuRgFc94P01CSOvoF0doDyXktjh/ManaGLUy+7SYNPYWDecGe7RJgwE9MgCP09LDKorRjZmqq58SNTyG6Byrlihr4b+cdCCbxZCU6/gC2WAO+b6mcDLsx/X7RJT6qKHx9OoDYZsHcOAN6zQK/EW8gD5b48B/Rx9Q/0NANMC0WhF538PdskOaAv0ldx1+EDF/VYgSfr/JMCNh2Q6Tq9M0ImFmFVYhBoKNkQ07fXq1ZT4bUUK81BueZO3wIBOTVmVjRYyAlbiHoyEWT019/RNVgPEHF6+HZdKSDyy9UNUsH7IiA1qcUaGGJK7Iir6AzvsQBcKWyMXtTQxSBJnfXHT4Zk98alaYdnGHe0kMGA8mmFA4D6AyeM4yeIvTGDkxvVzzEfEVjMyi23LRthUXp/SeeAr3I/b1oGlWSOUUXZBsxianndk0PVG7su7eNCg0C+rtKaArcqyTm/VqnFdSzd9dgxKaPCBdHqKIx9IpLIJ5r4tyQxvfVFLAx1XuXajGV0WqniVYQdCS6ewgcXEpnGg/KUxXQDFUQ//zYLk3zWlm6TFw6oQI/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8qrx1Zfa2FvDmfAHNexRV2tzVqXllcfUQlr99PqmTSyEhpaJw3V3CHaXdJ9s?=
 =?us-ascii?Q?MU+NQU3eHG8AYVRRI3QqPpDt/dFiQ7d58iJdeOgquNNZwi0obyRVUdKYGIhy?=
 =?us-ascii?Q?fxbWVMQlWUo0BF9q8OLLFiu3w2pCia0UM9gONggvwDmP37/VuIoitvZsBVs0?=
 =?us-ascii?Q?2wuI+kCKAGQSGuAkRoPA/ZJhj5a4/8dWeRGrxE3vLmrHH2g4jFqoLoieaOME?=
 =?us-ascii?Q?r/04Ql+97r1UEJBKyEPH56t4dfWhEgpvK+2WW1EoalG/kZTX5D6ZAjTKjsr8?=
 =?us-ascii?Q?Y+lNxAVorNadZu5Dn1GBVIk7KLIPVaF22A7Kw4nmmxyydvmH5nH8h0xxTdud?=
 =?us-ascii?Q?E+8m9t/u2A9CUuNorHdL19U4lFpceYiFjlNiNZphXWWJuewe8o7fmtWeno03?=
 =?us-ascii?Q?n9OhomvyOFD+IIrpaD4hbxo96lBg7QkkACdKv0nFFzPvuAjeVNwJRnXFVSD0?=
 =?us-ascii?Q?/X3DFENJNVjLBe4w2Cc9pCCAZ2gX3Gb/hPX+TCSL0CtIQSobR3pw4QYdDcAF?=
 =?us-ascii?Q?Go2evayjLEd7+a8svw4NbmBDoLvyq0gF7XrVnGnX3Ysqr8j3JqeCnqeQjOLC?=
 =?us-ascii?Q?zdwD4GUpTixgqYj1Jd+2YJN+VuRBaczeYMfcRNFu4OscPMIhWUM3WtI5Mwd1?=
 =?us-ascii?Q?fkTez9PhXSxPOzy0LhS+44bxlHNGo+9Iygo9y9fplW0zPlWZZy9YSRFO6X8m?=
 =?us-ascii?Q?mXM3u7OD6yFQmgu+hzDBKqeoBy3S+T/G7Hsx2uLPmw13DG57apiooy9riIF8?=
 =?us-ascii?Q?obqFllgBPJQ+1otOvu9x9upkCIl7sjtSOzlexZHry3smjUoI/oducxZwNKTI?=
 =?us-ascii?Q?NnPFWbZC8anAdiQ3nD2wG4R4Mv6jZsNzmbY6eD1pJpMRk1FKlxnYopvJaAWX?=
 =?us-ascii?Q?HIKvo+DBfCXNyJhKT5P1NXPiyKeQ8/PAQVYtVF67f1seDXa/VhsAJDl/3hMx?=
 =?us-ascii?Q?5CbynlxYEEwr6wjxZB7lCvz2md2pX/IhNjwaHny7iNz+Va/kCMj4Froh0lWM?=
 =?us-ascii?Q?0NR6zFfDVrya6py6+FWb/qoqTiVJ+IESk6nF13EfKtczPDgqq1Ad6LygJp4c?=
 =?us-ascii?Q?3IKpjBjlIRdr+bqV9JFINc7S/yPu6Uh4D42pKrKQ/xyZmKo8Wd726VHfPInW?=
 =?us-ascii?Q?XEpfW9ipND3eoYDAXgtKC5jnLKNVTG/kZr3wwdH/IfkoLyCDFaFCRUaKGJfU?=
 =?us-ascii?Q?/Mlq+tDqaJ0n71Jihwawx57LMAtG6+HEeJA+eyrhHxj0kghHeqAu33XMt1Is?=
 =?us-ascii?Q?/2VPmOtT+yltRSr7zRyXbLyyEGLGrp+S/F0QKwEi1QZO7n5clQF35KVpLc2t?=
 =?us-ascii?Q?ItAu1/tBKBFUb3RkJxeSednb4YVA3tLIb0EhczeFgFNmNhWFlNQt3zJmKoC3?=
 =?us-ascii?Q?hKeY3J2cc7Au48GjhVctKl+ipuW7zsSA+fxVCP4djeim39NAN9V42Us6sqXY?=
 =?us-ascii?Q?tpoR1OANd7jyEo8+dmfK9ao1zQT6NNQyf7aTvFfxr4IgjD9flLO6/pJR59md?=
 =?us-ascii?Q?ytHAmcjb5pvTZI3sgGvDVqMOLyIede+9nW2lG/EbpRAfDJR4kRlUTign3dug?=
 =?us-ascii?Q?aHJI6xWGuGVCs/vWpFRHhLWBVtw9cszHZw6nVurAYclW843TF7aONNgaDqqT?=
 =?us-ascii?Q?cfJkNRjQ9oVOUeDvfc6Eo1Dkphlzuwrttzy86ug4rHxlOVSKDZ0j/Em9zMmc?=
 =?us-ascii?Q?2ZPeplv9PtgZqvE/84TL0CqyMjqY6kjUPADxG0DJwMpc1cStJh4MSy69mP75?=
 =?us-ascii?Q?RpqUfs8Y/SPjOelNKpTLWYjtBiKb+oTQtekogruhS6KuUSGG4yoX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 255697e9-f916-46f3-8ac5-08da2cbf7af0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:34.0868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwuWaFL20U40TDheyXV/c8OYaPgyOI1e5WIAJVUlLZ0yNbquuX+K7yg1iv6/GlSRNvX8op+P7q/n0cu5uJQ8wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

When an FTE has no children is means all the rules where removed
and the FTE can be deleted regardless of the dests_size value.
While dests_size should be 0 when there are no children
be extra careful not to leak memory or get firmware syndrome
if the proper bookkeeping of dests_size wasn't done.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index ec91727eee2a..572237f262e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2084,16 +2084,16 @@ void mlx5_del_flow_rules(struct mlx5_flow_handle *handle)
 	down_write_ref_node(&fte->node, false);
 	for (i = handle->num_rules - 1; i >= 0; i--)
 		tree_remove_node(&handle->rule[i]->node, true);
-	if (fte->dests_size) {
-		if (fte->modify_mask)
-			modify_fte(fte);
-		up_write_ref_node(&fte->node, false);
-	} else if (list_empty(&fte->node.children)) {
+	if (list_empty(&fte->node.children)) {
 		del_hw_fte(&fte->node);
 		/* Avoid double call to del_hw_fte */
 		fte->node.del_hw_func = NULL;
 		up_write_ref_node(&fte->node, false);
 		tree_put_node(&fte->node, false);
+	} else if (fte->dests_size) {
+		if (fte->modify_mask)
+			modify_fte(fte);
+		up_write_ref_node(&fte->node, false);
 	} else {
 		up_write_ref_node(&fte->node, false);
 	}
-- 
2.35.1

