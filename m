Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D623C6736AD
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjASLXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjASLXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:23:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BF84672E
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674127373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aXq6c/f6h4+BTiTZpR3vtWniE9wxo1DhZWWIoClGUPw=;
        b=GDzIWx6d42Ks/6qR97o4M6P2j7lEkHnnwniz0SfGM6viUxsgZU5brx46GHxOlM1Dc/q5ZN
        myvNP+wYuiyLnK+eji1X1hGVKzROJip88nkXeJ1uAsD646SoRrGLFoCzGdCtDqoI7UiYmL
        f8A9CbdByz5CSdCliwtPtQhbq/qbKBw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-_KHWMwj7OlidawfIU-pjRA-1; Thu, 19 Jan 2023 06:22:43 -0500
X-MC-Unique: _KHWMwj7OlidawfIU-pjRA-1
Received: by mail-ej1-f71.google.com with SMTP id jg2-20020a170907970200b0086ee94381fbso1390729ejc.2
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 03:22:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aXq6c/f6h4+BTiTZpR3vtWniE9wxo1DhZWWIoClGUPw=;
        b=D4VW2da1zaLhcA024luFlNpv+Jxi6ZSEPzNbZRDb6ea9rhbxxx1D6ZvzWMWiirmOiv
         3agN1wvlaanatjS7s3ZI64XQi4yT+4uKD9jpQ/0iGX3e9pIUDpCBY2MNYEdFrdtdlEim
         Lh//MGG0vX+aOe0YyY0knwy//Al4M2Z1G2cMl6xqXrCaAhT8W+pw9XJQ8wB/pQWJ6WDG
         BaAwphOWvbnbvmMyYhbsaPEJb7bsQRfINUPn0nkc/sxRxhzPXkKyuoacY95ZLn0R7G6j
         W/RaEiimi0TzeLAf4YhP5X4BdJeThnP0oS7Dl+qghWgeu6oZAakUM3HRC6wnERsOq+Ym
         /5eg==
X-Gm-Message-State: AFqh2kqj2v5gVfobOKKWb5S9jERWF0uHRGTMxV2gNYmMMQrAUrADHcNQ
        P/plV7CSvI/TmuEnMSvtxikS28tVHtSsYjBIlEyi1o3hDJ5RqqXucVpgii52DJRfz8sY54XFOkv
        AW3a6zTdsodGdOqTy
X-Received: by 2002:a05:6402:e94:b0:47e:d7ea:d980 with SMTP id h20-20020a0564020e9400b0047ed7ead980mr10390674eda.14.1674127360001;
        Thu, 19 Jan 2023 03:22:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtJL51gEaJ6MOGdGttqFOnjDKacmokHb2lva48GkUlnfzl1ZTRxJIY2jHVNr98Zv+LMF6pFAQ==
X-Received: by 2002:a05:6402:e94:b0:47e:d7ea:d980 with SMTP id h20-20020a0564020e9400b0047ed7ead980mr10390665eda.14.1674127359803;
        Thu, 19 Jan 2023 03:22:39 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id ew7-20020a056402538700b0049b58744f93sm9021653edb.81.2023.01.19.03.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 03:22:39 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d0ecbed5-0588-9624-7ecb-014a3bebf192@redhat.com>
Date:   Thu, 19 Jan 2023 12:22:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        pabeni@redhat.com
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul>
 <6f634864-2937-6e32-ba9d-7fa7f2b576cb@redhat.com>
 <20230118182600.026c8421@kernel.org>
 <e564a0de-e149-34a0-c0ba-8f740df0ae70@redhat.com>
 <CANn89iJPm30ur1_tE6TPU-QYDGqszavhtm0vLt2MyK90MYFA3A@mail.gmail.com>
In-Reply-To: <CANn89iJPm30ur1_tE6TPU-QYDGqszavhtm0vLt2MyK90MYFA3A@mail.gmail.com>
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



On 19/01/2023 11.28, Eric Dumazet wrote:
> On Thu, Jan 19, 2023 at 11:18 AM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>>
>> On 19/01/2023 03.26, Jakub Kicinski wrote:
>>> On Wed, 18 Jan 2023 22:37:47 +0100 Jesper Dangaard Brouer wrote:
>>>>> +           skb_mark_not_on_list(segs);
>>>>
>>>> The syzbot[1] bug goes way if I remove this skb_mark_not_on_list().
>>>>
>>>> I don't understand why I cannot clear skb->next here?
>>>
>>> Some of the skbs on the list are not private?
>>> IOW we should only unlink them if skb_unref().
>>
>> Yes, you are right.
>>
>> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
>> returns true, meaning the SKB is ready to be free'ed (as it calls/check
>> skb_unref()).
> 
> 
> This was the case already before your changes.
> 
> skb->next/prev can not be shared by multiple users.
> 
> One skb can be put on a single list by definition.
> 
> Whoever calls kfree_skb_list(list) owns all the skbs->next|prev found
> in the list
> 
> So you can mangle skb->next as you like, even if the unref() is
> telling that someone
> else has a reference on skb.

Then why does the bug go way if I remove the skb_mark_not_on_list() call 
then?

>>
>> I will send a proper fix patch shortly... after syzbot do a test on it.
>>

I've send a patch for syzbot that only calls skb_mark_not_on_list() when 
unref() and __kfree_skb_reason() "permits" this.
I tested it locally with reproducer and it also fixes/"removes" the bug.

--Jesper

