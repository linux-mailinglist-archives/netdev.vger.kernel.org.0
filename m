Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B229AE40C0
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 02:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388412AbfJYAwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 20:52:41 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45333 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388288AbfJYAwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 20:52:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id x28so359309pfi.12
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 17:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dHqCHkeg4vPKuIQHaTzMX90CIa195bnsa9ytECzwjDg=;
        b=tApizjjy/xNks70HNFZoHAEe+f2wuEYTH40LWUd0+6XLIaPDyXZNP1Ksx4PIP9rzEt
         BFfvOwsuZ0Yn5ZwZhNQxfIOUEVupucSSwS581DM7WBB3RixcQZO/GbQpLjtAnl7o+Out
         t+xkVMyO6ockj1/3DTvEukaISwT1xR8B1320oWsOAQPAOh/O4q6luHmHcdGAaBXa0dBO
         4ne7PdEBgpJO6LdofGRmZUkYLA/0fljMxRlC3RSnoKYWKzoeqtd6BO3BLaQggA+5QMvs
         y+XqfG5ynRfK7cSMkWDkJJZ3PBdDm0DUbsDWtTAuyn8L2gPvQI8gH8H45hzLc1DRXTUA
         uOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dHqCHkeg4vPKuIQHaTzMX90CIa195bnsa9ytECzwjDg=;
        b=Fzc2RHI3P4J9ZfTti9/ka6gCi1+BGp3YSuYHE7Be4ZPPdXI0aXC/dOtnLjWFqUty7X
         pC5Nmv+kp2pDr64UkegtXJ0Ij3Bf6up5fC+xC67WQtlJEMzhLv9hEIZUFStXjo8nmqnj
         9ej9PgZwQxVT6C9FdptiETUXxo+/Tl9BRu9SpwzWCMCndoCn43GTyAGCfE1a4gBJ9VI9
         z3BvJayns/NiuGAO40Y/mXHk7B88OyC9L3vC6vS1Yjg0pgwQalF/0A3pqIT3U/6fF0sw
         +mgT8zh6HLkvrrd5d2XcFAkACs9d2/t2zI/ixBIMjvl98I9bFNYZwY7QNN6njkLEFeHx
         hN/w==
X-Gm-Message-State: APjAAAXoSmlkBTiRSoGD4bA2txKSpqNZ45kz47xfEOEcAro7mB1Sv1u8
        E/cISkQWZX19qzt7URszF+FBx/4gceb41w==
X-Google-Smtp-Source: APXvYqzZFayIohcNMa0UlsM1Tv4o7lXiEPzt8vsm/OsmSxz14th9NDxRsG8gD5QOcQ3WLQ138yMNTA==
X-Received: by 2002:a65:434c:: with SMTP id k12mr1012814pgq.141.1571964758832;
        Thu, 24 Oct 2019 17:52:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id v68sm170970pfv.47.2019.10.24.17.52.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 17:52:37 -0700 (PDT)
Subject: Re: [PATCH 1/3] io_uring: add support for async work inheriting files
 table
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     linux-block@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <20191017212858.13230-1-axboe@kernel.dk>
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
 <947c74b9-e828-e190-19fc-449c72a20798@kernel.dk>
Message-ID: <4a920143-d899-8811-a767-d114dba1e4e3@kernel.dk>
Date:   Thu, 24 Oct 2019 18:52:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <947c74b9-e828-e190-19fc-449c72a20798@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/24/19 6:35 PM, Jens Axboe wrote:
> On 10/24/19 5:13 PM, Jann Horn wrote:
>> On Fri, Oct 25, 2019 at 12:04 AM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 10/24/19 2:31 PM, Jann Horn wrote:
>>>> On Thu, Oct 24, 2019 at 9:41 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 10/18/19 12:50 PM, Jann Horn wrote:
>>>>>> On Fri, Oct 18, 2019 at 8:16 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>> On 10/18/19 12:06 PM, Jann Horn wrote:
>>>>>>>> But actually, by the way: Is this whole files_struct thing creating a
>>>>>>>> reference loop? The files_struct has a reference to the uring file,
>>>>>>>> and the uring file has ACCEPT work that has a reference to the
>>>>>>>> files_struct. If the task gets killed and the accept work blocks, the
>>>>>>>> entire files_struct will stay alive, right?
>>>>>>>
>>>>>>> Yes, for the lifetime of the request, it does create a loop. So if the
>>>>>>> application goes away, I think you're right, the files_struct will stay.
>>>>>>> And so will the io_uring, for that matter, as we depend on the closing
>>>>>>> of the files to do the final reap.
>>>>>>>
>>>>>>> Hmm, not sure how best to handle that, to be honest. We need some way to
>>>>>>> break the loop, if the request never finishes.
>>>>>>
>>>>>> A wacky and dubious approach would be to, instead of taking a
>>>>>> reference to the files_struct, abuse f_op->flush() to synchronously
>>>>>> flush out pending requests with references to the files_struct... But
>>>>>> it's probably a bad idea, given that in f_op->flush(), you can't
>>>>>> easily tell which files_struct the close is coming from. I suppose you
>>>>>> could keep a list of (fdtable, fd) pairs through which ACCEPT requests
>>>>>> have come in and then let f_op->flush() probe whether the file
>>>>>> pointers are gone from them...
>>>>>
>>>>> Got back to this after finishing the io-wq stuff, which we need for the
>>>>> cancel.
>>>>>
>>>>> Here's an updated patch:
>>>>>
>>>>> http://git.kernel.dk/cgit/linux-block/commit/?h=for-5.5/io_uring-test&id=1ea847edc58d6a54ca53001ad0c656da57257570
>>>>>
>>>>> that seems to work for me (lightly tested), we correctly find and cancel
>>>>> work that is holding on to the file table.
>>>>>
>>>>> The full series sits on top of my for-5.5/io_uring-wq branch, and can be
>>>>> viewed here:
>>>>>
>>>>> http://git.kernel.dk/cgit/linux-block/log/?h=for-5.5/io_uring-test
>>>>>
>>>>> Let me know what you think!
>>>>
>>>> Ah, I didn't realize that the second argument to f_op->flush is a
>>>> pointer to the files_struct. That's neat.
>>>>
>>>>
>>>> Security: There is no guarantee that ->flush() will run after the last
>>>> io_uring_enter() finishes. You can race like this, with threads A and
>>>> B in one process and C in another one:
>>>>
>>>> A: sends uring fd to C via unix domain socket
>>>> A: starts syscall io_uring_enter(fd, ...)
>>>> A: calls fdget(fd), takes reference to file
>>>> B: starts syscall close(fd)
>>>> B: fd table entry is removed
>>>> B: f_op->flush is invoked and finds no pending transactions
>>>> B: syscall close() returns
>>>> A: continues io_uring_enter(), grabbing current->files
>>>> A: io_uring_enter() returns
>>>> A and B: exit
>>>> worker: use-after-free access to files_struct
>>>>
>>>> I think the solution to this would be (unless you're fine with adding
>>>> some broad global read-write mutex) something like this in
>>>> __io_queue_sqe(), where "fd" and "f" are the variables from
>>>> io_uring_enter(), plumbed through the stack somehow:
>>>>
>>>> if (req->flags & REQ_F_NEED_FILES) {
>>>>      rcu_read_lock();
>>>>      spin_lock_irq(&ctx->inflight_lock);
>>>>      if (fcheck(fd) == f) {
>>>>        list_add(&req->inflight_list,
>>>>          &ctx->inflight_list);
>>>>        req->work.files = current->files;
>>>>        ret = 0;
>>>>      } else {
>>>>        ret = -EBADF;
>>>>      }
>>>>      spin_unlock_irq(&ctx->inflight_lock);
>>>>      rcu_read_unlock();
>>>>      if (ret)
>>>>        goto put_req;
>>>> }
>>>
>>> First of all, thanks for the thorough look at this! We already have f
>>> available here, it's req->file. And we just made a copy of the sqe, so
>>> we have sqe->fd available as well. I fixed this up.
>>
>> sqe->fd is the file descriptor we're doing I/O on, not the file
>> descriptor of the uring file, right? Same thing for req->file. This
>> check only detects whether the fd we're doing I/O on was closed, which
>> is irrelevant.
> 
> Duh yes, I'm an idiot. Easily fixable, I'll update this for the ring fd.

Incremental:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ec9dadfa90d2..4d94886a3d13 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -262,11 +262,13 @@ struct io_ring_ctx {
 
 struct sqe_submit {
 	const struct io_uring_sqe	*sqe;
+	struct file			*ring_file;
 	unsigned short			index;
 	bool				has_user : 1;
 	bool				in_async : 1;
 	bool				needs_fixed_file : 1;
 	u32				sequence;
+	int				ring_fd;
 };
 
 /*
@@ -2329,14 +2331,13 @@ static int io_req_set_file(struct io_ring_ctx *ctx, const struct sqe_submit *s,
 	return 0;
 }
 
-static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			 struct io_uring_sqe *sqe)
+static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req)
 {
 	int ret = -EBADF;
 
 	rcu_read_lock();
 	spin_lock_irq(&ctx->inflight_lock);
-	if (fcheck(sqe->fd) == req->file) {
+	if (fcheck(req->submit.ring_fd) == req->submit.ring_file) {
 		list_add(&req->inflight_entry, &ctx->inflight_list);
 		req->work.files = current->files;
 		ret = 0;
@@ -2367,7 +2368,7 @@ static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			s->sqe = sqe_copy;
 			memcpy(&req->submit, s, sizeof(*s));
 			if (req->flags & REQ_F_NEED_FILES) {
-				ret = io_grab_files(ctx, req, sqe_copy);
+				ret = io_grab_files(ctx, req);
 				if (ret) {
 					kfree(sqe_copy);
 					goto err;
@@ -2585,6 +2586,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct sqe_submit *s)
 
 	head = READ_ONCE(sq_array[head & ctx->sq_mask]);
 	if (head < ctx->sq_entries) {
+		s->ring_file = NULL;
 		s->index = head;
 		s->sqe = &ctx->sq_sqes[head];
 		s->sequence = ctx->cached_sq_head;
@@ -2782,7 +2784,8 @@ static int io_sq_thread(void *data)
 	return 0;
 }
 
-static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
+static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit,
+			  struct file *ring_file, int ring_fd)
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
@@ -2824,9 +2827,11 @@ static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_submit)
 		}
 
 out:
+		s.ring_file = ring_file;
 		s.has_user = true;
 		s.in_async = false;
 		s.needs_fixed_file = false;
+		s.ring_fd = ring_fd;
 		submit++;
 		trace_io_uring_submit_sqe(ctx, true, false);
 		io_submit_sqe(ctx, &s, statep, &link);
@@ -3828,10 +3833,9 @@ static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
+	io_uring_cancel_files(ctx, data);
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
 		io_wq_cancel_all(ctx->io_wq);
-	else
-		io_uring_cancel_files(ctx, data);
 	return 0;
 }
 
@@ -3903,7 +3907,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		to_submit = min(to_submit, ctx->sq_entries);
 
 		mutex_lock(&ctx->uring_lock);
-		submitted = io_ring_submit(ctx, to_submit);
+		submitted = io_ring_submit(ctx, to_submit, f.file, fd);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	if (flags & IORING_ENTER_GETEVENTS) {

-- 
Jens Axboe

