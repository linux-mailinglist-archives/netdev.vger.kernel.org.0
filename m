Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7683A06FC
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 00:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhFHWji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 18:39:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43387 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235005AbhFHWjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 18:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623191863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ZbqZA/8gJY2hDLGy844pJ9jlRQOVxQQ+Lr9OCxPWbQ=;
        b=asjxBNEPFg+BCgEXduV3+hOHsAIBTJqydzt7/nzs9tsqybj38GRrfMB6vsW3iVWkn+JeLc
        igTthj8wV1KI7UBfTLOVObhoWFG5y8yjpBxYxu5Vyty5f23Q/amtZpE8vyh5LpeGuQrYFL
        jGDkEwcXeE346gQonpDVXW/LLVE3rGo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-aanbR0LVMUSRrXceZ3l2tw-1; Tue, 08 Jun 2021 18:37:42 -0400
X-MC-Unique: aanbR0LVMUSRrXceZ3l2tw-1
Received: by mail-qk1-f197.google.com with SMTP id o5-20020a05620a22c5b02903aa5498b6f8so10054393qki.5
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 15:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0ZbqZA/8gJY2hDLGy844pJ9jlRQOVxQQ+Lr9OCxPWbQ=;
        b=aVl0SP/vmLTiNNYkSFuNFjXscXCoMgTeH8eSb2rhKwnuydZab+E4kf4VdSfNplsLep
         wZW30I6dFqizSDv6HD4S5gtIkg28VcRPrhBRpLtHLM9L0Ofry54+DxXwSt9BSY2zDdYJ
         cbsxvVryHbkN/f82nQBJtKIRmwSvIWNmPSeUSoHbPTVMg2Y8NgNETvgN9+yTYT3Dle9t
         NkZf/40YlAqOHFDoE50nQvlJHus8Er6h2hCV0B5ot9Iqinc8SgxcD2VYy3Pa32R2sBFq
         J7370LCrk/myl0+uhXjH5BEOIO3ytfLoU4LRqP7iHl12tVomZMowU3eRPoz4sD5a+8Jg
         GJdQ==
X-Gm-Message-State: AOAM532Xz9u4UDYkgz4etO63iiCtayfTm+Jg5u+F43vGsmnbRGXiLoQ1
        KM83PEHwaZu4eBpC57b1hHgOQwiXM4ElyVnb3QJeN6PldhdxJgLg2gUzuu7a7baZvMUg8ufz2ry
        zOrQMmdtnnJV2qI3v
X-Received: by 2002:a0c:e047:: with SMTP id y7mr2763918qvk.46.1623191861238;
        Tue, 08 Jun 2021 15:37:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzN3+8jezv+uBmSCAiZeWBmG/9g55nu0g8Xgb648WprNmsOozNnN12ovngdJP8/5aogFVeXsQ==
X-Received: by 2002:a0c:e047:: with SMTP id y7mr2763897qvk.46.1623191860991;
        Tue, 08 Jun 2021 15:37:40 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id u26sm11513815qtf.24.2021.06.08.15.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 15:37:40 -0700 (PDT)
Subject: Re: [PATCH net-next] net: tipc: fix FB_MTU eat two pages
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Menglong Dong <dong.menglong@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20210604074419.53956-1-dong.menglong@zte.com.cn>
 <e997a058-9f6e-86a0-8591-56b0b89441aa@redhat.com>
 <CADxym3ZostCAY0GwUpTxEHcOPyOj5Lmv4F7xP-Q4=AEAVaEAxw@mail.gmail.com>
 <998cce2c-b18d-59c1-df64-fc62856c63a1@redhat.com> <20210607125120.GA4262@www>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <46d2a694-6a85-0f8e-4156-9bb1c4dbdb69@redhat.com>
Date:   Tue, 8 Jun 2021 18:37:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210607125120.GA4262@www>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/21 8:51 AM, Menglong Dong wrote:
> On Sat, Jun 05, 2021 at 10:25:53AM -0400, Jon Maloy wrote:
>>
>> On 6/4/21 9:28 PM, Menglong Dong wrote:
>>> Hello Maloy,
>>>
>>> On Sat, Jun 5, 2021 at 3:20 AM Jon Maloy <jmaloy@redhat.com> wrote:

>>>> [...]
>>>
>>> So if I use the non-crypto version, the size allocated will be:
>>>
>>>    PAGE_SIZE - BUF_HEADROOM_non-crypto - BUF_TAILROOM_non-crypt +
>>>      BUF_HEADROOM_crypto + BUF_TAILROOM_crypto
>>>
>>> which is larger than PAGE_SIZE.
>>>
>>> So, I think the simple way is to define FB_MTU in 'crypto.h'. Is this
>>> acceptable?
>>>
>>> Thanks!
>>> Menglong Dong
>>>

I spent a little more time looking into this. I think the best we can do 
is to keep FB_MTU internal to msg.c, and then add an outline function to 
msg.c that can be used by bcast.c. The way it is used is never time 
critical.

I also see that we could need a little cleanup around this. There is a 
redundant align() function that should be removed and replaced with the 
global ALIGN() macro.
Even tipc_buf_acquire() should use this macro instead of the explicit 
method that is used now.
In general, I stongly dislike conditional code, and it is not necessary 
in this function. If we redefine the non-crypto BUF_TAILROOM to 0 
instead of 16 (it is not used anywhere else) we could get rid of this too.

But I leave that to you. If you only fix the FB_MTU macro I am content.

///jon

