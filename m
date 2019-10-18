Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00720DC6BB
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408633AbfJROB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:01:26 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39519 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393182AbfJROB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:01:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so3961707pff.6
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 07:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hf1qVJNxJFGIEDbuKHU/SYAxW3Q+MBcdUlTEY/Ap0o4=;
        b=XY5WG2UIaJ8O87eMvYCBtsY2FjZFIvlITUngfd+YX1v9v0JOPnSVSlHEsHotfE7I0U
         4NrZldV5MAXNibDkPiYPE3MIDbjjFRl7J5JCtzBoHf/lGVm9jnDnDQg/z/TiGd7JBNP5
         CErKSYSabju1x9ueVtFwnPt21CStFjgQrQKkUgvZsJ4DVNVA1jghvXOmrktNkZKXSQJX
         OeyUjeCQRlT3qNBy0/4Opol6JYDRoqShYs3F+bfCtx2pWa5qn+nXxbi/9VT89HEz2w4g
         UWHc8r5oQ0It1NooBVdZQ6EVsnwmzjFSUXUkD3BQN4nXDV/tpHnoDrWhiEXPMcsAgejo
         VM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hf1qVJNxJFGIEDbuKHU/SYAxW3Q+MBcdUlTEY/Ap0o4=;
        b=RY6AM3/Az/DzYV/bJF++8AVZoCT+OvQVewtYE4YMeP/+lHt/2BMzPtD7AceuLjH+1T
         +1HDSfIt+nFEdDqKhAqEMnNKuqKUF2Kr3a6sqlOvMjVIAgNOFF06Ahvj+pgycPSMulcJ
         DYrY8eh6mcYgsjObZFCD1x/9SVrr7RXFZtTHgKGtxviZ96/sKIjj/zrTGUB3zl7e0zUt
         1NUGYtxs66YC+CYCYtrriflIW4XlzUwYsyT9XXAUSo4Ob3PIHGIeQ8SJ8SsEZYMiCtng
         IPqHVIQCZvTApuNKTdKw9UHhZBPFahAGI0XPnkGXqOIBhmwYk6nRS8yGfIXZcAOsLnA/
         6T7w==
X-Gm-Message-State: APjAAAV/E5KbEfzovhjZoAFGDGJsQ1iUxqmBfq6Y/Q3jGc/86yN5oHG7
        UaGS4Ks5EdrpLoBJixwRd5DCEEwagabQKA==
X-Google-Smtp-Source: APXvYqyvXWQvv8i6cBSexk18xZE1lGg7o0uO9hnccodCg5ctN4NgikzjGLepkJCLLWCJsKq0R1lh6Q==
X-Received: by 2002:a63:709:: with SMTP id 9mr10389888pgh.445.1571407284165;
        Fri, 18 Oct 2019 07:01:24 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id x20sm10019163pfp.120.2019.10.18.07.01.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 07:01:23 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
 <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk>
Date:   Fri, 18 Oct 2019 08:01:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17/19 8:41 PM, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 4:01 AM Jens Axboe <axboe@kernel.dk> wrote:
>> This is in preparation for adding opcodes that need to modify files
>> in a process file table, either adding new ones or closing old ones.
> 
> Closing old ones would be tricky. Basically if you call
> get_files_struct() while you're between an fdget()/fdput() pair (e.g.
> from sys_io_uring_enter()), you're not allowed to use that
> files_struct reference to replace or close existing FDs through that
> reference. (Or more accurately, if you go through fdget() with
> files_struct refcount 1, you must not replace/close FDs in there in
> any way until you've passed the corresponding fdput().)
> 
> You can avoid that if you ensure that you never use fdget()/fdput() in
> the relevant places, only fget()/fput().

That's a good point, I didn't think the closing aspect through when
writing that changelog. File addition is the most interesting aspect,
obviously, and the only part that I care about in this patch set. I'll
change the wording.

>> If an opcode needs this, it must set REQ_F_NEED_FILES in the request
>> structure. If work that needs to get punted to async context have this
>> set, they will grab a reference to the process file table. When the
>> work is completed, the reference is dropped again.
> [...]
>> @@ -2220,6 +2223,10 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>>                                  set_fs(USER_DS);
>>                          }
>>                  }
>> +               if (s->files && !old_files) {
>> +                       old_files = current->files;
>> +                       current->files = s->files;
>> +               }
> 
> AFAIK e.g. stuff like proc_fd_link() in procfs can concurrently call
> get_files_struct() even on kernel tasks, so you should take the
> task_lock(current) while fiddling with the ->files pointer.

Fixed up, thanks!

> Also, maybe I'm too tired to read this correctly, but it seems like
> when io_sq_wq_submit_work() is processing multiple elements with
> ->files pointers, this part will only consume a reference to the first
> one?

Like the mm, we should only have the one file table. But there's no
reason to not handle this properly, I've amended the commit to properly
swap so it works for any number of file tables.

>>                  if (!ret) {
>>                          s->has_user = cur_mm != NULL;
>> @@ -2312,6 +2319,11 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>>                  unuse_mm(cur_mm);
>>                  mmput(cur_mm);
>>          }
>> +       if (old_files) {
>> +               struct files_struct *files = current->files;
>> +               current->files = old_files;
>> +               put_files_struct(files);
>> +       }
> 
> And then here the first files_struct reference is dropped, and the
> rest of them leak?

Fixed with the above change.

>> @@ -2413,6 +2425,8 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>>
>>                          s->sqe = sqe_copy;
>>                          memcpy(&req->submit, s, sizeof(*s));
>> +                       if (req->flags & REQ_F_NEED_FILES)
>> +                               req->submit.files = get_files_struct(current);
> 
> Stupid question: How does this interact with sqpoll mode? In that
> case, this function is running on a kernel thread that isn't sharing
> the application's files_struct, right?

Not a stupid question! It doesn't work with sqpoll. We need to be
entered on behalf of the task, and we never see that with sqpoll (except
if NEED_WAKE is set in flags).

For now I'll just forbid it explicitly in io_accept(), just like we do
for IORING_SETUP_IOPOLL.

Updated patch1:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=df6caac708dae8ee9a74c9016e479b02ad78d436

and patch 3:

http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=442bb35fc4f8f28c29ea220475c45babb44ee49c

-- 
Jens Axboe

