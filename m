Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B505B3D249C
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhGVMsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:48:46 -0400
Received: from mail-mw2nam10on2068.outbound.protection.outlook.com ([40.107.94.68]:21344
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231994AbhGVMsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 08:48:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cErkaZMSqhpOlOJVYB7b1n+TBuv7ocmKZuhpSeavZ5Cb6IEQNgIkexGDDXIA2pX5j40FoYgHutye5J0Pnx0aBAAkaUNhATlaQe3yXuN7wwUaGC84tDYBUNHxLxLbgsbhjZ/wPz9wHNWIS/uqCtJoJ9X9aP4o30rDDIl6GIBHzt4yEUizX93t93cMe/i44lMgxyTBEoqS+t3VY7Yktx3RL66JynDsGv4Kf4m9OhWwGZwhF/FqKSTMyeSZBEGaMKkw3Ia7kFlIDo2pUkaYt3tYZx7gfLQk/CtM3JxfYsb7ITMSyU2a78XjYHtxvCphdNFeBhpOFR8jmojKT8SDaZ0HgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1tpmN/aM4sUQ6q4O8ZhxsepynHnBdain7PvM+hP0g4=;
 b=POdLNV8jcNe+kgTJorqVorQ9v8L1Z4fJ/MJ7UK4IoWERzeX75H1oFYPRcpP2KrxD/UwVa20Pkdk3qUZlryscQkokAfM6jludvriyMrwkQ/GfFtfdOQ7O9ACxDB+xp6KmgHcnd/S8d3EAj8smkgnqa0cueONGit+jccDdvp3Zwv8lCgNqnUiIrCP/fu2/LTWt4Q/9R1+9X+rMnd8RQeSg273hUGNiPjjeozsFxpLEIN0Nqh2l0kMtRqAd2wlILlahsxM4Aca7muzfBcGxmYmxQKN0wVb/RDrNJzSf4J5PHPpjv84/mPNrrExz2FgvWmQzDpYg0geNjGnDRD2eMV2eYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1tpmN/aM4sUQ6q4O8ZhxsepynHnBdain7PvM+hP0g4=;
 b=PKQiqW8WWGo08LKtai0CUsURiYa0Qyryr/xABWz+zfH56GDs1Srm356x4i++0+eZ8Orx5NREGkhkjX9XKp6u5h8k5YPnuyiFSohSNX9bX+lcXkVxzwC/ShNXcWyE/kFGo4tiVZJ9XHViowDHYmfSVwo8SE8x57jEf5qxGokWfUP+4XpNtlcE9mXfxGKU1mqkMz6HintB2IAw+dq8qtxvwsVgbCk0ffLSY/T65KNBbx1Wbe+PCbehyQRSlbXnaberpXOQpO7UNy7x6mNoSdkCvbMLtY9VkAguv/cEX1jKbiGQOy4vaoY9WnY9W8kWG2XG8l1nL0yIO+FRGj89N8UYnQ==
Received: from BN6PR16CA0029.namprd16.prod.outlook.com (2603:10b6:405:14::15)
 by MWHPR12MB1326.namprd12.prod.outlook.com (2603:10b6:300:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 13:29:19 +0000
Received: from BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:14:cafe::de) by BN6PR16CA0029.outlook.office365.com
 (2603:10b6:405:14::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 13:29:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT018.mail.protection.outlook.com (10.13.176.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 13:29:18 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 22 Jul 2021 13:29:15 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
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
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
In-Reply-To: <20210722091938.12956-2-simon.horman@corigine.com>
Date:   Thu, 22 Jul 2021 16:29:13 +0300
Message-ID: <ygnhim12qxxy.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dd9f1af-ab4f-4330-9210-08d94d14b594
X-MS-TrafficTypeDiagnostic: MWHPR12MB1326:
X-Microsoft-Antispam-PRVS: <MWHPR12MB13269CCA30BCD8024BDEEEBCA0E49@MWHPR12MB1326.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uIak753S/Z/AA3OX60EpgXYGwUTFciVH+LCSjlyMzcK7l7F2KDGzLeLgzVBV1Qly9JBmxIqyEDRtGitF98/qNY9UfgjBTpWQ8QyRQsm4JfobsDXLspMJ6VkPVh2al23rnAAS8XgMklNkCLDbM0hlY+F0ZVWdWsIvd0ISGXh1oP5mFVdyUbV7ydfXED7yxBSrFpkhOttYvPKiZtHUm7gkLhHhEfCCpfVoUsnCLDCUYmRi2P2cS/2jbtFnqq93+78cm5Lc0ZilksY73vNlHqla96xnuCmlVMGEFziO3UJqNN5mzVXI25c/7+1Wrj9hFtCdPdDvctl0tLCnws0fG6X+uDmEqiys2g7TEFFbyC9BEgaKrI8UCz+X4v9Y5pVvzOFEGxiROfXYeIZfrICs2CXHThIfLnLGUVtoatI0naQMJBNtaIUYqfKgPVSH0ezRza9jben2gdzFsxXA0FkHCld9jX+kSumDi7AhiP0m4rJNNlL9rBSB/ai266H8bEAqbpJDszFKGMlgyPIAM7LZPONQDY/HL6YBAs4N5d8oQa3N6CnQwcxI+oipRHMOugnJCtNU/GZAnJ+1eNqeMSm36rK9v7RoaSFk79MSq3DikLN67yLXur5xcmR2uVd+uHWFhx3kVOWKo1rO9v51Hvwo96kiYG8iy57t5TyBC8y3HNo5wG815/UZdCYpqDBpkTA28rHiX/dDtLwKs4PvfoaiabzXIg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(86362001)(2616005)(5660300002)(26005)(7696005)(54906003)(336012)(356005)(36756003)(508600001)(30864003)(426003)(4326008)(47076005)(316002)(8676002)(6916009)(8936002)(82310400003)(83380400001)(70206006)(7636003)(36860700001)(186003)(16526019)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 13:29:18.9074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd9f1af-ab4f-4330-9210-08d94d14b594
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1326
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 22 Jul 2021 at 12:19, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> offload tc action.
>
> We offload the tc action mainly for ovs meter configuration.
> Make some basic changes for different vendors to return EOPNOTSUPP.
>
> We need to call tc_cleanup_flow_action to clean up tc action entry since
> in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> action.
>
> As per review from the RFC, the kernel test robot will fail to run, so
> we add CONFIG_NET_CLS_ACT control for the action offload.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
>  .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
>  include/linux/netdevice.h                     |  1 +
>  include/net/flow_offload.h                    | 15 ++++++++
>  include/net/pkt_cls.h                         | 15 ++++++++
>  net/core/flow_offload.c                       | 26 +++++++++++++-
>  net/sched/act_api.c                           | 33 +++++++++++++++++
>  net/sched/cls_api.c                           | 36 ++++++++++++++++---
>  9 files changed, 128 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 5e4429b14b8c..edbbf7b4df77 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1951,7 +1951,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
>  				 void *data,
>  				 void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> -	if (!bnxt_is_netdev_indr_offload(netdev))
> +	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
>  		return -EOPNOTSUPP;
>  
>  	switch (type) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index 059799e4f483..111daacc4cc3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -486,6 +486,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
>  			    void *data,
>  			    void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> +	if (!netdev)
> +		return -EOPNOTSUPP;
> +
>  	switch (type) {
>  	case TC_SETUP_BLOCK:
>  		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> index 2406d33356ad..88bbc86347b4 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -1869,6 +1869,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
>  			    void *data,
>  			    void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> +	if (!netdev)
> +		return -EOPNOTSUPP;
> +
>  	if (!nfp_fl_is_netdev_to_offload(netdev))
>  		return -EOPNOTSUPP;
>  
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 42f6f866d5f3..b138219baf6f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -923,6 +923,7 @@ enum tc_setup_type {
>  	TC_SETUP_QDISC_TBF,
>  	TC_SETUP_QDISC_FIFO,
>  	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>  };
>  
>  /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 69c9eabf8325..26644596fd54 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -553,6 +553,21 @@ struct flow_cls_offload {
>  	u32 classid;
>  };
>  
> +enum flow_act_command {
> +	FLOW_ACT_REPLACE,
> +	FLOW_ACT_DESTROY,
> +	FLOW_ACT_STATS,
> +};
> +
> +struct flow_offload_action {
> +	struct netlink_ext_ack *extack;
> +	enum flow_act_command command;
> +	struct flow_stats stats;
> +	struct flow_action action;
> +};
> +
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
> +
>  static inline struct flow_rule *
>  flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
>  {
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index ec7823921bd2..cd4cf6b10f5d 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -266,6 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  	for (; 0; (void)(i), (void)(a), (void)(exts))
>  #endif
>  
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
>  static inline void
>  tcf_exts_stats_update(const struct tcf_exts *exts,
>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -536,8 +539,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>  	return ifindex == skb->skb_iif;
>  }
>  
> +#ifdef CONFIG_NET_CLS_ACT
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts);
> +#else
> +static inline int tc_setup_flow_action(struct flow_action *flow_action,
> +				       const struct tcf_exts *exts)
> +{
> +		return 0;
> +}
> +#endif
> +
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>  
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -558,6 +572,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>  			  enum tc_setup_type type, void *type_data,
>  			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions(struct tc_action *actions[]);
>  
>  #ifdef CONFIG_NET_CLS_ACT
>  int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 715b67f6c62f..0fa2f75cc9b3 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
>  }
>  EXPORT_SYMBOL(flow_rule_alloc);
>  
> +struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
> +{
> +	struct flow_offload_action *fl_action;
> +	int i;
> +
> +	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
> +			    GFP_KERNEL);
> +	if (!fl_action)
> +		return NULL;
> +
> +	fl_action->action.num_entries = num_actions;
> +	/* Pre-fill each action hw_stats with DONT_CARE.
> +	 * Caller can override this if it wants stats for a given action.
> +	 */
> +	for (i = 0; i < num_actions; i++)
> +		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
> +
> +	return fl_action;
> +}
> +EXPORT_SYMBOL(flow_action_alloc);
> +
>  #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
>  	const struct flow_match *__m = &(__rule)->match;			\
>  	struct flow_dissector *__d = (__m)->dissector;				\
> @@ -476,6 +497,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
>  
>  	mutex_unlock(&flow_indr_block_lock);
>  
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	if (bo)
> +		return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	else
> +		return 0;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 998a2374f7ae..185f17ea60d5 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1060,6 +1060,36 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	return ERR_PTR(err);
>  }
>  
> +/* offload the tc command after inserted */
> +int tcf_action_offload_cmd(struct tc_action *actions[],
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct flow_offload_action *fl_act;
> +	int err = 0;
> +
> +	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
> +	if (!fl_act)
> +		return -ENOMEM;
> +
> +	fl_act->extack = extack;
> +	err = tc_setup_action(&fl_act->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to setup tc actions for offload\n");
> +		goto err_out;
> +	}
> +	fl_act->command = FLOW_ACT_REPLACE;
> +
> +	flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
> +
> +	tc_cleanup_flow_action(&fl_act->action);
> +
> +err_out:
> +	kfree(fl_act);
> +	return err;
> +}
> +EXPORT_SYMBOL(tcf_action_offload_cmd);
> +
>  /* Returns numbers of initialized actions or negative error. */
>  
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1514,6 +1544,9 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
>  		return ret;
>  	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
>  
> +	/* offload actions to hardware if possible */
> +	tcf_action_offload_cmd(actions, extack);
> +

I think this has already been suggested for RFC, but some sort of
visibility for offload status of action would be extremely welcome.
Perhaps "IN_HW" flag and counter, similar to what we have for offloaded
filters.

>  	/* only put existing actions */
>  	for (i = 0; i < TCA_ACT_MAX_PRIO; i++)
>  		if (init_res[i] == ACT_P_CREATED)
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index c8cb59a11098..9b9770dab5e8 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
>  	return hw_stats;
>  }
>  
> -int tc_setup_flow_action(struct flow_action *flow_action,
> -			 const struct tcf_exts *exts)
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[])
>  {
>  	struct tc_action *act;
>  	int i, j, k, err = 0;
> @@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>  	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>  
> -	if (!exts)
> +	if (!actions)
>  		return 0;
>  
>  	j = 0;
> -	tcf_exts_for_each_action(i, act, exts) {
> +	tcf_act_for_each_action(i, act, actions) {
>  		struct flow_action_entry *entry;
>  
>  		entry = &flow_action->entries[j];
> @@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	spin_unlock_bh(&act->tcfa_lock);
>  	goto err_out;
>  }
> +EXPORT_SYMBOL(tc_setup_action);
> +
> +#ifdef CONFIG_NET_CLS_ACT
> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{
> +	if (!exts)
> +		return 0;
> +
> +	return tc_setup_action(flow_action, exts->actions);
> +}
>  EXPORT_SYMBOL(tc_setup_flow_action);
> +#endif
>  
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  {
> @@ -3743,6 +3755,22 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>  }
>  EXPORT_SYMBOL(tcf_exts_num_actions);
>  
> +unsigned int tcf_act_num_actions(struct tc_action *actions[])
> +{
> +	unsigned int num_acts = 0;
> +	struct tc_action *act;
> +	int i;
> +
> +	tcf_act_for_each_action(i, act, actions) {
> +		if (is_tcf_pedit(act))
> +			num_acts += tcf_pedit_nkeys(act);
> +		else
> +			num_acts++;
> +	}
> +	return num_acts;
> +}
> +EXPORT_SYMBOL(tcf_act_num_actions);
> +
>  #ifdef CONFIG_NET_CLS_ACT
>  static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>  					u32 *p_block_index,

