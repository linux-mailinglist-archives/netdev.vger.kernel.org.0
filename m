Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7378A396AB9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 03:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFABxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 21:53:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232268AbhFABxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 21:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622512320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YWev/Te8IAqF0czBilN1sKjy7odret07+EIptXPPlVg=;
        b=TXwF/i8V6hrGIl92RaXvW/ky4c5+dZMFRko8AV4zlFc0N0sjTXu9WZvV0YI1mUKxwVU9wP
        GXppf4zYqjR/H9eDfxZriREHOMH9aajthwl3QfA51yBlJBhQ6eq4skCksIas6XgioeICSz
        exbJ4Z4GT6XceQY+Jn6JR1UUSy0xbKQ=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-UcIFkHbKMaC4f60AE4ReuA-1; Mon, 31 May 2021 21:51:58 -0400
X-MC-Unique: UcIFkHbKMaC4f60AE4ReuA-1
Received: by mail-pl1-f198.google.com with SMTP id 37-20020a1709020328b02900f916f1d504so3795014pld.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 18:51:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YWev/Te8IAqF0czBilN1sKjy7odret07+EIptXPPlVg=;
        b=Xpb/NAp7gE5iSVSXKAWE+Se+aACezLO1efRmVqERw2FUrL+i/UrRLszwYq70a9soKb
         +OegcPBC5Tbz1BD4/r2q9aMT+UhPTtEHfk5bkTjemNUJhbTr36n3TQiYoBPIEN/aia+o
         QzduUAezPBWK1ahzXlm088MnbOTXgNr/rXHCdqIfc0Xx8Na/2byXJb9OFrxzVUcb51Z/
         UwSc7N8Gc6C0ENuyT6iedMCuRRsu5PK0UZRpGev/b7R9DDuo4j9tnETSFUj1sBh/8/yR
         pGf9uBnoZSw61ya3cdc81HedMyPOIhf46cXNzMklZRmbJDDo4mbAzMsgeab4+buDpNIq
         mP6A==
X-Gm-Message-State: AOAM533gdA/PqRYFFxXh/tDQUO9s2eeetstPaRJycWlTlxGWkCBgOOKs
        Z8MGOmhARVBMoTmbk+3/yRb4UJMb1zkTDPm7VgJZCv6ti50hCbMnU0yxj5AntHZoVefMyxpFQc2
        2aWPqf9BBDkt1nrqH
X-Received: by 2002:a17:90a:43a6:: with SMTP id r35mr1957755pjg.222.1622512317806;
        Mon, 31 May 2021 18:51:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZhUSTY2svEIOJpmqKwnCCesMbeoDS4VzTWct+zhBKdDDhqnrLsxPBRcTsNvaHlbKxAssgRw==
X-Received: by 2002:a17:90a:43a6:: with SMTP id r35mr1957746pjg.222.1622512317648;
        Mon, 31 May 2021 18:51:57 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k12sm7581515pga.13.2021.05.31.18.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 18:51:57 -0700 (PDT)
Subject: Re: [PATCH v4] virtio-net: Add validation for used length
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210531135852.113-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <32febeff-cc36-2333-5d2c-1f3ae3d91f94@redhat.com>
Date:   Tue, 1 Jun 2021 09:51:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531135852.113-1-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/31 ÏÂÎç9:58, Xie Yongji Ð´µÀ:
> This adds validation for used length (might come
> from an untrusted device) to avoid data corruption
> or loss.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 20 +++++++++++++-------
>   1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 073fec4c0df1..ed969b65126e 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -730,6 +730,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	len -= vi->hdr_len;
>   	stats->bytes += len;
>   
> +	if (unlikely(len > GOOD_PACKET_LEN)) {
> +		pr_debug("%s: rx error: len %u exceeds max size %d\n",
> +			 dev->name, len, GOOD_PACKET_LEN);
> +		dev->stats.rx_length_errors++;
> +		goto err_len;
> +	}
>   	rcu_read_lock();
>   	xdp_prog = rcu_dereference(rq->xdp_prog);
>   	if (xdp_prog) {
> @@ -833,6 +839,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   err_xdp:
>   	rcu_read_unlock();
>   	stats->xdp_drops++;
> +err_len:
>   	stats->drops++;
>   	put_page(page);
>   xdp_xmit:
> @@ -886,6 +893,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	head_skb = NULL;
>   	stats->bytes += len - vi->hdr_len;
>   
> +	if (unlikely(len > truesize)) {
> +		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> +			 dev->name, len, (unsigned long)ctx);
> +		dev->stats.rx_length_errors++;
> +		goto err_skb;
> +	}
>   	rcu_read_lock();
>   	xdp_prog = rcu_dereference(rq->xdp_prog);
>   	if (xdp_prog) {
> @@ -1012,13 +1025,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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

