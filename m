Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DB8398895
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhFBLvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:51:10 -0400
Received: from mail-bn8nam12on2048.outbound.protection.outlook.com ([40.107.237.48]:31073
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229607AbhFBLvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 07:51:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/9rIl9l5ODfLHs8+JvSBUOdcTBx0wWD0lQPeBOMG9kAChy6gYFYetpLm9GwHNl8yNkUiBr51V4KvWlLZA3iz1GUpAzLyE0ibghqQgynfp3ICREgiMRerRYNjKl6Mm64PNcLbupyMDxWHcEXoEviPDI1dnnFa98O5EFnx3kHazZOWZex9jFprUH/ZQeypkBvqw187NWQO4dtsh87ua8UfaSV3bei35IKN+ck8s5pikq0kQP+pX8EWDVd9T4HgnppHc8fFCDNe6K+L2g/7/9Mdxe3S2jSlg3XXgV9/EXWRhnuCK6CQZSpcnrUgycxVpdlaXlrt3lMhKvdUuRY/jv1qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hERkB6Ll/ET79A15sW4VOUXDTSVVI9qi8K7swqWSvKg=;
 b=S9P2Q8Rv3UpY3lpy9LqpnpPq9K6kpD/BdtsWLXo7Hpv9beZRruPyOk3EbF0mfSa731YvRFZeuODWWY8BL0mJqz5vaM+8d0CTV3GePahMulfeOYQfQ5A7H/24IAuEQmt0peby/reZgD+Xh7xzA0IxlGF2QUfyXeGG30LO9pXignribrzMeFp2OnZ4did29B0Tz86MtgKc/xqASCy4b6GXcHbFu/2tRhiWtmsi0oIvB2/mEXYV53Mila5THpv2NILs9h+CcejobTu2nHXtfdJLiWa5yapPN3EUfIkolKUZmSrp68mRsGaqaKcZxuCNHA4o0lyFNs3KplAtGKk/b3A3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hERkB6Ll/ET79A15sW4VOUXDTSVVI9qi8K7swqWSvKg=;
 b=LBY2tjNWCJ3U/58epTTpsC0jXOTtUA8pnMvSjLbjuFhw4T287DTa9W+H9xfSAq3qpntcZbRx1gPibZv26HUsliWDU65u/QnERJBcE8+0O3snskXgtGcrGtuDIYPS8pCfD3uFuwohsfe2BcQD3kDJ+ETVrZRkmtT3A1fs7Hn5WqoAWCc6SZFNUUSZTsjPFrvp8PuzGM17tEvMYlXWHmRvylGEnkJd1BInCOOcVKMIThKDPU2sYqiVC3m+JN5YGdpAU5mK3ZnIejV1xIaAzwZc7aPDnQ5moewOxPBcH5ysogjSp8X1S/jjZnWyET90AMcGwzAJg+pJhIMqnUA5/a75+g==
Received: from DM3PR08CA0002.namprd08.prod.outlook.com (2603:10b6:0:52::12) by
 PH0PR12MB5433.namprd12.prod.outlook.com (2603:10b6:510:e1::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.21; Wed, 2 Jun 2021 11:49:25 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::32) by DM3PR08CA0002.outlook.office365.com
 (2603:10b6:0:52::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 11:49:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 11:49:25 +0000
Received: from [172.27.4.140] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 11:49:22 +0000
Subject: Re: [PATCH] net/mlx5e: Fix an error code in
 mlx5e_arfs_create_tables()
To:     Yang Li <yang.lee@linux.alibaba.com>, <saeedm@nvidia.com>
CC:     <leon@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1622628553-89257-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <7b14006a-4528-bdd9-dd12-0785d8409a5d@nvidia.com>
Date:   Wed, 2 Jun 2021 19:49:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1622628553-89257-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b793e476-d033-4197-51a6-08d925bc785b
X-MS-TrafficTypeDiagnostic: PH0PR12MB5433:
X-Microsoft-Antispam-PRVS: <PH0PR12MB5433DE68CA48B3C449F29A4DC73D9@PH0PR12MB5433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:200;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k8qDg3pPxqgfI6eo1/l3BJ8yu6Am1F/1QNFCEXHv51hxkgrShre/40Uzlt/jlIEYWU6MzYamio4i7krLL8JPVhp+VF25BnFlmBQRWnUzBIH/9N4s/SYXxThRfTng+n1Qnx/9VpWT5NOM2m/Pi6Vxn328ohqA/J80RRg73wgfLFpo24/2BZD3WGeV/J69Sx2NuK6jCqq/aU4j9TRHGBbsbHv/X1pnIST0lmSx+sTec66tbEh7M8TYQJQDZtxQdmwZw8TEPYPms+sOzFJEeRzGCnLbdQM0B+gaZLVhZfthL3z26KfBJB8t3mqux94Iiv5+O78atGoM2lEA/FEk8CQBc29GUfovdrhA4a5r8SsDaoyo89awbduk3SZYKmJCkD8bQDP26iQm96N20bRBNlmctXFZ4JMeveXB5UP/jI9zlwrL2uwBMOd2ojRysIPVaA3F3p/m80MlHnsCWT711p8BQVQZH24FqWF834BL3OL82vGVXiWn9Z0wPY/7t1ZLVm2KkDczJ8NvGRx23ATu61Xd8fCmiXFe0xzozmuCrIWVNhrk/o4K4X8RvDe3lQ0+/tgKRNg51Zx6RDIYWrHCZYBNJsgtlOCIeJvmJsJzhpRgGqINeejkhe0eVqn8hDUBTkFzqjBghT34C40up4w4ZEsXlIZAk9fsc34SENxBFoBn5NUgyXD/xwpXn/RcvxPAG0zf
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(36840700001)(46966006)(7636003)(86362001)(36860700001)(6666004)(356005)(82740400003)(31686004)(2616005)(8936002)(82310400003)(83380400001)(53546011)(16576012)(4326008)(36756003)(70586007)(6636002)(186003)(336012)(31696002)(426003)(47076005)(70206006)(26005)(8676002)(2906002)(54906003)(316002)(5660300002)(36906005)(16526019)(478600001)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 11:49:25.1916
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b793e476-d033-4197-51a6-08d925bc785b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5433
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/2021 6:09 PM, Yang Li wrote:
> When the code execute 'if (!priv->fs.arfs->wq)', the value of err is 0.
> So, we use -ENOMEM to indicate that the function
> create_singlethread_workqueue() return NULL.
> 
> Clean up smatch warning:
> drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c:373
> mlx5e_arfs_create_tables() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 'commit f6755b80d693 ("net/mlx5e: Dynamic alloc arfs table for netdev when needed")'
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> index 5cd466e..2949437 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
> @@ -369,8 +369,10 @@ int mlx5e_arfs_create_tables(struct mlx5e_priv *priv)
>   	spin_lock_init(&priv->fs.arfs->arfs_lock);
>   	INIT_LIST_HEAD(&priv->fs.arfs->rules);
>   	priv->fs.arfs->wq = create_singlethread_workqueue("mlx5e_arfs");
> -	if (!priv->fs.arfs->wq)
> +	if (!priv->fs.arfs->wq) {
> +		err = -ENOMEM;
>   		goto err;
> +	}
>   
>   	for (i = 0; i < ARFS_NUM_TYPES; i++) {
>   		err = arfs_create_table(priv, i);

Maybe also need to "destroy_workqueue(priv->fs.arfs->wq);" in err_des.
