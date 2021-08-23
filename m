Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C843F5078
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 20:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhHWSjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 14:39:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230083AbhHWSi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 14:38:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629743896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aGeRK61kiXK1K05tade+IDVRPgDSs9Mu5QBfh6lgm+Q=;
        b=J63wmgEVzOSL9tebD90mu8hWveNUBKuX8aNtol/sLDzOmkt7fk9BwdACTpjBjNcJv4m0Qi
        ZXr3o1jL3Xh83jQBGkA/b//zChgpBi5M/E0ub6yOQE4yX/ZxDqfxkk+0e+9RSCE6nFgw4K
        oGolToe2MzzkV4j474xKhdP4KCBUSwI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-Jf4iHs7jM7WXv0I_UPT42w-1; Mon, 23 Aug 2021 14:38:15 -0400
X-MC-Unique: Jf4iHs7jM7WXv0I_UPT42w-1
Received: by mail-wm1-f72.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so48059wml.5
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 11:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aGeRK61kiXK1K05tade+IDVRPgDSs9Mu5QBfh6lgm+Q=;
        b=gYEDWEpw9L/uJFXArxqpVifzQ8MgNCfBZtpX2EhI4rzIcTbPmUmJOiYX5rnLxe1Asc
         4kHYBHK4ocz1jb+pBt4yqqre2eO2NK+yYJzfoeSdh4KWblx4dKiyeC4vx9bB/DTH7Qe/
         eTunBUOkMWqpHc77CnO7V7x+3f5fVsxXIpxOjqPpKQGeMKDNBhOgWy9/cj0onkwXxoHn
         OlR9w3SVeHsSJxb5IUmJ/2oEAQwTeVrvBAFndmULAJpLYHG89fx9j3uQkuhiW6zHQH8q
         1Op8sdIpwIztRgETvl8Jd4RsXhQlVEpLDmTPbNNFAOh+km9Fe7CFO1c+sv1TyUV7YZHF
         praQ==
X-Gm-Message-State: AOAM5332rctrlqXKIn155w+9skEloaG/WSDKDwhMvHq54uc+/CGFanWM
        MINPlh/TNzZEy9BMT/wGYmOFWJg2tpBpFm7Y0XQdce/yE0q9wwRdlK/VZIy9sRriuxn3f4Zllo9
        D5lnnvNh8uo9tb27d
X-Received: by 2002:a05:600c:4656:: with SMTP id n22mr13403722wmo.74.1629743894356;
        Mon, 23 Aug 2021 11:38:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx30LR2fj61cxgWt2sNK/230aqlYfdRAsV6ILtvVucKEAcOOWdUh1RddfLWL/j+m/rLgt1jrQ==
X-Received: by 2002:a05:600c:4656:: with SMTP id n22mr13403712wmo.74.1629743894249;
        Mon, 23 Aug 2021 11:38:14 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id l2sm13936162wme.28.2021.08.23.11.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 11:38:13 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com
Subject: Re: [PATCH net-next] netdevice: move xdp_rxq within netdev_rx_queue
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
References: <20210823180135.1153608-1-kuba@kernel.org>
Message-ID: <b2cd6882-4e31-18f6-315b-7b0937b8942c@redhat.com>
Date:   Mon, 23 Aug 2021 20:38:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210823180135.1153608-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/08/2021 20.01, Jakub Kicinski wrote:
> Both struct netdev_rx_queue and struct xdp_rxq_info are cacheline
> aligned. This causes extra padding before and after the xdp_rxq
> member. Move the member upfront, so that it's naturally aligned.
> 
> Before:
> 	/* size: 256, cachelines: 4, members: 6 */
> 	/* sum members: 160, holes: 1, sum holes: 40 */
> 	/* padding: 56 */
> 	/* paddings: 1, sum paddings: 36 */
> 	/* forced alignments: 1, forced holes: 1, sum forced holes: 40 */
> 
> After:
> 	/* size: 192, cachelines: 3, members: 6 */
> 	/* padding: 32 */
> 	/* paddings: 1, sum paddings: 36 */
> 	/* forced alignments: 1 */
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/linux/netdevice.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)


LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 9579942ac2fd..514ec3a0507c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -722,13 +722,13 @@ bool rps_may_expire_flow(struct net_device *dev, u16 rxq_index, u32 flow_id,
>   
>   /* This structure contains an instance of an RX queue. */
>   struct netdev_rx_queue {
> +	struct xdp_rxq_info		xdp_rxq;
>   #ifdef CONFIG_RPS
>   	struct rps_map __rcu		*rps_map;
>   	struct rps_dev_flow_table __rcu	*rps_flow_table;
>   #endif
>   	struct kobject			kobj;
>   	struct net_device		*dev;
> -	struct xdp_rxq_info		xdp_rxq;
>   #ifdef CONFIG_XDP_SOCKETS
>   	struct xsk_buff_pool            *pool;
>   #endif
> 

