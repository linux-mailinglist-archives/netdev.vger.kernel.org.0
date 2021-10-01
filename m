Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F6C41F20F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 18:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354816AbhJAQWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 12:22:45 -0400
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:7008
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232069AbhJAQWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 12:22:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwiYXkZrpb7UZ7AoFHC5y845FWFz70jIsa6E6TEGJnyWvd0G2u+8mSjbJhanlTqzcC4BzO+qSVFl6BNmiSzl5FJb2eHjs8WFZV/1zrkSkVgXqYx4cWQ1oBMIKWGj/vkCedeNQRGz7XsCREnhjyBYcBN9zReZPsEhuu6x9HGACtX8exIBz7BTK2du2wNaRb0bHRoXP/1w+4xStj5Fg4BsLIw6Coz2U46ZfAhK82djwqmGCyQ5nRhHQ3tkyWESCN/Cy2XrZFhDMBGtSkv+dV850EpabVO4OuFNAcy0phEzwyrJsXCllc+B9EWSDo5bIKHZTRqql33ctmfJqEaHt9FsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8QsoBrCuh8G5TlUxQwuIczCAPiVQR6UPR1lVuedxI4=;
 b=EsSa3La8tvIZLGj5lRAGfGGcM5NwzhL2UelJDNZ3QqcwulpuRCMG4xrb1mBhqC8KTAS6bWYyeUOKw0QVZ1Gd7G/mzZF7WdHSDKl5WIUWhGGM79xHTp9aEuGKj7Z0n5MxrEZxmbqkBlJCYwxqfyjU5wt4C5Pf0ZdrOMmeIvvXQcH6xHKp3viT7OOaNekAzUQmCh/UQN2V8xAE0mnZh8ZYNuOgGV5+QNOvu4wDTCMCSffq9sbIhX7DDIj7X8bKzUfcjXIgI1PEP1hqfpUrfN4DRU/jWnMKQ5sW3Al30X9KPnN4CmlS1D7k862aH8wl4OovEKSMwhBWzPEBG8Q56STtuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8QsoBrCuh8G5TlUxQwuIczCAPiVQR6UPR1lVuedxI4=;
 b=Bn/SiIM1oUdbhSmB/zlMBuvYsUab03H4E3j4XVLE5LG5o6YJXTbANE7G1Fxuxhtoxt6zM26CPnbWyeTVKdAdoFkUfi6VHiQkpPcsJaoMT0SFK7lCrCiFz3K6HZhCcTBqur/FKrETsoMCmws21Lcdink/8+NWa8j+ce9Y33SbWfLxJQ4A1XSnTzHd3p6lSXGkf+1urymZaS0XUqJEddxHTCg/hFNFsIPScAPm9GLWTxeWtULsg4mKHgPJOTPPlHoK8VkCSDrMkea7ImAxYgbM6384YOOjhVzz/Gb0PSMcmvllGDsjkcwZB/VXck3F7zE8SB3ycWx+uHBbUPsV9tiRjg==
Received: from BN9PR03CA0725.namprd03.prod.outlook.com (2603:10b6:408:110::10)
 by DM5PR12MB1404.namprd12.prod.outlook.com (2603:10b6:3:77::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Fri, 1 Oct
 2021 16:20:57 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::10) by BN9PR03CA0725.outlook.office365.com
 (2603:10b6:408:110::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend
 Transport; Fri, 1 Oct 2021 16:20:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 16:20:57 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 1 Oct 2021 16:20:54 +0000
References: <20211001113237.14449-1-simon.horman@corigine.com>
 <20211001113237.14449-3-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roi Dayan <roid@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [RFC/PATCH net-next v2 2/5] flow_offload: allow user to offload
 tc action to net device
In-Reply-To: <20211001113237.14449-3-simon.horman@corigine.com>
Date:   Fri, 1 Oct 2021 19:20:52 +0300
Message-ID: <ygnhmtnsbtsr.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad277f90-453e-42c8-9558-08d984f77373
X-MS-TrafficTypeDiagnostic: DM5PR12MB1404:
X-Microsoft-Antispam-PRVS: <DM5PR12MB14048C9FD724E5CA4FC3F5CBA0AB9@DM5PR12MB1404.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3fZpsKMv1Z7sAvdjCk0lnZ8bHyY2JFnl/YN9Q64CZZk8qNlYSA2Rv/qh0xHvZwLH+zg1TfdUE2JzCZhZ27wOVuZkZkyqdo/FU7YS5S6onwVm8j44EBD52xYeoUv6nz6shsl8rO+3NzoLHTlRdoEuBFoeOiENy11ZkN6tPooUzL/ifs/XF9yMNPr8N/mWWf70sLHppC73mzfCxYhTro4pLXuYIgKOSKg/+uTTjXkBJu8xYudr86JsEsdK6899XQofZ1U4tAjQvIW2pUxzDUCELxGsLoVqBXznGLnT2Q0qoLB/1r9tnTjbnvmWMryCwYvkKjZrzrnHE/LyyrxD8Ojfbt5KbrOdm4mx7e5Y6NUw0HgMhCgQ6kqbDHha6bHOiht23ITw1CtR/3GYyhE/RK276KwlDDoM/ACTuhn1kJ2/Vp1VGV5na+UQklSU1nsU/kRQVSDuvSIIU+KvxuGZJLd8bSRtfgMrAzmV8hh2H4rwFDYMNCfgf89huk5YKZx3eIYY1+8BW/32YhH8vOqJ7NejiRuKq296A4u7jtnobllw91bOrt1T96VNvxih/020baVeIamj8irQBsPbfxL23LHi4iNnnOcNF4bbgkXp0NEGOdBUUaAYMMUKtDHPC4kTUI7NupAnFjV0aVgnLnnLROMJS/JiYQizxqwnLOX1w8AN+diGOjxfMZqlqVaeryJH4iP5qfu9qr+Cl8pKRcNK+dHqdPo/IkA4pUrNsLJlV7uAoCg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70206006)(83380400001)(82310400003)(4326008)(36860700001)(2906002)(47076005)(86362001)(70586007)(36906005)(26005)(54906003)(316002)(6916009)(5660300002)(7636003)(356005)(16526019)(8936002)(426003)(336012)(508600001)(36756003)(7696005)(2616005)(8676002)(186003)(30864003)(4226004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 16:20:57.5960
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad277f90-453e-42c8-9558-08d984f77373
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1404
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 01 Oct 2021 at 14:32, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> offload tc action.
>
> We add skip_hw and skip_sw for user to control if offload the action
> to hardware.
>
> Make some basic changes for different vendors to return EOPNOTSUPP.
>
> We need to call tc_cleanup_flow_action to clean up tc action entry since
> in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> action.
>
> drivers should update the hw_counter in flow action to indicate it
> accepts to offload the action.
>
> Add a basic process to delete offloaded actions from net device.
>
> As per review from the RFC, the kernel test robot will fail to run, so
> we add CONFIG_NET_CLS_ACT control for the action offload.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
>  .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
>  .../ethernet/netronome/nfp/flower/offload.c   |   3 +
>  include/linux/netdevice.h                     |   1 +
>  include/net/act_api.h                         |   3 +-
>  include/net/flow_offload.h                    |  27 ++
>  include/net/pkt_cls.h                         |  40 +++
>  include/uapi/linux/pkt_cls.h                  |  12 +-
>  net/core/flow_offload.c                       |  43 ++-
>  net/sched/act_api.c                           | 251 +++++++++++++++++-
>  net/sched/cls_api.c                           |  29 +-
>  11 files changed, 395 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index e6a4a768b10b..8c9bab932478 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1962,7 +1962,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
>  				 void *data,
>  				 void (*cleanup)(struct flow_block_cb *block_cb))
>  {
> -	if (!bnxt_is_netdev_indr_offload(netdev))
> +	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
>  		return -EOPNOTSUPP;
>  
>  	switch (type) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index 398c6761eeb3..5e69357df295 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -497,6 +497,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
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
> index 64c0ef57ad42..17190fe17a82 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -1867,6 +1867,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
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
> index d79163208dfd..a5fa6fa91772 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -916,6 +916,7 @@ enum tc_setup_type {
>  	TC_SETUP_QDISC_TBF,
>  	TC_SETUP_QDISC_FIFO,
>  	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>  };
>  
>  /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index f19f7f4a463c..656a74002a98 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -44,6 +44,7 @@ struct tc_action {
>  	u8			hw_stats;
>  	u8			used_hw_stats;
>  	bool			used_hw_stats_valid;
> +	u32 in_hw_count;
>  };
>  #define tcf_index	common.tcfa_index
>  #define tcf_refcnt	common.tcfa_refcnt
> @@ -239,7 +240,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
>  void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>  			     u64 drops, bool hw);
>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
> -
> +int tcf_action_offload_del(struct tc_action *action);
>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct tcf_chain **handle,
>  			     struct netlink_ext_ack *newchain);
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3961461d9c8b..bf76baca579d 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -148,6 +148,10 @@ enum flow_action_id {
>  	FLOW_ACTION_MPLS_MANGLE,
>  	FLOW_ACTION_GATE,
>  	FLOW_ACTION_PPPOE_PUSH,
> +	FLOW_ACTION_PEDIT, /* generic action type of pedit action for action
> +			    * offload, it will be different type when adding
> +			    * tc actions
> +			    */

This doesn't seem to be used anywhere in the series (it is set by
flow_action_init() but never read). It is also confusing to add another
id for pedit when FLOW_ACTION_{ADD|MANGLE} already exists in same enum.

>  	NUM_FLOW_ACTIONS,
>  };
>  
> @@ -552,6 +556,29 @@ struct flow_cls_offload {
>  	u32 classid;
>  };
>  
> +enum flow_act_command {
> +	FLOW_ACT_REPLACE,
> +	FLOW_ACT_DESTROY,
> +	FLOW_ACT_STATS,
> +};
> +
> +enum flow_act_hw_oper {
> +	FLOW_ACT_HW_ADD,
> +	FLOW_ACT_HW_UPDATE,
> +	FLOW_ACT_HW_DEL,
> +};
> +
> +struct flow_offload_action {
> +	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
> +	enum flow_act_command command;
> +	enum flow_action_id id;
> +	u32 index;
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
> index 83a6d0792180..3bb4e6f45038 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -258,6 +258,34 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  	for (; 0; (void)(i), (void)(a), (void)(exts))
>  #endif
>  
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
> +static inline bool tc_act_skip_hw(u32 flags)
> +{
> +	return (flags & TCA_ACT_FLAGS_SKIP_HW) ? true : false;
> +}
> +
> +static inline bool tc_act_skip_sw(u32 flags)
> +{
> +	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
> +}
> +
> +static inline bool tc_act_in_hw(u32 flags)
> +{
> +	return (flags & TCA_ACT_FLAGS_IN_HW) ? true : false;
> +}
> +
> +/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
> +static inline bool tc_act_flags_valid(u32 flags)
> +{
> +	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
> +	if (!(flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW)))
> +		return false;

Can be simplified to just:

return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);

> +
> +	return true;
> +}
> +
>  static inline void
>  tcf_exts_stats_update(const struct tcf_exts *exts,
>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -532,8 +560,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
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
> +	return 0;
> +}
> +#endif
> +
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[]);
>  void tc_cleanup_flow_action(struct flow_action *flow_action);
>  
>  int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -554,6 +593,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>  			  enum tc_setup_type type, void *type_data,
>  			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>  unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions_single(struct tc_action *act);
>  
>  #ifdef CONFIG_NET_CLS_ACT
>  int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 6836ccb9c45d..616e78cde822 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -19,13 +19,19 @@ enum {
>  	TCA_ACT_FLAGS,
>  	TCA_ACT_HW_STATS,
>  	TCA_ACT_USED_HW_STATS,
> +	TCA_ACT_IN_HW_COUNT,
>  	__TCA_ACT_MAX
>  };
>  
>  /* See other TCA_ACT_FLAGS_ * flags in include/net/act_api.h. */
> -#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
> -					 * actions stats.
> -					 */
> +#define TCA_ACT_FLAGS_NO_PERCPU_STATS (1 << 0) /* Don't use percpu allocator for
> +						* actions stats.
> +						*/
> +#define TCA_ACT_FLAGS_SKIP_HW	(1 << 1) /* don't offload action to HW */
> +#define TCA_ACT_FLAGS_SKIP_SW	(1 << 2) /* don't use action in SW */
> +#define TCA_ACT_FLAGS_IN_HW	(1 << 3) /* action is offloaded to HW */
> +#define TCA_ACT_FLAGS_NOT_IN_HW	(1 << 4) /* action isn't offloaded to HW */
> +#define TCA_ACT_FLAGS_VERBOSE	(1 << 5) /* verbose logging */

Doesn't seem to be used anywhere.

>  
>  /* tca HW stats type
>   * When user does not pass the attribute, he does not care.
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6beaea13564a..6676431733ef 100644
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
> @@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
>  				void (*cleanup)(struct flow_block_cb *block_cb))
>  {
>  	struct flow_indr_dev *this;
> +	u32 count = 0;
> +	int err;
>  
>  	mutex_lock(&flow_indr_block_lock);
> +	if (bo) {
> +		if (bo->command == FLOW_BLOCK_BIND)
> +			indir_dev_add(data, dev, sch, type, cleanup, bo);
> +		else if (bo->command == FLOW_BLOCK_UNBIND)
> +			indir_dev_remove(data);
> +	}
>  
> -	if (bo->command == FLOW_BLOCK_BIND)
> -		indir_dev_add(data, dev, sch, type, cleanup, bo);
> -	else if (bo->command == FLOW_BLOCK_UNBIND)
> -		indir_dev_remove(data);
> -
> -	list_for_each_entry(this, &flow_block_indr_dev_list, list)
> -		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
> +	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
> +		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
> +		if (!err)
> +			count++;
> +	}
>  
>  	mutex_unlock(&flow_indr_block_lock);
>  
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 7dd3a2dc5fa4..3e18f3456afa 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -21,6 +21,19 @@
>  #include <net/pkt_cls.h>
>  #include <net/act_api.h>
>  #include <net/netlink.h>
> +#include <net/tc_act/tc_pedit.h>
> +#include <net/tc_act/tc_mirred.h>
> +#include <net/tc_act/tc_vlan.h>
> +#include <net/tc_act/tc_tunnel_key.h>
> +#include <net/tc_act/tc_csum.h>
> +#include <net/tc_act/tc_gact.h>
> +#include <net/tc_act/tc_police.h>
> +#include <net/tc_act/tc_sample.h>
> +#include <net/tc_act/tc_skbedit.h>
> +#include <net/tc_act/tc_ct.h>
> +#include <net/tc_act/tc_mpls.h>
> +#include <net/tc_act/tc_gate.h>
> +#include <net/flow_offload.h>
>  
>  #ifdef CONFIG_INET
>  DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
> @@ -145,6 +158,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
>  	if (refcount_dec_and_mutex_lock(&p->tcfa_refcnt, &idrinfo->lock)) {
>  		if (bind)
>  			atomic_dec(&p->tcfa_bindcnt);
> +		tcf_action_offload_del(p);
>  		idr_remove(&idrinfo->action_idr, p->tcfa_index);
>  		mutex_unlock(&idrinfo->lock);

I'm curious whether it is required to call tcf_action_offload_del()
inside idrinfo->lock critical section here.

>  
> @@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
>  		return -EPERM;
>  
>  	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
> +		tcf_action_offload_del(p);
>  		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
>  		tcf_action_cleanup(p);
>  		return ACT_P_DELETED;
> @@ -448,6 +463,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
>  		if (refcount_dec_and_test(&p->tcfa_refcnt)) {
>  			struct module *owner = p->ops->owner;
>  
> +			tcf_action_offload_del(p);
>  			WARN_ON(p != idr_remove(&idrinfo->action_idr,
>  						p->tcfa_index));
>  			mutex_unlock(&idrinfo->lock);
> @@ -733,6 +749,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>  			jmp_prgcnt -= 1;
>  			continue;
>  		}
> +
> +		if (tc_act_skip_sw(a->tcfa_flags))
> +			continue;
>  repeat:
>  		ret = a->ops->act(skb, a, res);
>  		if (ret == TC_ACT_REPEAT)
> @@ -838,6 +857,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>  			       a->tcfa_flags, a->tcfa_flags))
>  		goto nla_put_failure;
>  
> +	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
> +		goto nla_put_failure;
> +
>  	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
>  	if (nest == NULL)
>  		goto nla_put_failure;
> @@ -917,7 +939,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
>  	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
>  				    .len = TC_COOKIE_MAX_SIZE },
>  	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
> -	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
> +	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
> +							TCA_ACT_FLAGS_SKIP_HW |
> +							TCA_ACT_FLAGS_SKIP_SW),
>  	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
>  };
>  
> @@ -1030,8 +1054,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  			}
>  		}
>  		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
> -		if (tb[TCA_ACT_FLAGS])
> +		if (tb[TCA_ACT_FLAGS]) {
>  			userflags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
> +			if (!tc_act_flags_valid(userflags.value)) {
> +				err = -EINVAL;
> +				goto err_out;
> +			}
> +		}
>  
>  		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
>  				userflags.value | flags, extack);
> @@ -1059,6 +1088,219 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>  	return ERR_PTR(err);
>  }
>  
> +static int flow_action_init(struct flow_offload_action *fl_action,
> +			    struct tc_action *act,
> +			    enum flow_act_command cmd,
> +			    struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (!fl_action)
> +		return -EINVAL;
> +
> +	fl_action->extack = extack;
> +	fl_action->command = cmd;
> +	fl_action->index = act->tcfa_index;
> +
> +	if (is_tcf_gact_ok(act)) {
> +		fl_action->id = FLOW_ACTION_ACCEPT;
> +	} else if (is_tcf_gact_shot(act)) {
> +		fl_action->id = FLOW_ACTION_DROP;
> +	} else if (is_tcf_gact_trap(act)) {
> +		fl_action->id = FLOW_ACTION_TRAP;
> +	} else if (is_tcf_gact_goto_chain(act)) {
> +		fl_action->id = FLOW_ACTION_GOTO;
> +	} else if (is_tcf_mirred_egress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT;
> +	} else if (is_tcf_mirred_egress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED;
> +	} else if (is_tcf_mirred_ingress_redirect(act)) {
> +		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
> +	} else if (is_tcf_mirred_ingress_mirror(act)) {
> +		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
> +	} else if (is_tcf_vlan(act)) {
> +		switch (tcf_vlan_action(act)) {
> +		case TCA_VLAN_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_VLAN_PUSH;
> +			break;
> +		case TCA_VLAN_ACT_POP:
> +			fl_action->id = FLOW_ACTION_VLAN_POP;
> +			break;
> +		case TCA_VLAN_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
> +			break;
> +		default:
> +			err = -EOPNOTSUPP;
> +			goto err_out;
> +		}
> +	} else if (is_tcf_tunnel_set(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
> +	} else if (is_tcf_tunnel_release(act)) {
> +		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
> +	} else if (is_tcf_pedit(act)) {
> +		fl_action->id = FLOW_ACTION_PEDIT;
> +	} else if (is_tcf_csum(act)) {
> +		fl_action->id = FLOW_ACTION_CSUM;
> +	} else if (is_tcf_skbedit_mark(act)) {
> +		fl_action->id = FLOW_ACTION_MARK;
> +	} else if (is_tcf_sample(act)) {
> +		fl_action->id = FLOW_ACTION_SAMPLE;
> +	} else if (is_tcf_police(act)) {
> +		fl_action->id = FLOW_ACTION_POLICE;
> +	} else if (is_tcf_ct(act)) {
> +		fl_action->id = FLOW_ACTION_CT;
> +	} else if (is_tcf_mpls(act)) {
> +		switch (tcf_mpls_action(act)) {
> +		case TCA_MPLS_ACT_PUSH:
> +			fl_action->id = FLOW_ACTION_MPLS_PUSH;
> +			break;
> +		case TCA_MPLS_ACT_POP:
> +			fl_action->id = FLOW_ACTION_MPLS_POP;
> +			break;
> +		case TCA_MPLS_ACT_MODIFY:
> +			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
> +			break;
> +		default:
> +			err = -EOPNOTSUPP;
> +			goto err_out;
> +		}
> +	} else if (is_tcf_skbedit_ptype(act)) {
> +		fl_action->id = FLOW_ACTION_PTYPE;
> +	} else if (is_tcf_skbedit_priority(act)) {
> +		fl_action->id = FLOW_ACTION_PRIORITY;
> +	} else if (is_tcf_gate(act)) {
> +		fl_action->id = FLOW_ACTION_GATE;
> +	} else {
> +		goto err_out;
> +	}
> +	return 0;
> +
> +err_out:
> +	return err;
> +}

Why is this function needed? It sets flow_offload_action->id, but
similar value is also set in flow_offload_action->entries[]->id.

> +
> +static void flow_action_update_hw(struct tc_action *act,
> +				  u32 hw_count,
> +				  enum flow_act_hw_oper cmd)

Enum flow_act_hw_oper is defined together with similar-ish enum
flow_act_command and only instance of flow_act_hw_oper is called "cmd"
which is confusing. More thoughts in next comment.

> +{
> +	if (!act)
> +		return;
> +
> +	switch (cmd) {
> +	case FLOW_ACT_HW_ADD:
> +		act->in_hw_count = hw_count;
> +		break;
> +	case FLOW_ACT_HW_UPDATE:
> +		act->in_hw_count += hw_count;
> +		break;
> +	case FLOW_ACT_HW_DEL:
> +		act->in_hw_count = act->in_hw_count > hw_count ?
> +				   act->in_hw_count - hw_count : 0;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	if (act->in_hw_count) {
> +		act->tcfa_flags &= ~TCA_ACT_FLAGS_NOT_IN_HW;
> +		act->tcfa_flags |= TCA_ACT_FLAGS_IN_HW;
> +	} else {
> +		act->tcfa_flags &= ~TCA_ACT_FLAGS_IN_HW;
> +		act->tcfa_flags |= TCA_ACT_FLAGS_NOT_IN_HW;
> +	}

I guess this could be just split to three one-liners for add/update/del,
if not for common code to update flags. Such simplification would also
probably remove the need for flow_act_hw_oper enum. I know I suggested
mimicking similar classifier infrastructure, but after thinking about it
some more maybe it would be better to parse in_hw_count to determine
whether action is in hardware (and either only set {not_}in_hw flags
before dumping to user space or get rid of them altogether)? After all,
it seems that having both in classifier API is just due to historic
reasons - in_hw flags were added first and couldn't be removed in order
not to break userland after in_hw_count was implemented. WDYT?

> +}
> +
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  u32 *hw_count,
> +				  struct netlink_ext_ack *extack)
> +{
> +	int err;
> +
> +	if (IS_ERR(fl_act))
> +		return PTR_ERR(fl_act);
> +
> +	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
> +
> +	if (err < 0)
> +		return err;
> +
> +	if (hw_count)
> +		*hw_count = err;
> +
> +	return 0;
> +}
> +
> +/* offload the tc command after inserted */
> +static int tcf_action_offload_add(struct tc_action *action,
> +				  struct netlink_ext_ack *extack)
> +{
> +	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
> +	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> +		[0] = action,
> +	};
> +	struct flow_offload_action *fl_action;
> +	u32 in_hw_count = 0;
> +	int err = 0;
> +
> +	if (tc_act_skip_hw(action->tcfa_flags))
> +		return 0;
> +
> +	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
> +	if (!fl_action)
> +		return -EINVAL;
> +
> +	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
> +	if (err)
> +		goto fl_err;
> +
> +	err = tc_setup_action(&fl_action->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to setup tc actions for offload\n");
> +		goto fl_err;
> +	}
> +
> +	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
> +	if (!err)
> +		flow_action_update_hw(action, in_hw_count, FLOW_ACT_HW_ADD);
> +
> +	if (skip_sw && !tc_act_in_hw(action->tcfa_flags))
> +		err = -EINVAL;
> +
> +	tc_cleanup_flow_action(&fl_action->action);
> +
> +fl_err:
> +	kfree(fl_action);
> +
> +	return err;
> +}
> +
> +int tcf_action_offload_del(struct tc_action *action)
> +{
> +	struct flow_offload_action fl_act;
> +	u32 in_hw_count = 0;
> +	int err = 0;
> +
> +	if (!action)
> +		return -EINVAL;
> +
> +	if (!tc_act_in_hw(action->tcfa_flags))
> +		return 0;
> +
> +	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
> +	if (err)
> +		return err;
> +
> +	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
> +	if (err)
> +		return err;
> +
> +	if (action->in_hw_count != in_hw_count)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  /* Returns numbers of initialized actions or negative error. */
>  
>  int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1101,6 +1343,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
>  		sz += tcf_action_fill_size(act);
>  		/* Start from index 0 */
>  		actions[i - 1] = act;
> +		if (!(flags & TCA_ACT_FLAGS_BIND)) {
> +			err = tcf_action_offload_add(act, extack);
> +			if (tc_act_skip_sw(act->tcfa_flags) && err)
> +				goto err;
> +		}
>  	}
>  
>  	/* We have to commit them all together, because if any error happened in
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 2ef8f5a6205a..351d93988b8b 100644
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
> @@ -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
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
>  #ifdef CONFIG_NET_CLS_ACT
>  static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>  					u32 *p_block_index,

This ~400 lines patch is hard to properly review. I would suggest
splitting it.

