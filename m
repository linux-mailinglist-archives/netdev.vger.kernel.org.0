Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED20C44D9BA
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 17:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234046AbhKKQES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 11:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbhKKQER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 11:04:17 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2535FC0613F5
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:01:28 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 136so883073pgc.0
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 08:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7wfDHiPejbS6tDQijlCtZbth9NfDRjzLAZP+AtCVvZk=;
        b=WJnf3KMp3asJehyM7Bx3fguusBmvh/1/FoyX09dTZhMVRf11bVdfg603H7tjOHf6NG
         3ll0hA8q7lUgamTugnuygz6LAfiSsYtNLGX0C8Ux2HKznUe9+GIg3JO8QucK7KRFew1g
         rQT0Y481E0ItBtfq29i4aXXk+7Y83b7tZ7FsRSyjKGoqcUDBiHBGMo3DAiVFwySpiniO
         o7fD/422sV00SY3f3IkCJVklAoRpc1y1ztmfSkka1+6KMsr4jMkO76mAaDBV31PNqwOW
         63kVJwud9VMjv+2gKe7oQ0I9vy79RqlkhxZEON6VpYcu5IPrC0rsjdIo31qg7IwXJTrw
         oD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7wfDHiPejbS6tDQijlCtZbth9NfDRjzLAZP+AtCVvZk=;
        b=AmNxN57pX/q3aLignjJs2BchAyey1nHBjU2ctA6wsyldHr5gyKlND9YS6atSpHCl05
         WLqBbpYuSVdZPjBjWv/uluUWKM8BrQz56FGXhmKNHd5cyVJi/v/0tMhVnUdGYEpXnczC
         ytnRTdqXiB+Ql8CvUZnGxO7vTU/0IhiwBgPK9rT9o9wCZfhdVu4iAMybK1UcOHOjB0R/
         kVHzCDJlpDU/+bqGUSA/Hm19z4JvVSdy84CfDgiBsk1S1A2uOWQYqzmoSQ46x+ZkGuHV
         gMcW+Vgq/vbJ9ZtMuc2SO3wd2GnMFi+p1T2+Dah5iJz2OCShI60r4aTJuSwMiqTpvqDC
         KWZA==
X-Gm-Message-State: AOAM532UTxlKOjdHl6Mp5bl2uk/PCuKqX/kQ0sz1eUObKXn4JoHrN2Xc
        GfOZ1JYOHaer1W5PVSUqupddSw==
X-Google-Smtp-Source: ABdhPJxBCA2agoApq1FTFonuazhl5sS5Hn1Z6aY/+CCKh/2B3iR7DCT0CJGRNC1UiIE2x80H7JSHow==
X-Received: by 2002:a05:6a00:888:b0:44c:c00e:189c with SMTP id q8-20020a056a00088800b0044cc00e189cmr7439754pfj.79.1636646487541;
        Thu, 11 Nov 2021 08:01:27 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id e14sm2636558pga.76.2021.11.11.08.01.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 08:01:27 -0800 (PST)
Message-ID: <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
Date:   Thu, 11 Nov 2021 08:01:26 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
Content-Language: en-US
To:     Marco Elver <elver@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>
References: <20211111003519.1050494-1-tadeusz.struk@linaro.org>
 <CANpmjNNcVFmnBV-1Daauqk5ww8YRUVRtVs_SXVAPWG5CrFBVPg@mail.gmail.com>
 <c410f4a0-cc06-8ef8-3765-d99e29012acb@linaro.org>
 <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/21 07:52, Marco Elver wrote:
>> The other way to fix it would be to make the struct sk_buff_head
>> equal in size with struct sk_buff:
>>
>>    struct sk_buff_head {
>> -       /* These two members must be first. */
>> -       struct sk_buff  *next;
>> -       struct sk_buff  *prev;
>> +       union {
>> +               struct {
>> +                       /* These two members must be first. */
>> +                       struct sk_buff  *next;
>> +                       struct sk_buff  *prev;
>>
>> -       __u32           qlen;
>> -       spinlock_t      lock;
>> +                       __u32           qlen;
>> +                       spinlock_t      lock;
>> +               };
>> +               struct sk_buff  __prv;
>> +       };
>>    };
>>
>> but that's much more invasive, and I don't even have means to
>> quantify this in terms of final binary size and performance
>> impact. I think that would be a flat out no go.
>>
>>   From the other hand if you look at the __skb_queue functions
>> they don't do much and at all so there is no much room for
>> other issues really. I followed the suggestion in [1]:
>>
>> "if your function deliberately contains possible ..., you can
>>    use __attribute__((no_sanitize... "
> That general advice might not be compatible with what the kernel
> wants, especially since UBSAN_OBJECT_SIZE is normally disabled and I
> think known to cause these issues in the kernel.
> 
> I'll defer to maintainers to decide what would be the preferred way of
> handling this.

Sure, I would also like to know if there is a better way of fixing this.
Thanks for your feedback.

-- 
Thanks,
Tadeusz
