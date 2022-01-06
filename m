Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB9448689E
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242074AbiAFRcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242096AbiAFRcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:32:04 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CA2C034000;
        Thu,  6 Jan 2022 09:32:03 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so3896033pji.3;
        Thu, 06 Jan 2022 09:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F6BvddQSghSUpi/aUMLF/la8hm42Cnpo4XIe+FyB6vw=;
        b=JQcvWNT5+7ufzcU8rBnRYw/j7jOGmf5VbXNL7fhEorWyg+yssPSE48I85lZd0Hot1l
         wUe3imRBJAgGkW8cbvIwZAsZgGPtUvIWmjKVGc3QIF1W+dyuEaeMTf1hVpyDhn0ZF4vT
         vei1n5LHZdbEGyiW3EKWaAXicfrtoLVK/PvuRgl8P+nCdT2QT0ICYoBzFq7t8xjF364u
         stVZcCjz27SDtztEkM20Xi0eLq5EHqHSW+16jDG1DGGlaCT6KF+quh8CufBAhiP2520b
         bOI/60vGkrKUrh0Pu78oOzBmS9Oq78tCXekWB9OJEqrk4OgCIwJEzVaMOqOyPhIgN7JH
         jXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F6BvddQSghSUpi/aUMLF/la8hm42Cnpo4XIe+FyB6vw=;
        b=sz+03cHPsZOkOOvwhhWj95xGErThc0j2FO7dbbFLr9N99kFvgH5VmHXTYLZoM8wRp3
         3jhEHQcoNUqmnyjXwrbFANgPWV7y7VGRqsilPdqavNxn209ZROt3+cu2iQu+dsf/VnhR
         o1voWoxgiIQ1ajEhXZWRZsMR9JFQ4BeEZxppeGIwxBECiThhbi5iYES5gHD+pm/9LAxX
         Pp+6s0v8LXVOOOm/NTDvnTNd2Ya/8Qi+6Zubf/nuH3tLkvzzDNQPtVsVZV2vnnUucFPb
         oJ9G12MdLJVwOBfX4/E5DPG+SbM4JOFec/3zEUYV85CSG+ghvV9tocGQf35XJLvJ7BPR
         cZdQ==
X-Gm-Message-State: AOAM530SMNKoDVjvZoHqZj8TqDNsKeS3J1z7WXk9cDRSJOGesmPGwgs/
        QIs1zHg1Gi9iriv5wDoeKwplZQ/PHLM=
X-Google-Smtp-Source: ABdhPJyCQs+I8O+y7HMBQUgUXeBjmEgs9ULVUwVMvYLKsWOGT+/jlb2BLG/2gfIISPXZO/xmb0kE9A==
X-Received: by 2002:a17:902:c008:b0:149:346b:cb85 with SMTP id v8-20020a170902c00800b00149346bcb85mr59811515plx.122.1641490323396;
        Thu, 06 Jan 2022 09:32:03 -0800 (PST)
Received: from [192.168.1.122] ([122.172.37.80])
        by smtp.gmail.com with ESMTPSA id t5sm2487888pgj.85.2022.01.06.09.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Jan 2022 09:32:03 -0800 (PST)
Message-ID: <597c1bfc-f8ab-d513-4916-dbd93b05e66a@gmail.com>
Date:   Thu, 6 Jan 2022 23:01:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v3 3/3] io_uring: Add `sendto(2)` and `recvfrom(2)`
 support
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nugra <richiisei@gmail.com>
References: <20211230115057.139187-3-ammar.faizi@intel.com>
 <20211230173126.174350-1-ammar.faizi@intel.com>
 <20211230173126.174350-4-ammar.faizi@intel.com>
From:   Praveen Kumar <kpraveen.lkml@gmail.com>
In-Reply-To: <20211230173126.174350-4-ammar.faizi@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30-12-2021 23:22, Ammar Faizi wrote:
> This adds sendto(2) and recvfrom(2) support for io_uring.
> 
> New opcodes:
>   IORING_OP_SENDTO
>   IORING_OP_RECVFROM
> 
> Cc: Nugra <richiisei@gmail.com>
> Tested-by: Nugra <richiisei@gmail.com>
> Link: https://github.com/axboe/liburing/issues/397
> Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
> ---
> 
> v3:
>   - Fix build error when CONFIG_NET is undefined should be done in
>     the first patch, not this patch.
> 
>   - Add Tested-by tag from Nugra.
> 
> v2:
>   - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
>     call as unlikely.
> 
>   - Fix build error when CONFIG_NET is undefined.
> 
>   - Added Nugra to CC list (tester).
> ---
>  fs/io_uring.c                 | 80 +++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  2 +
>  2 files changed, 78 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7adcb591398f..3726958f8f58 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -575,7 +575,15 @@ struct io_sr_msg {
>  	union {
>  		struct compat_msghdr __user	*umsg_compat;
>  		struct user_msghdr __user	*umsg;
> -		void __user			*buf;
> +
> +		struct {
> +			void __user		*buf;
> +			struct sockaddr __user	*addr;
> +			union {
> +				int		sendto_addr_len;
> +				int __user	*recvfrom_addr_len;
> +			};
> +		};
>  	};
>  	int				msg_flags;
>  	int				bgid;
> @@ -1133,6 +1141,19 @@ static const struct io_op_def io_op_defs[] = {
>  		.needs_file = 1
>  	},
>  	[IORING_OP_GETXATTR] = {},
> +	[IORING_OP_SENDTO] = {
> +		.needs_file		= 1,
> +		.unbound_nonreg_file	= 1,
> +		.pollout		= 1,
> +		.audit_skip		= 1,
> +	},
> +	[IORING_OP_RECVFROM] = {
> +		.needs_file		= 1,
> +		.unbound_nonreg_file	= 1,
> +		.pollin			= 1,
> +		.buffer_select		= 1,
> +		.audit_skip		= 1,
> +	},
>  };
>  
>  /* requests with any of those set should undergo io_disarm_next() */
> @@ -5216,12 +5237,24 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
>  
> +	/*
> +	 * For IORING_OP_SEND{,TO}, the assignment to @sr->umsg
> +	 * is equivalent to an assignment to @sr->buf.
> +	 */
>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +
>  	sr->len = READ_ONCE(sqe->len);
>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>  	if (sr->msg_flags & MSG_DONTWAIT)
>  		req->flags |= REQ_F_NOWAIT;
>  
> +	if (req->opcode == IORING_OP_SENDTO) {
> +		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +		sr->sendto_addr_len = READ_ONCE(sqe->addr3);
> +	} else {
> +		sr->addr = (struct sockaddr __user *) NULL;

Let's have sendto_addr_len  = 0  

> +	}
> +
>  #ifdef CONFIG_COMPAT
>  	if (req->ctx->compat)
>  		sr->msg_flags |= MSG_CMSG_COMPAT;
> @@ -5275,6 +5308,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>  
>  static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>  {
> +	struct sockaddr_storage address;
>  	struct io_sr_msg *sr = &req->sr_msg;
>  	struct msghdr msg;
>  	struct iovec iov;
> @@ -5291,10 +5325,20 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>  	if (unlikely(ret))
>  		return ret;
>  
> -	msg.msg_name = NULL;
> +
>  	msg.msg_control = NULL;
>  	msg.msg_controllen = 0;
> -	msg.msg_namelen = 0;
> +	if (sr->addr) {
> +		ret = move_addr_to_kernel(sr->addr, sr->sendto_addr_len,
> +					  &address);
> +		if (unlikely(ret < 0))
> +			goto fail;
> +		msg.msg_name = (struct sockaddr *) &address;
> +		msg.msg_namelen = sr->sendto_addr_len;
> +	} else {
> +		msg.msg_name = NULL;
> +		msg.msg_namelen = 0;
> +	}
>  
>  	flags = req->sr_msg.msg_flags;
>  	if (issue_flags & IO_URING_F_NONBLOCK)
> @@ -5309,6 +5353,7 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>  			return -EAGAIN;
>  		if (ret == -ERESTARTSYS)
>  			ret = -EINTR;
> +	fail:
>  		req_set_fail(req);

I think there is a problem with "fail" goto statement. Not getting full clarity on this change. With latest kernel, I see req_set_fail(req) inside if check, which I don't see here. Can you please resend the patch on latest kernel version. Thanks.

>  	}
>  	__io_req_complete(req, issue_flags, ret, 0);
> @@ -5427,13 +5472,25 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>  		return -EINVAL;
>  
> +	/*
> +	 * For IORING_OP_RECV{,FROM}, the assignment to @sr->umsg
> +	 * is equivalent to an assignment to @sr->buf.
> +	 */
>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +
>  	sr->len = READ_ONCE(sqe->len);
>  	sr->bgid = READ_ONCE(sqe->buf_group);
>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>  	if (sr->msg_flags & MSG_DONTWAIT)
>  		req->flags |= REQ_F_NOWAIT;
>  
> +	if (req->opcode == IORING_OP_RECVFROM) {
> +		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +		sr->recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> +	} else {
> +		sr->addr = (struct sockaddr __user *) NULL;

I think recvfrom_addr_len should also be pointed to NULL, instead of garbage for this case.

> +	}
> +
>  #ifdef CONFIG_COMPAT
>  	if (req->ctx->compat)
>  		sr->msg_flags |= MSG_CMSG_COMPAT;
> @@ -5509,6 +5566,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>  	struct iovec iov;
>  	unsigned flags;
>  	int ret, min_ret = 0;
> +	struct sockaddr_storage address;
>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>  
>  	sock = sock_from_file(req->file);
> @@ -5526,7 +5584,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>  	if (unlikely(ret))
>  		goto out_free;
>  
> -	msg.msg_name = NULL;
> +	msg.msg_name = sr->addr ? (struct sockaddr *) &address : NULL;
>  	msg.msg_control = NULL;
>  	msg.msg_controllen = 0;
>  	msg.msg_namelen = 0;

I think namelen should also be updated ?

> @@ -5540,6 +5598,16 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>  		min_ret = iov_iter_count(&msg.msg_iter);
>  
>  	ret = sock_recvmsg(sock, &msg, flags);
> +
> +	if (ret >= 0 && sr->addr != NULL) {
> +		int tmp;
> +
> +		tmp = move_addr_to_user(&address, msg.msg_namelen, sr->addr,
> +					sr->recvfrom_addr_len);
> +		if (unlikely(tmp < 0))
> +			ret = tmp;
> +	}
> +
>  out_free:
>  	if (ret < min_ret) {
>  		if (ret == -EAGAIN && force_nonblock)
> @@ -6778,9 +6846,11 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	case IORING_OP_SYNC_FILE_RANGE:
>  		return io_sfr_prep(req, sqe);
>  	case IORING_OP_SENDMSG:
> +	case IORING_OP_SENDTO:
>  	case IORING_OP_SEND:
>  		return io_sendmsg_prep(req, sqe);
>  	case IORING_OP_RECVMSG:
> +	case IORING_OP_RECVFROM:
>  	case IORING_OP_RECV:
>  		return io_recvmsg_prep(req, sqe);
>  	case IORING_OP_CONNECT:
> @@ -7060,12 +7130,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	case IORING_OP_SENDMSG:
>  		ret = io_sendmsg(req, issue_flags);
>  		break;
> +	case IORING_OP_SENDTO:
>  	case IORING_OP_SEND:
>  		ret = io_sendto(req, issue_flags);
>  		break;
>  	case IORING_OP_RECVMSG:
>  		ret = io_recvmsg(req, issue_flags);
>  		break;
> +	case IORING_OP_RECVFROM:
>  	case IORING_OP_RECV:
>  		ret = io_recvfrom(req, issue_flags);
>  		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index efc7ac9b3a6b..a360069d1e8e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -150,6 +150,8 @@ enum {
>  	IORING_OP_SETXATTR,
>  	IORING_OP_FGETXATTR,
>  	IORING_OP_GETXATTR,
> +	IORING_OP_SENDTO,
> +	IORING_OP_RECVFROM,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,


Regards,

~Praveen.
