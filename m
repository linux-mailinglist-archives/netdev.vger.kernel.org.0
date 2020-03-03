Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 634E0177C61
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgCCQvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:51:10 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:42467 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbgCCQvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:51:07 -0500
Received: by mail-qv1-f67.google.com with SMTP id e7so1961524qvy.9
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 08:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zt0sOcA/A7mRg1Vg65c7ItgNnorq/fvgYPaXmZJtLOg=;
        b=l2KA8eQb5IuHGRpcXdGsrI8puBE0QDXshao+gtVFDF03yifBWolb1vMFWGeJO3hFw8
         SL0Z0fbuBkwtyxdVCQLOe3KEF/dEgWcX2t7kYURKeuKk84ds610NKfL5kfcjRfHcIJUQ
         5ikS9SJhH6UF2dk7BSFV977MPrTs5x8jkN3X+PWN0mOmd+lzbd3cATNHep2t7qa23Y+U
         7m9T8I9yJ4LUTHYyuYHcC2qKtOoez33UUoicoxCqX9ZKAyzXDnN8lGeBMo/7XP9tJlJD
         toA1stHI2S/dsLWNDrowdx3ohXxVLfcGcX/kEwHzDlFi1PaHg4Z9xG+Cw9XdR77kFwsV
         XnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zt0sOcA/A7mRg1Vg65c7ItgNnorq/fvgYPaXmZJtLOg=;
        b=SNM1jrCZKihspmT1b9nQhuMZu83dvA+X8AR58bpMKH5TMZIU5KKbrabqickGp0p28M
         o+f0Q/nYDuAlKfrr15s+x5UX4t2gA0TZQ4Gz37kK4hL51kl6kXJKcEA7snVqPECXThK3
         FZQ9tLMZvrpntJEecpdDKNykj7NT7fRlbM9rA/XmrcpHWMScuter1KHv6sjhZTo8U3hf
         D+ZDxjBcdYKh0f9aCI/p3RpyGmEtopxEHJwYVZxsw8KATwghQc1gdKNoiuvi/sjGhwF9
         VRSq6toNaBtbMsHiExTYo5fGWk3XQcUW4Q20SiEZ6Mu2jLsVNmMmsXLg+8bmI4o+AWIr
         mBfQ==
X-Gm-Message-State: ANhLgQ2V4SZeNSD8pgCUr+zskpyeVuQMer3qgY6CLiVLP0KaeNbYjk91
        ThiURYlsXXsMLSogiD/Av38=
X-Google-Smtp-Source: ADFU+vumZdM9AMG0RdTfbi0za5L2eTQ4mrXKfVOoAxUxtnRkr2YH/ZqkUxLgVo9GDLT+Z5CBn/OCKw==
X-Received: by 2002:a05:6214:1883:: with SMTP id cx3mr1323172qvb.186.1583254266243;
        Tue, 03 Mar 2020 08:51:06 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f016:fb09:9cfd:7305:ba61:3cf5])
        by smtp.gmail.com with ESMTPSA id d9sm12176572qth.34.2020.03.03.08.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 08:51:05 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 3BCC1C5B52; Tue,  3 Mar 2020 13:51:03 -0300 (-03)
Date:   Tue, 3 Mar 2020 13:51:03 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
Message-ID: <20200303165103.GC2546@localhost.localdomain>
References: <1583251072-10396-1-git-send-email-paulb@mellanox.com>
 <1583251072-10396-2-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583251072-10396-2-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 05:57:50PM +0200, Paul Blakey wrote:
> Use the NF flow tables infrastructure for CT offload.
> 
> Create a nf flow table per zone.
> 
> Next patches will add FT entries to this table, and do
> the software offload.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>   v4->v5:
>     Added reviewed by Jiri, thanks!
>   v3->v4:
>     Alloc GFP_ATOMIC
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
> index f685c0d..3321087 100644
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
> +	ct_ft = kzalloc(sizeof(*ct_ft), GFP_ATOMIC);
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
> -- 
> 1.8.3.1
> 
