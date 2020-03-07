Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6D17CFF5
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 21:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgCGUNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 15:13:01 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44569 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgCGUNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 15:13:01 -0500
Received: by mail-pl1-f193.google.com with SMTP id d9so2304986plo.11
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 12:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=iBPaM44o8XMBlLlvWTgmt2MEAFrzz16P6fSmwhjZIjU=;
        b=uQMqyQvLKIUk3URpfma5RBfXIfza6Cs1EiAW3iPlF8ZwWdwpWOVvGmkBFnotqQZM9m
         XZoWDqVJrSSVHg2tBWUENVJB/4iIVxU9qtP2RxlkB0Sae6Ui/THTB85rQacc4Yf/asBG
         9wr2RyvBlPwVP0p6jffFMf0pzRaf1j0hHTb35qGsZEbrxluCq2iYKHKSGyZ61XRE9rvZ
         5IeKtGwfIfw6b0qFxRdSku6Kn3kEU72LkmGrfcqMiYmfDzoAG0z3JLXb/7IQTIoCSeis
         wwH9o35cGOBxs6Wl/eMZIH8RscJ0j4U99Ut9mZv+EDo/VPqET8sxNXpGKDk3Uw8PzPFg
         j47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iBPaM44o8XMBlLlvWTgmt2MEAFrzz16P6fSmwhjZIjU=;
        b=EtfeCtvZJ/QqHCVmI+vuLIRPLzhtYQRoEJyBQNuegXXCFhxSps9q/4Y5fzeTC30AFR
         Guw8mldEr+YNSgZb12vXsGTz0TRe7jrUtGhk6mX7ABddEQjkh9FXKDiVMmkPjgGp19ZR
         /97t5wYUXAD3vaMknbLAkU959Wir7xm5ug4U/vA+TZ+yChv4ihf6vAM49ddV6EqerKBm
         2XTidCYfS8FXOVjNHSNIG+MSl9KeExEnopkCns7K+R9ZAseP8YhPn4z4IeJC6VxjhNKs
         uh2WsW3env6A032sDrBhUDtekinhwWA88ASOwcdrqVzTGyqbX+1T1aOaj+MBMQlE6FoH
         AgzA==
X-Gm-Message-State: ANhLgQ1dDCnQpoLtmtMvBxXVgJhKWpeKhT4dkT11Kl++1Z4nUtQQ+aTV
        rYvI3cQ504NBmgpj5YUmc/4=
X-Google-Smtp-Source: ADFU+vvkCZWDHDMvOp9CeX69aaS4VJMRwA3TgupsknuIzZHluO1sr+gXPT3JcRT49521Iz7tuRY8EQ==
X-Received: by 2002:a17:90a:254d:: with SMTP id j71mr9965542pje.169.1583611980187;
        Sat, 07 Mar 2020 12:13:00 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id u66sm3726794pfb.107.2020.03.07.12.12.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 12:12:59 -0800 (PST)
Subject: Re: [PATCH net-next v6 1/3] net/sched: act_ct: Create nf flow table
 per zone
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583251072-10396-1-git-send-email-paulb@mellanox.com>
 <1583251072-10396-2-git-send-email-paulb@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c0c033e8-63ed-a33c-2e1b-afbedcb476ea@gmail.com>
Date:   Sat, 7 Mar 2020 12:12:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583251072-10396-2-git-send-email-paulb@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/20 7:57 AM, Paul Blakey wrote:
> Use the NF flow tables infrastructure for CT offload.
> 
> Create a nf flow table per zone.
> 
> Next patches will add FT entries to this table, and do
> the software offload.
> 
> Signed-off-by: Paul Blakey <paulb@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
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

This call is going to allocate a rhashtable (GFP_KERNEL allocations that might sleep)

Since you still hold zones_lock spinlock, a splat should occur.

"BUG: sleeping function called from invalid context in  ..."

DEBUG_ATOMIC_SLEEP=y is your friend.

And it is always a good thing to make sure a patch does not trigger a lockdep splat

CONFIG_PROVE_LOCKING=y


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
> 
