Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90461A5A0F
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 17:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbfIBPB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 11:01:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731725AbfIBPB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 11:01:57 -0400
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12E4D155DB
        for <netdev@vger.kernel.org>; Mon,  2 Sep 2019 15:01:57 +0000 (UTC)
Received: by mail-qt1-f197.google.com with SMTP id i19so15856919qtq.17
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 08:01:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3eUULgrjIJg0a0dnW4SKY8dVu/LzudzFut/uYLoCkM0=;
        b=O3iXFgTPBf1Ir92Cr0BcLvoPChE3rpNKZlaguATmkJ7GJZ0s0NDTgZmn+OrJErbRb/
         4AaO2DXwerlAcFgzRUDHudShNOiP+24ANIBfYV7z7ycxTHfcGt8BRoVnasFsajEBH8qi
         OeVCdacOQRTKFy28tdNNEv9IkNJuPo+euU6UBwuyI5+fRhogZJWLcbS0riTCBH3C3iYM
         5fOEhtalWBLVoiUwSpv02RsUZO/0tKfAHb2/wNysMfYg090PePGS54NBQa4TiILm6+Az
         Hb5+BdogKWiN4GuECFJVYWEP3vyPxz3dVOjl9JyGiPNgZLZ3ca+tVlIGQrAcvfw0OKEX
         VmqA==
X-Gm-Message-State: APjAAAW9WsGxpTH5oOBzbSat0fnENSegdvtVVnbgf7IXtpac8u6oGScz
        KH3ftmdRnT1qH4W2ebSDTcuRjCyhV9thFWqP8kYzGc/VyGLZAJ60EgOmHVglZumvi+84Ch2/dnI
        D+j00sSygDWGRODHR
X-Received: by 2002:ac8:750e:: with SMTP id u14mr28909664qtq.282.1567436516418;
        Mon, 02 Sep 2019 08:01:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzukZkbHkn1xgGj19iRwoWTZ0EUi0+QeIBA4njsNuROpWrZ/97Kw7ZdMd2ZPPImX2/1Fxx4Fg==
X-Received: by 2002:ac8:750e:: with SMTP id u14mr28909631qtq.282.1567436516228;
        Mon, 02 Sep 2019 08:01:56 -0700 (PDT)
Received: from redhat.com (bzq-79-180-62-110.red.bezeqint.net. [79.180.62.110])
        by smtp.gmail.com with ESMTPSA id o11sm4589103qkm.105.2019.09.02.08.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 08:01:55 -0700 (PDT)
Date:   Mon, 2 Sep 2019 11:01:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     ? jiang <jiangkidd@hotmail.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>
Subject: Re: [PATCH v3] virtio-net: lower min ring num_free for efficiency
Message-ID: <20190902110038-mutt-send-email-mst@kernel.org>
References: <BYAPR14MB32059DD9439280B66B532351A6AB0@BYAPR14MB3205.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR14MB32059DD9439280B66B532351A6AB0@BYAPR14MB3205.namprd14.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 02:51:23AM +0000, ? jiang wrote:
> This change lowers ring buffer reclaim threshold from 1/2*queue to budget
> for better performance. According to our test with qemu + dpdk, packet
> dropping happens when the guest is not able to provide free buffer in
> avail ring timely with default 1/2*queue. The value in the patch has been
> tested and does show better performance.
> 
> Test setup: iperf3 to generate packets to guest (total 30mins, pps 400k, UDP)
> avg packets drop before: 2842
> avg packets drop after: 360(-87.3%)
> 
> Further, current code suffers from a starvation problem: the amount of
> work done by try_fill_recv is not bounded by the budget parameter, thus
> (with large queues) once in a while userspace gets blocked for a long
> time while queue is being refilled. Trigger refills earlier to make sure
> the amount of work to do is limited.
> 
> Signed-off-by: jiangkidd <jiangkidd@hotmail.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>


Dave, could you merge this please?

Either net or net-next at your discretion.

> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0d4115c9e20b..bc08be7925eb 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1331,7 +1331,7 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  		}
>  	}
>  
> -	if (rq->vq->num_free > virtqueue_get_vring_size(rq->vq) / 2) {
> +	if (rq->vq->num_free > min((unsigned int)budget, virtqueue_get_vring_size(rq->vq)) / 2) {
>  		if (!try_fill_recv(vi, rq, GFP_ATOMIC))
>  			schedule_delayed_work(&vi->refill, 0);
>  	}
> -- 
> 2.11.0
