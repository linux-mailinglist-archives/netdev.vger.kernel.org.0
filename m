Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1735A3F5FC2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbhHXODF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbhHXODC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:03:02 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B58C0613C1
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 07:02:18 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id b7so26477591iob.4
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 07:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SXhAUewW+r0PMnd1AF5dqqxnB74hWPeETejTBaHF3Qk=;
        b=i/dHXfhTEWVw1RePpMLRJ6oAcfCgekoNLv+MnnDFUKUujfj0wt/y/3KOtgo5KgTjzf
         w3CCYIvlZINQzZ0sKMcTFbKdLewS99ClUdG7MGWCktRwgQd1/3I/uceTs2zdpdK8K8HQ
         2ZbJaRh+B0KORJYuWIQIy7Ch5N/MnSPB1zx4EQgm6g/usFhK18ppzzkJeS5djf6+FTqG
         pp6562noEzwh+mHtaWgRdhIAYfsOxqA2TVjq2yOLlTYgoO3PHKcIPnijy+uYMBBeQBTs
         gkoyh5m8+qcAdcsETEY5A2iUym+bFtCUVfenmUfHVw0RvVhKYCL0krYB6BikPRJt5ED8
         Uwvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SXhAUewW+r0PMnd1AF5dqqxnB74hWPeETejTBaHF3Qk=;
        b=o8kTLb62mS7iOErLRL2WdlQPx5OkEe4z/T/4pIPGyudAxURo/2apVH432et2yLoS4m
         6/qvWqOUcGvlkzVGzuK3ENg5Mq8sWmpLnRheyStqQihV45zfvXjoSU83NDXHB8CD2Cl/
         Oz5fTcqJofPum4ydZN+yOLMroQEC3zjDeZ5DYQupaafiflqBUASYUTJJSsB0TIN+vny5
         dre3GtEnb9hX4u6emcSSlYWh9Lh7k3orhEmeLCuPoUTh7iI2Kvc9k85f2lecsu8zRQCc
         y2OYv9QVwGgS09pefvH+G/8td10Jq2jcMYy9lA8oTjsmEciRMcThKm0aHcVX4syMNuyh
         W7ug==
X-Gm-Message-State: AOAM5324QWHHDJJM5yM5+52ZQ51V101FpkOILVQGUDo7J97AX7m5faI7
        udUFtcfWHsW+cOrHF9aSwV1gpw==
X-Google-Smtp-Source: ABdhPJzrBFabN2yPRk3crVjsEKj+8uZoejubOqtSz7dYYj6xKvzC7HagRjBOUFUEJl60KaC/wQ5k3g==
X-Received: by 2002:a05:6602:2597:: with SMTP id p23mr31607681ioo.195.1629813737898;
        Tue, 24 Aug 2021 07:02:17 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z16sm10166033ile.72.2021.08.24.07.02.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:02:17 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] open/accept directly into io_uring fixed file
 table
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1629559905.git.asml.silence@gmail.com>
 <7fa72eec-9222-60eb-9ec6-e4b6efbfc5fb@kernel.dk> <YSPzab+g8ee84bX7@localhost>
 <59494bda-f804-4185-dd7d-4827b14bae61@kernel.dk>
 <2527d712-bc8b-7393-f4c0-3035dd525b1e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c4653859-4003-70db-8b81-291dd17a6718@kernel.dk>
Date:   Tue, 24 Aug 2021 08:02:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2527d712-bc8b-7393-f4c0-3035dd525b1e@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 3:48 AM, Pavel Begunkov wrote:
> On 8/23/21 8:40 PM, Jens Axboe wrote:
>> On 8/23/21 1:13 PM, Josh Triplett wrote:
>>> On Sat, Aug 21, 2021 at 08:18:12PM -0600, Jens Axboe wrote:
>>>> On 8/21/21 9:52 AM, Pavel Begunkov wrote:
>>>>> Add an optional feature to open/accept directly into io_uring's fixed
>>>>> file table bypassing the normal file table. Same behaviour if as the
>>>>> snippet below, but in one operation:
>>>>>
>>>>> sqe = prep_[open,accept](...);
>>>>> cqe = submit_and_wait(sqe);
>>>>> io_uring_register_files_update(uring_idx, (fd = cqe->res));
>>>>> close((fd = cqe->res));
>>>>>
>>>>> The idea in pretty old, and was brough up and implemented a year ago
>>>>> by Josh Triplett, though haven't sought the light for some reasons.
>>>>>
>>>>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>>>>> the old behaviour. If non-zero value is specified, then it will behave
>>>>> as described and place the file into a fixed file slot
>>>>> sqe->file_index - 1. A file table should be already created, the slot
>>>>> should be valid and empty, otherwise the operation will fail.
>>>>>
>>>>> we can't use IOSQE_FIXED_FILE to switch between modes, because accept
>>>>> takes a file, and it already uses the flag with a different meaning.
>>>>>
>>>>> since RFC:
>>>>>  - added attribution
>>>>>  - updated descriptions
>>>>>  - rebased
>>>>>
>>>>> since v1:
>>>>>  - EBADF if slot is already used (Josh Triplett)
>>>>>  - alias index with splice_fd_in (Josh Triplett)
>>>>>  - fix a bound check bug
>>>>
>>>> With the prep series, this looks good to me now. Josh, what do you
>>>> think?
>>>
>>> I would still like to see this using a union with the `nofile` field in
>>> io_open and io_accept, rather than overloading the 16-bit buf_index
>>> field. That would avoid truncating to 16 bits, and make less work for
>>> expansion to more than 16 bits of fixed file indexes.
>>>
>>> (I'd also like that to actually use a union, rather than overloading the
>>> meaning of buf_index/nofile.)
>>
>> Agree, and in fact there's room in the open and accept command parts, so
>> we can just make it a separate entry there instead of using ->buf_index.
>> Then just pass in the index to io_install_fixed_file() instead of having
>> it pull it from req->buf_index.
> 
> That's internal details, can be expanded at wish in the future, if we'd
> ever need larger tables. ->buf_index already holds indexes to different
> resources just fine.

Sure it's internal and can always be changed, doesn't change the fact
that it's a bit iffy that it's used differently in different spots. As
it costs us nothing to simply add a 'fixed_file' u32 for io_accept and
io_open, I really think that should be done instead.

> Aliasing with nofile would rather be ugly, so the only option, as you
> mentioned, is to grab some space from open/accept structs, but don't see
> why we'd want it when there is a more convenient alternative.

Because it's a lot more readable and less error prone imho. Agree on the
union, we don't have to resort to that.

>>> I personally still feel that using non-zero to signify index-plus-one is
>>> both error-prone and not as future-compatible. I think we could do
>>> better with no additional overhead. But I think the final call on that
>>> interface is up to you, Jens. Do you think it'd be worth spending a flag
>>> bit or using a different opcode, to get a cleaner interface? If you
>>> don't, then I'd be fine with seeing this go in with just the io_open and
>>> io_accept change.
>>
>> I'd be inclined to go the extra opcode route instead, as the flag only
>> really would make sense to requests that instantiate file descriptors.
>> For this particular case, we'd need 3 new opcodes for
>> openat/openat2/accept, which is probably a worthwhile expenditure.
>>
>> Pavel, what do you think? Switch to using a different opcode for the new
>> requests, and just grab some space in io_open and io_accept for the fd
>> and pass it in to install.
> 
> I don't get it, why it's even called hackish? How that's anyhow better?
> To me the feature looks like a natural extension to the operations, just
> like a read can be tuned with flags, so and creating new opcodes seems
> a bit ugly, unnecessary taking space from opcodes and adding duplication
> (even if both versions call the same handler).

I agree that it's a natural extension, the problem is that we have to do
unnatural things (somewhat) to make it work. I'm fine with using the
union for the splice_fd_in to pass it in, I don't think it's a big deal.

I do wish that IORING_OP_CLOSE would work with them, though. I think we
should to that as a followup patch. It's a bit odd to be able to open a
file with IORING_OP_OPENAT and not being able to close it with
IORING_OP_CLOSE. For the latter, we should just give it fixed file
support, which would be pretty trivial.

> First, why it's not future-compatible? It's a serious argument, but I
> don't see where it came from. Do I miss something?
> 
> It's u32 now, and so will easily cover all indexes. SQE fields should
> always be zeroed, that's a rule, liburing follows it, and there would
> have been already lots of problems for users not honoring it. And there
> will be a helper hiding all the index conversions for convenience.
> 
> void io_uring_prep_open_direct(sqe, index, ...)
> {
> 	io_uring_prep_open(sqe, ...);
> 	sqe->file_index = index + 1;
> }

Let's keep it the way that it is, but I do want to see the buf_index
thing go away and just req->open.fixed_file or whatever being used for
open and accept. We should fold that in.

-- 
Jens Axboe

