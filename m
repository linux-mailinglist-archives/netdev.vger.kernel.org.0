Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B1616F825
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 07:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgBZGne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 01:43:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:60112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgBZGne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 01:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582699412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=45Q2Z/6mfbnmrfD1M7fzs4kDePvxBZmHxdEsKKqCXbU=;
        b=e3trmm3Wbw8TSJaLC7y3vq5S0POnT3THJ7KfXodk0lkCkjHgmt/B9vIH05qbMFlbEgiDts
        d5MPqLa+oBi//t9uQdDD7cLfXRmTV/dUxqktgzFrkFmNNA57BxSO1uVUDFEva3+hZAtlzF
        71UVTTZ0lYCfOCp9H1Oin6YUkEUalXE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-yUIWZDVgMJCye-qyawHPpQ-1; Wed, 26 Feb 2020 01:43:28 -0500
X-MC-Unique: yUIWZDVgMJCye-qyawHPpQ-1
Received: by mail-qk1-f199.google.com with SMTP id w126so2682756qkb.23
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 22:43:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=45Q2Z/6mfbnmrfD1M7fzs4kDePvxBZmHxdEsKKqCXbU=;
        b=S1PzdF9siepIS8BW+quxrAhGZXEhZCTTA7O5Bgv5pIaij5FWpnbZabgNA3z/oo/UW/
         Dl5cIJsDuqNkoD1dlyKtmpSewh3T6YbNfdKYP3kZCss6pgKPR3sZzaVCegk96SGAFvbJ
         reOf63Huo73/oq7htoBFY1xdTn4R0sT0sCBQ7Cyxj/EzlT2GC0YGXa2xPKwMsonW8/jt
         Cle2eH/gNF41mt+JacO9p1nn36zxXGN9VUTTBD94JItB542PjM7xkunNw/hpR9JCSz5P
         66Qp9PUB54tWUCNCNRQ69rj+wLOa08XCjiReocnGiydbgZSMlyaxadiiVdgQ/z6HyWeQ
         S/Qg==
X-Gm-Message-State: APjAAAW+sk2zQ0NtrQ4KaJ+pid9a4k/01vTZmmu4AFPBs2T676iFI+QD
        jlbPdYyRSzRNEUVTc2xs6myfzIZ2DLxG0E9Y9VJrJcDiVcinGZX3iwMZQ41QOyX4DmvlGCEyRKV
        HXIW4LrY2JhiAHYiO
X-Received: by 2002:a05:6214:4f2:: with SMTP id cl18mr3431781qvb.89.1582699408011;
        Tue, 25 Feb 2020 22:43:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqyBbLUYkni9JkcvO08M+iP4GMZsMtJn2mpIqPOt9f6NH24OpB0rtHzSsoUIG0zq0EkxKWqt/Q==
X-Received: by 2002:a05:6214:4f2:: with SMTP id cl18mr3431745qvb.89.1582699407348;
        Tue, 25 Feb 2020 22:43:27 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id d9sm593296qtw.32.2020.02.25.22.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 22:43:26 -0800 (PST)
Date:   Wed, 26 Feb 2020 01:43:21 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226013336-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226005744.1623-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 05:57:44PM -0700, David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
> 
> virtio_net currently requires extra queues to install an XDP program,
> with the rule being twice as many queues as vcpus. From a host
> perspective this means the VM needs to have 2*vcpus vhost threads
> for each guest NIC for which XDP is to be allowed. For example, a
> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
> 
> The extra queues are only needed in case an XDP program wants to
> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> additional queues. Relax the queue requirement and allow XDP
> functionality based on resources. If an XDP program is loaded and
> there are insufficient queues, then return a warning to the user
> and if a program returns XDP_TX just drop the packet. This allows
> the use of the rest of the XDP functionality to work without
> putting an unreasonable burden on the host.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>


It isn't particularly easy for userspace to detect packets
are dropped. If there's a need for a limited XDP with
limited resources, IMHO it's better for userspace to
declare this to the driver.


> ---
>  drivers/net/virtio_net.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2fe7a3188282..2f4c5b2e674d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -190,6 +190,8 @@ struct virtnet_info {
>  	/* # of XDP queue pairs currently used by the driver */
>  	u16 xdp_queue_pairs;
>  
> +	bool can_do_xdp_tx;
> +
>  	/* I like... big packets and I cannot lie! */
>  	bool big_packets;
>  
> @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  			len = xdp.data_end - xdp.data;
>  			break;
>  		case XDP_TX:
> +			if (!vi->can_do_xdp_tx)
> +				goto err_xdp;
>  			stats->xdp_tx++;
>  			xdpf = convert_to_xdp_frame(&xdp);
>  			if (unlikely(!xdpf))
> @@ -870,6 +874,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			}
>  			break;
>  		case XDP_TX:
> +			if (!vi->can_do_xdp_tx)
> +				goto err_xdp;
>  			stats->xdp_tx++;
>  			xdpf = convert_to_xdp_frame(&xdp);
>  			if (unlikely(!xdpf))
> @@ -2435,10 +2441,10 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
>  
>  	/* XDP requires extra queues for XDP_TX */
>  	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
> -		netdev_warn(dev, "request %i queues but max is %i\n",
> -			    curr_qp + xdp_qp, vi->max_queue_pairs);
> -		return -ENOMEM;
> +		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available; XDP_TX will not be allowed");
> +		vi->can_do_xdp_tx = false;
> +	} else {
> +		vi->can_do_xdp_tx = true;
>  	}
>  
>  	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
> -- 
> 2.17.1

