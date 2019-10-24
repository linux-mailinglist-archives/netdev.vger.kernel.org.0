Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFA9E3EC1
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbfJXWEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 18:04:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40015 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfJXWEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 18:04:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so144162pfb.7
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mOAfuL8qzK8bfUHR6R8IbAbNq+V3yukE6A1ms8+prT4=;
        b=EMBzm9fXVaF4JpM+VVKPuZDbQEbFp8aR9QSG/ycSVDWjoTdW6bOfrMlvpxblG4rJma
         kyH3zs2POb0XivMAht2sMQ8hOU4Cg31voMMBnbjiCckAxiLZk10ktH5vJqu0VEyvzm7X
         r9OHY93XSaZbrFTA90r84PIx+OsRqNT71qTrAbrYatZz7Zmv/dCrVLRDCbEiX2W1W5x0
         TKQmsLuRzvQ7MNycNlAUdu3o1rRv2KUKNF87xq9YHAySHDluWYX4HtvkivonY5x04Idv
         Gn7c2QW/vbdLnTjwOiceCF/ItwoB9QJnhHOhYVQHRlkO9PBNXpr1Y/vFcJUCKWoQuQ9t
         1pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mOAfuL8qzK8bfUHR6R8IbAbNq+V3yukE6A1ms8+prT4=;
        b=S+4E3IodQOFpxgkaoawJ9az0PJGhkYkl+bBGLo5xDMccOIl5FfTUwDNJIfudvxlmTz
         9wnwspY8jJSEaZcvVXmJxdRitcIqj74Me9CSKXc85nSVPUOjwflOoipkKrWsPjfKkqpy
         yy9r18TcaEw6I8d6J9mfbHmMBG450t0RGrecopau0vScZwyPYSJ2V+IKvZiKTZ0m5llI
         gPaQq57pk+KuSI918PUOdLe8o7mhMB0r0un2N7ANbk0eZoF7FxASdyReepjnsXseRUu+
         vKlomR4QzGKcX/UFpTfD9U8smMD2Ofhxn36wMY2P5HrNCqJXtLZ/3GDCuBQ8ShG8sFLd
         qBHg==
X-Gm-Message-State: APjAAAV8Ua/M7cv7/P3hh5eWy2D5dHJOVsYIrBMPHegcldjHYchO3HJQ
        ul5TYBZI2n78SUQFvAXqb7lUuTSYvtplnw==
X-Google-Smtp-Source: APXvYqwv8JiG6f0VdK4wXcxwfpAIMQjsE7CQ5BXso8Cv5xcHiaTIXcvdyJxLGFXR4l0lzvAw2KZWkg==
X-Received: by 2002:a63:aa45:: with SMTP id x5mr306354pgo.194.1571954669757;
        Thu, 24 Oct 2019 15:04:29 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id h186sm34384095pfb.63.2019.10.24.15.04.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 15:04:28 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
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
 <0a3de9b2-3d3a-07b5-0e1c-515f610fbf75@kernel.dk>
 <CAG48ez1akvnVpK3dMH4H=C2CsNGDZkDaxZEF2stGAPCnUcaa+g@mail.gmail.com>
 <c3fb07d4-223c-8835-5c22-68367e957a4f@kernel.dk>
 <CAG48ez0K_wtHA4DSWjz4TjohHkMTGo2pTpDVMZPQWD2gtrqZJw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c252182a-4d09-5e9b-112b-2dad9ef123b5@kernel.dk>
Date:   Thu, 24 Oct 2019 16:04:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez0K_wtHA4DSWjz4TjohHkMTGo2pTpDVMZPQWD2gtrqZJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 2:31 PM, Jann Horn wrote:
> On Thu, Oct 24, 2019 at 9:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/18/19 12:50 PM, Jann Horn wrote:
>>> On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 10/18/19 12:06 PM, Jann Horn wrote:
>>>>> But actually, by the way: Is this whole files_struct thing creating a
>>>>> reference loop? The files_struct has a reference to the uring file,
>>>>> and the uring file has ACCEPT work that has a reference to the
>>>>> files_struct. If the task gets killed and the accept work blocks, the
>>>>> entire files_struct will stay alive, right?
>>>>
>>>> Yes, for the lifetime of the request, it does create a loop. So if the
>>>> application goes away, I think you're right, the files_struct will stay.
>>>> And so will the io_uring, for that matter, as we depend on the closing
>>>> of the files to do the final reap.
>>>>
>>>> Hmm, not sure how best to handle that, to be honest. We need some way to
>>>> break the loop, if the request never finishes.
>>>
>>> A wacky and dubious approach would be to, instead of taking a
>>> reference to the files_struct, abuse f_op->flush() to synchronously
>>> flush out pending requests with references to the files_struct... But
>>> it's probably a bad idea, given that in f_op->flush(), you can't
>>> easily tell which files_struct the close is coming from. I suppose you
>>> could keep a list of (fdtable, fd) pairs through which ACCEPT requests
>>> have come in and then let f_op->flush() probe whether the file
>>> pointers are gone from them...
>>
>> Got back to this after finishing the io-wq stuff, which we need for the
>> cancel.
>>
>> Here's an updated patch:
>>
>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=1ea847edc58d6a54ca53001ad0c656da57257570
>>
>> that seems to work for me (lightly tested), we correctly find and cancel
>> work that is holding on to the file table.
>>
>> The full series sits on top of my for-5.5/io_uring-wq branch, and can be
>> viewed here:
>>
>> http://git.kernel.dk/cgit/linux-block/log/?h=for-5.5/io_uring-test
>>
>> Let me know what you think!
> 
> Ah, I didn't realize that the second argument to f_op->flush is a
> pointer to the files_struct. That's neat.
> 
> 
> Security: There is no guarantee that ->flush() will run after the last
> io_uring_enter() finishes. You can race like this, with threads A and
> B in one process and C in another one:
> 
> A: sends uring fd to C via unix domain socket
> A: starts syscall io_uring_enter(fd, ...)
> A: calls fdget(fd), takes reference to file
> B: starts syscall close(fd)
> B: fd table entry is removed
> B: f_op->flush is invoked and finds no pending transactions
> B: syscall close() returns
> A: continues io_uring_enter(), grabbing current->files
> A: io_uring_enter() returns
> A and B: exit
> worker: use-after-free access to files_struct
> 
> I think the solution to this would be (unless you're fine with adding
> some broad global read-write mutex) something like this in
> __io_queue_sqe(), where "fd" and "f" are the variables from
> io_uring_enter(), plumbed through the stack somehow:
> 
> if (req->flags & REQ_F_NEED_FILES) {
>    rcu_read_lock();
>    spin_lock_irq(&ctx->inflight_lock);
>    if (fcheck(fd) == f) {
>      list_add(&req->inflight_list,
>        &ctx->inflight_list);
>      req->work.files = current->files;
>      ret = 0;
>    } else {
>      ret = -EBADF;
>    }
>    spin_unlock_irq(&ctx->inflight_lock);
>    rcu_read_unlock();
>    if (ret)
>      goto put_req;
> }

First of all, thanks for the thorough look at this! We already have f
available here, it's req->file. And we just made a copy of the sqe, so
we have sqe->fd available as well. I fixed this up.

> Minor note: If a process uses dup() to duplicate the uring fd, then
> closes the duplicated fd, that will cause work cancellations - but I
> guess that's fine?

I don't think that's a concern.

> Style nit: I find it a bit confusing to name both the list head and
> the list member heads "inflight_list". Maybe name them "inflight_list"
> and "inflight_entry", or something like that?

Fixed

> Correctness: Why is the wait in io_uring_flush() TASK_INTERRUPTIBLE?
> Shouldn't it be TASK_UNINTERRUPTIBLE? If someone sends a signal to the
> task while it's at that schedule(), it's just going to loop back
> around and retry what it was doing already, right?

Fixed

> Security + Correctness: If there is more than one io_wqe, it seems to
> me that io_uring_flush() calls io_wq_cancel_work(), which calls
> io_wqe_cancel_work(), which may return IO_WQ_CANCEL_OK if the first
> request it looks at is pending. In that case, io_wq_cancel_work() will
> immediately return, and io_uring_flush() will also immediately return.
> It looks like any other requests will continue running?

Ah good point, I missed that. We need to keep looping until we get
NOTFOUND returned. Fixed as well.

Also added cancellation if the task is going away. Here's the
incremental patch, I'll resend with the full version.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 43ae0e04fd09..ec9dadfa90d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,7 +326,7 @@ struct io_kiocb {
 	u32			result;
 	u32			sequence;
 
-	struct list_head	inflight_list;
+	struct list_head	inflight_entry;
 
 	struct io_wq_work	work;
 };
@@ -688,7 +688,7 @@ static void __io_free_req(struct io_kiocb *req)
 		unsigned long flags;
 
 		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_list);
+		list_del(&req->inflight_entry);
 		if (wq_has_sleeper(&ctx->inflight_wait))
 			wake_up(&ctx->inflight_wait);
 		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
@@ -2329,6 +2329,24 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	return 0;
 }
 
+static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req,
+			 struct io_uring_sqe *sqe)
+{
+	int ret = -EBADF;
+
+	rcu_read_lock();
+	spin_lock_irq(&ctx->inflight_lock);
+	if (fcheck(sqe->fd) == req->file) {
+		list_add(&req->inflight_entry, &ctx->inflight_list);
+		req->work.files = current->files;
+		ret = 0;
+	}
+	spin_unlock_irq(&ctx->inflight_lock);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			struct sqe_submit *s)
 {
@@ -2349,23 +2367,24 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
 			if (req->flags & REQ_F_NEED_FILES) {
-				spin_lock_irq(&ctx->inflight_lock);
-				list_add(&req->inflight_list,
-						&ctx->inflight_list);
-				req->work.files = current->files;
-				spin_unlock_irq(&ctx->inflight_lock);
+				ret = io_grab_files(ctx, req, sqe_copy);
+				if (ret) {
+					kfree(sqe_copy);
+					goto err;
+				}
 			}
-			io_queue_async_work(ctx, req);
 
 			/*
 			 * Queued up for async execution, worker will release
 			 * submit reference when the iocb is actually submitted.
 			 */
+			io_queue_async_work(ctx, req);
 			return 0;
 		}
 	}
 
 	/* drop submission reference */
+err:
 	io_put_req(req, NULL);
 
 	/* and drop final reference, if we failed */
@@ -3768,38 +3787,51 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int io_uring_flush(struct file *file, void *data)
+static void io_uring_cancel_files(struct io_ring_ctx *ctx,
+				  struct files_struct *files)
 {
-	struct io_ring_ctx *ctx = file->private_data;
-	enum io_wq_cancel ret;
 	struct io_kiocb *req;
 	DEFINE_WAIT(wait);
 
-restart:
-	ret = IO_WQ_CANCEL_NOTFOUND;
+	while (!list_empty_careful(&ctx->inflight_list)) {
+		enum io_wq_cancel ret = IO_WQ_CANCEL_NOTFOUND;
 
-	spin_lock_irq(&ctx->inflight_lock);
-	list_for_each_entry(req, &ctx->inflight_list, inflight_list) {
-		if (req->work.files == data) {
-			ret = io_wq_cancel_work(ctx->io_wq, &req->work);
-			break;
+		spin_lock_irq(&ctx->inflight_lock);
+		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
+			if (req->work.files == files) {
+				ret = io_wq_cancel_work(ctx->io_wq, &req->work);
+				break;
+			}
 		}
-	}
-	if (ret == IO_WQ_CANCEL_RUNNING)
-		prepare_to_wait(&ctx->inflight_wait, &wait, TASK_INTERRUPTIBLE);
+		if (ret == IO_WQ_CANCEL_RUNNING)
+			prepare_to_wait(&ctx->inflight_wait, &wait,
+					TASK_UNINTERRUPTIBLE);
 
-	spin_unlock_irq(&ctx->inflight_lock);
+		spin_unlock_irq(&ctx->inflight_lock);
 
-	/*
-	 * If it was found running, wait for one inflight request to finish.
-	 * Retry loop after that, as it may not have been the one we were
-	 * looking for.
-	 */
-	if (ret == IO_WQ_CANCEL_RUNNING) {
+		/*
+		 * We need to keep going until we get NOTFOUND. We only cancel
+		 * one work at the time.
+		 *
+		 * If we get CANCEL_RUNNING, then wait for a work to complete
+		 * before continuing.
+		 */
+		if (ret == IO_WQ_CANCEL_OK)
+			continue;
+		else if (ret != IO_WQ_CANCEL_RUNNING)
+			break;
 		schedule();
-		goto restart;
-	}
+	};
+}
 
+static int io_uring_flush(struct file *file, void *data)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+		io_wq_cancel_all(ctx->io_wq);
+	else
+		io_uring_cancel_files(ctx, data);
 	return 0;
 }
 

-- 
Jens Axboe

