Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE06DCD49
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505684AbfJRSGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:06:53 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41683 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfJRSGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 14:06:53 -0400
Received: by mail-oi1-f195.google.com with SMTP id g81so5954360oib.8
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 11:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/e/Moa0ihvefz9yqg1t4ezlgVZNAXSin7nNZXCiNtE=;
        b=l6O+OilV7pYfr0d3OLsLunxuHvoVfIh4g28Q7bMQ3CIfn71OG2kjCu/B6xUe2eXJIm
         cWq/iVwwNDETgBwt81Z3JIt56pXupCy3t4HWAUFG9M40/ukJ7km001AeeDq0q9SDQeem
         jsadBSr48T6h8+5x9DZ00BrEyjDlPWHmUxdFm4dqjcTzxnpRSYpI99rgLZ+ciiKr+zFk
         BMwPtRz9ErwDygSDxV/+AXFqDTBCUfB7PBRWgQ1jcG4IzXb+i7qG7uCHXdc0sdjcVB78
         /PDWuGJzMdVCurTF9PuvqwWybOZb2ZPK7fVJci8FEpyBaaOmsrx6EB5xF7c9LroXEoGt
         38yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/e/Moa0ihvefz9yqg1t4ezlgVZNAXSin7nNZXCiNtE=;
        b=AK8AeOBSFzZ4MB3tbvQr08jbqg6s7ogbhbP7UOJ7PCoMk2xYFu8v3RdFwJO6+jGwJQ
         BNPoMRb5NPyaZ6oFvJqfLZUUSu8uK0dEpI2yYLCx9ifecQaIWhY91nEu8aUvUgfHtxQ8
         +c1gCYens5tTjXFCyuoMewTaKB9kgpLZEgAmokE5X2JqAK/Kis7hIJjaUSqTK+4+2vTm
         PyNMO+YHrKfrMV5to++GiIbMa9dxzJ8z3HqWBIOfh9GNris3IqBXBKtzKnXE/PejT44a
         J/0ACdpXG+rVy62RaXZ9h52aI9uIera4nKlAEbxZkB+vZXl9GzJtF7cYCMPvUyIiNWtF
         sbig==
X-Gm-Message-State: APjAAAXh/QDY1k1agFo5ZSDKkGFpQT9+REzlZ3WgNl3MxAO5udw9mS9N
        x51tNXeSZvDLRm+f/YqJDBstEmpV1/IaZMxQBO7d5A==
X-Google-Smtp-Source: APXvYqz/NarsZ1RFuKrAUxdKpaKRPsMJeKFch6Pfq9no/XPUXq2I29eblMPlKWnPxn4jB/4zZiOk3ZFUxjvkNJ//drE=
X-Received: by 2002:aca:da41:: with SMTP id r62mr8722272oig.47.1571422011755;
 Fri, 18 Oct 2019 11:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191017212858.13230-1-axboe@kernel.dk> <20191017212858.13230-2-axboe@kernel.dk>
 <CAG48ez0G2y0JS9=S2KmePO3xq-5DuzgovrLFiX4TJL-G897LCA@mail.gmail.com>
 <0fb9d9a0-6251-c4bd-71b0-6e34c6a1aab8@kernel.dk> <CAG48ez181=JoYudXee0KbU0vDZ=EbxmgB7q0mmjaA0gyp6MFBQ@mail.gmail.com>
 <a54329d5-a128-3ccd-7a12-f6cadaa20dbf@kernel.dk> <CAG48ez1SDQNHjgFku4ft4qw9hdv1g6-sf7-dxuU_tJSx+ofV-w@mail.gmail.com>
 <dbcf874d-8484-9c27-157a-c2752181acb5@kernel.dk> <CAG48ez3KwaQ3DVH1VoWxFWTG2ZfCQ6M0oyv5vZqkLgY0QDEdiw@mail.gmail.com>
 <a8fb7a1f-69c7-bf2a-b3dd-7886077d234b@kernel.dk> <572f40fb-201c-99ce-b3f5-05ff9369b895@kernel.dk>
 <CAG48ez12pteHyZasU8Smup-0Mn3BWNMCVjybd1jvXsPrJ7OmYg@mail.gmail.com>
 <20b44cc0-87b1-7bf8-d20e-f6131da9d130@kernel.dk> <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
In-Reply-To: <2d208fc8-7c24-bca5-3d4a-796a5a8267eb@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 18 Oct 2019 20:06:25 +0200
Message-ID: <CAG48ez2ZQBVEe8yYRwWX2=TMYWsJ=tK44NM+wqiLW2AmfYEcHw@mail.gmail.com>
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

On Fri, Oct 18, 2019 at 7:05 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/18/19 10:36 AM, Jens Axboe wrote:
> >> Ignoring the locking elision, basically the logic is now this:
> >>
> >> static void io_sq_wq_submit_work(struct work_struct *work)
> >> {
> >>           struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> >>           struct files_struct *cur_files = NULL, *old_files;
> >>           [...]
> >>           old_files = current->files;
> >>           [...]
> >>           do {
> >>                   struct sqe_submit *s = &req->submit;
> >>                   [...]
> >>                   if (cur_files)
> >>                           /* drop cur_files reference; borrow lifetime must
> >>                            * end before here */
> >>                           put_files_struct(cur_files);
> >>                   /* move reference ownership to cur_files */
> >>                   cur_files = s->files;
> >>                   if (cur_files) {
> >>                           task_lock(current);
> >>                           /* current->files borrows reference from cur_files;
> >>                            * existing borrow from previous loop ends here */
> >>                           current->files = cur_files;
> >>                           task_unlock(current);
> >>                   }
> >>
> >>                   [call __io_submit_sqe()]
> >>                   [...]
> >>           } while (req);
> >>           [...]
> >>           /* existing borrow ends here */
> >>           task_lock(current);
> >>           current->files = old_files;
> >>           task_unlock(current);
> >>           if (cur_files)
> >>                   /* drop cur_files reference; borrow lifetime must
> >>                    * end before here */
> >>                   put_files_struct(cur_files);
> >> }
> >>
> >> If you run two iterations of this loop, with a first element that has
> >> a ->files pointer and a second element that doesn't, then in the
> >> second run through the loop, the reference to the files_struct will be
> >> dropped while current->files still points to it; current->files is
> >> only reset after the loop has ended. If someone accesses
> >> current->files through procfs directly after that, AFAICS you'd get a
> >> use-after-free.
> >
> > Amazing how this is still broken. You are right, and it's especially
> > annoying since that's exactly the case I originally talked about (not
> > flipping current->files if we don't have to). I just did it wrong, so
> > we'll leave a dangling pointer in ->files.
> >
> > The by far most common case is if one sqe has a files it needs to
> > attach, then others that also have files will be the same set. So I want
> > to optimize for the case where we only flip current->files once when we
> > see the files, and once when we're done with the loop.
> >
> > Let me see if I can get this right...
>
> I _think_ the simplest way to do it is simply to have both cur_files and
> current->files hold a reference to the file table. That won't really add
> any extra cost as the double increments / decrements are following each
> other. Something like this incremental, totally untested.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2fed0badad38..b3cf3f3d7911 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2293,9 +2293,14 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>                         put_files_struct(cur_files);
>                 cur_files = s->files;
>                 if (cur_files && cur_files != current->files) {
> +                       struct files_struct *old;
> +
> +                       atomic_inc(&cur_files->count);
>                         task_lock(current);
> +                       old = current->files;
>                         current->files = cur_files;
>                         task_unlock(current);
> +                       put_files_struct(old);
>                 }
>
>                 if (!ret) {
> @@ -2390,9 +2395,13 @@ static void io_sq_wq_submit_work(struct work_struct *work)
>                 mmput(cur_mm);
>         }
>         if (old_files != current->files) {
> +               struct files_struct *old;
> +
>                 task_lock(current);
> +               old = current->files;
>                 current->files = old_files;
>                 task_unlock(current);
> +               put_files_struct(old);
>         }
>         if (cur_files)
>                 put_files_struct(cur_files);

The only part I still feel a bit twitchy about is this part at the end:

        if (old_files != current->files) {
                struct files_struct *old;

                task_lock(current);
                old = current->files;
                current->files = old_files;
                task_unlock(current);
                put_files_struct(old);
        }

If it was possible for the initial ->files to be the same as the
->files of a submission, and we got two submissions with first a
different files_struct and then our old one, then this branch would
not be executed even though it should, which would leave the refcount
of the files_struct one too high. But that probably can't happen?
Since kernel workers should be running with &init_files (I think?) and
that thing is never used for userspace tasks. But still, I'd feel
better if you could change it like this:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f9f5c70564f0..7673035d6bfe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2265,6 +2265,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
 {
        struct io_kiocb *req = container_of(work, struct io_kiocb, work);
        struct files_struct *cur_files = NULL, *old_files;
+       bool restore_current_files = false;
        struct io_ring_ctx *ctx = req->ctx;
        struct mm_struct *cur_mm = NULL;
        struct async_list *async_list;
@@ -2313,6 +2314,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
                        current->files = cur_files;
                        task_unlock(current);
                        put_files_struct(old);
+                       restore_current_files = true;
                }

                if (!ret) {
@@ -2406,7 +2408,7 @@ static void io_sq_wq_submit_work(struct work_struct *work)
                unuse_mm(cur_mm);
                mmput(cur_mm);
        }
-       if (old_files != current->files) {
+       if (restore_current_files) {
                struct files_struct *old;

                task_lock(current);


But actually, by the way: Is this whole files_struct thing creating a
reference loop? The files_struct has a reference to the uring file,
and the uring file has ACCEPT work that has a reference to the
files_struct. If the task gets killed and the accept work blocks, the
entire files_struct will stay alive, right?
