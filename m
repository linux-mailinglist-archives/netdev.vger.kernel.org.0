Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC423D25AC
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhGVNot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 09:44:49 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:4065
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232170AbhGVNoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 09:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VgHmzmFZs8SEEpQVUoYOxEUwttXKX4gjkfmda2YbGBAhHRAdfPWQMZ8Ft0P1shWwd/4kL6kf+t96Yoq00MixBXvmgT+rMOvttN+M8TBvzMwFJS1+ULstehsx3u35hYSYIOQVIxGCumUoh4edvTr/30vNwfmz9JLyQrjVycGHTqUMZNWq77Nukj19jelQtMnJuFv3y9Kz59C9ZHdwikJ9BcvfZayix63yGuDRKQyl9MisyXstLXEetl2g3oCsNOCfXXuoHirWrosK9rpPCM3Rjx5RTVlOgC/4PJl1IiAIoT8sfjsFhugZehwojQzBpO/4dQs4jB1gdrcMuXbM4qD/VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGpOLHhUDe4DRqh3nF3V9axCuuXtzk8y9qj7WyCZSeo=;
 b=iBMfp7tzwNEUjiAsFafthQx3hOq3IIlrCta6UzeN0ekR9Y2IhM8mhcKRf6C0mRkycBQJJoRHewX7x/ztLSAZo7Rrh268mENPQv/Z1j86+sRFZW4z+zHIm9wSE6OAMmzn+f5VoV12hJgNKv3euFVT7MS4N2B2nRdtvZa/8BmvIu4uinWiCDi2cEGRyEHfwLTkWt23m5VOzJm3ex67HTV91ORsYFN3lAmRpY1gMvpBYX+mfF3Yv1FW+AwpFNmdP6GKk809GyTcbbZ5zEnylnoBSvLIldL/HCMGXDA+OQt8pZz4ExO+17/gENnSVCiyTC1LNHl6DUf0gdXzop2eZNwwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGpOLHhUDe4DRqh3nF3V9axCuuXtzk8y9qj7WyCZSeo=;
 b=Hx51esPPUsNhqV30VKGz6xVNjXv7xBUwVujnPafxkFLeXH7Z493RM8kww55AaT3Hta6Q8oFwZbf1pOPPQ23uhQ5EO7fqywVnlXvgteo2LvFsrGiTcPPFEWFW36H57hXQzkQ3yBPKs+jZZpojxey2/Ja9d8z1WQwzBcAW6FG14JbWIVRmvuzEAhQwHSAFydHWASWW+D2tL89azEG8rbyPj//Hl7Or2sjkdMbRur0BvlOKwAyhthQQdKcpz2vxaT4CbfgrbIc4v+hvUvgkvuKARFnuIbwLTrXEgK1Vryr47f9e8y20tOFnMb1yhyrOH+DLCTeAZXrz4342jAojhq1O1A==
Received: from DM5PR06CA0035.namprd06.prod.outlook.com (2603:10b6:3:5d::21) by
 DM6PR12MB2618.namprd12.prod.outlook.com (2603:10b6:5:49::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.29; Thu, 22 Jul 2021 14:25:20 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::e6) by DM5PR06CA0035.outlook.office365.com
 (2603:10b6:3:5d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 14:25:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 14:25:19 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 22 Jul 2021 14:25:16 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-3-simon.horman@corigine.com>
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
Subject: Re: [PATCH net-next 2/3] flow_offload: add process to delete
 offloaded actions from net device
In-Reply-To: <20210722091938.12956-3-simon.horman@corigine.com>
Date:   Thu, 22 Jul 2021 17:25:13 +0300
Message-ID: <ygnhfsw6qvcm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f95c525d-7c1e-442f-ba2a-08d94d1c88eb
X-MS-TrafficTypeDiagnostic: DM6PR12MB2618:
X-Microsoft-Antispam-PRVS: <DM6PR12MB26180B43E4C139ACE1659160A0E49@DM6PR12MB2618.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cscVgnay0y8dvyQxMAkaszvOO5WT1Mmi9W4fk2g/QsJ6akJkwlc2ld+VmJxYwHjvvoBnIp3HZc84E6SFA79R84N8b8622cPktrsxF14d9beTqw+FfaMkh0i56/RHiLABgHRZQbC3mIGHO55x56JqkBCjxQJLeX13kdbz/0DAkMwbluVESwFtVegNZ+PZczX2JhSF8fsoh8MgkgCpG3sf7cGSuRhmy/XPX9h/mWqrA+p5zIaEOBsS2jur/NX3S0zmJHS5ck4oWxCYFPJFeAu71RkziNut4q6OVTKzDlGIadqCQbDbwaZXpkjz/2UIMopRM0+guiDDDWipdUH6A+nsy/wj1DKjd0vRYl76u9X04SUpFZc3trfbNpwdo7Xvve63qEoBCny4lRUMMwIZds3+bdjQtkSXY/R0ktfF3g5HJRk+eZIAHhdq64SJdpfNrcwy1Tw+x5TG5obrdwPkwjARdj3E/dPxsEp0DRHIXFtP7Avi8RYkP+Z+AZ9V6NDOpJOgBOAZ54+oQypHeHPl0a1h2NsnNMAmvb0mO++Zc6Iq8CJd+rDtjC8BC1JfIKouh7MxiFhLbGjp9HMFRfEmUhMhPN9bS/Hk8/hEqlj7rHDdQQZRIYNeLUCkFwkAdeSJ9KhHbbJoNG14wV2JrK/jv7dLPqZmjYJJWRmZGkYbeLN2Nb0iuY1MQ8Y3ZAf5WHyKSA9Ghge50vVO9Y8DgtWyrDL9oQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39850400004)(396003)(46966006)(36840700001)(82740400003)(426003)(47076005)(186003)(2906002)(8676002)(36756003)(36860700001)(8936002)(54906003)(356005)(7636003)(336012)(16526019)(26005)(82310400003)(83380400001)(70206006)(478600001)(70586007)(7696005)(2616005)(316002)(6916009)(4326008)(5660300002)(86362001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 14:25:19.9689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f95c525d-7c1e-442f-ba2a-08d94d1c88eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2618
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 22 Jul 2021 at 12:19, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Add a basic process to delete offloaded actions from net device.
>
> Should not remove the offloaded action entries if the action
> fails to delete in tcf_del_notify.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/pkt_cls.h |   1 +
>  net/sched/act_api.c   | 112 +++++++++++++++++++++++++++++++++++-------
>  net/sched/cls_api.c   |  14 ++++--
>  3 files changed, 106 insertions(+), 21 deletions(-)
>
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index cd4cf6b10f5d..03dae225d64f 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -573,6 +573,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>  			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
>  unsigned int tcf_act_num_actions(struct tc_action *actions[]);
> +unsigned int tcf_act_num_actions_single(struct tc_action *act);
>  
>  #ifdef CONFIG_NET_CLS_ACT
>  int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 185f17ea60d5..23a4538916af 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1060,36 +1060,109 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	return ERR_PTR(err);
>  }
>  
> -/* offload the tc command after inserted */
> -int tcf_action_offload_cmd(struct tc_action *actions[],
> -			   struct netlink_ext_ack *extack)
> +int tcf_action_offload_cmd_pre(struct tc_action *actions[],
> +			       enum flow_act_command cmd,
> +			       struct netlink_ext_ack *extack,
> +			       struct flow_offload_action **fl_act)
>  {
> -	struct flow_offload_action *fl_act;
> +	struct flow_offload_action *fl_act_p;
>  	int err = 0;
>  
> -	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
> -	if (!fl_act)
> +	fl_act_p = flow_action_alloc(tcf_act_num_actions(actions));
> +	if (!fl_act_p)
>  		return -ENOMEM;
>  
> -	fl_act->extack = extack;
> -	err = tc_setup_action(&fl_act->action, actions);
> +	fl_act_p->extack = extack;
> +	fl_act_p->command = cmd;
> +	err = tc_setup_action(&fl_act_p->action, actions);
>  	if (err) {
>  		NL_SET_ERR_MSG_MOD(extack,
>  				   "Failed to setup tc actions for offload\n");
>  		goto err_out;
>  	}
> -	fl_act->command = FLOW_ACT_REPLACE;
> +	*fl_act = fl_act_p;
> +	return 0;
> +err_out:
> +	kfree(fl_act_p);
> +	return err;
> +}
> +EXPORT_SYMBOL(tcf_action_offload_cmd_pre);

This doesn't seem be used anywhere outside this file.

> +
> +int tcf_action_offload_cmd_post(struct flow_offload_action *fl_act,
> +				struct netlink_ext_ack *extack)
> +{
> +	if (IS_ERR(fl_act))
> +		return PTR_ERR(fl_act);
>  
>  	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
>  
>  	tc_cleanup_flow_action(&fl_act->action);
> -
> -err_out:
>  	kfree(fl_act);
> -	return err;
> +	return 0;
> +}

This one is not exported, by is non-static.

> +
> +/* offload the tc command after inserted */
> +int tcf_action_offload_cmd(struct tc_action *actions[],
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct flow_offload_action *fl_act;
> +	int err = 0;
> +
> +	err = tcf_action_offload_cmd_pre(actions,
> +					 FLOW_ACT_REPLACE,
> +					 extack,
> +					 &fl_act);
> +	if (err)
> +		return err;
> +
> +	return tcf_action_offload_cmd_post(fl_act, extack);
>  }
>  EXPORT_SYMBOL(tcf_action_offload_cmd);
>  
> +/* offload the tc command after deleted */
> +int tcf_action_offload_del_post(struct flow_offload_action *fl_act,
> +				struct tc_action *actions[],
> +				struct netlink_ext_ack *extack,
> +				int fallback_num)
> +{
> +	int fallback_entries = 0;
> +	struct tc_action *act;
> +	int total_entries = 0;
> +	int i;
> +
> +	if (!fl_act)
> +		return -EINVAL;
> +
> +	if (fallback_num) {
> +		/* for each the actions to fallback the action entries remain in the actions */
> +		for (i = 0; i < TCA_ACT_MAX_PRIO; i++) {
> +			act = actions[i];
> +			if (!act)
> +				continue;
> +
> +			fallback_entries += tcf_act_num_actions_single(act);
> +		}
> +		fallback_entries += fallback_num;
> +	}
> +	total_entries = fl_act->action.num_entries;
> +	if (total_entries > fallback_entries) {
> +		/* just offload the actions that is not fallback and start with the actions */
> +		fl_act->action.num_entries -= fallback_entries;
> +		flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
> +
> +		/* recovery num_entries for cleanup */
> +		fl_act->action.num_entries = total_entries;
> +	} else {
> +		NL_SET_ERR_MSG(extack, "no entries to offload when deleting the tc actions");
> +	}
> +
> +	tc_cleanup_flow_action(&fl_act->action);
> +
> +	kfree(fl_act);
> +	return 0;
> +}
> +EXPORT_SYMBOL(tcf_action_offload_del_post);
> +
>  /* Returns numbers of initialized actions or negative error. */
>  
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1393,7 +1466,7 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
>  	return err;
>  }
>  
> -static int tcf_action_delete(struct net *net, struct tc_action *actions[])
> +static int tcf_action_delete(struct net *net, struct tc_action *actions[], int *fallbacknum)
>  {
>  	int i;
>  
> @@ -1407,6 +1480,7 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
>  		u32 act_index = a->tcfa_index;
>  
>  		actions[i] = NULL;
> +		*fallbacknum = tcf_act_num_actions_single(a);
>  		if (tcf_action_put(a)) {
>  			/* last reference, action was deleted concurrently */
>  			module_put(ops->owner);
> @@ -1419,12 +1493,13 @@ static int tcf_action_delete(struct net *net, struct tc_action *actions[])
>  				return ret;
>  		}
>  	}
> +	*fallbacknum = 0;
>  	return 0;
>  }
>  
>  static int
>  tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
> -	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack)
> +	       u32 portid, size_t attr_size, struct netlink_ext_ack *extack, int *fallbacknum)
>  {
>  	int ret;
>  	struct sk_buff *skb;
> @@ -1442,7 +1517,7 @@ tcf_del_notify(struct net *net, struct nlmsghdr *n, struct tc_action *actions[],
>  	}
>  
>  	/* now do the delete */
> -	ret = tcf_action_delete(net, actions);
> +	ret = tcf_action_delete(net, actions, fallbacknum);
>  	if (ret < 0) {
>  		NL_SET_ERR_MSG(extack, "Failed to delete TC action");
>  		kfree_skb(skb);
> @@ -1458,11 +1533,12 @@ static int
>  tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
>  	      u32 portid, int event, struct netlink_ext_ack *extack)
>  {
> -	int i, ret;
>  	struct nlattr *tb[TCA_ACT_MAX_PRIO + 1];
>  	struct tc_action *act;
>  	size_t attr_size = 0;
>  	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {};
> +	struct flow_offload_action *fl_act;
> +	int i, ret, fallback_num;
>  
>  	ret = nla_parse_nested_deprecated(tb, TCA_ACT_MAX_PRIO, nla, NULL,
>  					  extack);
> @@ -1492,7 +1568,9 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
>  	if (event == RTM_GETACTION)
>  		ret = tcf_get_notify(net, portid, n, actions, event, extack);
>  	else { /* delete */
> -		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
> +		tcf_action_offload_cmd_pre(actions, FLOW_ACT_DESTROY, extack, &fl_act);
> +		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack, &fallback_num);
> +		tcf_action_offload_del_post(fl_act, actions, extack, fallback_num);

This tcf_action_offload_cmd_{pre|post}() approach looks slightly
complicated, especially with fallback_num calculations. I would suggest
to simplify it by only initializing action cookies in
flow_action->entries[] (I assume you don't really need all the action
data just to delete it, right?) for DEL/STATS and do one of the
following:

- Unoffload actions one-by-one after every deletion in
  tcf_actions_delete(), perhaps reusing the same flow_offload_action of
  size 1 by only changing the cookie on each iteration.

- If you really want to send the whole batch to the driver, save cookies
  for all successfully deleted actions in an array and initialize
  compound flow_offload_action from the array.

This would remove the need for whole pre/post thing, which otherwise
gets even more complicated in following patch by 'keep_fl_act' arg.

>  		if (ret)
>  			goto err;
>  		return 0;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 9b9770dab5e8..23ce021f07f8 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3755,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_num_actions);
>  
> +unsigned int tcf_act_num_actions_single(struct tc_action *act)
> +{
> +	if (is_tcf_pedit(act))
> +		return tcf_pedit_nkeys(act);
> +	else
> +		return 1;
> +}
> +EXPORT_SYMBOL(tcf_act_num_actions_single);
> +
>  unsigned int tcf_act_num_actions(struct tc_action *actions[])
>  {
>  	unsigned int num_acts = 0;
> @@ -3762,10 +3771,7 @@ unsigned int tcf_act_num_actions(struct tc_action *actions[])
>  	int i;
>  
>  	tcf_act_for_each_action(i, act, actions) {
> -		if (is_tcf_pedit(act))
> -			num_acts += tcf_pedit_nkeys(act);
> -		else
> -			num_acts++;
> +		num_acts += tcf_act_num_actions_single(act);
>  	}
>  	return num_acts;
>  }

