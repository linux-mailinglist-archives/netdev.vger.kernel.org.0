Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7C39B05C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 04:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFDCal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 22:30:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhFDCai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 22:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622773733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4FEeFH/pQALtmPWyCOn3tMvLw70W3gs+V22pPRCgrw=;
        b=WUeOSinv+Hheacs/ulPKQDu6DB3JqTvYcn+bEvy7dY6gjFUZzFSeydfA/dkYPODUl8Hd3H
        pQlHzxG2fJC8BB1/P4cq8qxJUVXvRi3kyQRMv47tHJ/QfFObhOz+6fS8gX/x1esw0xsVF/
        mwzyF/AWUr4JOGfEYbXJ4TpkVYJPVIU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-S1fd-MkSN1qVHGPInZN3YA-1; Thu, 03 Jun 2021 22:28:52 -0400
X-MC-Unique: S1fd-MkSN1qVHGPInZN3YA-1
Received: by mail-pg1-f197.google.com with SMTP id k9-20020a63d1090000b029021091ebb84cso5089804pgg.3
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 19:28:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=W4FEeFH/pQALtmPWyCOn3tMvLw70W3gs+V22pPRCgrw=;
        b=pBQwDX5ogLuKbzxH8zyXewTuqeNS/P5iTMMjC2/x5v5ILdVpFPlaE3U2a6fLxyGgQQ
         5QviJBf0ZzGomix4r7abpc3iWULMvBHX2eyN6so/U1RGiM6nM/cM34iUcpDLQdOsrLE1
         +imXZHBl4jVC/qhn3FvpGEL/CW/Os71Dudr1FL+bjhUMrm6wm3CWDhfE/GNeHAEBa3UU
         v4UCVLzCVnoSNg4ZQwuqn1IwoemoPM+8ZhBPjdavOVxVpK/HdkOTRvgdunDY632PwAFu
         i5Tv+y8+dHouOZ6ZuPbAjZ/w7Y3cKwsJ64bVI3JhwXjzLIFcryeaum3UxfJhXaM89r4C
         oLwQ==
X-Gm-Message-State: AOAM533py12doPkHNMNTi18A5QREoEKmPFeT2rJ+h02ka/Roa3CdbtUD
        UgnIFvffKckZzAhzDQGri9eV1nC0wc0Uyw1iKEePFeUDP+CRegDIBeeP1a4ANZJ7kMMevBYX2Ls
        +irSXRui1FJYwExZ6
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr2387040pjo.200.1622773730977;
        Thu, 03 Jun 2021 19:28:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7nIC7vCX27/pebah12gefchckRdwl+x2P/Rcym5m+MUU5qWKzxUck3QlQJYl+LYPsU17LGw==
X-Received: by 2002:a17:90a:8d82:: with SMTP id d2mr2387019pjo.200.1622773730666;
        Thu, 03 Jun 2021 19:28:50 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i8sm3247600pjs.54.2021.06.03.19.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 19:28:50 -0700 (PDT)
Subject: Re: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?Q?Corentin_No=c3=abl?= <corentin.noel@collabora.com>
References: <20210603170901.66504-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <231466df-adc1-79a9-6950-77c88e2783c2@redhat.com>
Date:   Fri, 4 Jun 2021 10:28:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210603170901.66504-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/4 上午1:09, Xuan Zhuo 写道:
> In virtio-net's large packet mode, there is a hole in the space behind
> buf.


before the buf actually or behind the vnet header?


>
>      hdr_padded_len - hdr_len
>
> We must take this into account when calculating tailroom.
>
> [   44.544385] skb_put.cold (net/core/skbuff.c:5254 (discriminator 1) net/core/skbuff.c:5252 (discriminator 1))
> [   44.544864] page_to_skb (drivers/net/virtio_net.c:485) [   44.545361] receive_buf (drivers/net/virtio_net.c:849 drivers/net/virtio_net.c:1131)
> [   44.545870] ? netif_receive_skb_list_internal (net/core/dev.c:5714)
> [   44.546628] ? dev_gro_receive (net/core/dev.c:6103)
> [   44.547135] ? napi_complete_done (./include/linux/list.h:35 net/core/dev.c:5867 net/core/dev.c:5862 net/core/dev.c:6565)
> [   44.547672] virtnet_poll (drivers/net/virtio_net.c:1427 drivers/net/virtio_net.c:1525)
> [   44.548251] __napi_poll (net/core/dev.c:6985)
> [   44.548744] net_rx_action (net/core/dev.c:7054 net/core/dev.c:7139)
> [   44.549264] __do_softirq (./arch/x86/include/asm/jump_label.h:19 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:560)
> [   44.549762] irq_exit_rcu (kernel/softirq.c:433 kernel/softirq.c:637 kernel/softirq.c:649)
> [   44.551384] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 13))
> [   44.551991] ? asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
> [   44.552654] asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reported-by: Corentin Noël <corentin.noel@collabora.com>
> Tested-by: Corentin Noël <corentin.noel@collabora.com>
> ---
>   drivers/net/virtio_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fa407eb8b457..78a01c71a17c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>   	 */
>   	truesize = headroom ? PAGE_SIZE : truesize;
> -	tailroom = truesize - len - headroom;
> +	tailroom = truesize - len - headroom - (hdr_padded_len - hdr_len);


The patch looks correct and I saw it has been merged.

But I prefer to do that in receive_big() instead of here.

Thanks



>   	buf = p - headroom;
>   
>   	len -= hdr_len;

