Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC77573692
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiGMMs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiGMMs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:48:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB607661
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 05:48:56 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id o12so10138736pfp.5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 05:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BKyOVUrzwlaedgmh0TuoPyFjlEf5eVuhO+GwcT5efrU=;
        b=bbYa+VrAHcIx3mN0sGx3I8E5KYpenxnW/O5AclFwgleyzY2l3CEGLh6LHZYlZuFi0c
         M+L95bPLVNk836RrpS5lSWETYIAC13XzjZ3En0fYoghEcewIm6PaNyW35plRscEYAlPb
         LilA8tnECxqyBj34QvQ17FPHNownE+3o0ci7to5GZrfegAJwZyCTF7MjXjha2Cuyen/4
         kzOOdMK4LN3VuygIdfPPl+IEmm74zevzRwJuSLMvntjAJ7JL1Woa1BMzd8vdp4NtEbgG
         ugtoyMf02XPdRotsJCu8xWfG4mtdm0k0WAdyUYPOlsnPLZG6wHOtSL3Kj2EwlD+SlbuW
         GVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BKyOVUrzwlaedgmh0TuoPyFjlEf5eVuhO+GwcT5efrU=;
        b=u/8s5ZsncKJSJEbX41y5sv/4Aov+oh2kBFOQsCcqbxuW00qVKGhUcAllzg/f+MNTno
         i5igfVUQkwoUbM+zFRDLKpuXRVqo4CFM7IAbktkn4QLPlsjrMzdRoLfKuDwMoPYGa/AH
         7h2EKljc8T3SWGRn/O3NWxX7jB2nVm4kvKm3h+tYbt9D2rlGFn92nKPJmhGBY7749hnd
         RoC+/8zVKPDXL9EuvlA/WlYYlfkCdDhulGSI76FGe0QhNlRt1xHLWvj7dG++OYziYgS2
         UjxZs2xGgtIHWV7f0amlAjF7NYKS+CrzmWlpWL8RJd/5VgzDqGG0a32a3uSRj70Sky4i
         oDng==
X-Gm-Message-State: AJIora9GvkOAQd2hryGkKiHYeihpsUyzoIPx0vAXz4LlO/bcx7Xp2TjI
        sMG5GAZ78UGGjAI/JC26t3HbTg==
X-Google-Smtp-Source: AGRyM1sR/9fto7YBBHCjR6Pvk5mF6BTSRsy726v4jv4mUoUxp61ro7zHAalNtXqcPpCQG9+whFxjWQ==
X-Received: by 2002:a65:6048:0:b0:412:73c7:cca9 with SMTP id a8-20020a656048000000b0041273c7cca9mr2921072pgp.257.1657716535401;
        Wed, 13 Jul 2022 05:48:55 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902680300b0016bfa1a5170sm8747848plk.285.2022.07.13.05.48.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 05:48:54 -0700 (PDT)
Message-ID: <6d80d6a3-749a-baa3-8f27-5e6a696d0499@kernel.dk>
Date:   Wed, 13 Jul 2022 06:48:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 for-next 3/3] io_uring: support multishot in recvmsg
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        io-uring@vger.kernel.org
Cc:     netdev@vger.kernel.org, Kernel-team@fb.com
References: <20220713082321.1445020-1-dylany@fb.com>
 <20220713082321.1445020-4-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220713082321.1445020-4-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/22 2:23 AM, Dylan Yudaken wrote:
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 5bc3440a8290..56f734acced6 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -483,12 +491,15 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
>  }
>  
>  /*
> - * Finishes io_recv
> + * Finishes io_recv and io_recvmsg.
>   *
>   * Returns true if it is actually finished, or false if it should run
>   * again (for multishot).
>   */
> -static inline bool io_recv_finish(struct io_kiocb *req, int *ret, unsigned int cflags)
> +static inline bool io_recv_finish(struct io_kiocb *req,
> +				  int *ret,
> +				  unsigned int cflags,
> +				  bool multishot_finished)
>  {
>  	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {

Minor nit, but this should look like:

static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
				  unsigned int cflags, bool mshot_finished)
> @@ -518,6 +529,104 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret, unsigned int c
>  	return true;
>  }
>  
> +static int io_recvmsg_prep_multishot(
> +	struct io_async_msghdr *kmsg,
> +	struct io_sr_msg *sr,
> +	void __user **buf,
> +	size_t *len)
> +{

Ditto on the function formating.

> +	unsigned long used = 0;
> +
> +	if (*len < sizeof(struct io_uring_recvmsg_out))
> +		return -EFAULT;
> +	used += sizeof(struct io_uring_recvmsg_out);
> +
> +	if (kmsg->namelen) {
> +		if (kmsg->namelen + used > *len)
> +			return -EFAULT;
> +		used += kmsg->namelen;
> +	}
> +	if (kmsg->controllen) {
> +		if (kmsg->controllen + used > *len)
> +			return -EFAULT;
> +		kmsg->msg.msg_control_user = (void *)((unsigned long)*buf + used);
> +		kmsg->msg.msg_controllen = kmsg->controllen;
> +		used += kmsg->controllen;
> +	}
> +	if (used >= UINT_MAX)
> +		return -EOVERFLOW;
> +
> +	sr->buf = *buf; /* stash for later copy */
> +	*buf = (void *)((unsigned long)*buf + used);
> +	*len -= used;
> +	kmsg->payloadlen = *len;
> +	return 0;
> +}

Not sure if it's just me, but the *buf and casting is really hard to
read here. Can we make that any clearer? Maybe cast to an unsigned long
* at the top of change the buf argument to be that?

> +struct io_recvmsg_multishot_hdr {
> +	struct io_uring_recvmsg_out msg;
> +	struct sockaddr_storage addr;
> +} __packed;

This __packed shouldn't be necessary, and I'm always a bit wary of
adding it on kernel structures as if it's really needed, then we're most
likely doing something wrong (and things will run slower, notably on
some archs). Looks like you have a BUILD_BUG_ON() for this too, so we'd
catch any potential issues here upfront.

> +static int io_recvmsg_multishot(
> +	struct socket *sock,
> +	struct io_sr_msg *io,
> +	struct io_async_msghdr *kmsg,
> +	unsigned int flags,
> +	bool *finished)
> +{
> +	int err;
> +	int copy_len;
> +	struct io_recvmsg_multishot_hdr hdr;
> +
> +	if (kmsg->namelen)
> +		kmsg->msg.msg_name = &hdr.addr;
> +	kmsg->msg.msg_flags = flags & (MSG_CMSG_CLOEXEC|MSG_CMSG_COMPAT);
> +	kmsg->msg.msg_namelen = 0;
> +
> +	if (sock->file->f_flags & O_NONBLOCK)
> +		flags |= MSG_DONTWAIT;
> +
> +	err = sock_recvmsg(sock, &kmsg->msg, flags);
> +	*finished = err <= 0;
> +	if (err < 0)
> +		return err;
> +
> +	hdr.msg = (struct io_uring_recvmsg_out) {
> +		.controllen = kmsg->controllen - kmsg->msg.msg_controllen,
> +		.flags = kmsg->msg.msg_flags & ~MSG_CMSG_COMPAT
> +	};
> +
> +	hdr.msg.payloadlen = err;
> +	if (err > kmsg->payloadlen)
> +		err = kmsg->payloadlen;
> +
> +	copy_len = sizeof(struct io_uring_recvmsg_out);
> +	if (kmsg->msg.msg_namelen > kmsg->namelen)
> +		copy_len += kmsg->namelen;
> +	else
> +		copy_len += kmsg->msg.msg_namelen;
> +
> +	/*
> +	 *      "fromlen shall refer to the value before truncation.."
> +	 *                      1003.1g
> +	 */
> +	hdr.msg.namelen = kmsg->msg.msg_namelen;
> +
> +	/* ensure that there is no gap between hdr and sockaddr_storage */
> +	BUILD_BUG_ON(offsetof(struct io_recvmsg_multishot_hdr, addr) !=
> +		     sizeof(struct io_uring_recvmsg_out));
> +	if (copy_to_user(io->buf, &hdr, copy_len)) {
> +		*finished = true;
> +		return -EFAULT;
> +	}
> +
> +	return sizeof(struct io_uring_recvmsg_out) +
> +		kmsg->namelen +
> +		kmsg->controllen +
> +		err;
> +}

	return sizeof(struct io_uring_recvmsg_out) + kmsg->namelen +
			kmsg->controllen + err;

would be closer to the kernel style.

In general I'm not a big fan of the bool pointer 'finished'. But I also
don't have a good suggestion on how to make it cleaner, so... Would be
nice if we could just have an error return (< 0), and then return >= 0
in two variants for MSHOT_OK and MSHOT_TERMINATE or something.

> @@ -527,6 +636,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  	unsigned flags;
>  	int ret, min_ret = 0;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
> +	bool multishot_finished = true;
>  
>  	sock = sock_from_file(req->file);
>  	if (unlikely(!sock))
> @@ -545,16 +655,29 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>  	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
>  		return io_setup_async_msg(req, kmsg, issue_flags);
>  
> +retry_multishot:
>  	if (io_do_buffer_select(req)) {
>  		void __user *buf;
> +		size_t len = sr->len;
>  
> -		buf = io_buffer_select(req, &sr->len, issue_flags);
> +		buf = io_buffer_select(req, &len, issue_flags);
>  		if (!buf)
>  			return -ENOBUFS;
> +
> +		if (req->flags & REQ_F_APOLL_MULTISHOT) {
> +			ret = io_recvmsg_prep_multishot(kmsg, sr,
> +							&buf, &len);
> +
			ret = io_recvmsg_prep_multishot(kmsg, sr, &buf, &len);

Apart from these nits, looks pretty good to me.

-- 
Jens Axboe

