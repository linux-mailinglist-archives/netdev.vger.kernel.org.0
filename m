Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557B91C7B51
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgEFUdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:33:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22802 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726093AbgEFUdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588797179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9ZFk1jBUP6x0YDNxDE3YAl8iEd93cob/siSLZhgGV9o=;
        b=BgGsusirw3mKGaDBtnERq3EyJi3RNFu4VR9GJF/lFY2MldP34e7FTourKEEqyIBYdnjsRj
        R6rSaR+2Ns4Pm7ULqlKQLfWpDI1oXhcgZ2ktQtODrYuv/h1IYi2IdZ93TDnifxO4vUVFZv
        sEEG25+ErxHKTTtN5aSIGRXKqtixKGU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-xgDK-C6JMiO_6Gm8vu4SSA-1; Wed, 06 May 2020 16:32:57 -0400
X-MC-Unique: xgDK-C6JMiO_6Gm8vu4SSA-1
Received: by mail-wr1-f70.google.com with SMTP id x8so1920523wrl.16
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ZFk1jBUP6x0YDNxDE3YAl8iEd93cob/siSLZhgGV9o=;
        b=TWQo6WTi91Pe22TCaPZ7zBoZKFPXS5hNl0Jy3veyshVYRcUyRxNrvC1UFFUDcIBg1d
         m9tmCtVj0THJE0vT+3Tinqt8HznFxuaImDIcMqwjpgvJ8USeqhb+7tvbnx00KIdt6QU+
         YPvBuQR2MG6rHXuHI8zDhDh48eZVrQh+1jqU1HpV78jpWIJzPjyjj5igNtT1hPIIF37Z
         8RcD9GEk1iuGfMTQu2msA3StHplWGUFOtVSXaMoY3bPlToWPsoPyIDeCR4Y2eibURrS/
         vX1u1Bet6OARW7FgVN+tnk5Gb2H7sLMSEn5N50MiJZAJQKgKc9qAt2XP4CFg23HSUq1I
         AAhw==
X-Gm-Message-State: AGi0PubMDFvk61D8Z5fQx8lcGYLC5PMRSqRxyD/+3dXz2ZaUxBywP8ti
        TiWv80NcvY0Dl1Tu4svO5qzMTYEWsH50gs3zwR+9ZP08+3OqGeK8+W9ySe7pkYwbUunzD9Ki7sN
        pC8qdnzIt9Prw06SF
X-Received: by 2002:adf:fe01:: with SMTP id n1mr11128886wrr.268.1588797176513;
        Wed, 06 May 2020 13:32:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypLReZq9OJmCb+r83s/HG7eVrefUQ62FWlPQlkLKQYTb7TAId3pVJFTSqkasQ6SnOGSz7lZN3Q==
X-Received: by 2002:adf:fe01:: with SMTP id n1mr11128869wrr.268.1588797176337;
        Wed, 06 May 2020 13:32:56 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id g15sm4608600wrp.96.2020.05.06.13.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:32:55 -0700 (PDT)
Date:   Wed, 6 May 2020 16:32:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Subject: Re: [PATCH net-next v2 19/33] tun: add XDP frame size
Message-ID: <20200506163247-mutt-send-email-mst@kernel.org>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824571799.2172139.18397231693481050715.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158824571799.2172139.18397231693481050715.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 01:21:58PM +0200, Jesper Dangaard Brouer wrote:
> The tun driver have two code paths for running XDP (bpf_prog_run_xdp).
> In both cases 'buflen' contains enough tailroom for skb_shared_info.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/tun.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 44889eba1dbc..c54f967e2c66 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1671,6 +1671,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>  		xdp_set_data_meta_invalid(&xdp);
>  		xdp.data_end = xdp.data + len;
>  		xdp.rxq = &tfile->xdp_rxq;
> +		xdp.frame_sz = buflen;
>  
>  		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>  		if (act == XDP_REDIRECT || act == XDP_TX) {
> @@ -2411,6 +2412,7 @@ static int tun_xdp_one(struct tun_struct *tun,
>  		}
>  		xdp_set_data_meta_invalid(xdp);
>  		xdp->rxq = &tfile->xdp_rxq;
> +		xdp->frame_sz = buflen;
>  
>  		act = bpf_prog_run_xdp(xdp_prog, xdp);
>  		err = tun_xdp_act(tun, xdp_prog, xdp, act);
> 
> 

