Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499865C67E
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 03:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfGBBAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 21:00:35 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34588 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbfGBBAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 21:00:35 -0400
Received: by mail-pf1-f196.google.com with SMTP id c85so7389267pfc.1
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 18:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PiX5STCVXjevwCJYWk4lufX0mpBeJjcesacfAnf5TCI=;
        b=u7pNJ+LInJkAs/UD85LJ0Ll2aZJBDfS2NLHcozRVMGZPor8bWI5IqTlkY969biboRZ
         GVMaypQxIKQDGhOsu4uEBDIuP5cAtbgQFTk0jdWfhGxAOTqajey8i7Ly92mO5r89bKCs
         QZaLfaJUdHVcD38H9oNHFLFIr9eNLNfza2/bJL+I0rp6FKEY/rlLUPDLgJUF5uDFeErS
         j1YdcNGZ9Zpii60ON/3ilrcRd5tyHW5V7T8jydJtbYZzo6PU2RVv4RBQL6VUa0sNJ5mU
         /tJlTMoQTVHm8si05ShK65ZJzf3yaT5A+3fLmsBYE34JlvXkUXlD3/F9q/8/IQpO14vh
         lEEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=PiX5STCVXjevwCJYWk4lufX0mpBeJjcesacfAnf5TCI=;
        b=CYzr/bREOzWBFRoLHLLP6JSoUrg9IZ2+DjTFyN/kXPIrNerbZ3d7D5g9HaUgyj6uLe
         ocF6B1Sat6nUhlVqtLlCAlklMvNgSWG5ufOD3y0f0RfygXXSbywZXzpb4LldNUC3Ou1g
         g4a5V4Z9BjXOBFISOmL7mYJVmJs4Ua5KLuOmwpvyByYnEeoKsZJMFRpLq3q5NxpeNfC8
         Na451/zos8vzsR3t72iyssLneMU5dlRnMn/m3wHFKx8jRC7fj/qgrl20QJ6V0Rf7YgvE
         jJCNPTU7gh3Op7HVpCaIDmS2L6W/lCgWg2mUEu4vdkCZBFIJZUVVaLKeRR6+EC/5kDK/
         Hxkg==
X-Gm-Message-State: APjAAAWYNtcDhFhaNMTyDgVd95O3sZXv/vo1FvoionbNSbsuQ3Fl5Q7q
        SQi20c2eAacOT1uN6tepfjRqlpSn+WY=
X-Google-Smtp-Source: APXvYqxa+CxNZ53vIap/MyiZtu1zBQsbMInB4hu/W9BtwRbaNDkWEWA09Q//E1QQTZAQ+TAwefzUQQ==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr27309805pgd.241.1562029233657;
        Mon, 01 Jul 2019 18:00:33 -0700 (PDT)
Received: from [172.25.11.16] (osnfw.sakura.ad.jp. [210.224.179.167])
        by smtp.gmail.com with ESMTPSA id v22sm7961063pgk.69.2019.07.01.18.00.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 18:00:32 -0700 (PDT)
Subject: Re: [PATCH bpf-next] virtio_net: add XDP meta data support
To:     Jason Wang <jasowang@redhat.com>, davem@davemloft.net
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org
References: <20190627080641.3266-1-yuya.kusakabe@gmail.com>
 <fe3070db-ec3a-9c7c-e15e-93032811767f@redhat.com>
From:   Yuya Kusakabe <yuya.kusakabe@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=yuya.kusakabe@gmail.com; keydata=
 mQINBFjtjhwBEADZqewy3PViD7ZRYVsmTvRqgw97NHWqcnNh/B0QMtn75R55aRDZG8BH9YtG
 OMGKmN70ZzVKm4yQ8+sBw9HC7n5pp+kftLAcfqDKwzsQpp/gKP3pfLDO2fkw/JRhUL+aaKTm
 ZQiMKv/XpfNsreAGQ+qvYVFmpMHCGlkQ6krY8yXhnwNm+Ne+42Bd1EYMT1PpQkPgwEDHVJqD
 JSymfmpMIzLYxtDxu4zXBOqj5eiDqaSmxKBrFveA8YcPARuNwMGB2ZbFIv7hZOVfMp4Skl9H
 aC2k4oCx3bJR/+IAy2pbJPXZtjFt9N8TLOZIJb4/wk83QVunaUaZYRkEJp4ZCDt3qzrAMqsb
 vPgg33/8ZicEKnuwAmTGnXuvrIBvvJfjeGG0dMheZY9aiJl5cdIBn8Xp6+rhogGuUc9C3AKI
 wMmYm3M8MkAgB/ghRAVbn/14nJjegHbN9bB2opwpd97piAj79RzKs0+g/xDLWcshSG4xL2U1
 sYc58vPVXnSvJaOFUYe3kq4RCO/Rt3ilK8IXX8i8dFt0Z04mPEAxYA7T1Xa6/rMdrcnyUdiw
 6NfWMlFJ8Dulq1eKt8rymRZaWlMT6ZiO0yWhp6HQwmpdyaB+XAQZ7P/05+mvXoO4SwDDoZJv
 DlpO9lbbLLLiPkIKXgKLwUUACcblviHEX1nqmnAr+0CZ9q/MTQARAQABtCdZdXlhIEt1c2Fr
 YWJlIDx5dXlhLmt1c2FrYWJlQGdtYWlsLmNvbT6JAlQEEwEIAD4CGwMFCwkIBwMFFQoJCAsF
 FgIDAQACHgECF4AWIQTaB7usAfxNKMeqa6Yq19F1Kl0bTQUCXNOYhQUJCzi/aQAKCRAq19F1
 Kl0bTSxyD/9ocPShBVCwNH+Uwg0jlcKsqk7p13cr74cL7YxeyLjS82BKiDbfADm+zA//nOdP
 +pW9dUw7D9sv50cJQVlhw11nwE4FnvkTNJQo5A0ircJMQkViQgVP46VoHMxSQG+f9O3J8RTT
 sfgkGf4fqf6e49W/+yLFlJFInNjTdyC+fIngOZW9T+/9tgwgciS7VIOZj0rzfi62TU1brACn
 ABmXZletM0E11iDTVAm8VA3eemgVHIANa+doOh0VI2HjeuVOLom30pD6avJhjKsmawgj97Aj
 E7vf1WfFO/GVMV5CrJo8wdeGFVdgyC8KSEbLNkwMcE2QiipC6/XjtvZo6gD2bXZYoCEtiPkC
 EAVYOMh1CZlbPJsKExXfp+i3U4TGE8ag5bpC5FTw8oXkwqjz3KJaIkpcoxbFk520dMoeiDEp
 N6W1nueJUMrlIjqe4LnkDGwA+1HQN+osX2jCtE5xB3o9MefY1hDXDZqXAjOXfLV1O8AIhfR5
 NjPJds29slln8psEFRwll/gB8SWDBJPBUur5Wz19d64s6cC0FTeuSZvnhDsVERSd1yYyOnin
 QmwCrD3LtHLS80LyDKsK0acCfEVBuQBE6qs9yVEV+59iDEKV7vMkrz5S9xwtvpAkoRA7lnIR
 z5BW9vLoaTR9JYdDtWq5+AXbNfqePqITt3DrGfJYrtPxM7kCDQRY7Y4cARAA2bDVoMFOiKHO
 J1YfeGcc2gVVXwJcfuhLGdOhLe9OcasUUw85Fvkz/nRgx5P3Cm39RuvlEIL8xfI4GfKEijtv
 qnzYlN+ZlZoi3ZHetAYs8509On1Lq7FcyiSJbPAgAmcEX0kD7JERR0UoMRGw465ZIK7CKww0
 6QCzNcz6ZT2lQqcSgMp8ILopGr9KZxgzAIlU1P1EkqF8U8q4hlEOGghe66wFU1ByGYfaJV+/
 qqj2nReKXcbbcsDzhbRrBVUoJfYieBd0eSF+oeHCPuLuhCyeIiQhElwue7jaeQrVBiQTlpg7
 03gysP0Q40D5uR3arpwnU3csZ7tBN1INGTIGGnfw/jfqvxe45n13rHnrcovPF0H4D/sHT4Cy
 1Ih4XdzXVGeyjqAIPZoJQ3XpM7hEztMU4RCzAfIvcI1PHd6p/LqJi9IZl25wXD4UsfELmd4L
 R4+QDJp2g2EP6wOUdjsNJkibelwdmQnc+II6iYxakwHt/JF0A777NGTiGaO8axeIO7cq9Afa
 R/JocpbnICFNM8BRC36AMjqey6cc9JjXtBTufrTJ7wd+TyjeboeOdhv67kZFrUrE8MK3cbQd
 nDAXTv+hSJ4VwZJJAXtYHyU0Qqh1O65pCxRgLaCs3jBPL8Duq41NAihf+8LFkp0zKnzfgoye
 8bo1fLMKz7pOY/sI5s0gJNsAEQEAAYkCPAQYAQgAJhYhBNoHu6wB/E0ox6prpirX0XUqXRtN
 BQJY7Y4cAhsMBQkFo5qAAAoJECrX0XUqXRtNJGsP/RE9YbGYQEK81Fsq4bQgs+J0PY1p8jct
 QOQP6e01sp9SUXpcZsTbQIQn+vQNOXprH71+WPY2p3ZBb2DNLUw7uoZo25Go78YVSsjQP19K
 h5WZfY6JH0FeVkyXK/kv3bOPwq1U1qsY54KE+33f//+6YjRgVyUn16oASImyVHLmuwn+N+1Y
 hZJ/FTlYPP9/ZlEuzLBBff1upT40lT+1yQSoyGGwKGNzvIYZghBoDAmiau7wpFECpkRijkQ1
 7QQxHE472p0yO+IOglNLWhO7cMtnrgF2q1ZGE/uGo/ouBkMxOXbzFPEx6SlKr89tpXnDKr9W
 7IVNWdX8c1kt0XDNgtfXa9DLJ2mqkN6KTXwDIBlE63+KJwfbjoAz/n48yKaReiCxwf/1N3sp
 saRzLCbEPPaCzQyknk33Tr/hODx+aTib02gE9Vvbr7+SCg+UoLNDvmf4xMH0qaR35C6AgBS4
 auVyx3qNbRrEBgTTZDWgjQ3mX3IzdaMIJ5PXslBhdZG9w7KMIN+00jIqOQ7vdsBo3oQgmDZo
 0EixDe3gezOPG8OkbxaBXzED6C6A0Ujh9ppenIZueoWUcNpmPRYFBD+4ZlsWAPuuGALKHjbo
 FBb//0jym6NzJPVuz1a9mNXDfgeOnQG9lfMq1q6P/1gofgSHqGE8Mu92EHsNo/8Sc3IgXtC8 V13X
Message-ID: <455941f9-aadb-ab70-2745-34f8fd893e89@gmail.com>
Date:   Tue, 2 Jul 2019 10:00:27 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <fe3070db-ec3a-9c7c-e15e-93032811767f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 6:30 PM, Jason Wang wrote:
> 
> On 2019/6/27 下午4:06, Yuya Kusakabe wrote:
>> This adds XDP meta data support to both receive_small() and
>> receive_mergeable().
>>
>> Fixes: de8f3a83b0a0 ("bpf: add meta pointer for direct access")
>> Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
>> ---
>>   drivers/net/virtio_net.c | 40 +++++++++++++++++++++++++++++-----------
>>   1 file changed, 29 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>> index 4f3de0ac8b0b..e787657fc568 100644
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
>> @@ -393,17 +393,25 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>       else
>>           hdr_padded_len = sizeof(struct padded_vnet_hdr);
>>   -    if (hdr_valid)
>> +    if (hdr_valid && !metasize)
>>           memcpy(hdr, p, hdr_len);
>>         len -= hdr_len;
>>       offset += hdr_padded_len;
>>       p += hdr_padded_len;
>>   -    copy = len;
>> +    copy = len + metasize;
>>       if (copy > skb_tailroom(skb))
>>           copy = skb_tailroom(skb);
>> -    skb_put_data(skb, p, copy);
>> +
>> +    if (metasize) {
>> +        skb_put_data(skb, p - metasize, copy);
> 
> 
> I would rather keep copy untouched above, and use copy + metasize here, then you can save the following decrement  as well. Or tweak the caller the count the meta in to offset, then we need only deal with skb_pull() and skb_metadata_set() here.

I think the latter is better, because copy + metasize must be smaller than skb tailroom size.

> 
>> +        __skb_pull(skb, metasize);
>> +        skb_metadata_set(skb, metasize);
>> +        copy -= metasize;
>> +    } else {
>> +        skb_put_data(skb, p, copy);
>> +    }
>>         len -= copy;
>>       offset += copy;
>> @@ -644,6 +652,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       unsigned int delta = 0;
>>       struct page *xdp_page;
>>       int err;
>> +    unsigned int metasize = 0;
>>         len -= vi->hdr_len;
>>       stats->bytes += len;
>> @@ -683,8 +692,8 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>             xdp.data_hard_start = buf + VIRTNET_RX_PAD + vi->hdr_len;
>>           xdp.data = xdp.data_hard_start + xdp_headroom;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + len;
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>           orig_data = xdp.data;
>>           act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -695,9 +704,11 @@ static struct sk_buff *receive_small(struct net_device *dev,
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
> Why need this?

Because virtnet_xdp_xmit() doesn't support XDP meta data as below. And I suppose that we don't need to support XDP metadata for XDP_TX.

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
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>>                   goto err_xdp;
>> @@ -735,11 +746,14 @@ static struct sk_buff *receive_small(struct net_device *dev,
>>       }
>>       skb_reserve(skb, headroom - delta);
>>       skb_put(skb, len);
>> -    if (!delta) {
>> +    if (!delta && !metasize) {
>>           buf += header_offset;
>>           memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>>       } /* keep zeroed vnet hdr since packet was changed by bpf */
> 
> 
> Is there any method to preserve the vnet header here? We probably don't want to lose it for XDP_PASS when packet is not modified.

I'll try to keep the vnet header with moving the meta data to the front of the vnet header.

> 
>>   +    if (metasize)
>> +        skb_metadata_set(skb, metasize);
>> +
>>   err:
>>       return skb;
>>   @@ -761,7 +775,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
>>   {
>>       struct page *page = buf;
>>       struct sk_buff *skb = page_to_skb(vi, rq, page, 0, len,
>> -                      PAGE_SIZE, true);
>> +                      PAGE_SIZE, true, 0);
>>         stats->bytes += len - vi->hdr_len;
>>       if (unlikely(!skb))
>> @@ -793,6 +807,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>       unsigned int truesize;
>>       unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>>       int err;
>> +    unsigned int metasize = 0;
>>         head_skb = NULL;
>>       stats->bytes += len - vi->hdr_len;
>> @@ -839,8 +854,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           data = page_address(xdp_page) + offset;
>>           xdp.data_hard_start = data - VIRTIO_XDP_HEADROOM + vi->hdr_len;
>>           xdp.data = data + vi->hdr_len;
>> -        xdp_set_data_meta_invalid(&xdp);
>>           xdp.data_end = xdp.data + (len - vi->hdr_len);
>> +        xdp.data_meta = xdp.data;
>>           xdp.rxq = &rq->xdp_rxq;
>>             act = bpf_prog_run_xdp(xdp_prog, &xdp);
>> @@ -859,18 +874,20 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>                * adjusted
>>                */
>>               len = xdp.data_end - xdp.data + vi->hdr_len;
>> +            metasize = xdp.data - xdp.data_meta;
>>               /* We can only create skb based on xdp_page. */
>>               if (unlikely(xdp_page != page)) {
>>                   rcu_read_unlock();
>>                   put_page(page);
>>                   head_skb = page_to_skb(vi, rq, xdp_page,
>> -                               offset, len,
>> -                               PAGE_SIZE, false);
>> +                           offset, len,
>> +                           PAGE_SIZE, false, metasize);
> 
> 
> Indentation is wired.

Sorry. I'll fix it.

> 
> Thanks
> 
> 
>>                   return head_skb;
>>               }
>>               break;
>>           case XDP_TX:
>>               stats->xdp_tx++;
>> +            xdp.data_meta = xdp.data;
>>               xdpf = convert_to_xdp_frame(&xdp);
>>               if (unlikely(!xdpf))
>>                   goto err_xdp;
>> @@ -921,7 +938,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>           goto err_skb;
>>       }
>>   -    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog);
>> +    head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
>> +                   metasize);
>>       curr_skb = head_skb;
>>         if (unlikely(!curr_skb))
