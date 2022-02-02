Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 694DE4A6AEA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244381AbiBBEbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:31:40 -0500
Received: from mail-mw2nam10on2055.outbound.protection.outlook.com ([40.107.94.55]:54112
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244210AbiBBEbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 23:31:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxRLdfffAICtRCn3RQqm83fpLshhcpmDbJy+mE0RBjVMhm1BHcug9teDooj6HwMg+KdJv6Ahcq1dRracX19JFdk51c9ib8rzZEj2yaFGonmUEWnl65gPcJQ+zJV97fu1ur8nuOkovZlus68Dn2Eh57NL+0sGafUgTGZh37ISIQNSHbiJfk/pbOemgM3dd/YP9c659h/mF+Q4pTi79titWpyccVxWNoBrrQGghY70z+saor+7mZoWdG7JGAERivzuB+JyeHB4G7oQhVgCOSnJz7cvSKLVb1uXDlVwrCfbJAzeTiDTt00B7rHJYfhkJMvoMx4SkeHMx9YLgt2GsGJO5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ctywqRygsg/QFE5JRHyWy+lAxl/8mgy0QwnVazXDeic=;
 b=d416RaDJAvKY1mHAwumTgmINayQ6uJs5KJ+v3SgYZUEz1kszRSepLXvf/sSSZRRj9se0fEri4hv1iTOAUg5temCeevm6BdG7AyaGrIHH7HaDr+b8TW09JbnrajpJsvnTOCtadcRCIj4+9qtSIib+8Mbvea+UJrR0DXi7Ztq6JHrrq6LZZTfVCe2L+bE/Kii7kebnGHat0T2/UbHZ7tfQAqisobNNm8mAMl2Hj0HrwCKkl18YfsLSjyynzsajRmfntSyiipcwAIPXuu2zfcRZ1oe4aq6yuom9tkH7Su0j5be4MSUylhSXF9yt65/cWgrc/qIRPRS6T04yMcAAi1lQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctywqRygsg/QFE5JRHyWy+lAxl/8mgy0QwnVazXDeic=;
 b=E6RnZ4KcGCfI+SQJQ4DQUzCINSELSN3hDVFFxGrTwpoj7iRnVaSmiReFFoY2H1UPQSR/5ZLXSbHU8SvcWE3EnoF4IqKee7aYvjPljf6r/xQPCc9WtFSRzW81ssQLBeligv4bwtzhxgCumSAyFattf8kqGh8U0haXTLbn/9YvCHVuRrE90nSvrFgP8sMlvEgFx/OT3v1DwwKRTjBpTzr+u3xmDeH+VpivtHATJiYTmFWfym57BJ1nQbnac3ntyeMqFOj6ZTt5sF+fCWjx8b1XYt50En7nkFwVT9D70VlDjI4cbbRQsLp+QWUbkHFkHujTD7f+RmUmOgk3DBO+ikOBdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM5PR12MB1370.namprd12.prod.outlook.com (2603:10b6:3:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Wed, 2 Feb
 2022 04:31:37 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 04:31:37 +0000
Date:   Tue, 1 Feb 2022 20:31:34 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     Colin Ian King <colin.i.king@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net/mlx5e: Fix spelling mistake "supoported" ->
 "supported"
Message-ID: <20220202043134.535ks3poq4lnfmyd@sx1>
References: <20220131084317.8058-1-colin.i.king@gmail.com>
 <2df0d488-36c9-1f2b-8d27-7ada36ad3f4f@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2df0d488-36c9-1f2b-8d27-7ada36ad3f4f@nvidia.com>
X-ClientProxiedBy: BY3PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::13) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d3465b6-9f88-4b85-0db8-08d9e604e69a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1370:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB13708C66E52C396FD1255296B3279@DM5PR12MB1370.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:820;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrJdQa/YWJtVgaw4+JVY6NYpLJkcU/quLhTdHF7G+OI27KmLzRMd4PyGXeNYUyg2UHHy5ufR7d346DnV1+3dsZrvo0LaSxGwEcJIFgQTjYfOuVRgHohsfLRaxyBk57zNwDXV0noqXY3W1DEloAr+fLU74HI1yPuwmRMNOTNufVWEBJvJSm5V5IwbRMN6Bb8Ec30Nurdfgu6asIwgsb2fYlAYOHK08KLqIuOdLgns23C8iEO/lDKCdTFBXmOxMrqdGR45nyybk5fn7uOnkb9Kr4OAUlO1uHS3q/5ZSwW0TRSWu4cbsv7Cqmk4Zhm6ADTblICoaw4XoZnx83ggNSuiS+UVoj8yGzRMmf/9k4SyCkYhEaaOeEqtfd7jMEveTg9rRECKOGQMWX2X3SO24li/eVlFjrU4pddtxCwSymHFF9nsMxGmH7USXDIJwzzUV6/N/N9iWobGzR5O9RwNQWx9j7EJ0YMXUMRAEknAMXrR1+8RV7LRicO0YFnNS1Q1Si287UnNhMENcymgqlxmUCAXwD27b1wZcJBJEX7ZCKdnXq2aW6YpAnB5EAHe7fX3p6JNZvL9foEVNnSFkiyyUrsh+1NVvAtOMvimTwLC75ZEGX8HAAf14H6pmFxTG6ofzk414kvuKbNVwdEfX6mzViaw58N4bOlgJWKCTuhy1q9MdN6MlQyu2eBIrxaY2FKTtnAMYvfBfWftDIs6qdELW5f/Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(316002)(5660300002)(6486002)(6636002)(54906003)(9686003)(33716001)(2906002)(38100700002)(8676002)(6512007)(8936002)(186003)(38350700002)(66946007)(6666004)(26005)(1076003)(66476007)(6506007)(52116002)(508600001)(83380400001)(66556008)(4326008)(86362001)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a9kjRYyJFWUAFgvLdT4TUHstbJ/ZPPKwSuk9oJzIMzo9YwJ0RzhloaHwW94I?=
 =?us-ascii?Q?iWDVywirSxXbKWhZh3LXnN97JSvsqPs8H6AdZ60hyko4paGn7oDLP8BIjADv?=
 =?us-ascii?Q?nVdf31oMe0NCk+VLwGfAu4yePcVGKFlfHmTeE/NT4uW8d8SXdeeasM8sAa/G?=
 =?us-ascii?Q?Pg6O+bOGr0paeZBwUMGxLMtlLIfLLiWQ/bz59GWEtU/C9eiHtMIPgSjFuIeg?=
 =?us-ascii?Q?XygqQ7UnDM9Qpy900Jjk0TXWhe5St3acYJi+iDOEt+eNN1fC61wGWtqgdvH+?=
 =?us-ascii?Q?ipqQmHsytNxWnQAoJPUNunRQHl/0xAvNbXfVA+DIGB6p4IBcyZ6lEkEo8mXZ?=
 =?us-ascii?Q?+IGmYOmNyLBwdXwIJ4t7/WArEwhYFT9Gt129d/d47+3oBZzNPCnl49QtiTE7?=
 =?us-ascii?Q?SfrqyTSMhScjZD1J1mTBuas/i3+kotwsRlwQF/1Ubbamk6aCAy6uo224BdLP?=
 =?us-ascii?Q?bEtBf2uMvsTPAHuNL7JZ4M08J5CPSv0rAnfeKzZn2bjMIFZpvFX6t8mpeDJq?=
 =?us-ascii?Q?96PpdYuV5bH+Nu4p3dT7B9zOLNZQcvEko+R5S67QraOckvAEU0g3bLnoElJD?=
 =?us-ascii?Q?tWvREhjXnQ4lWMGDcbdLPMYMwQbyNtjIFN4uSIK5jvIqGOeewZYR07aYhmaw?=
 =?us-ascii?Q?+jdZ6JI4ZblW4/9KX7e+DOvV24GMFtUwuh4nBYQMODvRxmVZTFfLRay/lo15?=
 =?us-ascii?Q?b0SOxYMxRMF9Cp7my/3J62lwcLNEDZYbz35oge+zMtlWwTNYngK8RwkRnZST?=
 =?us-ascii?Q?6sgCNi5CnQ1oD0ZSguQBvIjDNInS66y40xmJKMTwhNdD9KokS8tlGYLpXTI5?=
 =?us-ascii?Q?5rb5PSyZoabPa44jCIu+UPGRd5QPQiUlNUa5vkw4Pfux3CsNw0/phhztuzYC?=
 =?us-ascii?Q?ijWqV0UOWO9qU+t96FHs7qWxyMqHyK+WYS8nJoCV3lZfQIM1JQJk98IHJbyk?=
 =?us-ascii?Q?Z21eflnVAF/8vixHQUyTD8/Kv/4qRodut/C2gcREmZIWdQC3oPS4cy4j1Xqf?=
 =?us-ascii?Q?M2zWY398XK7fqjqviR5hcoa3v6f+7cM03U1TjhRx4p4y8VrbSrbVYcxWN+8t?=
 =?us-ascii?Q?oSoopjZ3Nb9heKEa6TZUOtQ9qYn2qCN0NBUW/KItrwa+odAqr3UDXA5Hr8gg?=
 =?us-ascii?Q?MqCiEU+XZCbKHyeLEv9GD6D1DWjiAE3R116h7XxorlXrItodb28uQwII+bCd?=
 =?us-ascii?Q?Q1Bi3kUgB4qTXethV+qFIPW7J5NpKzdakv2yRezsEJWSv97I4s4ir4t5hHZ9?=
 =?us-ascii?Q?3W4W7OFjy/z1fN53ei3LbjBja/y+doouvesIprCT6CRDZVximQeDhANVbOgG?=
 =?us-ascii?Q?3BOvcmCrYVrHyZdOqsjLe7v2gJYAxdMTfLqcHmwe3ZsdZk1lIY7ycLMn8hm3?=
 =?us-ascii?Q?D1OsbqWTD8iHZp1B7gn8GNBatrWe4yKzAKiDVzDaQKZRmFoVATazZQQd8IV/?=
 =?us-ascii?Q?ui6XrBnAW4mtud3na28ZV7x1kOYbeXO87+6ctKUO8I86nzINZZHe0ukfdHit?=
 =?us-ascii?Q?G6ncbc39MbWxS1ztCu3XKfsA/ksI9aFrZjoSiKD6mbpXcbeNc9iVp5nz6SbQ?=
 =?us-ascii?Q?rNFDZN1+D8DcKHYQA5DsoCEPKmEAg6b7Oh9v0UdBRClBrs7+g0Jiko8b9Fsy?=
 =?us-ascii?Q?IITYJC5YlVt9LJ/2JGzDeek=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3465b6-9f88-4b85-0db8-08d9e604e69a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 04:31:37.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zfl4+I0p8qfS0ZjY9PamTgDylSeAduL7EzXL52D0AYX1iLIJPK2tAexLwgkJIJUu9lGIlOcPe+LOyWsPqqekw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1370
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Feb 09:43, Roi Dayan wrote:
>
>
>On 2022-01-31 10:43 AM, Colin Ian King wrote:
>>There is a spelling mistake in a NL_SET_ERR_MSG_MOD error
>>message.  Fix it.
>>
>>Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>>---
>>  drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
>>index 85f0cb88127f..9fb1a9a8bc02 100644
>>--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
>>+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
>>@@ -21,7 +21,7 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
>>  	}
>>  	if (parse_state->ct && !clear_action) {
>>-		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supoported");
>>+		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
>>  		return false;
>>  	}
>
>thanks
>you can add a fixes line if needed
>
>Fixes: fd7ab32d19b6 ("net/mlx5e: TC, Reject rules with multiple CT actions")
>

wrong hash,

this is the correct one:
Fixes: 3b49a7edec1d ("net/mlx5e: TC, Reject rules with multiple CT actions")


>
>Reviewed-by: Roi Dayan <roid@nvidia.com>

Applied to net-next-mlx5

