Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06842C6EA1
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 04:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730942AbgK1DYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 22:24:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49841 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730830AbgK0Tyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 14:54:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606506832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M/fe2yj2Q26HfFpDGiUaTOc7G7mNGEHtDg3Y6hQ9yEg=;
        b=caFpkOHUwqGz4nJCd+JV3BXP2yrLhRjin7QmxojVOGlBxT7MJH8sQFiAnRyw1FlHtKKKmX
        ZA28VjDsOIQ+s757jY3+j0DVGhI4x5LtTBR26TfqsuwDEKlpRDKRuUw1erZLV2i5c7IO83
        7gdcYCvH3xZ3mUggPfAKH6OXhsnQ+FM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-nTOh3HEZOf-S2DvgEUtRQg-1; Fri, 27 Nov 2020 14:31:38 -0500
X-MC-Unique: nTOh3HEZOf-S2DvgEUtRQg-1
Received: by mail-wr1-f71.google.com with SMTP id 91so3822937wrk.17
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 11:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M/fe2yj2Q26HfFpDGiUaTOc7G7mNGEHtDg3Y6hQ9yEg=;
        b=I3t/Ce2keZdNvWVAWZA+a5UUAOX75Fnn0YRCDDp6JZoAxBeGK6eloIKx1Q4O1I5MWo
         6f6v/vl3aLH9iGYuCwRkTQ720DkeFHunz/gnKTYOTVzsklCdLkttPNzNDAVu35amCx5q
         zFJVh+4Ei4ef4ZfFY/ZBtejW4u4v2GSHEKfy5PP917jlkpXAY8elvQVD6RsgPK8bkmrQ
         52KPbkfB+T1mwZfNh+yNkirBfO6IanTD1iDXmlKRzWgAfuGQD7rC4Rkn8uPXvXIr486E
         25DjYfCrR0nfnyGXS2qAvFslt0JJoM+D0fdYVPIhcnN7tGAhjxKepqbqqfW15bQDSWmF
         wgYQ==
X-Gm-Message-State: AOAM531xnJK+EYNwL5T3PHxiV71uFW6mNOaGf0f3GBBD5XQPMLZuUMGm
        7Z6+tH5GJWPndWX+6ZIikz4sD49dKEhKEQP3I0tsuUhMce43Nbb1SIBBNldpjbviVKwzYEF7jmH
        PQw6bx4JWiMoheZw+
X-Received: by 2002:a5d:6447:: with SMTP id d7mr12378225wrw.96.1606505497233;
        Fri, 27 Nov 2020 11:31:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygFAI9ROZ2ioGaUwzV+W31rZCpGYquXRdGnsiYRIBVLiahxYsj/3KmngGBkeuBDPrsN6r8MQ==
X-Received: by 2002:a5d:6447:: with SMTP id d7mr12378193wrw.96.1606505496876;
        Fri, 27 Nov 2020 11:31:36 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id a1sm16404143wrv.61.2020.11.27.11.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:31:36 -0800 (PST)
Date:   Fri, 27 Nov 2020 20:31:34 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201127193134.GA23450@linux.home>
References: <20201126122426.25243-1-tparkin@katalix.com>
 <20201126122426.25243-2-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201126122426.25243-2-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 12:24:25PM +0000, Tom Parkin wrote:
> This new ioctl pair allows two ppp channels to be bridged together:
> frames arriving in one channel are transmitted in the other channel
> and vice versa.

Thanks!
Some comments below (mostly about locking).

> The practical use for this is primarily to support the L2TP Access
> Concentrator use-case.  The end-user session is presented as a ppp
> channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
> over a serial link) and is switched into a PPPoL2TP session for
> transmission to the LNS.  At the LNS the PPP session is terminated in
> the ISP's network.
> 
> When a PPP channel is bridged to another it takes a reference on the
> other's struct ppp_file.  This reference is dropped when the channels
> are unbridged, which can occur either explicitly on userspace calling
> the PPPIOCUNBRIDGECHAN ioctl, or implicitly when either channel in the
> bridge is unregistered.
> 
> In order to implement the channel bridge, struct channel is extended
> with a new field, 'bridge', which points to the other struct channel
> making up the bridge.
> 
> This pointer is RCU protected to avoid adding another lock to the data
> path.
> 
> To guard against concurrent writes to the pointer, the existing struct
> channel lock 'downl' use is extended (rather than adding a new lock).
> Order of lock acquisition is maintained: i.e. the channel 'upl' lock is
> always acquired before 'downl' in code paths that need to hold both.
> 
> Signed-off-by: Tom Parkin <tparkin@katalix.com>
> ---
>  drivers/net/ppp/ppp_generic.c  | 147 ++++++++++++++++++++++++++++++++-
>  include/uapi/linux/ppp-ioctl.h |   2 +
>  2 files changed, 147 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> index 7d005896a0f9..5e563bfb8e2a 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -170,11 +170,12 @@ struct channel {
>  	struct list_head list;		/* link in all/new_channels list */
>  	struct ppp_channel *chan;	/* public channel data structure */
>  	struct rw_semaphore chan_sem;	/* protects `chan' during chan ioctl */
> -	spinlock_t	downl;		/* protects `chan', file.xq dequeue */
> +	spinlock_t	downl;		/* protects `chan', 'bridge', file.xq dequeue */
>  	struct ppp	*ppp;		/* ppp unit we're connected to */
>  	struct net	*chan_net;	/* the net channel belongs to */
>  	struct list_head clist;		/* link in list of channels per unit */
>  	rwlock_t	upl;		/* protects `ppp' */
> +	struct channel *bridge;		/* "bridged" ppp channel */

Missing __rcu annotation (as reported by kernel test robot):
struct channel __rcu *bridge;

With RCU protection, it might make sense to use ->upl, instead of
->downl, to protect the update side. Since ->upl is used to protect the
pointer to the parent unit, it probably makes sense to use it for
->bridge too, which somehow replaces the parent unit (as both are
mutually exclusive). Also, using ->upl would avoid some lock nesting
when updating ->bridge.

>  #ifdef CONFIG_PPP_MULTILINK
>  	u8		avail;		/* flag used in multilink stuff */
>  	u8		had_frag;	/* >= 1 fragments have been sent */
> @@ -606,6 +607,95 @@ static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
>  #endif
>  #endif
>  
> +/* Bridge one PPP channel to another.
> + * When two channels are bridged, ppp_input on one channel is redirected to
> + * the other's ops->start_xmit handler.
> + * In order to safely bridge channels we must reject channels which are already
> + * part of a bridge instance, or which form part of an existing unit.
> + * Once successfully bridged, each channel holds a reference on the other
> + * to prevent it being freed while the bridge is extant.
> + */
> +static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
> +{
> +	int ret = -EALREADY;
> +
> +	/* We need to take each channel upl for access to the 'ppp' field,
> +	 * and each channel downl for write access to the 'bridge' field.
> +	 */
> +
> +	read_lock_bh(&pch->upl);
> +	if (pch->ppp)
> +		goto out0;
> +
> +	spin_lock(&pch->downl);
> +
> +	read_lock_bh(&pchb->upl);
> +	if (pchb->ppp)
> +		goto out1;

You're verifying that ->ppp isn't set, however, you haven't added a
test in ppp_connect_channel() to avoid setting ->ppp when ->bridge
is already set. Therefore, it'd still be possible to set both ->ppp and
->bridge on a channel.

> +	spin_lock(&pchb->downl);
> +
> +	if (pch->bridge || pchb->bridge)
> +		goto out2;
> +
> +	rcu_assign_pointer(pch->bridge, pchb);
> +	refcount_inc(&pchb->file.refcnt);
> +
> +	rcu_assign_pointer(pchb->bridge, pch);
> +	refcount_inc(&pch->file.refcnt);
> +
> +	ret = 0;
> +
> +out2:
> +	spin_unlock(&pchb->downl);
> +out1:
> +	read_unlock_bh(&pchb->upl);
> +	spin_unlock(&pch->downl);
> +out0:
> +	read_unlock_bh(&pch->upl);
> +
> +	return ret;
> +}

Locking looks dangerous here: given that ppp_bridge_channels() is
called with pn->all_channels_lock held, that's 5 nested locks.

Since we have to hold the channels anyway, why not incrementing the
refcount immediately and unlock everything as soon as possible?

That is, instead of doing:
  LOCK(all_channels_lock)
  LOCK(channel->upl)
  LOCK(channel->downl)
  LOCK(bridge->upl)
  LOCK(bridge->downl)
  assign_pointers
  UNLOCK()
  ...
  UNLOCK()

what about something like:

  LOCK(all_channels_lock)
  bridge = find_channel()
  refcount_inc(&bridge->refcount)
  UNLOCK(all_channels_lock)

  LOCK(channel->upl)
  LOCK(channel->downl)
  set ->bridge
  UNLOCK(channel->downl)
  UNLOCK(channel->upl)

  refcount_inc(&channel->refcount) // so that bridge holds a ref

  LOCK(bridge->upl)
  LOCK(bridge->downl)
  set ->bridge
  UNLOCK(bridge->downl)
  UNLOCK(bridge->upl)

We could even avoid locking ->downl if ->bridge was protected directly
by ->upl. That way we'd avoid nesting locks entirely.

> +static int ppp_unbridge_channels(struct channel *pch)
> +{
> +	struct channel *pchb;
> +
> +	rcu_read_lock();
> +
> +	pchb = rcu_dereference(pch->bridge);
> +	if (!pchb) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}
> +
> +	if (pch != rcu_dereference(pchb->bridge)) {
> +		rcu_read_unlock();
> +		return -ENXIO;
> +	}

Looks like we have a TOCTOU problem here: ->bridge might change before
we lock ->downl.

> +	spin_lock(&pch->downl);
> +	spin_lock(&pchb->downl);

I think we can have a deadlock here. Since ppp_unbridge_channels()
isn't running under the protection of an external lock, we could have
the bridge channel call this function concurrently. Then we'd have
lock inversion:

  ppp_unbridge_channels(channel)    ppp_unbridge_channels(bridge)
    LOCK(channel->downl)              LOCK(bridge->downl)
    LOCK(bridge->downl)               LOCK(channel->downl)  // deadlock

Here again I think we should avoid nesting locks and clear each
->bridge pointer independently.

> +	rcu_assign_pointer(pch->bridge, NULL);
> +	rcu_assign_pointer(pchb->bridge, NULL);

Nit, we can use RCU_INIT_POINTER() when resetting a pointer with NULL.

> +	spin_unlock(&pchb->downl);
> +	spin_unlock(&pch->downl);
> +
> +	rcu_read_unlock();
> +
> +	synchronize_rcu();
> +
> +	if (refcount_dec_and_test(&pch->file.refcnt))
> +		ppp_destroy_channel(pch);
> +
> +	if (refcount_dec_and_test(&pchb->file.refcnt))
> +		ppp_destroy_channel(pchb);
> +
> +	return 0;
> +}
> +
>  static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct ppp_file *pf;
> @@ -641,8 +731,9 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	}
>  
>  	if (pf->kind == CHANNEL) {
> -		struct channel *pch;
> +		struct channel *pch, *pchb;
>  		struct ppp_channel *chan;
> +		struct ppp_net *pn;
>  
>  		pch = PF_TO_CHANNEL(pf);
>  
> @@ -657,6 +748,22 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  			err = ppp_disconnect_channel(pch);
>  			break;
>  
> +		case PPPIOCBRIDGECHAN:
> +			if (get_user(unit, p))
> +				break;
> +			err = -ENXIO;
> +			pn = ppp_pernet(current->nsproxy->net_ns);
> +			spin_lock_bh(&pn->all_channels_lock);
> +			pchb = ppp_find_channel(pn, unit);
> +			if (pchb)
> +				err = ppp_bridge_channels(pch, pchb);
> +			spin_unlock_bh(&pn->all_channels_lock);
> +			break;
> +
> +		case PPPIOCUNBRIDGECHAN:
> +			err = ppp_unbridge_channels(pch);
> +			break;
> +
>  		default:
>  			down_read(&pch->chan_sem);
>  			chan = pch->chan;
> @@ -2089,6 +2196,35 @@ static bool ppp_decompress_proto(struct sk_buff *skb)
>  	return pskb_may_pull(skb, 2);
>  }
>  
> +/* Attempt to handle a frame via. a bridged channel, if one exists.
> + * If the channel is bridged, the frame is consumed by the bridge.
> + * If not, the caller must handle the frame by normal recv mechanisms.
> + * Returns true if the frame is consumed, false otherwise.
> + */
> +static bool ppp_channel_bridge_input(struct channel *pch, struct sk_buff *skb)
> +{
> +	struct channel *pchb;
> +
> +	rcu_read_lock();
> +	pchb = rcu_dereference(pch->bridge);
> +	if (pchb) {
> +		spin_lock(&pchb->downl);
> +		if (pchb->chan) {
> +			skb_scrub_packet(skb, !net_eq(pch->chan_net, pchb->chan_net));
> +			if (!pchb->chan->ops->start_xmit(pchb->chan, skb))
> +				kfree_skb(skb);
> +		} else {
> +			/* channel got unregistered */
> +			kfree_skb(skb);
> +		}
> +		spin_unlock(&pchb->downl);
> +	}
> +	rcu_read_unlock();
> +
> +	/* If pchb is set then we've consumed the packet */
> +	return pchb;
> +}

Maybe "return !!pchb;". I always find it unexpected to store a pointer
into a bool. But maybe it's just me.
Also, I believe the code could be made more readable by returning early
in unhandled cases, instead of nesting all the conditions.

>  void
>  ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
>  {
> @@ -2100,6 +2236,10 @@ ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
>  		return;
>  	}
>  
> +	/* If the channel is bridged, transmit via. bridge */
> +	if (ppp_channel_bridge_input(pch, skb))
> +		return;
> +
>  	read_lock_bh(&pch->upl);
>  	if (!ppp_decompress_proto(skb)) {
>  		kfree_skb(skb);
> @@ -2796,8 +2936,11 @@ ppp_unregister_channel(struct ppp_channel *chan)
>  	list_del(&pch->list);
>  	spin_unlock_bh(&pn->all_channels_lock);
>  
> +	ppp_unbridge_channels(pch);
> +
>  	pch->file.dead = 1;
>  	wake_up_interruptible(&pch->file.rwait);
> +
>  	if (refcount_dec_and_test(&pch->file.refcnt))
>  		ppp_destroy_channel(pch);
>  }
> diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
> index 7bd2a5a75348..8dbecb3ad036 100644
> --- a/include/uapi/linux/ppp-ioctl.h
> +++ b/include/uapi/linux/ppp-ioctl.h
> @@ -115,6 +115,8 @@ struct pppol2tp_ioc_stats {
>  #define PPPIOCATTCHAN	_IOW('t', 56, int)	/* attach to ppp channel */
>  #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
>  #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
> +#define PPPIOCBRIDGECHAN _IOW('t', 53, int)	/* bridge one channel to another */
> +#define PPPIOCUNBRIDGECHAN _IO('t', 54)	/* unbridge channel */
>  
>  #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
>  #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */
> -- 
> 2.17.1
> 

