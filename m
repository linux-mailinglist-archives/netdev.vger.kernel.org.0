Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEDB20B073
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgFZL27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728558AbgFZL26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:28:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E4FC08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:28:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so9021587ejj.5
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=CP2lXpX1jeN16cNfchT7V53vKPKcB5ET1erYzrv/Vuc=;
        b=17f5u8jX2f+waJSMdObg6WTJqlMmW4Cv0SP+aHDKLN3e8RCe139sQTZ1U5ML2xN7TF
         E0KN6pzv8dlZ48nkXIcH2KsSAgnI3eq9LiTOetYjDMSmWgOveLq7J/NfOy8zUvWugYMR
         jCw5lidCzDcOGj7WZkqHO4a3GpaY4VXhF0Ss7E89CpKK0uB0A6vW9tFj0kDkMeEFdUcf
         goKAOL9bh/8gDPXTRn0ifgYe7JDexrb6Hvm1YNp/o+mNxZZJb2PJ1RkmOm6w705RGbne
         1yWsoDAgL102hySTIvTD5QWHOUIh/8HfPGjs9LF2xzVLsnVrlZr22xrweYZLznres37G
         Hhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=CP2lXpX1jeN16cNfchT7V53vKPKcB5ET1erYzrv/Vuc=;
        b=HpitsKTzpDMs5p3BQkI2sBJeGE18+svegvWV9g0ySN3gMLa9z7zD5PVtMHoYEWcjNp
         eBeZID4bfBsXmvM/1fF3d+rSPHAx8I33a7lFHGccZSDl1U/wFawrRFl+iLwVdXEjoqST
         yxemB7m4Ro5iaNneaaWeP6D89fw3kFfc91RGwxkecW6FCxOD7x3yNkQSDX/XFIucoufR
         0jhyC5IKrRxglzMA65JGub6DXvIb/oNXbMJY/VwlmEC1tdmyfQvJi3wSJxY4eJTobjhW
         Vb/zcwOeqGF1xK95VINe/PwapYOxQ5s9/EptjAhDUyODwkaS+hSSn/CuoaZchRz3Zt+9
         jukA==
X-Gm-Message-State: AOAM530tIPdpW2+3DPTaF2rdM/R7LBj3GSvkUj7RmIjnzKPY3mJjYlvQ
        5t8hb8cS6YEjd1nVCOH3l8i70U+EOdNJ96GWmAJ5D7Ske64=
X-Google-Smtp-Source: ABdhPJwppMukAwfIhROULio5K/QCJsZDu8ldnH2WIW3RumQkbQHiWLneenFFWpafbm+b7vcJJEWZiCCN0nFWessA6OY=
X-Received: by 2002:a17:906:6dcd:: with SMTP id j13mr1991881ejt.131.1593170936830;
 Fri, 26 Jun 2020 04:28:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:3a1b:0:0:0:0:0 with HTTP; Fri, 26 Jun 2020 04:28:56
 -0700 (PDT)
X-Originating-IP: [5.35.13.201]
In-Reply-To: <1593170826-1600-4-git-send-email-kda@linux-powerpc.org>
References: <1593170826-1600-1-git-send-email-kda@linux-powerpc.org> <1593170826-1600-4-git-send-email-kda@linux-powerpc.org>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 26 Jun 2020 14:28:56 +0300
Message-ID: <CAOJe8K0W1oC=2kcJOBFnOxFsGo2gBv6Jb0YQJCtPg5gfrOzonQ@mail.gmail.com>
Subject: Re: [PATCH net-next v12 3/3] xen networking: add XDP offset
 adjustment to xen-netback
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/26/20, Denis Kirjanov <kda@linux-powerpc.org> wrote:
> the patch basically adds the offset adjustment and netfront
> state reading to make XDP work on netfront side.
>
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Ooops, please ignore it. That was to quick :/

> ---
>  drivers/net/xen-netback/common.h    |  4 ++++
>  drivers/net/xen-netback/interface.c |  2 ++
>  drivers/net/xen-netback/netback.c   |  7 +++++++
>  drivers/net/xen-netback/rx.c        | 15 ++++++++++++++-
>  drivers/net/xen-netback/xenbus.c    | 34
> ++++++++++++++++++++++++++++++++++
>  5 files changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/xen-netback/common.h
> b/drivers/net/xen-netback/common.h
> index 05847eb..ae477f7 100644
> --- a/drivers/net/xen-netback/common.h
> +++ b/drivers/net/xen-netback/common.h
> @@ -281,6 +281,9 @@ struct xenvif {
>  	u8 ipv6_csum:1;
>  	u8 multicast_control:1;
>
> +	/* headroom requested by xen-netfront */
> +	u16 xdp_headroom;
> +
>  	/* Is this interface disabled? True when backend discovers
>  	 * frontend is rogue.
>  	 */
> @@ -395,6 +398,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct
> xenvif_queue *queue)
>  irqreturn_t xenvif_interrupt(int irq, void *dev_id);
>
>  extern bool separate_tx_rx_irq;
> +extern bool provides_xdp_headroom;
>
>  extern unsigned int rx_drain_timeout_msecs;
>  extern unsigned int rx_stall_timeout_msecs;
> diff --git a/drivers/net/xen-netback/interface.c
> b/drivers/net/xen-netback/interface.c
> index 0c8a02a..fc16edd 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -483,6 +483,8 @@ struct xenvif *xenvif_alloc(struct device *parent,
> domid_t domid,
>  	vif->queues = NULL;
>  	vif->num_queues = 0;
>
> +	vif->netfront_xdp_headroom = 0;
> +
>  	spin_lock_init(&vif->lock);
>  	INIT_LIST_HEAD(&vif->fe_mcast_addr);
>
> diff --git a/drivers/net/xen-netback/netback.c
> b/drivers/net/xen-netback/netback.c
> index 315dfc6..6dfca72 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -96,6 +96,13 @@
>  module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
>  MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
>
> +/* The module parameter tells that we have to put data
> + * for xen-netfront with the XDP_PACKET_HEADROOM offset
> + * needed for XDP processing
> + */
> +bool provides_xdp_headroom = true;
> +module_param(provides_xdp_headroom, bool, 0644);
> +
>  static void xenvif_idx_release(struct xenvif_queue *queue, u16
> pending_idx,
>  			       u8 status);
>
> diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
> index ef58870..c5e9e14 100644
> --- a/drivers/net/xen-netback/rx.c
> +++ b/drivers/net/xen-netback/rx.c
> @@ -258,6 +258,19 @@ static void xenvif_rx_next_skb(struct xenvif_queue
> *queue,
>  		pkt->extra_count++;
>  	}
>
> +	if (queue->vif->netfront_xdp_headroom) {
> +		struct xen_netif_extra_info *extra;
> +
> +		extra = &pkt->extras[XEN_NETIF_EXTRA_TYPE_XDP - 1];
> +
> +		memset(extra, 0, sizeof(struct xen_netif_extra_info));
> +		extra->u.xdp.headroom = queue->vif->netfront_xdp_headroom;
> +		extra->type = XEN_NETIF_EXTRA_TYPE_XDP;
> +		extra->flags = 0;
> +
> +		pkt->extra_count++;
> +	}
> +
>  	if (skb->sw_hash) {
>  		struct xen_netif_extra_info *extra;
>
> @@ -356,7 +369,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue
> *queue,
>  				struct xen_netif_rx_request *req,
>  				struct xen_netif_rx_response *rsp)
>  {
> -	unsigned int offset = 0;
> +	unsigned int offset = queue->vif->netfront_xdp_headroom;
>  	unsigned int flags;
>
>  	do {
> diff --git a/drivers/net/xen-netback/xenbus.c
> b/drivers/net/xen-netback/xenbus.c
> index 286054b..f321068 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,24 @@ static void set_backend_state(struct backend_info *be,
>  	}
>  }
>
> +static void read_xenbus_frontend_xdp(struct backend_info *be,
> +				      struct xenbus_device *dev)
> +{
> +	struct xenvif *vif = be->vif;
> +	u16 headroom;
> +	int err;
> +
> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> +			   "xdp-headroom", "%hu", &headroom);
> +	if (err != 1) {
> +		vif->netfront_xdp_headroom = 0;
> +		return;
> +	}
> +	if (headroom > XEN_NETIF_MAX_XDP_HEADROOM)
> +		headroom = XEN_NETIF_MAX_XDP_HEADROOM;
> +	vif->netfront_xdp_headroom = headroom;
> +}
> +
>  /**
>   * Callback received when the frontend's state changes.
>   */
> @@ -417,6 +435,11 @@ static void frontend_changed(struct xenbus_device
> *dev,
>  		set_backend_state(be, XenbusStateConnected);
>  		break;
>
> +	case XenbusStateReconfiguring:
> +		read_xenbus_frontend_xdp(be, dev);
> +		xenbus_switch_state(dev, XenbusStateReconfigured);
> +		break;
> +
>  	case XenbusStateClosing:
>  		set_backend_state(be, XenbusStateClosing);
>  		break;
> @@ -947,6 +970,8 @@ static int read_xenbus_vif_flags(struct backend_info
> *be)
>  	vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
>  						"feature-ipv6-csum-offload", 0);
>
> +	read_xenbus_frontend_xdp(be, dev);
> +
>  	return 0;
>  }
>
> @@ -1036,6 +1061,15 @@ static int netback_probe(struct xenbus_device *dev,
>  			goto abort_transaction;
>  		}
>
> +		/* we can adjust a headroom for netfront XDP processing */
> +		err = xenbus_printf(xbt, dev->nodename,
> +				    "feature-xdp-headroom", "%d",
> +				    provides_xdp_headroom);
> +		if (err) {
> +			message = "writing feature-xdp-headroom";
> +			goto abort_transaction;
> +		}
> +
>  		/* We don't support rx-flip path (except old guests who
>  		 * don't grok this feature flag).
>  		 */
> --
> 1.8.3.1
>
>
