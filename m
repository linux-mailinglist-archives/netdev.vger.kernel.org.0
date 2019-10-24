Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A10E404A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 01:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfJXXNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 19:13:50 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46414 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbfJXXNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 19:13:49 -0400
Received: by mail-oi1-f193.google.com with SMTP id c2so98004oic.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 16:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+eK+5fkzYxyunCal9Tn719EPwXUpc/8mT0s2MAFKdkg=;
        b=SEJZ2Aok3JBqRf+BoSSTatvK5FJhVAunGdBbrWajS2C3I2Ekp6awq5ULZyam+OfhWy
         f8AqWCKMJybqXCyotKpbxUcaHGA9VSXesT4+yv4jJnKZxMOTLaPixQSaPnJXozhDovWu
         FaHnrKVCg7MnSJx7uFqvZsTnUYSGJB37ZfgG9HA7//tJQOYIYLXHRSBKsltv9ztj//Pl
         RI6XgMx/o0gVHSaS+jjzg1CJzSUa9guzTIUmu052Ry7THJ1BS0a+e2cJmkPQWNar3FwT
         Dv8iJ5m0106WUTaM2jLfKrJKOJyXLZZydjUii25wFWd9J7qEFwqGoQAklTuOr6FvgJUx
         5ayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+eK+5fkzYxyunCal9Tn719EPwXUpc/8mT0s2MAFKdkg=;
        b=mFly/wvZG8zWjzKCw1IeBZJCtNTcFKREGJCkpqJ21geijknWDO2GopKOwLYRs8WcxW
         s6mCKZ3k8T9re0ufkfo8FefbwdOcZVZ0PA1K53reTI7nzBORDbCIG9F2T2bm0hEP6voT
         ifLchoTusXmIJ8a0gupzV+kQPwhFotXui+FtKWYFxgD783ZykGKB1dlQgXiR7s4iRavC
         Hx8JTce7kDvofGEDtzuRlFPnG7tQg8r1mWckt6fJWiOla6e1nB9RLwTHkRIQG5Q2NMA1
         6DWYg2Ci9irGf2VxUGjSKxegNE4qMOiVeTNFb0A5XoDq6eB4Pq+sk9wNNg7seY5cMNAN
         vLPw==
X-Gm-Message-State: APjAAAV2cqdEYXQxCUQUOI0x1BWGSEmYmSYwMFAuuar9R/vXyVot6jV/
        1bR84uGho62auaa98hLLRbbOMhuCK75b9J2ZcYgumw==
X-Google-Smtp-Source: APXvYqwQhv0NxIDV1LDcBAWZl5QLL4CwIafH4+3vgKwAP3NGx8ZDjESC5K2cau+hQoPGajKr2X/KHYG+ZVmqyb/DgYw=
X-Received: by 2002:aca:cd4d:: with SMTP id d74mr468386oig.157.1571958827931;
 Thu, 24 Oct 2019 16:13:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk>
 <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk> <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk> <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
 <a8fb7a1f-69c7-bf2a-b3dd-7886077d234b@kernel.dk> <572f40fb-201c-99ce-b3f5-05ff9369b895@kernel.dk>
 <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
 <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk> <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
 <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com>
 <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk> <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
 <c3fb07d4-223c-8835-5c22-68367e957a4f@kernel.dk> <CAG48ez0K_wtHA4DSWjz4TjohHkMTGo2pTpDVMZPQWD2gtrqZJw@mail.gmail.com>
 <c252182a-4d09-5e9b-112b-2dad9ef123b5@kernel.dk>
In-Reply-To: <c252182a-4d09-5e9b-112b-2dad9ef123b5@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 25 Oct 2019 01:13:20 +0200
Message-ID: <CAG48ez00zr2P1WCznnXmTvq+FQ4Ji8kDnuNqbeeMvOh_MhXeTg@mail.gmail.com>
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files table
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 12:04 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/24/19 2:31 PM, Jann Horn wrote:
> > On Thu, Oct 24, 2019 at 9:41 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 10/18/19 12:50 PM, Jann Horn wrote:
> >>> On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 10/18/19 12:06 PM, Jann Horn wrote:
> >>>>> But actually, by the way: Is this whole files_struct thing creating a
> >>>>> reference loop? The files_struct has a reference to the uring file,
> >>>>> and the uring file has ACCEPT work that has a reference to the
> >>>>> files_struct. If the task gets killed and the accept work blocks, the
> >>>>> entire files_struct will stay alive, right?
> >>>>
> >>>> Yes, for the lifetime of the request, it does create a loop. So if the
> >>>> application goes away, I think you're right, the files_struct will stay.
> >>>> And so will the io_uring, for that matter, as we depend on the closing
> >>>> of the files to do the final reap.
> >>>>
> >>>> Hmm, not sure how best to handle that, to be honest. We need some way to
> >>>> break the loop, if the request never finishes.
> >>>
> >>> A wacky and dubious approach would be to, instead of taking a
> >>> reference to the files_struct, abuse f_op->flush() to synchronously
> >>> flush out pending requests with references to the files_struct... But
> >>> it's probably a bad idea, given that in f_op->flush(), you can't
> >>> easily tell which files_struct the close is coming from. I suppose you
> >>> could keep a list of (fdtable, fd) pairs through which ACCEPT requests
> >>> have come in and then let f_op->flush() probe whether the file
> >>> pointers are gone from them...
> >>
> >> Got back to this after finishing the io-wq stuff, which we need for the
> >> cancel.
> >>
> >> Here's an updated patch:
> >>
> >> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=1ea847edc58d6a54ca53001ad0c656da57257570
> >>
> >> that seems to work for me (lightly tested), we correctly find and cancel
> >> work that is holding on to the file table.
> >>
> >> The full series sits on top of my for-5.5/io_uring-wq branch, and can be
> >> viewed here:
> >>
> >> http://git.kernel.dk/cgit/linux-block/log/?h=for-5.5/io_uring-test
> >>
> >> Let me know what you think!
> >
> > Ah, I didn't realize that the second argument to f_op->flush is a
> > pointer to the files_struct. That's neat.
> >
> >
> > Security: There is no guarantee that ->flush() will run after the last
> > io_uring_enter() finishes. You can race like this, with threads A and
> > B in one process and C in another one:
> >
> > A: sends uring fd to C via unix domain socket
> > A: starts syscall io_uring_enter(fd, ...)
> > A: calls fdget(fd), takes reference to file
> > B: starts syscall close(fd)
> > B: fd table entry is removed
> > B: f_op->flush is invoked and finds no pending transactions
> > B: syscall close() returns
> > A: continues io_uring_enter(), grabbing current->files
> > A: io_uring_enter() returns
> > A and B: exit
> > worker: use-after-free access to files_struct
> >
> > I think the solution to this would be (unless you're fine with adding
> > some broad global read-write mutex) something like this in
> > __io_queue_sqe(), where "fd" and "f" are the variables from
> > io_uring_enter(), plumbed through the stack somehow:
> >
> > if (req->flags & REQ_F_NEED_FILES) {
> >    rcu_read_lock();
> >    spin_lock_irq(&ctx->inflight_lock);
> >    if (fcheck(fd) == f) {
> >      list_add(&req->inflight_list,
> >        &ctx->inflight_list);
> >      req->work.files = current->files;
> >      ret = 0;
> >    } else {
> >      ret = -EBADF;
> >    }
> >    spin_unlock_irq(&ctx->inflight_lock);
> >    rcu_read_unlock();
> >    if (ret)
> >      goto put_req;
> > }
>
> First of all, thanks for the thorough look at this! We already have f
> available here, it's req->file. And we just made a copy of the sqe, so
> we have sqe->fd available as well. I fixed this up.

sqe->fd is the file descriptor we're doing I/O on, not the file
descriptor of the uring file, right? Same thing for req->file. This
check only detects whether the fd we're doing I/O on was closed, which
is irrelevant.

> > Security + Correctness: If there is more than one io_wqe, it seems to
> > me that io_uring_flush() calls io_wq_cancel_work(), which calls
> > io_wqe_cancel_work(), which may return IO_WQ_CANCEL_OK if the first
> > request it looks at is pending. In that case, io_wq_cancel_work() will
> > immediately return, and io_uring_flush() will also immediately return.
> > It looks like any other requests will continue running?
>
> Ah good point, I missed that. We need to keep looping until we get
> NOTFOUND returned. Fixed as well.
>
> Also added cancellation if the task is going away. Here's the
> incremental patch, I'll resend with the full version.
[...]
> +static int io_uring_flush(struct file *file, void *data)
> +{
> +       struct io_ring_ctx *ctx = file->private_data;
> +
> +       if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> +               io_wq_cancel_all(ctx->io_wq);

Looking at io_wq_cancel_all(), this will just send a signal to the
task without waiting for anything, right? Isn't that unsafe?


> +       else
> +               io_uring_cancel_files(ctx, data);
>         return 0;
>  }
