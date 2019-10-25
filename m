Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0F8E55DF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 23:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfJYVbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 17:31:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37223 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfJYVbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 17:31:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id q130so3433491wme.2;
        Fri, 25 Oct 2019 14:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=3JP6WTfBPNSaCsavgQQu2jTWhA2JDfWOlSDUAm98vek=;
        b=Pr+0gWPYCLKKHdxUDEnp3XryRIb2k0NDtCuzarY1vBPb2gEnEooU39vCuMLZ4S+gJm
         IH69+ebqem+Fbyu97n+AcPdWmHBSOXzQU01qXA4I4lBgYkwnSIToLQ5TZK0baL6Sxjvl
         vcuxERQ0mwazAuxSu/048Vfp6qqtzcv/IZ7Zgax66yiq0O4k43SxqLV6i4afQRCTQk6F
         xyr2BvyK5nDqV3K4NvseMpuOcKgUJ/ihNhDERlkJJB6kz+3G1/xEogxI9GQGSdReQ4sZ
         aKdNDZwM14nZuTf6gjc6MB/J5LhljfIcO9FhusCnf8g4xiwDMVsRQ9DKiRSHazXfZNu9
         7z8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=3JP6WTfBPNSaCsavgQQu2jTWhA2JDfWOlSDUAm98vek=;
        b=bzI8MrqvOBzmyGzVWbtdgpmlgqi6Qgmv9crX3LRRv9TnEtfSKJINCMjpUlkXwaQum/
         WBBNGmKdfNAyvL4xqAwG1wWfaQVwsDG64vlNb3lfPlwFeEiTCSg/AzQonIH53gklky2P
         Cfr4CW8tv7l43GEM3mTwOm8wVSx7SdXClxhOPQ2Fj/cDR1Bw3QHfhLYMlbBJlFrg/7sY
         oBuSnAEaTyuGFmdkcB9/pjwuJNTJeTXARjTWbfE1P1xEpb4ody5cOmtpIrJUO1a9oTR5
         4YX8LkGyrDFDCZC0dSDfJ994cNSreCjqRf+zG/HAru9t9FJ3vrTqQpNnJCpxoMrIbppz
         Y/pA==
X-Gm-Message-State: APjAAAUc5AA+TPstoyx4LHONV2tt0IpGw9db/Idw5eatJssViQ7o+4Ki
        jePeVUOC6zbBgRQ1I0e69LU=
X-Google-Smtp-Source: APXvYqxP9g//9yrmonMAffTUIUC0Wzj+lM41MpDv+TJNvH4YgQNSRqkOzcD+O8UdDlGmz87xHJap2Q==
X-Received: by 2002:a7b:cc01:: with SMTP id f1mr5588614wmh.113.1572039108345;
        Fri, 25 Oct 2019 14:31:48 -0700 (PDT)
Received: from [192.168.43.163] ([109.126.132.16])
        by smtp.gmail.com with ESMTPSA id 37sm4896169wrc.96.2019.10.25.14.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Oct 2019 14:31:47 -0700 (PDT)
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c33f7137-5b54-c588-f4e8-dd7e1e03edf3@gmail.com>
Date:   Sat, 26 Oct 2019 00:31:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191025173037.13486-3-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Pjzbmz2GGIsZDKcM7mLd0gDiEsC6CkGtt"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Pjzbmz2GGIsZDKcM7mLd0gDiEsC6CkGtt
Content-Type: multipart/mixed; boundary="X4W8tqYRZ97c4iNGxnolIf18vCcEtt3cm";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, jannh@google.com
Message-ID: <c33f7137-5b54-c588-f4e8-dd7e1e03edf3@gmail.com>
Subject: Re: [PATCH 2/4] io_uring: io_uring: add support for async work
 inheriting files
References: <20191025173037.13486-1-axboe@kernel.dk>
 <20191025173037.13486-3-axboe@kernel.dk>
In-Reply-To: <20191025173037.13486-3-axboe@kernel.dk>

--X4W8tqYRZ97c4iNGxnolIf18vCcEtt3cm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 25/10/2019 20:30, Jens Axboe wrote:
> This is in preparation for adding opcodes that need to add new files
> in a process file table, system calls like open(2) or accept4(2).
>=20
> If an opcode needs this, it must set IO_WQ_WORK_NEEDS_FILES in the work=

> item. If work that needs to get punted to async context have this
> set, the async worker will assume the original task file table before
> executing the work.
>=20
> Note that opcodes that need access to the current files of an
> application cannot be done through IORING_SETUP_SQPOLL.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io-wq.c    |  14 ++++++
>  fs/io-wq.h    |   3 ++
>  fs/io_uring.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++--=

>  3 files changed, 129 insertions(+), 4 deletions(-)
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index 99ac5e338d99..134c4632c0be 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -52,6 +52,7 @@ struct io_worker {
> =20
>  	struct rcu_head rcu;
>  	struct mm_struct *mm;
> +	struct files_struct *restore_files;
>  };
> =20
>  struct io_wq_nulls_list {
> @@ -128,6 +129,12 @@ static bool __io_worker_unuse(struct io_wqe *wqe, =
struct io_worker *worker)
>  	__must_hold(wqe->lock)
>  	__releases(wqe->lock)
>  {
> +	if (current->files !=3D worker->restore_files) {
> +		task_lock(current);
> +		current->files =3D worker->restore_files;
> +		task_unlock(current);
> +	}
> +
>  	/*
>  	 * If we have an active mm, we need to drop the wq lock before unusin=
g
>  	 * it. If we do, return true and let the caller retry the idle loop.
> @@ -188,6 +195,7 @@ static void io_worker_start(struct io_wqe *wqe, str=
uct io_worker *worker)
>  	current->flags |=3D PF_IO_WORKER;
> =20
>  	worker->flags |=3D (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
> +	worker->restore_files =3D current->files;
>  	atomic_inc(&wqe->nr_running);
>  }
> =20
> @@ -278,6 +286,12 @@ static void io_worker_handle_work(struct io_worker=
 *worker)
>  		if (!work)
>  			break;
>  next:
> +		if ((work->flags & IO_WQ_WORK_NEEDS_FILES) &&
> +		    current->files !=3D work->files) {
> +			task_lock(current);
> +			current->files =3D work->files;
> +			task_unlock(current);
> +		}
>  		if ((work->flags & IO_WQ_WORK_NEEDS_USER) && !worker->mm &&
>  		    wq->mm && mmget_not_zero(wq->mm)) {
>  			use_mm(wq->mm);
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index be8f22c8937b..e93f764b1fa4 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -8,6 +8,7 @@ enum {
>  	IO_WQ_WORK_HAS_MM	=3D 2,
>  	IO_WQ_WORK_HASHED	=3D 4,
>  	IO_WQ_WORK_NEEDS_USER	=3D 8,
> +	IO_WQ_WORK_NEEDS_FILES	=3D 16,
> =20
>  	IO_WQ_HASH_SHIFT	=3D 24,	/* upper 8 bits are used for hash key */
>  };
> @@ -22,12 +23,14 @@ struct io_wq_work {
>  	struct list_head list;
>  	void (*func)(struct io_wq_work **);
>  	unsigned flags;
> +	struct files_struct *files;
>  };
> =20
>  #define INIT_IO_WORK(work, _func)			\
>  	do {						\
>  		(work)->func =3D _func;			\
>  		(work)->flags =3D 0;			\
> +		(work)->files =3D NULL;			\
>  	} while (0)					\
> =20
>  struct io_wq *io_wq_create(unsigned concurrency, struct mm_struct *mm)=
;
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index effa385ebe72..5a6f8e1dc718 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -196,6 +196,8 @@ struct io_ring_ctx {
> =20
>  		struct list_head	defer_list;
>  		struct list_head	timeout_list;
> +
> +		wait_queue_head_t	inflight_wait;
>  	} ____cacheline_aligned_in_smp;
> =20
>  	/* IO offload */
> @@ -250,6 +252,9 @@ struct io_ring_ctx {
>  		 */
>  		struct list_head	poll_list;
>  		struct list_head	cancel_list;
> +
> +		spinlock_t		inflight_lock;
> +		struct list_head	inflight_list;
>  	} ____cacheline_aligned_in_smp;
> =20
>  #if defined(CONFIG_UNIX)
> @@ -259,11 +264,13 @@ struct io_ring_ctx {
> =20
>  struct sqe_submit {
>  	const struct io_uring_sqe	*sqe;
> +	struct file			*ring_file;
>  	unsigned short			index;
>  	bool				has_user : 1;
>  	bool				in_async : 1;
>  	bool				needs_fixed_file : 1;
>  	u32				sequence;
> +	int				ring_fd;
>  };
> =20
>  /*
> @@ -318,10 +325,13 @@ struct io_kiocb {
>  #define REQ_F_TIMEOUT		1024	/* timeout request */
>  #define REQ_F_ISREG		2048	/* regular file */
>  #define REQ_F_MUST_PUNT		4096	/* must be punted even for NONBLOCK */
> +#define REQ_F_INFLIGHT		8192	/* on inflight list */
>  	u64			user_data;
>  	u32			result;
>  	u32			sequence;
> =20
> +	struct list_head	inflight_entry;
> +
>  	struct io_wq_work	work;
>  };
> =20
> @@ -402,6 +412,9 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct=
 io_uring_params *p)
>  	INIT_LIST_HEAD(&ctx->cancel_list);
>  	INIT_LIST_HEAD(&ctx->defer_list);
>  	INIT_LIST_HEAD(&ctx->timeout_list);
> +	init_waitqueue_head(&ctx->inflight_wait);
> +	spin_lock_init(&ctx->inflight_lock);
> +	INIT_LIST_HEAD(&ctx->inflight_list);
>  	return ctx;
>  }
> =20
> @@ -671,9 +684,20 @@ static void io_free_req_many(struct io_ring_ctx *c=
tx, void **reqs, int *nr)
> =20
>  static void __io_free_req(struct io_kiocb *req)
>  {
> +	struct io_ring_ctx *ctx =3D req->ctx;
> +
>  	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
>  		fput(req->file);
> -	percpu_ref_put(&req->ctx->refs);
> +	if (req->flags & REQ_F_INFLIGHT) {
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&ctx->inflight_lock, flags);
> +		list_del(&req->inflight_entry);
> +		if (waitqueue_active(&ctx->inflight_wait))
> +			wake_up(&ctx->inflight_wait);
> +		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
> +	}
> +	percpu_ref_put(&ctx->refs);
>  	kmem_cache_free(req_cachep, req);
>  }
> =20
> @@ -2277,6 +2301,30 @@ static int io_req_set_file(struct io_ring_ctx *c=
tx, const struct sqe_submit *s,
>  	return 0;
>  }
> =20
> +static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req=
)
> +{
> +	int ret =3D -EBADF;
> +
> +	rcu_read_lock();
> +	spin_lock_irq(&ctx->inflight_lock);
> +	/*
> +	 * We use the f_ops->flush() handler to ensure that we can flush
> +	 * out work accessing these files if the fd is closed. Check if
> +	 * the fd has changed since we started down this path, and disallow
> +	 * this operation if it has.
> +	 */
> +	if (fcheck(req->submit.ring_fd) =3D=3D req->submit.ring_file) {
Can we get here from io_submit_sqes()?
ring_fd will be uninitialised in this case.


> +		list_add(&req->inflight_entry, &ctx->inflight_list);
> +		req->flags |=3D REQ_F_INFLIGHT;
> +		req->work.files =3D current->files;
> +		ret =3D 0;
> +	}
> +	spin_unlock_irq(&ctx->inflight_lock);
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  static int __io_queue_sqe(struct io_ring_ctx *ctx, struct io_kiocb *re=
q,
>  			struct sqe_submit *s)
>  {
> @@ -2296,17 +2344,25 @@ static int __io_queue_sqe(struct io_ring_ctx *c=
tx, struct io_kiocb *req,
>  		if (sqe_copy) {
>  			s->sqe =3D sqe_copy;
>  			memcpy(&req->submit, s, sizeof(*s));
> -			io_queue_async_work(ctx, req);
> +			if (req->work.flags & IO_WQ_WORK_NEEDS_FILES) {
> +				ret =3D io_grab_files(ctx, req);
> +				if (ret) {
> +					kfree(sqe_copy);
> +					goto err;
> +				}
> +			}
> =20
>  			/*
>  			 * Queued up for async execution, worker will release
>  			 * submit reference when the iocb is actually submitted.
>  			 */
> +			io_queue_async_work(ctx, req);
>  			return 0;
>  		}
>  	}
> =20
>  	/* drop submission reference */
> +err:
>  	io_put_req(req, NULL);
> =20
>  	/* and drop final reference, if we failed */
> @@ -2509,6 +2565,7 @@ static bool io_get_sqring(struct io_ring_ctx *ctx=
, struct sqe_submit *s)
> =20
>  	head =3D READ_ONCE(sq_array[head & ctx->sq_mask]);
>  	if (head < ctx->sq_entries) {
> +		s->ring_file =3D NULL;
>  		s->index =3D head;
>  		s->sqe =3D &ctx->sq_sqes[head];
>  		s->sequence =3D ctx->cached_sq_head;
> @@ -2716,7 +2773,8 @@ static int io_sq_thread(void *data)
>  	return 0;
>  }
> =20
> -static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_sub=
mit)
> +static int io_ring_submit(struct io_ring_ctx *ctx, unsigned int to_sub=
mit,
> +			  struct file *ring_file, int ring_fd)
>  {
>  	struct io_submit_state state, *statep =3D NULL;
>  	struct io_kiocb *link =3D NULL;
> @@ -2758,9 +2816,11 @@ static int io_ring_submit(struct io_ring_ctx *ct=
x, unsigned int to_submit)
>  		}
> =20
>  out:
> +		s.ring_file =3D ring_file;
>  		s.has_user =3D true;
>  		s.in_async =3D false;
>  		s.needs_fixed_file =3D false;
> +		s.ring_fd =3D ring_fd;
>  		submit++;
>  		trace_io_uring_submit_sqe(ctx, true, false);
>  		io_submit_sqe(ctx, &s, statep, &link);
> @@ -3722,6 +3782,53 @@ static int io_uring_release(struct inode *inode,=
 struct file *file)
>  	return 0;
>  }
> =20
> +static void io_uring_cancel_files(struct io_ring_ctx *ctx,
> +				  struct files_struct *files)
> +{
> +	struct io_kiocb *req;
> +	DEFINE_WAIT(wait);
> +
> +	while (!list_empty_careful(&ctx->inflight_list)) {
> +		enum io_wq_cancel ret =3D IO_WQ_CANCEL_NOTFOUND;
> +
> +		spin_lock_irq(&ctx->inflight_lock);
> +		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
> +			if (req->work.files =3D=3D files) {
> +				ret =3D io_wq_cancel_work(ctx->io_wq, &req->work);
> +				break;
> +			}
> +		}
> +		if (ret =3D=3D IO_WQ_CANCEL_RUNNING)
> +			prepare_to_wait(&ctx->inflight_wait, &wait,
> +					TASK_UNINTERRUPTIBLE);
> +
> +		spin_unlock_irq(&ctx->inflight_lock);
> +
> +		/*
> +		 * We need to keep going until we get NOTFOUND. We only cancel
> +		 * one work at the time.
> +		 *
> +		 * If we get CANCEL_RUNNING, then wait for a work to complete
> +		 * before continuing.
> +		 */
> +		if (ret =3D=3D IO_WQ_CANCEL_OK)
> +			continue;
> +		else if (ret !=3D IO_WQ_CANCEL_RUNNING)
> +			break;
> +		schedule();
> +	}
> +}
> +
> +static int io_uring_flush(struct file *file, void *data)
> +{
> +	struct io_ring_ctx *ctx =3D file->private_data;
> +
> +	io_uring_cancel_files(ctx, data);
> +	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> +		io_wq_cancel_all(ctx->io_wq);
> +	return 0;
> +}
> +
>  static int io_uring_mmap(struct file *file, struct vm_area_struct *vma=
)
>  {
>  	loff_t offset =3D (loff_t) vma->vm_pgoff << PAGE_SHIFT;
> @@ -3790,7 +3897,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd,=
 u32, to_submit,
>  		to_submit =3D min(to_submit, ctx->sq_entries);
> =20
>  		mutex_lock(&ctx->uring_lock);
> -		submitted =3D io_ring_submit(ctx, to_submit);
> +		submitted =3D io_ring_submit(ctx, to_submit, f.file, fd);
>  		mutex_unlock(&ctx->uring_lock);
>  	}
>  	if (flags & IORING_ENTER_GETEVENTS) {
> @@ -3813,6 +3920,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd,=
 u32, to_submit,
> =20
>  static const struct file_operations io_uring_fops =3D {
>  	.release	=3D io_uring_release,
> +	.flush		=3D io_uring_flush,
>  	.mmap		=3D io_uring_mmap,
>  	.poll		=3D io_uring_poll,
>  	.fasync		=3D io_uring_fasync,
>=20

--=20
Yours sincerely,
Pavel Begunkov


--X4W8tqYRZ97c4iNGxnolIf18vCcEtt3cm--

--Pjzbmz2GGIsZDKcM7mLd0gDiEsC6CkGtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl2zabwACgkQWt5b1Glr
+6VasRAAn9D2DrWP5t25ed0MTeSm0w6ANLJCw/wYvccgsTDw2AWM28XGuzkuN8XR
BwBAoAFIDUufi6OAdT3RZSfkrt8dYlbcKnyRQyrX43BRJPZxMwfnxIhcYNqoSWzX
jwucml1XCIaOPwuvrwof7Km3Fgr0AmaAmTMyhZLeu9CbvW+RVyH64xdCpz3RcLAJ
IBDiiTdnzs3s2T0dhjfe+Tm8Qnp6xa1BnBvjhFB2ztmdC28KHihpb+6C+r/CjlQf
WBIMa4Dq4f1o/jmNH9VbGV2j+V125xk8HCciEZZZjr39eXj153PT4thcGQBodEEZ
mn9ZoGz2kMTEX5V+wy4CSMArvrDy+M2rINFDMrebdcuNtkU7VtyJCjda6/Q2vXaw
b1XQGGhL1WY1lQOvAwrGKjddlzWzMiwRDRwts4FsVL/P/w5PTReA1HfDCmEqTdlj
aSHfTItFsDxIcfNAG8n95WCGEO8tJYbA76aO5arlX5+Lf7Vx0fFxCzp7r4l7Zfjd
6FaGic2loikVZZlborZ9dNEMZCXg1QTkcjNqnP+1QmsRJ9H07l6VQNNp6abxq4go
LyILIZ0vNnACjGNJ2gy6P8EVQYojinFlRgTb1Pwh0k8U7Hp80WjFDC1vk0jwZTx1
lk3JMUgipI0VcQpNmqJPR+yzE3uMC/VdPIm/Qsb8LNd1rbrKWMo=
=SDqU
-----END PGP SIGNATURE-----

--Pjzbmz2GGIsZDKcM7mLd0gDiEsC6CkGtt--
