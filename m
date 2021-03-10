Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0FB3338A6
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhCJJYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:24:35 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:44033
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230397AbhCJJY2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:24:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7zeXYaoCljwbcXLyiDP9YYf0z14m8+aEuJe+er/ufwdk7nHkK9YTCgQw+FL3dohmS70B8icKvjRgmU3kGcFsKjvcf1WHiq7yrq9DI6Ir+W0FZA1aZrq6Fvng8ivX1hlT82WOzb69PSmmTXOZr9JM/5KMWXAUn1K2n7/IORzMIpJiB4PhARV4bfJ5FWrtGSEyBS/1hJFncx2vQBnMOVZk6P/ILQwcC1vgk1Bq5i1An34N4PxULPQ3D9v56bXv9/bdUhxUFB6dbZg22MNU7sqUrUwgJdkNMSgbw44wpXIKwU27PqdKLYphJ7zvCsckPFddqQjLwYb4NTHlqI0+ylhOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzWvwDZcldfhAoxCRj8o4MEB7rP3dPUeO0kluDHm59o=;
 b=KYpFcl1rkXcWldByiPUrnlkH2jqOe0v1UYfMNjhJDpMUPnqY4W0lkCYDOR4fjwQXMUf0n1EdRTZV+235RC/wGhuZEr3q2x7fuRZ0z2RnyNEVJ7wqSPyhK4vKiiiSfVT2p6UEbS3Z6gGY8vaVURaksFfF6zlbTrh+EooDfkwWmC5mx8jq9G/i3k6nUwPyp9Lu+hCgLkwSrRpmSqEsPBM/xsawvl5npihydC/ffjRsa+Nrf2CaI/X6TgmPQg29EicaQirVk1xCPp+Ikjhx2UGIRvOT3BW0yqW3rctjabIVt4v0c7lgh2YthW1v4BYFS3ksqvwVAMU6Q8uGbnitn/mENQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzWvwDZcldfhAoxCRj8o4MEB7rP3dPUeO0kluDHm59o=;
 b=GbURi1JjXQYOyGonpvxhVNSZovBMxKEmPXeT8tFNOa19OlLCHwgU0K5dSsxlNZrS4L65Ok/lbRLCkOc08rfqtsuHyqTZ/ueA0tmAMG78kLlDmHf5Dwpz9b8H2GCvXcLh1oNr0S2P+vxPc342y1s4P55tZU6BnEDHiZDywlUyqBI0rZxRI3Gk2cF/bUtdacEiOArgyije7E4WOTQhttXi+7krEUU9AaO/BDxl2dWhF6j+bsCAarCccldB5zZm/gYwg4uKneMcmYHuaO1j8jZDIMIv6XvfoUwhl+hv0PqePpZcb4mEYHHDM+BXXsZwntJHRy3pE+1YUxZqQ1ucfLqd7A==
Received: from MWHPR11CA0039.namprd11.prod.outlook.com (2603:10b6:300:115::25)
 by MN2PR12MB3183.namprd12.prod.outlook.com (2603:10b6:208:101::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Wed, 10 Mar
 2021 09:24:27 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:115:cafe::49) by MWHPR11CA0039.outlook.office365.com
 (2603:10b6:300:115::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Wed, 10 Mar 2021 09:24:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3890.19 via Frontend Transport; Wed, 10 Mar 2021 09:24:26 +0000
Received: from [172.27.14.238] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 10 Mar
 2021 09:24:22 +0000
Subject: Re: [PATCH] net: bonding: fix error return code of bond_neigh_init()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, <j.vosburgh@gmail.com>,
        <vfalico@gmail.com>, <andy@greyhouse.net>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210308031102.26730-1-baijiaju1990@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <e15f36f7-6421-69a3-f10a-45b83621b96f@nvidia.com>
Date:   Wed, 10 Mar 2021 11:24:20 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308031102.26730-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7a5952a-9c60-4077-d757-08d8e3a64cd0
X-MS-TrafficTypeDiagnostic: MN2PR12MB3183:
X-Microsoft-Antispam-PRVS: <MN2PR12MB31839FAF7E362BE7D80D8A8CB8919@MN2PR12MB3183.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:116;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6uj0Fj1IigmvzjJ5Xt8qS2+7jC970HhmZ4azjY3zaYHssFrIFNadkEIr9YwNTJ4K9cWRqCJc+M39PviEVjvcX0UZcG75GUoBzOazJv7BhqrbB8w4BoS183QAs4M47vCBbuk4J60vOH/muNJbOGJAIBeg4B8HiQdFG40cofbxtQI9oLtG2xS55seDgzmXVCgwg5YJCxBrGSxJijWn8WLBAso1/uKBDsMoJJpAeBPv2t0IxuNIOnDE5alOG9/mh3CtaNrfK2rM6plCpFYJll64jF//OEYjUlnHQMr7Qplz/XKNQNmtm8skt7214rM/rifmh/ROZkA4Yb6qFn9dRS3nbzv3rLvGTIHduDDZSxuCnAmHuD9K894ySrAjALXhjKEo5Z8X4XjfLylPoyaQSB6A7kIp4ZQxWbm5KdLN8OTXxI1Kf2fbofKFJEIXLWFYy01QNIUw8gEWQgDKKLYdAQhZ34VtjfU5sjCHt9/pKZmTmJWT3yYr6Z9LDVDzQQ906W/ilNTTxGGb3pliVyYJ44zPM2ZmeWi+R6NncmjzGYZVF8ng/2DOVn48KcBpXY4zZ98YmMY/8a7wq0970iHEvx93g4HU8KA1r2+E62bdyTYaNKGl0iEIN3aFj935kWxdu2AA41lN/C9VCKqyJyuda9wzZYvGupWHw62Oala+gcKkHluB72O2ShQKjeqGE8YtBQobvVeXN7YFOb5KX7lnL/TW9ZaowmLUrta5JQL3cGKSDZA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(34020700004)(36860700001)(316002)(82310400003)(31696002)(26005)(47076005)(36906005)(426003)(2906002)(478600001)(4326008)(70586007)(86362001)(53546011)(356005)(82740400003)(83380400001)(31686004)(336012)(110136005)(2616005)(70206006)(8936002)(54906003)(7636003)(8676002)(16576012)(186003)(36756003)(107886003)(16526019)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 09:24:26.4527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a5952a-9c60-4077-d757-08d8e3a64cd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3183
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-03-08 5:11 AM, Jia-Ju Bai wrote:
> When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
> return code of bond_neigh_init() is assigned.
> To fix this bug, ret is assigned with -EINVAL in these cases.
> 
> Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>   drivers/net/bonding/bond_main.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 74cbbb22470b..456315bef3a8 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3978,11 +3978,15 @@ static int bond_neigh_init(struct neighbour *n)
>   
>   	rcu_read_lock();
>   	slave = bond_first_slave_rcu(bond);
> -	if (!slave)
> +	if (!slave) {
> +		ret = -EINVAL;
>   		goto out;
> +	}
>   	slave_ops = slave->dev->netdev_ops;
> -	if (!slave_ops->ndo_neigh_setup)
> +	if (!slave_ops->ndo_neigh_setup) {
> +		ret = -EINVAL;
>   		goto out;
> +	}
>   
>   	/* TODO: find another way [1] to implement this.
>   	 * Passing a zeroed structure is fragile,
> 


Hi,

This breaks basic functionally that always worked. A slave doesn't need
to exists nor to implement ndo_neigh_setup.
Now trying to add a neigh entry because of that fails.
This commit needs to be reverted.

Thanks,
Roi
