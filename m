Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBDE33285F
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCIOTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:19:13 -0500
Received: from mail-dm6nam12on2086.outbound.protection.outlook.com ([40.107.243.86]:19286
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230035AbhCIOTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 09:19:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IN8gYOK34Gl274dTx4HutFkF+8UWUF66wX1otpyZokSSXq8BnocN09jh2botaT3o5S5FlNRn7ILp7aIvmmMS+9HS2mUc6Jc9Hem/TOr2OhI9/3z8xJa18Nfy7GuwSEvj/gOGjmnX/5J8QQD7quG5pM6XNigu2mJM5WvSwf1qt0iaqI9VdfB4oz/6vfddkQrSSfK7zyW8ON+OSunkUmYbL3R/TtwTgqBKw5C2N1MTrvtq8C6spTrfihXOY80j2FpTVHCvysCXU6tLTvqcoWcZ49jvjRuX+uSCmcBisHNUtTgxC6nLHNlqR8BUGRyNmKnd+cKB22dYbNENQzVR6JBpkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oo+as1Vt5yavLqmmjBmuKrZa8mhfLdGp4rpHVpMDEgs=;
 b=D9Z3lSTXSRYHzcx4iLObsVYWiBNrm7hmsMNduuY4ef5suldEDCGXKhq5ULwhdkS7B+KONsyVyi/A0KZ/bcJOb12EURH5EZnLO74Klc0fSGdUHjOh+NCeifGU3Ky03N6v+YbH6QcG3N0xIFBCrYL7rQtORmuNNDjsMLMRy13fH0RluvcllV5mvtw5XPBRgrYiI0MRCWkZOhhdxTVsDmpYIwJNybBu0fwDAAPmtss99RelsIcD3aUGVuLKax2BEs/KXvZnR1XshKpEMrFf1AISvEiPlRP0wWQRTpzDdjuNXsCPJ9YRrLMCxj5L+Uuc6cIIR116rz8kmQgfy3I+pht5jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oo+as1Vt5yavLqmmjBmuKrZa8mhfLdGp4rpHVpMDEgs=;
 b=ePpc13alwV5PhmGyQAlj5v9Y5MB3Pm2BEJLYfwXreur6J+qXa6gz9QQd/ZsxF57zLmtkv4t4cDGvJBYQG9Bh1/0QI0AYLd0+1w7gGQ8l2XsKuY4NTUmtJD5BF7dMYGM/2uHjxp3D1FVP60aKP1gssKT9FxsUv0w+5t2FFA/LbMjw+EvVmjyNEFddHcxi6o81DukdPs7alNBZKR3acKtfBWgOkShviedBSNyVYb4R6r/Czg/TLpkEfOFTl+mu68P2W2BImBVYXN3XB0m2ZeNf+XP9KHKwel199vgCS3GixCYIhmilhAfb7JxyTBuIB7s9xJUERBA2+0ECA4X5gTBZUA==
Received: from BN6PR1201CA0004.namprd12.prod.outlook.com
 (2603:10b6:405:4c::14) by MN2PR12MB4157.namprd12.prod.outlook.com
 (2603:10b6:208:1db::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Tue, 9 Mar
 2021 14:19:08 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::a8) by BN6PR1201CA0004.outlook.office365.com
 (2603:10b6:405:4c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Tue, 9 Mar 2021 14:19:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 14:19:08 +0000
Received: from [172.27.12.237] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 14:19:01 +0000
Subject: Re: [RFC] devlink: health: add remediation type
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        <eranbe@mellanox.com>
References: <20210306024220.251721-1-kuba@kernel.org>
 <3d7e75bb-311d-ccd3-6852-cae5c32c9a8e@nvidia.com>
 <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <25fb28f1-03f9-8307-8d9b-22f81f94dfcd@nvidia.com>
Date:   Tue, 9 Mar 2021 16:18:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308091600.5f686fcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7645018d-ecc6-49b8-36b3-08d8e3064d8c
X-MS-TrafficTypeDiagnostic: MN2PR12MB4157:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4157AB06BA7D84E6FC5C52FCB7929@MN2PR12MB4157.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dj5m9fUg1KJvmqq/yMLMcKeiphQn3Vn12VG2rwkuyA1Vxm5s2wlKg/oS0BaeQEfGp3J5goh9NDJf8bYGXYdLlXVX9gUnyoL/6tb2B83Z8ouRR7fN1LCBFdUgkFSEkDs8BlSGDuE5utudJF4wW9BIqKDvlRYmT0VmvZzFT2txIe1TXXc6oiYhjf0WmHsg8oS8X7HB4e5tPb9PXATpDBPCatLBdba7jY/++McrNbs8bb1ZEfNmdUUBcnCg5cKQzqdKy3192RolcLPx0YmqnGM/2aCFLtd3Pww4FNWmi54rBJhbo4LA07/EgcOkEnHxMmEKsCMIjv1544OIYiZaTqvDjF/3BwKIfpoQFiFWtHzTwaTzNwwszbCgLLL9wIF46L7/cVSluQvgJxjkMXQ/m2omRv2uxRspWWNCMW/rYzIGeull3HW04YoqdaYXCdGyF0F5ZV2Ag3clhnMsYZDlczX4KZUTaIymJZXK1+hg07Xvocxu+QEI7x0bn2pLQQW+AgP2wTDufRl0ARDCd9hLt+KNcurDd9z/Nz8agdb5msH2Ipjvzd1Zq+6FlN6OSlD74YgH1acxFCX6o/L+9t2XR0DWLLMp62ZMIS2kL8mlbBWnof13i1iN4KwW1+cWw/ogpAAhfK1VnFi/uvj/6WeiVexHRyKToucVkrvebjyGeGgW0Bk2f5fIbGyP67SZXqJAuhebrJVEKie+BQiS/feMHZymWr8uD4rSopc3mveDNr/FWQwbWiW9RYG5KBomR23o/CEU
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(36840700001)(36756003)(356005)(31686004)(316002)(86362001)(186003)(34020700004)(53546011)(7636003)(82310400003)(54906003)(336012)(6916009)(31696002)(83380400001)(426003)(2616005)(5660300002)(107886003)(82740400003)(70586007)(70206006)(26005)(36906005)(4326008)(2906002)(16526019)(47076005)(8936002)(36860700001)(8676002)(6666004)(478600001)(16576012)(43740500002)(134885004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 14:19:08.1669
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7645018d-ecc6-49b8-36b3-08d8e3064d8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4157
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/2021 7:16 PM, Jakub Kicinski wrote:
> On Sun, 7 Mar 2021 17:59:58 +0200 Eran Ben Elisha wrote:
>> On 3/6/2021 4:42 AM, Jakub Kicinski wrote:
>>> Currently devlink health does not give user any clear information
>>> of what kind of remediation ->recover callback will perform. This
>>> makes it difficult to understand the impact of enabling auto-
>>> -remediation, and the severity of the error itself.
>>>
>>> To allow users to make more informed decision, as well as stretch
>>> the applicability of devlink health beyond what can be fixed by
>>> resetting things - add a new remediation type attribute.
>>>
>>> Note that we only allow one remediation type per reporter, this
>>> is intentional. devlink health is not built for mixing issues
>>> of different severity into one reporter since it only maintains
>>> one dump, of the first event and a single error counter.
>>> Nudging vendors towards categorizing issues beyond coarse
>>> groups is an added bonus.
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>>    include/net/devlink.h        |  2 ++
>>>    include/uapi/linux/devlink.h | 30 ++++++++++++++++++++++++++++++
>>>    net/core/devlink.c           |  7 +++++--
>>>    3 files changed, 37 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>>> index 853420db5d32..70b5fd6a8c0d 100644
>>> --- a/include/net/devlink.h
>>> +++ b/include/net/devlink.h
>>> @@ -664,6 +664,7 @@ enum devlink_health_reporter_state {
>>>    /**
>>>     * struct devlink_health_reporter_ops - Reporter operations
>>>     * @name: reporter name
>>> + * remedy: severity of the remediation required
>>>     * @recover: callback to recover from reported error
>>>     *           if priv_ctx is NULL, run a full recover
>>>     * @dump: callback to dump an object
>>> @@ -674,6 +675,7 @@ enum devlink_health_reporter_state {
>>>    
>>>    struct devlink_health_reporter_ops {
>>>    	char *name;
>>> +	enum devlink_health_reporter_remedy remedy;
>>>    	int (*recover)(struct devlink_health_reporter *reporter,
>>>    		       void *priv_ctx, struct netlink_ext_ack *extack);
>>>    	int (*dump)(struct devlink_health_reporter *reporter,
>>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>>> index f6008b2fa60f..bd490c5536b1 100644
>>> --- a/include/uapi/linux/devlink.h
>>> +++ b/include/uapi/linux/devlink.h
>>> @@ -534,6 +534,9 @@ enum devlink_attr {
>>>    	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
>>>    
>>>    	DEVLINK_ATTR_PORT_PCI_SF_NUMBER,	/* u32 */
>>> +
>>> +	DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,	/* u32 */
>>> +
>>>    	/* add new attributes above here, update the policy in devlink.c */
>>>    
>>>    	__DEVLINK_ATTR_MAX,
>>> @@ -608,4 +611,31 @@ enum devlink_port_fn_opstate {
>>>    	DEVLINK_PORT_FN_OPSTATE_ATTACHED,
>>>    };
>>>    
>>> +/**
>>> + * enum devlink_health_reporter_remedy - severity of remediation procedure
>>> + * @DLH_REMEDY_NONE: transient error, no remediation required
>> DLH_REMEDY_LOCAL_FIX: associated component will undergo a local
>> un-harmful fix attempt.
>> (e.g look for lost interrupt in mlx5e_tx_reporter_timeout_recover())
> 
> Should we make it more specific? Maybe DLH_REMEDY_STALL: device stall
> detected, resumed by re-trigerring processing, without reset?

Sounds good.

> 
>>> + * @DLH_REMEDY_COMP_RESET: associated device component (e.g. device queue)
>>> + *			will be reset
>>> + * @DLH_REMEDY_RESET: full device reset, will result in temporary unavailability
>>> + *			of the device, device configuration should not be lost
>>> + * @DLH_REMEDY_REINIT: device will be reinitialized and configuration lost
>>> + * @DLH_REMEDY_POWER_CYCLE: device requires a power cycle to recover
>>> + * @DLH_REMEDY_REIMAGE: device needs to be reflashed
>>> + * @DLH_REMEDY_BAD_PART: indication of failing hardware, device needs to be
>>> + *			replaced
>>> + *
>>> + * Used in %DEVLINK_ATTR_HEALTH_REPORTER_REMEDY, categorizes the health reporter
>>> + * by the severity of the required remediation, and indicates the remediation
>>> + * type to the user if it can't be applied automatically (e.g. "reimage").
>>> + */
>> The assumption here is that a reporter's recovery function has one
>> remedy. But it can have few remedies and escalate between them. Did you
>> consider a bitmask?
> 
> Yes, I tried to explain in the commit message. If we wanted to support
> escalating remediations we'd also need separate counters etc. I think
> having a health reporter per remediation should actually work fairly
> well.

That would require reporter's recovery procedure failure to trigger 
health flow for other reporter.
So we can find ourselves with 2 RX reporters, sharing the same diagnose 
and dump callbacks, and each has other recovery flow.
Seems a bit counterintuitive.

Maybe, per reporter, exposing a counter per each supported remedy is not 
that bad?

> 
> The major case where escalations would be immediately useful would be
> cases where normal remediation failed therefore we need a hard reset.
> But in those cases I think having the health reporter in a failed state
> should be a sufficient indication to automation to take a machine out
> of service and power cycle it.
> 
>>> +enum devlink_health_reporter_remedy {
>>> +	DLH_REMEDY_NONE = 1,
>>> +	DLH_REMEDY_COMP_RESET,
>>> +	DLH_REMEDY_RESET,
>>> +	DLH_REMEDY_REINIT,
>>> +	DLH_REMEDY_POWER_CYCLE,
>>> +	DLH_REMEDY_REIMAGE,
>> In general, I don't expect a reported to perform POWER_CYCLE or REIMAGE
>> as part of the recovery.
> 
> Right, these are extending the use of health reporters beyond what can
> be remediated automatically.
> 
>>> +	DLH_REMEDY_BAD_PART,
>> BAD_PART probably indicates that the reporter (or any command line
>> execution) cannot recover the issue.
>> As the suggested remedy is static per reporter's recover method, it
>> doesn't make sense for one to set a recover method that by design cannot
>> recover successfully.
>>
>> Maybe we should extend devlink_health_reporter_state with POWER_CYCLE,
>> REIMAGE and BAD_PART? To indicate the user that for a successful
>> recovery, it should run a non-devlink-health operation?
> 
> Hm, export and extend devlink_health_reporter_state? I like that idea.
> 
>>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>>> index 737b61c2976e..73eb665070b9 100644
>>> --- a/net/core/devlink.c
>>> +++ b/net/core/devlink.c
>>> @@ -6095,7 +6095,8 @@ __devlink_health_reporter_create(struct devlink *devlink,
>>>    {
>>>    	struct devlink_health_reporter *reporter;
>>>    
>>> -	if (WARN_ON(graceful_period && !ops->recover))
>>> +	if (WARN_ON(graceful_period && !ops->recover) ||
>>> +	    WARN_ON(!ops->remedy))
>> Here you fail every reported that doesn't have remedy set, not only the
>> ones with recovery callback
> 
> Right, DLH_REMEDY_NONE doesn't require a callback. Some health
> issues can be remedied by the device e.g. ECC errors or something
> along those lines. Obviously non-RFC patch will have to come with
> driver changes.
> 
>>>    		return ERR_PTR(-EINVAL);
>>>    
>>>    	reporter = kzalloc(sizeof(*reporter), GFP_KERNEL);
>>> @@ -6263,7 +6264,9 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>>>    	if (!reporter_attr)
>>>    		goto genlmsg_cancel;
>>>    	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
>>> -			   reporter->ops->name))
>>> +			   reporter->ops->name) ||
>>> +	    nla_put_u32(msg, DEVLINK_ATTR_HEALTH_REPORTER_REMEDY,
>>> +			reporter->ops->remedy))
>> Why not new if clause like all other attributes later.
> 
> Eh.
> 
Currently, each nla_put_* is under its own if clause.

>>>    		goto reporter_nest_cancel;
>>>    	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
>>>    		       reporter->health_state))
>>>    
> 
