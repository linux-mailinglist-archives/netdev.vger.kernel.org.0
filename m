Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C48438C0CB
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhEUHeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 03:34:50 -0400
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:63713
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230050AbhEUHes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 03:34:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldw+Ha7ReOkPWKNseLQNy27m680oaYMwf+h9WsgQAlJ8AE8e4vww4TMLpUMkcRDxzq4yK2xN9XjU/3eMl2Qu7lYA1KKzykeQf6CjvoNBQgKVdSqrCZkjmacNZtpKrhF6V29YmUee6PKtNK9MCKGuOaj57RKQXPii9eHWlG7OaR2FkKVt9WQT5VwherZquRfQuy2ZCTuIonA9uNPQO7CZ06TqosndBzVBHH9gwvfwqSaO4bov5WFQFnKsHkszuwtvCXgqIOugAJAg50vtcdxhEdP3kzIc8JYhL7EjBaoG4NdkadxxC1AJbcrVbfqBoj7pVibU16opNA7fjA9yHFEpXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJdCZgunn6cNfJ0zmFSAP9NrJT15xFBCe6CIRPam51A=;
 b=mFb8Za33zXmei2unw+MgH/a+so1EGEouhkkHMXf02j6FZBTFeL7YwnXLTwS1dL5O9qd94kWcYwkrWbw7hUXItctdt2lbPrNRX/D2yYk8n9Y504SL2GmL42TG8wips8blNM9ECR4jvKQINdyns+SEqzbLjEhrt36lA327QtA1H7qU9UwUY8OY384OWgfDpiMkOWFih+Baz+J/gahWV/jEJgUTi6YHlky9btXlkUd9Z0WyKfE8ycTOuLGKxN7nKsNWHU6xlQLvLUYkOkA+WkXG5y4e+BMWfDhz5/UwZTERINReE2AoYRbF30A575Ldj6CEIPYyrqY1orpYFnCmS4LJ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=netronome.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJdCZgunn6cNfJ0zmFSAP9NrJT15xFBCe6CIRPam51A=;
 b=sc7mixCO3wLNvXOVwsRxOs39O5dyBZS9sa5volQpSJP/cxK63UC92sVFgMAQKpg8ul4Hy7QFyzZM9LVvL4c4pZ+dgGLeVjnNDJM2R+pWZ16f6DfgMit/6afN+i6lYm1RF1Z3zMXI//5XDMkfE28/IODxnulbZ4xRHqxx9BoMv9CmNmGhkdxLIjP0D2/PvAPrsjIMrlVJTuzvpiUCq0GyWFKtyawX8ZLe3KSf0BYscxO4UOnDhZkVduj8oqoXd3Aur2qR7g7627i4V8tyIEcIRPstuRPsvLZ735B3kCG36vxkpC3uFD0G5paoeN5HQFoqkYppcQ867nP82+JINtFctw==
Received: from DM3PR11CA0003.namprd11.prod.outlook.com (2603:10b6:0:54::13) by
 BY5PR12MB3938.namprd12.prod.outlook.com (2603:10b6:a03:1af::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 21 May
 2021 07:33:24 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::34) by DM3PR11CA0003.outlook.office365.com
 (2603:10b6:0:54::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Fri, 21 May 2021 07:33:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; netronome.com; dkim=none (message not signed)
 header.d=none;netronome.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 07:33:24 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 07:33:23 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 07:33:21 +0000
Date:   Fri, 21 May 2021 07:33:18 +0000
From:   Jianbo Liu <jianbol@nvidia.com>
To:     Simon Horman <simon.horman@netronome.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@netronome.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Louis Peens" <louis.peens@netronome.com>
Subject: Re: [RFC net-next] net/flow_offload: allow user to offload tc action
 to net device
Message-ID: <20210521073314.GA1655@vdi.nvidia.com>
References: <20210429081014.28498-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210429081014.28498-1-simon.horman@netronome.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7ca5e8a-6b19-4ac7-e97c-08d91c2ab79f
X-MS-TrafficTypeDiagnostic: BY5PR12MB3938:
X-Microsoft-Antispam-PRVS: <BY5PR12MB393873EF44C602AE8A1F3817C5299@BY5PR12MB3938.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FntLG3337sKolm6RXv/9ZugI2xcLuUP1XUu4ctcd3bSueFw1wys4zF/uZB1nzu2uAdMx4S32SSSOgHfFY+h2DxH9J9qNcVxjUvaqPVWpWIg9iqLbM+/8yyd4/WkNdUWIuQU2NK4LeT/Q9FdeL4eAGhondaE5Gyfq8JRwh8VzQN4/jakzDq9K+jl86v2UiynrT8XAGYtoqzNXUvHaRyt2VnLewZ2HnU9ib7XaNF4Mb8AVIwulXJ6ymgfCs7As/TCQFpWQKnWGV2JqUR6awzZcj67rCZxsE5iCp5kASnjVbuq141j8Wt56YlH3TMpABWRs56CjhuPQBJPMhZEzB0sO/0c5ymQW/EXO+FfpM7aVQ2/INYqELgAXAlFy87cGVMVSV0BOgWAoEjJrC25bvxN/70xAcrgFIc2LRsDjkkif9ZDuN/XViHffxd5nqo4ZIcdh653Gi/9hNbJorSQL2IEn82Vl418aHKtIMLXUw45/UAzt7NwFT+bcN62XVff+rX6TUcwLfBTFcShPKw01FVT/mbmj4Xna4qC6sin2XNVbjHtl9GSXnLv0oQrSrKw0TFETWwGyvSbuxuMvxpH5CTeR+sbv+rrsiHsYLkFuV7v1/huSpBJ00A57K0BMSSr5LJzPrhCsTYrpW5NNWicGDaGoGQ==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(5660300002)(70586007)(36860700001)(478600001)(82310400003)(6666004)(1076003)(70206006)(26005)(7696005)(6916009)(426003)(4326008)(54906003)(7636003)(82740400003)(186003)(8936002)(83380400001)(33656002)(336012)(47076005)(356005)(86362001)(30864003)(36906005)(316002)(8676002)(55016002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 07:33:24.3101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7ca5e8a-6b19-4ac7-e97c-08d91c2ab79f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3938
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/29/2021 10:10, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Allow use of flow_indr_dev_register/flow_indr_dev_setup_offload to offload
> tc actions independent of flows.
> 
> The motivation for this work is to prepare for using TC police action
> instances to provide hardware offload of OVS metering feature - which calls
> for policers that may be used my multiple flows and whose lifecycle is
> independent of any flows that use them.
> 
> This patch includes basic changes to offload drivers to return EOPNOTSUPP
> if this feature is used - it is not yet supported by any driver.

Not sure if you consider the case when there are multiple netdevs in a
system which all support action offloading (for example, police), how
does driver know which device should this software meter be offloaded
to, and create hardware meter for it?

> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
>  .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
>  include/linux/netdevice.h                     |  1 +
>  include/net/flow_offload.h                    | 15 ++++++++
>  include/net/pkt_cls.h                         |  6 ++++
>  include/net/tc_act/tc_police.h                |  5 +++
>  net/core/flow_offload.c                       | 26 +++++++++++++-
>  net/sched/act_api.c                           | 30 ++++++++++++++++
>  net/sched/cls_api.c                           | 34 ++++++++++++++++---
>  10 files changed, 119 insertions(+), 6 deletions(-)
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
> index 6cdc52d50a48..c8dde4bc3961 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -490,6 +490,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
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
> index e95969c462e4..f6c665051173 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -1839,6 +1839,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
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
> index 5cbc950b34df..2f8cb65d85d1 100644
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
> index dc5c1e69cd9f..5fd8b5600b4a 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -551,6 +551,21 @@ struct flow_cls_offload {
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
> index 255e4f4b521f..5c6549ae0cc7 100644
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
> @@ -538,6 +541,8 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>  
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts);
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>  
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -558,6 +563,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>  			  enum tc_setup_type type, void *type_data,
>  			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions(struct tc_action *actions[]);
>  
>  #ifdef CONFIG_NET_CLS_ACT
>  int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
> index 72649512dcdd..6309519bf9d4 100644
> --- a/include/net/tc_act/tc_police.h
> +++ b/include/net/tc_act/tc_police.h
> @@ -53,6 +53,11 @@ static inline bool is_tcf_police(const struct tc_action *act)
>  	return false;
>  }
>  
> +static inline u32 tcf_police_index(const struct tc_action *act)
> +{
> +	return act->tcfa_index;
> +}
> +

Any action should have an index, maybe we can have a general function
to get index for all actions.

>  static inline u64 tcf_police_rate_bytes_ps(const struct tc_action *act)
>  {
>  	struct tcf_police *police = to_police(act);
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
> index f6d5755d669e..dab24688d9c7 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1059,6 +1059,34 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	return ERR_PTR(err);
>  }
>  
> +/* offload the tc command after inserted */
> +int tcf_action_offload_cmd(struct tc_action *actions[], bool add, struct netlink_ext_ack *extack)
> +{
> +	int err = 0;
> +	struct flow_offload_action *fl_act;
> +
> +	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
> +	if (!fl_act)
> +		return -ENOMEM;
> +
> +	fl_act->extack = extack;
> +	err = tc_setup_action(&fl_act->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to setup tc actions for offload\n");
> +		goto err_out;
> +	}
> +	fl_act->command = add ? FLOW_ACT_REPLACE : FLOW_ACT_DESTROY;
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
> @@ -1107,6 +1135,7 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  	 */
>  	tcf_idr_insert_many(actions);
>  
> +	tcf_action_offload_cmd(actions, true, extack);

Maybe it should be placed it inside tcf_action_add, so only
independently defined actions (by tc-actions commands) are offloaded.
Otherwise, new hardware meter is created for each rule with police
action, and it's hard to share hardware meter among rules, right?

>  	*attr_size = tcf_action_full_attrs_size(sz);
>  	err = i - 1;
>  	goto err_mod;
> @@ -1465,6 +1494,7 @@ tca_action_gd(struct net *net, struct nlattr *nla, struct nlmsghdr *n,
>  	if (event == RTM_GETACTION)
>  		ret = tcf_get_notify(net, portid, n, actions, event, extack);
>  	else { /* delete */
> +		tcf_action_offload_cmd(actions, false, extack);
>  		ret = tcf_del_notify(net, n, actions, portid, attr_size, extack);
>  		if (ret)
>  			goto err;
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 40fbea626dfd..995024c20df6 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3551,8 +3551,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
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
> @@ -3561,11 +3561,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
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
> @@ -3732,6 +3732,16 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  	spin_unlock_bh(&act->tcfa_lock);
>  	goto err_out;
>  }
> +EXPORT_SYMBOL(tc_setup_action);
> +
> +int tc_setup_flow_action(struct flow_action *flow_action,
> +			 const struct tcf_exts *exts)
> +{
> +	if (!exts)
> +		return 0;
> +
> +	return tc_setup_action(flow_action, exts->actions);
> +}
>  EXPORT_SYMBOL(tc_setup_flow_action);
>  
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
> @@ -3750,6 +3760,22 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
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
> -- 
> 2.20.1
> 

-- 
