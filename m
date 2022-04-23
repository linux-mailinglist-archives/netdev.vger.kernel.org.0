Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F49F50CBDA
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiDWPid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiDWPi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:38:26 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CCB26F4
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:35:28 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id el3so8940548edb.11
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=o/CJ5WWEETXK69oPoyBSWz7VeMGOtK+lSlLywL1D9Nk=;
        b=BE3VvQpPCKWlIFjbA3lVG7mn7VcetLMgpTQeJFc6keKzpdsTRzAdiruWx3JIgEoCdB
         COovHQS6riaiG6GDioqj2MVosUXmiVj/GfhxtDEn51EtX3HGSCd1Fu0mdPvJANsLhMc1
         NhSUikBjtpDdsA62BxR1jH+SZqACfkrVSk2yTgfEK72AHBHspklM3hHbC3o6upvGXpdu
         ZiB1Uh/pLD4/jH7wKdgElUN3kMDCtRXmPtys1UQSqOSmcF4ILo5Z5zauUHx3LrsoNmBP
         Up3XYD7er2+fkF3WwuKbPNhDh4Jov5a17GpbEkpj8qBpEoYuqGoIsUxERDX5NZBrNS15
         5y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=o/CJ5WWEETXK69oPoyBSWz7VeMGOtK+lSlLywL1D9Nk=;
        b=GMKu5Mx3uVqnJU7katHKbTlJT00eQmuMOlcijYnltBfvj+wM8M5gosW31IB3GBTxIR
         dOJcPtEUCNS9icLnZZ21X3rDwgwpeR4ns5nP9FKzyYTE/QVKAT9zuBE6e1pYpi43fyWI
         bsiMXf5WkyRI3wnTBd2PUteMmoWM2zfare3dRp1WxG23p0fGhjmqfgIz6Hky2vmQ3N2X
         BrHaWPJcQV8OHMTxRzKMaqRSWUI6eFUq44Ee9108lzLh8laNdh3f4ZC5XlakxMqyZCkg
         TZ7sFFGVEzo/rnfrGGW6y0mqrUD0aJT8poGLJ28/wzuNbVnD6nuTCDo2aSqjUptRdhIA
         CQZg==
X-Gm-Message-State: AOAM5337EoNrqFNf/L9SoljhrkC9ksNB3ncPbbTlWtIIOJDZfAIb/kwo
        cXVe1mO0mdBhmPOhX0zmKbhYgPm5UfJiOmkH
X-Google-Smtp-Source: ABdhPJxFI9jbc24y64+cuaiBnirbclKSmsPpxv/8DfB0P4w7IIklyDTTiU+OBAHP6TmH1ZYIuNgIJg==
X-Received: by 2002:aa7:dd87:0:b0:425:c104:71bf with SMTP id g7-20020aa7dd87000000b00425c10471bfmr8179979edv.110.1650728127336;
        Sat, 23 Apr 2022 08:35:27 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906520f00b006cd07ba40absm1763359ejm.160.2022.04.23.08.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 08:35:26 -0700 (PDT)
Message-ID: <c7e49737-c5f8-5164-88ad-599c828c5d23@blackwall.org>
Date:   Sat, 23 Apr 2022 18:35:25 +0300
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
 <1650724608.256497-2-xuanzhuo@linux.alibaba.com>
 <c206c147-ad7e-b615-2e96-572482335563@blackwall.org>
 <1650726113.2334588-1-xuanzhuo@linux.alibaba.com>
 <ff95db6e-5a0a-7e63-080f-c719ac434c34@blackwall.org>
In-Reply-To: <ff95db6e-5a0a-7e63-080f-c719ac434c34@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/04/2022 18:23, Nikolay Aleksandrov wrote:
> On 23/04/2022 18:01, Xuan Zhuo wrote:
>> On Sat, 23 Apr 2022 17:58:05 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> On 23/04/2022 17:36, Xuan Zhuo wrote:
>>>> On Sat, 23 Apr 2022 17:30:11 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>>>> On 23/04/2022 17:16, Nikolay Aleksandrov wrote:
>>>>>> On 23/04/2022 16:31, Xuan Zhuo wrote:
>>>>>>> On Sat, 23 Apr 2022 14:26:12 +0300, Nikolay Aleksandrov <razor@blackwall.org> wrote:
[snip]
>>>>>>> +                                                      VIRTIO_XDP_HEADROOM - metazie);
>>>>>>>                                 return head_skb;
>>>>>>>                         }
>>>>>>>                         break;
>>>>>>
>>>>>> That patch doesn't fix it, as I said with xdp you can move both data and data_meta.
>>>>>> So just doing that would take care of the meta, but won't take care of moving data.
>>>>>>
>>>>>
>>>>> Also it doesn't take care of the case where page_to_skb() is called with the original page
>>>>> i.e. when we already have headroom, so we hit the next/standard page_to_skb() call (xdp_page == page).
>>>>
>>>> Yes, you are right.
>>>>
>>>>>
>>>>> The above change guarantees that buf and p will be in the same page
>>>>
>>>>
>>>> How can this be guaranteed?
>>>>
>>>> 1. For example, we applied for a 32k buffer first, and took away 1500 + hdr_len
>>>>    from the allocation.
>>>> 2. set xdp
>>>> 3. alloc for new buffer
>>>>
>>>
>>> p = page_address(page) + offset;
>>> buf = p & PAGE_MASK; // whatever page p lands in is where buf is set
>>>
>>> => p and buf are always in the same page, no?
>>
>> I don't think it is, it's entirely possible to split on two pages.
>>
>>>
>>>> The buffer allocated in the third step must be unaligned, and it is entirely
>>>> possible that p and buf are not on the same page.
>>>>
>>>> I fixed my previous patch.
>>>>
>>>> Thanks.
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 87838cbe38cf..d95e82255b94 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -1005,6 +1005,8 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>>                          * xdp.data_meta were adjusted
>>>>                          */
>>>>                         len = xdp.data_end - xdp.data + vi->hdr_len + metasize;
>>>> +
>>>> +                       headroom = xdp.data - vi->hdr_len - metasize - (buf - headroom);
>>>
>>> This is wrong, xdp.data isn't related to buf in the xdp_linearize_page() case.
>>
>> Yes, you are right. For the case of xdp_linearize_page() , we should change it.
>>
>>    headroom = xdp.data - vi->hdr_len - metasize - page_address(xdp_page);
>>
>> Thanks.
>>
> 
> That is equal to offset:
>                        offset = xdp.data - page_address(xdp_page) -
>                                  vi->hdr_len - metasize;
> 
> So I do agree that it will work, it is effectively what I also suggested in the
> other email and it will be equal to just doing buf = page_address() in the xdp_linearize
> case because p = page_address + offset, and now we do buf = p - headroom where headroom also
> equals offset, so we get buf = page_address().
> 

All of the above is equivalent to:
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 87838cbe38cf..12e88980e4b3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1012,8 +1012,10 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
                                head_skb = page_to_skb(vi, rq, xdp_page, offset,
                                                       len, PAGE_SIZE, false,
                                                       metasize,
-                                                      VIRTIO_XDP_HEADROOM);
+                                                      offset);
                                return head_skb;
+                       } else {
+                               headroom = xdp.data - (buf - headroom) - vi->hdr_len - metasize;
                        }
                        break;
                case XDP_TX:

I agree with that, it is also equivalent to my proposal in the other email. It adjusts the new
headroom after the xdp prog which is ok. I'll wait (and test it in the meantime) for other
feedback and if all agree I'll post v2.

>>
>>>
>>>>                         /* We can only create skb based on xdp_page. */
>>>>                         if (unlikely(xdp_page != page)) {
>>>>                                 rcu_read_unlock();
>>>> @@ -1012,7 +1014,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>>>>                                 head_skb = page_to_skb(vi, rq, xdp_page, offset,
>>>>                                                        len, PAGE_SIZE, false,
>>>>                                                        metasize,
>>>> -                                                      VIRTIO_XDP_HEADROOM);
>>>> +                                                      headroom);
>>>>                                 return head_skb;
>>>>                         }
>>>>                         break;
>>>
> 

