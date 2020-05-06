Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265961C7B52
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEFUdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:33:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726093AbgEFUdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:33:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588797216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QKrWfoQgXcZFPy5pzZGV3ew40nkonHSC1M2c16vq6R8=;
        b=ak7T3xuPJWLg6KhLRmYgdFpIjLwyvo4mAJ8tUyb0WGXLwXDpKjDiE6+EpiVjqHmK5PKbOC
        G1ebjDUglsvlWUkrLCOTo4aDkJIp1dR90w/mUJXRA7nP67PiWLiwbv/ZHVyCq7Vduj1WJd
        P7nR1FgASlIsK9qD6znPP+WfbwxXfmg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-cAWnjdk9N_iDYtjO6nfaAg-1; Wed, 06 May 2020 16:33:34 -0400
X-MC-Unique: cAWnjdk9N_iDYtjO6nfaAg-1
Received: by mail-wr1-f69.google.com with SMTP id e5so1908830wrs.23
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 13:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QKrWfoQgXcZFPy5pzZGV3ew40nkonHSC1M2c16vq6R8=;
        b=djuwhldxdQ9CLKYonmLQqnKqi+9OwonZFFhu/1virNWSMo8shFL809WVVnrJ+rx5DX
         s/5OFDPHSaJf1hD9ckYidj5sh7s7IqQwk0PgGW+fsTp0rUgtlkl8w/IgYLacIPVvPFLp
         0u0VZT1EA8uLXw07/Sawl8B2OyEiQINjdvXpHfVPk1UfxpZzOLE1L13T0brhfbVX2Q5X
         16hkQeGT3ZgrWTZmP+ee7LsP2KHyXupM3c0BWf6cOT50y3LVBYibgCkG3WDQScmaueVn
         8m/6qmlGMKThyNYCCzUlqhSKC7KYcL9q8U4ruLgE7DQqOXbXaxwaR6UFEnTF/VdKQ8xv
         xkbQ==
X-Gm-Message-State: AGi0PuZ91gVTIsGuXpN/rHL0fnFW+dHe1Pnt42SQ1hhM63CA+wYbSzj3
        gU8cOFHxAIVXq+HGNy4C2XsheY3KQM+KWsrpsrUU3ZV6GQqZ8ZaZY2t/Pmdhpqt9meOCPMRhGr0
        Nv3FIpFnT5CxdYQaH
X-Received: by 2002:a5d:5001:: with SMTP id e1mr11919351wrt.27.1588797213512;
        Wed, 06 May 2020 13:33:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypJN7Gcycn/d6Zc0I6qlNFQBgDpZNghG7fqqIn6zWJizbeAuds5qjZXlzXn7dS6crItjEZ31TA==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr11919332wrt.27.1588797213298;
        Wed, 06 May 2020 13:33:33 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id w15sm4292697wrl.73.2020.05.06.13.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 13:33:32 -0700 (PDT)
Date:   Wed, 6 May 2020 16:33:29 -0400
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
Subject: Re: [PATCH net-next v2 20/33] vhost_net: also populate XDP frame size
Message-ID: <20200506163322-mutt-send-email-mst@kernel.org>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824572308.2172139.1144470511173466125.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158824572308.2172139.1144470511173466125.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 01:22:03PM +0200, Jesper Dangaard Brouer wrote:
> In vhost_net_build_xdp() the 'buf' that gets queued via an xdp_buff
> have embedded a struct tun_xdp_hdr (located at xdp->data_hard_start)
> which contains the buffer length 'buflen' (with tailroom for
> skb_shared_info). Also storing this buflen in xdp->frame_sz, does not
> obsolete struct tun_xdp_hdr, as it also contains a struct
> virtio_net_hdr with other information.
> 
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/net.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 2927f02cc7e1..516519dcc8ff 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -747,6 +747,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
>  	xdp->data = buf + pad;
>  	xdp->data_end = xdp->data + len;
>  	hdr->buflen = buflen;
> +	xdp->frame_sz = buflen;
>  
>  	--net->refcnt_bias;
>  	alloc_frag->offset += buflen;
> 
> 

