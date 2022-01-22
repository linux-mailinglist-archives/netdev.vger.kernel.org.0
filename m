Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D34F496B04
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 09:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233135AbiAVIb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 03:31:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232958AbiAVIb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 03:31:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642840286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jCimr63v8CEPF1zIfZIJt01XQ0IyOhIWO0SMYz9s+Rg=;
        b=HqkRc3fEFXT5TQSfjK4pS+IhO7KqvS2VP4AmLTeB95lPLOvzt/s3f3F71YrlE6wKA0ce4/
        yOuiPc7q18/HFtwwVi8BNZpLpWcyOhSezdkd3Th/0gSQ4kfonrQPssR76oytHYBMBglR2r
        ID+fiYGfNDRHiUAkrMx3O9eIKYqG0bw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-ITA31kLTOne9-2bOjPOfAg-1; Sat, 22 Jan 2022 03:31:21 -0500
X-MC-Unique: ITA31kLTOne9-2bOjPOfAg-1
Received: by mail-lj1-f199.google.com with SMTP id l7-20020a2e9087000000b00236c156bf9bso426023ljg.2
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 00:31:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=jCimr63v8CEPF1zIfZIJt01XQ0IyOhIWO0SMYz9s+Rg=;
        b=dR9vORxmNj/0OPv4acWDdHMALupux+XuT2+5b37h8RaeTjeRuMIs3y2QPld+LMkI+j
         DiA/ib+KJCXvxiII/yIkRtcnzuqQZ5/oJgN1h2VHS+oc/8NJOCrurONFB3SitYJPibR/
         X2O/te1qQzO0CRjS3EeU4iixRwgMGWRAmiu4tb5WJC/6V3ZZWkr7H57AekCyfKRrs1FA
         hndcJgxxPxwh0Az3yz3cMtGy0Xq1nek77Z6lO2pOoIpMs652JiWlFpN1skOsQV+2oaYe
         OeZ2kBLbhh19AI/tHhiw9YIGKQfFwU1Dp3UhL7i3Kr+Z6UEbeQ8uvlppuv1YmUV/EQs2
         NS3w==
X-Gm-Message-State: AOAM533RRQkcJjleEwDrZZ9EOCFO3Ya1DXMJ9pnP+nAEfkaKxTZdyzEl
        fCEm0imgW9UydyRU52ovA8qoJge6EqH+QG1fRXh70NBESl2x6bemrJDNd6gdhavsQugADLs4HJ0
        q1uolAvPxHyklV5IF
X-Received: by 2002:a05:6512:3f9f:: with SMTP id x31mr6454748lfa.391.1642840279845;
        Sat, 22 Jan 2022 00:31:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz0D9mLT48oagApjNXUtIGHXX+OV4Zfpp2S4ieJGhsRdBvoOn+TY1JNX2UZMUSKJkkpz8+ATw==
X-Received: by 2002:a05:6512:3f9f:: with SMTP id x31mr6454741lfa.391.1642840279670;
        Sat, 22 Jan 2022 00:31:19 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id n21sm497430lfe.153.2022.01.22.00.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 00:31:18 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <5bd8f1bd-1a21-df1b-6d6f-9fe5657fdd7c@redhat.com>
Date:   Sat, 22 Jan 2022 09:31:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [net RFC v1 1/1] page_pool: fix NULL dereference crash
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
References: <20220122005644.802352-1-colin.foster@in-advantage.com>
 <20220122005644.802352-2-colin.foster@in-advantage.com>
 <CAADnVQK8xrQ92+=wm8AoDkC93SEKz3G=CoOnkPgvs=spJk5UZA@mail.gmail.com>
 <20220122024051.GA905413@euler>
In-Reply-To: <20220122024051.GA905413@euler>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22/01/2022 03.40, Colin Foster wrote:
> On Fri, Jan 21, 2022 at 05:13:28PM -0800, Alexei Starovoitov wrote:
>> On Fri, Jan 21, 2022 at 4:57 PM Colin Foster
>> <colin.foster@in-advantage.com> wrote:
>>>
>>> Check for the existence of page pool params before dereferencing. This can
>>> cause crashes in certain conditions.
>>
>> In what conditions?
>> Out of tree driver?
>>
>>> Fixes: 35b2e549894b ("page_pool: Add callback to init pages when they are
>>> allocated")
>>>
>>> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
>>> ---
>>>   net/core/page_pool.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>> index bd62c01a2ec3..641f849c95e7 100644
>>> --- a/net/core/page_pool.c
>>> +++ b/net/core/page_pool.c
>>> @@ -213,7 +213,7 @@ static void page_pool_set_pp_info(struct page_pool *pool,
>>>   {
>>>          page->pp = pool;
>>>          page->pp_magic |= PP_SIGNATURE;
>>> -       if (pool->p.init_callback)
>>> +       if (pool->p && pool->p.init_callback)
> 
> And my apologies - this should be if (pool... not if (pool->p. kernelbot
> will be sure to tell me of this blunder soon

Can you confirm if your crash is fixed by this change?


>>>                  pool->p.init_callback(page, pool->p.init_arg);
>>>   }

