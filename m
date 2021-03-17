Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AE833FBF6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 00:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhCQXmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 19:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCQXmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 19:42:03 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9F5C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 16:42:03 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id l79so142001oib.1
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 16:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vs9qqd0RdZaJV7Y8THd6SyenXnV2HBPkDBhbgperYUc=;
        b=H4SAdcPlZt5Pv6QiuJzVxpVaj939t2W41M0jkq8iW1d5fM157Zj0U8KzfVtuwcOocC
         XhyA0AxB8tEbqAL4xLPCgh9jN1Fr8lnVxgaMbgDFDGg9PDCIwbgFDmNd2TCxkBpoa+po
         0ttjM8kbDhYoamN86RGhdkHlkz3kFxrU37/ItT2pPLMhL1MCsOcsSDNjaUHvOVJTm7GL
         vE+c+SlLk7yQm7fSpgw84kew/PjmDg2zBl50A1jsR27ss++sgduxFU6Nidz9zzEf5lk+
         +TbtR+9WSYufpWb6afS/9bZpLBm8fll+6TmLeSdztY77kYoMOXwMN1MtL9OMHnpW0fel
         QgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vs9qqd0RdZaJV7Y8THd6SyenXnV2HBPkDBhbgperYUc=;
        b=Z7uzb7nj3NbPr7wxNn98iDxREQ2I1QV2BtlTTgj3exEiCiVXHUUMNNCnAqa65UkOyl
         dl5W+ggZs6CfHjVFhZebQZL+P8ZOYXXPz6nizuB++jEuS3KrO5Cv5rnxhx7r8qd1bJ+0
         B3FoamfmnENrmLyzF/oJerzlfsfOVuOTPs1woB0eYdtbmLEAgNxPDysm0K1NnEEHku/y
         ZV4u93SCBsImFIJT3qzKLoXcHvVoKuiTRENOvSPkeuZiHPfg/nom1G62EJhP/FoqMWMM
         F/YfkoNVnEqnPwLcFCLsCFtL5916vZ9bdXiyjGQ6KSHo1vl1DC8WHlJWxwDy+AR7YEEq
         yONQ==
X-Gm-Message-State: AOAM531f4ogKBExs5KVUJ8Qdr1zK+DhdfsJyYhkF1IbCuAzt0/TUPXo2
        WX/tqfHZw7IXiwxMbxD+8tg=
X-Google-Smtp-Source: ABdhPJzjDPdkOQRSKJXsmI2/zyxWlKk5kk29LWGZJvl6yqt63v0HxzTOqfDLwWqpQ40+0PpVGQE+LQ==
X-Received: by 2002:aca:358a:: with SMTP id c132mr1014814oia.142.1616024522577;
        Wed, 17 Mar 2021 16:42:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id l17sm76007otb.57.2021.03.17.16.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 16:42:02 -0700 (PDT)
Subject: Re: [PATCH 1/2] neighbour: allow referenced neighbours to be removed
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org
References: <20210317185320.1561608-1-cascardo@canonical.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <af0b2c0a-d8a9-1932-e3cd-54a67a3d389b@gmail.com>
Date:   Wed, 17 Mar 2021 17:42:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317185320.1561608-1-cascardo@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 12:53 PM, Thadeu Lima de Souza Cascardo wrote:
> During forced garbage collection, neighbours with more than a reference are
> not removed. It's possible to DoS the neighbour table by using ARP spoofing
> in such a way that there is always a timer pending for all neighbours,
> preventing any of them from being removed. That will cause any new
> neighbour creation to fail.
> 
> Use the same code as used by neigh_flush_dev, which deletes the timer and
> cleans the queue when there are still references left.
> 
> With the same ARP spoofing technique, it was still possible to reach a valid
> destination when this fix was applied, with no more table overflows.

And how fast are neighbor entries removed with this patch? The current
code gives a neighbor entry a minimum lifetime to allow it to exist long
enough to be confirmed. Removing the minimum lifetime means neighbor
entries are constantly churning which is just as bad as the arp spoofing
problem.

> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> ---
>  net/core/neighbour.c | 117 +++++++++++++++++++------------------------
>  1 file changed, 51 insertions(+), 66 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index e2982b3970b8..bbc89c7ffdfd 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -173,25 +173,48 @@ static bool neigh_update_ext_learned(struct neighbour *neigh, u32 flags,
>  	return rc;
>  }
>  
> +static int neigh_del_timer(struct neighbour *n)
> +{
> +	if ((n->nud_state & NUD_IN_TIMER) &&
> +	    del_timer(&n->timer)) {
> +		neigh_release(n);
> +		return 1;
> +	}
> +	return 0;
> +}
> +
>  static bool neigh_del(struct neighbour *n, struct neighbour __rcu **np,
>  		      struct neigh_table *tbl)
>  {
> -	bool retval = false;
> -
> +	rcu_assign_pointer(*np,
> +		   rcu_dereference_protected(n->next,
> +				lockdep_is_held(&tbl->lock)));
>  	write_lock(&n->lock);
> -	if (refcount_read(&n->refcnt) == 1) {
> -		struct neighbour *neigh;
> -
> -		neigh = rcu_dereference_protected(n->next,
> -						  lockdep_is_held(&tbl->lock));
> -		rcu_assign_pointer(*np, neigh);
> -		neigh_mark_dead(n);
> -		retval = true;
> +	neigh_del_timer(n);
> +	neigh_mark_dead(n);
> +	if (refcount_read(&n->refcnt) != 1) {
> +		/* The most unpleasant situation.
> +		   We must destroy neighbour entry,
> +		   but someone still uses it.
> +
> +		   The destroy will be delayed until
> +		   the last user releases us, but
> +		   we must kill timers etc. and move
> +		   it to safe state.
> +		 */
> +		__skb_queue_purge(&n->arp_queue);
> +		n->arp_queue_len_bytes = 0;
> +		n->output = neigh_blackhole;
> +		if (n->nud_state & NUD_VALID)
> +			n->nud_state = NUD_NOARP;
> +		else
> +			n->nud_state = NUD_NONE;
> +		neigh_dbg(2, "neigh %p is stray\n", n);
>  	}
>  	write_unlock(&n->lock);
> -	if (retval)
> -		neigh_cleanup_and_release(n);
> -	return retval;
> +	neigh_cleanup_and_release(n);
> +
> +	return true;
>  }
>  
>  bool neigh_remove_one(struct neighbour *ndel, struct neigh_table *tbl)
> @@ -229,22 +252,20 @@ static int neigh_forced_gc(struct neigh_table *tbl)
>  	write_lock_bh(&tbl->lock);
>  
>  	list_for_each_entry_safe(n, tmp, &tbl->gc_list, gc_list) {
> -		if (refcount_read(&n->refcnt) == 1) {
> -			bool remove = false;
> -
> -			write_lock(&n->lock);
> -			if ((n->nud_state == NUD_FAILED) ||
> -			    (tbl->is_multicast &&
> -			     tbl->is_multicast(n->primary_key)) ||
> -			    time_after(tref, n->updated))
> -				remove = true;
> -			write_unlock(&n->lock);
> -
> -			if (remove && neigh_remove_one(n, tbl))
> -				shrunk++;
> -			if (shrunk >= max_clean)
> -				break;
> -		}
> +		bool remove = false;
> +
> +		write_lock(&n->lock);
> +		if ((n->nud_state == NUD_FAILED) ||
> +		    (tbl->is_multicast &&
> +		     tbl->is_multicast(n->primary_key)) ||
> +		    time_after(tref, n->updated))
> +			remove = true;
> +		write_unlock(&n->lock);
> +
> +		if (remove && neigh_remove_one(n, tbl))
> +			shrunk++;
> +		if (shrunk >= max_clean)
> +			break;
>  	}
>  
>  	tbl->last_flush = jiffies;
> @@ -264,16 +285,6 @@ static void neigh_add_timer(struct neighbour *n, unsigned long when)
>  	}
>  }
>  
> -static int neigh_del_timer(struct neighbour *n)
> -{
> -	if ((n->nud_state & NUD_IN_TIMER) &&
> -	    del_timer(&n->timer)) {
> -		neigh_release(n);
> -		return 1;
> -	}
> -	return 0;
> -}
> -
>  static void pneigh_queue_purge(struct sk_buff_head *list)
>  {
>  	struct sk_buff *skb;
> @@ -307,33 +318,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
>  				np = &n->next;
>  				continue;
>  			}
> -			rcu_assign_pointer(*np,
> -				   rcu_dereference_protected(n->next,
> -						lockdep_is_held(&tbl->lock)));
> -			write_lock(&n->lock);
> -			neigh_del_timer(n);
> -			neigh_mark_dead(n);
> -			if (refcount_read(&n->refcnt) != 1) {
> -				/* The most unpleasant situation.
> -				   We must destroy neighbour entry,
> -				   but someone still uses it.
> -
> -				   The destroy will be delayed until
> -				   the last user releases us, but
> -				   we must kill timers etc. and move
> -				   it to safe state.
> -				 */
> -				__skb_queue_purge(&n->arp_queue);
> -				n->arp_queue_len_bytes = 0;
> -				n->output = neigh_blackhole;
> -				if (n->nud_state & NUD_VALID)
> -					n->nud_state = NUD_NOARP;
> -				else
> -					n->nud_state = NUD_NONE;
> -				neigh_dbg(2, "neigh %p is stray\n", n);
> -			}
> -			write_unlock(&n->lock);
> -			neigh_cleanup_and_release(n);
> +			neigh_del(n, np, tbl);
>  		}
>  	}
>  }
> 

