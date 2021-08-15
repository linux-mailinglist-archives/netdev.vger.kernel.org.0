Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068043EC8A8
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 12:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbhHOKtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 06:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbhHOKtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 06:49:50 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAB0C061764;
        Sun, 15 Aug 2021 03:49:20 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f10so6610751wml.2;
        Sun, 15 Aug 2021 03:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1CxQWhhARjoVMY5/tTuJPwWDah4z0FveG0g5iNjB8ZQ=;
        b=bG5audem24BHB6wJddbcB8i4yYN5vp0jxn5DudeSNMiK0ig+jWQH/8ARzDeHY5kpC4
         //YqoAzOo3PE6+1z6+CeH8s312iTsTYPP1xlMmCBo3qRhbKW3gb4ER1ilw6keoj8oGpS
         GobRke+RbE4lqV5zuiYNhZ1hgVTO1z0dLzFeV5QM/h7XJlXlD+S8w/PcJdBiQk/M+c1V
         fyUxSYd896YV3XZybODobUN4c0G5SFIvK3UOLMFmG6nNPhjrWo+uyB617FCasbwXQ1T/
         0/44lCiq0Mk4jhElupRouXgBRH4YsxP2RCxbPy61qzzygIcW9a919jGVXfuI/gkD0lNG
         q5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1CxQWhhARjoVMY5/tTuJPwWDah4z0FveG0g5iNjB8ZQ=;
        b=BCv5pkSrYdxR/yiU+o5PfhRt6XiJyzCohnpjmEqEXooEwwvtEme+x2kTueFpAodAgO
         yTBk7gWV0MO210C3gCXafZ3TM++Diolo+B9gVFYvL92bdpT/gjgfDCpcjNEuN9zSiiS/
         irM0qYrjUkIiCtWV/lzzZsWwGRaktGQkYq6SoD+Dr7HvQOUGgxDKzRp8NCIUZNKw26U6
         RErAhd6Cq8t0KCCTcqS5HCbIHKxD3JI0iQTz8ENJnOEqaC42ElCOOuUBPwv/9QoU7MKc
         A8fA9oQHjt4qqJOeJdHzdVIX54kUIPNhXVHtUzLQt6TdRPs3Jg7jM8eIFJUXqJu09D9E
         LHRw==
X-Gm-Message-State: AOAM533rb8a75h/NQtZ/UTr8hXcB2jVsiMxDm1fyIKp7PQhejJPUujO1
        znDIRQkv75SY4J+rIBbfTlQ=
X-Google-Smtp-Source: ABdhPJytWviH22yDk6aTFHkCZwAClH3nHUCl1exKXbol4mRzaTyX4je3koyDhCaPySpZ3QgzgSlIeg==
X-Received: by 2002:a7b:c5c7:: with SMTP id n7mr10801270wmk.5.1629024559014;
        Sun, 15 Aug 2021 03:49:19 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id x18sm7677487wrw.19.2021.08.15.03.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 03:49:18 -0700 (PDT)
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost> <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
 <YRiKg7tV+8oMtXtg@localhost>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <c6c0a1ee-2417-6e9d-4206-77f9498a4401@gmail.com>
Date:   Sun, 15 Aug 2021 11:48:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRiKg7tV+8oMtXtg@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/21 4:31 AM, Josh Triplett wrote:
> On Sat, Aug 14, 2021 at 01:50:24PM +0100, Pavel Begunkov wrote:
>> On 8/13/21 8:00 PM, Josh Triplett wrote:
>>> Rather than using sqe->file_index - 1, which feels like an error-prone
>>> interface, I think it makes sense to use a dedicated flag for this, like
>>> IOSQE_OPEN_FIXED. That flag could work for any open-like operation,
>>> including open, accept, and in the future many other operations such as
>>> memfd_create. (Imagine using a single ring submission to open a memfd,
>>> write a buffer into it, seal it, send it over a UNIX socket, and then
>>> close it.)
>>>
>>> The only downside is that you'll need to reject that flag in all
>>> non-open operations. One way to unify that code might be to add a flag
>>> in io_op_def for open-like operations, and then check in common code for
>>> the case of non-open-like operations passing IOSQE_OPEN_FIXED.
>>
>> io_uring is really thin, and so I absolutely don't want any extra
>> overhead in the generic path, IOW anything affecting
>> reads/writes/sends/recvs.
> 
> There are already several checks for valid flags in io_init_req. For
> instance:

Yes, it's horrible and I don't want to make it any worse.

>         if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
>             !io_op_defs[req->opcode].buffer_select)
>                 return -EOPNOTSUPP;
> It'd be trivial to make io_op_defs have a "valid flags" byte, and one
> bitwise op tells you if any invalid flags were passed. *Zero* additional
> overhead for other operations.

Good point

> Alternatively, since there are so few operations that open a file
> descriptor, you could just add a separate opcode for those few
> operations. That still seems preferable to overloading a 16-bit index
> field for this.

I don't think so

> With this new mechanism, I think we're going to want to support more
> than 65535 fixed-file entries. I can easily imagine wanting to handle
> hundreds of thousands of files or sockets this way.

May be. What I'm curious about is that the feature doesn't really
change anything in this regard, but seems I haven't heard people
asking for larger tables.

>> The other reason is that there are only 2 bits left in sqe->flags,
>> and we may use them for something better, considering that it's
>> only open/accept and not much as this.
> 
> pipe, dup3, socket, socketpair, pidfds (via either pidfd_open or a
> ring-based spawn mechanism), epoll_create, inotify, fanotify, signalfd,
> timerfd, eventfd, memfd_create, userfaultfd, open_tree, fsopen, fsmount,
> memfd_secret.

We could argue for many of those whether they should be in io_uring,
and whether there are many benefits having them async and so. It would
have another story if all the ecosystem was io_uring centric, but
that's speculations.

> Of those, I personally would *love* to have at least pipe, socket,
> pidfd, memfd_create, and fsopen/fsmount/open_tree, plus some manner of
> dup-like operation for moving things between the fixed-file table and
> file descriptors.
> 
> I think this is valuable and versatile enough to merit a flag. It would
> also be entirely reasonable to create separate operations for these. But
> either way, I don't think this should just be determined by whether a
> 16-bit index is non-zero.
> 
>> I agree that it feels error-prone, but at least it can be wrapped
>> nicely enough in liburing, e.g.
>>
>> void io_uring_prep_openat_direct(struct io_uring_sqe *sqe, int dfd,
>> 				 const char *path, int flags,
>> 				 mode_t mode, int slot_idx);
> 
> That wrapper wouldn't be able to handle more than a 16-bit slot index
> though.

It would. Note, the index is "int" there, so if doesn't fit
into u16, we can fail it. And do conversion if required.

>>> Also, rather than using a 16-bit index for the fixed file table and
>>> potentially requiring expansion into a different field in the future,
>>> what about overlapping it with the nofile field in the open and accept
>>> requests? If they're not opening a normal file descriptor, they don't
>>> need nofile. And in the original sqe, you can then overlap it with a
>>> 32-bit field like splice_fd_in.
>>
>> There is no nofile in SQEs, though
>>
>> req->open.nofile = rlimit(RLIMIT_NOFILE);
> 
> nofile isn't needed for opening into the fixed-file table, so it could
> be omitted in that case, and another field unioned with it.

There is no problem to place it internally. Moreover, it's at the
moment uniformly placed inside io_kiocb, but with nofile we'd need
to find the place on per-op basis.

Not like any matters, it's just bike shedding.

> allow passing a 32-bit fixed-file index into open and accept without
> growing the size of their structures. I think, with this new capability,
> we're going to want a large number of fixed files available.
> 
> In the SQE, you could overlap it with the splice_fd_in field, which
> isn't needed by any calls other than splice.

But it doesn't mean it won't be used, as happened with pretty every
other field in SQE. So, it rather depends on what packing is wanted.
And reusing almost never used ->buf_index (and potentially ->ioprio),
sounds reasonable.

-- 
Pavel Begunkov
