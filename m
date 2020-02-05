Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 231D415281A
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 10:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgBEJSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 04:18:22 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41306 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgBEJSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 04:18:22 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so624457plr.8;
        Wed, 05 Feb 2020 01:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8/lqlpHZqUc9jpTXdi9xRlNfjSF6bBYPtgNuRCUwjng=;
        b=CPZ83JD9xyRYa4SCNne3iL6VqtZVXAtBNGoDsa03+9cAXdmLBAsVTxyblxjfAZ4BbC
         hNRigZAaB6tc/TbaRu/QAoc+NMzRt+xZKNodJFfLN6EwVyrLCfr0pPCrSOwokO1CNTPn
         KHcKvqgNgreBuvrNx6h1rI+DwMQMTK3cVxDXGSet9Cj6TqWJ7F8Sw9eD+YpjeD29IHuI
         F1xRtBbIP/Igh+9z8d9oqb+YyWRz/K7ZeCYy2VYT0/RVbEOGgDT+2Boz3sbj+sAQbQ5p
         dOaSONbwGA6AM3IwFgc8yKoARV6AkyZNkewm1LDyzao2eef8c6iydUB2U0sOTxw3WzWT
         dMjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=8/lqlpHZqUc9jpTXdi9xRlNfjSF6bBYPtgNuRCUwjng=;
        b=nCEfNLykQl1uq3Iatimxj9fUssQbyQ1+/n40vnSOXC663T9Ool4Ngp9xSQZZRan+P+
         8cHl9tUpvAb58/qBU/JLe5V44EuvAnMOvqcUUXiod6JfZIPvVSabSSXZOMWpveh5ifSl
         LS3Jy+KduNVL/euVRyQXQxrLeb0DK/7/BeYNIee/gz+Ah/kUeARrHbS5on4HpR2+l26w
         PJuEFy63u+Ys/z/3G9Lhlw/GyQVJQlAqTg+vOH+5XtS5wfCJkfl00sHKMLX3XG5L8fEn
         TK/6+9zJ4ESjiIdBijVDywHmylRB/JBXdJEaLE5yyhED8cHqw1mMIfXyAQVcI63yhd9D
         w60g==
X-Gm-Message-State: APjAAAV6a1w9QWWEctJ3WP/iOaMYpWRZN4OO2OJ3/qvsERdDRvrgXqrF
        oHsLKUWRVM4B/FvnbofDyq+wtpZYtYYIgA==
X-Google-Smtp-Source: APXvYqzH3p/aOzW9PrRmT4l8I0IF35mTaAfkpqnI3QrtxQYvaoaN9WZj3AlhqH2pN4oDAX5T0J07gA==
X-Received: by 2002:a17:90b:14e:: with SMTP id em14mr4269889pjb.112.1580894301030;
        Wed, 05 Feb 2020 01:18:21 -0800 (PST)
Received: from [192.168.100.27] ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id z18sm28211325pfk.19.2020.02.05.01.18.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 01:18:20 -0800 (PST)
Subject: Re: [PATCH bpf-next v4] virtio_net: add XDP meta data support
To:     Jason Wang <jasowang@redhat.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        mst@redhat.com, songliubraving@fb.com, yhs@fb.com, kuba@kernel.org,
        andriin@fb.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <8da1b560-3128-b885-b453-13de5c7431fb@redhat.com>
 <20200204071655.94474-1-yuya.kusakabe@gmail.com>
 <9a0a1469-c8a7-8223-a4d5-dad656a142fc@redhat.com>
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
Autocrypt: addr=yuya.kusakabe@gmail.com; keydata=
 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 V13X
Message-ID: <1100837f-075f-dc97-cd14-758c96f2ac1d@gmail.com>
Date:   Wed, 5 Feb 2020 18:18:13 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9a0a1469-c8a7-8223-a4d5-dad656a142fc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/20 1:10 PM, Jason Wang wrote:
> 
> On 2020/2/4 下午3:16, Yuya Kusakabe wrote:
>> Implement support for transferring XDP meta data into skb for
>> virtio_net driver; before calling into the program, xdp.data_meta points
>> to xdp.data and copy vnet header to the front of xdp.data_hard_start
>> to avoid overwriting it, where on program return with pass verdict,
>> we call into skb_metadata_set().
>>
>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>> ---
>>   drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++------------
>>   1 file changed, 33 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 2fe7a3188282..5fdd6ea0e3f1 100644
>> --- a/drivers/net/virtio_net.c
>> +++ b/drivers/net/virtio_net.c
>> @@ -371,7 +371,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>                      struct receive_queue *rq,
>>                      struct page *page, unsigned int offset,
>>                      unsigned int len, unsigned int truesize,
>> -                   bool hdr_valid)
>> +                   bool hdr_valid, unsigned int metasize)
>>   {
>>       struct sk_buff *skb;
>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>> @@ -393,7 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>       else
>>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>   -    if (hdr_valid)
>> +    if (hdr_valid && !metasize)
> 
> 
> hdr_valid means no XDP, so I think we can remove the check for metasize here and add a comment instead?

I will fix it on next patch.

> 
>>           memcpy(hdr, p, hdr_len);
>>         len -= hdr_len;
>> @@ -405,6 +405,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>           copy = skb_tailroom(skb);
>>       skb_put_data(skb, p, copy);
>>   +    if (metasize) {
>> +        __skb_pull(skb, metasize);
>> +        skb_metadata_set(skb, metasize);
>> +    }
>> +
>>       len -= copy;
>>       offset += copy;
>>   @@ -644,6 +649,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       unsigned int delta = 0;
>>       struct page *xdp_page;
>>       int err;
>> +    unsigned int metasize = 0;
>>         len -= vi->hdr_len;
>>       stats->bytes += len;
>> @@ -683,10 +689,15 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>             xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>>           xdp.data = xdp.data_hard_start + xdp_headroom;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + len;
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>           orig_data = xdp.data;
>> +        /* Copy the vnet header to the front of data_hard_start to avoid
>> +         * overwriting it by XDP meta data.
>> +         */
>> +        memcpy(xdp.data_hard_start - vi->hdr_len,
>> +               xdp.data - vi->hdr_len, vi->hdr_len);
> 
> 
> I think we don't need this. And it looks to me there's a bug in the current code.
> 
> Commit 436c9453a1ac0 ("virtio-net: keep vnet header zeroed after processing XDP") leave the a corner case for receive_small() which still use:
> 
>         if (!delta) {
>                 buf += header_offset;
>                 memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>         } /* keep zeroed vnet hdr since packet was changed by bpf */
> 
> Which seems wrong, we need check xdp_prog instead of delta.
> 
> With this fixed, there's no need to care about the vnet header here since we don't know whether or not packet is modified by XDP.

I missed this commit. I understand this is the reason for "Awaiting Upstream".

> 
>>           act = bpf_prog_run_xdp(xdp_prog, &xdp);
>>           stats->xdp_packets++;
>>   @@ -695,9 +706,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>               /* Recalculate length in case bpf program changed it */
>>               delta = orig_data - xdp.data;
>>               len = xdp.data_end - xdp.data;
>> +            metasize = xdp.data - xdp.data_meta;
>>               break;
>>           case XDP_TX:
>>               stats->xdp_tx++;
>> +            xdp.data_meta = xdp.data;
> 
> 
> I think we should remove the xdp_set_data_meta_invalid() at least? And move this initialization just after xdp.data is initialized.
> 
> Testing receive_small() requires to disable mrg_rxbuf, guest_tso4, guest_tso6 and guest_ufo from qemu command line.
> 
> 
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>>                   goto err_xdp;
>> @@ -736,10 +749,12 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       skb_reserve(skb, headroom - delta);
>>       skb_put(skb, len);
>>       if (!delta) {
> 
> 
> Need to check xdp_prog (need another patch).

I will fix it on next patch.

> 
> 
>> -        buf += header_offset;
>> -        memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>> +        memcpy(skb_vnet_hdr(skb), buf + VIRTNET_RX_PAD, vi->hdr_len);
>>       } /* keep zeroed vnet hdr since packet was changed by bpf */
>>   +    if (metasize)
>> +        skb_metadata_set(skb, metasize);
>> +
>>   err:
>>       return skb;
>>   @@ -760,8 +775,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
>>                      struct virtnet_rq_stats *stats)
>>   {
>>       struct page *page = buf;
>> -    struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
>> -                      PAGE_SIZE, true);
>> +    struct sk_buff *skb =
>> +        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>>         stats->bytes += len - vi->hdr_len;
>>       if (unlikely(!skb))
>> @@ -793,6 +808,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>       unsigned int truesize;
>>       unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>>       int err;
>> +    unsigned int metasize = 0;
>>         head_skb = NULL;
>>       stats->bytes += len - vi->hdr_len;
>> @@ -839,8 +855,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           data = page_address(xdp_page) + offset;
>>           xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>>           xdp.data = data + vi->hdr_len;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + (len - vi->hdr_len);
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -852,8 +868,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>                * adjustments. Note other cases do not build an
>>                * skb and avoid using offset
>>                */
>> -            offset = xdp.data -
>> -                    page_address(xdp_page) - vi->hdr_len;
>> +            metasize = xdp.data - xdp.data_meta;
>> +            offset = xdp.data - page_address(xdp_page) -
>> +                 vi->hdr_len - metasize;
>>                 /* recalculate len if xdp.data or xdp.data_end were
>>                * adjusted
>> @@ -863,14 +880,15 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>               if (unlikely(xdp_page != page)) {
>>                   rcu_read_unlock();
>>                   put_page(page);
>> -                head_skb = page_to_skb(vi, rq, xdp_page,
>> -                               offset, len,
>> -                               PAGE_SIZE, false);
>> +                head_skb = page_to_skb(vi, rq, xdp_page, offset,
>> +                               len, PAGE_SIZE, false,
>> +                               metasize);
>>                   return head_skb;
>>               }
>>               break;
>>           case XDP_TX:
>>               stats->xdp_tx++;
>> +            xdp.data_meta = xdp.data;
> 
> 
> Any reason for doing this?

XDP_TX can not support metadata for now, because if metasize > 0, __virtnet_xdp_xmit_one() returns EOPNOTSUPP.

static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
				   struct send_queue *sq,
				   struct xdp_frame *xdpf)
{
	struct virtio_net_hdr_mrg_rxbuf *hdr;
	int err;

	/* virtqueue want to use data area in-front of packet */
	if (unlikely(xdpf->metasize > 0))
		return -EOPNOTSUPP;


> 
> Thanks
> 
> 
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>>                   goto err_xdp;
>> @@ -921,7 +939,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           goto err_skb;
>>       }
>>   -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
>> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>> +                   metasize);
>>       curr_skb = head_skb;
>>         if (unlikely(!curr_skb))
> 

Thank you for your kind review.
