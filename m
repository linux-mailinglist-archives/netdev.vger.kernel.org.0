Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EBC273AF3
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 08:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgIVGcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 02:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgIVGcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 02:32:43 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CE8C061755;
        Mon, 21 Sep 2020 23:32:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s12so15689127wrw.11;
        Mon, 21 Sep 2020 23:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eDOz/JMLknkTw9g+y5dhApSm97qkVUEs/ZHTL0gz2fw=;
        b=HaQCQALGHVNQEMfZjWIQPSNwZdZYY918PSJxIKXBtHGREzrfZs14l3A7EVqs2FMev/
         IJEb11WYJ0Io7OvlAVv0yN7wti4dY6131+xDOqnq33+mYC8No5DoDKBA0p28miZblzSh
         iNg4UEEi1t4FGDg7qM28k8HJWOiayhzucNTCXz50wqRizN5pQgGXudx9Eg67GPANhr56
         mEa26Q61i7gAReMjuCfJwAh+HVaTrMT52kQoueu+Kbqdewu6qCadAh37ghukc7GFxD1C
         O0B5pJecQysUZMJL8izt5QrVScpa7C7bG8FE9jy6GPyeF/acFygKkym3brbq6FgSx5HG
         wh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=eDOz/JMLknkTw9g+y5dhApSm97qkVUEs/ZHTL0gz2fw=;
        b=Axole8VmCQWtxzHLCme95aa2gjvpwCeAqQ/XplPdXWi9n9Fq8DufMbCjLqXf5ZfTtO
         Ch8tlHpb2sL1gQXm58m21ZO/davJUmJDN0xo7DerDQBFswX3WiLct+Wkv6EFgFETfPRe
         ELQ5iaTNhTj/TCCYdsvYubqWqMZ1EUMopOMgcxeLLrt9uNa95+0rAA1Bf685XRPVKlRz
         q/gzLtocacn9F8pNtAvlwDQ+8XvEn0tydk+QGFiCejguPN7WJbLJfqPUNvjQm95wkaTc
         enrT+GO9dL/RT3RD3IFYoFdFjWhDyCPjq/KyBtycJKFYE9JC2YRNUT6uVFYGlfgNwkPY
         HaDg==
X-Gm-Message-State: AOAM5319ax/wOO1qbckVBBZwPS6hA56KhtDH0tdIUbSZsXuL+6nVvtbY
        kRevcHEenz3p2xAxeUBBOG08goVq8kIyog==
X-Google-Smtp-Source: ABdhPJzC1rbzyPo53+fNSxXWPDaZOzMzgC1GT/88osu+za3TOCt7+Tr5Ya9aJiKtMy5iRtpQZlj3MQ==
X-Received: by 2002:adf:fa52:: with SMTP id y18mr3532704wrr.264.1600756361855;
        Mon, 21 Sep 2020 23:32:41 -0700 (PDT)
Received: from [192.168.43.240] ([5.100.192.97])
        by smtp.gmail.com with ESMTPSA id d83sm3167538wmf.23.2020.09.21.23.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 23:32:41 -0700 (PDT)
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <e0a1b4d1-ff47-18d1-d535-c62812cb3105@gmail.com>
Date:   Tue, 22 Sep 2020 09:30:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CALCETrUEC81va8-fuUXG1uA5rbKxnKDYsDOXC70_HtKD4LAeAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/09/2020 03:58, Andy Lutomirski wrote:
> On Mon, Sep 21, 2020 at 5:24 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>> Ah, so reading /dev/input/event* would suffer from the same issue,
>>>>>>> and that one would in fact be broken by your patch in the hypothetical
>>>>>>> case that someone tried to use io_uring to read /dev/input/event on x32...
>>>>>>>
>>>>>>> For reference, I checked the socket timestamp handling that has a
>>>>>>> number of corner cases with time32/time64 formats in compat mode,
>>>>>>> but none of those appear to be affected by the problem.
>>>>>>>
>>>>>>>> Aside from the potentially nasty use of per-task variables, one thing
>>>>>>>> I don't like about PF_FORCE_COMPAT is that it's one-way.  If we're
>>>>>>>> going to have a generic mechanism for this, shouldn't we allow a full
>>>>>>>> override of the syscall arch instead of just allowing forcing compat
>>>>>>>> so that a compat syscall can do a non-compat operation?
>>>>>>>
>>>>>>> The only reason it's needed here is that the caller is in a kernel
>>>>>>> thread rather than a system call. Are there any possible scenarios
>>>>>>> where one would actually need the opposite?
>>>>>>>
>>>>>>
>>>>>> I can certainly imagine needing to force x32 mode from a kernel thread.
>>>>>>
>>>>>> As for the other direction: what exactly are the desired bitness/arch semantics of io_uring?  Is the operation bitness chosen by the io_uring creation or by the io_uring_enter() bitness?
>>>>>
>>>>> It's rather the second one. Even though AFAIR it wasn't discussed
>>>>> specifically, that how it works now (_partially_).
>>>>
>>>> Double checked -- I'm wrong, that's the former one. Most of it is based
>>>> on a flag that was set an creation.
>>>>
>>>
>>> Could we get away with making io_uring_enter() return -EINVAL (or
>>> maybe -ENOTTY?) if you try to do it with bitness that doesn't match
>>> the io_uring?  And disable SQPOLL in compat mode?
>>
>> Something like below. If PF_FORCE_COMPAT or any other solution
>> doesn't lend by the time, I'll take a look whether other io_uring's
>> syscalls need similar checks, etc.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0458f02d4ca8..aab20785fa9a 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -8671,6 +8671,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
>>         if (ctx->flags & IORING_SETUP_R_DISABLED)
>>                 goto out;
>>
>> +       ret = -EINVAl;
>> +       if (ctx->compat != in_compat_syscall())
>> +               goto out;
>> +
> 
> This seems entirely reasonable to me.  Sharing an io_uring ring
> between programs with different ABIs seems a bit nutty.
> 
>>         /*
>>          * For SQ polling, the thread will do all submissions and completions.
>>          * Just return the requested submit count, and wake the thread if
>> @@ -9006,6 +9010,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>>         if (ret)
>>                 goto err;
>>
>> +       ret = -EINVAL;
>> +       if (ctx->compat)
>> +               goto err;
>> +
> 
> I may be looking at a different kernel than you, but aren't you
> preventing creating an io_uring regardless of whether SQPOLL is
> requested?

I diffed a not-saved file on a sleepy head, thanks for noticing.
As you said, there should be an SQPOLL check.

...
if (ctx->compat && (p->flags & IORING_SETUP_SQPOLL))
	goto err;

-- 
Pavel Begunkov
