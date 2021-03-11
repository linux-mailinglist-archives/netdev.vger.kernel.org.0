Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F6B3375D4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 15:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhCKOdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 09:33:31 -0500
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:24832
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233571AbhCKOdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 09:33:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFWLoD/vR4ytKGL3Vr40Kd9dYCfr2X0tJoHAhzNiUGf0vLGuV5rD6qpddiHis+uoWy8cLg3e3OFGv3btLYjx526HBOm45Lut5Iow373lBEv7p8aXPKd8ZlNSHtJaFYgVjCPPhNIUDJDkHqkjyQKClsnGxrYF6aT2OuqL4VsKTflKRLH52+/UFR9TQziTyGgGJ4JH5xJ5JWqcALRmRN11ly4N2aIFHIQIOrfdG7RjTZ0eVWVf3NH13uPWxid1UFlLUk+vGeZhaBUfL3d6GbLywqozNfk9Q9pVPQDXocq70uERzI3k11+bNh4rh3BfDeTtl3d7g4C90UIdGkHfmu3gWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWyPSemQiCQ3L1cGHg9nSi/4FQii1lO4QWbAkPC8BfU=;
 b=iIuzzVJk8g9IdPAeBzW1hALKTCiptgdnKqmY0SQQn04rwC1cgtausFDy9ZinE+7BfE864XZ+4QPXfjYChPpbIh/7liv50DvjaTfthvVEXJsUlAUiNl4iqx5mTaLCaRMjFc91FKjvOQAtH3pELJJra08oNuU0RhTIW4HdhH0XotAAymiv0VbI7dIshe81BmD4YMtQnhqHr/2zcJyq0FhSybzzsMVEMz/HN54Rbst4EzPhHMenHY1b3mZdqm0oBnvO6VjM15FgNvukWm0WRJsI7nV9kUWl/ZTYRurFwtsRUQDNqd9411QREQa2ogqrmOElj73r1fa0LJwzNUOeGQ6Xbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=broadcom.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZWyPSemQiCQ3L1cGHg9nSi/4FQii1lO4QWbAkPC8BfU=;
 b=mW5fxJIxz0dBAY38LvV+DlyEJvAtMHw3T0fYoWKZVAoJu0ePshvUv0FEbPuOpFGdcscQfjmE+rZEbmar5yanKtyDZVmWCVRJDnPxxEy7HhhfXIpjabISgkfyNP92HLPFBncyTGJZqkZrFB6NmoZ59EyGdpow2ajhjmFhIcrN4FcijYZT2hkxDfusD1tA/Z8t51Y56vefpOSyQYvhzdxmQeBPA9N8a8U83pMW5eCqagHJjY64qZ+NYDMgXwNUFzhWRyN8DoqpAM+8h7XgrN0KqwqS6dMMZ2xgpnTzhb+VLd99A5EEoLy8yNvW4KAEHmftwFnWaxYcLlmqtcK95BtMEA==
Received: from BN6PR11CA0050.namprd11.prod.outlook.com (2603:10b6:404:f7::12)
 by MWHPR12MB1343.namprd12.prod.outlook.com (2603:10b6:300:7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 14:33:10 +0000
Received: from BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::7c) by BN6PR11CA0050.outlook.office365.com
 (2603:10b6:404:f7::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Thu, 11 Mar 2021 14:33:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT059.mail.protection.outlook.com (10.13.177.120) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Thu, 11 Mar 2021 14:33:09 +0000
Received: from [172.27.12.248] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Mar
 2021 14:32:47 +0000
Subject: Re: [RFC net-next v2 2/3] devlink: health: add remediation type
To:     <netdev@vger.kernel.org>
CC:     <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>, Jakub Kicinski <kuba@kernel.org>
References: <20210311032613.1533100-1-kuba@kernel.org>
 <20210311032613.1533100-2-kuba@kernel.org>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <53f182d0-e1f6-5e18-ac04-ff7f6ec56af8@nvidia.com>
Date:   Thu, 11 Mar 2021 16:32:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311032613.1533100-2-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f976df8-a952-499f-b265-08d8e49a97d6
X-MS-TrafficTypeDiagnostic: MWHPR12MB1343:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1343E4C7226EFC4F63F431FEB7909@MWHPR12MB1343.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wqKsdxZOe5W+v8bdUiRy/fKzmo3WY9QGRZCELMpQYF4vH1L0+2jEsFGH5PyW7xEdd3dAcqbwlPwIhvGKPtopvjuT3HuMk4BwSeEu6HDUfCkvWANEK35pj8tBXIlMQCmGayDChXZwx5Rz8gLMXW0pURuyTSv5RgvsbVcAJ6VSRfpHNTJLBCqv/Z2CUDQpuK2sVTPNYj32GPcPIEZVZI0rVvcdfO4h3d1OJNJ11XBdgfMdNntZWjpNzZwCZN7cojFCKSc9PGpm+jkaAVDfuRbNkQE1dGtxNDntoi76g1w2Hggi6gb1/MLDPdyjmZY1mi6uG7C1mc8Ka+gzIFqjrdiiIyl692xr+NAjD2wIPTn6qPVOL3rVV5jOHD0z/HpwLncXXbfAC8/4pb3GQoqAMRDjD/74DokkUMaReN5IfSw5001zFvx21QTXQgGnNcRXn89kViV+Gctc9MP2F8UcdjOrDcYWpbENOpNRaVMIAgc7BYAxeHi0OtKPgwHWt9Q0Gl/rsH/BRpW/Uzdy+Qu2+2SSE3yDrKDIYsImrGP8AHWClME6Yiq0wP3WxoklvNOx9CL0C83hHsYTnj/Wimx77DOK1CHw3eUxX9Kh45TcIIKyrejwZDZ6iOHoUE51aDxiwxbGyyEUtej0Ooy1gTyYky4Av2TwPDGiEUrn3RQA7s+OLlJxn2Rpcgz1NV50gMfbzh4U2L+203cz+mIOYJD/x4zYWzGb3WjCsgcsZoy2tnOfUpIBqzLOQTllHgEalBbUx03y
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(396003)(376002)(46966006)(36840700001)(31696002)(31686004)(16526019)(186003)(8676002)(7636003)(478600001)(53546011)(2616005)(4326008)(86362001)(83380400001)(2906002)(36756003)(336012)(26005)(5660300002)(34070700002)(316002)(16576012)(356005)(47076005)(6666004)(36906005)(70206006)(82740400003)(54906003)(426003)(8936002)(82310400003)(6916009)(36860700001)(70586007)(43740500002)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 14:33:09.4842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f976df8-a952-499f-b265-08d8e49a97d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 5:26 AM, Jakub Kicinski wrote:
> Currently devlink health does not give user any clear information
> of what kind of remediation ->recover callback will perform. This
> makes it difficult to understand the impact of enabling auto-
> -remediation, and the severity of the error itself.
> 
> To allow users to make more informed decision add a new remediation
> type attribute.
> 
> Note that we only allow one remediation type per reporter, this
> is intentional. devlink health is not built for mixing issues
> of different severity into one reporter since it only maintains
> one dump, of the first event and a single error counter.
> Nudging vendors towards categorizing issues beyond coarse
> groups is an added bonus.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/net/devlink.h        |  2 ++
>   include/uapi/linux/devlink.h | 25 +++++++++++++++++++++++++
>   net/core/devlink.c           |  7 ++++++-
>   3 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index b424328af658..72b37769761f 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -659,6 +659,7 @@ struct devlink_health_reporter;
>   /**
>    * struct devlink_health_reporter_ops - Reporter operations
>    * @name: reporter name
> + * remedy: severity of the remediation required
>    * @recover: callback to recover from reported error
>    *           if priv_ctx is NULL, run a full recover
>    * @dump: callback to dump an object
> @@ -669,6 +670,7 @@ struct devlink_health_reporter;
>   
>   struct devlink_health_reporter_ops {
>   	char *name;
> +	enum devlink_health_remedy remedy;
>   	int (*recover)(struct devlink_health_reporter *reporter,
>   		       void *priv_ctx, struct netlink_ext_ack *extack);
>   	int (*dump)(struct devlink_health_reporter *reporter,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 41a6ea3b2256..8cd1508b525b 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -534,6 +534,9 @@ enum devlink_attr {
>   	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
>   
>   	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
> +
> +	DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,	/* u32 */
> +
>   	/* add new attributes above here, update the policy in devlink.c */
>   
>   	__DEVLINK_ATTR_MAX,
> @@ -620,4 +623,26 @@ enum devlink_health_state {
>   	DL_HEALTH_STATE_ERROR,
>   };
>   
> +/**
> + * enum devlink_health_reporter_remedy - severity of remediation procedure
> + * @DL_HEALTH_REMEDY_NONE: transient error, no remediation required
> + * @DL_HEALTH_REMEDY_KICK: device stalled, processing will be re-triggered
> + * @DL_HEALTH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
> + *			will be reset
> + * @DL_HEALTH_REMEDY_RESET: full device reset, will result in temporary
> + *			unavailability of the device, device configuration
> + *			should not be lost
> + * @DL_HEALTH_REMEDY_REINIT: device will be reinitialized and configuration lost
> + *
> + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
> + * by the severity of the remediation.
> + */
> +enum devlink_health_remedy {
> +	DL_HEALTH_REMEDY_NONE = 1,

What is the reason zero is skipped?

> +	DL_HEALTH_REMEDY_KICK,
> +	DL_HEALTH_REMEDY_COMP_RESET,
> +	DL_HEALTH_REMEDY_RESET,
> +	DL_HEALTH_REMEDY_REINIT,
> +};
> +
>   #endif /* _UAPI_LINUX_DEVLINK_H_ */
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 8e4e4bd7bb36..09d77d43ff63 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
>   {
>   	struct devlink_health_reporter *reporter;
>   
> -	if (WARN_ON(graceful_period && !ops->recover))
> +	if (WARN_ON(graceful_period && !ops->recover) ||
> +	    WARN_ON(ops->recover && !ops->remedy))

It allows drivers to set recover callback and report DL_HEALTH_REMEDY_NONE.
Defining DL_HEALTH_REMEDY_NONE = 0  would make this if clause to catch it.

>   		return ERR_PTR(-EINVAL);
>   
>   	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
> @@ -6265,6 +6266,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>   	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
>   			   reporter->ops->name))
>   		goto reporter_nest_cancel;
> +	if (reporter->ops->remedy &&
> +	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
> +			reporter->ops->remedy))
> +		goto reporter_nest_cancel;
>   	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
>   		       reporter->health_state))
>   		goto reporter_nest_cancel;
> 
