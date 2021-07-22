Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605893D234B
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbhGVLnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 07:43:39 -0400
Received: from mail-mw2nam12on2049.outbound.protection.outlook.com ([40.107.244.49]:32193
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231795AbhGVLni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 07:43:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsLnvIHOeaHaF3cRtF4l2QDUu/tVpNoihTEjkd8KEILlfjhZgVLu8n17GF7oMwsLEjuzRwOdQ2heI2Xl6KOUtgC+20n8Nf8j2cuLCiUFm6lieybQSb1KG4fEPCPrqTeSGeHA40aTNlidrqQvQWDhgeiuKldQLGIz83eZDtAU+rqw9dBL699ocI1fSw4ASZwvSCw7UcPLGMRVklJTRPCd5SAi9BIsAW8kVQgRROb21btUjT/YEwhh13XWMB6+qkZzSxv6zGofliulCJYzWq4ivLIKVCX1l2k+D/i1sbg/FG+sPiaukFkCWgTJWtWY2HodTUAQVgu4InLlGaYpGqj+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd5qUTFkIAv8avmKYDU0DEWOQJtd8Mdf5TWGx+5w6uY=;
 b=QoKJWsbWTOto5GH/MeRhqmZhIQDzlqZIT0zRJjE9nPkh/hJqzsVhGhYt8TJPGzGi69spL2Tu5nr3Lt67G0aIaP7yjcOy1u311+o+iJjvbu2GLSeMe+G1d1TCyJCVzJeOwXOP9ADZoW71vmrWKQebSv/xGxetNm/aa6k2c+mdE4ikEKq/U+Vfz5Xw1x5MPi6/09nJLCp5ZyDCG7ro9NOmp54aPgUhRj6+M0lgnzWIAKGLW1KLUBYgReNeF+9jfABX7YPW4W5IEIV6Odr325kfDjqD6D6CNvbMLtUVVOQDM/Yj4cUhV59vrv0jF8T75ZK5ePyT6reyUFVNHoriG2pWlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sd5qUTFkIAv8avmKYDU0DEWOQJtd8Mdf5TWGx+5w6uY=;
 b=Qr4kKNq4wlz+0fIea34fluKvn2FoprvwVnlnq+rKykfJ2RBlPxhRn1mkI1TdoT3qQnlTNliVNjwhMViwZdgQZENEmFV31Fcj/8KzRZAEBVojI5pYoSp8XE/v6bS4Y5h8oZvk1MeAEI4nQiBo85yY72ng0P677tcbqc8ycMXuw+P0bbBq94xhh51fCbRZX7s9WonXLUTvbEA5iOo76xBYz3aDa4bBGWuBKPkPReyzmvQKmmtxl/dPAENZO/LOKK4SeoBQQZDdDSO3uUkl/Mb9WbNrb2cyoAvfymaGPCUcg2ehg1AsaroeyeXbdCezqbNIBX4lAUqfnmm4K1GdBmOwZQ==
Received: from DM5PR13CA0016.namprd13.prod.outlook.com (2603:10b6:3:23::26) by
 MW3PR12MB4476.namprd12.prod.outlook.com (2603:10b6:303:2d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.24; Thu, 22 Jul 2021 12:24:12 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:23:cafe::ba) by DM5PR13CA0016.outlook.office365.com
 (2603:10b6:3:23::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend
 Transport; Thu, 22 Jul 2021 12:24:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 12:24:12 +0000
Received: from [172.27.14.135] (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 12:24:09 +0000
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Louis Peens" <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <2b7f3729-2f87-881b-6b1f-d21ed2df3b20@nvidia.com>
Date:   Thu, 22 Jul 2021 15:24:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722091938.12956-2-simon.horman@corigine.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 934917e7-bfd5-4f13-46d9-08d94d0b9cfd
X-MS-TrafficTypeDiagnostic: MW3PR12MB4476:
X-Microsoft-Antispam-PRVS: <MW3PR12MB44765D817F6617521A5C8917B8E49@MW3PR12MB4476.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQLcg97M2vLNWqmkYdMkjdq3I3DPgemU+s8VzIgbYAdH7JamEAVhhrMzMa1LT3JKqyPl91yjh+DWb3x2bo/o3cXaFCbs7KYFGyh98d2yFQCMashcLZh8E/8Zq9Y1Uwx4jRq8BpN81hI6iNaI4wUkjJlf8jVogHQsA5+aHO9X6ReWfnD+wWxvf71WYuV6iZrbyNCBzdH1vbxK+KpL4GzsaT8/bcsf5pFqnaxhOZMw8/uHRmouLhazLEsbPjgrdW7uqM7/gXKbKOHQglruQjA1+lna/+7TYESunz9Gp7S3mf7KygixuTm0LPwAzBh9Ev6Jobvx/ldQTmz5FBTG9a/UmEfNZgN9YEvoEvlrsMRJsKnN4j6F2PdvYU8acZY+9MdTJTMkAGqo2g8gI5bkEdG31dFQjSxbrQ22fW+/cIOoE+tK49Y9lz1hpuluC78kdmNET+7TsBEzzZEjFRd8cOMVQphWmGmT4miyxn75QbN5EGGJO+EPGpKcPAcmMyeZZqUmTrgSJoFLUv1FP37Wxx+4/MjfKMGQubnodMOJzhHyXspzMOwfGqAOOZa/V6FoIdNMRwiHMpKK2e2Ra4PgaCB7BKUr1OW4/FwWcOrn+ReGP0/ZlTAfecuQcSF4UCC06g4gHK24RN+yQXy8fZ9nFiwFDAVvSHgJqYKrKIzgkaGfKve2/kLJonB0qjwuZBY6yCM/D4g1xqVRmSGljHqakxCJeYlrBFetKezR9C9QR4IrQYc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(70586007)(336012)(110136005)(26005)(47076005)(54906003)(36860700001)(316002)(5660300002)(508600001)(53546011)(16576012)(186003)(31686004)(4326008)(31696002)(356005)(30864003)(2616005)(8676002)(7636003)(70206006)(86362001)(36906005)(82310400003)(16526019)(83380400001)(36756003)(8936002)(2906002)(426003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 12:24:12.2050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 934917e7-bfd5-4f13-46d9-08d94d0b9cfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4476
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-22 12:19 PM, Simon Horman wrote:
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
>   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
>   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
>   .../ethernet/netronome/nfp/flower/offload.c   |  3 ++
>   include/linux/netdevice.h                     |  1 +
>   include/net/flow_offload.h                    | 15 ++++++++
>   include/net/pkt_cls.h                         | 15 ++++++++
>   net/core/flow_offload.c                       | 26 +++++++++++++-
>   net/sched/act_api.c                           | 33 +++++++++++++++++
>   net/sched/cls_api.c                           | 36 ++++++++++++++++---
>   9 files changed, 128 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 5e4429b14b8c..edbbf7b4df77 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -1951,7 +1951,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
>   				 void *data,
>   				 void (*cleanup)(struct flow_block_cb *block_cb))
>   {
> -	if (!bnxt_is_netdev_indr_offload(netdev))
> +	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
>   		return -EOPNOTSUPP;
>   
>   	switch (type) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index 059799e4f483..111daacc4cc3 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -486,6 +486,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
>   			    void *data,
>   			    void (*cleanup)(struct flow_block_cb *block_cb))
>   {
> +	if (!netdev)
> +		return -EOPNOTSUPP;
> +
>   	switch (type) {
>   	case TC_SETUP_BLOCK:
>   		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> index 2406d33356ad..88bbc86347b4 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -1869,6 +1869,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
>   			    void *data,
>   			    void (*cleanup)(struct flow_block_cb *block_cb))
>   {
> +	if (!netdev)
> +		return -EOPNOTSUPP;
> +
>   	if (!nfp_fl_is_netdev_to_offload(netdev))
>   		return -EOPNOTSUPP;
>   
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 42f6f866d5f3..b138219baf6f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -923,6 +923,7 @@ enum tc_setup_type {
>   	TC_SETUP_QDISC_TBF,
>   	TC_SETUP_QDISC_FIFO,
>   	TC_SETUP_QDISC_HTB,
> +	TC_SETUP_ACT,
>   };
>   
>   /* These structures hold the attributes of bpf state that are being passed
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 69c9eabf8325..26644596fd54 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -553,6 +553,21 @@ struct flow_cls_offload {
>   	u32 classid;
>   };
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
>   static inline struct flow_rule *
>   flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
>   {
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index ec7823921bd2..cd4cf6b10f5d 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -266,6 +266,9 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>   	for (; 0; (void)(i), (void)(a), (void)(exts))
>   #endif
>   
> +#define tcf_act_for_each_action(i, a, actions) \
> +	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
> +
>   static inline void
>   tcf_exts_stats_update(const struct tcf_exts *exts,
>   		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> @@ -536,8 +539,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
>   	return ifindex == skb->skb_iif;
>   }
>   
> +#ifdef CONFIG_NET_CLS_ACT
>   int tc_setup_flow_action(struct flow_action *flow_action,
>   			 const struct tcf_exts *exts);
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
>   void tc_cleanup_flow_action(struct flow_action *flow_action);
>   
>   int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
> @@ -558,6 +572,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
>   			  enum tc_setup_type type, void *type_data,
>   			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
>   unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
> +unsigned int tcf_act_num_actions(struct tc_action *actions[]);
>   
>   #ifdef CONFIG_NET_CLS_ACT
>   int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 715b67f6c62f..0fa2f75cc9b3 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
>   }
>   EXPORT_SYMBOL(flow_rule_alloc);
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

Hi Simon,

Our automatic tests got a trace from flow_action_alloc()
introduced in this series.
I don't have specific commands right now but maybe its easy
to reproduce with option CONFIG_DEBUG_ATOMIC_SLEEP=y

fl_dump->fl_hw_update_stats->fl_hw_update_stats->tcf_exts_stats_update
   ->tcf_action_update_hw_stats->tcf_action_offload_cmd_pre->
     ->flow_action_alloc

Thanks,
Roi



[  761.008866] BUG: sleeping function called from invalid context at 
include/linux/sched/mm.h:201
[  761.011047] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 
20194, name: handler1
[  761.013052] INFO: lockdep is turned off.
[  761.014102] CPU: 1 PID: 20194 Comm: handler1 Not tainted 
5.14.0-rc1_2021_07_22_09_58_22_ #1
[  761.015891] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  761.017190] Call Trace:
[  761.017556]  dump_stack_lvl+0x57/0x7d
[  761.018038]  ___might_sleep.cold+0x15a/0x1b7
[  761.018583]  __kmalloc+0x259/0x430
[  761.019044]  ? flow_action_alloc+0x28/0xd0
[  761.019574]  ? lock_release+0x460/0x750
[  761.020068]  flow_action_alloc+0x28/0xd0
[  761.020586]  tcf_action_offload_cmd_pre+0x25/0x130
[  761.021188]  tcf_action_update_hw_stats+0x9e/0x2e0
[  761.021791]  ? tcf_action_offload_cmd+0xe0/0xe0
[  761.022358]  ? is_bpf_text_address+0x73/0x110
[  761.022918]  ? mlx5e_delete_flower+0xf50/0xf50 [mlx5_core]
[  761.023713]  ? tc_setup_cb_call+0x181/0x270
[  761.024254]  fl_hw_update_stats+0x2e4/0x4e0 [cls_flower]
[  761.024908]  ? fl_hw_replace_filter+0x6a0/0x6a0 [cls_flower]
[  761.025595]  ? lock_release+0x460/0x750
[  761.026095]  ? memcpy+0x39/0x60
[  761.026537]  fl_dump+0x499/0x5f0 [cls_flower]
[  761.027106]  ? fl_tmplt_dump+0x220/0x220 [cls_flower]
[  761.027746]  ? memcpy+0x39/0x60
[  761.028173]  ? nla_put+0x15f/0x1c0
[  761.028634]  tcf_fill_node+0x50f/0x930
[  761.029137]  ? __tcf_get_next_proto+0x470/0x470
[  761.029725]  ? memset+0x20/0x40
[  761.030167]  tfilter_notify+0x15e/0x2d0
[  761.030681]  tc_new_tfilter+0x1128/0x1ea0
[  761.031218]  ? tc_del_tfilter+0x13e0/0x13e0
[  761.031768]  ? security_capable+0x51/0x90
[  761.032280]  ? tc_del_tfilter+0x13e0/0x13e0
[  761.032826]  rtnetlink_rcv_msg+0x637/0x950



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
>   #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
>   	const struct flow_match *__m = &(__rule)->match;			\
>   	struct flow_dissector *__d = (__m)->dissector;				\
> @@ -476,6 +497,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
>   
>   	mutex_unlock(&flow_indr_block_lock);
>   
> -	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	if (bo)
> +		return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
> +	else
> +		return 0;
>   }
>   EXPORT_SYMBOL(flow_indr_dev_setup_offload);
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 998a2374f7ae..185f17ea60d5 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1060,6 +1060,36 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>   	return ERR_PTR(err);
>   }
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
>   /* Returns numbers of initialized actions or negative error. */
>   
>   int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1514,6 +1544,9 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
>   		return ret;
>   	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
>   
> +	/* offload actions to hardware if possible */
> +	tcf_action_offload_cmd(actions, extack);
> +
>   	/* only put existing actions */
>   	for (i = 0; i < TCA_ACT_MAX_PRIO; i++)
>   		if (init_res[i] == ACT_P_CREATED)
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index c8cb59a11098..9b9770dab5e8 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
>   	return hw_stats;
>   }
>   
> -int tc_setup_flow_action(struct flow_action *flow_action,
> -			 const struct tcf_exts *exts)
> +int tc_setup_action(struct flow_action *flow_action,
> +		    struct tc_action *actions[])
>   {
>   	struct tc_action *act;
>   	int i, j, k, err = 0;
> @@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
>   	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
>   
> -	if (!exts)
> +	if (!actions)
>   		return 0;
>   
>   	j = 0;
> -	tcf_exts_for_each_action(i, act, exts) {
> +	tcf_act_for_each_action(i, act, actions) {
>   		struct flow_action_entry *entry;
>   
>   		entry = &flow_action->entries[j];
> @@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   	spin_unlock_bh(&act->tcfa_lock);
>   	goto err_out;
>   }
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
>   EXPORT_SYMBOL(tc_setup_flow_action);
> +#endif
>   
>   unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>   {
> @@ -3743,6 +3755,22 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
>   }
>   EXPORT_SYMBOL(tcf_exts_num_actions);
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
>   #ifdef CONFIG_NET_CLS_ACT
>   static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
>   					u32 *p_block_index,
> 
