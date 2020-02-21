Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3219516768F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 09:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgBUIgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 03:36:20 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45938 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733104AbgBUIgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 03:36:18 -0500
Received: by mail-pf1-f193.google.com with SMTP id 2so812690pfg.12;
        Fri, 21 Feb 2020 00:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oj8fzjEzBAgzXEDr795+iOf1viUL7ZqodcxYvnjVpBI=;
        b=P72v8MRi179GTSpmui8N8ZpwMSwlNEzSu46cMDKMfapJEcd8BxX0ygynYvAVS9haPu
         1Q/zZO0mWvAbtd4MTyda32eXkFVmtaHP8JxXhQZuJoF2kQsFAQ7dSF0ws9PywMfNHY57
         Y4F3z6nWYtfG+u4Yc1nQ43nENDEUyEGlfeNmk2EzlSg4j3kXfcOmce7CwvHDIU3yWOYc
         PxT+IsIqLY4GdJ2SagoZWia31R8LK3b7tNLr2z6G7J67I1zUlek8t/K6+4JZFFxstXgb
         DThYPlvleGfP3oP5/KywsDqpwy8EJNOrq6qhDqOtd/PtT52SUxaUgJaNQhDfeHM59UM6
         /dMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Oj8fzjEzBAgzXEDr795+iOf1viUL7ZqodcxYvnjVpBI=;
        b=pjrB0iudNAvgv/DL/iIGM+qIpeKxIvt2N1R7Uu9X5I0G0OAiUn/2MeDbEWM9aDzKOb
         lJX+9zN4itcMZaem1C7J4RAO2LsG0u+Ibjw/ow62x8t3dnxu7vhOYguz24HyDWEqEZlK
         OEkw3WB/92N0+xRghZy0EBi/BzZeULlqxwbLx1Eyk8Y3udTSmonj18a0L3BykWpE+BkX
         cQLQhPR+quGuVfKKwJLRh0t5A+bNkd11+SEW1QHY/ubpH39rZZk11lKeMJ78ZEa7x1IO
         Dm7D+7rMcGamUFfZBkKsRU5IcHG2tbUCIUeXQ1pXQGbhbSSqV3rUtfLyvWHzOGI/lJM1
         X7Tg==
X-Gm-Message-State: APjAAAXBnUzy3lUKBLROZYY30syUAHPU6lZRrKpeVdX+anW8YzREoMPE
        UG6HgHX9K8SM0MjMLpx/GdU=
X-Google-Smtp-Source: APXvYqxoH/ivGUgZopABlQdv6PW6vm/llP+bqkp1jQyp7fw9QYMjsOADrPXJRTJAa+ODdCNiWWVn+g==
X-Received: by 2002:aa7:934a:: with SMTP id 10mr37942689pfn.233.1582274177337;
        Fri, 21 Feb 2020 00:36:17 -0800 (PST)
Received: from [192.168.100.28] ([103.202.217.14])
        by smtp.gmail.com with ESMTPSA id y10sm1982095pfq.110.2020.02.21.00.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 00:36:16 -0800 (PST)
Subject: Re: [PATCH bpf-next v5] virtio_net: add XDP meta data support
To:     Jason Wang <jasowang@redhat.com>
Cc:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
References: <0c5eaba2-dd5a-fc3f-0e8f-154f7ad52881@redhat.com>
 <20200220085549.269795-1-yuya.kusakabe@gmail.com>
 <5bf11065-6b85-8253-8548-683c01c98ac1@redhat.com>
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
Autocrypt: addr=yuya.kusakabe@gmail.com; keydata=
 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 V13X
Message-ID: <8fafd23d-4c80-539d-9f74-bc5cda0d5575@gmail.com>
Date:   Fri, 21 Feb 2020 17:36:08 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5bf11065-6b85-8253-8548-683c01c98ac1@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/21/20 1:23 PM, Jason Wang wrote:
> 
> On 2020/2/20 下午4:55, Yuya Kusakabe wrote:
>> Implement support for transferring XDP meta data into skb for
>> virtio_net driver; before calling into the program, xdp.data_meta points
>> to xdp.data, where on program return with pass verdict, we call
>> into skb_metadata_set().
>>
>> Tested with the script at
>> https://github.com/higebu/virtio_net-xdp-metadata-test.
>>
>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
> 
> 
> I'm not sure this is correct since virtio-net claims to not support metadata by calling xdp_set_data_meta_invalid()?

virtio_net doesn't support by calling xdp_set_data_meta_invalid() for now.

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/drivers/net/virtio_net.c?id=e42da4c62abb547d9c9138e0e7fcd1f36057b5e8#n686
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/drivers/net/virtio_net.c?id=e42da4c62abb547d9c9138e0e7fcd1f36057b5e8#n842

And xdp_set_data_meta_invalid() are added by de8f3a83b0a0.

$ git blame ./drivers/net/virtio_net.c | grep xdp_set_data_meta_invalid
de8f3a83b0a0f (Daniel Borkmann           2017-09-25 02:25:51 +0200  686)                xdp_set_data_meta_invalid(&xdp);
de8f3a83b0a0f (Daniel Borkmann           2017-09-25 02:25:51 +0200  842)                xdp_set_data_meta_invalid(&xdp);

So I added `Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")` to the comment.

> 
> 
>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>> ---
>> v5:
>>   - page_to_skb(): copy vnet header if hdr_valid without checking metasize.
>>   - receive_small(): do not copy vnet header if xdp_prog is availavle.
>>   - __virtnet_xdp_xmit_one(): remove the xdp_set_data_meta_invalid().
>>   - improve comments.
>> v4:
>>   - improve commit message
>> v3:
>>   - fix preserve the vnet header in receive_small().
>> v2:
>>   - keep copy untouched in page_to_skb().
>>   - preserve the vnet header in receive_small().
>>   - fix indentation.
>> ---
>>   drivers/net/virtio_net.c | 54 ++++++++++++++++++++++++----------------
>>   1 file changed, 33 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 2fe7a3188282..4ea0ae60c000 100644
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
>> @@ -393,6 +393,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>       else
>>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>   +    /* hdr_valid means no XDP, so we can copy the vnet header */
>>       if (hdr_valid)
>>           memcpy(hdr, p, hdr_len);
>>   @@ -405,6 +406,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>           copy = skb_tailroom(skb);
>>       skb_put_data(skb, p, copy);
>>   +    if (metasize) {
>> +        __skb_pull(skb, metasize);
>> +        skb_metadata_set(skb, metasize);
>> +    }
>> +
>>       len -= copy;
>>       offset += copy;
>>   @@ -450,10 +456,6 @@ static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>>       struct virtio_net_hdr_mrg_rxbuf *hdr;
>>       int err;
>>   -    /* virtqueue want to use data area in-front of packet */
>> -    if (unlikely(xdpf->metasize > 0))
>> -        return -EOPNOTSUPP;
>> -
>>       if (unlikely(xdpf->headroom < vi->hdr_len))
>>           return -EOVERFLOW;
>>   @@ -644,6 +646,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       unsigned int delta = 0;
>>       struct page *xdp_page;
>>       int err;
>> +    unsigned int metasize = 0;
>>         len -= vi->hdr_len;
>>       stats->bytes += len;
>> @@ -683,8 +686,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>             xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>>           xdp.data = xdp.data_hard_start + xdp_headroom;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + len;
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>           orig_data = xdp.data;
>>           act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -695,6 +698,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>               /* Recalculate length in case bpf program changed it */
>>               delta = orig_data - xdp.data;
>>               len = xdp.data_end - xdp.data;
>> +            metasize = xdp.data - xdp.data_meta;
>>               break;
>>           case XDP_TX:
>>               stats->xdp_tx++;
>> @@ -735,11 +739,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       }
>>       skb_reserve(skb, headroom - delta);
>>       skb_put(skb, len);
>> -    if (!delta) {
>> +    if (!xdp_prog) {
>>           buf += header_offset;
>>           memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>>       } /* keep zeroed vnet hdr since packet was changed by bpf */
> 
> 
> I prefer to make this an independent patch and cc stable.
> 
> Other looks good.
> 
> Thanks

I see. So I need to revert to delta from xdp_prog?

Thank you.

> 
>>   +    if (metasize)
>> +        skb_metadata_set(skb, metasize);
>> +
>>   err:
>>       return skb;
>>   @@ -760,8 +767,8 @@ static struct sk_buff *receive_big(struct net_device *dev,
>>                      struct virtnet_rq_stats *stats)
>>   {
>>       struct page *page = buf;
>> -    struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
>> -                      PAGE_SIZE, true);
>> +    struct sk_buff *skb =
>> +        page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0);
>>         stats->bytes += len - vi->hdr_len;
>>       if (unlikely(!skb))
>> @@ -793,6 +800,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>       unsigned int truesize;
>>       unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>>       int err;
>> +    unsigned int metasize = 0;
>>         head_skb = NULL;
>>       stats->bytes += len - vi->hdr_len;
>> @@ -839,8 +847,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           data = page_address(xdp_page) + offset;
>>           xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>>           xdp.data = data + vi->hdr_len;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + (len - vi->hdr_len);
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -848,24 +856,27 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>             switch (act) {
>>           case XDP_PASS:
>> +            metasize = xdp.data - xdp.data_meta;
>> +
>>               /* recalculate offset to account for any header
>> -             * adjustments. Note other cases do not build an
>> -             * skb and avoid using offset
>> +             * adjustments and minus the metasize to copy the
>> +             * metadata in page_to_skb(). Note other cases do not
>> +             * build an skb and avoid using offset
>>                */
>> -            offset = xdp.data -
>> -                    page_address(xdp_page) - vi->hdr_len;
>> +            offset = xdp.data - page_address(xdp_page) -
>> +                 vi->hdr_len - metasize;
>>   -            /* recalculate len if xdp.data or xdp.data_end were
>> -             * adjusted
>> +            /* recalculate len if xdp.data, xdp.data_end or
>> +             * xdp.data_meta were adjusted
>>                */
>> -            len = xdp.data_end - xdp.data + vi->hdr_len;
>> +            len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
>>               /* We can only create skb based on xdp_page. */
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
>> @@ -921,7 +932,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           goto err_skb;
>>       }
>>   -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
>> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>> +                   metasize);
>>       curr_skb = head_skb;
>>         if (unlikely(!curr_skb))
> 
