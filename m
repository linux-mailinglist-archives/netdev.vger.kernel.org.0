Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589BE1C7B45
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgEFUbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:31:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44066 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726218AbgEFUbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:31:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588797059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mxj3BMUER/qskRTE3a7H06hV5LBr7IdHhUh5bgVa4OE=;
        b=SWIZCniKqBnPuK4hL3sY0DyRCZ4GEgUnDcQRmuUiBnbIWGVj2vV5N96YRw3CjQRWjn5E+k
        DoXh0nUk+qNPWY8nejNrbQ/oZtQFT7znSZIQXUi4VtRotEAzsm08Yc9Pj0wZBGlFGFOUiX
        sQxVyeeE6Loq+6EmM7PqwjZHTd5YtDA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-551DicF6O7y-xC8TnMoQ7Q-1; Wed, 06 May 2020 16:30:56 -0400
X-MC-Unique: 551DicF6O7y-xC8TnMoQ7Q-1
Received: by mail-wm1-f69.google.com with SMTP id v23so1430735wmj.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mxj3BMUER/qskRTE3a7H06hV5LBr7IdHhUh5bgVa4OE=;
        b=e2viDxVulos57zLqYTfa++x8uFX/bnx4vQDFk4QNzDgYs9QYI1imP+GOnVCgTD1/Ug
         mUmaxlQcgus3ubqqBUNjF5uUATY5bPCNnUxn03HdxvSV9QJ6BLEeHY7OwPs0A4I07EdP
         CTxpdrsL0EePEGwnPhcZ8Hb1K4tGqZ0H1BKOn0SyrKRrUWAm6bS+ouveTsaVxbz8C/Rf
         /DiTzeQHmCg7rYMYJpdVA6knmDR8QGDtYVemNzZAnAEokLhgrZJKeRBYcSd7770m4O2R
         m4uoCOFjmWTI8bzTYt7TFFR0QfC1tmI5CUZTnEu9FRt696Sj5tGRFKKEy7Tkqd84m/wL
         eqOg==
X-Gm-Message-State: AGi0PuabSoTHy+wh11q0gbWEO39EOC+xUfvmpRCCg9yRGxrAo9QmXXod
        Cv+AhF38aPfKIed8X8PkZSrQcvhvVyLhChqHhWiRq44TnLiwDQBySpKUsq7rmuR7AovQdJyCWe+
        ofAnEn0QoBUjg1zPO
X-Received: by 2002:a5d:650c:: with SMTP id x12mr10917403wru.425.1588797055102;
        Wed, 06 May 2020 13:30:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJMoBt/7ReQsSc5SDcms1E5ukat//yBhg8yRBv8cixGfRK83FSjm3HKIwLitzMGU0a+XqRMlg==
X-Received: by 2002:a5d:650c:: with SMTP id x12mr10917379wru.425.1588797054926;
        Wed, 06 May 2020 13:30:54 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id 92sm4414502wrm.71.2020.05.06.13.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:30:54 -0700 (PDT)
Date:   Wed, 6 May 2020 16:30:51 -0400
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
Subject: Re: [PATCH net-next 19/33] tun: add XDP frame size
Message-ID: <20200506163031-mutt-send-email-mst@kernel.org>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757173758.1370371.17195673814740376146.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158757173758.1370371.17195673814740376146.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 06:08:57PM +0200, Jesper Dangaard Brouer wrote:
> The tun driver have two code paths for running XDP (bpf_prog_run_xdp).
> In both cases 'buflen' contains enough tailroom for skb_shared_info.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

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

