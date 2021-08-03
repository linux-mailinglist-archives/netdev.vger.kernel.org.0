Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B880F3DE488
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhHCCvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:51:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45826 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233436AbhHCCvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 22:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627959088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FtFtSflpgXYpxK/P7s4u0DhYswz+8t3sa9wAOnkpUy8=;
        b=DAYnY4AHzHQ2ByO2rEoe45mofph657owAq8dzFUaaWwupCUBpJWBX2ICSbxMMIu+CqLmys
        Xt5CWV0mGqSMO//XWq6Uwqp90SeZkdThMty++2voY/lNiEqua1+oxad+/mbdCs7+XTs0zi
        0JWbq1H9bwVNQ9sYZgNMeOC1Nhu72bo=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-IOTqY1R0NvKLCKxwvMwahQ-1; Mon, 02 Aug 2021 22:51:27 -0400
X-MC-Unique: IOTqY1R0NvKLCKxwvMwahQ-1
Received: by mail-pl1-f198.google.com with SMTP id u4-20020a170902e804b029012c4b467095so15281144plg.9
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 19:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FtFtSflpgXYpxK/P7s4u0DhYswz+8t3sa9wAOnkpUy8=;
        b=dm2BwMu4mAeiQ9bdp7Zv8yDdS22l5CE/KqMj/wkZVdSC1PgfBjbpKRNdyZZl/5AStr
         2899a79Ez9b1BPKk4GU25R7XhtA3GGtoe+ucSMZEQ8zY6CviDpUsjd41Yb06r9N/Z4Cj
         FwZda1lI0Sn2TIckiUNm7LXCPU3LV3dPKXt9+/YkFIV6bjM8WKSnHZ4YLaejRr/XJ7RM
         rR2Jqm59zjBsHC2HHEEdOje4Y9h7K11iQNd3fyVHtg/azqmXW9B14pnYj0bmYlowe4rc
         mKUrWzD4tnVVmI7ddoMakPQGxmAUbJSYiJuYb/G1qhIbSgxMS2JtsGsMUnPI9hD9PBID
         FlWg==
X-Gm-Message-State: AOAM533PsX8UeIs2DsZxdCmVmfQJwcb1KFrSiqGnjt7YO4b/NVqnQDpW
        FeGD0cGZtLWMc/1Jb79S+sKbLfnutdL2szIuFNYFXkXAupt7DQO7pn/qb4YMHKl8S1QoT/r8bS4
        X/TAS1ax5Wf+6I7z3
X-Received: by 2002:a17:90b:4a47:: with SMTP id lb7mr2010299pjb.137.1627959086376;
        Mon, 02 Aug 2021 19:51:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynvB3G26Icvx22CnaMMyf/BhZyd3nCyGSIFFnymfxrtduoeR/x6KpkPMPy7rMbPYy7YYGblg==
X-Received: by 2002:a17:90b:4a47:: with SMTP id lb7mr2010285pjb.137.1627959086131;
        Mon, 02 Aug 2021 19:51:26 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm11858514pjq.1.2021.08.02.19.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 19:51:25 -0700 (PDT)
Subject: Re: [PATCH net-next] virtio-net: realign page_to_skb() after merges
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        xuanzhuo@linux.alibaba.com
References: <20210802175729.2042133-1-kuba@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b076c30d-2e45-3181-9f1a-bb530511db88@redhat.com>
Date:   Tue, 3 Aug 2021 10:51:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210802175729.2042133-1-kuba@kernel.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/8/3 ÉÏÎç1:57, Jakub Kicinski Ð´µÀ:
> We ended up merging two versions of the same patch set:
>
> commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
> commit 5c37711d9f27 ("virtio-net: fix for unable to handle page fault for address")
>
> into net, and
>
> commit 7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")
> commit 6c66c147b9a4 ("virtio-net: fix for unable to handle page fault for address")
>
> into net-next. Redo the merge from commit 126285651b7f ("Merge
> ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), so that
> the most recent code remains.
>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 27 ++++++++-------------------
>   1 file changed, 8 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 56c3f8519093..74482a52f076 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -380,7 +380,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   				   struct page *page, unsigned int offset,
>   				   unsigned int len, unsigned int truesize,
>   				   bool hdr_valid, unsigned int metasize,
> -				   bool whole_page)
> +				   unsigned int headroom)
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -398,28 +398,16 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>   
> -	/* If whole_page, there is an offset between the beginning of the
> +	/* If headroom is not 0, there is an offset between the beginning of the
>   	 * data and the allocated space, otherwise the data and the allocated
>   	 * space are aligned.
>   	 *
>   	 * Buffers with headroom use PAGE_SIZE as alloc size, see
>   	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>   	 */
> -	if (whole_page) {
> -		/* Buffers with whole_page use PAGE_SIZE as alloc size,
> -		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> -		 */
> -		truesize = PAGE_SIZE;
> -
> -		/* page maybe head page, so we should get the buf by p, not the
> -		 * page
> -		 */
> -		tailroom = truesize - len - offset_in_page(p);
> -		buf = (char *)((unsigned long)p & PAGE_MASK);
> -	} else {
> -		tailroom = truesize - len;
> -		buf = p;
> -	}
> +	truesize = headroom ? PAGE_SIZE : truesize;
> +	tailroom = truesize - len - headroom;
> +	buf = p - headroom;
>   
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
> @@ -978,7 +966,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   				put_page(page);
>   				head_skb = page_to_skb(vi, rq, xdp_page, offset,
>   						       len, PAGE_SIZE, false,
> -						       metasize, true);
> +						       metasize,
> +						       VIRTIO_XDP_HEADROOM);
>   				return head_skb;
>   			}
>   			break;
> @@ -1029,7 +1018,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	rcu_read_unlock();
>   
>   	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> -			       metasize, !!headroom);
> +			       metasize, headroom);
>   	curr_skb = head_skb;
>   
>   	if (unlikely(!curr_skb))

