Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAAE440101
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhJ2ROE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:14:04 -0400
Received: from mail-mw2nam12on2085.outbound.protection.outlook.com ([40.107.244.85]:58598
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229782AbhJ2ROD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:14:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJodpRo1kmgVmokQu/iC+/zuDUyNqWtFJdmSxhN2k86j22HsQR/41yriBjjwDxeFmsph3AjGtqwPr2RO0JcartHcfKua2hxfZEgtILd0s7GqUeBTmOobRonZlf9UPsitB3FHq1Eo2Lzd4vaxa1dUNID8LlDRoGRhzbFkxNvVrOaHeSczPST+qY6ql6EtiuCbxYSiN8txi7PpssWz3qzfiyDeryAj9X1cuOQVE/Ki7iuy/u2vOYpz1lEBgO4yLhTwTQL7fhMRLPQ4AfT8XfGs95HLA62V40npi2JMo4D48HBkEiQ148oYJGyu0k6gShDAh6B4P40ZSIp3IREv0lz3Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGlsqjm+cqYri7E990ZsqhWzz/0KvO8f1Eev1jdsyiQ=;
 b=bxbru6FK+FoSjNzknCm5DxTIfu7iUI0dX1WJXwQ8ViecMFUBSySgwDNEvCYByf/P+hrIYyySRORxOfDjdUN6bET/ovx5mVR4VeAWB8ZtOMqvLSgjRokJOAOGIh9KlswnWNWPcyFXuJrail+9wAiQ6rvHx74qMp+rOd+xKF/ol/uYh8HdgLMF8x7J0wLAJsriKLaM0U57fuIAvI1pRcQW7XZcQPlFsgXvP9hyffHxQdBJfkKoFPkmA7Fb805bUd+MnfGzLF1w3f8dEDXjPuV5sx4ILfK/bwLS1ahBqyCAxDSe8JDyfXgXKwVWQCAHjYAINY8iiw5xBmKzstZpxphyNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGlsqjm+cqYri7E990ZsqhWzz/0KvO8f1Eev1jdsyiQ=;
 b=M9SWVSgTF+z8Tq1j/DQ4FC1lWUeRbzIDqjBrkZSI6idRqfeWvQkIRSlrlsbQAXnCSKQkIVM9dyxpH9+1G5FbrbKW7uVrISam27mptw8DL/GbNCQkF2Ug0SYu+gI6ngZhbu6WWOXSKcrPTlJwsx8ihBajhvUnCUQca4ze2CoS4u9V5q72jvqjwQHmMmW8nKS1FtdiXf1FZeesfH2cVAalPRCk9M0sCoMDKHuaO+M8Ongit0JsQNDwGATiZQyRi766l/otzUsQl7f9441hSepbG59VwInb7EUWE+xDL+I89iM0FmeT4FSrh+bDlfsAMKcTLTEqLixyN+jEDW2iK1y78Q==
Received: from DM6PR02CA0165.namprd02.prod.outlook.com (2603:10b6:5:332::32)
 by BL0PR12MB4756.namprd12.prod.outlook.com (2603:10b6:208:8d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 17:11:32 +0000
Received: from DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::ad) by DM6PR02CA0165.outlook.office365.com
 (2603:10b6:5:332::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend
 Transport; Fri, 29 Oct 2021 17:11:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT021.mail.protection.outlook.com (10.13.173.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 17:11:32 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 29 Oct 2021 17:11:23 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-6-simon.horman@corigine.com>
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
Subject: Re: [RFC/PATCH net-next v3 5/8] flow_offload: add process to update
 action stats from hardware
In-Reply-To: <20211028110646.13791-6-simon.horman@corigine.com>
Date:   Fri, 29 Oct 2021 20:11:20 +0300
Message-ID: <ygnho877ah8n.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc9ab45a-e0fb-450a-eff8-08d99aff279e
X-MS-TrafficTypeDiagnostic: BL0PR12MB4756:
X-Microsoft-Antispam-PRVS: <BL0PR12MB475668B62109A54DE4B757F9A0879@BL0PR12MB4756.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5npDx/+00aZndsqqIbuVP7E8eRkpkO09kMyRBr1o+n3n5W57NI8LrLft5Ss3dOYUXHQV792PxXKUpXA8lAUmsseuL2qgGY1SYBHY4UeLHBQ2Cm2MTYsU7cYlwTofB/ACuNjrwjdbzv5OZwDdeJAOA0aqpzhSKuWPtrCOa48TzKctfbiWMEKgrNKO8IF+yubOlkwesvq1pYQSLPxuFaWw1TpGqzouj6uPuG1KQFWviVMxDEZ0PjczHZlepwL1mGs7y38nMZMrLLvW3VTbkbaN0hLC5CJ/5q6arXT4k2cai0nieqSfkHof4l7xaE+yEysZ6lQICuyelMmQeNUxgQXna5ofAxxaGIQg3IEVSCb1WYs6O3OPeSRxPNZASOZzRXpwPSGqoRjLE9L9b+4Lkxf8rWBwNE8KrfG092ehPmk2sQiS9kilFfQN2qAQ03uW4SnhzTwxPWHZ65kvPxea76aDIXljX8seZtG1p40IK0ecUiSoB9I9SXjk2lKmLK8fRs5lLiLqO33XlVUHHeqwvwbZoBDlEhxHJ1XESDn8U/fNR0zUNq2oq2rSv+iz++G9y6wzi7k01TcC2MGJ0giNm9sN+1VCEOFC8SaM3wBOJgxYuFngslCUWd18mmVbOR6E8MkTVga+J4BkF+5q+qqf4BBnyzcmgnHtABTVLfphH11lux4CvMMsLpxFOzXZROjmP4hgSbFqk1Eaenwa1GXLE2NRDw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(316002)(2616005)(26005)(7636003)(186003)(36756003)(86362001)(83380400001)(47076005)(336012)(356005)(426003)(4326008)(54906003)(5660300002)(6916009)(8676002)(82310400003)(36906005)(8936002)(508600001)(2906002)(16526019)(7696005)(70206006)(36860700001)(15650500001)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 17:11:32.0092
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9ab45a-e0fb-450a-eff8-08d99aff279e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4756
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> When collecting stats for actions update them using both
> both hardware and software counters.
>
> Stats update process should not in context of preempt_disable.

I think you are missing a word here.

>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/act_api.h |  1 +
>  include/net/pkt_cls.h | 18 ++++++++++--------
>  net/sched/act_api.c   | 37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 48 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 671208bd27ef..80a9d1e7d805 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -247,6 +247,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>  			     u64 drops, bool hw);
>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
>  int tcf_action_offload_del(struct tc_action *action);
> +int tcf_action_update_hw_stats(struct tc_action *action);
>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct tcf_chain **handle,
>  			     struct netlink_ext_ack *newchain);
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 44ae5182a965..88788b821f76 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -292,18 +292,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
>  #ifdef CONFIG_NET_CLS_ACT
>  	int i;
>  
> -	preempt_disable();
> -
>  	for (i = 0; i < exts->nr_actions; i++) {
>  		struct tc_action *a = exts->actions[i];
>  
> -		tcf_action_stats_update(a, bytes, packets, drops,
> -					lastuse, true);
> -		a->used_hw_stats = used_hw_stats;
> -		a->used_hw_stats_valid = used_hw_stats_valid;
> -	}
> +		/* if stats from hw, just skip */
> +		if (tcf_action_update_hw_stats(a)) {
> +			preempt_disable();
> +			tcf_action_stats_update(a, bytes, packets, drops,
> +						lastuse, true);
> +			preempt_enable();
>  
> -	preempt_enable();
> +			a->used_hw_stats = used_hw_stats;
> +			a->used_hw_stats_valid = used_hw_stats_valid;
> +		}
> +	}
>  #endif
>  }
>  
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 604bf1923bcc..881c7ba4d180 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1238,6 +1238,40 @@ static int tcf_action_offload_add(struct tc_action *action,
>  	return err;
>  }
>  
> +int tcf_action_update_hw_stats(struct tc_action *action)
> +{
> +	struct flow_offload_action fl_act = {};
> +	int err = 0;
> +
> +	if (!tc_act_in_hw(action))
> +		return -EOPNOTSUPP;
> +
> +	err = flow_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
> +	if (err)
> +		goto err_out;
> +
> +	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
> +
> +	if (!err && fl_act.stats.lastused) {
> +		preempt_disable();
> +		tcf_action_stats_update(action, fl_act.stats.bytes,
> +					fl_act.stats.pkts,
> +					fl_act.stats.drops,
> +					fl_act.stats.lastused,
> +					true);
> +		preempt_enable();
> +		action->used_hw_stats = fl_act.stats.used_hw_stats;
> +		action->used_hw_stats_valid = true;
> +		err = 0;

Error handling here is slightly convoluted. This line assigns err=0
third time (it is initialized with zero and then we can only get here if
result of tcf_action_offload_cmd() assigned 'err' to zero again).
Considering that error handler in this function is empty we can just
return errors directly as soon as they happen and return zero at the end
of the function.

> +	} else {
> +		err = -EOPNOTSUPP;

Hmm the code can return error here when tcf_action_offload_cmd()
succeeded but 'lastused' is zero. Such behavior will cause
tcf_exts_stats_update() to update action with filter counter values. Is
this the desired behavior when, for example, in filter action list there
is and action that can drop packets followed by some shared action? In
such case 'lastused' can be zero if all packets that filter matched were
dropped by previous action and shared action will be assigned with
filter counter value that includes dropped packets/bytes.

> +	}
> +
> +err_out:
> +	return err;
> +}
> +EXPORT_SYMBOL(tcf_action_update_hw_stats);
> +
>  int tcf_action_offload_del(struct tc_action *action)
>  {
>  	struct flow_offload_action fl_act;
> @@ -1362,6 +1396,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
>  	if (p == NULL)
>  		goto errout;
>  
> +	/* update hw stats for this action */
> +	tcf_action_update_hw_stats(p);
> +
>  	/* compat_mode being true specifies a call that is supposed
>  	 * to add additional backward compatibility statistic TLVs.
>  	 */

