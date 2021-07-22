Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A363D2650
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhGVOSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:18:48 -0400
Received: from mail-dm6nam11on2089.outbound.protection.outlook.com ([40.107.223.89]:46304
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232517AbhGVOPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 10:15:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqvexdJmeSCx+yN5vbaGxlyuiIirNSUxVQMNk2itvEo9sZp98mPvjVeP4Iq4zO96ZTBiKvYSVSYU+5bYuqxnPULEOH+ZvDmoU701kg1jHofcYiMNSPe9GgN+xdCGZE/4ZCgtnbIv7O1TXfY6Yo1uDfzTOPsGHB8HYuG0CV8ohNmgU3STMA/F8g5OppRf2on0UTBSdNVoZWPtMvFglmIHXJ0pi6+frPN+GZ7tgWt7JyEnY28R6NZubzcV3SkRH3FgYxdCmcFQjtHYBCUMZSK2Nrq/v9Ixow9ZLUcBH61VDvpNQ72lI+1dGBV6yjepJWHwcCJEGT16H0xWLGzP2fSHPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tf+l8CUFMRyVGSOARoa8tUWrA+i/zVFkZYfQabsWPU=;
 b=cYov6jSO1Fyk46J1Vi9zwq/BA/N8cJXwJJ9h/K7u9M9v6PVwIQ4dYAeUdgIRM5zcrA+APE1IJiYNoOUBTJCQXBB2aPxWnK8t7B7JVrQJuw/gSiKlA4o2UFj0Pqz6hM8rLmlfWDRTLOF3bp8VItQhs0iCihj7ifPjioJ6pvLj8TTZ5gAwxtl4kczxbPS2z3BBt9y8mqyVTKsEtj/QLLGAvB9rnm3s3f/NhAYcycGkC7YSeuGiB3pY+6i1O9CL/LJyftNz7NZw92t11Lduh1ozpeTKSOKPdsUNdeechauini9idTu0jE4tIspCsehs/38EyWt4WQtfD9G6UYB4OSLnbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tf+l8CUFMRyVGSOARoa8tUWrA+i/zVFkZYfQabsWPU=;
 b=sRxy2NpeYruPThKq67qa8iHgz+kTIhyjGDRW79YmNSnsgZ34qYHAz3HDqDlGHeycQIIzfTIwt7MMgDsYAYbsWdzbZIj+JThvzzJfwmsBFPMmCjeL2JAD2i3DQaztDI4RpSsuFQ6vQN5k8xpsrENTPS4nKie71aF/nQ7uFhIMwo048b/ktz5DMrdRRdf479tp71Ws5BVyk2KrAuVLMcBAdR9TIW9O9pumapkdLnPTFR/5c2wyVrFZDHYI7WPXFGuZqoRMokRSgwi9JsDwRDH4AFfr0Kzkl/se/nCMizrvVxZAzEwedY841DeRiCkn4kxs19YaG92ja6gN5I0l7Ttv5w==
Received: from DM5PR13CA0069.namprd13.prod.outlook.com (2603:10b6:3:117::31)
 by BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Thu, 22 Jul
 2021 14:55:56 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::84) by DM5PR13CA0069.outlook.office365.com
 (2603:10b6:3:117::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Thu, 22 Jul 2021 14:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 14:55:55 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 22 Jul 2021 14:55:52 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-4-simon.horman@corigine.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Louis Peens" <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 3/3] flow_offload: add process to update action
 stats from hardware
In-Reply-To: <20210722091938.12956-4-simon.horman@corigine.com>
Date:   Thu, 22 Jul 2021 17:55:49 +0300
Message-ID: <ygnhczraqtxm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82c4d2c0-0e00-4720-283d-08d94d20cf09
X-MS-TrafficTypeDiagnostic: BY5PR12MB4163:
X-Microsoft-Antispam-PRVS: <BY5PR12MB41633030E1974D8D570FE744A0E49@BY5PR12MB4163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fr92zZc3wBy8azxsYXMKovSXE9TGsEuAUTM0GGHgyHPJCtDd6O1ZdX2urlt3sO2Ek4kwz3q1xIJeEmshgjsYb7WPJKRY+g5f2UTqqoZDn2ko8B0qoo2ac8bnqmhyR/JIX7kyBQOz53QDmtsbeYGdFZGK9JOLQ0R88ATDHTbzgXH800ncqHnrcwr7aHBPWRCAutIyQ9iL3v1U3Lp8FDghYWGs0D8pOYsOHF3L+/E9fdm68ec2MUrkRmmDdJwIU8l/Dxh9Npqt5ANCWqjGTRLa64QKSYi1qHBddC52WaeaP/sjJsUjRnnoUvxpvluklz910xqHgfUWVGCDH/GgMxpHhMO684Qkmul8oi2AekOvW1CGLXYyFEf7M6yxKDt3Sk+CIB/WED5/Xnz5JxDSeIDNjCOBL+i/cvg6ODKeJ+0MqrJEstfbwrSfObsEN1llT+LgtzzVRun1z/R2BS1W7U2dnIl/0mi9a6ph30FsdZg21drMu7ozhkMnmgslP38jbmR9fJ+60m3Hn2+HQ8NIgZOfgLcyaNCfH0DIGWVtYbHF8Pwcbm2SAq+Iz9e99KVPXd8DoMYli9BI78pn4Ci1ryvq3M+KmL9pJ4aswmG7F1MP6TzFSZfy4bo59m9XyTw64Q/ZXp5mZyCD8zoYE8hatmFo1lJvLNuGXIhZ/yBnE3lKTZ4Lib/eIQ+mQElmEp2Vvhjnijpdw1OJDzi2dHc4sGHuc2Ekne/9ELdBAI7YltU64QE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(46966006)(36840700001)(36860700001)(356005)(186003)(478600001)(82310400003)(336012)(8936002)(7636003)(6916009)(7696005)(16526019)(26005)(15650500001)(4326008)(83380400001)(36756003)(47076005)(8676002)(2616005)(2906002)(86362001)(82740400003)(426003)(6666004)(316002)(5660300002)(70586007)(70206006)(54906003)(4226004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 14:55:55.6352
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c4d2c0-0e00-4720-283d-08d94d20cf09
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 22 Jul 2021 at 12:19, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> When collecting stats for actions update them using both
> both hardware and software counters.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/act_api.h      |  1 +
>  include/net/flow_offload.h |  2 +-
>  include/net/pkt_cls.h      |  4 ++++
>  net/sched/act_api.c        | 49 ++++++++++++++++++++++++++++++++++----
>  4 files changed, 51 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 086b291e9530..fe8331b5efce 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -233,6 +233,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
>  void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>  			     u64 drops, bool hw);
>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
> +int tcf_action_update_hw_stats(struct tc_action *action);
>  
>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct tcf_chain **handle,
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 26644596fd54..467688fff7ce 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -560,7 +560,7 @@ enum flow_act_command {
>  };
>  
>  struct flow_offload_action {
> -	struct netlink_ext_ack *extack;
> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
>  	enum flow_act_command command;
>  	struct flow_stats stats;
>  	struct flow_action action;
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 03dae225d64f..569c9294b15b 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -282,6 +282,10 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
>  	for (i = 0; i < exts->nr_actions; i++) {
>  		struct tc_action *a = exts->actions[i];
>  
> +		/* if stats from hw, just skip */
> +		if (!tcf_action_update_hw_stats(a))
> +			continue;
> +

Is it okay to call this inside preempt disable section?

>  		tcf_action_stats_update(a, bytes, packets, drops,
>  					lastuse, true);
>  		a->used_hw_stats = used_hw_stats;
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 23a4538916af..7d5535bc2c13 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1089,15 +1089,18 @@ int tcf_action_offload_cmd_pre(struct tc_action *actions[],
>  EXPORT_SYMBOL(tcf_action_offload_cmd_pre);
>  
>  int tcf_action_offload_cmd_post(struct flow_offload_action *fl_act,
> -				struct netlink_ext_ack *extack)
> +				struct netlink_ext_ack *extack,
> +				bool keep_fl_act)
>  {
>  	if (IS_ERR(fl_act))
>  		return PTR_ERR(fl_act);
>  
>  	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
>  
> -	tc_cleanup_flow_action(&fl_act->action);
> -	kfree(fl_act);
> +	if (!keep_fl_act) {
> +		tc_cleanup_flow_action(&fl_act->action);
> +		kfree(fl_act);
> +	}
>  	return 0;
>  }
>  
> @@ -1115,10 +1118,45 @@ int tcf_action_offload_cmd(struct tc_action *actions[],
>  	if (err)
>  		return err;
>  
> -	return tcf_action_offload_cmd_post(fl_act, extack);
> +	return tcf_action_offload_cmd_post(fl_act, extack, false);
>  }
>  EXPORT_SYMBOL(tcf_action_offload_cmd);
>  
> +int tcf_action_update_hw_stats(struct tc_action *action)
> +{
> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> +		[0] = action,
> +	};
> +	struct flow_offload_action *fl_act;
> +	int err = 0;
> +

Having some way to distinguish offloaded actions would also be useful
here to skip this function. I wonder how this affects dump rate when
executed for every single action, even when none of them were offloaded
through action API.

> +	err = tcf_action_offload_cmd_pre(actions,
> +					 FLOW_ACT_STATS,
> +					 NULL,
> +					 &fl_act);
> +	if (err)
> +		goto err_out;
> +
> +	err = tcf_action_offload_cmd_post(fl_act, NULL, true);
> +
> +	if (fl_act->stats.lastused) {
> +		tcf_action_stats_update(action, fl_act->stats.bytes,
> +					fl_act->stats.pkts,
> +					fl_act->stats.drops,
> +					fl_act->stats.lastused,
> +					true);
> +		err = 0;
> +	} else {
> +		err = -EOPNOTSUPP;
> +	}
> +	tc_cleanup_flow_action(&fl_act->action);
> +	kfree(fl_act);
> +
> +err_out:
> +	return err;
> +}
> +EXPORT_SYMBOL(tcf_action_update_hw_stats);
> +
>  /* offload the tc command after deleted */
>  int tcf_action_offload_del_post(struct flow_offload_action *fl_act,
>  				struct tc_action *actions[],
> @@ -1255,6 +1293,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
>  	if (p == NULL)
>  		goto errout;
>  
> +	/* update hw stats for this action */
> +	tcf_action_update_hw_stats(p);
> +
>  	/* compat_mode being true specifies a call that is supposed
>  	 * to add additional backward compatibility statistic TLVs.
>  	 */

