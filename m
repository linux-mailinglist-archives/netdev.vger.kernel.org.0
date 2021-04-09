Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A2E35A194
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 16:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhDIO6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 10:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233541AbhDIO6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 10:58:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617980281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5lM8BXbAB1LpWiYvO+Oh6jqO0FSF6aQebUJSfZqsk2w=;
        b=I0TmGagACttPrM5snH/F5FFXfMYtVxB5pj2R4dZmbITYeQb2BQOVo3X3z1nIL+5y4JK0Nr
        JVcEndK1fb6Wgj83qIsVvbQZK125A4Cc+EVCI0kbPNP0/uTUWVN+q8dV/RD0ErCyd3kTpt
        vqFZyDectiTZAH+m9x7iJvE1Y1mUy3U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-k9QPskJtMaqm7hVKtuhE3A-1; Fri, 09 Apr 2021 10:57:50 -0400
X-MC-Unique: k9QPskJtMaqm7hVKtuhE3A-1
Received: by mail-ej1-f70.google.com with SMTP id a11so2053433ejg.7
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 07:57:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5lM8BXbAB1LpWiYvO+Oh6jqO0FSF6aQebUJSfZqsk2w=;
        b=qG4EWNlNArJkWPQsxRmMwVWZgiyajFH+NLbyISBiDZdoJrP0qGaDU1Hac+2fNJ+/px
         AvBhZfNWF57X5ZzEti1BM/LRJAL5eSx69k7yXnqut/4u7pMY0LYg4xkcEECbT5czKKaH
         mnmoPg+rIvcFBfePbWToxY12tRpnW7/3SjM66oufiPMngPGaMDSVEHh4zYqTr3Tx+dg0
         BCSJSc2ebAmZNxdPBTb8vH8RP0MyuyLzAkCNHE7waXgQ8/wqB9moQr3doM0EO9YHi3sh
         mInQWOvBuYLcWjcRnG0R1fB0l4l/Px2c5KmGxe2weKQC5F4Z6laEZG+cRnbVnHfaq3n+
         bo2w==
X-Gm-Message-State: AOAM530/B7SKgHdU0YHf6Py+T3g7eH8ZV1ZCJsoRLbk2osZqxqp1jp5F
        uan2rGezqreJiCz8Ma6o1mpbiq3JwZCn66dvYQQaor9thyPLfqsgae8PLkH05jegghZhFPRQn6U
        yBgBvfeYpWwZf5h79
X-Received: by 2002:aa7:c9c8:: with SMTP id i8mr17664021edt.193.1617980269385;
        Fri, 09 Apr 2021 07:57:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPtXF1LEzt286HlIzaz3Xy5xGUjW/PsMrKRaD0MkLFFVNpqLClJjkDG2qa3d1LRkaGFdii1g==
X-Received: by 2002:aa7:c9c8:: with SMTP id i8mr17664013edt.193.1617980269213;
        Fri, 09 Apr 2021 07:57:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id eo22sm1350756ejc.0.2021.04.09.07.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 07:57:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C503A1802F9; Fri,  9 Apr 2021 16:57:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next 3/4] veth: refine napi usage
In-Reply-To: <b241da0e8aa31773472591e219ada3632a84dfbb.1617965243.git.pabeni@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
 <b241da0e8aa31773472591e219ada3632a84dfbb.1617965243.git.pabeni@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Apr 2021 16:57:47 +0200
Message-ID: <87y2drtsic.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> After the previous patch, when enabling GRO, locally generated
> TCP traffic experiences some measurable overhead, as it traverses
> the GRO engine without any chance of aggregation.
>
> This change refine the NAPI receive path admission test, to avoid
> unnecessary GRO overhead in most scenarios, when GRO is enabled
> on a veth peer.
>
> Only skbs that are eligible for aggregation enter the GRO layer,
> the others will go through the traditional receive path.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  drivers/net/veth.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index ca44e82d1edeb..85f90f33d437e 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -282,6 +282,25 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
>  		netif_rx(skb);
>  }
>  
> +/* return true if the specified skb has chances of GRO aggregation
> + * Don't strive for accuracy, but try to avoid GRO overhead in the most
> + * common scenarios.
> + * When XDP is enabled, all traffic is considered eligible, as the xmit
> + * device has TSO off.
> + * When TSO is enabled on the xmit device, we are likely interested only
> + * in UDP aggregation, explicitly check for that if the skb is suspected
> + * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
> + * to belong to locally generated UDP traffic.
> + */
> +static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
> +					 const struct net_device *rcv,
> +					 const struct sk_buff *skb)
> +{
> +	return !(dev->features & NETIF_F_ALL_TSO) ||
> +		(skb->destructor == sock_wfree &&
> +		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
> +}
> +
>  static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>  {
>  	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
> @@ -305,8 +324,10 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  		/* The napi pointer is available when an XDP program is
>  		 * attached or when GRO is enabled
> +		 * Don't bother with napi/GRO if the skb can't be aggregated
>  		 */
> -		use_napi = rcu_access_pointer(rq->napi);
> +		use_napi = rcu_access_pointer(rq->napi) &&
> +			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
>  		skb_record_rx_queue(skb, rxq);
>  	}

You just changed the 'xdp_rcv' check to this use_napi, and now you're
conditioning it on GRO eligibility, so doesn't this break XDP if that
was the reason NAPI was turned on in the first place?

-Toke

