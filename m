Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9BE50CC07
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiDWP6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiDWP6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:58:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254CFE9B
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:55:55 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z99so13774788ede.5
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QnKErwSXat4qexxkmNgihC1z6Q4C1GOP8emnalj3zKY=;
        b=OQKqojjRu/6u2nGcFEzeCbF7WQb9pnrfzXoQLTFHY3iuQOBh4rLzAt+C8QvI7zj6DA
         NTG/CZybdXl4Y55ZPVjGogIBNN4gJn6vO3kCOsmgtZCaaTB9IEqZxVX+nTyH0U8dno87
         DYJ/FkS0l++SrLFuJZ8n4kXnu4fykqSFg3V9hUF9kw8CJl3UJkNu2ZC6zmS80Ry/8voK
         CnX5Czhm+1GPrfIXrWJaFqCHUapQ1fl7aNqyw8W82yDiyDpTcktu37FCp+iUDpkD6DZx
         dxbHKzQhUemRqGCi3DBtFIiexp2gTZHClgFbdm5vpMVJ0AU5/Rjf0ajdWhkwKTTkP2ZI
         KplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QnKErwSXat4qexxkmNgihC1z6Q4C1GOP8emnalj3zKY=;
        b=L1V3D8nQg5mgMh2iCqjlcDufy5NBzF1Wl/1gO5hgrMMF7a4cjPGFeeAI/0/BeKWOze
         0WkXeILzxQujeCykioSSWuxCFrQEn0LBjWFjkxisGlxsbf52mRqgS4BmJca6zMwJzG6k
         o2MYN4S3bdnL2uG14Dkd/1V3LBk4w5XFKbdb5yOcB4l+7GwcOkw0eBnNJ70JWQxqDK6B
         XQslXeUwye6UfevXiz97HequdaHTkSovQ6wp4eDI1F8H19HghZuMGsCTr1M35j+/0hZp
         +soj3OvjuH/PWh1Pxo7ND3hbNnuBIW040LhXatATkObGtI9ZPiXY6zx5AtegX9D2d717
         zsuw==
X-Gm-Message-State: AOAM533Tz05m7Scve0LUT1JRRLM+Z34Tb/Y7YLElLuBBzkobSZxeEuoc
        Iw9jiZVc0WoPGf6lXYqx8RuoLA==
X-Google-Smtp-Source: ABdhPJwGZhxtcU/CjjffaxobWl86iaqzRUjZp8xTahkgEnX3UO8k/6sfG2jNT3wExUAZ7uSST2P8Hw==
X-Received: by 2002:a05:6402:3587:b0:423:fcf6:e979 with SMTP id y7-20020a056402358700b00423fcf6e979mr10703888edc.137.1650729353673;
        Sat, 23 Apr 2022 08:55:53 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id kx5-20020a170907774500b006e1382b8192sm1806933ejc.147.2022.04.23.08.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 08:55:53 -0700 (PDT)
Message-ID: <9e7db66d-8925-be38-c740-b7e3d21c2060@blackwall.org>
Date:   Sat, 23 Apr 2022 18:55:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] virtio_net: fix wrong buf address calculation when
 using xdp
Content-Language: en-US
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
 <1650724608.256497-2-xuanzhuo@linux.alibaba.com>
 <c206c147-ad7e-b615-2e96-572482335563@blackwall.org>
 <1650726113.2334588-1-xuanzhuo@linux.alibaba.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <1650726113.2334588-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/04/2022 18:01, Xuan Zhuo wrote:
> On Sat, 23 Apr 2022 17:58:05 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> On 23/04/2022 17:36, Xuan Zhuo wrote:
>>> On Sat, 23 Apr 2022 17:30:11 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>>> On 23/04/2022 17:16, Nikolay Aleksandrov wrote:
>>>>> On 23/04/2022 16:31, Xuan Zhuo wrote:
>>>>>> On Sat, 23 Apr 2022 14:26:12 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
[snip]                                   metasize,
>>>>>> -                                                      VIRTIO_XDP_HEADROOM);
>>>>>> +                                                      VIRTIO_XDP_HEADROOM - metazie);
>>>>>>                                 return head_skb;
>>>>>>                         }
>>>>>>                         break;
>>>>>
>>>>> That patch doesn't fix it, as I said with xdp you can move both data and data_meta.
>>>>> So just doing that would take care of the meta, but won't take care of moving data.
>>>>>
>>>>
>>>> Also it doesn't take care of the case where page_to_skb() is called with the original page
>>>> i.e. when we already have headroom, so we hit the next/standard page_to_skb() call (xdp_page == page).
>>>
>>> Yes, you are right.
>>>
>>>>
>>>> The above change guarantees that buf and p will be in the same page
>>>
>>>
>>> How can this be guaranteed?
>>>
>>> 1. For example, we applied for a 32k buffer first, and took away 1500 + hdr_len
>>>    from the allocation.
>>> 2. set xdp
>>> 3. alloc for new buffer
>>>
>>
>> p = page_address(page) + offset;
>> buf = p & PAGE_MASK; // whatever page p lands in is where buf is set
>>
>> => p and buf are always in the same page, no?
> 
> I don't think it is, it's entirely possible to split on two pages.
> 

Ahhh, I completely misinterpreted page_address(). You're right.


