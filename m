Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE49238FAEE
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 08:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhEYGcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 02:32:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230453AbhEYGcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 02:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621924238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIPfv8IYDUTIDMiq+eRnmm+3Pp4NwYwr+GrjUyUW4n4=;
        b=hMgTRZrO5XwJEg5ehAVdAeP+nSGjEGy78ZWEHsXsUn++FxCrCuqZLSnaMI9xkkH7IzAgkT
        fl+aWSyCS4Fy30BX+xIHNmjCOYiRZfLUK/cCec15E5p+6a7hEwyg+3X13uCM0KeHUGMFTk
        DJRy2n+lT9QOxQ5sSLlRdOBZoB+xx08=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-8hWvnpajPey0Etw3mubV1A-1; Tue, 25 May 2021 02:30:35 -0400
X-MC-Unique: 8hWvnpajPey0Etw3mubV1A-1
Received: by mail-pf1-f199.google.com with SMTP id x4-20020aa794040000b02902e382051004so10237613pfo.6
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 23:30:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pIPfv8IYDUTIDMiq+eRnmm+3Pp4NwYwr+GrjUyUW4n4=;
        b=YxB2k6SL2NrtYmE41WVTTi6HMyb00/giw8xFiyHAbzQUe0K3KmJuG4RzI097UAXt2/
         KPUdyHaSEc/okYzJyPgVry9kSoss6TmofOmpErgRjxsjTSR/WpREk22YEjQo9aIYHccy
         XmrkNtksDlHvySPialdDQw8P2pF+MGvR9COCQ66geDHh4OOz3p26XjeI33d4tUOZWO9Y
         4R1Za5rEjjC+AYLV5bqkvNnjXUv+CGV5Id8I0r/FCYH+EWXZh4HxgQ9NtimqF3cR3eno
         CCu4VpgTSWczhwhLYAdmfGtuxTZY4vRaRUlM/Ox41WJp9tMGyXe4HBQ0iakIBladfU/1
         umrQ==
X-Gm-Message-State: AOAM531yAiZAoeoMlmJT+9NnwF9eRVgLwvDpFmdP3V4JbcbHimvxCQEA
        5COuXiEcoz4ACJcdMhMsBd/aTJN5iOZbhwHr5bGhmmy/Ty7mG7UV2EvlWnnj4uEvzPcL4lB9zW8
        YYQ4gtUfIGEzoMNNd
X-Received: by 2002:aa7:80d3:0:b029:28e:f117:4961 with SMTP id a19-20020aa780d30000b029028ef1174961mr29062275pfn.37.1621924234929;
        Mon, 24 May 2021 23:30:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjxp4RjmBg//wxUGNw5gB2804G2bqHAHLpl0rtSt4C2hFIH3k1hJTSLGBvAz9QuuJ5ei26BA==
X-Received: by 2002:aa7:80d3:0:b029:28e:f117:4961 with SMTP id a19-20020aa780d30000b029028ef1174961mr29062259pfn.37.1621924234638;
        Mon, 24 May 2021 23:30:34 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g202sm13245651pfb.54.2021.05.24.23.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 23:30:34 -0700 (PDT)
Subject: Re: [PATCH] virtio-net: Add validation for used length
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210525045838.1137-1-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <75e26cf1-6ee8-108c-ff48-8a23345b3ccc@redhat.com>
Date:   Tue, 25 May 2021 14:30:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210525045838.1137-1-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/25 ÏÂÎç12:58, Xie Yongji Ð´µÀ:
> This adds validation for used length (might come
> from an untrusted device) to avoid data corruption
> or loss.
>
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/net/virtio_net.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index c4711e23af88..2dcdc1a3c7e8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -668,6 +668,13 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   		void *orig_data;
>   		u32 act;
>   
> +		if (unlikely(len > GOOD_PACKET_LEN)) {
> +			pr_debug("%s: rx error: len %u exceeds max size %lu\n",
> +				 dev->name, len, GOOD_PACKET_LEN);
> +			dev->stats.rx_length_errors++;
> +			goto err_xdp;
> +		}


Need to count vi->hdr_len here?


> +
>   		if (unlikely(hdr->hdr.gso_type))
>   			goto err_xdp;
>   
> @@ -739,6 +746,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
>   	}
>   	rcu_read_unlock();
>   
> +	if (unlikely(len > GOOD_PACKET_LEN)) {
> +		pr_debug("%s: rx error: len %u exceeds max size %lu\n",
> +			 dev->name, len, GOOD_PACKET_LEN);
> +		dev->stats.rx_length_errors++;
> +		put_page(page);
> +		return NULL;
> +	}
> +
>   	skb = build_skb(buf, buflen);
>   	if (!skb) {
>   		put_page(page);
> @@ -822,6 +837,13 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		void *data;
>   		u32 act;
>   
> +		if (unlikely(len > truesize)) {
> +			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> +				 dev->name, len, (unsigned long)ctx);
> +			dev->stats.rx_length_errors++;
> +			goto err_xdp;
> +		}


There's a similar check after the XDP, let's simply move it here?

And do we need similar check in receive_big()?

Thanks


> +
>   		/* Transient failure which in theory could occur if
>   		 * in-flight packets from before XDP was enabled reach
>   		 * the receive path after XDP is loaded.

