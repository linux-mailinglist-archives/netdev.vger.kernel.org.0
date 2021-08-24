Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B5C3F5B41
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhHXJtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbhHXJtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 05:49:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1212C061757;
        Tue, 24 Aug 2021 02:48:34 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u16so30365546wrn.5;
        Tue, 24 Aug 2021 02:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VG94zlDLd3x883YtDNmS9uT8EWoP3KBY06pFhvdSQaI=;
        b=CQBHBFnAtD6mkMLpOtKO9RFLxkb80vT2+QR+L1QtkN1NSsBESWSjsGq7Gl3eNihgUj
         sohg42ziimu0GKUktXRu/n1wmo4Ly/CGcR5wmuzMPQpfyYbwjukwoaaVIwHz8PvxH3bI
         w+NNRleGhgeMKWD96nblF42S7UjCi/vdng19ENXuB0eGlOEKvsp5z8M/3Ut6aGdAu0nR
         U7jVUAbgQ6tUngIOJhK8a5svIeigV5spkKSgEnv9F7Lt76TXf1NRFBqiza4jmh1442ld
         vndsPFoOq1L2DEqd0nUHv0EIdMlCCkN7tebOGe3IpNC6zQ2UJ/SF1gGA/vQtmhqJ0FOs
         DLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VG94zlDLd3x883YtDNmS9uT8EWoP3KBY06pFhvdSQaI=;
        b=ruXZ3oBuFQHwZVddpU4er3tpx/jCd5yylCaaG++AfYLKju5WMjrzd75qeAHfZ3HClv
         xPGJQrbUvSuZ3QVj1ltnMgxF0NSSco/vqQRVPwpFgDz7wr62ayA6zI/Qm+noxdVfg/az
         wAbw/pBYHPQVQvRmp0LAm5yNcRAM64whb7b3fJoLNeqiZpoYJ2j9hMnbkqPWtG0aE25k
         rYXZ63SqB77WQMUv5bHXg9LCpMxFXk2sVH6GiBo3qpxfwi0R76w4pOkaJ8YS3AgHl+12
         8jxffs22FyP3UufskiXoakb7TkAUAdtWospm+NgFWgDKrnBpNqfASYRW2yNX7zcfo48B
         ZPlg==
X-Gm-Message-State: AOAM530939PQM/XBM2tOA+powM3BIbDo/n0ElAxAGBZ5Fi3MQ7Y6w3SY
        pTOJmX3+RspDGViBmhgjQOM=
X-Google-Smtp-Source: ABdhPJxyPG8kH/z9iRJ/24fUQi24iEEOETzdkO/opyfzwMptxtbC5Qe1Wl+UHbqNLZhuzxy7tZ3cgQ==
X-Received: by 2002:adf:f8c8:: with SMTP id f8mr18824817wrq.204.1629798513621;
        Tue, 24 Aug 2021 02:48:33 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id z7sm1761767wmi.4.2021.08.24.02.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 02:48:33 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] open/accept directly into io_uring fixed file
 table
To:     Jens Axboe <axboe@kernel.dk>, Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1629559905.git.asml.silence@gmail.com>
 <7fa72eec-9222-60eb-9ec6-e4b6efbfc5fb@kernel.dk> <YSPzab+g8ee84bX7@localhost>
 <59494bda-f804-4185-dd7d-4827b14bae61@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <2527d712-bc8b-7393-f4c0-3035dd525b1e@gmail.com>
Date:   Tue, 24 Aug 2021 10:48:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <59494bda-f804-4185-dd7d-4827b14bae61@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/21 8:40 PM, Jens Axboe wrote:
> On 8/23/21 1:13 PM, Josh Triplett wrote:
>> On Sat, Aug 21, 2021 at 08:18:12PM -0600, Jens Axboe wrote:
>>> On 8/21/21 9:52 AM, Pavel Begunkov wrote:
>>>> Add an optional feature to open/accept directly into io_uring's fixed
>>>> file table bypassing the normal file table. Same behaviour if as the
>>>> snippet below, but in one operation:
>>>>
>>>> sqe = prep_[open,accept](...);
>>>> cqe = submit_and_wait(sqe);
>>>> io_uring_register_files_update(uring_idx, (fd = cqe->res));
>>>> close((fd = cqe->res));
>>>>
>>>> The idea in pretty old, and was brough up and implemented a year ago
>>>> by Josh Triplett, though haven't sought the light for some reasons.
>>>>
>>>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>>>> the old behaviour. If non-zero value is specified, then it will behave
>>>> as described and place the file into a fixed file slot
>>>> sqe->file_index - 1. A file table should be already created, the slot
>>>> should be valid and empty, otherwise the operation will fail.
>>>>
>>>> we can't use IOSQE_FIXED_FILE to switch between modes, because accept
>>>> takes a file, and it already uses the flag with a different meaning.
>>>>
>>>> since RFC:
>>>>  - added attribution
>>>>  - updated descriptions
>>>>  - rebased
>>>>
>>>> since v1:
>>>>  - EBADF if slot is already used (Josh Triplett)
>>>>  - alias index with splice_fd_in (Josh Triplett)
>>>>  - fix a bound check bug
>>>
>>> With the prep series, this looks good to me now. Josh, what do you
>>> think?
>>
>> I would still like to see this using a union with the `nofile` field in
>> io_open and io_accept, rather than overloading the 16-bit buf_index
>> field. That would avoid truncating to 16 bits, and make less work for
>> expansion to more than 16 bits of fixed file indexes.
>>
>> (I'd also like that to actually use a union, rather than overloading the
>> meaning of buf_index/nofile.)
> 
> Agree, and in fact there's room in the open and accept command parts, so
> we can just make it a separate entry there instead of using ->buf_index.
> Then just pass in the index to io_install_fixed_file() instead of having
> it pull it from req->buf_index.

That's internal details, can be expanded at wish in the future, if we'd
ever need larger tables. ->buf_index already holds indexes to different
resources just fine.

Aliasing with nofile would rather be ugly, so the only option, as you
mentioned, is to grab some space from open/accept structs, but don't see
why we'd want it when there is a more convenient alternative.

>> I personally still feel that using non-zero to signify index-plus-one is
>> both error-prone and not as future-compatible. I think we could do
>> better with no additional overhead. But I think the final call on that
>> interface is up to you, Jens. Do you think it'd be worth spending a flag
>> bit or using a different opcode, to get a cleaner interface? If you
>> don't, then I'd be fine with seeing this go in with just the io_open and
>> io_accept change.
> 
> I'd be inclined to go the extra opcode route instead, as the flag only
> really would make sense to requests that instantiate file descriptors.
> For this particular case, we'd need 3 new opcodes for
> openat/openat2/accept, which is probably a worthwhile expenditure.
> 
> Pavel, what do you think? Switch to using a different opcode for the new
> requests, and just grab some space in io_open and io_accept for the fd
> and pass it in to install.

I don't get it, why it's even called hackish? How that's anyhow better?
To me the feature looks like a natural extension to the operations, just
like a read can be tuned with flags, so and creating new opcodes seems
a bit ugly, unnecessary taking space from opcodes and adding duplication
(even if both versions call the same handler).

First, why it's not future-compatible? It's a serious argument, but I
don't see where it came from. Do I miss something?

It's u32 now, and so will easily cover all indexes. SQE fields should
always be zeroed, that's a rule, liburing follows it, and there would
have been already lots of problems for users not honoring it. And there
will be a helper hiding all the index conversions for convenience.

void io_uring_prep_open_direct(sqe, index, ...)
{
	io_uring_prep_open(sqe, ...);
	sqe->file_index = index + 1;
}

-- 
Pavel Begunkov
