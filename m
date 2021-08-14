Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A393EC5E9
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 01:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234151AbhHNXET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 19:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233964AbhHNXER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 19:04:17 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8A2C0617AD
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 16:03:48 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id h18so14711399ilc.5
        for <netdev@vger.kernel.org>; Sat, 14 Aug 2021 16:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qmFkeUHwny/Th4/3e9gJVXZ8p7Kjf4pDQS/FEdz+8YE=;
        b=kXW9tb0UCZ2N5bGDjQPAvvLu1hM04NlMdl58Yc5hHnWxbLTNABC8DLnuZLyP8kkpz+
         WjnZyXOM9ffsmeZGLUEl5mp3KWbAwReS7sAIH2Gpos4a9wAeMRA06ErmF/MuYQMLHB7L
         Z1ud8ayhOxx4MxdkLXxeiL1bruw9kS7vTt+1YOwSZjoTYCUwjNd7lkddkc7WYZYMWK11
         dNp5DkNmRuoId9uQ4Yz7NYs+MMvMmhGI/gvC5nQ9qj3/NYmmjc7zplg0g5y1JFVBt2lX
         vgyZMItX9qp4eFQgfSj20PkG8rXNu6bHGdkqbQgUMl5RRnRPH2tLqpUxEnLGPLAhMz1f
         c3fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qmFkeUHwny/Th4/3e9gJVXZ8p7Kjf4pDQS/FEdz+8YE=;
        b=IbPMtzFro3vNN00sSUA8Dxj3z/KgU21M+Krlc8jsmWTDuSKGXXj2FuK5wQ0LkNwLVs
         /yrB1M+N6F5W/pGPa3aozfUfTiBjE0G16eI1RZQ/S8pcy4+UAyjHfUyc9vj+wkhndYUS
         0PbJ0/b4o387ZFTbPDMlJAPd6sAEXStuB/YSdi0KJiK54STxMDOrgAP+n2qx+KyPb41k
         o0B9nKpXx5UV4TgTTFbCXdQfBgOnI8klJvp4y4izzvJHmeQHUtTstcoDfBzlOOjYMDWP
         H0XsMF48bcEu3eMkn/7DwOnJqHtU3fZIPFSYAo2V926fT4W6/OWvKzXOkoKY9nV5SuwB
         MWPw==
X-Gm-Message-State: AOAM530YMCLuUp/3QHJmBAiRkl1WOSA+HwU7Yt178mYRo0bR1XkzOFP2
        ySK5PPqKOG1wOqFx87YkAwm/BQ==
X-Google-Smtp-Source: ABdhPJz9JNmQC0uFEVHBIP3yvL3q4yXkIoDBB/M0W13fT7lR0LrtJwhpFT44iJsVz9F098giwQajkw==
X-Received: by 2002:a92:d7c1:: with SMTP id g1mr6542553ilq.24.1628982227203;
        Sat, 14 Aug 2021 16:03:47 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l9sm3054927ilv.31.2021.08.14.16.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 16:03:46 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost> <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk>
Date:   Sat, 14 Aug 2021 17:03:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/21 6:50 AM, Pavel Begunkov wrote:
> On 8/13/21 8:00 PM, Josh Triplett wrote:
>> On Fri, Aug 13, 2021 at 05:43:09PM +0100, Pavel Begunkov wrote:
>>> Add an optional feature to open/accept directly into io_uring's fixed
>>> file table bypassing the normal file table. Same behaviour if as the
>>> snippet below, but in one operation:
>>>
>>> sqe = prep_[open,accept](...);
>>> cqe = submit_and_wait(sqe);
>>> // error handling
>>> io_uring_register_files_update(uring_idx, (fd = cqe->res));
>>> // optionally
>>> close((fd = cqe->res));
>>>
>>> The idea in pretty old, and was brough up and implemented a year ago
>>> by Josh Triplett, though haven't sought the light for some reasons.
>>
>> Thank you for working to get this over the finish line!
>>
>>> Tested on basic cases, will be sent out as liburing patches later.
>>>
>>> A copy paste from 2/2 describing user API and some notes:
>>>
>>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>>> the old behaviour. If non-zero value is specified, then it will behave
>>> as described and place the file into a fixed file slot
>>> sqe->file_index - 1. A file table should be already created, the slot
>>> should be valid and empty, otherwise the operation will fail.
>>>
>>> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
>>> accept takes a file, and it already uses the flag with a different
>>> meaning.
>>>
>>> Note 2: it's u16, where in theory the limit for fixed file tables might
>>> get increased in the future. If would ever happen so, we'll better
>>> workaround later, e.g. by making ioprio to represent upper bits 16 bits.
>>> The layout for open is tight already enough.
>>
>> Rather than using sqe->file_index - 1, which feels like an error-prone
>> interface, I think it makes sense to use a dedicated flag for this, like
>> IOSQE_OPEN_FIXED. That flag could work for any open-like operation,
>> including open, accept, and in the future many other operations such as
>> memfd_create. (Imagine using a single ring submission to open a memfd,
>> write a buffer into it, seal it, send it over a UNIX socket, and then
>> close it.)
>>
>> The only downside is that you'll need to reject that flag in all
>> non-open operations. One way to unify that code might be to add a flag
>> in io_op_def for open-like operations, and then check in common code for
>> the case of non-open-like operations passing IOSQE_OPEN_FIXED.
> 
> io_uring is really thin, and so I absolutely don't want any extra
> overhead in the generic path, IOW anything affecting
> reads/writes/sends/recvs.
> 
> The other reason is that there are only 2 bits left in sqe->flags,
> and we may use them for something better, considering that it's
> only open/accept and not much as this.
> 
> I agree that it feels error-prone, but at least it can be wrapped
> nicely enough in liburing, e.g.
> 
> void io_uring_prep_openat_direct(struct io_uring_sqe *sqe, int dfd,
> 				 const char *path, int flags,
> 				 mode_t mode, int slot_idx);
> 
> 
>> Also, rather than using a 16-bit index for the fixed file table and
>> potentially requiring expansion into a different field in the future,
>> what about overlapping it with the nofile field in the open and accept
>> requests? If they're not opening a normal file descriptor, they don't
>> need nofile. And in the original sqe, you can then overlap it with a
>> 32-bit field like splice_fd_in.
> 
> There is no nofile in SQEs, though
> 
> req->open.nofile = rlimit(RLIMIT_NOFILE);

What's the plan in terms of limiting the amount of direct descriptors
(for lack of a better word)? That seems like an important aspect that
should get sorted out upfront.

Do we include the regular file table max_fds count for creating a new
direct descriptor, and limit to RLIMIT_NOFILE? That would seem logical,
but then that also implies that the regular file table should include
the ctx (potentially several) direct descriptors. And the latter is much
worse.

Maybe we have a way to size the direct table, which will consume entries
from the same pool that the regular file table does? That would then
work both ways, and could potentially just be done dynamically similarly
to how we expand the regular file table when we exceed its current size.

Anyway, just throwing a few ideas out there, with the intent to spark a
bit of discussion on this topic. I really like the direct descriptors,
it'll be a lot more efficient for certain use cases.

-- 
Jens Axboe

