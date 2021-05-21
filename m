Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFF738BAE9
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhEUAod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 20:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhEUAo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 20:44:29 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A692C061574;
        Thu, 20 May 2021 17:43:07 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id y184-20020a1ce1c10000b02901769b409001so6224037wmg.3;
        Thu, 20 May 2021 17:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=biVpLbsE2ctahUajkeB/6fi6wXSoIR5li/nvuWvn9d8=;
        b=UjNpwrnAsUs8iUYznG/uJcFpqpjvFOLMcgtc3Cv8SxlQrUZjTpAIgyZot8cymU2cfm
         7cWuXg3Bt3Z8gQbkHkX7YB8HnYEcQtm6khHsmN/uc9AvkE7HjfsKKMPCWEznGN1jafxa
         Fwn8oaT0KEB2Kmr/jC2dCBss2W49yIKV39CUvgOyNi+AGDxRQUcM67mcfjLqVjih1j8B
         8INLjVzR1pODHnrZtGRdeF/L8iKbVD33Z2QXOAKURf0EQznePGcZssnuzwh3F1jTHDDa
         GKhsOlSulHsi7PgdPZa8tZklVVZ9qXehDCWgrIXW6gj5VeQpt2sCGVh4rcAX4hHFJoph
         +cYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=biVpLbsE2ctahUajkeB/6fi6wXSoIR5li/nvuWvn9d8=;
        b=X1taC1f7c9lg9zeVe33b+SsLzUn42/AmSplFqkfm/oiO2Wy5lIoA0TmHVVOCTNi+mC
         5bS4Hj5u+o9feHah8jhHUz5qZUOChfRFSsMVua9OidReEuqG4B7OjvJUOybNqcLSzA3l
         EJWCCc6GWYGR0bbNQZb6FIOfZgH1pYeJpthJDvOVhvi5niCwxmvZlhzy1t3uqCyUGDYF
         Ourg88NXSe0kxNf3lmavNi7Qh8lvmcj/VcHYz8LpZMWdV51bNa/sY57PMVN0888PZmHK
         HSIsKAiz+oiu+3ZVC/zJV0UyXtIT8nGFT/ACmA1vEJIiyaPhzRjIinFLPHrCadagovGA
         y+MQ==
X-Gm-Message-State: AOAM532dV1R1vlPv+HH6XD2aHRt7WIXyOsL9HxIuNEHdydBF54z/moM0
        AWSRdd0WvBz+OMZMYlXum3E=
X-Google-Smtp-Source: ABdhPJwk51uW5xZbQfvUyc/qcZR8wkQ2j4UTZYWP0Gm/isGDMJAtx4lxaGK5ayoLS4DjKplisTNgwA==
X-Received: by 2002:a1c:7501:: with SMTP id o1mr6115870wmc.65.1621557785713;
        Thu, 20 May 2021 17:43:05 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id f12sm117667wre.88.2021.05.20.17.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 17:43:05 -0700 (PDT)
Subject: Re: [PATCH 14/23] io_uring: add support for bpf requests
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <cc2b848d112d86bd1f4ea3f2813d0a016e44a364.1621424513.git.asml.silence@gmail.com>
Message-ID: <70ae2078-689f-79d3-e067-2bb720dc9fa5@gmail.com>
Date:   Fri, 21 May 2021 01:42:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cc2b848d112d86bd1f4ea3f2813d0a016e44a364.1621424513.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/21 3:13 PM, Pavel Begunkov wrote:
> Wire up a new io_uring operation type IORING_OP_BPF, which executes a
> specified BPF program from the registered prog table. It doesn't allow
> to do anything useful for now, no BPF functions are allowed apart from
> basic ones.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c                 | 92 +++++++++++++++++++++++++++++++++++
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 93 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b13cbcd5c47b..20fddc5945f2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -682,6 +682,11 @@ struct io_unlink {
>  	struct filename			*filename;
>  };
>  
> +struct io_bpf {
> +	struct file			*file;
> +	struct bpf_prog			*prog;
> +};
> +
>  struct io_completion {
>  	struct file			*file;
>  	struct list_head		list;
> @@ -826,6 +831,7 @@ struct io_kiocb {
>  		struct io_shutdown	shutdown;
>  		struct io_rename	rename;
>  		struct io_unlink	unlink;
> +		struct io_bpf		bpf;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -875,6 +881,9 @@ struct io_defer_entry {
>  	u32			seq;
>  };
>  
> +struct io_bpf_ctx {
> +};
> +
>  struct io_op_def {
>  	/* needs req->file assigned */
>  	unsigned		needs_file : 1;
> @@ -1039,6 +1048,7 @@ static const struct io_op_def io_op_defs[] = {
>  	},
>  	[IORING_OP_RENAMEAT] = {},
>  	[IORING_OP_UNLINKAT] = {},
> +	[IORING_OP_BPF] = {},
>  };
>  
>  static bool io_disarm_next(struct io_kiocb *req);
> @@ -1070,6 +1080,7 @@ static void io_rsrc_put_work(struct work_struct *work);
>  static void io_req_task_queue(struct io_kiocb *req);
>  static void io_submit_flush_completions(struct io_comp_state *cs,
>  					struct io_ring_ctx *ctx);
> +static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags);
>  static bool io_poll_remove_waitqs(struct io_kiocb *req);
>  static int io_req_prep_async(struct io_kiocb *req);
>  
> @@ -3931,6 +3942,53 @@ static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
>  	return io_openat2(req, issue_flags);
>  }
>  
> +static int io_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct bpf_prog *prog;
> +	unsigned int idx;
> +
> +	if (unlikely(ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
> +		return -EINVAL;
> +	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
> +		return -EINVAL;
> +	if (sqe->ioprio || sqe->len || sqe->cancel_flags)
> +		return -EINVAL;
> +	if (sqe->addr)
> +		return -EINVAL;
> +
> +	idx = READ_ONCE(sqe->off);
> +	if (unlikely(idx >= ctx->nr_bpf_progs))
> +		return -EFAULT;
> +	idx = array_index_nospec(idx, ctx->nr_bpf_progs);
> +	prog = ctx->bpf_progs[idx].prog;
> +	if (!prog)
> +		return -EFAULT;
> +
> +	req->bpf.prog = prog;
> +	return 0;
> +}
> +
> +static void io_bpf_run_task_work(struct callback_head *cb)
> +{
> +	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	mutex_lock(&ctx->uring_lock);
> +	io_bpf_run(req, 0);
> +	mutex_unlock(&ctx->uring_lock);
> +}
> +
> +static int io_bpf(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	init_task_work(&req->task_work, io_bpf_run_task_work);
> +	if (unlikely(io_req_task_work_add(req))) {
> +		req_ref_get(req);
> +		io_req_task_queue_fail(req, -ECANCELED);
> +	}
> +	return 0;
> +}
> +
>  static int io_remove_buffers_prep(struct io_kiocb *req,
>  				  const struct io_uring_sqe *sqe)
>  {
> @@ -6002,6 +6060,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_renameat_prep(req, sqe);
>  	case IORING_OP_UNLINKAT:
>  		return io_unlinkat_prep(req, sqe);
> +	case IORING_OP_BPF:
> +		return io_bpf_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6269,6 +6329,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	case IORING_OP_UNLINKAT:
>  		ret = io_unlinkat(req, issue_flags);
>  		break;
> +	case IORING_OP_BPF:
> +		ret = io_bpf(req, issue_flags);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> @@ -10303,6 +10366,35 @@ const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
>  	.is_valid_access	= io_bpf_is_valid_access,
>  };
>  
> +static void io_bpf_run(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_bpf_ctx bpf_ctx;
> +	struct bpf_prog *prog;
> +	int ret = -EAGAIN;
> +
> +	lockdep_assert_held(&req->ctx->uring_lock);
> +
> +	if (unlikely(percpu_ref_is_dying(&ctx->refs) ||
> +		     atomic_read(&req->task->io_uring->in_idle)))
> +		goto done;
> +
> +	memset(&bpf_ctx, 0, sizeof(bpf_ctx));
> +	prog = req->bpf.prog;
> +
> +	if (prog->aux->sleepable) {

Looks forgot to amend, the condition should be inversed.

> +		rcu_read_lock();
> +		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
> +		rcu_read_unlock();
> +	} else {
> +		bpf_prog_run_pin_on_cpu(req->bpf.prog, &bpf_ctx);
> +	}
> +
> +	ret = 0;
> +done:
> +	__io_req_complete(req, issue_flags, ret, 0);
> +}
> +
>  SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>  		void __user *, arg, unsigned int, nr_args)
>  {
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index b450f41d7389..25ab804670e1 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -138,6 +138,7 @@ enum {
>  	IORING_OP_SHUTDOWN,
>  	IORING_OP_RENAMEAT,
>  	IORING_OP_UNLINKAT,
> +	IORING_OP_BPF,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
