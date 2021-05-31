Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F61395542
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhEaGNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhEaGNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 02:13:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622441480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gFtzwgziSoZ8iozEmB6Ecc/Oz0muKre3EGFmRB+A8Zw=;
        b=LxEXndpd9iVJjq8e5kSD3QD2JezW9fNkuZeibjWMjA5xFEkEvkf4YmPn5q0PCzU97oWWAX
        oZplPss0QNoUonOEh8Dfn9jDgj/z0pwa9qm3bjEHGbtTyjrMTVwtgkYMfWQzKOroSS3Mtn
        7nDbxtz2mboIwRupyCv24NMpOF5bIB0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-WFUVPhgWPYm_h_Gz_hqSSA-1; Mon, 31 May 2021 02:11:17 -0400
X-MC-Unique: WFUVPhgWPYm_h_Gz_hqSSA-1
Received: by mail-pj1-f72.google.com with SMTP id k1-20020a17090a7f01b029015d0d4c2107so4764871pjl.0
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 23:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=gFtzwgziSoZ8iozEmB6Ecc/Oz0muKre3EGFmRB+A8Zw=;
        b=VLR40RJzzE/grXjT0FoxDf8SEFQkfwCy+KDCU0nwzGic8pmNkcaxkg15XbI2EQ6Wwk
         EwcWzf7TwkByfFbna4T9FiBe0RnpGvQ/4LpNVErdyLmlMxdSliUqmxWgw22o6NvbAUEa
         L1hEndnIL+LW/Z8rxwSVE79WjyPIbAaQne92YeaCvPR2Yp+Qvi5PGlnXvbF3kePL08iA
         j9hl7wP/dAYYCOjLH7oZc9rAbgSD67d+dkFkABAxPdEJaPzxzaI3exIG+5Ts1AmJGOFx
         9xkUpR0C2FLr+NQ6pUaz9lvkOZ5dM9wVB0EOZ+naHzd8nN4GAFd80CYdaIZ5JJQAR/Qm
         Qdlg==
X-Gm-Message-State: AOAM533pZKVLcfWGZ8Pci8Xc1w/iPDYCv03X5sMPNCuKPwU10XpIw6mH
        3WCj87N02omoHgQ1cHiifkJ+LnoJAn8o7DGbRW1JcyZej+us+xVfepEvjtbMkqiZWRX9tywvs9F
        cmfa05cI7pLg9hVYS
X-Received: by 2002:a63:2bd5:: with SMTP id r204mr20901096pgr.426.1622441476731;
        Sun, 30 May 2021 23:11:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxutLeevxA6LuaKonk96FQO3so1MTRdYBSNys4UBNveOmY1P9CbnJDYcS/TPJxyyRyHmM3yvA==
X-Received: by 2002:a63:2bd5:: with SMTP id r204mr20901072pgr.426.1622441476476;
        Sun, 30 May 2021 23:11:16 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a9sm9621387pfo.69.2021.05.30.23.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 23:11:16 -0700 (PDT)
Subject: Re: [PATCH net 2/2] virtio-net: get build_skb() buf by data ptr
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
References: <20210514151637.117596-1-xuanzhuo@linux.alibaba.com>
 <20210514151637.117596-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2920ec92-43ac-714f-69b5-281467d1d5ad@redhat.com>
Date:   Mon, 31 May 2021 14:10:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210514151637.117596-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/14 下午11:16, Xuan Zhuo 写道:
> In the case of merge, the page passed into page_to_skb() may be a head
> page, not the page where the current data is located.


I don't get how this can happen?

Maybe you can explain a little bit more?

receive_mergeable() call page_to_skb() in two places:

1) XDP_PASS for linearized page , in this case we use xdp_page
2) page_to_skb() for "normal" page, in this case the page contains the data

Thanks


> So when trying to
> get the buf where the data is located, you should directly use the
> pointer(p) to get the address corresponding to the page.
>
> At the same time, the offset of the data in the page should also be
> obtained using offset_in_page().
>
> This patch solves this problem. But if you don’t use this patch, the
> original code can also run, because if the page is not the page of the
> current data, the calculated tailroom will be less than 0, and will not
> enter the logic of build_skb() . The significance of this patch is to
> modify this logical problem, allowing more situations to use
> build_skb().
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 3e46c12dde08..073fec4c0df1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -407,8 +407,12 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
>   		 */
>   		truesize = PAGE_SIZE;
> -		tailroom = truesize - len - offset;
> -		buf = page_address(page);
> +
> +		/* page maybe head page, so we should get the buf by p, not the
> +		 * page
> +		 */
> +		tailroom = truesize - len - offset_in_page(p);
> +		buf = (char *)((unsigned long)p & PAGE_MASK);
>   	} else {
>   		tailroom = truesize - len;
>   		buf = p;

