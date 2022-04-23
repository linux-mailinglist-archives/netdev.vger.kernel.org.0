Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EE550CB6F
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiDWOtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDWOtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:49:45 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6850F21250
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 07:46:48 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id l7so21559108ejn.2
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 07:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=5uDQPPMsTk5W1n+QET2AQT3aKlOkVlFk36DfAPXFLwY=;
        b=bx4VgBMgIxqMa5uTA+nBFx3NnuqBgeQNC5+M53Pdp83FF6w5I83pJ9VgyOvjaC70bx
         OhTfqFt6VGVJFFkoWFjC2ZoJoWwr8hbw+r2KzdIKmvUMQfBOcUFKHoAk6EPBxe+rh3D5
         prrWLJkhzRyUQHSf7HPHrrNT7uV71sqPjW0iG3Py0g5s+U+aA0Wx8zL49DSi9hvbz1Ah
         pSjGpuQfFL5g5lUZmTSEab+2Dmih+b5NH9lANiWftUQMajOAuyTf/ps5D1nWqLPGzEFf
         9JWnYQkaDRHXeUxqKCm2lY+HMgge67UqQKmV3h4E+5GjbJ3RgzY6dHJN/FZYv2aAwDIK
         Pyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=5uDQPPMsTk5W1n+QET2AQT3aKlOkVlFk36DfAPXFLwY=;
        b=GEg+6LVyZYu3WhYnopOfsZIWNkmkDBkaw9izlPuZccVhEwkf5C/g+KCKSu/Htlu+c5
         sOTb8LiEgjXzfqXNwO5/oaBVYwqPSbr7ZuZSoE8/fZdQ76WLDdduBSqvI6mAbm1mX/tW
         TniLJ1iQHtj3O01j5psYVmLHZjt+z0cDasJmRQOGdV0Qm7NLKl+T2AL435POZY58RwTl
         ucg/7ceV1TmrQBv7K9kcbLFv7gXjO+kxeyL/ay5+1xVPJ3sOIQz76xAq9T23MGuGQNwT
         W5ydbRu1QhBKza9GcRATgZvOM0zTC81IiCXWxmHOLTuBF0DF9VaY1UdQqsfrn7xsxJV6
         ayYg==
X-Gm-Message-State: AOAM530AyfFmW4Xubhpc9EIP+hGmbDU6q2k8kjIei0/C8ACi/eYTldWh
        lUCKkFIITTDQnwtc/M+V/2J9IQ==
X-Google-Smtp-Source: ABdhPJymOSpmVHDxroZCJlsNOHForVzEgS121+nl4ECu1VXW721AdsIdMBm+g4Gx7KJ7dcBqF+3eGQ==
X-Received: by 2002:a17:907:868c:b0:6f2:d939:630c with SMTP id qa12-20020a170907868c00b006f2d939630cmr6713845ejc.211.1650725206757;
        Sat, 23 Apr 2022 07:46:46 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id r3-20020aa7cb83000000b0041b573e2654sm2270648edt.94.2022.04.23.07.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 07:46:46 -0700 (PDT)
Message-ID: <89a628a2-f31c-7740-fdf1-1bc8023636cd@blackwall.org>
Date:   Sat, 23 Apr 2022 17:46:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] virtio_net: fix wrong buf address calculation when
 using xdp
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20220423112612.2292774-1-razor@blackwall.org>
 <1650720683.8168066-1-xuanzhuo@linux.alibaba.com>
 <8d511a16-8d69-82b1-48a1-24de3a592aef@blackwall.org>
 <a58bfd2c-4f83-11fe-08d1-19c1d6497fc2@blackwall.org>
In-Reply-To: <a58bfd2c-4f83-11fe-08d1-19c1d6497fc2@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/04/2022 17:30, Nikolay Aleksandrov wrote:
> On 23/04/2022 17:16, Nikolay Aleksandrov wrote:
>> On 23/04/2022 16:31, Xuan Zhuo wrote:
>>> On Sat, 23 Apr 2022 14:26:12 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>>> We received a report[1] of kernel crashes when Cilium is used in XDP
>>>> mode with virtio_net after updating to newer kernels. After
>>>> investigating the reason it turned out that when using mergeable bufs
>>>> with an XDP program which adjusts xdp.data or xdp.data_meta page_to_buf()
>>>> calculates the build_skb address wrong because the offset can become less
>>>> than the headroom so it gets the address of the previous page (-X bytes
>>>> depending on how lower offset is):
>>>>  page_to_skb: page addr ffff9eb2923e2000 buf ffff9eb2923e1ffc offset 252 headroom 256
>>>>
>>>> This is a pr_err() I added in the beginning of page_to_skb which clearly
>>>> shows offset that is less than headroom by adding 4 bytes of metadata
>>>> via an xdp prog. The calculations done are:
>>>>  receive_mergeable():
>>>>  headroom = VIRTIO_XDP_HEADROOM; // VIRTIO_XDP_HEADROOM == 256 bytes
>>>>  offset = xdp.data - page_address(xdp_page) -
>>>>           vi->hdr_len - metasize;
>>>>
>>>>  page_to_skb():
>>>>  p = page_address(page) + offset;
>>>>  ...
>>>>  buf = p - headroom;
>>>>
>>>> Now buf goes -4 bytes from the page's starting address as can be seen
>>>> above which is set as skb->head and skb->data by build_skb later. Depending
>>>> on what's done with the skb (when it's freed most often) we get all kinds
>>>> of corruptions and BUG_ON() triggers in mm[2]. The story of the faulty
>>>> commit is interesting because the patch was sent and applied twice (it
>>>> seems the first one got lost during merge back in 5.13 window). The
>>>> first version of the patch that was applied as:
>>>>  commit 7bf64460e3b2 ("virtio-net: get build_skb() buf by data ptr")
>>>> was actually correct because it calculated the page starting address
>>>> without relying on offset or headroom, but then the second version that
>>>> was applied as:
>>>>  commit 8fb7da9e9907 ("virtio_net: get build_skb() buf by data ptr")
>>>> was wrong and added the above calculation.
>>>> An example xdp prog[3] is below.
>>>>
>>>> [1] https://github.com/cilium/cilium/issues/19453
>>>>
>>>> [2] Two of the many traces:
[snip]
>>>>  drivers/net/virtio_net.c | 8 ++++++--
>>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 87838cbe38cf..0687dd88e97f 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -434,9 +434,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>>>>  	 * Buffers with headroom use PAGE_SIZE as alloc size, see
>>>>  	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
>>>>  	 */
>>>> -	truesize = headroom ? PAGE_SIZE : truesize;
>>>> +	if (headroom) {
>>>> +		truesize = PAGE_SIZE;
>>>> +		buf = (char *)((unsigned long)p & PAGE_MASK);
>>>
>>> The reason for not doing this is that buf and p may not be on the same page, and
>>> buf is probably not page-aligned.
>>>
>>> The implementation of virtio-net merge is add_recvbuf_mergeable(), which
>>> allocates a large block of memory at one time, and allocates from it each time.
>>> Although in xdp mode, each allocation is page_size, it does not guarantee that
>>> each allocation is page-aligned .
>>>
>>> The problem here is that the value of headroom is wrong, the package is
>>> structured like this:
>>>
>>> from device    | headroom          | virtio-net hdr | data |
>>> after xdp      | headroom  |  virtio-net hdr | meta | data |
>>
>> You're free to push data back (not necessarily through meta).
>> You don't have virtio-net hdr for the xdp case (hdr_valid is false there).
>>
>>>
>>> The page_address(page) + offset we pass to page_to_skb() points to the
>>> virtio-net hdr.
>>>
>>> So I think it might be better to change it this way.
>>>
>>> Thanks.
>>>
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index 87838cbe38cf..086ae835ec86 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -1012,7 +1012,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>                                 head_skb = page_to_skb(vi, rq, xdp_page, offset,
>>>                                                        len, PAGE_SIZE, false,
>>>                                                        metasize,
>>> -                                                      VIRTIO_XDP_HEADROOM);
>>> +                                                      VIRTIO_XDP_HEADROOM - metazie);
>>>                                 return head_skb;
>>>                         }
>>>                         break;
>>
>> That patch doesn't fix it, as I said with xdp you can move both data and data_meta.
>> So just doing that would take care of the meta, but won't take care of moving data.
>>
> 
> Also it doesn't take care of the case where page_to_skb() is called with the original page
> i.e. when we already have headroom, so we hit the next/standard page_to_skb() call (xdp_page == page).
> 
> The above change guarantees that buf and p will be in the same page and the skb_reserve() call will
> make skb->data point to p - buf, i.e. to the beginning of the valid data in that page.
> Unfortunately the new headroom will not be correct if it is a frag, it will be longer.
> 
> 

Completely untested alternative could be based on the offset size, that is if it has
eaten into the headroom and is smaller then we swap them (that means we start at page
boundary since we have headroom guaranteed space):
 buf = page_address(page) + (offset > headroom ? offset - headroom : 0);

or perhaps in current code terms:
 buf = p - (offset > headroom ? headroom : offset);

That means offset is somewhere inside the headroom of the buf and, the buf itself
starts at page boundary (when offset < headroom). I think this preserves the correct
headroom for the new skb. WDYT?

Cheers,
 Nik



