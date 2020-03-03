Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C786F177697
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgCCNDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:03:03 -0500
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:6065
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728496AbgCCNDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 08:03:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXHwMH2C9KLghzaq4vOEja5rxLMupyhkB0g/3AqhfDpzLv/cs5s+WEFQs0MvFL0a6xbHl7a2NLa7Q920rMYY+qcB4PCaSUefvwojDMAX7XLCXP9CbijhcfG6VzeACbU69qbGTCzo7Qgnv1nq4osPVQZ0NsclRnzpwztqLmGgBrGf2hYYbESOrwckIjPoauqfc0jx4YfDk44MRnBdhk5jh0eqem9xXTg3nzVU6sxImEz6j8/DXiFhyrQLfwoPiP3aX4Tvsy8g2cPsRUNtZQI0nFN8C7m8Hk+LQlIi0eJ7RhsSLfM5B1rxLosOyH8XDdSlIb64BzkkwjEf5UR2PwFSDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLw/LcfNQrwVjxS/WayjgZqktc02Z5Iu38MYhOCyuqs=;
 b=PgJFbbl0xO3UK9HL9DrLrMpvh+32ppovWFC0iJPR5HHHd0/jcEdTyWw0ORM+/B0kz7xfC9XQNXbanAD1B32cpdAmLEMMGTSiWb78HQz44mv9Y+4zqZRBAc0xFuxJS1fQ4MJjKkfLr3nBMRVUO+sQ37gy3x0wL5mfNwQ69d8sQPieocyiC5wl1X4kglBXkShy8mzefCHGKp0XX74t3Q8YrwuE9MozL5joywAI9QnT4SyUshz0B7wwavr/bUqmS2mHUXWLhqyIME3MbOeNCTbvyqz1Ml7QhhY+TbWxEZ+3HRqKxeuDfa6fYrTSKaJhOuMQXsPimfc7VnZafVLsHC+4iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLw/LcfNQrwVjxS/WayjgZqktc02Z5Iu38MYhOCyuqs=;
 b=WGHAUD9Jk4pEc2g2W8IpGdoUjoXPdGD1FJIkF/ZAwyg9hf8IKxIYXiJogycE0orpl6ZsKf79Yu2es2xcQbHIF0e3KSfdgpefru2oMhdLkKY6TQcUHeenXzIv2JvK7rrhtaYlRIzsfcb053/kuug0UnnZ5g7yqJ9bgZ0+9JZebV8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6246.eurprd05.prod.outlook.com (20.179.2.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Tue, 3 Mar 2020 13:02:55 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 13:02:55 +0000
Subject: Re: [PATCH net-next v3 1/3] net/sched: act_ct: Create nf flow table
 per zone
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
 <1583239973-3728-2-git-send-email-paulb@mellanox.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <d6a9c501-fa05-0cba-11ff-2686a8724db8@mellanox.com>
Date:   Tue, 3 Mar 2020 15:02:51 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <1583239973-3728-2-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::39) To AM6PR05MB5096.eurprd05.prod.outlook.com
 (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 13:02:54 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 89bb2fb9-2a0e-4bbc-658b-08d7bf7330af
X-MS-TrafficTypeDiagnostic: AM6PR05MB6246:|AM6PR05MB6246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB624657BC748CA4F83CFD0906CFE40@AM6PR05MB6246.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(189003)(199004)(8936002)(16526019)(66946007)(6486002)(6636002)(186003)(66556008)(66476007)(31686004)(26005)(110136005)(86362001)(5660300002)(36756003)(2616005)(81166006)(16576012)(2906002)(956004)(52116002)(81156014)(31696002)(8676002)(6666004)(53546011)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6246;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BD6csHpyDmakNn+Kvr4WBph/4mtCrgbDb5Q5YWucZZxWqlJ4ETmy9aAZegAIgSGphvZZP8wA54cEAX+DlClR2Vjkc9ypNE4D5viLZZCVL4KV476PAqbf+tXkufz+pl8i4WRx1lu/FR+9x/B/X7WkAzw0ol5nu/4Xu8cKMMfdrFekupB/5+ohKFck6SierZt3TiKaNBpI5YOIWVqsC0q40MmhBs6d2BPZRyqcnv6uLEjf6AoJn63/ujEhOzpBlLaG1WT1glRLwcCrWKxpDP1MKmtYM7WMPPgFc0XBI6nzbzE9mUa5qu49xgcXgBVZU6Vsa5LhWFUVeAczd2to3+5zR/rkH7yKnGRthCEgmR4mW66QkI5sHv5PjNC1yqD+ve7tjtIofHsZysUmOFLDyvkXL025Xxx4K5SbiBuqJFe29XRKGkovnWyzR7G5QvWdp9I8
X-MS-Exchange-AntiSpam-MessageData: xzZgvj0urUL6ewdB/coj38f16Q5vyk/hjFq3ip5f+lc2LfolS4qo3avXnaI20eDKRelhiUi1SyV4Qok2Ts8ENwjL6iQ4pr98tQWq11qsQ57KZ8IQKbTF+CPbH4hAGkrxuIvrp4YeyHtNKuPjZdodJQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89bb2fb9-2a0e-4bbc-658b-08d7bf7330af
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 13:02:55.6559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dh5yBM53kbaKanfDoVejvA7FKlPxT69K10G6DyUQiKGhgB1FEg4aoi+VE65ZkI6d14XNR4z+HAkVFguMWX0bTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/3/2020 2:52 PM, Paul Blakey wrote:
> Use the NF flow tables infrastructure for CT offload.
>
> Create a nf flow table per zone.
>
> Next patches will add FT entries to this table, and do
> the software offload.
>
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> ---
> Changelog:
>   v2->v3:
>     Ditch re-locking to alloc, and use atomic allocation
>   v1->v2:
>     Use spin_lock_bh instead of spin_lock, and unlock for alloc (as it can sleep)
>     Free ft on last tc act instance instead of last instance + last offloaded tuple,
>     this removes cleanup cb and netfilter patches, and is simpler
>     Removed accidental mlx5/core/en_tc.c change
>     Removed reviewed by Jiri - patch changed
>
>  include/net/tc_act/tc_ct.h |   2 +
>  net/sched/Kconfig          |   2 +-
>  net/sched/act_ct.c         | 134 ++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 136 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
> index a8b1564..cf3492e 100644
> --- a/include/net/tc_act/tc_ct.h
> +++ b/include/net/tc_act/tc_ct.h
> @@ -25,6 +25,8 @@ struct tcf_ct_params {
>  	u16 ct_action;
>  
>  	struct rcu_head rcu;
> +
> +	struct tcf_ct_flow_table *ct_ft;
>  };
>  
>  struct tcf_ct {
> diff --git a/net/sched/Kconfig b/net/sched/Kconfig
> index edde0e5..bfbefb7 100644
> --- a/net/sched/Kconfig
> +++ b/net/sched/Kconfig
> @@ -972,7 +972,7 @@ config NET_ACT_TUNNEL_KEY
>  
>  config NET_ACT_CT
>  	tristate "connection tracking tc action"
> -	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT
> +	depends on NET_CLS_ACT && NF_CONNTRACK && NF_NAT && NF_FLOW_TABLE
>  	help
>  	  Say Y here to allow sending the packets to conntrack module.
>  
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index f685c0d..d36417f 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -15,6 +15,7 @@
>  #include <linux/pkt_cls.h>
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
> +#include <linux/rhashtable.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/pkt_cls.h>
> @@ -24,6 +25,7 @@
>  #include <uapi/linux/tc_act/tc_ct.h>
>  #include <net/tc_act/tc_ct.h>
>  
> +#include <net/netfilter/nf_flow_table.h>
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_core.h>
>  #include <net/netfilter/nf_conntrack_zones.h>
> @@ -31,6 +33,108 @@
>  #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
>  #include <uapi/linux/netfilter/nf_nat.h>
>  
> +static struct workqueue_struct *act_ct_wq;
> +static struct rhashtable zones_ht;
> +static DEFINE_SPINLOCK(zones_lock);
> +
> +struct tcf_ct_flow_table {
> +	struct rhash_head node; /* In zones tables */
> +
> +	struct rcu_work rwork;
> +	struct nf_flowtable nf_ft;
> +	u16 zone;
> +	u32 ref;
> +
> +	bool dying;
> +};
> +
> +static const struct rhashtable_params zones_params = {
> +	.head_offset = offsetof(struct tcf_ct_flow_table, node),
> +	.key_offset = offsetof(struct tcf_ct_flow_table, zone),
> +	.key_len = sizeof_field(struct tcf_ct_flow_table, zone),
> +	.automatic_shrinking = true,
> +};
> +
> +static struct nf_flowtable_type flowtable_ct = {
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
> +{
> +	struct tcf_ct_flow_table *ct_ft;
> +	int err = -ENOMEM;
> +
> +	spin_lock_bh(&zones_lock);
> +	ct_ft = rhashtable_lookup_fast(&zones_ht, &params->zone, zones_params);
> +	if (ct_ft)
> +		goto take_ref;
> +
> +	ct_ft = kzalloc(sizeof(*ct_ft), GFP_KERNEL);

Reverted it back wrong, should be atomic here.

Sending v4, sorry

> +	if (!ct_ft)
> +		goto err_alloc;
> +
> +	ct_ft->zone = params->zone;
> +	err = rhashtable_insert_fast(&zones_ht, &ct_ft->node, zones_params);
> +	if (err)
> +		goto err_insert;
> +
> +	ct_ft->nf_ft.type = &flowtable_ct;
> +	err = nf_flow_table_init(&ct_ft->nf_ft);
> +	if (err)
> +		goto err_init;
> +
> +	__module_get(THIS_MODULE);
> +take_ref:
> +	params->ct_ft = ct_ft;
> +	ct_ft->ref++;
> +	spin_unlock_bh(&zones_lock);
> +
> +	return 0;
> +
> +err_init:
> +	rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
> +err_insert:
> +	kfree(ct_ft);
> +err_alloc:
> +	spin_unlock_bh(&zones_lock);
> +	return err;
> +}
> +
> +static void tcf_ct_flow_table_cleanup_work(struct work_struct *work)
> +{
> +	struct tcf_ct_flow_table *ct_ft;
> +
> +	ct_ft = container_of(to_rcu_work(work), struct tcf_ct_flow_table,
> +			     rwork);
> +	nf_flow_table_free(&ct_ft->nf_ft);
> +	kfree(ct_ft);
> +
> +	module_put(THIS_MODULE);
> +}
> +
> +static void tcf_ct_flow_table_put(struct tcf_ct_params *params)
> +{
> +	struct tcf_ct_flow_table *ct_ft = params->ct_ft;
> +
> +	spin_lock_bh(&zones_lock);
> +	if (--params->ct_ft->ref == 0) {
> +		rhashtable_remove_fast(&zones_ht, &ct_ft->node, zones_params);
> +		INIT_RCU_WORK(&ct_ft->rwork, tcf_ct_flow_table_cleanup_work);
> +		queue_rcu_work(act_ct_wq, &ct_ft->rwork);
> +	}
> +	spin_unlock_bh(&zones_lock);
> +}
> +
> +static int tcf_ct_flow_tables_init(void)
> +{
> +	return rhashtable_init(&zones_ht, &zones_params);
> +}
> +
> +static void tcf_ct_flow_tables_uninit(void)
> +{
> +	rhashtable_destroy(&zones_ht);
> +}
> +
>  static struct tc_action_ops act_ct_ops;
>  static unsigned int ct_net_id;
>  
> @@ -207,6 +311,8 @@ static void tcf_ct_params_free(struct rcu_head *head)
>  	struct tcf_ct_params *params = container_of(head,
>  						    struct tcf_ct_params, rcu);
>  
> +	tcf_ct_flow_table_put(params);
> +
>  	if (params->tmpl)
>  		nf_conntrack_put(&params->tmpl->ct_general);
>  	kfree(params);
> @@ -730,6 +836,10 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
>  	if (err)
>  		goto cleanup;
>  
> +	err = tcf_ct_flow_table_get(params);
> +	if (err)
> +		goto cleanup;
> +
>  	spin_lock_bh(&c->tcf_lock);
>  	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>  	params = rcu_replace_pointer(c->params, params,
> @@ -974,12 +1084,34 @@ static void __net_exit ct_exit_net(struct list_head *net_list)
>  
>  static int __init ct_init_module(void)
>  {
> -	return tcf_register_action(&act_ct_ops, &ct_net_ops);
> +	int err;
> +
> +	act_ct_wq = alloc_ordered_workqueue("act_ct_workqueue", 0);
> +	if (!act_ct_wq)
> +		return -ENOMEM;
> +
> +	err = tcf_ct_flow_tables_init();
> +	if (err)
> +		goto err_tbl_init;
> +
> +	err = tcf_register_action(&act_ct_ops, &ct_net_ops);
> +	if (err)
> +		goto err_register;
> +
> +	return 0;
> +
> +err_tbl_init:
> +	destroy_workqueue(act_ct_wq);
> +err_register:
> +	tcf_ct_flow_tables_uninit();
> +	return err;
>  }
>  
>  static void __exit ct_cleanup_module(void)
>  {
>  	tcf_unregister_action(&act_ct_ops, &ct_net_ops);
> +	tcf_ct_flow_tables_uninit();
> +	destroy_workqueue(act_ct_wq);
>  }
>  
>  module_init(ct_init_module);
