Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9258C4450E2
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 10:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhKDJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 05:10:05 -0400
Received: from mail-bn8nam11on2051.outbound.protection.outlook.com ([40.107.236.51]:35808
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230335AbhKDJKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 05:10:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2an/IoXMcrj9l3hrg8oTwCQNKH482bUSPWUx7Z6+dwUAvzjTPQuKtLNjnwRPAjJAMgjp6oKs+94Ky532BlmY6c/0iS0JdNnOHXHIIrgrxOazfmDezpwSK04Zu5aMDLaF+nbkIBrlnV0tsnPQ08FjqKAj8H+W4W8YiYxknm0k+lTtJJLvDhJIXRFY/HInpPSJPglvjFDnCwxjZJLPZnvgxCAMxs+KlbzHINuMIFnxyZpzscIQRlTUoFtbJH9FcSgDReWq+TliUhVqmPi2udETh0mRXZbaNnOslJCiD5DmtNTI4T8K7nfoQbb+6e1LpoGAleLOhCBvVPlZr5qc9sXuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lc+p+O2M/DVM32jk0aXCA92OXbDOhEAq/raFKMTjcY=;
 b=ih9OT0alUcg68nD4cegIl9kutYri0PBgrqrE0AJFc5jJfKMjU8MBl5CpREZNv6G9ijVM5ziZOt+HBVqg7r+GkPMoo9Kcl5eubLzymIwrOxZETlUfYMXBeN+1PZJU8V3bfpC7KpsQHV5Com03cR366JQlU3VEu6wTm4qB/vST2ZqWmVLtpXyf95HIdp5/r7F73Dq4ua3wwB2rl1z/Zkk4T3FY/sFB6RZBktJ6V3QdVanhb12whjayf3x1byA3+pcR9LQbMrbcz9gALYV2oqCVkOpG+6z+BIK9/RPsCeRNqLN9xY/44Tn9L7vYLjCqXE6Vf82J4BrRq+ZGIxHyX0PVVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lc+p+O2M/DVM32jk0aXCA92OXbDOhEAq/raFKMTjcY=;
 b=V8JCuLygqJ02kwCMQOsBIy+eHf6/9lUmU0Z4uRJh2m7CJ/gMWwrcUYQYrSXjcEBVDVZj+hv3EVawM+0Ox5OFJiRU4sz+GfO2/a84YN24XP2OuEmEmTJfdAIOc04TebMmpf5k1SOuNdiEuhO5vg5Xox3JQM+ms+JvVBblUM/OHEZZu0TKIbw7I3SLrSlnuq6kYsDCy+wMK1ltsS7E0nuHjJh/jsJenA5JqC62PhEx6Jnl3yqBRTXyIed338Eilyw0EEJZRWQXs//hbPdtpWJ4kBNStnyVFjl2dtpgYB/IAsMkuDPjlOKBLu6Lpyf+q21ufmsgo/wKGWFisD8xP2cm+w==
Received: from BN6PR2001CA0016.namprd20.prod.outlook.com
 (2603:10b6:404:b4::26) by CY4PR12MB1944.namprd12.prod.outlook.com
 (2603:10b6:903:127::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Thu, 4 Nov
 2021 09:07:23 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::7a) by BN6PR2001CA0016.outlook.office365.com
 (2603:10b6:404:b4::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend
 Transport; Thu, 4 Nov 2021 09:07:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 09:07:22 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Thu, 4 Nov 2021 09:07:16 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <DM5PR1301MB21722934E954B577033F0F56E78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <DM5PR1301MB2172E10FBDD2EA06E156BEDDE78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Baowen Zheng <baowen.zheng@corigine.com>
CC:     Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
In-Reply-To: <DM5PR1301MB2172E10FBDD2EA06E156BEDDE78D9@DM5PR1301MB2172.namprd13.prod.outlook.com>
Date:   Thu, 4 Nov 2021 11:07:13 +0200
Message-ID: <ygnhsfwc8f26.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39833eab-4f98-4706-1a61-08d99f72834f
X-MS-TrafficTypeDiagnostic: CY4PR12MB1944:
X-Microsoft-Antispam-PRVS: <CY4PR12MB194485AAF9A33CC9398314E8A08D9@CY4PR12MB1944.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DnlBf+6EggDfZD5IUKKPIHrI0FDro/niAdYWjppTzCvUFR4mRc7s+FoS1Xp31YX3vZ0ClVFMq/WSaltsC7R7jqOo2WRECBkBzRHCGlRMi59BSTWzP9YfDBokWzwvXMzfV7sMXjN9/c9WaHwy91lU54BBkzjDM01L3ZJu/kmCxjbOhoI4AWA7NbFQLfuxCq3LxTxGhN0Tonrwu/duFhnkvQ/+c0djUiJ6+nvDsFG9YXPEWerzEdF9+WgOKLjWlbAObjdUKYk3J7xUfKo/dp3C1x3RXt+uBccmALSJPGh8Eg06LPmcFLpifyFMw3vt65A8VbeFDT9a3zUhU7WfnEYfKcfHUAilsSlVWhIzk3Og4l7JakpiVYWxlDLBS+9j7P8QpeKFCU7I3YPjXe7lTO86u+jxLAms25Bo/p8e24cYV0YG6R1TKspq0bJSWUsTSzHl+HaMJiPtqNOo8Zn7papyr8GFJd8OO+OBSgTf3dbKlwNYBn0lOOrhIo2P/za01HuS+IKYv32oVdlnHxt1dI20XYDqdVHV5aS77yBgiy5Osji+QpsC5IKqIj73+zlbaRwNReDad6FdbJ80+UZpI7jE7MuFgkvWClgH6IgMRjxHhWdfd1OqMEukQgexPg1n/bQwdsIrPxTpW2dpHr5C5yq+5NObh4TcqN0WZS7zyvMf+tbkegvbNQj9G9BJohIEm0LW+wAIaNhlzARbToIDD+Zq3w==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(83380400001)(6666004)(70206006)(7636003)(15650500001)(16526019)(70586007)(47076005)(336012)(26005)(426003)(54906003)(4326008)(8676002)(8936002)(316002)(36860700001)(86362001)(2906002)(6916009)(508600001)(5660300002)(36756003)(82310400003)(7696005)(186003)(356005)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 09:07:22.4335
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39833eab-4f98-4706-1a61-08d99f72834f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1944
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 04 Nov 2021 at 07:51, Baowen Zheng <baowen.zheng@corigine.com> wrote:
> Sorry for reply this message again.
> On November 4, 2021 10:31 AM, Baowen Zheng wrote:
>>Thanks for your review and sorry for delay in responding.
>>On October 30, 2021 2:01 AM, Vlad Buslov wrote:
>>>On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com>
>>>wrote:
>>>> From: Baowen Zheng <baowen.zheng@corigine.com>
>>>>
>>>> Add process to validate flags of filter and actions when adding a tc
>>>> filter.
>>>>
>>>> We need to prevent adding filter with flags conflicts with its actions.
>>>>
>>>> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>>>> Signed-off-by: Louis Peens <louis.peens@corigine.com>
>>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>>> ---
>>>>  net/sched/cls_api.c      | 26 ++++++++++++++++++++++++++
>>>>  net/sched/cls_flower.c   |  3 ++-
>>>>  net/sched/cls_matchall.c |  4 ++--
>>>>  net/sched/cls_u32.c      |  7 ++++---
>>>>  4 files changed, 34 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c index
>>>> 351d93988b8b..80647da9713a 100644
>>>> --- a/net/sched/cls_api.c
>>>> +++ b/net/sched/cls_api.c
>>>> @@ -3025,6 +3025,29 @@ void tcf_exts_destroy(struct tcf_exts *exts)
>>>> } EXPORT_SYMBOL(tcf_exts_destroy);
>>>>
>>>> +static bool tcf_exts_validate_actions(const struct tcf_exts *exts,
>>>> +u32 flags) { #ifdef CONFIG_NET_CLS_ACT
>>>> +	bool skip_sw = tc_skip_sw(flags);
>>>> +	bool skip_hw = tc_skip_hw(flags);
>>>> +	int i;
>>>> +
>>>> +	if (!(skip_sw | skip_hw))
>>>> +		return true;
>>>> +
>>>> +	for (i = 0; i < exts->nr_actions; i++) {
>>>> +		struct tc_action *a = exts->actions[i];
>>>> +
>>>> +		if ((skip_sw && tc_act_skip_hw(a->tcfa_flags)) ||
>>>> +		    (skip_hw && tc_act_skip_sw(a->tcfa_flags)))
>>>> +			return false;
>>>> +	}
>>>> +	return true;
>>>> +#else
>>>> +	return true;
>>>> +#endif
>>>> +}
>>>> +
>>>
>>>I know Jamal suggested to have skip_sw for actions, but it complicates
>>>the code and I'm still not entirely understand why it is necessary.
>>>After all, action can only get applied to a packet if the packet has
>>>been matched by some filter and filters already have skip sw/hw
>>>controls. Forgoing action skip_sw flag would:
>>>
>>>- Alleviate the need to validate that filter and action flags are compatible.
>>>(trying to offload filter that points to existing skip_hw action would
>>>just fail because the driver wouldn't find the action with provided id
>>>in its tables)
>>>
>>>- Remove the need to add more conditionals into TC software data path
>>>in patch 4.
>>>
>>>WDYT?
>>As we discussed with Jamal, we will keep the flag of skip_sw and we need to
>>make exactly match for the actions with flags and the filter specific action with
>>index.
>>>
>>>>  int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr
>>**tb,
>>>>  		      struct nlattr *rate_tlv, struct tcf_exts *exts,
>>>>  		      u32 flags, struct netlink_ext_ack *extack) @@ -3066,6
>>>+3089,9
>>>> @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp,
>>>> struct nlattr
>>>**tb,
>>>>  				return err;
>>>>  			exts->nr_actions = err;
>>>>  		}
>>>> +
>>>> +		if (!tcf_exts_validate_actions(exts, flags))
>>>> +			return -EINVAL;
>>>>  	}
>>>>  #else
>>>>  	if ((exts->action && tb[exts->action]) || diff --git
>>>> a/net/sched/cls_flower.c b/net/sched/cls_flower.c index
>>>> eb6345a027e1..55f89f0e393e 100644
>>>> --- a/net/sched/cls_flower.c
>>>> +++ b/net/sched/cls_flower.c
>>>> @@ -2035,7 +2035,8 @@ static int fl_change(struct net *net, struct
>>>> sk_buff
>>>*in_skb,
>>>>  	}
>>>>
>>>>  	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
>>>> -			   tp->chain->tmplt_priv, flags, extack);
>>>> +			   tp->chain->tmplt_priv, flags | fnew->flags,
>>>> +			   extack);
>>>
>>>Aren't you or-ing flags from two different ranges (TCA_CLS_FLAGS_* and
>>>TCA_ACT_FLAGS_*) that map to same bits, or am I missing something? This
>>>isn't explained in commit message so it is hard for me to understand
>>>the idea here.
>>Yes, as you said we use TCA_CLS_FLAGS_* or TCA_ACT_FLAGS_* flags to
>>validate the action flags.
>>As you know, the TCA_ACT_FLAGS_* in flags are system flags(in high 16 bits)
>>and the TCA_CLS_FLAGS_* are user flags(in low 16 bits), so they will not be
>>conflict.

Indeed, currently available TCA_CLS_FLAGS_* fit into first 16 bits, but
the field itself is 32 bits and with addition of more flags in the
future higher bits may start to be used since TCA_CLS_FLAGS_* and
TCA_ACT_FLAGS_* are independent sets.

>>But I think you suggestion also makes sense to us, do you think we need to
>>pass a single filter flag to make the process more clear?
> After consideration, I think it is better to separate CLS flags and ACT flags. 
> So we will pass CLS flags as a separate flags, thanks.

Please also validate inside tcf_action_init() instead of creating new
tcf_exts_validate_actions() function, if possible. I think this will
lead to cleaner and more simple code.

>>>
>>>>  	if (err)
>>>>  		goto errout;
>>>>
>>>> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
>>>> index 24f0046ce0b3..00b76fbc1dce 100644
>>>> --- a/net/sched/cls_matchall.c
>>>> +++ b/net/sched/cls_matchall.c
>>>> @@ -226,8 +226,8 @@ static int mall_change(struct net *net, struct
>>>> sk_buff
>>>*in_skb,
>>>>  		goto err_alloc_percpu;
>>>>  	}
>>>>
>>>> -	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
>>>> -			     extack);
>>>> +	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
>>>> +			     flags | new->flags, extack);
>>>>  	if (err)
>>>>  		goto err_set_parms;
>>>>
>>>> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c index
>>>> 4272814487f0..fc670cc45122 100644
>>>> --- a/net/sched/cls_u32.c
>>>> +++ b/net/sched/cls_u32.c
>>>> @@ -895,7 +895,8 @@ static int u32_change(struct net *net, struct
>>>> sk_buff
>>>*in_skb,
>>>>  			return -ENOMEM;
>>>>
>>>>  		err = u32_set_parms(net, tp, base, new, tb,
>>>> -				    tca[TCA_RATE], flags, extack);
>>>> +				    tca[TCA_RATE], flags | new->flags,
>>>> +				    extack);
>>>>
>>>>  		if (err) {
>>>>  			u32_destroy_key(new, false);
>>>> @@ -1060,8 +1061,8 @@ static int u32_change(struct net *net, struct
>>>sk_buff *in_skb,
>>>>  	}
>>>>  #endif
>>>>
>>>> -	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], flags,
>>>> -			    extack);
>>>> +	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE],
>>>> +			    flags | n->flags, extack);
>>>>  	if (err == 0) {
>>>>  		struct tc_u_knode __rcu **ins;
>>>>  		struct tc_u_knode *pins;

