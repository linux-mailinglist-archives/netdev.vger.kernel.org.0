Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9FD4C4471
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235449AbiBYMTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiBYMTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:19:24 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2065.outbound.protection.outlook.com [40.107.96.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADDB22BEB7;
        Fri, 25 Feb 2022 04:18:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N45WshOtmd+mAnHvqX0belFUTFZnV32A51GU6ASUs/8HJJYs3Cah1LAb+iJmLzPBnCm/UKOsVwgMtyyTwFIf621DGjmjpBji+aiW7JXgxUdhp8wEXU5wkPHhkTTz/IPOwNArBDUhQ6nKnDgVeqJ3yiYjGV3L0tiPjxFbBTCPljtnRdi443k/g7MY4x5BW1X+5dmPqoZ9G0kT4vhFWRhYKEb7aCZDozVlbwpy3vSd2aZHYRiFgeWXEs7cuuYtMiIflcFi1rckj/NfBaKbKpTXJGYPaoqJbRmENybfrOdDlqUgeS3LmZVlVHwl3R2KQ0GTJ9Sq6ClJQdVq3e2pQ0tSLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlSevdM/LsN81vu5oau9/ZCQWaPp9PhmZjKTbRRIC2I=;
 b=bjTO9y0pFyAKLyIwjxhhwQztkepp6gnmuqk0f2mhLWpmXyLo5ThUsn7YiOG9mM3Ay/uDkAjRGrWzQfzzCq1uhvYR1ZwT0Eq2SxM0GqvdbfGIlImIRNjC0kXHjNzwuE88LzdGkE4VcZyEtoSmPDiExsqzfOl8jnfzXCaDAAS8GeJJZtHf082lyqNFGmK00ONuFsLCpY5Uo2fYH0v3bko7KgMl069llg6nBjQb72Gh74bdx45J6ZgcYx8XKj6cv1/7OnXqS18gE+ckWv2YwmyY/adww4oOs7ZXCL7fL6n6zfIXZED6+IRtE3K6OSwJjB0SxvN+GKUV26aqeb7jav+wGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlSevdM/LsN81vu5oau9/ZCQWaPp9PhmZjKTbRRIC2I=;
 b=pSLdU+Umv+80kyhBlsOLcBEqWAjN4JnBjhf6zarBTWjt+Jc3dh3QP8pOKJQIquxzQZ8Zpz4i+Npmc2h607QOrFiYrLEiQEQAnKbsU7L7INvch3/LfTxiVTXixNSXcT8wfXoIy+MKz7BUy+IDryRt7fhQkBolDXJVwZaYldHL7ETbven7+H8tX3SuR7pFz8eq0+1zJYxcotpjpcrU+qp9dk9vaAMW8BntRnqvNoDZC43hAOt7nDNB+aNB/j01IZ51N5dmb4SIwhb3qZPAjdYbU6/nFD/jYEcyM6szvPo4RLfAo+vS/8nMk+lrknE0gwbL75ZRuLdE8F1XlHzTjQ+GRw==
Received: from BN9PR03CA0882.namprd03.prod.outlook.com (2603:10b6:408:13c::17)
 by PH0PR12MB5401.namprd12.prod.outlook.com (2603:10b6:510:d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 12:18:51 +0000
Received: from BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::4a) by BN9PR03CA0882.outlook.office365.com
 (2603:10b6:408:13c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Fri, 25 Feb 2022 12:18:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT015.mail.protection.outlook.com (10.13.176.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Fri, 25 Feb 2022 12:18:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 12:18:49 +0000
Received: from [172.27.0.43] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 04:18:46 -0800
Message-ID: <5024bc30-d872-3861-a6fd-0a7dba5fbf3e@nvidia.com>
Date:   Fri, 25 Feb 2022 14:18:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [PATCH] net/mlx5e: TC, Fix use after free in
 mlx5e_clone_flow_attr_for_post_act()
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20220224145325.GA6793@kili>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220224145325.GA6793@kili>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 249da689-b2a3-4f55-efe1-08d9f858fb96
X-MS-TrafficTypeDiagnostic: PH0PR12MB5401:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54011DD6E0B81EB0864EAE6DB83E9@PH0PR12MB5401.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: silqCJxsvdF+LTfhE2awqetDtr5PqPSbf94yESYNKAuUVyXR2Z8dgBtMpgLIbC+gi+3bWSJTMvhAsC0CSe8zatOn79QkagsTompT95qTqKv5oeV7JST5435Ev8WTCXhRRf/IhdiuwtwB+0ERG059yDTiVPr1qB97jYMoJ/N9/RrTeMasf8/iKmpIrptvXEbufppGxolLAl5q0D3paXC/AkkhREUz+E1sGAI4zG4c/FI5dFhAEbOb+ut5Qtg8Mw3bEM5gbzZ94owBEtaTkTRU5bCayEdMD2k8FWrBjh3oTyLgbZ3Tl06pcVzO57nTshmsOacmnZQvv1aWm7VpVdMFGNh81J0UZuzUNKHglwJQAPxlBFvvDgQgGwuWigSe8LJkLCl3dTDFhMCUGaqmlY7q402+HibnKAW+o1mgK+bDmwpbvWOvvHQ4cwfv2o5LgWR4haLrPVC/2EbtxulYGazgQ1OSN+OOoC//W1EQZMIpHp7XGxL+Mq0W+qbbRQJGpmB6c5v3G4ZETE3rOzoNnDda2/LhLOpc5jjgZgCqdJNSoPLeiXs0k9NbTbEoCd16S4NoB2FNL5QsOh/qzOBNTDAyU6jmKC7H1yTvswEgFEWoDtOfzcE0JFYtrGjMK6Y5aBSFiQU4bSf0grUnt39+GH7v7mEMjznlO99tfITM2AGaVs3zTb5qMeikst+0i0JGdLy43HtfAxhzMjWyHRBG6om6rIn8mX0iJCKZfs2W+3/udkYK8/8yQmBAlD5sfaJ97ngLyxlPGzOMT87OCyVMHur4RiW8ysNzshYAAeGVbOCjS7Xd5+YDavXeMdYDOyrSFRR8l+3vmi0gvqsR3j8pxm6zdQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(70586007)(70206006)(82310400004)(8936002)(508600001)(336012)(426003)(966005)(5660300002)(8676002)(4326008)(83380400001)(186003)(16526019)(26005)(86362001)(31696002)(6636002)(40460700003)(54906003)(2906002)(110136005)(53546011)(47076005)(31686004)(36756003)(316002)(16576012)(36860700001)(2616005)(81166007)(356005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 12:18:50.9544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 249da689-b2a3-4f55-efe1-08d9f858fb96
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5401
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-02-24 4:53 PM, Dan Carpenter wrote:
> This returns freed memory leading to a use after free.  It's supposed to
> return NULL.
> 
> Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This goes through Saeed's tree not the net tree.
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 76a015dfc5fc..c0776a4a3845 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -3398,7 +3398,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
>   	if (!attr2 || !parse_attr) {
>   		kvfree(parse_attr);
>   		kfree(attr2);
> -		return attr2;
> +		return NULL;
>   	}
>   
>   	memcpy(attr2, attr, attr_sz);

hi, I noticed your fix now and already reviewed same fix from Colin

https://patchwork.kernel.org/project/netdevbpf/patch/20220224221525.147744-1-colin.i.king@gmail.com/

so just need to take either one.
thanks

Reviewed-by: Roi Dayan <roid@nvidia.com>
