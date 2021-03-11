Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3FB337577
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 15:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhCKOXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 09:23:23 -0500
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:44825
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233493AbhCKOXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 09:23:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvcFLWYpgddbkhiHIEnuqwl0vHs7hdl5py8HEThNUUFjp2rp99oP3Z+rU6cldnCquCoSFhw0ofQ1jIYzthJebpAbo8FJFjq64kbAPuuJb0+uImQ5QI/ewxRbKQVDBoBFzKefYYtuIqp0/j8nsFgHwtX4QhyJr+27IxrA5/JvToriCYZiWftAkIolamD9jb7svOnLiV94t/QHVBmbsf1vZ9rE+EItdvmcQNECaVEPDeIGn9Zq8FTpPa7wPyJBsHYA4wQ+1nUjquCOTo6HSDZ6E1pUyFGCJPGxN0q2DPP/hm4z7mN84JE4qS+QCSYu06qVwoeUWB4ZRmk3ZXagXrguQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vi8hvq8ekD5eb2BgjzGdni2M1u7QXvcUm/eeQekWag=;
 b=e6Tv4kfP2m3FgsL3DafdmVzbFMb4VzpP0ZZOTlaUSvpzzw09Y98PenV/UibYzdUY73RjpFzh3iQks0JEB8tK8jjxM99qz4ID3eQv3FIGiEkRvOp/fk47KflBYpNrLztC4wKbCH7ll/xqRtgwQFwGbadXH7NgQUX8ugXTf78qAQM8TXCIUsQdLELbF54SeqDgyuPavECzOFw8ayhTsIJU1sVT7ExK5K4JJ86qjlevP7t1TspNoqMKolJRfnGpNSRuLrckVyEo9NSP9a5JMC/Cz2IVXLl34w2/7B5hkUQMauwAaTHrPBxbYxlrZvVdvR1c6fnnWKZ3zjyngceyvC7AIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vi8hvq8ekD5eb2BgjzGdni2M1u7QXvcUm/eeQekWag=;
 b=qegyuAbnkEJNHOxk9c2wEBJnLutxw9QhXdI1/jSM6PD0zGkQfWZ9iH7bsukig6bMr5yyYV5a/DyWwposNNSvaHHCdrEEhM/xaSrimuUsBu7lXu8LMRdr6uSip+Am1zTZx8+Reus9FjlnC/G3HV7cKlxrCLOCItCB2cqNzV5DgEcp5/SmNbe00UoPqc7t9Rl+/y1vk020kWYUtow89YTW1gPbxdIUnSg6UJu1hg5cAZenUgAqGp18TiDIMGSKdlVnNIwyMNmoLl8UNOmKvOaoEWNhxoPXph6KCROWd6oEHSVfPPg9+wtM5aoNcnTNpGJPHWgS8hGDF0nx3WJOb52v3Q==
Received: from BN6PR1201CA0005.namprd12.prod.outlook.com
 (2603:10b6:405:4c::15) by DM5PR12MB1883.namprd12.prod.outlook.com
 (2603:10b6:3:113::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 11 Mar
 2021 14:23:17 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::35) by BN6PR1201CA0005.outlook.office365.com
 (2603:10b6:405:4c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 14:23:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 14:23:16 +0000
Received: from [172.27.12.248] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:23:12 +0000
Subject: Re: [RFC net-next v2 3/3] devlink: add more failure modes
To:     <f242ed68-d31b-527d-562f-c5a35123861a@intel.com>,
        <netdev@vger.kernel.org>
CC:     <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>, Jakub Kicinski <kuba@kernel.org>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
References: <20210311032613.1533100-1-kuba@kernel.org>
 <20210311032613.1533100-3-kuba@kernel.org>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <8d61628c-9ca7-13ac-2dcd-97ecc9378a9e@nvidia.com>
Date:   Thu, 11 Mar 2021 16:23:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311032613.1533100-3-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3a698f7-99c6-4de6-89f3-08d8e4993673
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1883D3C5A4DE4609DCC445C1B7909@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:529;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c90+GBOJo1q1vsI3Oxc0NsjYLrJ0SQk1hfUphBQw2ISwGFGXpH7NCNNrSRPeEAic0ZAGiVeid5Rn74FFI53Taz786ASASt6DVC6wTdrWLqxzNIF+HZXSOdPsgpZfBjSkmOfXoomS9A/OuIBOSJxRd0NUKBs686f6jOOZfV16ZzM8jCAsoe4y41tROKChmhLBHmDUlHCF59NW7ZsI9RRmDBS5U69oFhHc50xg+ChPzgsXZJqk3ORoIEW4D4g03qC7gHb4/nPyj6Rmsekb9raobaKYMvC7oZ2VZyjiQUeyjyTyly9LMY2XVhFoXjW1/YElriUal378KTeS7cuNHQaf29oTR0ThJzqezx62K+DwVjPLy4z0ar4wH0qS+SEwjXInJZiQm5O1ckWi/x0T/4+RENbHxTFFQVP1oL45CyR1MnV+/gof21Kl23D+bdR7TNrrnAiflz3vKp/joowJMlJI9aaGRvPtZljyQtbuv2VI5UP5YPYg2RH/oVnNF/zWMgI/UQFGR1BS8B3XqEkCK4PLssrlv+GU/AmXYPmiOQ8ANj8/aWlKuUg55bWRQR2jQqWcabyJHuEkxUr7j2whTajot9KXyxjAKsGqsWw5bs9kpAxhtPC9c7GtY3VCaNJ70x6p9OCOErW3Vo7HcQsxJwficCFl2AaVSmjr/QQ1ybhuoKcTesfO9elqDCzCJqzf9B1Wchy3SvKb/etrSFacezdk4b0FDT0Af6TDzNpIv/wNSnc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(26005)(70586007)(356005)(16576012)(36906005)(70206006)(316002)(110136005)(54906003)(2616005)(34070700002)(36860700001)(107886003)(36756003)(4326008)(426003)(31686004)(8676002)(336012)(5660300002)(82740400003)(478600001)(2906002)(53546011)(8936002)(186003)(47076005)(16526019)(6666004)(83380400001)(31696002)(86362001)(7636003)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:23:16.5966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a698f7-99c6-4de6-89f3-08d8e4993673
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 5:26 AM, Jakub Kicinski wrote:
>>> Pending vendors adding the right reporters. <<

Would you like Nvidia to reply with the remedy per reporter or to 
actually prepare the patch?

> 
> Extend the applicability of devlink health reporters
> beyond what can be locally remedied. Add failure modes
> which require re-flashing the NVM image or HW changes.
> 
> The expectation is that driver will call
> devlink_health_reporter_state_update() to put hardware
> health reporters into bad state.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/uapi/linux/devlink.h | 7 +++++++
>   net/core/devlink.c           | 3 +--
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 8cd1508b525b..f623bbc63489 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -617,10 +617,17 @@ enum devlink_port_fn_opstate {
>    * @DL_HEALTH_STATE_ERROR: error state, running health reporter's recovery
>    *			may fix the issue, otherwise user needs to try
>    *			power cycling or other forms of reset
> + * @DL_HEALTH_STATE_BAD_IMAGE: device's non-volatile memory needs
> + *			to be re-written, usually due to block corruption
> + * @DL_HEALTH_STATE_BAD_HW: hardware errors detected, device, host
> + *			or the connection between the two may be at fault
>    */
>   enum devlink_health_state {
>   	DL_HEALTH_STATE_HEALTHY,
>   	DL_HEALTH_STATE_ERROR,
> +
> +	DL_HEALTH_STATE_BAD_IMAGE,
> +	DL_HEALTH_STATE_BAD_HW,
>   };
>   
>   /**
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 09d77d43ff63..4a9fa6288a4a 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6527,8 +6527,7 @@ void
>   devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
>   				     enum devlink_health_state state)
>   {
> -	if (WARN_ON(state != DL_HEALTH_STATE_HEALTHY &&
> -		    state != DL_HEALTH_STATE_ERROR))
> +	if (WARN_ON(state > DL_HEALTH_STATE_BAD_HW))
>   		return;
>   
>   	if (reporter->health_state == state)
> 

devlink_health_reporter_recover() requires an update as well.
something like:

@@ -6346,8 +6346,15 @@ devlink_health_reporter_recover(struct 
devlink_health_reporter *reporter,
  {
         int err;

-   if (reporter->health_state == DL_HEALTH_STATE_HEALTHY)
+ switch (reporter->health_state) {
+ case DL_HEALTH_STATE_HEALTHY:
                 return 0;
+ case DL_HEALTH_STATE_ERROR:
+         break;
+ case DL_HEALTH_STATE_BAD_IMAGE:
+ case DL_HEALTH_STATE_BAD_HW:
+         return -EOPNOTSUPP;
+ }

         if (!reporter->ops->recover)
                 return -EOPNOTSUPP;

