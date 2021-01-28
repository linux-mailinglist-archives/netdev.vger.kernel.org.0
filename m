Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02820307976
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 16:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231159AbhA1PS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 10:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231390AbhA1PSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 10:18:14 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F55BC0613D6;
        Thu, 28 Jan 2021 07:17:34 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id a20so4031276pjs.1;
        Thu, 28 Jan 2021 07:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Nye8p/WF2NWdxjWCcs2X/vHGUhlnVaM/5kQ/1QbWn4=;
        b=bCsqzeuAGuApSZxxJAxr75qJ6gUgKRhrPGQz7yXrp/xRnXsoWxybscn4vh5QrsNaCz
         WGvjTsbc0j/TCCqYassW1O3Aj4UA9+6wUte1CheKYLbln16eYunXmiS6njtyf53J4z8x
         fy2Bs1YR/wQNpMc6SRoarSzGbsxL/o4EyiDDfDpCOPtibpm1yyQiay56ZI0+6Z534X9F
         tER6yltuLGG/ThN9I/waSYyu+DAkZzvdPtTINvjH8pzC8Xzh2J4hVT3phFO2gIXZ74gk
         Nmfq4df1X31bmJVBshpd66Y31NOpDpHa5GylyKb3a+fDroT9tkcmoE2PZ9Yb40Xa24St
         2oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Nye8p/WF2NWdxjWCcs2X/vHGUhlnVaM/5kQ/1QbWn4=;
        b=JhlQwU9jHcsI7s0phu/+hM/xmM5MoIH/mrA4q5RqSgh88imLRMtaxEQd0900ApM579
         nA6LzoB1nl/Wsw24zOeqHWxXV61TXPKQuxwH8ojmc6+ik+XllMsgjyrxUGgP7ZIG83gn
         AxRjqna1nYNLmU5UsGHHuICrSjWO7Y/wKrCU/zVUyVH4QN4bzg0nYi6vsITqJ0HNW+Du
         VxZawFBpq2poDnKUILGo5PXz9vGFnTwjRGS5+vfBZ3DWmwv25mjC1q2zeb0C4aYRTNg9
         MJIzskUv+5DHWy+VvZyPv8bPhlnU/rN3lIMKIeXnbm7bHwWJgEzJew4GONjVR6b7Q6rz
         2cXg==
X-Gm-Message-State: AOAM532+qMRbtz34zUw7XWsdLRzEkrzKrxbMvGfTvHSbeMr1O/zS+s5Z
        GMHMKoKMKTCrcjF32L/UStw=
X-Google-Smtp-Source: ABdhPJwsZmg60NuhdyVTl0ndOhEzxWR2wvZ9Xe6KyHOOKqOBHUgMZIrAS9dWYtala5iaIw2DUWdPgg==
X-Received: by 2002:a17:902:b213:b029:db:3a3e:d8ad with SMTP id t19-20020a170902b213b02900db3a3ed8admr47121plr.73.1611847053795;
        Thu, 28 Jan 2021 07:17:33 -0800 (PST)
Received: from [192.168.1.18] (i121-115-229-245.s42.a013.ap.plala.or.jp. [121.115.229.245])
        by smtp.googlemail.com with ESMTPSA id ne6sm5330632pjb.44.2021.01.28.07.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 07:17:33 -0800 (PST)
Subject: Re: [PATCH bpf-next 1/3] net: veth: introduce bulking for XDP_PASS
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, toke@redhat.com
References: <cover.1611685778.git.lorenzo@kernel.org>
 <adca75284e30320e9d692d618a6349319d9340f3.1611685778.git.lorenzo@kernel.org>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <de16aab2-58a5-dd0b-1577-4fa04a6806ce@gmail.com>
Date:   Fri, 29 Jan 2021 00:17:27 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <adca75284e30320e9d692d618a6349319d9340f3.1611685778.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/01/27 3:41, Lorenzo Bianconi wrote:
> Introduce bulking support for XDP_PASS verdict forwarding skbs to
> the networking stack
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   drivers/net/veth.c | 43 ++++++++++++++++++++++++++-----------------
>   1 file changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 6e03b619c93c..23137d9966da 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -35,6 +35,7 @@
>   #define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
>   
>   #define VETH_XDP_TX_BULK_SIZE	16
> +#define VETH_XDP_BATCH		8
>   
>   struct veth_stats {
>   	u64	rx_drops;
> @@ -787,27 +788,35 @@ static int veth_xdp_rcv(struct veth_rq *rq, int budget,
>   	int i, done = 0;
>   
>   	for (i = 0; i < budget; i++) {
> -		void *ptr = __ptr_ring_consume(&rq->xdp_ring);
> -		struct sk_buff *skb;
> +		void *frames[VETH_XDP_BATCH];
> +		void *skbs[VETH_XDP_BATCH];
> +		int i, n_frame, n_skb = 0;

'i' is a shadowed variable. I think this may be confusing.

>   
> -		if (!ptr)
> +		n_frame = __ptr_ring_consume_batched(&rq->xdp_ring, frames,
> +						     VETH_XDP_BATCH);

This apparently exceeds the budget.
This will process budget*VETH_XDP_BATCH packets at most.
(You are probably aware of this because you return 'i' instead of 'done'?)

Also I'm not sure if we need to introduce __ptr_ring_consume_batched() here.
The function just does __ptr_ring_consume() n times.

IIUC Your final code looks like this:

for (budget) {
	n_frame = __ptr_ring_consume_batched(VETH_XDP_BATCH);
	for (n_frame) {
		if (frame is XDP)
			xdpf[n_xdpf++] = to_xdp(frame);
		else
			skbs[n_skb++] = frame;
	}

	if (n_xdpf)
		veth_xdp_rcv_batch(xdpf);

	for (n_skb) {
		skb = veth_xdp_rcv_skb(skbs[i]);
		napi_gro_receive(skb);
	}
}

Your code processes VETH_XDP_BATCH packets at a time no matter whether each of them 
is xdp_frame or skb, but I think you actually want to process VETH_XDP_BATCH 
xdp_frames at a time?
Then, why not doing like this?

for (budget) {
	ptr = __ptr_ring_consume();
	if (ptr is XDP) {
		if (n_xdpf >= VETH_XDP_BATCH) {
			veth_xdp_rcv_batch(xdpf);
			n_xdpf = 0;
		}
		xdpf[n_xdpf++] = to_xdp(ptr);
	} else {
		skb = veth_xdp_rcv_skb(ptr);
		napi_gro_receive(skb);
	}
}
if (n_xdpf)
	veth_xdp_rcv_batch(xdpf);

Toshiaki Makita
