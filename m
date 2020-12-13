Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B98C2D912E
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 00:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbgLMXbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 18:31:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726022AbgLMXax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 18:30:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607902156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FWN/nvGfcwJ4JhylvAKAFoL2tU46r+A52KR+6wvr1TA=;
        b=XyMnSJ8uYMr1bBdgL1mQ5gQ3FtjS91wiDj+wzjH6rHO34aHKSYo2vxb0y/U5NT6AFvvZr8
        v+Id7SzRXN/YEfNdhdwyKIFZOEPx61PfouKxJ8YmPsP1SdXKLh3nEvlCwKExgEi4x6fIN4
        5UqFQDLZidgXx3b9d3RY4GnkxaIvXyc=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-BvJPEKu9Ofu7ClN1liy9gw-1; Sun, 13 Dec 2020 18:29:13 -0500
X-MC-Unique: BvJPEKu9Ofu7ClN1liy9gw-1
Received: by mail-oi1-f200.google.com with SMTP id j28so8052713oig.0
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 15:29:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=FWN/nvGfcwJ4JhylvAKAFoL2tU46r+A52KR+6wvr1TA=;
        b=a0Vl7Xk2N4VwtEO6h0zEF0/f/x6T08sF3HqMI8dm9VEXarKZBmh2VxubGjD5FQBPDt
         n+b7kQfQMs323fT4ULasQB6sKJ6o1nrsSj/hBPGbjzVcYBKjX/GzwIYtrQE/DbW6o+KP
         VzXqoKY1llWL23CXAOnOGHTdiEwYfSNZl36JYhRUgAQKJvFRGFZD3egImJCcUvsZuzt3
         hKzj2inm1fZzLYN49LU3D59foG7gW8ITQ2C/iaczML+shhRom7ign/wF4OZ5IVkPjQ/N
         u/Pq3mgvDf058M3AxZ+8nh3N4KklcAfhcPwyUI/5s0ORwpmudOw5t4odJt0/ptOF98LP
         xGxQ==
X-Gm-Message-State: AOAM530gGJZNrdPiGCoNr+oG18JGfXpqgb++V84NB7UuKFm/YlwI9Mwk
        PNFgvTcwNOYTTPFR+Hynthnb8lC9jM5NfJ8tWVCoMSSUcKJEg4TfzhefBjavI5pHfstBOxPXAoy
        ZoYYTNWZUKff4UFO9
X-Received: by 2002:a4a:8f95:: with SMTP id c21mr291655ooj.60.1607902152631;
        Sun, 13 Dec 2020 15:29:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmAGZgZXj13+5q7GCS8nCLos/WbA1HcGONzVC6yTpxKN9dHpko47DrrSGao/QihXohNCYaqw==
X-Received: by 2002:a4a:8f95:: with SMTP id c21mr291645ooj.60.1607902152400;
        Sun, 13 Dec 2020 15:29:12 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id s77sm2998865oos.27.2020.12.13.15.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 15:29:11 -0800 (PST)
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Joe Perches <joe@perches.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
 <4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com>
 <CAKwvOdn50VP4h7tidMnnFeMA1M-FevykP+Y0ozieisS7Nn4yoQ@mail.gmail.com>
 <26052c5a0a098aa7d9c0c8a1d39cc4a8f7915dd2.camel@perches.com>
 <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
 <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
 <cf2a184e2264a2b9fd2c8d7f10d524924d417d57.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <c9d63f7d-7fa4-4fd6-f897-265315d935ab@redhat.com>
Date:   Sun, 13 Dec 2020 15:29:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <cf2a184e2264a2b9fd2c8d7f10d524924d417d57.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/13/20 3:25 PM, Joe Perches wrote:
> On Sun, 2020-12-13 at 11:21 -0800, Tom Rix wrote:
>> On 12/2/20 2:34 PM, Nick Desaulniers wrote:
>>> On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>>>> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>>>>
>>>>> Yeah, we could go through and remove %h and %hh to solve this, too, right?
>>>> Yup.
>>>>
>>>> I think one of the checkpatch improvement mentees is adding
>>>> some suggestion and I hope an automated fix mechanism for that.
>>>>
>>>> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
>>> + Tom, who's been looking at leveraging clang-tidy to automate such
>>> treewide mechanical changes.
>>> ex. https://reviews.llvm.org/D91789
>>>
>>> See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
>>> use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
>>> related context.
>> I have posted the fixer here
>>
>> https://reviews.llvm.org/D93182
>>
>> It catches about 200 problems in 100 files, I'll be posting these soon.
> Thanks, but see below:
>  
>> clang-tidy-fix's big difference over checkpatch is using the __printf(x,y) attribute to find the log functions.
>>
>> I will be doing a follow-on to add the missing __printf or __scanf's and rerunning the fixer.
> scanf should not be tested because the %h use is required there.

Yes.

I mean the clang-tidy check i am planning on writing will find missing __scanf as well as the __printf.

The %h fixer only works on __printf.

Tom

>
>

