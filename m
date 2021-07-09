Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91BD3C2219
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 12:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbhGIKR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 06:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231864AbhGIKR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 06:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625825715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lhJ6tiif1JBj1r12vohofmrlsesDWEqh4MF11PwNUDo=;
        b=fYOxqxrnZS7KEHELyPecVupQGVKOAj5oiq6Gb8zXZDu/2exlekvdd0kajJuEbfcPJXMqRD
        jDKicDs0rLAolfK+NVR0m/v+kyeMnkULY7FRo0JZSp6gASwTHaFCBU1sy0EvDM3x/uEyC1
        16/A3X6iu+ABJrE6WI4U5vo39XzBhzE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-Q_eb_KzmOQCridMky0prSQ-1; Fri, 09 Jul 2021 06:15:14 -0400
X-MC-Unique: Q_eb_KzmOQCridMky0prSQ-1
Received: by mail-ej1-f72.google.com with SMTP id rl7-20020a1709072167b02904f7606bd58fso2503820ejb.11
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 03:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lhJ6tiif1JBj1r12vohofmrlsesDWEqh4MF11PwNUDo=;
        b=WaahGLEGiP1deOuma9y8VYb0d50xmsXLIRlgxbkttkgcwUOtUYPA/s9YO3fHBlHXVT
         wic+YYisyl2vyEwh5JESo4+sU9UunxVq+bpYgVVpFeahpA1q/+Oqzq55Yo6fENYp/dw8
         XVifFGxflMvEFd8ylOA6pfM/2JT2wXFgRBzCfe6FBdIOOLKx/tMobazZghzEAnmUy9GE
         Xm05SyHjGNlgRoG+rd3nIsYFz3uZQ/DzCI45BLUs6qKdOzegTYlJkp1pr5nqbFXty2ev
         10OxiWpyX3DQRMwPdU6AK35ZeW0URdiPQn895QEI+uDaw6qXoeAMJ7SLZLW5qdCNkEC3
         F5TQ==
X-Gm-Message-State: AOAM531G8Xjtr1fBovnOQiZIPriZW59upz+4QK8UYRL3gKVHGq9F0gEr
        htX6EAS7g3Mpoq1CjyBhjKj5tMYm13qT2EWVX5niWhzyinrwYKewNcMr4+1iuikbyUvlMUw64I4
        dg76+JpF1UsX0TrL3
X-Received: by 2002:a05:6402:5142:: with SMTP id n2mr45452190edd.241.1625825712895;
        Fri, 09 Jul 2021 03:15:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxhY1XiAnB9pjK9GTB727I0KdoOFeCGlcVnzS7EInD5UTVOj/Iz5bXhtG4cbViE9Jq1lGx7zA==
X-Received: by 2002:a05:6402:5142:: with SMTP id n2mr45452166edd.241.1625825712708;
        Fri, 09 Jul 2021 03:15:12 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id ch27sm989984edb.57.2021.07.09.03.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 03:15:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 998CE180733; Fri,  9 Jul 2021 12:15:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool op
In-Reply-To: <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
 <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Jul 2021 12:15:11 +0200
Message-ID: <878s2fvln4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> This change implements the set_channel() ethtool operation,
> preserving the current defaults values and allowing up set
> the number of queues in the range set ad device creation
> time.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/veth.c | 62 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 58 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index bdb7ce3cb054..10360228a06a 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -72,6 +72,8 @@ struct veth_priv {
>  	atomic64_t		dropped;
>  	struct bpf_prog		*_xdp_prog;
>  	struct veth_rq		*rq;
> +	unsigned int		num_tx_queues;
> +	unsigned int		num_rx_queues;

Why are these needed to be duplicated? Don't they just duplicate the
'real_num_tx_queues' members in struct net_device?

>  	unsigned int		requested_headroom;
>  };
>  
> @@ -224,10 +226,49 @@ static void veth_get_channels(struct net_device *dev,
>  {
>  	channels->tx_count = dev->real_num_tx_queues;
>  	channels->rx_count = dev->real_num_rx_queues;
> -	channels->max_tx = dev->real_num_tx_queues;
> -	channels->max_rx = dev->real_num_rx_queues;
> +	channels->max_tx = dev->num_tx_queues;
> +	channels->max_rx = dev->num_rx_queues;
>  	channels->combined_count = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
> -	channels->max_combined = min(dev->real_num_rx_queues, dev->real_num_tx_queues);
> +	channels->max_combined = min(dev->num_rx_queues, dev->num_tx_queues);
> +}
> +
> +static int veth_close(struct net_device *dev);
> +static int veth_open(struct net_device *dev);
> +
> +static int veth_set_channels(struct net_device *dev,
> +			     struct ethtool_channels *ch)
> +{
> +	struct veth_priv *priv = netdev_priv(dev);
> +	struct veth_priv *peer_priv;
> +
> +	/* accept changes only on rx/tx */
> +	if (ch->combined_count != min(dev->real_num_rx_queues, dev->real_num_tx_queues))
> +		return -EINVAL;
> +
> +	/* respect contraint posed at device creation time */
> +	if (ch->rx_count > dev->num_rx_queues || ch->tx_count > dev->num_tx_queues)
> +		return -EINVAL;
> +
> +	if (!ch->rx_count || !ch->tx_count)
> +		return -EINVAL;
> +
> +	/* avoid braking XDP, if that is enabled */
> +	if (priv->_xdp_prog && ch->rx_count < priv->peer->real_num_tx_queues)
> +		return -EINVAL;
> +
> +	peer_priv = netdev_priv(priv->peer);
> +	if (peer_priv->_xdp_prog && ch->tx_count > priv->peer->real_num_rx_queues)
> +		return -EINVAL;

An XDP program could be loaded later, so I think it's better to enforce
this constraint unconditionally.

(What happens on the regular xmit path if the number of TX queues is out
of sync with the peer RX queues, BTW?)

> +	if (netif_running(dev))
> +		veth_close(dev);
> +
> +	priv->num_tx_queues = ch->tx_count;
> +	priv->num_rx_queues = ch->rx_count;

Why can't just you use netif_set_real_num_*_queues() here directly (and
get rid of the priv members as above)?

-Toke

