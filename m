Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFC83EC933
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 15:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238145AbhHONBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 09:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbhHONBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 09:01:11 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C541C061764;
        Sun, 15 Aug 2021 06:00:41 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id g138so9866240wmg.4;
        Sun, 15 Aug 2021 06:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=srfloInibHXaJl9SxUAGFFuCdBbcpXrXkdFtSsa87so=;
        b=hReCxcPhsYYuZnNBgAFreot260ud5A7ljdqQ/R3ShO0+hvjppJh3ilfr36w842n+hK
         mAyqguaj2z060NECIwf0qEZWOTiYMvvNdCjDk1E1pkQTPKGdNzQLE28V/RB9t9894EWt
         sdrUGd9LKa1mmD8bDAsC4N417udYoXxdq2itlO6/TxyVlHjZ13EFj4+ZrFUO85NQ6UCA
         bKq7lQRaSdykfs3RjhxN4/L9BJMDUJzChLewkQux1s4U/SlYiE0mzFZmg3J9qXo0szPg
         +JaLVNBiPU/hCSDmoziG7C/3elLoXj0nYeSNr9kyWj6vJ/tLQ7Z6ScgNil9MZVo8Gqsr
         j5Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=srfloInibHXaJl9SxUAGFFuCdBbcpXrXkdFtSsa87so=;
        b=kiexqmNkdcy6nz+/NkFqNOYDFXNxEeIigNzPppz6ZaAOMuVxB5NExZ+ScZookvmci4
         gOpdRkc9dt9gFfcemWpfbcCsmtxARVJND3Knc0SbP0anntfyOV966m0gqN7DpydZcUx8
         KdvlmkmBDiDB+rTR5Y9Qa/jYajEi1FevLf1KF5nPE4IjMqHvfKkFpwA/lpa1rd1z0DFE
         w5/cSC06R50Hq11DxiA2eBFLXLhaZKVCX/F1muPJJ1sGpT0i1Jxdkhq9U95SQ6pmyrs9
         6ft6uhuVH9G7C+WYG98X8Zyu8Q+gGyVrv4Bc3lebbNTIBdLIkgYoyGmwI/bEKnoFugsq
         YLxw==
X-Gm-Message-State: AOAM532iMf0XqK3JeUrwD3eza+FkRpCgDAUwGXpntCp8qkN99ZmfErMU
        QOEytKdktz6X4aY+GbDEJow=
X-Google-Smtp-Source: ABdhPJyw0FfnJJ1BJ548Tr3Xd5So3JAbslMwlsQ2EOeTqWEokX+x2YBG3Twfwz1soNysIRqNAKQnUw==
X-Received: by 2002:a05:600c:154b:: with SMTP id f11mr11102098wmg.116.1629032439721;
        Sun, 15 Aug 2021 06:00:39 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id r1sm3004588wrt.24.2021.08.15.06.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Aug 2021 06:00:39 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost> <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
 <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <0338e4c0-9161-732d-7d3e-c53bdf9fbb0c@gmail.com>
Date:   Sun, 15 Aug 2021 14:00:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/15/21 12:03 AM, Jens Axboe wrote:
> On 8/14/21 6:50 AM, Pavel Begunkov wrote:
>> On 8/13/21 8:00 PM, Josh Triplett wrote:
>>> On Fri, Aug 13, 2021 at 05:43:09PM +0100, Pavel Begunkov wrote:
>>>> Add an optional feature to open/accept directly into io_uring's fixed
>>>> file table bypassing the normal file table. Same behaviour if as the
>>>> snippet below, but in one operation:
>>>>
>>>> sqe = prep_[open,accept](...);
>>>> cqe = submit_and_wait(sqe);
>>>> // error handling
>>>> io_uring_register_files_update(uring_idx, (fd = cqe->res));
>>>> // optionally
>>>> close((fd = cqe->res));
>>>>
>>>> The idea in pretty old, and was brough up and implemented a year ago
>>>> by Josh Triplett, though haven't sought the light for some reasons.
>>>
>>> Thank you for working to get this over the finish line!
>>>
>>>> Tested on basic cases, will be sent out as liburing patches later.
>>>>
>>>> A copy paste from 2/2 describing user API and some notes:
>>>>
>>>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>>>> the old behaviour. If non-zero value is specified, then it will behave
>>>> as described and place the file into a fixed file slot
>>>> sqe->file_index - 1. A file table should be already created, the slot
>>>> should be valid and empty, otherwise the operation will fail.
>>>>
>>>> Note 1: we can't use IOSQE_FIXED_FILE to switch between modes, because
>>>> accept takes a file, and it already uses the flag with a different
>>>> meaning.
>>>>
>>>> Note 2: it's u16, where in theory the limit for fixed file tables might
>>>> get increased in the future. If would ever happen so, we'll better
>>>> workaround later, e.g. by making ioprio to represent upper bits 16 bits.
>>>> The layout for open is tight already enough.
>>>
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
>>
>> The other reason is that there are only 2 bits left in sqe->flags,
>> and we may use them for something better, considering that it's
>> only open/accept and not much as this.
>>
>> I agree that it feels error-prone, but at least it can be wrapped
>> nicely enough in liburing, e.g.
>>
>> void io_uring_prep_openat_direct(struct io_uring_sqe *sqe, int dfd,
>> 				 const char *path, int flags,
>> 				 mode_t mode, int slot_idx);
>>
>>
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
> What's the plan in terms of limiting the amount of direct descriptors
> (for lack of a better word)? That seems like an important aspect that
> should get sorted out upfront.

As was brought before, agree that it have to be solved. However, don't
think it holds this feature, as the same problems can be perfectly
achieved without it.

fd = open();
io_uring_register(fd);
close(fd);

> Do we include the regular file table max_fds count for creating a new
> direct descriptor, and limit to RLIMIT_NOFILE? That would seem logical,
> but then that also implies that the regular file table should include
> the ctx (potentially several) direct descriptors. And the latter is much
> worse.

To which object we're binding the counting? To the task that created
the ring? I'd be afraid of the following case then:

fork(NO_FDTABLE_SHARE, callback -> {
	ring = create_io_uring();
	io_uring_register_fds(&ring);
	pass_ring_to_parent(ring);
	// e.g. via socket or so.
	exit();
});

Restricting based on user may have been a better option, but as well
not without problems.

Another option, which is too ugly to exist but have to mention,
is to count number of tasks and io_urings together. Maybe can spark
some better idea.

Also, do we have anything related in cgroups/namespaces?

> Maybe we have a way to size the direct table, which will consume entries
> from the same pool that the regular file table does? That would then
> work both ways, and could potentially just be done dynamically similarly
> to how we expand the regular file table when we exceed its current size.
> 
> Anyway, just throwing a few ideas out there, with the intent to spark a
> bit of discussion on this topic. I really like the direct descriptors,
> it'll be a lot more efficient for certain use cases.
> 

-- 
Pavel Begunkov
