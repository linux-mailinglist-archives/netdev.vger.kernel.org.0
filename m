Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C4A4577A0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 21:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhKSUMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 15:12:24 -0500
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:49856
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232099AbhKSUMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 15:12:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ht6rnLpQtkA+aYVDxQBIsVP3NpiWMLSY8cf9rnwMaZA9ecyC+DjS+2aR9BVI5aisu2vhY/D+ryt1liwSCWFUalkBErJGLwFuCI8EDviY41npBmYxqoOnIiWqwGoU7BsRHM0LEY1hQAmCsidr67ORxyY1K2khxVUnIvfLuxGHyQDfxLAmwV3Cfb0qR9R/9wDZTmGmHZ0/erKNWoBAtokOCfxGVQOkD2K4Hb+gQIS/xWCCPUbymLUhEVjLPOeNgfB88NPkQZuQGo40nc+XmYeNE3jbBXhv4PQQe8ZFbapdmB0JtVhdxFjhk5MsWyYbsA9PAV0WpT9H2Q/Fmm4Z/ROLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSk/9IBy3mKpHdAFPsYLiWBYeA8iWRI2xzRaQlyBXE0=;
 b=GoWfaagaTf+LO9YEVlN4f0pqY8uHSO3AFS3c7yzvMERATLXvMk+BTQ8fZCcHL0SuQN4cN54kzUbRoMuC6GzW4pSDXvruMOuJQ6g4CfvhJqAzrI1sSMBt71JuADvWZ/cG7krM+dZWptggRm7s0NDjFMXVSiN1JVXAYGUDhTeHTe/0DC2HEzDJHJjj+ORCNW7ngf1PVDSFqL/zcivvK5W1wytBelT10t0Mx+7VnImlO3/m6TlCzZvkuF/fyXz0TXoPMD0Qe4Nk0JZspS1Ev51omJvtEBW5L6Q+q6c6EHTVCUsf/HLkW6GKnTeW0fptccozy8YroFI+K38MTbKmOG44lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSk/9IBy3mKpHdAFPsYLiWBYeA8iWRI2xzRaQlyBXE0=;
 b=tIPZG9WbB0SJJeufMlYhkJ5GUIH+duPiPQcxeWuihIlAhqCBVFmKnni55DSIAfhflTq6u4x8s/LWCZKyCX63WL8+gibibF8bQ4f+H+Q/UhoS+e0g4qTpz81dUBOwHpZTcKzfud/Ol2/lK236Cx+MKEmNxJE7wSp+WA8hvNkpteF52nNxSEJ47fRMcLvY7ofW+BFITRu4gNakl88tHkB3Ny6mGTwbE0wwqtJe1uOf5lsKSJj4nLmidT/PgKtTU6P3U4YWkcy9XLgdgIXpALY4i01Hd4L9EykpcHlNkq5dSZTysX4dqSavp5hzpIC9ZqmOJPJHHb7Dg+mkWGB+YSl2cg==
Received: from MW3PR06CA0014.namprd06.prod.outlook.com (2603:10b6:303:2a::19)
 by BL0PR12MB2355.namprd12.prod.outlook.com (2603:10b6:207:3f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 20:09:18 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::6c) by MW3PR06CA0014.outlook.office365.com
 (2603:10b6:303:2a::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Fri, 19 Nov 2021 20:09:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Fri, 19 Nov 2021 20:09:18 +0000
Received: from localhost.localdomain.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Fri, 19 Nov 2021 20:09:15 +0000
References: <20211118130805.23897-1-simon.horman@corigine.com>
 <20211118130805.23897-9-simon.horman@corigine.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     <netdev@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Jiri Pirko" <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>
Subject: Re: [PATCH v4 08/10] flow_offload: add reoffload process to update
 hw_count
In-Reply-To: <20211118130805.23897-9-simon.horman@corigine.com>
Date:   Fri, 19 Nov 2021 22:09:12 +0200
Message-ID: <ygnhh7c79ac7.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f6318e6-0768-415a-7c6b-08d9ab9877cf
X-MS-TrafficTypeDiagnostic: BL0PR12MB2355:
X-Microsoft-Antispam-PRVS: <BL0PR12MB2355DA194F654A1670170D6AA09C9@BL0PR12MB2355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWItuChH9A7JrZvM1tIf0t0xPEcsKQNJGhxdkEDjrIG6MLVulbMqVZ9DdGh4Iao0pJEl1othEl0wA9WYAZUSh2t1Cj33NuJzYby3l0nqDZJFs859kPj4l7sBUkLY9YZgslmOqYdkl/YrT7aRxFAwZ2XHZ53fMFrH9Z0aEnkpaCE5judg3a35QOhptSK6FucA9qfQiXAHvfsOAVGSmMcej1uCeK93zF3NCx4v9S3aZikd7w9HPxUA13PJMAO7BeguGRoAyILCoXb8Yv/c2fcQKsOLO7ZSR+xl7Auy/1UfAXlQIVPAFJvd6U1F5wTu2tgdO409iHJ2qrF+HA7APgfbKjbtpJGPVYvCT4Lc0TTEw8gtD1u4skYE27fW9xMrBtVluiAwWCRiNjqzuFOJbYSyn5PgpYy6CDkcOG1TJsmlS7IE/bARgq88yNj88SGLtKo6fQ6G5j1wu+Zm8KbkIdMX+7fYEI9kDaPeWb5UA/+tCRlpnl/z2VS/YYM3WsQg87V+mEVJ3QBqj69BIrsEeCrQabkKN0CMLmNeGpHriBSQcEDMyR3hDLXWobPvEf9c6CKYheg2QvRv5B9WId6I4U/N47BMmIpoH+ZkrZmODEzzpRB8gxNC6yyaK45IMHwBqWxkF5i0ZM1pWQ2WXH3F2DsDnlQmhZ4xknHkQ3GmFybsXvLqVmdbHegQf/5FWs5NQHWuLarcpfL+IYOCOqwn/afIzQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(86362001)(336012)(8936002)(8676002)(316002)(54906003)(5660300002)(2906002)(36906005)(36756003)(6916009)(47076005)(15650500001)(4326008)(508600001)(36860700001)(7636003)(426003)(356005)(6666004)(70586007)(70206006)(26005)(2616005)(186003)(7696005)(83380400001)(16526019)(82310400003)(30864003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 20:09:18.1941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6318e6-0768-415a-7c6b-08d9ab9877cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 18 Nov 2021 at 15:08, Simon Horman <simon.horman@corigine.com> wrote:
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
>  net/core/flow_offload.c |   4 +
>  net/sched/act_api.c     | 213 ++++++++++++++++++++++++++++++++++++----
>  3 files changed, 222 insertions(+), 19 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 7900598d2dd3..e5e6e58df618 100644
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
>  
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
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 6676431733ef..92000164ac37 100644
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
> @@ -470,6 +473,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
>  	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
>  	mutex_unlock(&flow_indr_block_lock);
>  
> +	tcf_action_reoffload_cb(cb, cb_priv, false);
>  	flow_block_indr_notify(&cleanup_list);
>  	kfree(indr_dev);
>  }
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index f5834d47a392..ada51b2df851 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -225,15 +225,11 @@ static int flow_action_init(struct flow_offload_action *fl_action,
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
> @@ -245,9 +241,41 @@ static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
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
> @@ -275,9 +303,10 @@ static int tcf_action_offload_add(struct tc_action *action,
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
> @@ -290,6 +319,12 @@ static int tcf_action_offload_add(struct tc_action *action,
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
> @@ -302,7 +337,7 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  	if (err)
>  		return err;
>  
> -	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
> +	err = tcf_action_offload_cmd(&fl_act, NULL, NULL, NULL);
>  	if (!err) {
>  		preempt_disable();
>  		tcf_action_stats_update(action, fl_act.stats.bytes,
> @@ -321,7 +356,9 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>  }
>  EXPORT_SYMBOL(tcf_action_update_hw_stats);
>  
> -static int tcf_action_offload_del(struct tc_action *action)
> +static int tcf_action_offload_del_ex(struct tc_action *action,
> +				     flow_indr_block_bind_cb_t *cb,
> +				     void *cb_priv)
>  {
>  	struct flow_offload_action fl_act;
>  	u32 in_hw_count = 0;
> @@ -337,16 +374,25 @@ static int tcf_action_offload_del(struct tc_action *action)
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
>  	return 0;
>  }
>  
> +static int tcf_action_offload_del(struct tc_action *action)
> +{
> +	return tcf_action_offload_del_ex(action, NULL, NULL);
> +}
> +
>  static void tcf_action_cleanup(struct tc_action *p)
>  {
>  	tcf_action_offload_del(p);
> @@ -841,6 +887,59 @@ EXPORT_SYMBOL(tcf_idrinfo_destroy);
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
> @@ -859,18 +958,30 @@ int tcf_register_action(struct tc_action_ops *act,
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

Rename to 'err_id' to harmonize label naming.

> +	unregister_pernet_subsys(ops);
> +	return ret;
>  }
>  EXPORT_SYMBOL(tcf_register_action);
>  
> @@ -889,12 +1000,76 @@ int tcf_unregister_action(struct tc_action_ops *act,
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
>  
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

Deleting skip_sw action that is no longer offloaded to any hardware
device is reasonable, but note that in this case no netlink notification
is ever generated. Don't know if it is a problem, just highlighting the
fact since the whole behavior of implicitly deleting such actions is
completely omitted from the change log.

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
> +	return 0;
> +}
> +
>  /* lookup by name */
>  static struct tc_action_ops *tc_lookup_action_n(char *kind)
>  {

