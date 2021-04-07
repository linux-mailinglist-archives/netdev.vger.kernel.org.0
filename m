Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588BD3572E0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 19:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354698AbhDGRNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 13:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbhDGRNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 13:13:50 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C93C06175F
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 10:13:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u11so6345211wrp.4
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=spct60znTNGYOyR35NREia36IJTXUy0OONnZZ90mbMg=;
        b=fcM6235XPcsSY9CAcuM0EnAr4ev5sEK6pprD4EETY0o64yvRFeJMAIHa/iRBfJMxMs
         nTAK+BABT9ahSQnyr/sDvUsDNltjNEniTSgkgxYOwPDyWR9nc8LjrrdnTcMsqecdujBR
         V7DYn4cgyo0ohcEjp2uznICvCnD/K88zY9grlZ6Y/xecUbdcihhDKLDFW6HL2gsAiyq5
         i5wgN9S/5IX2cVqwNzCsLjfTWdWfs6w6uBOV0JDMYIMSaVRKUtvsyZjwyq4P0H9Igt/J
         2FAvYnBa8lctPeoS9d0Ufhx0v8H/dxuVjo7BDRL78XaEBx2UdRgxvRmcZ+ioRb/WcEQ9
         a5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=spct60znTNGYOyR35NREia36IJTXUy0OONnZZ90mbMg=;
        b=cbF10FHOlN93V+68iQIOdK9WdGpiRacuKnqmBGQ6LHrZo+JHQfT9himCVHDG8ib1kw
         OWj0YL9585X97mzEj6x7FerCev8inl3k8qn5kkfDUTX4bEH6kZ/DOelgKEJ04ftPJAdl
         aBr5Ajstpim62OkHTASIO/Ah+qKStSsuu1nt8aHkwGzoxi+N+zqXpajjO7B77BZkQaL7
         vKQdalPegIGFlCrEpUMPFaojXG8E4g62oIn5Bp1RvEIQlpyVnYGh4WyLc/d8eYxeSF2G
         4ICe3mg9YRvy4dUky63XU/cvJ+rH2hib2ON8CnT34LDRiYAHzzzE5QT3yUTghnIACsh3
         YHNA==
X-Gm-Message-State: AOAM533aN7ia7Qf6Mj7eFh4V8bgaexrCSQk45Hxe2c+zmb89+qkKopjP
        IGHqpelsyWjPgeGH2WfAwrjnrDEzJJI=
X-Google-Smtp-Source: ABdhPJyneJDvCbYOpE2sWkEPumyYrEh/x7yZCzB1QjxxpxCzw4omtqCcAT2YPDwOT+OXpsUVELc9Ow==
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr5572670wrm.39.1617815617496;
        Wed, 07 Apr 2021 10:13:37 -0700 (PDT)
Received: from [192.168.1.101] ([37.172.15.210])
        by smtp.gmail.com with ESMTPSA id c16sm49403852wrs.81.2021.04.07.10.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 10:13:37 -0700 (PDT)
Subject: Re: [PATCH net-next] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20210407054949.98211-1-xuanzhuo@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <84995a39-c588-3aa0-98ff-f16087dbdff0@gmail.com>
Date:   Wed, 7 Apr 2021 19:13:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210407054949.98211-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/7/21 7:49 AM, Xuan Zhuo wrote:
> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
> can use build_skb to create skb directly. No need to alloc for
> additional space. And it can save a 'frags slot', which is very friendly
> to GRO.
> 
> Here, if the payload of the received package is too small (less than
> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
> napi_alloc_skb. So we can reuse these pages.
> 
> Testing Machine:
>     The four queues of the network card are bound to the cpu1.
> 
> Test command:
>     for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
> 
> The size of the udp package is 1000, so in the case of this patch, there
> will always be enough tailroom to use build_skb. The sent udp packet
> will be discarded because there is no port to receive it. The irqsoftd
> of the machine is 100%, we observe the received quantity displayed by
> sar -n DEV 1:
> 
> no build_skb:  956864.00 rxpck/s
> build_skb:    1158465.00 rxpck/s
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---

This will generate merge conflicts.

Please wait that commit 0f6925b3e8da ("virtio_net: Do not pull payload in skb->head") has reached net-next.

Also are we sure pages are always writable, and not shared ?


