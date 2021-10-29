Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F3F44014E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhJ2ReE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:34:04 -0400
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:11264
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229826AbhJ2ReD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:34:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvyRAKI7K8L468mn+n1Rbopv4cFAHxjZpRf/b13hEhQgoHnS92T6NJJq+GSlapSQiAQH4uEv5e6JWw/XZvExlY6qXQ8iTuyD2mlfAHVce5FAPmivOJ5FnZatrrJyd075/LCoLCr3mvNmnAcHD6ctC4d8wjbLeYN7lzN+0/z4V9nuzFOxfVD7xxyJf/L3q3ChinBMf6mCr6JoKtCQScW+LGbpIbRsMWzS/irdHaCJAI1WvumSR/1T8WR5kTEDpKpQjLu/6b44o0nU6mppGxT9jjIM/sCdbpL8q5jLPfEHOcUgRwujGUfNm/IagdLfKT+PQgnNTr/KkawcCYINW1l+CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D4199jQo1yiZt+7lO5agehCzYV0xCu0855Dv+/IOSyQ=;
 b=e2hx/YNSsGNiBpjFntYxn/ZqFysHySvp9LOHWuBIob4o6J8mnzKFAx5ZJFV9ODW+0yphAdQ5ECASoYBZ3NYDyN0JT2RvU/4yVRUSbloxtphShDLSZNsEu0hwMuUse2GHk30chLqvO12hOG7x7JRCMiqzcQO3Zrds8t4s2L4B6lhYB+/FspBlWFY9ycz6f+trilLy9gK4CRx7XAaXpHR8LqyKy159OXF+S0CXBwBba3sT2cMKHMyQ3AjC5dH/BuQ87cvFCTkL47dct+ZJDD9PKJv2ukP5Bpfwx8LC5UMu4x+WvljqYyvjZDiatdgbgSe/Uvuh53GYlmMWiulew7uqDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D4199jQo1yiZt+7lO5agehCzYV0xCu0855Dv+/IOSyQ=;
 b=qdaQH0+n6KwXOfYk7Y0gLMRz8KnLAx6vrH7ftzIWpMUScFk+xExY8bOjOJAHYOGXDZmvgrG9x4bj5ch8bUbNovzym5QnbLzEV92lsa2R+H31PTA8X6igAzTef3dNqrTRSA4D/lihG1zBrUv1s2QpziLnE5+al8L739v5MwZas/tL/bwqkvrNw4FFx28c7ezpaV3kdUr/EY6HMNAqLJJtmlPZ++LY1NFlUVNDLHCfhwjnf6ZaHKR8TvZKL3SmoCkCvmVUKcfSineUSQoFCtKXmz3nWTR4gQBFId0NPB0v1+17V/JJw11GBuHQzPYS6Ak/8fqmRVo3Z3NfIasqFrxrdg==
Received: from BN6PR2001CA0023.namprd20.prod.outlook.com
 (2603:10b6:404:b4::33) by CO6PR12MB5460.namprd12.prod.outlook.com
 (2603:10b6:5:357::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 17:31:29 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:b4:cafe::b6) by BN6PR2001CA0023.outlook.office365.com
 (2603:10b6:404:b4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend
 Transport; Fri, 29 Oct 2021 17:31:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Fri, 29 Oct 2021 17:31:28 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 29 Oct 2021 17:31:24 +0000
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-8-simon.horman@corigine.com>
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
Subject: Re: [RFC/PATCH net-next v3 7/8] flow_offload: add reoffload process
 to update hw_count
In-Reply-To: <20211028110646.13791-8-simon.horman@corigine.com>
Date:   Fri, 29 Oct 2021 20:31:22 +0300
Message-ID: <ygnhlf2bagb9.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 890907ec-e01e-47b3-a9ea-08d99b01f0c9
X-MS-TrafficTypeDiagnostic: CO6PR12MB5460:
X-Microsoft-Antispam-PRVS: <CO6PR12MB546040AA8AFE01A6050A665EA0879@CO6PR12MB5460.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HObd58P9HmwvFTz3Om6vWOzAdKCEJNuz/zSyMDryBh9lrrMGWyq0eHv0A12ghTUGWinl7kzxDN+fZ0eHLvLU6igBPxUQ7pQvHp7evOZtz0KvpU0eS7B3MSsKJ9pIoYKE/8uUUaCUEaj/GqKTxyLBZCN6R0MytCvJEFDnGbzhuKiBoU1Psu47kh8FwgZmm4Uq02TUvX1FXaWlDQlHrtemGfM0ALQ93g3kutS21rV73TDqSx2lpI7N0XCURcLvjfTtfC8W2ZodBARlx5ed6vdvImmNPKe+/yeMNGjZaJxNEyEHlCSuAEhfg4cM4gZQXA4IJNjXQVbCanbmjq7CADKTORJhX3hJb2l3bFKnKHhAuAWu8QuHk33GKFu0SF8zt0fLKMcqTp3/DO2SQq2CNcMRnTQ87x2IbsQcGrtrke/avRckxMDBN9+kDnci/BmRIEAAV2alcwVgY/HtL3/LL2pGIgvfT2pHd4at1tr0iG8eG3mEjQp2cejAgRVbZetut+grvtmF4TCRYaSgovdhkPxf4Pv3/D5bvSsskRPtPuEpih6YssmDwnwhlNnUAokwyDYFJSHe3ZuSPBWq976mzQXrg93TbVc4X2gDamqeO6teizb+4VP9BhpublJUfciQaQUkNxkPZE64Tp7YC1YJTOBJdp+YFdwjh/BGhEO3qOGKgO4KC7FJO/15fOn8vV5/X5ukCsgDpdDnql/GXH0t44/PhA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(54906003)(36860700001)(316002)(86362001)(30864003)(2906002)(5660300002)(6916009)(8676002)(4326008)(7696005)(36756003)(15650500001)(426003)(508600001)(356005)(336012)(82310400003)(16526019)(70586007)(70206006)(83380400001)(47076005)(8936002)(2616005)(7636003)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 17:31:28.3358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 890907ec-e01e-47b3-a9ea-08d99b01f0c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5460
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 28 Oct 2021 at 14:06, Simon Horman <simon.horman@corigine.com> wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
>
> Add reoffload process to update hw_count when driver
> is inserted or removed.
>
> When reoffloading actions, we still offload the actions
> that are added independent of filters.
>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  include/net/act_api.h   |  24 +++++
>  include/net/pkt_cls.h   |   5 +
>  net/core/flow_offload.c |   5 +
>  net/sched/act_api.c     | 213 ++++++++++++++++++++++++++++++++++++----
>  4 files changed, 228 insertions(+), 19 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 80a9d1e7d805..03ff39e347c3 100644
> --- a/include/net/act_api.h
> +++ b/include/net/act_api.h
> @@ -7,6 +7,7 @@
>  */
>  
>  #include <linux/refcount.h>
> +#include <net/flow_offload.h>
>  #include <net/sch_generic.h>
>  #include <net/pkt_sched.h>
>  #include <net/net_namespace.h>
> @@ -243,11 +244,26 @@ static inline void flow_action_hw_count_set(struct tc_action *act,
>  	act->in_hw_count = hw_count;
>  }
>  
> +static inline void flow_action_hw_count_inc(struct tc_action *act,
> +					    u32 hw_count)
> +{
> +	act->in_hw_count += hw_count;
> +}
> +
> +static inline void flow_action_hw_count_dec(struct tc_action *act,
> +					    u32 hw_count)
> +{
> +	act->in_hw_count = act->in_hw_count > hw_count ?
> +			   act->in_hw_count - hw_count : 0;
> +}
> +
>  void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
>  			     u64 drops, bool hw);
>  int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
>  int tcf_action_offload_del(struct tc_action *action);
>  int tcf_action_update_hw_stats(struct tc_action *action);
> +int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
> +			    void *cb_priv, bool add);
>  int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
>  			     struct tcf_chain **handle,
>  			     struct netlink_ext_ack *newchain);
> @@ -259,6 +275,14 @@ DECLARE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
>  #endif
>  
>  int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb));
> +
> +#else /* !CONFIG_NET_CLS_ACT */
> +
> +static inline int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
> +					  void *cb_priv, bool add) {
> +	return 0;
> +}
> +
>  #endif /* CONFIG_NET_CLS_ACT */
>  
>  static inline void tcf_action_stats_update(struct tc_action *a, u64 bytes,
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index 88788b821f76..82ac631c50bc 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -284,6 +284,11 @@ static inline bool tc_act_flags_valid(u32 flags)
>  	return flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW);
>  }
>  
> +static inline bool tc_act_bind(u32 flags)
> +{
> +	return !!(flags & TCA_ACT_FLAGS_BIND);
> +}
> +
>  static inline void
>  tcf_exts_stats_update(const struct tcf_exts *exts,
>  		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6676431733ef..d591204af6e0 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -1,6 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #include <linux/kernel.h>
>  #include <linux/slab.h>
> +#include <net/act_api.h>
>  #include <net/flow_offload.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/mutex.h>
> @@ -418,6 +419,8 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  	existing_qdiscs_register(cb, cb_priv);
>  	mutex_unlock(&flow_indr_block_lock);
>  
> +	tcf_action_reoffload_cb(cb, cb_priv, true);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(flow_indr_dev_register);
> @@ -472,6 +475,8 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  
>  	flow_block_indr_notify(&cleanup_list);
>  	kfree(indr_dev);
> +
> +	tcf_action_reoffload_cb(cb, cb_priv, false);

Don't know if it is a problem, but shouldn't tcf_action_reoffload_cb()
be called before flow_block_indr_notify(), which calls
flow_block_indr->cleanup() callbacks?

>  }
>  EXPORT_SYMBOL(flow_indr_dev_unregister);
>  
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 3893ffd91192..dce25d8f147b 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -638,6 +638,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
>  
>  static LIST_HEAD(act_base);
>  static DEFINE_RWLOCK(act_mod_lock);
> +/* since act ops id is stored in pernet subsystem list,
> + * then there is no way to walk through only all the action
> + * subsystem, so we keep tc action pernet ops id for
> + * reoffload to walk through.
> + */
> +static LIST_HEAD(act_pernet_id_list);
> +static DEFINE_MUTEX(act_id_mutex);
> +struct tc_act_pernet_id {
> +	struct list_head list;
> +	unsigned int id;
> +};
> +
> +static int tcf_pernet_add_id_list(unsigned int id)
> +{
> +	struct tc_act_pernet_id *id_ptr;
> +	int ret = 0;
> +
> +	mutex_lock(&act_id_mutex);
> +	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
> +		if (id_ptr->id == id) {
> +			ret = -EEXIST;
> +			goto err_out;
> +		}
> +	}
> +
> +	id_ptr = kzalloc(sizeof(*id_ptr), GFP_KERNEL);
> +	if (!id_ptr) {
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +	id_ptr->id = id;
> +
> +	list_add_tail(&id_ptr->list, &act_pernet_id_list);
> +
> +err_out:
> +	mutex_unlock(&act_id_mutex);
> +	return ret;
> +}
> +
> +static void tcf_pernet_del_id_list(unsigned int id)
> +{
> +	struct tc_act_pernet_id *id_ptr;
> +
> +	mutex_lock(&act_id_mutex);
> +	list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
> +		if (id_ptr->id == id) {
> +			list_del(&id_ptr->list);
> +			kfree(id_ptr);
> +			break;
> +		}
> +	}
> +	mutex_unlock(&act_id_mutex);
> +}
>  
>  int tcf_register_action(struct tc_action_ops *act,
>  			struct pernet_operations *ops)
> @@ -656,18 +709,30 @@ int tcf_register_action(struct tc_action_ops *act,
>  	if (ret)
>  		return ret;
>  
> +	if (ops->id) {
> +		ret = tcf_pernet_add_id_list(*ops->id);
> +		if (ret)
> +			goto id_err;
> +	}
> +
>  	write_lock(&act_mod_lock);
>  	list_for_each_entry(a, &act_base, head) {
>  		if (act->id == a->id || (strcmp(act->kind, a->kind) == 0)) {
> -			write_unlock(&act_mod_lock);
> -			unregister_pernet_subsys(ops);
> -			return -EEXIST;
> +			ret = -EEXIST;
> +			goto err_out;
>  		}
>  	}
>  	list_add_tail(&act->head, &act_base);
>  	write_unlock(&act_mod_lock);
>  
>  	return 0;
> +
> +err_out:
> +	write_unlock(&act_mod_lock);
> +	tcf_pernet_del_id_list(*ops->id);
> +id_err:
> +	unregister_pernet_subsys(ops);
> +	return ret;
>  }
>  EXPORT_SYMBOL(tcf_register_action);
>  
> @@ -686,8 +751,11 @@ int tcf_unregister_action(struct tc_action_ops *act,
>  		}
>  	}
>  	write_unlock(&act_mod_lock);
> -	if (!err)
> +	if (!err) {
>  		unregister_pernet_subsys(ops);
> +		if (ops->id)
> +			tcf_pernet_del_id_list(*ops->id);
> +	}
>  	return err;
>  }
>  EXPORT_SYMBOL(tcf_unregister_action);
> @@ -1175,15 +1243,11 @@ static int flow_action_init(struct flow_offload_action *fl_action,
>  	return 0;
>  }
>  
> -static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> -				  u32 *hw_count,
> -				  struct netlink_ext_ack *extack)
> +static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
> +				     u32 *hw_count)
>  {
>  	int err;
>  
> -	if (IS_ERR(fl_act))
> -		return PTR_ERR(fl_act);
> -
>  	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
>  					  fl_act, NULL, NULL);
>  	if (err < 0)
> @@ -1195,9 +1259,41 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
>  	return 0;
>  }
>  
> +static int tcf_action_offload_cmd_cb_ex(struct flow_offload_action *fl_act,
> +					u32 *hw_count,
> +					flow_indr_block_bind_cb_t *cb,
> +					void *cb_priv)
> +{
> +	int err;
> +
> +	err = cb(NULL, NULL, cb_priv, TC_SETUP_ACT, NULL, fl_act, NULL);
> +	if (err < 0)
> +		return err;
> +
> +	if (hw_count)
> +		*hw_count = 1;
> +
> +	return 0;
> +}
> +
> +static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
> +				  u32 *hw_count,
> +				  flow_indr_block_bind_cb_t *cb,
> +				  void *cb_priv)
> +{
> +	if (IS_ERR(fl_act))
> +		return PTR_ERR(fl_act);
> +
> +	return cb ? tcf_action_offload_cmd_cb_ex(fl_act, hw_count,
> +						 cb, cb_priv) :
> +		    tcf_action_offload_cmd_ex(fl_act, hw_count);
> +}
> +
>  /* offload the tc command after inserted */
> -static int tcf_action_offload_add(struct tc_action *action,
> -				  struct netlink_ext_ack *extack)
> +static int tcf_action_offload_add_ex(struct tc_action *action,
> +				     struct netlink_ext_ack *extack,
> +				     flow_indr_block_bind_cb_t *cb,
> +				     void *cb_priv)
>  {
>  	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
>  	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
> @@ -1225,9 +1321,10 @@ static int tcf_action_offload_add(struct tc_action *action,
>  		goto fl_err;
>  	}
>  
> -	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
> +	err = tcf_action_offload_cmd(fl_action, &in_hw_count, cb, cb_priv);
>  	if (!err)
> -		flow_action_hw_count_set(action, in_hw_count);
> +		cb ? flow_action_hw_count_inc(action, in_hw_count) :
> +		     flow_action_hw_count_set(action, in_hw_count);
>  
>  	if (skip_sw && !tc_act_in_hw(action))
>  		err = -EINVAL;
> @@ -1240,6 +1337,12 @@ static int tcf_action_offload_add(struct tc_action *action,
>  	return err;
>  }
>  
> +static int tcf_action_offload_add(struct tc_action *action,
> +				  struct netlink_ext_ack *extack)
> +{
> +	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
> +}
> +
>  int tcf_action_update_hw_stats(struct tc_action *action)
>  {
>  	struct flow_offload_action fl_act = {};
> @@ -1252,7 +1355,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  	if (err)
>  		goto err_out;
>  
> -	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
> +	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
>  
>  	if (!err && fl_act.stats.lastused) {
>  		preempt_disable();
> @@ -1274,7 +1377,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  }
>  EXPORT_SYMBOL(tcf_action_update_hw_stats);
>  
> -int tcf_action_offload_del(struct tc_action *action)
> +static int tcf_action_offload_del_ex(struct tc_action *action,
> +				     flow_indr_block_bind_cb_t *cb,
> +				     void *cb_priv)
>  {
>  	struct flow_offload_action fl_act;
>  	u32 in_hw_count = 0;
> @@ -1290,13 +1395,83 @@ int tcf_action_offload_del(struct tc_action *action)
>  	if (err)
>  		return err;
>  
> -	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
> -	if (err)
> +	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, cb, cb_priv);
> +	if (err < 0)
>  		return err;
>  
> -	if (action->in_hw_count != in_hw_count)
> +	if (!cb && action->in_hw_count != in_hw_count)
>  		return -EINVAL;
>  
> +	/* do not need to update hw state when deleting action */
> +	if (cb && in_hw_count)
> +		flow_action_hw_count_dec(action, in_hw_count);
> +
> +	return 0;
> +}
> +
> +int tcf_action_offload_del(struct tc_action *action)
> +{
> +	return tcf_action_offload_del_ex(action, NULL, NULL);
> +}
> +
> +int tcf_action_reoffload_cb(flow_indr_block_bind_cb_t *cb,
> +			    void *cb_priv, bool add)
> +{
> +	struct tc_act_pernet_id *id_ptr;
> +	struct tcf_idrinfo *idrinfo;
> +	struct tc_action_net *tn;
> +	struct tc_action *p;
> +	unsigned int act_id;
> +	unsigned long tmp;
> +	unsigned long id;
> +	struct idr *idr;
> +	struct net *net;
> +	int ret;
> +
> +	if (!cb)
> +		return -EINVAL;
> +
> +	down_read(&net_rwsem);
> +	mutex_lock(&act_id_mutex);
> +
> +	for_each_net(net) {
> +		list_for_each_entry(id_ptr, &act_pernet_id_list, list) {
> +			act_id = id_ptr->id;
> +			tn = net_generic(net, act_id);
> +			if (!tn)
> +				continue;
> +			idrinfo = tn->idrinfo;
> +			if (!idrinfo)
> +				continue;
> +
> +			mutex_lock(&idrinfo->lock);
> +			idr = &idrinfo->action_idr;
> +			idr_for_each_entry_ul(idr, p, tmp, id) {
> +				if (IS_ERR(p) || tc_act_bind(p->tcfa_flags))
> +					continue;
> +				if (add) {
> +					tcf_action_offload_add_ex(p, NULL, cb,
> +								  cb_priv);
> +					continue;
> +				}
> +
> +				/* cb unregister to update hw count */
> +				ret = tcf_action_offload_del_ex(p, cb, cb_priv);
> +				if (ret < 0)
> +					continue;
> +				if (tc_act_skip_sw(p->tcfa_flags) &&
> +				    !tc_act_in_hw(p)) {
> +					ret = tcf_idr_release_unsafe(p);
> +					if (ret == ACT_P_DELETED)
> +						module_put(p->ops->owner);
> +				}
> +			}
> +			mutex_unlock(&idrinfo->lock);
> +		}
> +	}
> +	mutex_unlock(&act_id_mutex);
> +	up_read(&net_rwsem);
> +
>  	return 0;
>  }

