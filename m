Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB5367506F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjATJPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjATJPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:15:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6A8B77C
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674205981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZPeR4ezySQsDIGM6vL70GUntxVZdDTQ3/O5g5jnGLyE=;
        b=iI8wldgBIsPVYH8QnoLEvkhqj4MrmkTGl4yySxVZHjeWCe3tjinmoHuSjzM2gq42eG3JxL
        +iAaIZfzbBRiVqyccvZp8RtKcxUddq2P2KmNb9LScxIcfYxCCpCRSP+83IGlxnD8x6QDgc
        4YbyuwswY7G1zKAnimk+rdmQRaQotl0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-375-_OeKHXVAPv6t2lwbsh-ARw-1; Fri, 20 Jan 2023 04:09:44 -0500
X-MC-Unique: _OeKHXVAPv6t2lwbsh-ARw-1
Received: by mail-ej1-f69.google.com with SMTP id du14-20020a17090772ce00b0087108bbcfa6so3391499ejc.7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:09:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZPeR4ezySQsDIGM6vL70GUntxVZdDTQ3/O5g5jnGLyE=;
        b=TNXrKM3oVsJ1SQD1JToRWbfFlvL3vk+e7T6bNjfjqzPONEMT/mutHtsWkMxw0AN6AL
         wshASsckQxqpCF/ZcEsE4rtX04h0vr9TKUd/APNeVVmoF7W6XbHQ80NqjS/0HPEVRJd6
         KaDbQHjNjYx+99fLpldHoHNwYd/ojy1b9gKxHnrVf6Dy25bVjzsrPX1waG3d41IwhtgP
         Ps2lIt2VYI261MpLV21ZTwb61Hw467lIw2iz9h7GwAMSjMmr3RxZganvvbTmYGKVyn7Q
         p1BwVj+Zpu1XjnQv7VcNPNnvZNU007UJNluCESFamyiNLCu1iWV/sahPHaF8dBTJEiRw
         nX2w==
X-Gm-Message-State: AFqh2ko3txm0ph01+WfexFk/JqlfwioYeMPVXwT7Mdndc6b0e0Slf4OS
        Afj/yaVkL6KY+gltNx9IGWj7swliTedwXzo7lKfoMGFHzx3V5kBQ2nVLAPLrK0oUNVcuj5np9eG
        vWhy2cF6G/wWwxrE6
X-Received: by 2002:a17:907:2982:b0:7c1:23f2:c052 with SMTP id eu2-20020a170907298200b007c123f2c052mr8244514ejc.45.1674205783797;
        Fri, 20 Jan 2023 01:09:43 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsQkUv9iZG2NFyXt3zMEzhO/30xUaSr/PocZ3T0Gedu/vtGto8J/OUS3WLYXJXduBV8NjQpYg==
X-Received: by 2002:a17:907:2982:b0:7c1:23f2:c052 with SMTP id eu2-20020a170907298200b007c123f2c052mr8244500ejc.45.1674205783555;
        Fri, 20 Jan 2023 01:09:43 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id kx1-20020a170907774100b0084d368b1628sm16387373ejc.40.2023.01.20.01.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 01:09:42 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d5c66d86-23e0-b786-5cba-ae9c18a97549@redhat.com>
Date:   Fri, 20 Jan 2023 10:09:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] net: fix kfree_skb_list use of
 skb_mark_not_on_list
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
References: <167415060025.1124471.10712199130760214632.stgit@firesoul>
 <CANn89iJ8Vd2V6jqVdMYLFcs0g_mu+bTJr3mKq__uXBFg1K0yhA@mail.gmail.com>
In-Reply-To: <CANn89iJ8Vd2V6jqVdMYLFcs0g_mu+bTJr3mKq__uXBFg1K0yhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/01/2023 19.04, Eric Dumazet wrote:
> On Thu, Jan 19, 2023 at 6:50 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>>
>> A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
>> kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
>> invoking skb_mark_not_on_list().
>>
>> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
>> returns true, meaning the SKB is ready to be free'ed, as it calls/check
>> skb_unref().
>>
>> This is needed as kfree_skb_list() is also invoked on skb_shared_info
>> frag_list. A frag_list can have SKBs with elevated refcnt due to cloning
>> via skb_clone_fraglist(), which takes a reference on all SKBs in the
>> list. This implies the invariant that all SKBs in the list must have the
>> same refcnt, when using kfree_skb_list().
> 
> Yeah, or more precisely skb_drop_fraglist() calling kfree_skb_list()
> 
>>
>> Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
>> Reported-and-tested-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
>> Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   net/core/skbuff.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 4e73ab3482b8..1bffbcbe6087 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -999,10 +999,10 @@ kfree_skb_list_reason(struct sk_buff *segs, enum skb_drop_reason reason)
>>          while (segs) {
>>                  struct sk_buff *next = segs->next;
>>
>> -               skb_mark_not_on_list(segs);
>> -
>> -               if (__kfree_skb_reason(segs, reason))
>> +               if (__kfree_skb_reason(segs, reason)) {
>> +                       skb_mark_not_on_list(segs);
> 
> Real question is : Why do we need to set/change/dirt skb->next ?
> 
> I would remove this completely, and save extra cache lines dirtying.

First of all, we just read this cacheline via reading segs->next.
This cacheline must as minimum be in Shared (S) state.

Secondly SLUB will write into this cacheline. Thus, we actually know 
that this cacheline need to go into Modified (M) or Exclusive (E).
Thus, writing into it here should be okay.  We could replace it with a 
prefetchw() to help SLUB get Exclusive (E) cache coherency state.

> Before your patch, we were not calling skb_mark_not_on_list(segs),
> so why bother ?

To catch potential bugs.


> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4e73ab3482b87d81371cff266627dab646d3e84c..180df58e85c72eaa16f5cb56b56d181a379b8921
> 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -999,8 +999,6 @@ kfree_skb_list_reason(struct sk_buff *segs, enum
> skb_drop_reason reason)
>          while (segs) {
>                  struct sk_buff *next = segs->next;
> 
> -               skb_mark_not_on_list(segs);
> -
>                  if (__kfree_skb_reason(segs, reason))
>                          kfree_skb_add_bulk(segs, &sa, reason);
> 

