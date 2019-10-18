Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8894DCDBD
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390871AbfJRSQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:16:46 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33263 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390451AbfJRSQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:16:46 -0400
Received: by mail-io1-f66.google.com with SMTP id z19so8586287ior.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kDwmqZlZ661Tf41Jm0+qlUgZsngoI6Idz7iYDn7Uyog=;
        b=POsBPqUklrdqQyoNz/bgC9418vXYq3UkOnzPhvw2ovg/hefjhvwRkN+wCxMMk9NqKp
         owc06kdinlnLcdegQbKgOLppqUj7HwMTMs1Roy/DmV3HQF/wpv0LGCkt2qWr+iYHH6g3
         E8FzWuvUdhkOvhIXSzZHuedlWi4TxyC5pI3oW+3rLKr/OI2BD2QjxzAIw0mfjJjaZZeo
         pOXUgN4UjHqLkOVvgAU/d8lZPU6hkxjtzfkbIO2V2LSWn0HuNCwGN9UBrGCYNEI3bxJf
         3ITkqSLko6ZBPijAa3AAeRrP3LjIh8kqE/vP0dN1z3o9KuPuyHs4IJGsRc0HQJ6DbeF0
         iU0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kDwmqZlZ661Tf41Jm0+qlUgZsngoI6Idz7iYDn7Uyog=;
        b=Bi7lpbSgwUzjKCLXOhMJJUvSonQGozaKH8mthl/FKAYR+WTJZv/09UcZI/AJZvOm59
         su+qCdQmrahB64fAcA+nay10Nqh4D1kEmXeI8Q8nugZCMz5dkp6DrhuOUPFWiOtiBoNK
         VVyp7te38bnpFHdIXGs7r+2FzCLlGmHbXXSn10wpYWLAGeK1dx7Tit2Jqec3ENmv8bxr
         0FH2BVsRiYJCtHMK4YIhZkqVCBCcv9zdbjpf5eXCH2mQK31IM8IcpcNVGn0izkbOH9g5
         bhMRobX6pXbBwp7d0/KW6OMLMxDfAmImeAkY9ZE3hzTBAuNfv7EMIke3/jIWjlKJADI/
         Ul7A==
X-Gm-Message-State: APjAAAXfgkpCPu569TbvPDWFDcztRWb5bPaxT9SuKTMxh3lBWk5tW4hR
        4t7zuCgn8wIG6J5KYGx1wUNCi9fcikXRBA==
X-Google-Smtp-Source: APXvYqzoulRgY44i30xBK+MqqJrlP6rSgDKQoWCHrndT8oRUDXWmhqpQDQZM1ktex7rk0IZfo9vBEQ==
X-Received: by 2002:a5d:8946:: with SMTP id b6mr9409434iot.191.1571422603953;
        Fri, 18 Oct 2019 11:16:43 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e1sm2131951ioq.67.2019.10.18.11.16.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 11:16:42 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk>
 <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk>
 <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk>
 <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
 <a8fb7a1f-69c7-bf2a-b3dd-7886077d234b@kernel.dk>
 <572f40fb-201c-99ce-b3f5-05ff9369b895@kernel.dk>
 <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
 <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk>
 <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
 <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk>
Date:   Fri, 18 Oct 2019 12:16:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/19 12:06 PM, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 7:05 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/18/19 10:36 AM, Jens Axboe wrote:
>>>> Ignoring the locking elision, basically the logic is now this:
>>>>
>>>> static void io_sq_wq_submit_work(struct work_struct *work)
>>>> {
>>>>            struct io_kiocb *req = container_of(work, struct io_kiocb, work);
>>>>            struct files_struct *cur_files = NULL, *old_files;
>>>>            [...]
>>>>            old_files = current->files;
>>>>            [...]
>>>>            do {
>>>>                    struct sqe_submit *s = &req->submit;
>>>>                    [...]
>>>>                    if (cur_files)
>>>>                            /* drop cur_files reference; borrow lifetime must
>>>>                             * end before here */
>>>>                            put_files_struct(cur_files);
>>>>                    /* move reference ownership to cur_files */
>>>>                    cur_files = s->files;
>>>>                    if (cur_files) {
>>>>                            task_lock(current);
>>>>                            /* current->files borrows reference from cur_files;
>>>>                             * existing borrow from previous loop ends here */
>>>>                            current->files = cur_files;
>>>>                            task_unlock(current);
>>>>                    }
>>>>
>>>>                    [call __io_submit_sqe()]
>>>>                    [...]
>>>>            } while (req);
>>>>            [...]
>>>>            /* existing borrow ends here */
>>>>            task_lock(current);
>>>>            current->files = old_files;
>>>>            task_unlock(current);
>>>>            if (cur_files)
>>>>                    /* drop cur_files reference; borrow lifetime must
>>>>                     * end before here */
>>>>                    put_files_struct(cur_files);
>>>> }
>>>>
>>>> If you run two iterations of this loop, with a first element that has
>>>> a ->files pointer and a second element that doesn't, then in the
>>>> second run through the loop, the reference to the files_struct will be
>>>> dropped while current->files still points to it; current->files is
>>>> only reset after the loop has ended. If someone accesses
>>>> current->files through procfs directly after that, AFAICS you'd get a
>>>> use-after-free.
>>>
>>> Amazing how this is still broken. You are right, and it's especially
>>> annoying since that's exactly the case I originally talked about (not
>>> flipping current->files if we don't have to). I just did it wrong, so
>>> we'll leave a dangling pointer in ->files.
>>>
>>> The by far most common case is if one sqe has a files it needs to
>>> attach, then others that also have files will be the same set. So I want
>>> to optimize for the case where we only flip current->files once when we
>>> see the files, and once when we're done with the loop.
>>>
>>> Let me see if I can get this right...
>>
>> I _think_ the simplest way to do it is simply to have both cur_files and
>> current->files hold a reference to the file table. That won't really add
>> any extra cost as the double increments / decrements are following each
>> other. Something like this incremental, totally untested.
>>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 2fed0badad38..b3cf3f3d7911 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2293,9 +2293,14 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>>                          put_files_struct(cur_files);
>>                  cur_files = s->files;
>>                  if (cur_files && cur_files != current->files) {
>> +                       struct files_struct *old;
>> +
>> +                       atomic_inc(&cur_files->count);
>>                          task_lock(current);
>> +                       old = current->files;
>>                          current->files = cur_files;
>>                          task_unlock(current);
>> +                       put_files_struct(old);
>>                  }
>>
>>                  if (!ret) {
>> @@ -2390,9 +2395,13 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>>                  mmput(cur_mm);
>>          }
>>          if (old_files != current->files) {
>> +               struct files_struct *old;
>> +
>>                  task_lock(current);
>> +               old = current->files;
>>                  current->files = old_files;
>>                  task_unlock(current);
>> +               put_files_struct(old);
>>          }
>>          if (cur_files)
>>                  put_files_struct(cur_files);
> 
> The only part I still feel a bit twitchy about is this part at the end:
> 
>          if (old_files != current->files) {
>                  struct files_struct *old;
> 
>                  task_lock(current);
>                  old = current->files;
>                  current->files = old_files;
>                  task_unlock(current);
>                  put_files_struct(old);
>          }
> 
> If it was possible for the initial ->files to be the same as the
> ->files of a submission, and we got two submissions with first a
> different files_struct and then our old one, then this branch would
> not be executed even though it should, which would leave the refcount
> of the files_struct one too high. But that probably can't happen?
> Since kernel workers should be running with &init_files (I think?) and
> that thing is never used for userspace tasks. But still, I'd feel
> better if you could change it like this:

Right, that is never going to happen. But your solution is simpler,
so... I'll throw some testing at it.

> But actually, by the way: Is this whole files_struct thing creating a
> reference loop? The files_struct has a reference to the uring file,
> and the uring file has ACCEPT work that has a reference to the
> files_struct. If the task gets killed and the accept work blocks, the
> entire files_struct will stay alive, right?

Yes, for the lifetime of the request, it does create a loop. So if the
application goes away, I think you're right, the files_struct will stay.
And so will the io_uring, for that matter, as we depend on the closing
of the files to do the final reap.

Hmm, not sure how best to handle that, to be honest. We need some way to
break the loop, if the request never finishes.

-- 
Jens Axboe

