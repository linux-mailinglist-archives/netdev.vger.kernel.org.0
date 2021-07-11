Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13B43C3BC0
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 13:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhGKLVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 07:21:23 -0400
Received: from mail-bn1nam07on2062.outbound.protection.outlook.com ([40.107.212.62]:19278
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229688AbhGKLVX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 07:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njuhinQgbNf7+VXfivULVpnnZbp2dFEAk5A3hxYILLMVI6hUeOamLVOu6ADgMXKyFj/r7Sktf3Y9GD3+lOH1uEj4fIEkkoQbxlX1j+HZotir4nlOcBqNs8yCPopjlOddOFlV6+YZXpveX+3HgzXLdqILp66FpH3RAT3QtDm5h4elSQn2hWLpt6omcJIiAccz97sqir2fx1ul9LV5SSo08svvsFQ/IPFhQbho4aCOcuQK2O5vkK1JorahpcBrzytCenWMsp1TWyxTLlWCxaLL1qiJ6O7FujvH1lTW6UpIFPjLO2Jmc6lOzIYTlP37cJ9mhRRROZUQmbtSZn7Gsfbtyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Lhqzz4zCnEfTEFt/TQAQ5grpXxA/UnDip0P0qbrjz8=;
 b=ifpSRBiHDdopWbWet0fBgcRpEiTi6Sa5trhxhRwu+Y4sBnmm0DyUn8skFCB4ZhkFCQiu5EeyLKhXjxOvzEOtO5Iurf1q+CY4u1tZtcKlAKAwHJG0u0OKAVqVBM/mM7PEGgF+auA/9H7sRKxnqJJ9wZcciLMo/dU9SzreWL1nY3oUkaF0c/QCafPnWvKVRkryblbHVWzyQy/DgOiZ6inMBiGxr8yqsLGPmvgJVhwJ2405rnmk4sNn8HOWRe4JXXnwqSXCnkxD9ZfRuLgdkXhsm8BIXfi33e8a+WxtdwkcSuv4jaMo638pf9pxJrgijrExgK+YZcJ9x4DaTtz5oCqdzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Lhqzz4zCnEfTEFt/TQAQ5grpXxA/UnDip0P0qbrjz8=;
 b=IgF91LCFpwSL1tzRqHG7iEhRTGj9Ety6mTA8GaWh4fA0VtbeAW0bGk1dwMJfSgWqYuw5sAz9LVy/LJz7wdu2Kg9DpAQvn2gk8dOzXLujIMGQKZcvGeDoc97HjIJAaGuCUD7264MTdXbIiZpBXkUP2FDED0sfOblibx/chSsZbQOAlF5Q9B/1BzDyIIArdFtY+pTTBLTwNua9TXvbKyhIttFlmoryFw4v2P9+2axmy5zxszi0rTAXnGLseBe3vrdAu6NZ7LjG68QNyw+kRJXroese/RmKGMUk0khM9U5zV0EAwHUpqUNgKbVwqdpUFphizcEUD4mPmqVNxuh0HupGpA==
Received: from DS7PR03CA0083.namprd03.prod.outlook.com (2603:10b6:5:3bb::28)
 by MWHPR12MB1791.namprd12.prod.outlook.com (2603:10b6:300:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Sun, 11 Jul
 2021 11:18:34 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::6a) by DS7PR03CA0083.outlook.office365.com
 (2603:10b6:5:3bb::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend
 Transport; Sun, 11 Jul 2021 11:18:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Sun, 11 Jul 2021 11:18:34 +0000
Received: from [172.27.15.179] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 11 Jul
 2021 11:18:32 +0000
Subject: Re: [PATCH iproute2] libnetlink: check error handler is present
 before a call
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        <netdev@vger.kernel.org>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
References: <20210711111546.3695-1-alexander.mikhalitsyn@virtuozzo.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <54821a00-0dd1-da72-0445-63af284eb8b3@nvidia.com>
Date:   Sun, 11 Jul 2021 14:18:30 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210711111546.3695-1-alexander.mikhalitsyn@virtuozzo.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5bef709-4a71-4cc5-99b3-08d9445d9f81
X-MS-TrafficTypeDiagnostic: MWHPR12MB1791:
X-Microsoft-Antispam-PRVS: <MWHPR12MB179136DBA91D783BFB576B5EB8169@MWHPR12MB1791.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:628;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yA97B7Jxvd79JKe7uPIFN3UeLCJto191so+bi22uEix7EC4xEjFT1AzcT0aZNeGhlxa/P6EinnEUcD9oR0slasdXM48lZUuc619xyG9/oE9Wq5yOAgsKSrLRh2kpiOWzh+uPVomHaaWm5l2WvAkXm7LildxxK4jFD1t7ElsW9dKwnR6ya70DKt1e7Tv0AbIP6pFx9+sqFAl2gf0Cekd8YdUcI8yyMKMxBGjG/D2mtnPNgLbTzB/Ho/Eo/J+IoMxFRz+310HIFGHFGhA+jZPIo+NHlS7qrEbl+bryb/IZQFbWKjuTr87FWQaRkLBfCgOJsm5qShLFEQY38TIQSHAPshr4fBM0GW3w+ptGptb4cehdpFHjjNureyh5MAhqfZVJWQb6ipzIzeBhhRNQZ+PSiEb3ToKlmvlcml7o3nDM2HBwy/JdNP5jDU9zI4Y3EfveR7iGyKkifQu2g8R2k/VitruXka42lDrWACyRV5tlJCsfVjaQgIUmVU0U8gtrqCgbhh0/+iCOlQP87WYq8ENfj23s0HNNshi8fs990Vy8R4jZ4g4svli59T2ca6jtVIWsDXQCvibplNS8kxUtgavPIJ4Nm/UXFFEkD9Wo1cwGuShzzS+16rlU8yr56yh3BqmnzogTHsQOlkRCcv5JcvIr1w35lMr0Ul7EsUSrB/F6jrqjQzw7ihdaVcogXKlYn5ub0j8DBEWDcSqsCmefaWyQKSNglR2RllFOzWbasxGddp3/Exc5cQi5gCVDQhwBsoSxEE1tMFBel4iUs8fmXwQG3w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(46966006)(36840700001)(356005)(26005)(2906002)(82310400003)(86362001)(36756003)(5660300002)(70206006)(7636003)(8936002)(336012)(8676002)(31686004)(53546011)(82740400003)(34020700004)(47076005)(83380400001)(36860700001)(110136005)(426003)(4326008)(478600001)(2616005)(186003)(31696002)(16576012)(16526019)(54906003)(36906005)(70586007)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2021 11:18:34.6894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5bef709-4a71-4cc5-99b3-08d9445d9f81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1791
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-11 2:15 PM, Alexander Mikhalitsyn wrote:
> Fix nullptr dereference of errhndlr from rtnl_dump_filter_arg
> struct in rtnl_dump_done and rtnl_dump_error functions.
> 
> Fixes: 459ce6e3d792 ("ip route: ignore ENOENT during save if RT_TABLE_MAIN is being dumped")
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Roi Dayan <roid@nvidia.com>
> Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> Reported-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> ---
>   lib/libnetlink.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/libnetlink.c b/lib/libnetlink.c
> index e9b8c3bd..d068dbe2 100644
> --- a/lib/libnetlink.c
> +++ b/lib/libnetlink.c
> @@ -686,7 +686,7 @@ static int rtnl_dump_done(struct nlmsghdr *h,
>   	if (len < 0) {
>   		errno = -len;
>   
> -		if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR)
> +		if (a->errhndlr && (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_DONE_NLERR))
>   			return 0;
>   
>   		/* check for any messages returned from kernel */
> @@ -729,7 +729,7 @@ static int rtnl_dump_error(const struct rtnl_handle *rth,
>   		     errno == EOPNOTSUPP))
>   			return -1;
>   
> -		if (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR)
> +		if (a->errhndlr && (a->errhndlr(h, a->arg2) & RTNL_SUPPRESS_NLMSG_ERROR_NLERR))
>   			return 0;
>   
>   		if (!(rth->flags & RTNL_HANDLE_F_SUPPRESS_NLERR))
> 

that was quick. was about to send the exact same patch :)
so tested as well. thanks!

Reviewed-by: Roi Dayan <roid@nvidia.com>

