Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9BD39559C
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 08:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhEaGvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 02:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhEaGu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 02:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622443758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Yc0uSlr7grz8BAG5Bx+sZyGCLVXp2CTrZfFPky/9/w=;
        b=gZVFTso8CQ2qC9cp2DRumIL1/lDDCAD/G+S+iDvtWR5G1En6mx/UoSEhO3a0IhK8bX5xS6
        xLqV8Pv3rWdpPYHk1iBILTEu4XimGqlDbuoQUf9EZBap93OJmycxWkgWstnKTarzGvOkqz
        KzGnaq0iTEj1oiyvIh7399ScoIymVOo=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-D5oZ2bpHOT6SN68jLgY_Qw-1; Mon, 31 May 2021 02:49:16 -0400
X-MC-Unique: D5oZ2bpHOT6SN68jLgY_Qw-1
Received: by mail-pf1-f199.google.com with SMTP id v22-20020aa785160000b02902ddbe7f56bdso5442876pfn.12
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 23:49:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6Yc0uSlr7grz8BAG5Bx+sZyGCLVXp2CTrZfFPky/9/w=;
        b=V4p9WrMvk1Y5Ivyfl5TNM72tkYGEQ6a1F1WzAvaBEddOYnClfrGfHUOAeKOKts68go
         KT77jAqaGN31S1+HCT5l+iVgEOPgTVacaemmgJ+Npd2DpNp00sVU8ibVw4ZzfsHbCz7J
         q7OnbDPg2I9Bckw/HscHOWrQCw4eYi1d6O7qUTuF/y6E7IOS7Ui4F7PPh1tqgaezxSOV
         uoXtnqIGr/2kGKQn2W8EKVpTEjCdk9bnQ8L5ov066Xp0SwEYA4ReydADNmD50VW03MTZ
         s/CeOL0tlzxrOwHSO1jIl6ZvprQ+f4KG+AvZsQn/CZqxKRu/L3BiIfxIEydVkkH71ff5
         4nhg==
X-Gm-Message-State: AOAM533z3RxGavowiZIp6Io79kR3LNQdMjjwR63a7s5nJp5oCINuaGVX
        /+4QogiOlBas20/6HVaImr3g0JqBye1aeaHy0tMJgdplO6G6oG8ysgPhg7/Wt1Zi3OenUUVXBl+
        EZdfymBsJ8ovLz9jz
X-Received: by 2002:a17:90b:3796:: with SMTP id mz22mr1584918pjb.177.1622443755366;
        Sun, 30 May 2021 23:49:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9RAl2ySCS8IqAypdqHE7XJCr0ttp2qTK+ufr0FDlpClMk1kWxyYqhd7HsscFqocSEmZPnrg==
X-Received: by 2002:a17:90b:3796:: with SMTP id mz22mr1584900pjb.177.1622443755124;
        Sun, 30 May 2021 23:49:15 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o139sm2519738pfd.96.2021.05.30.23.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 23:49:14 -0700 (PDT)
Subject: Re: [PATCH v3] virtio-net: Add validation for used length
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210528121157.105-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <49ab3d41-c5d8-a49d-3ff4-28ebfdba0181@redhat.com>
Date:   Mon, 31 May 2021 14:49:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210528121157.105-1-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/28 ÏÂÎç8:11, Xie Yongji Ð´µÀ:
> This adds validation for used length (might come
> from an untrusted device) to avoid data corruption
> or loss.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/net/virtio_net.c | 28 +++++++++++++++++++++-------
>   1 file changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 073fec4c0df1..01f15b65824c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -732,6 +732,17 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   
>   	rcu_read_lock();
>   	xdp_prog = rcu_dereference(rq->xdp_prog);
> +	if (unlikely(len > GOOD_PACKET_LEN)) {
> +		pr_debug("%s: rx error: len %u exceeds max size %d\n",
> +			 dev->name, len, GOOD_PACKET_LEN);
> +		dev->stats.rx_length_errors++;
> +		if (xdp_prog)
> +			goto err_xdp;
> +
> +		rcu_read_unlock();
> +		put_page(page);
> +		return NULL;
> +	}
>   	if (xdp_prog) {
>   		struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
>   		struct xdp_frame *xdpf;
> @@ -888,6 +899,16 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   
>   	rcu_read_lock();
>   	xdp_prog = rcu_dereference(rq->xdp_prog);
> +	if (unlikely(len > truesize)) {
> +		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> +			 dev->name, len, (unsigned long)ctx);
> +		dev->stats.rx_length_errors++;
> +		if (xdp_prog)
> +			goto err_xdp;
> +
> +		rcu_read_unlock();
> +		goto err_skb;
> +	}


Patch looks correct but I'd rather not bother XDP here. It would be 
better if we just do the check before rcu_read_lock() and use err_skb 
directly() to avoid RCU/XDP stuffs.

Thanks


>   	if (xdp_prog) {
>   		struct xdp_frame *xdpf;
>   		struct page *xdp_page;
> @@ -1012,13 +1033,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	}
>   	rcu_read_unlock();
>   
> -	if (unlikely(len > truesize)) {
> -		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> -			 dev->name, len, (unsigned long)ctx);
> -		dev->stats.rx_length_errors++;
> -		goto err_skb;
> -	}
> -
>   	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>   			       metasize, !!headroom);
>   	curr_skb = head_skb;

