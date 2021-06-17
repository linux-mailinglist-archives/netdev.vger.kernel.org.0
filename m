Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9293AA95F
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 05:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFQDKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 23:10:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25641 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230075AbhFQDKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 23:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623899324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VJESmDxrRmYGcRizjKpgmpvFUh6G3YJgeVVQgOoxENU=;
        b=Rsw5/FR4xG/eiCQGqLdBJnlyKyaSf+wIxKhjZZhw3KhxOTdT/Ya6q6XryvnvAT6L1yPYys
        rDGDvRHRaDJ9tY8J1EbtK80HgK/Atb395NkuR0mRO+dxzB4uKIiPViBr/IdeGWWdrZ1eec
        CAa2AZ3aKJDFzvkoH8G7zCLNyAvX1LY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Lo3VILxYNnSBO2w7mDF4Ow-1; Wed, 16 Jun 2021 23:08:43 -0400
X-MC-Unique: Lo3VILxYNnSBO2w7mDF4Ow-1
Received: by mail-pg1-f198.google.com with SMTP id 4-20020a6315440000b029022154a87a57so2833205pgv.13
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 20:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VJESmDxrRmYGcRizjKpgmpvFUh6G3YJgeVVQgOoxENU=;
        b=mOZNLMGRLb+pWL4r1vBqBr5TGwqGNO4+s6pnfBREPsnYT+c0QP3wVQikDMv1M72zTb
         0U4iYFzlf92rKx2PBobHyslmtOPs+1+nXXmUpX6lmTd/jxPdfZStmv0zBawuoPQ2mxV0
         Coy9x3vgSMy5vNRCyky00/lp0bZimrtw7WcUYZnLfLlI0DXPHmVLo5wfZAxcs94j1W7E
         EFC4C53ljL8Eq64PSs15bmoYGijr/UHmEInLXS2krsQHV1VpudkuVk3rPP/R2ZwpmQvW
         1PkGD2T7FvsQXJpgR6rKBX+Xm03Y68IFzdvr/mG/uH458HcBkq41eItWw51HnelNqxT1
         sbgQ==
X-Gm-Message-State: AOAM531ueuaSX5hlLq+T7YRGJmrf1TN+VFs5rLElz72tYOyHk5aX0WRC
        vKbGWklY/IB6A0C8JK8c/OkNQ5t+v9ixcQ5992SP4grOC5xsqsAi3f60i7w7s/IuZIfFn6Vljk7
        r+pKP7WEeCXgoEbrX
X-Received: by 2002:a17:90a:5b0a:: with SMTP id o10mr14302853pji.143.1623899322058;
        Wed, 16 Jun 2021 20:08:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwpr+9g9pKcJlYbxlBvU6PgfqtM+wo9N90186PBpdb1zN0LxLJ/yCWe9p5eHsoSE5dmxkclqQ==
X-Received: by 2002:a17:90a:5b0a:: with SMTP id o10mr14302828pji.143.1623899321837;
        Wed, 16 Jun 2021 20:08:41 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ls17sm6381794pjb.56.2021.06.16.20.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 20:08:41 -0700 (PDT)
Subject: Re: [PATCH net-next v5 15/15] virtio-net: xsk zero copy xmit kick by
 threshold
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210610082209.91487-1-xuanzhuo@linux.alibaba.com>
 <20210610082209.91487-16-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7dbdb429-edda-9f33-fbfa-bb128c5e3eca@redhat.com>
Date:   Thu, 17 Jun 2021 11:08:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210610082209.91487-16-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/6/10 ÏÂÎç4:22, Xuan Zhuo Ð´µÀ:
> After testing, the performance of calling kick every time is not stable.
> And if all the packets are sent and kicked again, the performance is not
> good. So add a module parameter to specify how many packets are sent to
> call a kick.
>
> 8 is a relatively stable value with the best performance.
>
> Here is the pps of the test of xsk_kick_thr under different values (from
> 1 to 64).
>
> thr  PPS             thr PPS             thr PPS
> 1    2924116.74247 | 23  3683263.04348 | 45  2777907.22963
> 2    3441010.57191 | 24  3078880.13043 | 46  2781376.21739
> 3    3636728.72378 | 25  2859219.57656 | 47  2777271.91304
> 4    3637518.61468 | 26  2851557.9593  | 48  2800320.56575
> 5    3651738.16251 | 27  2834783.54408 | 49  2813039.87599
> 6    3652176.69231 | 28  2847012.41472 | 50  3445143.01839
> 7    3665415.80602 | 29  2860633.91304 | 51  3666918.01281
> 8    3665045.16555 | 30  2857903.5786  | 52  3059929.2709


I wonder what's the number for the case of non zc xsk?

Thanks


> 9    3671023.2401  | 31  2835589.98963 | 53  2831515.21739
> 10   3669532.23274 | 32  2862827.88706 | 54  3451804.07204
> 11   3666160.37749 | 33  2871855.96696 | 55  3654975.92385
> 12   3674951.44813 | 34  3434456.44816 | 56  3676198.3188
> 13   3667447.57331 | 35  3656918.54177 | 57  3684740.85619
> 14   3018846.0503  | 36  3596921.16722 | 58  3060958.8594
> 15   2792773.84505 | 37  3603460.63903 | 59  2828874.57191
> 16   3430596.3602  | 38  3595410.87666 | 60  3459926.11027
> 17   3660525.85806 | 39  3604250.17819 | 61  3685444.47599
> 18   3045627.69054 | 40  3596542.28428 | 62  3049959.0809
> 19   2841542.94177 | 41  3600705.16054 | 63  2806280.04013
> 20   2830475.97348 | 42  3019833.71191 | 64  3448494.3913
> 21   2845655.55789 | 43  2752951.93264 |
> 22   3450389.84365 | 44  2753107.27164 |
>
> It can be found that when the value of xsk_kick_thr is relatively small,
> the performance is not good, and when its value is greater than 13, the
> performance will be more irregular and unstable. It looks similar from 3
> to 13, I chose 8 as the default value.
>
> The test environment is qemu + vhost-net. I modified vhost-net to drop
> the packets sent by vm directly, so that the cpu of vm can run higher.
> By default, the processes in the vm and the cpu of softirqd are too low,
> and there is no obvious difference in the test data.
>
> During the test, the cpu of softirq reached 100%. Each xsk_kick_thr was
> run for 300s, the pps of every second was recorded, and the average of
> the pps was finally taken. The vhost process cpu on the host has also
> reached 100%.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>   drivers/net/virtio/virtio_net.c |  1 +
>   drivers/net/virtio/xsk.c        | 18 ++++++++++++++++--
>   drivers/net/virtio/xsk.h        |  2 ++
>   3 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio/virtio_net.c b/drivers/net/virtio/virtio_net.c
> index 9503133e71f0..dfe509939b45 100644
> --- a/drivers/net/virtio/virtio_net.c
> +++ b/drivers/net/virtio/virtio_net.c
> @@ -14,6 +14,7 @@ static bool csum = true, gso = true, napi_tx = true;
>   module_param(csum, bool, 0444);
>   module_param(gso, bool, 0444);
>   module_param(napi_tx, bool, 0644);
> +module_param(xsk_kick_thr, int, 0644);
>   
>   /* FIXME: MTU in config. */
>   #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> diff --git a/drivers/net/virtio/xsk.c b/drivers/net/virtio/xsk.c
> index 3973c82d1ad2..2f3ba6ab4798 100644
> --- a/drivers/net/virtio/xsk.c
> +++ b/drivers/net/virtio/xsk.c
> @@ -5,6 +5,8 @@
>   
>   #include "virtio_net.h"
>   
> +int xsk_kick_thr = 8;
> +
>   static struct virtio_net_hdr_mrg_rxbuf xsk_hdr;
>   
>   static struct virtnet_xsk_ctx *virtnet_xsk_ctx_get(struct virtnet_xsk_ctx_head *head)
> @@ -455,6 +457,7 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
>   	struct xdp_desc desc;
>   	int err, packet = 0;
>   	int ret = -EAGAIN;
> +	int need_kick = 0;
>   
>   	while (budget-- > 0) {
>   		if (sq->vq->num_free < 2 + MAX_SKB_FRAGS) {
> @@ -475,11 +478,22 @@ static int virtnet_xsk_xmit_batch(struct send_queue *sq,
>   		}
>   
>   		++packet;
> +		++need_kick;
> +		if (need_kick > xsk_kick_thr) {
> +			if (virtqueue_kick_prepare(sq->vq) &&
> +			    virtqueue_notify(sq->vq))
> +				++stats->kicks;
> +
> +			need_kick = 0;
> +		}
>   	}
>   
>   	if (packet) {
> -		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq))
> -			++stats->kicks;
> +		if (need_kick) {
> +			if (virtqueue_kick_prepare(sq->vq) &&
> +			    virtqueue_notify(sq->vq))
> +				++stats->kicks;
> +		}
>   
>   		*done += packet;
>   		stats->xdp_tx += packet;
> diff --git a/drivers/net/virtio/xsk.h b/drivers/net/virtio/xsk.h
> index fe22cf78d505..4f0f4f9cf23b 100644
> --- a/drivers/net/virtio/xsk.h
> +++ b/drivers/net/virtio/xsk.h
> @@ -7,6 +7,8 @@
>   
>   #define VIRTNET_XSK_BUFF_CTX  ((void *)(unsigned long)~0L)
>   
> +extern int xsk_kick_thr;
> +
>   /* When xsk disable, under normal circumstances, the network card must reclaim
>    * all the memory that has been sent and the memory added to the rq queue by
>    * destroying the queue.

