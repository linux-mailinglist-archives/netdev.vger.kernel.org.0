Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708F43302D3
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 17:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhCGQAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 11:00:24 -0500
Received: from mail-co1nam11on2055.outbound.protection.outlook.com ([40.107.220.55]:5468
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231226AbhCGQAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 11:00:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOiuAILfmOsJin0T06NmOh27yr2ESwZYSsJMQBK7GNYjeJvLGgo0QZzQ2irbQlo1rAwM+7B0v3/70C8yEntAtrRlrZfeHRKnUoa082onYda1jCPI3uhpOH5WnI4wmf12uSqijyR3LE8oXS0d7CjCI3mJzCVFNMJ9X5ZxR4pGljEb1q6FqIC7+u2o2DMpkc2MAFvgF0HpNHr/BdMrZA8Jr7O4/GkhbbEl9DcHXUQ96sNZiHdPaIdwjzKZt8ZZmPum3Dufu6EB0bDAGyh2uf+5MueU17PWLNsfXfobqDXKSOnRKXmBXNIio1LIqTeD93Go5yf9R74YNr9DHlIwsAlNRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pejd063JQsC6YHvLBYBXh4OEpT2AyG5PFOqioDAXRQ=;
 b=U5nVFlOxwwcyOOKXC1A5ajGXnXdjn3wOYbhu67tyUEfJWBtRTHb05EFTDScMIOEGek7MPrsaDab56sSg1mB8YDBvIlGJrOC8umL0hnlR4gZoDj88+wMqrhhoiBcnByBzKL6elSBKCi3jiadZ7n7JXvnqakOiNITd0SgbfPol6JrIF2iQEmIM/R2qthIB9b7kLywG9iqso1N5FKJOpOeZNOBeB0vs7ZjbOIXjp4J3sN7EnjqDUJ5n/ksZkbtT/wR4sHS8Lzws5gJoEnliK8VI0MzZ6e9TDMq7PFxiRUxFVW91gP19SnBSbdzEWl0bJIKQdm7/TRFOWdWVm0+RNsgtnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pejd063JQsC6YHvLBYBXh4OEpT2AyG5PFOqioDAXRQ=;
 b=qnnCYibZlYcvm0fU0ett0bRAzS83BqFVPZRRrziIvhdNoTH5B7Qacat232RAh4976j4+erOjJbX3NMIs6ODWWw8akhjwgeylhlouUaiQ7JI+KC2O9RjgfvcFeU4B6uZ86tOnpEkGaUZXWuoGsZKNq3cgY84B8ERmo5TTscFmAqw=
Received: from BN0PR04CA0158.namprd04.prod.outlook.com (2603:10b6:408:eb::13)
 by BN8PR12MB3124.namprd12.prod.outlook.com (2603:10b6:408:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Sun, 7 Mar
 2021 16:00:05 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::f5) by BN0PR04CA0158.outlook.office365.com
 (2603:10b6:408:eb::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Sun, 7 Mar 2021 16:00:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Sun, 7 Mar 2021 16:00:05 +0000
Received: from [172.27.12.69] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 7 Mar
 2021 16:00:01 +0000
Subject: Re: [RFC] devlink: health: add remediation type
To:     Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
References: <20210306024220.251721-1-kuba@kernel.org>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
Date:   Sun, 7 Mar 2021 17:59:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210306024220.251721-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3069313e-76cc-486d-de78-08d8e18212fa
X-MS-TrafficTypeDiagnostic: BN8PR12MB3124:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3124D56F8665AFE68A0792EBB7949@BN8PR12MB3124.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJquAPfhYWNwO8p5bBEwoQ9JEUGiEFGp/psIfTMOy0B+YghiZ6kUmnwUp3SxWX9Q3Yfia9qPdBJp3xazH88CkFqRxk7UGeA7FdcE8kAfrr0K9G+1y24syCI0kVfmErkmqU/IcJljf+4afJOiQW5J4/1oCeGjtI3Kt8OR0qgUeac4X2AtmdRwetHB4Mx7w5armr6oZHKWvMmOSDM1A6eD85VzDAC45BUf0IXVEsitKvP2vJ9puxM3JSqfrevaDKZwBVuRBrfXqYNHyZKnK9+j8ihTwTJs4NfClh0r7wk/GP2i4kOjTjaIrMWRKK0uGW28uRgWmE/OSkqjG0lYto8g5aNFBDfBXYjMUgNMonFFLhLZKXo9xo44rRJ0rridKp1f80hKEbusDLD2Gh5w3Fzaw8tOAkAvBY47jOGiij3OU4bphOnorhmXRbQdnvKYHmAgTeCUqixRu45C4y5mAg4yVyb2DWnSlgmpwt1t1wk2XNA9r0RcFeMWW8XDy17dUbFYqwd4KRlaAPEspCULyAzDPjap9l4bzubAty7YI57hPgg6BkHXHFJHYXRser6sLkpoIDPA6LrR1SaLeLor7QWK/CFmX4uxTUB6v3Lsm0BEwJA0PApnJmCH5hRsMyHdgQ++MA6zMHYuKaS8FFoYplY6Ex+xr+PjNdnxMexMFv8VzMG1jPABu7Jp0n+8kragU5mTJ/ZoFQuGqgMOSYJ7Yh8spN+Qa0phORE9Zr8fsQF17YE/kFVHplY5Gub3KSkZuCOR
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(46966006)(36840700001)(316002)(36756003)(478600001)(2906002)(2616005)(8936002)(47076005)(8676002)(53546011)(31686004)(5660300002)(426003)(36860700001)(16576012)(110136005)(36906005)(83380400001)(336012)(31696002)(70586007)(356005)(6666004)(86362001)(70206006)(26005)(34020700004)(186003)(82310400003)(7636003)(107886003)(4326008)(16526019)(82740400003)(54906003)(43740500002)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2021 16:00:05.1785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3069313e-76cc-486d-de78-08d8e18212fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/6/2021 4:42 AM, Jakub Kicinski wrote:
> Currently devlink health does not give user any clear information
> of what kind of remediation ->recover callback will perform. This
> makes it difficult to understand the impact of enabling auto-
> -remediation, and the severity of the error itself.
> 
> To allow users to make more informed decision, as well as stretch
> the applicability of devlink health beyond what can be fixed by
> resetting things - add a new remediation type attribute.
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
>   include/uapi/linux/devlink.h | 30 ++++++++++++++++++++++++++++++
>   net/core/devlink.c           |  7 +++++--
>   3 files changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 853420db5d32..70b5fd6a8c0d 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -664,6 +664,7 @@ enum devlink_health_reporter_state {
>   /**
>    * struct devlink_health_reporter_ops - Reporter operations
>    * @name: reporter name
> + * remedy: severity of the remediation required
>    * @recover: callback to recover from reported error
>    *           if priv_ctx is NULL, run a full recover
>    * @dump: callback to dump an object
> @@ -674,6 +675,7 @@ enum devlink_health_reporter_state {
>   
>   struct devlink_health_reporter_ops {
>   	char *name;
> +	enum devlink_health_reporter_remedy remedy;
>   	int (*recover)(struct devlink_health_reporter *reporter,
>   		       void *priv_ctx, struct netlink_ext_ack *extack);
>   	int (*dump)(struct devlink_health_reporter *reporter,
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index f6008b2fa60f..bd490c5536b1 100644
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
> @@ -608,4 +611,31 @@ enum devlink_port_fn_opstate {
>   	DEVLINK_PORT_FN_OPSTATE_ATTACHED,
>   };
>   
> +/**
> + * enum devlink_health_reporter_remedy - severity of remediation procedure
> + * @DLH_REMEDY_NONE: transient error, no remediation required
DLH_REMEDY_LOCAL_FIX: associated component will undergo a local 
un-harmful fix attempt.
(e.g look for lost interrupt in mlx5e_tx_reporter_timeout_recover())

> + * @DLH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
> + *			will be reset
> + * @DLH_REMEDY_RESET: full device reset, will result in temporary unavailability
> + *			of the device, device configuration should not be lost
> + * @DLH_REMEDY_REINIT: device will be reinitialized and configuration lost
> + * @DLH_REMEDY_POWER_CYCLE: device requires a power cycle to recover
> + * @DLH_REMEDY_REIMAGE: device needs to be reflashed
> + * @DLH_REMEDY_BAD_PART: indication of failing hardware, device needs to be
> + *			replaced
> + *
> + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
> + * by the severity of the required remediation, and indicates the remediation
> + * type to the user if it can't be applied automatically (e.g. "reimage").
> + */
The assumption here is that a reporter's recovery function has one 
remedy. But it can have few remedies and escalate between them. Did you 
consider a bitmask?

> +enum devlink_health_reporter_remedy {
> +	DLH_REMEDY_NONE = 1,
> +	DLH_REMEDY_COMP_RESET,
> +	DLH_REMEDY_RESET,
> +	DLH_REMEDY_REINIT,
> +	DLH_REMEDY_POWER_CYCLE,
> +	DLH_REMEDY_REIMAGE,
In general, I don't expect a reported to perform POWER_CYCLE or REIMAGE 
as part of the recovery.

> +	DLH_REMEDY_BAD_PART,
BAD_PART probably indicates that the reporter (or any command line 
execution) cannot recover the issue.
As the suggested remedy is static per reporter's recover method, it 
doesn't make sense for one to set a recover method that by design cannot 
recover successfully.

Maybe we should extend devlink_health_reporter_state with POWER_CYCLE, 
REIMAGE and BAD_PART? To indicate the user that for a successful 
recovery, it should run a non-devlink-health operation?

> +};
> +
>   #endif /* _UAPI_LINUX_DEVLINK_H_ */
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 737b61c2976e..73eb665070b9 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
>   {
>   	struct devlink_health_reporter *reporter;
>   
> -	if (WARN_ON(graceful_period && !ops->recover))
> +	if (WARN_ON(graceful_period && !ops->recover) ||
> +	    WARN_ON(!ops->remedy))
Here you fail every reported that doesn't have remedy set, not only the 
ones with recovery callback

>   		return ERR_PTR(-EINVAL);
>   
>   	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
> @@ -6263,7 +6264,9 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>   	if (!reporter_attr)
>   		goto genlmsg_cancel;
>   	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
> -			   reporter->ops->name))
> +			   reporter->ops->name) ||
> +	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
> +			reporter->ops->remedy))
Why not new if clause like all other attributes later.
>   		goto reporter_nest_cancel;
>   	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
>   		       reporter->health_state))
> 
