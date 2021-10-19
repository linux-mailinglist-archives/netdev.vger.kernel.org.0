Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F0433482
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhJSLSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:18:51 -0400
Received: from mail-mw2nam10on2067.outbound.protection.outlook.com ([40.107.94.67]:48705
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235408AbhJSLSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 07:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/tWaZoYn5PnscT2xfsi4t5ePe66bmgdGoz2DWs+0kvUMrWIPldaCWm1LYzbOeuKepfC2y685p1Nm1nLTPkPcoG+TXQM2/wX8r92ZP8Y1Bhby+ho3VwlrCTsYaYWwjjuzHTNGeoDpZBSZBJ/vt/Ld4/t6Z1J2ciIEl5dzWP1r+Fir5MNf6ZfzNwWwsn0pyUS4MC1T6We4JSPZh2rQYdwJ9mmAyI90hKKfncCZuaQXnGXEs51zqA295ZfDsqaAnwro++Imc8gM0Hnoz9BFZAyN7Vvy5v5IEvMpbCn5aBd/gvZwkpgKpG+0LbEgQ99FCiQM5iaGyl/foRiJs6jQIGJAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONXwRnj32xwddLxyDs1eWHgZCjZvUWBtUaTitu/W6Tw=;
 b=Ft4neDbr9QgLJIwrkNMG1KflxbH0vc4+TWAhT3Z8cTQvMjicQLxLdi2FFDZkt3yg6AVe/Zl2fTnqefpKKCPnZNQSd1RAX0UTjAse3GwwwsrF/PQDUEetzdgJZIf8gzrg4eVUqdWG6kosjSdPAF5b7AsdGptwLE3x8WWVd6lq0VztIE3X6rDgZkEgHSH4vrqPI3Y7I4r8x7tCn5iCuU3wr5vytT4eelNXta0uFXr0vLD5RrX1Qo2nEAOW7eNbPePjG9lW6RspM6727TeBp6BO1s4rMr05JbC7dUL3HRo3nKf/rPzY5AOmDHPISKYQazpVDSqhcj3WOFMgk9qgxyCt+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONXwRnj32xwddLxyDs1eWHgZCjZvUWBtUaTitu/W6Tw=;
 b=kMlpaxApXtXCT1ETNPVCqElqatc0clC0sFdfkG2HhiEueqTYZDLhq3ofrrNdGeo/QzPf9P5UM6HAAiZMxTeCAuhMib9TQhge6MSR5VnHTZC+Gy3rA4yHqrB6vMrQsLWmf5JJBYMEGzipubt2wPZJUiNFET8MZ65lHsMeU+4+buJiGeeyA8JXLz+mCJhX5k+sSSc0daahZjwin1sGe3xijwvY87T/LYwuACiw+Bwj62eo2br0HFCp8KtY17mIc7sVhw23BEu68ox32SenXZ0D8XeSHYC+axu7wTbueETdlM63slsu6mWKfEn0ih5Dlpm6jcly4w9PEMqRj3KlqDMfSA==
Received: from MW4PR03CA0222.namprd03.prod.outlook.com (2603:10b6:303:b9::17)
 by BL0PR12MB2433.namprd12.prod.outlook.com (2603:10b6:207:4a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 11:16:37 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::a0) by MW4PR03CA0222.outlook.office365.com
 (2603:10b6:303:b9::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 11:16:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 11:16:35 +0000
Received: from [172.27.13.79] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 11:16:32 +0000
Message-ID: <94e54e67-e578-3b25-0234-6ce072dc42cf@nvidia.com>
Date:   Tue, 19 Oct 2021 14:16:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V2 mlx5-next 06/14] vdpa/mlx5: Use mlx5_vf_get_core_dev()
 to get PF device
Content-Language: en-US
To:     Yishai Hadas <yishaih@nvidia.com>, <alex.williamson@redhat.com>,
        <bhelgaas@google.com>, <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <maorg@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-7-yishaih@nvidia.com>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20211019105838.227569-7-yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a29b5e6-6129-4564-f238-08d992f1ea40
X-MS-TrafficTypeDiagnostic: BL0PR12MB2433:
X-Microsoft-Antispam-PRVS: <BL0PR12MB243382CBF75483FFA21BC405DEBD9@BL0PR12MB2433.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNiiGB2nlcTBDs+NvHSiRsuP3DqTr9OwwPuv3+0XhI0oxOSHcLzerydL+GpYUhxHV9gnMw2Ftk4pUdu6g6105EtdLLsEnP/Sup/TBhmZJp+atFwrNNFLSUDN5nDCCZvwIblR6kNUk3HvLfsAU8baYv3hWFOPmdl5IZr7BWVIISeiwZ/jWnEiVwI3p65zUf669EwjqWISD5tNWS0/rKfw+WVfeBap2YmqoZUriskt0YMgwNqPw+P5bYOXLgq63qch2gggkrPZlQOBxrhqW0o0mv9ZbcDwYlu7dCEqF8zhxmGiYgFUA3Kt6NBFx9MRixDB+7zESpaZOgconP1bGhIgdPH7Y2njJLxQ5wMgUzjbHbOW/RACLyGquKH5tIxmUrBaXKwu5P5x+RORI4+PN70Ksstb0goctheEpq6WNuPr3kbM+gIFBHlYwt0g/HsUcrLNUIv1ViaHbWzEf4wCLh3gjkh7fhUwVi2CNwOqSR+wp0x0I9ZoQlNUxMbEkWz5JoHJWWtjNVOSFYyHCd8CWXeAs6/nVVJ39hWu6lKYNWqpBQkHG9OOkn2vCshUk65IliQWZ8nTXAgWNRFLrkMHSj5v5dad7rKv+THud1UzTrWbG1RbwW73Vv3Mw6d56rIAjf4r38xJX71OK+4fsYMC1Pgmzvgh6qTWPTPyqP7QdkhZWLaG8oH91QvjLewT3rgbjwDEtKxyOWBc2ab6zS8qB1mMTWLU/8u6ctbORgN8/sPKvrQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(82310400003)(6636002)(8936002)(16526019)(70206006)(36756003)(426003)(5660300002)(7636003)(86362001)(26005)(47076005)(31686004)(186003)(356005)(8676002)(4326008)(54906003)(316002)(16576012)(53546011)(336012)(31696002)(508600001)(110136005)(2906002)(70586007)(36860700001)(107886003)(2616005)(83380400001)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 11:16:35.9089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a29b5e6-6129-4564-f238-08d992f1ea40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2433
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/19/2021 1:58 PM, Yishai Hadas wrote:
> Use mlx5_vf_get_core_dev() to get PF device instead of accessing
> directly the PF data structure from the VF one.
>
> The mlx5_vf_get_core_dev() API in its turn uses the generic PCI API
> (i.e. pci_iov_get_pf_drvdata) to get it.
>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/vdpa/mlx5/net/mlx5_vnet.c | 27 +++++++++++++++++++++------
>   1 file changed, 21 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 5c7d2a953dbd..97b8917bc34d 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1445,7 +1445,10 @@ static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, u8 cmd)
>   	size_t read;
>   	u8 mac[ETH_ALEN];
>   
> -	pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
> +	pfmdev = mlx5_vf_get_core_dev(mvdev->mdev->pdev);
> +	if (!pfmdev)
> +		return status;
> +
>   	switch (cmd) {

Yishai/Jason,

I think this patch breaks VPDA over SF.

Did you verify it ?

-Max.

