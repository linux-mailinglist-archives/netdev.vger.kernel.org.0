Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BFD3F60D2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 16:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbhHXOpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 10:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237890AbhHXOpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 10:45:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFD4C061764;
        Tue, 24 Aug 2021 07:44:17 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v10so20480840wrd.4;
        Tue, 24 Aug 2021 07:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1NzbKqbkTUbaFr+lA6+JmiCj0QXO0t1xf2uOeDq9W8Q=;
        b=QIWtxOCX0oHdFAhMS0IA+Nk/oigUtaZqVLUx+1JyZzUkGeFvj66ZPB4rEzpmC/KKUJ
         nRwsRbine1J6TlOGxl7jhaZzTj0CISRCUtp/3F/0TNtxGc3pvkC14lmd4RsFhMVGc4Ht
         R6RmvTtyk2fk9EbE2Mb2AKc7SnCwnGVJ3StiCbSVnU82frso0FicLyNLp4mm3lA855Bc
         usNz+hVKdO6zLKvNMAhcCjS67mMSwqw/9vUu/fSS2B3tlkwWA6C4h9d7WBtjq26eqvNp
         6tskO4cQIpQdM4HGHbUGeoxSLfitKpA2T1X4BcmcXW1IhxR6fxCHO1PpbnzIuHZM0F9v
         vPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1NzbKqbkTUbaFr+lA6+JmiCj0QXO0t1xf2uOeDq9W8Q=;
        b=SglvO4XD/0AWr6ERK1qHUaUlHu87tplO/lWsRiqupKHG6xBm3xPWdVXbJ30gC9FBwm
         04ZDGUdud7aYu7KeGec1tdmmGl3CO8TU1reiBMxNYX1WceWZeujQndbHYKwHuMg2zImG
         oEMmJysG+/sf5G8cdYYjpsia60vgxHUoWIQ6dFcurUF8xCt9DlZW4+DIIvdVgoxSQVYW
         ms9D3pL6oQU70bRfESncoVlYMebg0kxjOfPbABHupiZBNMrrPuAe9BuHLcuAI26SOwJ8
         ve0Avuu3RccktgPuKnlDhm876Xhc9iv/66D4bpXHBzGW2DwjmsFrCSYu3QO8n89BgN0g
         qcog==
X-Gm-Message-State: AOAM531BbBrlP4q6En/PXgqLpXID3xEMNH+dhrEhaV6y+Kp/292UE+8E
        Xnl1JMlSKEQV8+xEmKIPdV0=
X-Google-Smtp-Source: ABdhPJwVzopxdLaEHLT47W3U+AaaD3NlZ7TYfWpSMAL/CjrUYRkdBmkjawuQUMi15yYA2TNeP4StzA==
X-Received: by 2002:adf:e711:: with SMTP id c17mr1160877wrm.417.1629816256556;
        Tue, 24 Aug 2021 07:44:16 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.113])
        by smtp.gmail.com with ESMTPSA id o7sm2452557wmc.46.2021.08.24.07.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Aug 2021 07:44:16 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
References: <cover.1629559905.git.asml.silence@gmail.com>
 <7fa72eec-9222-60eb-9ec6-e4b6efbfc5fb@kernel.dk> <YSPzab+g8ee84bX7@localhost>
 <59494bda-f804-4185-dd7d-4827b14bae61@kernel.dk>
 <2527d712-bc8b-7393-f4c0-3035dd525b1e@gmail.com>
 <c4653859-4003-70db-8b81-291dd17a6718@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v3 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <ce1aba5d-3fdd-092d-9870-ff989642ffd2@gmail.com>
Date:   Tue, 24 Aug 2021 15:43:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c4653859-4003-70db-8b81-291dd17a6718@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/24/21 3:02 PM, Jens Axboe wrote:
> On 8/24/21 3:48 AM, Pavel Begunkov wrote:
>> On 8/23/21 8:40 PM, Jens Axboe wrote:
>>> On 8/23/21 1:13 PM, Josh Triplett wrote:
>>>> On Sat, Aug 21, 2021 at 08:18:12PM -0600, Jens Axboe wrote:
>>>>> On 8/21/21 9:52 AM, Pavel Begunkov wrote:
>>>>>> Add an optional feature to open/accept directly into io_uring's fixed
>>>>>> file table bypassing the normal file table. Same behaviour if as the
>>>>>> snippet below, but in one operation:
>>>>>>
>>>>>> sqe = prep_[open,accept](...);
>>>>>> cqe = submit_and_wait(sqe);
>>>>>> io_uring_register_files_update(uring_idx, (fd = cqe->res));
>>>>>> close((fd = cqe->res));
>>>>>>
>>>>>> The idea in pretty old, and was brough up and implemented a year ago
>>>>>> by Josh Triplett, though haven't sought the light for some reasons.
>>>>>>
>>>>>> The behaviour is controlled by setting sqe->file_index, where 0 implies
>>>>>> the old behaviour. If non-zero value is specified, then it will behave
>>>>>> as described and place the file into a fixed file slot
>>>>>> sqe->file_index - 1. A file table should be already created, the slot
>>>>>> should be valid and empty, otherwise the operation will fail.
>>>>>>
>>>>>> we can't use IOSQE_FIXED_FILE to switch between modes, because accept
>>>>>> takes a file, and it already uses the flag with a different meaning.
>>>>>>
>>>>>> since RFC:
>>>>>>  - added attribution
>>>>>>  - updated descriptions
>>>>>>  - rebased
>>>>>>
>>>>>> since v1:
>>>>>>  - EBADF if slot is already used (Josh Triplett)
>>>>>>  - alias index with splice_fd_in (Josh Triplett)
>>>>>>  - fix a bound check bug
>>>>>
>>>>> With the prep series, this looks good to me now. Josh, what do you
>>>>> think?
>>>>
>>>> I would still like to see this using a union with the `nofile` field in
>>>> io_open and io_accept, rather than overloading the 16-bit buf_index
>>>> field. That would avoid truncating to 16 bits, and make less work for
>>>> expansion to more than 16 bits of fixed file indexes.
>>>>
>>>> (I'd also like that to actually use a union, rather than overloading the
>>>> meaning of buf_index/nofile.)
>>>
>>> Agree, and in fact there's room in the open and accept command parts, so
>>> we can just make it a separate entry there instead of using ->buf_index.
>>> Then just pass in the index to io_install_fixed_file() instead of having
>>> it pull it from req->buf_index.
>>
>> That's internal details, can be expanded at wish in the future, if we'd
>> ever need larger tables. ->buf_index already holds indexes to different
>> resources just fine.
> 
> Sure it's internal and can always be changed, doesn't change the fact
> that it's a bit iffy that it's used differently in different spots. As
> it costs us nothing to simply add a 'fixed_file' u32 for io_accept and
> io_open, I really think that should be done instead.
> 
>> Aliasing with nofile would rather be ugly, so the only option, as you
>> mentioned, is to grab some space from open/accept structs, but don't see
>> why we'd want it when there is a more convenient alternative.
> 
> Because it's a lot more readable and less error prone imho. Agree on the
> union, we don't have to resort to that.

Ok, I don't have a strong opinion on that. Will resend



>>>> I personally still feel that using non-zero to signify index-plus-one is
>>>> both error-prone and not as future-compatible. I think we could do
>>>> better with no additional overhead. But I think the final call on that
>>>> interface is up to you, Jens. Do you think it'd be worth spending a flag
>>>> bit or using a different opcode, to get a cleaner interface? If you
>>>> don't, then I'd be fine with seeing this go in with just the io_open and
>>>> io_accept change.
>>>
>>> I'd be inclined to go the extra opcode route instead, as the flag only
>>> really would make sense to requests that instantiate file descriptors.
>>> For this particular case, we'd need 3 new opcodes for
>>> openat/openat2/accept, which is probably a worthwhile expenditure.
>>>
>>> Pavel, what do you think? Switch to using a different opcode for the new
>>> requests, and just grab some space in io_open and io_accept for the fd
>>> and pass it in to install.
>>
>> I don't get it, why it's even called hackish? How that's anyhow better?
>> To me the feature looks like a natural extension to the operations, just
>> like a read can be tuned with flags, so and creating new opcodes seems
>> a bit ugly, unnecessary taking space from opcodes and adding duplication
>> (even if both versions call the same handler).
> 
> I agree that it's a natural extension, the problem is that we have to do
> unnatural things (somewhat) to make it work. I'm fine with using the
> union for the splice_fd_in to pass it in, I don't think it's a big deal.
> 
> I do wish that IORING_OP_CLOSE would work with them, though. I think we
> should to that as a followup patch. It's a bit odd to be able to open a
> file with IORING_OP_OPENAT and not being able to close it with
> IORING_OP_CLOSE. For the latter, we should just give it fixed file
> support, which would be pretty trivial.
> 
>> First, why it's not future-compatible? It's a serious argument, but I
>> don't see where it came from. Do I miss something?
>>
>> It's u32 now, and so will easily cover all indexes. SQE fields should
>> always be zeroed, that's a rule, liburing follows it, and there would
>> have been already lots of problems for users not honoring it. And there
>> will be a helper hiding all the index conversions for convenience.
>>
>> void io_uring_prep_open_direct(sqe, index, ...)
>> {
>> 	io_uring_prep_open(sqe, ...);
>> 	sqe->file_index = index + 1;
>> }
> 
> Let's keep it the way that it is, but I do want to see the buf_index
> thing go away and just req->open.fixed_file or whatever being used for
> open and accept. We should fold that in.

-- 
Pavel Begunkov
