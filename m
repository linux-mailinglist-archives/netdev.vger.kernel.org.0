Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1984A57FC
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiBAHn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:43:29 -0500
Received: from mail-bn8nam08on2086.outbound.protection.outlook.com ([40.107.100.86]:56256
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229975AbiBAHn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 02:43:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVWaAmy2V6AT5xtqfBinlyT9oeU12yKzVrBfLlkH4YmHkxKdxkD1FOW6f13CpVkGb606alo6WX5I7C6jiEOqOIY6sWZ/sM9A14WLzb5MMd74qH//vxNolm8q+1XxIfAxjz6cXrhLgPce6qvSukcHbiIiPyoa94GNhhmUvHDP4slLyzmg5tn2aZMhlVg6DitAS4G+AjESr/cnTGbR55o4FL7twP05oF5OcNzxM4ZL+vP4ubQLmJLOkkxiT+EJaEYSEKHCWkNrRRRvHCew/B9mNAvDLgT13rB9qZmNBsk2O9OOcAmUBSLccNyR97g9rzwrk4THBKxpVRDcSr5y4H+8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv0ejKix+fJ1Fj1w1ac5Tje2ICV5sqz04oR5H6gTyAo=;
 b=hdNX5+sW8/MiScxoIqancYwtUIo8OID0z4sDIu917c7jamZUWUkAz0Ox0YlYQKNjT5ggpJ23MJTLaFrYInE1xeMgV82UvPJ/FYzjEFaUf5SuyNEPNQaAh4xaDrL48bfSqGwQRpN2SIL9NijJHh7/DzpU9Hz91D7BWOkk11CJmHkWF8uJfH37ybFN7iUezECDBRBJFgL2LQJYIBj3Pa3SQXK4bqzIVps9x9Qjp21DZFzjlid5WdGnNUKYWUIAGQkBZNqs11MV8U/wyxteGhbeILx0SH2Gldd4ePdAt4bRf2N3HIkddo/FnkrbZAC3KyTK/3MPC2c51IEhouNvhDbPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lv0ejKix+fJ1Fj1w1ac5Tje2ICV5sqz04oR5H6gTyAo=;
 b=QZ3FTJkN7wN24SmCNU8J2MWiwdVRY+EGZRSVDYCfQ3MKxfEUgvvBfRBYWrJLn0/mmW0a1KZACJtY6piAyW8ZLySJg0NuoEp6gjYzF6H0sftCnp8pJItvMg74jbYZZ1N5GWQhOWpeNVArkTJLWPyg9WKS4AgdHQ5W9uL8QOqkeVKH7kKr/nOHFTtAjv3Y0yGaSQwU/ixQ95RS/NuKSzAWPUHCj2nXEIkc6JA7z15eAbTg7WxgOKLcKkQ+LDNdZirl+v1GOETCL+SK5N5sqve+y2LA27y1+k7iGy1frylKIblcXNjkIH55EGwPetnY2TFONyR5MHC03Fm4vZHlhPW5OQ==
Received: from BN8PR12CA0023.namprd12.prod.outlook.com (2603:10b6:408:60::36)
 by DM6PR12MB4545.namprd12.prod.outlook.com (2603:10b6:5:2a3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Tue, 1 Feb
 2022 07:43:26 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::18) by BN8PR12CA0023.outlook.office365.com
 (2603:10b6:408:60::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15 via Frontend
 Transport; Tue, 1 Feb 2022 07:43:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4930.15 via Frontend Transport; Tue, 1 Feb 2022 07:43:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Feb
 2022 07:43:24 +0000
Received: from [172.27.15.136] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 31 Jan 2022
 23:43:20 -0800
Message-ID: <2df0d488-36c9-1f2b-8d27-7ada36ad3f4f@nvidia.com>
Date:   Tue, 1 Feb 2022 09:43:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101
 Thunderbird/97.0
Subject: Re: [PATCH][next] net/mlx5e: Fix spelling mistake "supoported" ->
 "supported"
Content-Language: en-US
To:     Colin Ian King <colin.i.king@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220131084317.8058-1-colin.i.king@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220131084317.8058-1-colin.i.king@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7f1c571-3724-49ff-bc38-08d9e55687c8
X-MS-TrafficTypeDiagnostic: DM6PR12MB4545:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB45452A2EF5BC8DC66EECCE0CB8269@DM6PR12MB4545.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yXzpOnpmJzRS4vdH+kbzEbmRBFtQNUUvCJOVe0555yzOQrybp+owWFWIKePnwv/xtsZ5HCicHjUI7YrVyQ+vgVokWXaaGNwY4RRjTYqTUfnGlhgJybcvAvCF8v9k7fSSnpQTjwDeC/cuQoNlLIoqayQiwqvF6ZzyHLSSKRWcGvKDfFMv2hL68sv6MEQkWtFLaoN9f26Ty2taENyJ7I08/qjnCHWoeT/iXablnd5HYAuOrwPW9MJIpAdMR279aSTTcT1jD20/RsH/MyS8AXmq3Txl2jKfaJGMmygu1/DyQVqduCbJqhdfMOm/jm8aiaIEPip62THN0WyWe+GcN9FUfuoiB2lCN72zvu21j0bj6QVneYo6cEDDx652nxwLXVNRlvkH56uTq2zI8Iz3g4HPGeqd8ngnpOmwT1MkXYJNUQEDQVGRwgkDR7+IQ+fQs9dLSXV6M0v6ADL8QHTItU6m59I5eklLvJe1ACm7GBiDjPGatGY0dL/wVcqJ/0tzMgotlc6GosR181IZCxpf9ycg4ongBXABNczpX/N5pqPcIZ51t2phciBpJGRtdwrViiTiOT711WEgPwMP1TAf7BsHFA8XVnmh/f7ORznjxApTEQTwUB6/OKi7iV502UMMobJQCzhi+9lwpSJQ4nLMeDkDZg5gI08piE2eZRWlGYgkswge60Y4MoAkWC8sNMUHLUIr/+jqKDBkHaJzowyggg+fhw8mc7OdHYSgp29ql4C3dusBN+fcu2LghM0147Fc70cD
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(54906003)(70206006)(70586007)(16526019)(508600001)(336012)(40460700003)(5660300002)(426003)(31686004)(2616005)(316002)(186003)(16576012)(53546011)(110136005)(36756003)(26005)(47076005)(82310400004)(86362001)(8936002)(4326008)(2906002)(8676002)(36860700001)(83380400001)(31696002)(356005)(81166007)(36900700001)(43740500002)(20210929001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 07:43:25.6101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f1c571-3724-49ff-bc38-08d9e55687c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4545
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-01-31 10:43 AM, Colin Ian King wrote:
> There is a spelling mistake in a NL_SET_ERR_MSG_MOD error
> message.  Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
> index 85f0cb88127f..9fb1a9a8bc02 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
> @@ -21,7 +21,7 @@ tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
>   	}
>   
>   	if (parse_state->ct && !clear_action) {
> -		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supoported");
> +		NL_SET_ERR_MSG_MOD(extack, "Multiple CT actions are not supported");
>   		return false;
>   	}
>   

thanks
you can add a fixes line if needed

Fixes: fd7ab32d19b6 ("net/mlx5e: TC, Reject rules with multiple CT actions")


Reviewed-by: Roi Dayan <roid@nvidia.com>
