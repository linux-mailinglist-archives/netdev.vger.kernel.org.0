Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02660487426
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 09:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbiAGIdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 03:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiAGIdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 03:33:50 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1150C061245;
        Fri,  7 Jan 2022 00:33:50 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id 205so4685814pfu.0;
        Fri, 07 Jan 2022 00:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2CeQfauMdUXmKOMOuK6I4lQHEIz0dx7w2UsHkNa4A8Q=;
        b=b+9vQmWEnkOUZKO2v2v4MhjX5Po/KUcTNVNgzNeHSNCMd46eQ3KIgMNTQHYovaR1BV
         jaeDG4OozYn2u1ufwQOeMolEFPJnqJ6GJfCL+RRBjBCDf9xuFlAx9BFfedzYEGD9Nw4Y
         EnXz41+KQhXKGNFGEgezCX04IAVL2PVbHLVr95MUP8GVTU6JF+F2Ax4tOsHvA7HNCA2j
         zjvjHPlftFznwmCD2iCwcs/2S7cXk4zdUVz7VTsTBvzWbi1216jeg2FabSW33KDpeYXB
         zHTYG6argcX/8GFOylgYvm8Sfr7WQD9EuflTZiWwjFaX/QW4jXMXPmtZFW8U7PKYFnbx
         0d5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2CeQfauMdUXmKOMOuK6I4lQHEIz0dx7w2UsHkNa4A8Q=;
        b=BayPfm9ZpnWK0QZRV3bbliuLKpLfWcnLGmo1TQCbFIY2TSr2aNzNjPzQ8zALeU9aKf
         exoQuuPZrCVP4BAQvGenaXPK5qA0jW+3RT9olYWbWRwZUTJvOTo9iSq8n6Mfv0U8+dOH
         EMMwzfYzGNdn91gd77CKoozEh17fX6LHeBU7I6VzHFL1NTL6tDt+Hs9y6JM1tv6z1TZ0
         JwYzKNF6FePuDYPXDShsqtzbSHig+ODQT1+/l8eLQKk3Ou1GEMN6I7Wu5xF88Mh8QnX7
         1Os82MLEOJzY7JG1R43bCRQ6Ll3pUHatstZekdn7+HRaXAAT+tNapJ0bEixeZf5mUU5t
         jK7A==
X-Gm-Message-State: AOAM532mO0CzrFUXeiCoctBqG0s49iPriY3ls9zPd+xmViyqjLOE3+JH
        5p0ROTlZXPMbQv3HyLJGWYrqqWPt5sU=
X-Google-Smtp-Source: ABdhPJzjJkaa6TyZQekKo8cWjieVHdcbRwScC6H+cuytx+RFk3t1aFUwwrEwwYhAaQ3HbFg+941hfA==
X-Received: by 2002:a65:6a84:: with SMTP id q4mr774461pgu.303.1641544430159;
        Fri, 07 Jan 2022 00:33:50 -0800 (PST)
Received: from [192.168.1.87] ([122.172.37.80])
        by smtp.gmail.com with ESMTPSA id h7sm5184908pfv.35.2022.01.07.00.33.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 00:33:49 -0800 (PST)
Message-ID: <778df8ea-f8c6-d586-5c9c-42329da0e40d@gmail.com>
Date:   Fri, 7 Jan 2022 14:03:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v3 3/3] io_uring: Add `sendto(2)` and `recvfrom(2)`
 support
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nugra <richiisei@gmail.com>,
        Ammar Faizi <ammarfaizi2@gmail.com>
References: <20211230115057.139187-3-ammar.faizi@intel.com>
 <20211230173126.174350-1-ammar.faizi@intel.com>
 <20211230173126.174350-4-ammar.faizi@intel.com>
 <597c1bfc-f8ab-d513-4916-dbd93b05e66a@gmail.com>
 <20220106203850.1133211-1-ammarfaizi2@gnuweeb.org>
From:   Praveen Kumar <kpraveen.lkml@gmail.com>
In-Reply-To: <20220106203850.1133211-1-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07-01-2022 02:08, Ammar Faizi wrote:
> 
> On Thu, 6 Jan 2022 at 23:01:59 +0530, Praveen Kumar <kpraveen.lkml@gmail.com> wrote:
>> On 30-12-2021 23:22, Ammar Faizi wrote:
>>> This adds sendto(2) and recvfrom(2) support for io_uring.
>>>
>>> New opcodes:
>>>   IORING_OP_SENDTO
>>>   IORING_OP_RECVFROM
>>>
>>> Cc: Nugra <richiisei@gmail.com>
>>> Tested-by: Nugra <richiisei@gmail.com>
>>> Link: https://github.com/axboe/liburing/issues/397
>>> Signed-off-by: Ammar Faizi <ammarfaizi2@gmail.com>
>>> ---
>>>
>>> v3:
>>>   - Fix build error when CONFIG_NET is undefined should be done in
>>>     the first patch, not this patch.
>>>
>>>   - Add Tested-by tag from Nugra.
>>>
>>> v2:
>>>   - In `io_recvfrom()`, mark the error check of `move_addr_to_user()`
>>>     call as unlikely.
>>>
>>>   - Fix build error when CONFIG_NET is undefined.
>>>
>>>   - Added Nugra to CC list (tester).
>>> ---
>>>  fs/io_uring.c                 | 80 +++++++++++++++++++++++++++++++++--
>>>  include/uapi/linux/io_uring.h |  2 +
>>>  2 files changed, 78 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 7adcb591398f..3726958f8f58 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -575,7 +575,15 @@ struct io_sr_msg {
>>>  	union {
>>>  		struct compat_msghdr __user	*umsg_compat;
>>>  		struct user_msghdr __user	*umsg;
>>> -		void __user			*buf;
>>> +
>>> +		struct {
>>> +			void __user		*buf;
>>> +			struct sockaddr __user	*addr;
>>> +			union {
>>> +				int		sendto_addr_len;
>>> +				int __user	*recvfrom_addr_len;
>>> +			};
>>> +		};
>>>  	};
>>>  	int				msg_flags;
>>>  	int				bgid;
>>> @@ -1133,6 +1141,19 @@ static const struct io_op_def io_op_defs[] = {
>>>  		.needs_file = 1
>>>  	},
>>>  	[IORING_OP_GETXATTR] = {},
>>> +	[IORING_OP_SENDTO] = {
>>> +		.needs_file		= 1,
>>> +		.unbound_nonreg_file	= 1,
>>> +		.pollout		= 1,
>>> +		.audit_skip		= 1,
>>> +	},
>>> +	[IORING_OP_RECVFROM] = {
>>> +		.needs_file		= 1,
>>> +		.unbound_nonreg_file	= 1,
>>> +		.pollin			= 1,
>>> +		.buffer_select		= 1,
>>> +		.audit_skip		= 1,
>>> +	},
>>>  };
>>>  
>>>  /* requests with any of those set should undergo io_disarm_next() */
>>> @@ -5216,12 +5237,24 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>  		return -EINVAL;
>>>  
>>> +	/*
>>> +	 * For IORING_OP_SEND{,TO}, the assignment to @sr->umsg
>>> +	 * is equivalent to an assignment to @sr->buf.
>>> +	 */
>>>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>> +
>>>  	sr->len = READ_ONCE(sqe->len);
>>>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>>>  	if (sr->msg_flags & MSG_DONTWAIT)
>>>  		req->flags |= REQ_F_NOWAIT;
>>>  
>>> +	if (req->opcode == IORING_OP_SENDTO) {
>>> +		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>>> +		sr->sendto_addr_len = READ_ONCE(sqe->addr3);
>>> +	} else {
>>> +		sr->addr = (struct sockaddr __user *) NULL;
>>
>> Let's have sendto_addr_len  = 0  
> 
> Will do in the RFC v5.
> 
>>
>>> +	}
>>> +
>>>  #ifdef CONFIG_COMPAT
>>>  	if (req->ctx->compat)
>>>  		sr->msg_flags |= MSG_CMSG_COMPAT;
>>> @@ -5275,6 +5308,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>>>  
>>>  static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>>>  {
>>> +	struct sockaddr_storage address;
>>>  	struct io_sr_msg *sr = &req->sr_msg;
>>>  	struct msghdr msg;
>>>  	struct iovec iov;
>>> @@ -5291,10 +5325,20 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>>>  	if (unlikely(ret))
>>>  		return ret;
>>>  
>>> -	msg.msg_name = NULL;
>>> +
>>>  	msg.msg_control = NULL;
>>>  	msg.msg_controllen = 0;
>>> -	msg.msg_namelen = 0;
>>> +	if (sr->addr) {
>>> +		ret = move_addr_to_kernel(sr->addr, sr->sendto_addr_len,
>>> +					  &address);
>>> +		if (unlikely(ret < 0))
>>> +			goto fail;
>>> +		msg.msg_name = (struct sockaddr *) &address;
>>> +		msg.msg_namelen = sr->sendto_addr_len;
>>> +	} else {
>>> +		msg.msg_name = NULL;
>>> +		msg.msg_namelen = 0;
>>> +	}
>>>  
>>>  	flags = req->sr_msg.msg_flags;
>>>  	if (issue_flags & IO_URING_F_NONBLOCK)
>>> @@ -5309,6 +5353,7 @@ static int io_sendto(struct io_kiocb *req, unsigned int issue_flags)
>>>  			return -EAGAIN;
>>>  		if (ret == -ERESTARTSYS)
>>>  			ret = -EINTR;
>>> +	fail:
>>>  		req_set_fail(req);
>>
>> I think there is a problem with "fail" goto statement. Not getting
>> full clarity on this change. With latest kernel, I see
>> req_set_fail(req) inside if check, which I don't see here. Can you
>> please resend the patch on latest kernel version. Thanks.
> 
> I will send the v5 on top of "for-next" branch in Jens' tree soon.
> 
> That is already inside an "if check" anyway. We go to that label when
> the move_addr_to_kernel() fails (most of the time it is -EFAULT or
> -EINVAL).
> 
> That part looks like this (note the if check before the goto):
> ----------------------------------------------------------------------
> 	msg.msg_control = NULL;
> 	msg.msg_controllen = 0;
> 	if (sr->addr) {
> 		ret = move_addr_to_kernel(sr->addr, sr->sendto_addr_len,
> 					  &address);
> 		if (unlikely(ret < 0))
> 			goto fail;
> 		msg.msg_name = (struct sockaddr *) &address;
> 		msg.msg_namelen = sr->sendto_addr_len;
> 	} else {
> 		msg.msg_name = NULL;
> 		msg.msg_namelen = 0;
> 	}
> 
> 	flags = req->sr_msg.msg_flags;
> 	if (issue_flags & IO_URING_F_NONBLOCK)
> 		flags |= MSG_DONTWAIT;
> 	if (flags & MSG_WAITALL)
> 		min_ret = iov_iter_count(&msg.msg_iter);
> 
> 	msg.msg_flags = flags;
> 	ret = sock_sendmsg(sock, &msg);
> 	if (ret < min_ret) {
> 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
> 			return -EAGAIN;
> 		if (ret == -ERESTARTSYS)
> 			ret = -EINTR;
> 	fail:

Thanks for sending this. IMO this goto label should be just before the "if (ret < min_ret)" statement.

> 		req_set_fail(req);
> 	}
> 	__io_req_complete(req, issue_flags, ret, 0);
> 	return 0;
> ----------------------------------------------------------------------
> 
>>>  	}
>>>  	__io_req_complete(req, issue_flags, ret, 0);
>>> @@ -5427,13 +5472,25 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
>>>  		return -EINVAL;
>>>  
>>> +	/*
>>> +	 * For IORING_OP_RECV{,FROM}, the assignment to @sr->umsg
>>> +	 * is equivalent to an assignment to @sr->buf.
>>> +	 */
>>>  	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
>>> +
>>>  	sr->len = READ_ONCE(sqe->len);
>>>  	sr->bgid = READ_ONCE(sqe->buf_group);
>>>  	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
>>>  	if (sr->msg_flags & MSG_DONTWAIT)
>>>  		req->flags |= REQ_F_NOWAIT;
>>>  
>>> +	if (req->opcode == IORING_OP_RECVFROM) {
>>> +		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
>>> +		sr->recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr3));
>>> +	} else {
>>> +		sr->addr = (struct sockaddr __user *) NULL;
>>
>> I think recvfrom_addr_len should also be pointed to NULL, instead of
>> garbage for this case.
> 
> Will do in the RFC v5.
> 
>>
>>> +	}
>>> +
>>>  #ifdef CONFIG_COMPAT
>>>  	if (req->ctx->compat)
>>>  		sr->msg_flags |= MSG_CMSG_COMPAT;
>>> @@ -5509,6 +5566,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>>>  	struct iovec iov;
>>>  	unsigned flags;
>>>  	int ret, min_ret = 0;
>>> +	struct sockaddr_storage address;
>>>  	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>  
>>>  	sock = sock_from_file(req->file);
>>> @@ -5526,7 +5584,7 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>>>  	if (unlikely(ret))
>>>  		goto out_free;
>>>  
>>> -	msg.msg_name = NULL;
>>> +	msg.msg_name = sr->addr ? (struct sockaddr *) &address : NULL;
>>>  	msg.msg_control = NULL;
>>>  	msg.msg_controllen = 0;
>>>  	msg.msg_namelen = 0;
>>
>> I think namelen should also be updated ?
> 
> It doesn't have to be updated. From net/socket.c there is a comment
> like this:
> 
> 	/* We assume all kernel code knows the size of sockaddr_storage */
> 	msg.msg_namelen = 0;
> 
> Full __sys_recvfrom() source code, see here:
> https://github.com/torvalds/linux/blob/v5.16-rc8/net/socket.c#L2085-L2088
> 
> I will add the same comment in next series to clarify this one.
> 
>>
>>> @@ -5540,6 +5598,16 @@ static int io_recvfrom(struct io_kiocb *req, unsigned int issue_flags)
>>>  		min_ret = iov_iter_count(&msg.msg_iter);
>>>  
>>>  	ret = sock_recvmsg(sock, &msg, flags);
>>> +
>>> +	if (ret >= 0 && sr->addr != NULL) {
>>> +		int tmp;
>>> +
>>> +		tmp = move_addr_to_user(&address, msg.msg_namelen, sr->addr,
>>> +					sr->recvfrom_addr_len);
>>> +		if (unlikely(tmp < 0))
>>> +			ret = tmp;
>>> +	}
>>> +
>>>  out_free:
>>>  	if (ret < min_ret) {
>>>  		if (ret == -EAGAIN && force_nonblock)
>>> @@ -6778,9 +6846,11 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>  	case IORING_OP_SYNC_FILE_RANGE:
>>>  		return io_sfr_prep(req, sqe);
>>>  	case IORING_OP_SENDMSG:
>>> +	case IORING_OP_SENDTO:
>>>  	case IORING_OP_SEND:
>>>  		return io_sendmsg_prep(req, sqe);
>>>  	case IORING_OP_RECVMSG:
>>> +	case IORING_OP_RECVFROM:
>>>  	case IORING_OP_RECV:
>>>  		return io_recvmsg_prep(req, sqe);
>>>  	case IORING_OP_CONNECT:
>>> @@ -7060,12 +7130,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>>  	case IORING_OP_SENDMSG:
>>>  		ret = io_sendmsg(req, issue_flags);
>>>  		break;
>>> +	case IORING_OP_SENDTO:
>>>  	case IORING_OP_SEND:
>>>  		ret = io_sendto(req, issue_flags);
>>>  		break;
>>>  	case IORING_OP_RECVMSG:
>>>  		ret = io_recvmsg(req, issue_flags);
>>>  		break;
>>> +	case IORING_OP_RECVFROM:
>>>  	case IORING_OP_RECV:
>>>  		ret = io_recvfrom(req, issue_flags);
>>>  		break;
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index efc7ac9b3a6b..a360069d1e8e 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -150,6 +150,8 @@ enum {
>>>  	IORING_OP_SETXATTR,
>>>  	IORING_OP_FGETXATTR,
>>>  	IORING_OP_GETXATTR,
>>> +	IORING_OP_SENDTO,
>>> +	IORING_OP_RECVFROM,
>>>  
>>>  	/* this goes last, obviously */
>>>  	IORING_OP_LAST,
>>
>>
>> Regards,
>>
>> ~Praveen.
>>
> 
> Thanks for the review. I will send the RFC v5 soon.
> 

