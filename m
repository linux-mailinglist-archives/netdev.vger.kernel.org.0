Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18D6CDCBA7
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407837AbfJRQgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:36:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45858 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390036AbfJRQgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:36:32 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1so3646743pgj.12
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rWLs6Xuc3aJC0s0delqoDli8RYMmapuhff73waYsGtY=;
        b=AfR7j+fKA2c8DHDcxPY9fGz4gy2w1xUP0WHZe8VBKkez/uJ5S27VRq0sl/hVEpKoZO
         yy75VizWut/ylGy9uoA/ZOrFXLK2XZOSlu/PUQxXcGH8EnIKAFdWsPXDnzos6YIw73+C
         r4cMjEoXgC+5kT/DS6RpO+4rzGTqxcSDBu7MASCS4TTqqNBvzPW7bxWoHzvl1T2V7rxl
         jqpcR4cF1ZzyGb9p7AJ9wLyVnnDe9TyZ8Q69BtJlrSVI4dST5kZWnJg9RVlaTXACEQhm
         pFFykQatyhMoMtnGpunWdEkcmD4SJJzqTUMjItKXLoC7lmePJtaMwyEYMtgsk1uz4tYH
         gX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWLs6Xuc3aJC0s0delqoDli8RYMmapuhff73waYsGtY=;
        b=XOr4jOvF2fyiLJ5Y3YTXOPexua9ijVPnSDUoJVRU186vmI1qJDwjCwRlXF8OaeSTU9
         OCM/07Xn7eTDaw8IAU0tiPJOHpqVqh3/GYPDa5rRwn23vwESnCP6puDpFfqgkCETZzNW
         2crBeHIgaJHjzxfHvnhMEypRu+m8YJFk67/WptlsbERayCwoILPkZksbiRF5cisJo/qW
         8BjkXRObRu1PubwKx+JrxJ5ndaIuwBF4CTiqPJmgv+Uwq2x7Vbxb4/S9iZRClPp42/Sr
         hJYDxv0TbxtundJMcuQHGGZEiCk5LFu0xKPX7PAuh0ykEr6E+6PUB5YO8bktHCRBXO1Z
         aqSg==
X-Gm-Message-State: APjAAAWGnU7xvuCNdMJ5EhAkJlCjtHxoqK6462S0C3QKy6TrWOVriXaa
        Ev1DEcQ5qAN8l0MApeRuLl/SuuOGkVscIg==
X-Google-Smtp-Source: APXvYqwLWsAjNyv0O5PRoFjzmTVjhvNhmHsItJjRJYU2gj2UFw7QsUBLK7PfTTz6vvOdmQtuSdJS5g==
X-Received: by 2002:a62:2ec5:: with SMTP id u188mr7635072pfu.252.1571416589407;
        Fri, 18 Oct 2019 09:36:29 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id o64sm15326856pjb.24.2019.10.18.09.36.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:36:28 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk>
Date:   Fri, 18 Oct 2019 10:36:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/19 10:20 AM, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 5:55 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/18/19 9:00 AM, Jens Axboe wrote:
>>> On 10/18/19 8:52 AM, Jann Horn wrote:
>>>> On Fri, Oct 18, 2019 at 4:43 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 10/18/19 8:40 AM, Jann Horn wrote:
>>>>>> On Fri, Oct 18, 2019 at 4:37 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> On 10/18/19 8:34 AM, Jann Horn wrote:
>>>>>>>> On Fri, Oct 18, 2019 at 4:01 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>> On 10/17/19 8:41 PM, Jann Horn wrote:
>>>>>>>>>> On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>>> This is in preparation for adding opcodes that need to modify files
>>>>>>>>>>> in a process file table, either adding new ones or closing old ones.
>>>>>>>> [...]
>>>>>>>>> Updated patch1:
>>>>>>>>>
>>>>>>>>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=df6caac708dae8ee9a74c9016e479b02ad78d436
>>>>>>>>
>>>>>>>> I don't understand what you're doing with old_files in there. In the
>>>>>>>> "s->files && !old_files" branch, "current->files = s->files" happens
>>>>>>>> without holding task_lock(), but current->files and s->files are also
>>>>>>>> the same already at that point anyway. And what's the intent behind
>>>>>>>> assigning stuff to old_files inside the loop? Isn't that going to
>>>>>>>> cause the workqueue to keep a modified current->files beyond the
>>>>>>>> runtime of the work?
>>>>>>>
>>>>>>> I simply forgot to remove the old block, it should only have this one:
>>>>>>>
>>>>>>> if (s->files && s->files != cur_files) {
>>>>>>>             task_lock(current);
>>>>>>>             current->files = s->files;
>>>>>>>             task_unlock(current);
>>>>>>>             if (cur_files)
>>>>>>>                     put_files_struct(cur_files);
>>>>>>>             cur_files = s->files;
>>>>>>> }
>>>>>>
>>>>>> Don't you still need a put_files_struct() in the case where "s->files
>>>>>> == cur_files"?
>>>>>
>>>>> I want to hold on to the files for as long as I can, to avoid unnecessary
>>>>> shuffling of it. But I take it your worry here is that we'll be calling
>>>>> something that manipulates ->files? Nothing should do that, unless
>>>>> s->files is set. We didn't hide the workqueue ->files[] before this
>>>>> change either.
>>>>
>>>> No, my worry is that the refcount of the files_struct is left too
>>>> high. From what I can tell, the "do" loop in io_sq_wq_submit_work()
>>>> iterates over multiple instances of struct sqe_submit. If there are
>>>> two sqe_submit instances with the same ->files (each holding a
>>>> reference from the get_files_struct() in __io_queue_sqe()), then:
>>>>
>>>> When processing the first sqe_submit instance, current->files and
>>>> cur_files are set to $user_files.
>>>> When processing the second sqe_submit instance, nothing happens
>>>> (s->files == cur_files).
>>>> After the loop, at the end of the function, put_files_struct() is
>>>> called once on $user_files.
>>>>
>>>> So get_files_struct() has been called twice, but put_files_struct()
>>>> has only been called once. That leaves the refcount too high, and by
>>>> repeating this, an attacker can make the refcount wrap around and then
>>>> cause a use-after-free.
>>>
>>> Ah now I see what you are getting at, yes that's clearly a bug! I wonder
>>> how we best safely can batch the drops. We can track the number of times
>>> we've used the same files, and do atomic_sub_and_test() in a
>>> put_files_struct_many() type addition. But that would leave us open to
>>> the issue you describe, where someone could maliciously overflow the
>>> files ref count.
>>>
>>> Probably not worth over-optimizing, as long as we can avoid the
>>> current->files task lock/unlock and shuffle.
>>>
>>> I'll update the patch.
>>
>> Alright, this incremental on top should do it. And full updated patch
>> here:
>>
>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=40449c5a3d3b16796fa13e9469c69d62986e961c
>>
>> Let me know what you think.
> 
> Ignoring the locking elision, basically the logic is now this:
> 
> static void io_sq_wq_submit_work(struct work_struct *work)
> {
>          struct io_kiocb *req = container_of(work, struct io_kiocb, work);
>          struct files_struct *cur_files = NULL, *old_files;
>          [...]
>          old_files = current->files;
>          [...]
>          do {
>                  struct sqe_submit *s = &req->submit;
>                  [...]
>                  if (cur_files)
>                          /* drop cur_files reference; borrow lifetime must
>                           * end before here */
>                          put_files_struct(cur_files);
>                  /* move reference ownership to cur_files */
>                  cur_files = s->files;
>                  if (cur_files) {
>                          task_lock(current);
>                          /* current->files borrows reference from cur_files;
>                           * existing borrow from previous loop ends here */
>                          current->files = cur_files;
>                          task_unlock(current);
>                  }
> 
>                  [call __io_submit_sqe()]
>                  [...]
>          } while (req);
>          [...]
>          /* existing borrow ends here */
>          task_lock(current);
>          current->files = old_files;
>          task_unlock(current);
>          if (cur_files)
>                  /* drop cur_files reference; borrow lifetime must
>                   * end before here */
>                  put_files_struct(cur_files);
> }
> 
> If you run two iterations of this loop, with a first element that has
> a ->files pointer and a second element that doesn't, then in the
> second run through the loop, the reference to the files_struct will be
> dropped while current->files still points to it; current->files is
> only reset after the loop has ended. If someone accesses
> current->files through procfs directly after that, AFAICS you'd get a
> use-after-free.

Amazing how this is still broken. You are right, and it's especially
annoying since that's exactly the case I originally talked about (not
flipping current->files if we don't have to). I just did it wrong, so
we'll leave a dangling pointer in ->files.

The by far most common case is if one sqe has a files it needs to
attach, then others that also have files will be the same set. So I want
to optimize for the case where we only flip current->files once when we
see the files, and once when we're done with the loop.

Let me see if I can get this right...

-- 
Jens Axboe

