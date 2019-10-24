Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58CDE3D5E
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 22:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbfJXUbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 16:31:35 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:44685 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727677AbfJXUbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 16:31:35 -0400
Received: by mail-ot1-f65.google.com with SMTP id n48so146803ota.11
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlCz3glcIgz6+cv61sJX8bVfCHYO1bWoZJFgsRvlORQ=;
        b=gT3oUHubQDXmr2T9J0IXhoqzm/5OCQ60wFi51htkj27rPoXnOLSk2VOGtiAJIE9DJg
         kKTd0s2mJBv4ks6yE9/VQmNQnQiaOxKDjK+KJ8/5mU7+zOALBieopGskBc+YRy7OmJsV
         rKVTTzvclUFoPA/8ZhmZ5FHMl/A7/MuCcaOND9LMWbFh6Gx81R8vJQ+bCP7SBZX1s9HP
         iVLE9o2vNAIUuLY02/NYC6SQ6hCgX3WV/WcsHh6PTGso8jGA/NY+hP60KL8kwp4oj/3d
         ubaUJ5neLBCcUDhg5ZN/e/Fgi4JGgYDyJSxDrNyWiexYicPNqoC16XJQWkpYHeTFH0KH
         4mrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlCz3glcIgz6+cv61sJX8bVfCHYO1bWoZJFgsRvlORQ=;
        b=RU1JDc9y9rSVX8i7qr/DpeYsCv47FRQKHVT7QQZWgJQb0GCAqIbL+UUSo/TzuYwkDX
         7K/qfKVatUxMMpzMgsahj/NrBf79ZmKXWN4LRg7SBSl79JAW0HFrxHKemOM71CxsObor
         oSjjVw316EEZIbTiOcqYhR2IX87OdHzY9djh+049kPHU8qUhrwyaH0LSoP2byNgHbsFS
         tOOeEjz6Wv2Zeo0KXngKtw/gMwOfH7xOq6cFSwlFSUZd+SQVImS8VShMIGCWDnKiQ1Bn
         lT69WAaOXXPt6ilORKtRBp12dsng02N29K6WhVNdw8LFhWulbQRupHfS5hRgRGuJ8j6g
         cLJw==
X-Gm-Message-State: APjAAAVXmhK3g5/hDbJy7YAv+loCIo/4ofyDBDjVUP1x71ZrQR0wBiR1
        FGrONVIjmwUo56rKWn77Z5oI2RUR5JkpU4YYDHgdQogv
X-Google-Smtp-Source: APXvYqwSSC8vko9rgvKYJIKJLuhV2zwatVLj4ZmfiHNIzLorIWNuLmfDhLASlBDXJHKLnQ9syJrTPxGZ7qT9nUWosLM=
X-Received: by 2002:a9d:75d0:: with SMTP id c16mr291167otl.32.1571949094082;
 Thu, 24 Oct 2019 13:31:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk> <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk> <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk> <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
 <a8fb7a1f-69c7-bf2a-b3dd-7886077d234b@kernel.dk> <572f40fb-201c-99ce-b3f5-05ff9369b895@kernel.dk>
 <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
 <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk> <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
 <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com>
 <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk> <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
 <c3fb07d4-223c-8835-5c22-68367e957a4f@kernel.dk>
In-Reply-To: <c3fb07d4-223c-8835-5c22-68367e957a4f@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 24 Oct 2019 22:31:07 +0200
Message-ID: <CAG48ez0K_wtHA4DSWjz4TjohHkMTGo2pTpDVMZPQWD2gtrqZJw@mail.gmail.com>
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

On Thu, Oct 24, 2019 at 9:41 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/18/19 12:50 PM, Jann Horn wrote:
> > On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 10/18/19 12:06 PM, Jann Horn wrote:
> >>> But actually, by the way: Is this whole files_struct thing creating a
> >>> reference loop? The files_struct has a reference to the uring file,
> >>> and the uring file has ACCEPT work that has a reference to the
> >>> files_struct. If the task gets killed and the accept work blocks, the
> >>> entire files_struct will stay alive, right?
> >>
> >> Yes, for the lifetime of the request, it does create a loop. So if the
> >> application goes away, I think you're right, the files_struct will stay.
> >> And so will the io_uring, for that matter, as we depend on the closing
> >> of the files to do the final reap.
> >>
> >> Hmm, not sure how best to handle that, to be honest. We need some way to
> >> break the loop, if the request never finishes.
> >
> > A wacky and dubious approach would be to, instead of taking a
> > reference to the files_struct, abuse f_op->flush() to synchronously
> > flush out pending requests with references to the files_struct... But
> > it's probably a bad idea, given that in f_op->flush(), you can't
> > easily tell which files_struct the close is coming from. I suppose you
> > could keep a list of (fdtable, fd) pairs through which ACCEPT requests
> > have come in and then let f_op->flush() probe whether the file
> > pointers are gone from them...
>
> Got back to this after finishing the io-wq stuff, which we need for the
> cancel.
>
> Here's an updated patch:
>
> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=1ea847edc58d6a54ca53001ad0c656da57257570
>
> that seems to work for me (lightly tested), we correctly find and cancel
> work that is holding on to the file table.
>
> The full series sits on top of my for-5.5/io_uring-wq branch, and can be
> viewed here:
>
> http://git.kernel.dk/cgit/linux-block/log/?h=for-5.5/io_uring-test
>
> Let me know what you think!

Ah, I didn't realize that the second argument to f_op->flush is a
pointer to the files_struct. That's neat.


Security: There is no guarantee that ->flush() will run after the last
io_uring_enter() finishes. You can race like this, with threads A and
B in one process and C in another one:

A: sends uring fd to C via unix domain socket
A: starts syscall io_uring_enter(fd, ...)
A: calls fdget(fd), takes reference to file
B: starts syscall close(fd)
B: fd table entry is removed
B: f_op->flush is invoked and finds no pending transactions
B: syscall close() returns
A: continues io_uring_enter(), grabbing current->files
A: io_uring_enter() returns
A and B: exit
worker: use-after-free access to files_struct

I think the solution to this would be (unless you're fine with adding
some broad global read-write mutex) something like this in
__io_queue_sqe(), where "fd" and "f" are the variables from
io_uring_enter(), plumbed through the stack somehow:

if (req->flags & REQ_F_NEED_FILES) {
  rcu_read_lock();
  spin_lock_irq(&ctx->inflight_lock);
  if (fcheck(fd) == f) {
    list_add(&req->inflight_list,
      &ctx->inflight_list);
    req->work.files = current->files;
    ret = 0;
  } else {
    ret = -EBADF;
  }
  spin_unlock_irq(&ctx->inflight_lock);
  rcu_read_unlock();
  if (ret)
    goto put_req;
}


Minor note: If a process uses dup() to duplicate the uring fd, then
closes the duplicated fd, that will cause work cancellations - but I
guess that's fine?


Style nit: I find it a bit confusing to name both the list head and
the list member heads "inflight_list". Maybe name them "inflight_list"
and "inflight_entry", or something like that?


Correctness: Why is the wait in io_uring_flush() TASK_INTERRUPTIBLE?
Shouldn't it be TASK_UNINTERRUPTIBLE? If someone sends a signal to the
task while it's at that schedule(), it's just going to loop back
around and retry what it was doing already, right?


Security + Correctness: If there is more than one io_wqe, it seems to
me that io_uring_flush() calls io_wq_cancel_work(), which calls
io_wqe_cancel_work(), which may return IO_WQ_CANCEL_OK if the first
request it looks at is pending. In that case, io_wq_cancel_work() will
immediately return, and io_uring_flush() will also immediately return.
It looks like any other requests will continue running?
