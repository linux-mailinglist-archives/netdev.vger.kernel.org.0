Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A83E409F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 02:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbfJYAgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 20:36:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36162 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729728AbfJYAf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 20:35:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id v19so367232pfm.3
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 17:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vL4PIPj8ehIUie0vNmIQJ/s4e1QyV7Rwd473Kg98mYE=;
        b=1RK7f/0xmrPxKvsES56M+45yZyOKPfDF2/8ZOn44BIYkvjD2XhX2V3D9RsRq+Rm5Xb
         3/7BtT4+pPyE898cBaFqDj7v7lw8Xao1q8hCGDa5W3yIZNXMO3J+M17/PdMoWlztIQSD
         b6XFFfsudKy2lgdQZ0nb69IgMka/VgSGonQjRIufbIwKACWIptpn2np57qPZGwIv7+Sb
         qH9v+HkdEcFCjhvi+0yzlhY6ba7pjJ9QndQ8O6qfOwVbb4klJ7AYDiCtBX0H2SQ/9meR
         KPyq0NtSxLiDkkDdJZfKAsNc6DF7JRepM187DPbrqRoUEmr/bCGa5Fb4YlFKNu+cJqcd
         TuVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vL4PIPj8ehIUie0vNmIQJ/s4e1QyV7Rwd473Kg98mYE=;
        b=kLJ8oqQvc7kNPQ5IxXmcfOCAm74MbNzsP0Clo7UHLJKByWJaqtcPITsHwg8hwG0KOX
         2TXI8ftaagYnW4oea+VTWNQb7pj6HKzcdL8QHRrE/qQBJB7Oads08YZLtgdbJZor20HK
         H7hqaOaI+ypsBXznOA+vPKtW3LSftUKxfpcetek0chxOJu9kvsbpQgLG6ekFEbTS+c6m
         5U3McDWbKKCtbkYoem4MHSZzAfwXod7W/vU66v74p3dmW3YHlah5psst9Zl08gEpWdC0
         dI/cIeArzxCwyHHD6d3DWpeIK5uM9jgSFPEN65igU9F0IiUF57ZcfmDcAkQ3WGe9Heq8
         T8MQ==
X-Gm-Message-State: APjAAAUuJ11ZzB+KHV0+8P1NF04MPqpsM8HACfYlGqAcqch+dy0sEH6y
        TruXvYOvr4PgW/564YDRfbVER3/P1tpeVg==
X-Google-Smtp-Source: APXvYqzjnWug6iYnfbkLge73fmarfO/KW1fcReuopFNoYWl84u8oqUpGQ4p/iCCyuwn0yuMOJP1uNg==
X-Received: by 2002:a17:90a:19c1:: with SMTP id 1mr525113pjj.52.1571963756525;
        Thu, 24 Oct 2019 17:35:56 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id a8sm150105pfc.20.2019.10.24.17.35.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 17:35:55 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
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
 <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk>
 <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
 <c3fb07d4-223c-8835-5c22-68367e957a4f@kernel.dk>
 <CAG48ez0K_wtHA4DSWjz4TjohHkMTGo2pTpDVMZPQWD2gtrqZJw@mail.gmail.com>
 <c252182a-4d09-5e9b-112b-2dad9ef123b5@kernel.dk>
 <CAG48ez00zr2P1WCznnXmTvq+FQ4Ji8kDnuNqbeeMvOh_MhXeTg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <947c74b9-e828-e190-19fc-449c72a20798@kernel.dk>
Date:   Thu, 24 Oct 2019 18:35:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez00zr2P1WCznnXmTvq+FQ4Ji8kDnuNqbeeMvOh_MhXeTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 5:13 PM, Jann Horn wrote:
> On Fri, Oct 25, 2019 at 12:04 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/24/19 2:31 PM, Jann Horn wrote:
>>> On Thu, Oct 24, 2019 at 9:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 10/18/19 12:50 PM, Jann Horn wrote:
>>>>> On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 10/18/19 12:06 PM, Jann Horn wrote:
>>>>>>> But actually, by the way: Is this whole files_struct thing creating a
>>>>>>> reference loop? The files_struct has a reference to the uring file,
>>>>>>> and the uring file has ACCEPT work that has a reference to the
>>>>>>> files_struct. If the task gets killed and the accept work blocks, the
>>>>>>> entire files_struct will stay alive, right?
>>>>>>
>>>>>> Yes, for the lifetime of the request, it does create a loop. So if the
>>>>>> application goes away, I think you're right, the files_struct will stay.
>>>>>> And so will the io_uring, for that matter, as we depend on the closing
>>>>>> of the files to do the final reap.
>>>>>>
>>>>>> Hmm, not sure how best to handle that, to be honest. We need some way to
>>>>>> break the loop, if the request never finishes.
>>>>>
>>>>> A wacky and dubious approach would be to, instead of taking a
>>>>> reference to the files_struct, abuse f_op->flush() to synchronously
>>>>> flush out pending requests with references to the files_struct... But
>>>>> it's probably a bad idea, given that in f_op->flush(), you can't
>>>>> easily tell which files_struct the close is coming from. I suppose you
>>>>> could keep a list of (fdtable, fd) pairs through which ACCEPT requests
>>>>> have come in and then let f_op->flush() probe whether the file
>>>>> pointers are gone from them...
>>>>
>>>> Got back to this after finishing the io-wq stuff, which we need for the
>>>> cancel.
>>>>
>>>> Here's an updated patch:
>>>>
>>>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=1ea847edc58d6a54ca53001ad0c656da57257570
>>>>
>>>> that seems to work for me (lightly tested), we correctly find and cancel
>>>> work that is holding on to the file table.
>>>>
>>>> The full series sits on top of my for-5.5/io_uring-wq branch, and can be
>>>> viewed here:
>>>>
>>>> http://git.kernel.dk/cgit/linux-block/log/?h=for-5.5/io_uring-test
>>>>
>>>> Let me know what you think!
>>>
>>> Ah, I didn't realize that the second argument to f_op->flush is a
>>> pointer to the files_struct. That's neat.
>>>
>>>
>>> Security: There is no guarantee that ->flush() will run after the last
>>> io_uring_enter() finishes. You can race like this, with threads A and
>>> B in one process and C in another one:
>>>
>>> A: sends uring fd to C via unix domain socket
>>> A: starts syscall io_uring_enter(fd, ...)
>>> A: calls fdget(fd), takes reference to file
>>> B: starts syscall close(fd)
>>> B: fd table entry is removed
>>> B: f_op->flush is invoked and finds no pending transactions
>>> B: syscall close() returns
>>> A: continues io_uring_enter(), grabbing current->files
>>> A: io_uring_enter() returns
>>> A and B: exit
>>> worker: use-after-free access to files_struct
>>>
>>> I think the solution to this would be (unless you're fine with adding
>>> some broad global read-write mutex) something like this in
>>> __io_queue_sqe(), where "fd" and "f" are the variables from
>>> io_uring_enter(), plumbed through the stack somehow:
>>>
>>> if (req->flags & REQ_F_NEED_FILES) {
>>>     rcu_read_lock();
>>>     spin_lock_irq(&ctx->inflight_lock);
>>>     if (fcheck(fd) == f) {
>>>       list_add(&req->inflight_list,
>>>         &ctx->inflight_list);
>>>       req->work.files = current->files;
>>>       ret = 0;
>>>     } else {
>>>       ret = -EBADF;
>>>     }
>>>     spin_unlock_irq(&ctx->inflight_lock);
>>>     rcu_read_unlock();
>>>     if (ret)
>>>       goto put_req;
>>> }
>>
>> First of all, thanks for the thorough look at this! We already have f
>> available here, it's req->file. And we just made a copy of the sqe, so
>> we have sqe->fd available as well. I fixed this up.
> 
> sqe->fd is the file descriptor we're doing I/O on, not the file
> descriptor of the uring file, right? Same thing for req->file. This
> check only detects whether the fd we're doing I/O on was closed, which
> is irrelevant.

Duh yes, I'm an idiot. Easily fixable, I'll update this for the ring fd.

>>> Security + Correctness: If there is more than one io_wqe, it seems to
>>> me that io_uring_flush() calls io_wq_cancel_work(), which calls
>>> io_wqe_cancel_work(), which may return IO_WQ_CANCEL_OK if the first
>>> request it looks at is pending. In that case, io_wq_cancel_work() will
>>> immediately return, and io_uring_flush() will also immediately return.
>>> It looks like any other requests will continue running?
>>
>> Ah good point, I missed that. We need to keep looping until we get
>> NOTFOUND returned. Fixed as well.
>>
>> Also added cancellation if the task is going away. Here's the
>> incremental patch, I'll resend with the full version.
> [...]
>> +static int io_uring_flush(struct file *file, void *data)
>> +{
>> +       struct io_ring_ctx *ctx = file->private_data;
>> +
>> +       if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
>> +               io_wq_cancel_all(ctx->io_wq);
> 
> Looking at io_wq_cancel_all(), this will just send a signal to the
> task without waiting for anything, right? Isn't that unsafe?

Yes, that's a logic error, we should always do the
io_uring_cancel_files(). Ala:

	io_uring_cancel_files();
	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
		io_wq_cancel_all(ctx->io_wq);

Thanks!

-- 
Jens Axboe

