Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C962D900B
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 20:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394837AbgLMTXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 14:23:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395200AbgLMTW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 14:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607887291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UbL8Odta7ic6S0aPEogCx7D7h/B71ZIzRWsPMeenY94=;
        b=WKT3OqoGe8TUQzbUYAX3jHV1D93hbq9/hmlcgymcMf3lgW2viABWrK1OTvYmChOkNwlI4F
        c9Fv/DQD45vZ+OZwSCHBpDd7KucxRYI26BPgXS9Yy8VwnAPUsv9JcMY+T5mUJEkig9TWKu
        2jM5BvGhP9b2EhiUb4GPQCp7JBEQ4qM=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-IXfX5DBpOJuI-KpSfad4VQ-1; Sun, 13 Dec 2020 14:21:27 -0500
X-MC-Unique: IXfX5DBpOJuI-KpSfad4VQ-1
Received: by mail-oo1-f70.google.com with SMTP id t7so6851582oog.7
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 11:21:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=UbL8Odta7ic6S0aPEogCx7D7h/B71ZIzRWsPMeenY94=;
        b=mWi/kq997yBnS8KcXx5+B1dk74RTSfupp+BztLH4QUO+aSJ86Phnw4wY7JfryPBQU9
         ZHFkfMLIb4J3s18uV6mRffEt1Cwcnd4HdvjwZgBc1caGPbvH5yolvOKekfvbNrKIzwc7
         aUR8HnXPy0k4ceZ1tawwrfi27SKSsEmIzI1gCg9B2xzg2SVW/7pHEEnD6vmA3Jggg0t4
         jsuuQaUlitiXGGayhVAHjv/FdwI5IDhH8JaQblTvZoSj3wjZzT/OVOwxLk1hDN1vsFSQ
         NVn1nPkKLgkbUnwsKsJKlKRoc3sSdzTZiZoA1PZ93Vuznq3gQ1UbiDswAls04+9hF3Gs
         WSow==
X-Gm-Message-State: AOAM5323NFaYYBOOPZ546xV1UF0JpK1oG1NNUxVkPwyWYLeC27MaIlGi
        zZGvMa1tU+dHPvbkvbeeqRXp3neB4BrntNvY4bUIJUGqrlpD4N3aNtd0KVBIxT35A8bIwFAQB4o
        TEREDlOMxKLl8f4x+
X-Received: by 2002:a9d:269:: with SMTP id 96mr16744061otb.174.1607887286713;
        Sun, 13 Dec 2020 11:21:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQkCv+SsykJEiclAhkJJmaIpJ8GofmaJCmKC2P9NkPzPSY2w5X75hXxW7iT/wQfqs4MJlolQ==
X-Received: by 2002:a9d:269:: with SMTP id 96mr16744053otb.174.1607887286519;
        Sun, 13 Dec 2020 11:21:26 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id c5sm1967722otl.53.2020.12.13.11.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 11:21:25 -0800 (PST)
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Joe Perches <joe@perches.com>
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
From:   Tom Rix <trix@redhat.com>
Message-ID: <527928d8-4621-f2f3-a38f-80c60529dde8@redhat.com>
Date:   Sun, 13 Dec 2020 11:21:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdkv6W_dTLVowEBu0uV6oSxwW8F+U__qAsmk7vop6U8tpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/2/20 2:34 PM, Nick Desaulniers wrote:
> On Tue, Nov 10, 2020 at 2:04 PM Joe Perches <joe@perches.com> wrote:
>> On Tue, 2020-11-10 at 14:00 -0800, Nick Desaulniers wrote:
>>
>>> Yeah, we could go through and remove %h and %hh to solve this, too, right?
>> Yup.
>>
>> I think one of the checkpatch improvement mentees is adding
>> some suggestion and I hope an automated fix mechanism for that.
>>
>> https://lore.kernel.org/lkml/5e3265c241602bb54286fbaae9222070daa4768e.camel@perches.com/
> + Tom, who's been looking at leveraging clang-tidy to automate such
> treewide mechanical changes.
> ex. https://reviews.llvm.org/D91789
>
> See also commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging
> use of unnecessary %h[xudi] and %hh[xudi]") for a concise summary of
> related context.

I have posted the fixer here

https://reviews.llvm.org/D93182

It catches about 200 problems in 100 files, I'll be posting these soon.

clang-tidy-fix's big difference over checkpatch is using the __printf(x,y) attribute to find the log functions.

I will be doing a follow-on to add the missing __printf or __scanf's and rerunning the fixer.

Tom

