Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32C242A7A6
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 16:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbhJLOyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 10:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbhJLOyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 10:54:01 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7BAC061570;
        Tue, 12 Oct 2021 07:52:00 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h196so11221576iof.2;
        Tue, 12 Oct 2021 07:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zs1JX3thajw9B+yLriiEfpfFd2ERgglFvfaFqHcP2Lc=;
        b=E5+qS74sP6eRQA+XTQZv6UNJi6FCUahcGZEcYJV2Q70bnEn78lz5uM5vOdoie1bOoa
         sSrx+Vet0TSDAvdKnb07fSRWnqoiANvgl2ZVER0KCZ2N86WAlgAcuGMyp61KT59anytO
         goomd2o6jcXMvWgJUT+rLzCPuAsgCSkUGLofoIJyrGmb05sdYPyBfku5mEgwW9Y2U5KU
         gDFvbnoYhrLg/CsIn2fHbckPvWQNjQOulXIF/Eh3DX9M3RNY80by25KrXLgQKtZ+9ecv
         KuApoMc7umrkpsMk7RQF4Et0+2WIkBU9epGKj7zBQhCZUT9bIl2KvRRzdL9FDxax1vm1
         VAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zs1JX3thajw9B+yLriiEfpfFd2ERgglFvfaFqHcP2Lc=;
        b=nq2N82XvRCJhgHX2bBPGbFN//S0dWYJuIal6bbdaW9BpBDUxjBivk67H+OVCfuxI9w
         uxI5VLmJqiUa4tNwrDPcj/piz4JrZaQ2nP/XEOfZoq53Hx8U4WeoIut1tEjv0ahC302o
         SybHqchgg+U6hPM52rbumHzw59UtrDUFm1WoE9ZW9SlFd1YSWJe9GZymngVcfmlI0wF1
         ZupQlwaEF/iDGQ9Rfx9GUxGMUliMG9E0E3NrnURaUHJ7Zz5krGHI8LD9L/eORpjnRZdV
         AdR+G/7H/jtglrIAsA8dPevkr1TrX86C+CKM3ZkL4DAA4IarJaAJF9nf9ovusVSsPant
         gHNQ==
X-Gm-Message-State: AOAM530UGWEzb0ixFLkr9fzl8w2iR5drfLgR1mkm4OdPyTpOhFjcOvb8
        9gBZyXSqdrvyckOSCsCAVaX1RmMolLUQjQ==
X-Google-Smtp-Source: ABdhPJwoK90+Zn2aKVvNoLCfcehuMbibkLzrhwWNbC8SHSYphANw9cIWdxUbN3cGx8hzSWs8J7KJWQ==
X-Received: by 2002:a05:6638:ac6:: with SMTP id m6mr17954495jab.28.1634050319066;
        Tue, 12 Oct 2021 07:51:59 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a12sm5659020ilb.66.2021.10.12.07.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 07:51:58 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org, Ido Schimmel <idosch@idosch.org>
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05807c5b-59aa-839d-fbb0-b9712857741e@gmail.com>
Date:   Tue, 12 Oct 2021 08:51:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211011121238.25542-5-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 6:12 AM, Daniel Borkmann wrote:
> @@ -66,12 +68,22 @@ enum {
>  #define NUD_PERMANENT	0x80
>  #define NUD_NONE	0x00
>  
> -/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
> - * and make no address resolution or NUD.
> - * NUD_PERMANENT also cannot be deleted by garbage collectors.
> +/* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change and make no
> + * address resolution or NUD.
> + *
> + * NUD_PERMANENT also cannot be deleted by garbage collectors. This holds true
> + * for dynamic entries with NTF_EXT_LEARNED flag as well. However, upon carrier
> + * down event, NUD_PERMANENT entries are not flushed whereas NTF_EXT_LEARNED
> + * flagged entries explicitly are (which is also consistent with the routing
> + * subsystem).
> + *
>   * When NTF_EXT_LEARNED is set for a bridge fdb entry the different cache entry
>   * states don't make sense and thus are ignored. Such entries don't age and
>   * can roam.
> + *
> + * NTF_EXT_MANAGED flagged neigbor entries are managed by the kernel on behalf
> + * of a user space control plane, and automatically refreshed so that (if
> + * possible) they remain in NUD_REACHABLE state.

switchdev use cases need this capability as well to offload routes.
Similar functionality exists in mlxsw to resolve gateways. It would be
good for this design to cover both needs - and that may be as simple as
mlxsw setting the MANAGED flag on the entry to let the neigh subsystem
takeover.

>   */
>  
>  struct nda_cacheinfo {
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 5245e888c981..eae73efa9245 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -122,6 +122,8 @@ static void neigh_mark_dead(struct neighbour *n)
>  		list_del_init(&n->gc_list);
>  		atomic_dec(&n->tbl->gc_entries);
>  	}
> +	if (!list_empty(&n->managed_list))
> +		list_del_init(&n->managed_list);
>  }
>  
>  static void neigh_update_gc_list(struct neighbour *n)
> @@ -130,7 +132,6 @@ static void neigh_update_gc_list(struct neighbour *n)
>  
>  	write_lock_bh(&n->tbl->lock);
>  	write_lock(&n->lock);
> -

I like the extra newline - it makes locks stand out.


>  	if (n->dead)
>  		goto out;
>  
> @@ -149,32 +150,59 @@ static void neigh_update_gc_list(struct neighbour *n)
>  		list_add_tail(&n->gc_list, &n->tbl->gc_list);
>  		atomic_inc(&n->tbl->gc_entries);
>  	}
> +out:
> +	write_unlock(&n->lock);
> +	write_unlock_bh(&n->tbl->lock);
> +}
> +
> +static void neigh_update_managed_list(struct neighbour *n)
> +{
> +	bool on_managed_list, add_to_managed;
> +
> +	write_lock_bh(&n->tbl->lock);
> +	write_lock(&n->lock);
> +	if (n->dead)
> +		goto out;
> +
> +	add_to_managed = n->flags & NTF_MANAGED;
> +	on_managed_list = !list_empty(&n->managed_list);
>  
> +	if (!add_to_managed && on_managed_list)
> +		list_del_init(&n->managed_list);
> +	else if (add_to_managed && !on_managed_list)
> +		list_add_tail(&n->managed_list, &n->tbl->managed_list);
>  out:
>  	write_unlock(&n->lock);
>  	write_unlock_bh(&n->tbl->lock);
>  }
>  
> -static bool neigh_update_ext_learned(struct neighbour *neigh, u32 flags,
> -				     int *notify)
> +static void neigh_update_flags(struct neighbour *neigh, u32 flags, int *notify,
> +			       bool *gc_update, bool *managed_update)
>  {
> -	bool rc = false;
> -	u32 ndm_flags;
> +	u32 ndm_flags, old_flags = neigh->flags;
>  
>  	if (!(flags & NEIGH_UPDATE_F_ADMIN))
> -		return rc;
> +		return;
> +
> +	ndm_flags  = (flags & NEIGH_UPDATE_F_EXT_LEARNED) ? NTF_EXT_LEARNED : 0;
> +	ndm_flags |= (flags & NEIGH_UPDATE_F_MANAGED) ? NTF_MANAGED : 0;
>  
> -	ndm_flags = (flags & NEIGH_UPDATE_F_EXT_LEARNED) ? NTF_EXT_LEARNED : 0;
> -	if ((neigh->flags ^ ndm_flags) & NTF_EXT_LEARNED) {
> +	if ((old_flags ^ ndm_flags) & NTF_EXT_LEARNED) {
>  		if (ndm_flags & NTF_EXT_LEARNED)
>  			neigh->flags |= NTF_EXT_LEARNED;
>  		else
>  			neigh->flags &= ~NTF_EXT_LEARNED;
> -		rc = true;
>  		*notify = 1;
> +		*gc_update = true;
> +	}
> +	if ((old_flags ^ ndm_flags) & NTF_MANAGED) {
> +		if (ndm_flags & NTF_MANAGED)
> +			neigh->flags |= NTF_MANAGED;
> +		else
> +			neigh->flags &= ~NTF_MANAGED;
> +		*notify = 1;
> +		*managed_update = true;
>  	}
> -
> -	return rc;
>  }
>  
>  static bool neigh_del(struct neighbour *n, struct neighbour __rcu **np,
> @@ -422,6 +450,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl,
>  	refcount_set(&n->refcnt, 1);
>  	n->dead		  = 1;
>  	INIT_LIST_HEAD(&n->gc_list);
> +	INIT_LIST_HEAD(&n->managed_list);
>  
>  	atomic_inc(&tbl->entries);
>  out:
> @@ -650,7 +679,8 @@ ___neigh_create(struct neigh_table *tbl, const void *pkey,
>  	n->dead = 0;
>  	if (!exempt_from_gc)
>  		list_add_tail(&n->gc_list, &n->tbl->gc_list);
> -
> +	if (n->flags & NTF_MANAGED)
> +		list_add_tail(&n->managed_list, &n->tbl->managed_list);
>  	if (want_ref)
>  		neigh_hold(n);
>  	rcu_assign_pointer(n->next,
> @@ -1205,8 +1235,6 @@ static void neigh_update_hhs(struct neighbour *neigh)
>  	}
>  }
>  
> -
> -
>  /* Generic update routine.
>     -- lladdr is new lladdr or NULL, if it is not supplied.
>     -- new    is new state.
> @@ -1218,6 +1246,7 @@ static void neigh_update_hhs(struct neighbour *neigh)
>  				if it is different.
>  	NEIGH_UPDATE_F_ADMIN	means that the change is administrative.
>  	NEIGH_UPDATE_F_USE	means that the entry is user triggered.
> +	NEIGH_UPDATE_F_MANAGED	means that the entry will be auto-refreshed.
>  	NEIGH_UPDATE_F_OVERRIDE_ISROUTER allows to override existing
>  				NTF_ROUTER flag.
>  	NEIGH_UPDATE_F_ISROUTER	indicates if the neighbour is known as
> @@ -1225,17 +1254,15 @@ static void neigh_update_hhs(struct neighbour *neigh)
>  
>     Caller MUST hold reference count on the entry.
>   */
> -
>  static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>  			  u8 new, u32 flags, u32 nlmsg_pid,
>  			  struct netlink_ext_ack *extack)
>  {
> -	bool ext_learn_change = false;
> -	u8 old;
> -	int err;
> -	int notify = 0;
> -	struct net_device *dev;
> +	bool gc_update = false, managed_update = false;
>  	int update_isrouter = 0;
> +	struct net_device *dev;
> +	int err, notify = 0;
> +	u8 old;
>  
>  	trace_neigh_update(neigh, lladdr, new, flags, nlmsg_pid);
>  
> @@ -1254,8 +1281,8 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
>  	    (old & (NUD_NOARP | NUD_PERMANENT)))
>  		goto out;
>  
> -	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
> -	if (flags & NEIGH_UPDATE_F_USE) {
> +	neigh_update_flags(neigh, flags, &notify, &gc_update, &managed_update);
> +	if (flags & (NEIGH_UPDATE_F_USE | NEIGH_UPDATE_F_MANAGED)) {
>  		new = old & ~NUD_PERMANENT;

so a neighbor entry can not be both managed and permanent, but you don't
check for the combination in neigh_add and error out with a message to
the user.


