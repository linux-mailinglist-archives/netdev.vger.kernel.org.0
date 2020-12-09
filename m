Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126372D3814
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgLIBGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgLIBGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 20:06:45 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2AEC0613D6
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 17:06:05 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id d27so710001oic.0
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 17:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l8AQDCReSWYO7mGJNo1DnhG491pzv61j6dUQU/cFOe8=;
        b=M64FGG+eRC1O2Tlg+MJPE5Ke58QKCfq5qXZA053nxDrcgrYnUUu62wiSA55dn1ceK/
         WnrqY/D4aMjsGKjTXEuJRpfpyldvTipgNmSZdGg6BaxNCLcjD2IBPPWeNjuz8e3Zs3fV
         /CxsLKl5WbDL6QWch2zWoC49ITvxcgWvfGpPsSswP7thCVzduUUHvvACHcBuB9FJJCdb
         W9Es7VzatAiGBSch/N2LgWjzKsknfEOWBBgMPMj0It+38MXpE+susyLlJLzJmv/nRwLe
         QwSw2rjoJKCDU85QEGyZ1RAzLzMNGug1rqEFYxWBWBf9sWhfCG6y08JpUhcSe6kUxPUh
         nrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8AQDCReSWYO7mGJNo1DnhG491pzv61j6dUQU/cFOe8=;
        b=QH2FLlvrgZAW1ThzVkX9HgAoxVd+sC7ZsjHOKW/NbHPzEDEW6qquylVshmstqCQ4Er
         xEYorcSvOMRw8ygMmilvLX465x91tX6tRtpRxmDN3P/iC5z4GQuzIQM4mmV0YzDJMIJN
         GxadEVbEfJq3K8Cz+DY+NyFLTOOBZCB8wHctZfpht3glVUgixaMz0Oj3NYNQs8VUhWA3
         h9vmOoQJIlp8/Epv0Qo9v5NKCnAsrBvCrGfyfQKDAc7jU2xpDqT/EbJTRg7h+/ePTPsP
         CQQ5fEqwPxfqXtlnbIY7r3oodoiCeds5pAz4B2E8wHLjDbrbHuOVxuAp3heTHQbI+mz/
         ptWQ==
X-Gm-Message-State: AOAM530vDer1zlLh3LMxvVkxNLH/yLUDsWaIv66MZ8m1CFUG9lN7/Ld/
        K7SKrJ7Jqa/xKmy59bDGqFE=
X-Google-Smtp-Source: ABdhPJz1/hcIshzh1zSLKvSeT9W/cjpORYGMBgCrgYLiqTLae6n3p/fmlXuu6/5sxkiCAPOasVrH5g==
X-Received: by 2002:aca:bc03:: with SMTP id m3mr118783oif.106.1607475965086;
        Tue, 08 Dec 2020 17:06:05 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:64fc:adeb:84f9:fa62])
        by smtp.googlemail.com with ESMTPSA id u15sm3693oiv.28.2020.12.08.17.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 17:06:04 -0800 (PST)
Subject: Re: [PATCH v1 net-next 04/15] net/tls: expose get_netdev_for_sock
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-5-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f38e30af-f4c0-9adc-259a-5e54214e16b1@gmail.com>
Date:   Tue, 8 Dec 2020 18:06:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207210649.19194-5-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 2:06 PM, Boris Pismenny wrote:
> get_netdev_for_sock is a utility that is used to obtain
> the net_device structure from a connected socket.
> 
> Later patches will use this for nvme-tcp DDP and DDP CRC offloads.
> 
> Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  include/net/sock.h   | 17 +++++++++++++++++
>  net/tls/tls_device.c | 20 ++------------------
>  2 files changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 093b51719c69..a8f7393ea433 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -2711,4 +2711,21 @@ void sock_set_sndtimeo(struct sock *sk, s64 secs);
>  
>  int sock_bind_add(struct sock *sk, struct sockaddr *addr, int addr_len);
>  
> +/* Assume that the socket is already connected */
> +static inline struct net_device *get_netdev_for_sock(struct sock *sk, bool hold)
> +{
> +	struct dst_entry *dst = sk_dst_get(sk);
> +	struct net_device *netdev = NULL;
> +
> +	if (likely(dst)) {
> +		netdev = dst->dev;

I noticed you grab this once when the offload is configured. The dst
device could change - e.g., ECMP, routing changes. I'm guessing that
does not matter much for the use case - you are really wanting to
configure queues and zc buffers for a flow with the device; the netdev
is an easy gateway to get to it.

But, data center deployments tend to have redundant access points --
either multipath for L3 or bond for L2. For the latter, this offload
setup won't work - dst->dev will be the bond, the bond does not support
the offload, so user is out of luck.
