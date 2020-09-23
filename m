Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E74A2752C6
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIWIES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWIEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:04:15 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74632C061755;
        Wed, 23 Sep 2020 01:04:15 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a9so6049924wmm.2;
        Wed, 23 Sep 2020 01:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ONodeowpirgKu2fWGk3Tuj8MhxBtn1x7pOHZ1lVstcw=;
        b=MzoKpsZPMOiF5yYvEPp759U2ZjK3YzIFcKVI0hpLf7Xd9waLnNI3KxdguoSDjC2A9q
         kOy74+BBHOCeG9fgauj1WGJa2A3l55+l1D/9ayqSzfewV92N8zfOhh0jQ8KDwZdZ0Wc+
         pm0vHUIhD3KPR6dJ3R6edydt4ho5TGTB5EjolCrD2s9tYuJyJFX/n8V58fGZLFbqgzWr
         NNz67w0uK/ZROSVdeqbZC24nk0Qrbx6iFRMOAvkuOhm9cB7neMyc24Yf6OdJTHK3aRBz
         PZ8JE8fGVOclR8F5cUNHMz9MlsxF06G2W8pUoDZama+JQgSY1+Esbu0GHunoAplzbWQs
         UWXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ONodeowpirgKu2fWGk3Tuj8MhxBtn1x7pOHZ1lVstcw=;
        b=H7ju0USDXaG3m5BFKZZg7gXX6UT5WdAx1WaIw2mftSkKjH7JVeV6j3E1tzWqfhJpyl
         cJgMAWbarPRZUNNszAV++1FTaly6d044aFx53sY0h8FnjP0VI9XwsYZcw5cqfORtyyWa
         k/z54Mk/JoyUBpKxGO+2G0wQqvwA2E94Pcvmp63oWiZG+piksuV+VZ7Md30HHAKiab8p
         MZ1vQa3O4+oZqCr2kow59E/zBk/+4bDWpQhcco0E1zWbZDbXIxyOLR/zfuoPbAfkYHPH
         tfkmzhMjTa6py370aU+kaIFaKFqh5FBlzVGqhMX7Y+qjv2eESx6DjD1oiNryHrwaYEeT
         U6Og==
X-Gm-Message-State: AOAM533xfiJ1WYK2otgFg3LNRbLRAORCq+tuR0ChjIFoiWhnqzEPpnnZ
        fWXLgxBk+SItYC/TCSKFCLDKwpjd9F72AA==
X-Google-Smtp-Source: ABdhPJyHjes2guPDIH/GjSt6urDwIAObxYd85bPxA03C5r6pWsFZBYQtPZnXFeWZykiGGKGD1MH1fA==
X-Received: by 2002:a7b:c215:: with SMTP id x21mr4946654wmi.138.1600848253769;
        Wed, 23 Sep 2020 01:04:13 -0700 (PDT)
Received: from [192.168.43.240] ([5.100.192.97])
        by smtp.gmail.com with ESMTPSA id 63sm31416477wrh.71.2020.09.23.01.04.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 01:04:13 -0700 (PDT)
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
References: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
 <D0791499-1190-4C3F-A984-0A313ECA81C7@amacapital.net>
 <563138b5-7073-74bc-f0c5-b2bad6277e87@gmail.com>
 <486c92d0-0f2e-bd61-1ab8-302524af5e08@gmail.com>
 <CALCETrW3rwGsgfLNnu_0JAcL5jvrPVTLTWM3JpbB5P9Hye6Fdw@mail.gmail.com>
 <d5c6736a-2cb4-4e22-78da-a667bda5c05a@gmail.com>
 <CALCETrUEC81va8-fuUXG1uA5rbKxnKDYsDOXC70_HtKD4LAeAg@mail.gmail.com>
 <e0a1b4d1-ff47-18d1-d535-c62812cb3105@gmail.com>
 <CAK8P3a2-6JNS38EbZcLrk=cTT526oP=Rf0aoqWNSJ-k4XTYehQ@mail.gmail.com>
 <f25b4708-eba6-78d6-03f9-5bfb04e07627@gmail.com>
 <CAK8P3a39jN+t2hhLg0oKZnbYATQXmYE2-Z1JkmFyc1EPdg1HXw@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <91209170-dcb4-d9ee-afa0-a819f8877b86@gmail.com>
Date:   Wed, 23 Sep 2020 11:01:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a39jN+t2hhLg0oKZnbYATQXmYE2-Z1JkmFyc1EPdg1HXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2020 12:01, Arnd Bergmann wrote:
> On Tue, Sep 22, 2020 at 9:59 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 22/09/2020 10:23, Arnd Bergmann wrote:
>>> On Tue, Sep 22, 2020 at 8:32 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> On 22/09/2020 03:58, Andy Lutomirski wrote:
>>>>> On Mon, Sep 21, 2020 at 5:24 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>> I may be looking at a different kernel than you, but aren't you
>>>>> preventing creating an io_uring regardless of whether SQPOLL is
>>>>> requested?
>>>>
>>>> I diffed a not-saved file on a sleepy head, thanks for noticing.
>>>> As you said, there should be an SQPOLL check.
>>>>
>>>> ...
>>>> if (ctx->compat && (p->flags & IORING_SETUP_SQPOLL))
>>>>         goto err;
>>>
>>> Wouldn't that mean that now 32-bit containers behave differently
>>> between compat and native execution?
>>>
>>> I think if you want to prevent 32-bit applications from using SQPOLL,
>>> it needs to be done the same way on both to be consistent:
>>
>> The intention was to disable only compat not native 32-bit.
> 
> I'm not following why that would be considered a valid option,
> as that clearly breaks existing users that update from a 32-bit
> kernel to a 64-bit one.

Do you mean users who move 32-bit binaries (without recompiling) to a
new x64 kernel? Does the kernel guarantees that to work? I'd personally
care more native-bitness apps.

> 
> Taking away the features from users that are still on 32-bit kernels
> already seems questionable to me, but being inconsistent
> about it seems much worse, in particular when the regression
> is on the upgrade path.

TBH, this won't fix that entirely (e.g. passing non-compat io_uring
to a compat process should yield the same problem). So, let's put
it aside for now until this bikeshedding would be relevant.

> 
>>> Can we expect all existing and future user space to have a sane
>>> fallback when IORING_SETUP_SQPOLL fails?
>>
>> SQPOLL has a few differences with non-SQPOLL modes, but it's easy
>> to convert between them. Anyway, SQPOLL is a privileged special
>> case that's here for performance/latency reasons, I don't think
>> there will be any non-accidental users of it.
> 
> Ok, so the behavior of 32-bit tasks would be the same as running
> the same application as unprivileged 64-bit tasks, with applications

Yes, something like that, but that's not automatic and in some
(hopefully rare) cases there may be pitfalls. That's in short,
I can expand the idea a bit if anyone would be interested.

> already having to implement that fallback, right?

Well, not everyone _have_ to implement such a fallback, e.g.
applications working only whilst privileged may use SQPOLL only.

-- 
Pavel Begunkov
