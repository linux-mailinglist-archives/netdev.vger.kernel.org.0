Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D4D4401A3
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 20:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhJ2SDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 14:03:43 -0400
Received: from mail-dm3nam07on2046.outbound.protection.outlook.com ([40.107.95.46]:14304
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229498AbhJ2SDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 14:03:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwL/GIA3ftngI/r9D6V7tQiLRIahGOZ4SvTE82lev/PC90EYK5GMFD0tqh+p96y0FMpW0tUUOZe8uE949pP6HsKEYbHVPiB/1CpIlcRyXTrAwH1Bki0uiPilzY+bJ1KWcZxQdNwcz+3DVEo79qEZd9+WDH7vTYf1OLBystX1ROFZii8+ePNgPuZ6efa7ATWolI9DnGFxAwLV6toISCUS+1KRlEc1Tnd9c2IYJwWmazZOVAFveHPw6Lu6nVyENfh7T9hZnXvPK62sUAGeTu/UpM5MNS7eGRM72v27bPPCthjoYiwMtiF32ZPK6ghWxSMwQq+RlbvP9dGv28nGJrB1gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxk8r8+k6mYAux6h6gU3/6EtVgUgoUfUGBFVNGFSwvE=;
 b=Kvf7vZf9Py0NM5Gn7DkWIg4kWucyxgo65lI87b0lmH8S2T0LeNO3Mk9AJSTMBPQ8CUt+S3FlLknCSLFe23zmR1fWYNY+CCldA3s+52QD4U5OZs4Y+5Yp1jZe8ftq7zI7tYBwKz+PYMOGOaicFK1pmLkU3KiqDS0cEQOJyhygz3xpYu6LAQq4GipN95WTGT4Ct2PVEFlaZdsqXRsZCvWicmz4EzurUjFeCz4dq5qDi3nGJWm608mwWBTVv4dT7aC001hbln06gCYcgbCSmaxwJCxNbINS4R+jDYxJNNr8HHoXkZQfNG96nLTVI9Jo0gb7kRNJSOdwotaYYzKUK0KAcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxk8r8+k6mYAux6h6gU3/6EtVgUgoUfUGBFVNGFSwvE=;
 b=N1HlpCSavjYAIyAIG+Of/L9mmNTgKpewe4Tqu4MFxRL/SOjKtmKwX7X9jG0glXPBi3f1KBJCqeYce/LPaTflDTFetA5OSewH6W4K+uIu1CIIQpIpA/A1O1fIL1DpOaDutCmuw9nd9WnCKYKmDGQRZgqELUIKeFJIQJ5gPb2QrdhD2fEJLWhKt9VFzurDiV1w8qljfbTkIjdkRQ88VkjTbnXHjqabjrmb8ET6qmxgm5syzED29df2lVq92USKXzeJI7J0zQGLn00jfvtmkOUZU6rlfT63F/62gHAGDlNznsRhPQAJM6cFNN7VXN5rJy/DIgk0152a7o4jr6SSe7962Q==
Received: from BN9P223CA0012.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::17)
 by BN9PR12MB5290.namprd12.prod.outlook.com (2603:10b6:408:103::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 18:01:12 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::c7) by BN9P223CA0012.outlook.office365.com
 (2603:10b6:408:10b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend
 Transport; Fri, 29 Oct 2021 18:01:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 18:01:11 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 29 Oct 2021 18:01:08 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
In-Reply-To: <20211028110646.13791-9-simon.horman@corigine.com>
Date:   Fri, 29 Oct 2021 21:01:05 +0300
Message-ID: <ygnhilxfaexq.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08edf664-7602-42b7-c403-08d99b0617c9
X-MS-TrafficTypeDiagnostic: BN9PR12MB5290:
X-Microsoft-Antispam-PRVS: <BN9PR12MB52907F0A7A3D060C2BA4A8FDA0879@BN9PR12MB5290.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EPgJGmGHt4A0asJeaa5NsQ+gkANxz35VBUQIfaKEN0OWs7sikTxcSlvW7FwferzYSX9jvpuEt/KWgsulNvCkgG1ve/FaEFPBdXWI8esAhAajEs9TgeNeWn5jmG6xc4XsTZ3vI5dXNWGhTuypjU20PXjPUqWEH6PGKlmvU1/VaFSO4aJBg56i++5sHiFB/KFIYB6pFntNdwwr56arW/UmBLRrGwqTR4Ky1I9I5yef8ChKI22UKMBiB7PmHP/LX/4qLLK4wFsoVjlx1hM/0PHZ4rD3X8fb4x5ylNnAiT6y9qyACZIWx7ZBmkmdBlkX8Ra9vqPcKnUy05J/3k4IeNcZ8zo2XRsB/OnTfx99uIk3vO+fJHyCTUrf8wDhrEHuh5Bcr5rtlBhY98AtZMhalCV+DqPa0C5ZQQurr2sAV4PAle+nylyaZx5u7DKiSyaJVrE1BfiLqbYv6kr/6taTjRfypvzmqb5cFNEXQ8M91piwAa//fkE7czOQbBo/oFyi2HEf/qQW0wcKWqeU18zdQzPTxO3kuLkbKY/V9fM58xlwQ3Ja+vPAz2KJNvj2rzsQHg1cFgt6MpASRSLmjSXSrrsgeQDUJj16gsXJr81uDhKITdSL2MPrrrsBLrByCDAs6bjKeNdMcCv323dTDU21oHnzUhz89xFGnPc/V0IsYXPj+2zjuZdBqE+uwO2VkzWyHePt8a4zZK2+UIUFgfQ8rLDVViIU9xQHcbZ2TdpACKEN9Qg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7696005)(70586007)(2906002)(6916009)(4326008)(508600001)(70206006)(336012)(316002)(16526019)(36906005)(5660300002)(186003)(8676002)(26005)(54906003)(8936002)(36756003)(47076005)(36860700001)(83380400001)(356005)(82310400003)(7636003)(15650500001)(426003)(2616005)(86362001)(6666004)(4226004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 18:01:11.9124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08edf664-7602-42b7-c403-08d99b0617c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5290
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Add process to validate flags of filter and actions when adding
> a tc filter.
>
> We need to prevent adding filter with flags conflicts with its actions.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  net/sched/cls_api.c      | 26 ++++++++++++++++++++++++++
>  net/sched/cls_flower.c   |  3 ++-
>  net/sched/cls_matchall.c |  4 ++--
>  net/sched/cls_u32.c      |  7 ++++---
>  4 files changed, 34 insertions(+), 6 deletions(-)
>
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 351d93988b8b..80647da9713a 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3025,6 +3025,29 @@ void tcf_exts_destroy(struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_destroy);
>  
> +static bool tcf_exts_validate_actions(const struct tcf_exts *exts, u32 flags)
> +{
> +#ifdef CONFIG_NET_CLS_ACT
> +	bool skip_sw = tc_skip_sw(flags);
> +	bool skip_hw = tc_skip_hw(flags);
> +	int i;
> +
> +	if (!(skip_sw | skip_hw))
> +		return true;
> +
> +	for (i = 0; i < exts->nr_actions; i++) {
> +		struct tc_action *a = exts->actions[i];
> +
> +		if ((skip_sw && tc_act_skip_hw(a->tcfa_flags)) ||
> +		    (skip_hw && tc_act_skip_sw(a->tcfa_flags)))
> +			return false;
> +	}
> +	return true;
> +#else
> +	return true;
> +#endif
> +}
> +

I know Jamal suggested to have skip_sw for actions, but it complicates
the code and I'm still not entirely understand why it is necessary.
After all, action can only get applied to a packet if the packet has
been matched by some filter and filters already have skip sw/hw
controls. Forgoing action skip_sw flag would:

- Alleviate the need to validate that filter and action flags are
compatible. (trying to offload filter that points to existing skip_hw
action would just fail because the driver wouldn't find the action with
provided id in its tables)

- Remove the need to add more conditionals into TC software data path in
patch 4.

WDYT?

>  int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
>  		      struct nlattr *rate_tlv, struct tcf_exts *exts,
>  		      u32 flags, struct netlink_ext_ack *extack)
> @@ -3066,6 +3089,9 @@ int tcf_exts_validate(struct net *net, struct tcf_proto *tp, struct nlattr **tb,
>  				return err;
>  			exts->nr_actions = err;
>  		}
> +
> +		if (!tcf_exts_validate_actions(exts, flags))
> +			return -EINVAL;
>  	}
>  #else
>  	if ((exts->action && tb[exts->action]) ||
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index eb6345a027e1..55f89f0e393e 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -2035,7 +2035,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
>  	}
>  
>  	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE],
> -			   tp->chain->tmplt_priv, flags, extack);
> +			   tp->chain->tmplt_priv, flags | fnew->flags,
> +			   extack);

Aren't you or-ing flags from two different ranges (TCA_CLS_FLAGS_* and
TCA_ACT_FLAGS_*) that map to same bits, or am I missing something? This
isn't explained in commit message so it is hard for me to understand the
idea here.

>  	if (err)
>  		goto errout;
>  
> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
> index 24f0046ce0b3..00b76fbc1dce 100644
> --- a/net/sched/cls_matchall.c
> +++ b/net/sched/cls_matchall.c
> @@ -226,8 +226,8 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
>  		goto err_alloc_percpu;
>  	}
>  
> -	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
> -			     extack);
> +	err = mall_set_parms(net, tp, new, base, tb, tca[TCA_RATE],
> +			     flags | new->flags, extack);
>  	if (err)
>  		goto err_set_parms;
>  
> diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
> index 4272814487f0..fc670cc45122 100644
> --- a/net/sched/cls_u32.c
> +++ b/net/sched/cls_u32.c
> @@ -895,7 +895,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>  			return -ENOMEM;
>  
>  		err = u32_set_parms(net, tp, base, new, tb,
> -				    tca[TCA_RATE], flags, extack);
> +				    tca[TCA_RATE], flags | new->flags,
> +				    extack);
>  
>  		if (err) {
>  			u32_destroy_key(new, false);
> @@ -1060,8 +1061,8 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
>  	}
>  #endif
>  
> -	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE], flags,
> -			    extack);
> +	err = u32_set_parms(net, tp, base, n, tb, tca[TCA_RATE],
> +			    flags | n->flags, extack);
>  	if (err == 0) {
>  		struct tc_u_knode __rcu **ins;
>  		struct tc_u_knode *pins;

