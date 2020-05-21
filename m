Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A941DD203
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 17:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEUPhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 11:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgEUPhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 11:37:33 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767A6C061A0E;
        Thu, 21 May 2020 08:37:33 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id p4so3237046qvr.10;
        Thu, 21 May 2020 08:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W0srFBoV+cvF6vEsz7+qpgvyMaMTlwfBwvV9plBhvrw=;
        b=kp/lTn/w2Vk4bzuNOWy1ikgyCX5gSpqWJoebfcUyQ/G2dBjihqxLjyUNZWQpKzkBKf
         eFPcncJKyMSyPh2DgINQ6MzVJiba7jgbxs9gVoU/BG6eoYbVAWdbzMbnMctil7nydJCk
         9z43exIGRN0PY9RQdxGlnsNYEkpot1yT5AClLUGlM4Qqz/d9HVPJLC0eEuz9E1HWcY8N
         DXKkbhEBZl1jLwyDgNq8nX/j+uuLhhxw/3fZHEJybkzV3xzDpQx8EXHiFcPZJhTpDfhe
         5ulI0IxgeB6yWRLVZ1hIA+v/jPYYgSnEuilP9UeGgLeGmXwekTQdY+SGrU80Hf1iwtCf
         UOFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W0srFBoV+cvF6vEsz7+qpgvyMaMTlwfBwvV9plBhvrw=;
        b=Bxw6v5HM3Ug6tscGLpW056FRYKuc9aruljVRvz+EEFA4tZhnBH5sGpjSc17MI3Modq
         IuY9sH3Wb0m40bRLg3BlWkQwaw/j0DVj3G3+Ske6gNYvAMBSKeI7VIwC+4PlwUG/wbcP
         YiAlKe730lZt9V7JSWMBUTuxSEZFJ3kv96cqBHvWvmrwjejv8lEJW4li6Rco7HA53mMH
         oxWEHrITR9ijW/drlwgMuuLMw/zjd57CKRVFeWU39FQVlGvx4VVuwoExGn7wOdtLa86d
         ajqbWj7HepdpOYXMg9A+IOqf6WC4eByl8hewVlMSXa6oJ4w7Y/rCLHvOzmxb7jwLB28K
         qmeA==
X-Gm-Message-State: AOAM532TqF8T9qANX66wTrNAZwISaBYWCqAjc2bETSD/pLTNv+Lollt6
        DGRxHYvAehEDU8GCxTfydkqJfayXo8BPPw==
X-Google-Smtp-Source: ABdhPJyXo+SPJ+3nnTpP5Q6dsWvK/UPjFHjCdo7+FZ8/hjRU6mfkzE31qSCSq1qu5jXnAsmN2rBG8Q==
X-Received: by 2002:a05:6214:1543:: with SMTP id t3mr10961112qvw.122.1590075452483;
        Thu, 21 May 2020 08:37:32 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id k3sm5118461qkb.112.2020.05.21.08.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 08:37:31 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 44A40C0BEB; Thu, 21 May 2020 12:37:29 -0300 (-03)
Date:   Thu, 21 May 2020 12:37:29 -0300
From:   'Marcelo Ricardo Leitner' <marcelo.leitner@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH net-next] sctp: Pull the user copies out of the
 individual sockopt functions.
Message-ID: <20200521153729.GB74252@localhost.localdomain>
References: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd94b5e41a7c4edc8f743c56a04ed2c9@AcuMS.aculab.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 03:08:13PM +0000, David Laight wrote:

I wish we could split this patch into multiple ones. Like, one for
each sockopt, but it doesn't seem possible. It's tough to traverse
trough 5k lines long patch. :-(

> Since SCTP rather abuses getsockopt() to perform operations and uses
> the user buffer to select the association to get values from
> the sctp_getsockopt() has to do a Read-Modify-Write on the user buffer.
> 
> An on-stack buffer is used for short requests this allows the length
> check for simple getsockopt requests to be done by the wrapper.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>
> 
> --
> 
> While this patch might make it easier to export the functionality
> to other kernel modules, it doesn't make that change.
> 
> Only SCTP_SOCKOPT_CONNECTX3 contains an indirect pointer.
> It is also the only getsockopt() that wants to return a buffer
> and an error code. It is also definitely abusing getsockopt().

It should have been a linear buffer. The secondary __user access is
way worse than having the application to do another allocation. But
too late..

> 
> The SCTP_SOCKOPT_PEELOFF getsockopt() (another abuse) also wants to
> return a positive value and a buffer (containing the same value) on
> success.

Unnecessary, agree, but too late for changing that.

> 
> Both these stop the sctp_getsockopt_xxx() functions returning
> 'error or length'.
> 
> There is also real fubar of SCTP_GET_LOCAL_ADDRS which has to
> return the wrong length 'for historic compatibility'.
> Although I'm not sure how portable that makes applications.
> 
> Reduces the code by about 800 lines and 8k bytes (x86-64).
> Most of the changed lines are replacing x.y with x->y and
> simplifying error paths.

This cleanup is something that I've been longing for a while now.
Avoiding these repetitive user space handling is very welcomed.
Also, I think this is pretty much aligned with Christoph's goal as
well and can make the patches in his series easier/cleaner.

Other than the comments here, this patch LGTM.

> 
> Passes 'sparse' and at least some options work.

Assuming a v2 is coming, to appease the buildbot :)

...
> +static int sctp_setsockopt(struct sock *sk, int level, int optname,
> +			   char __user *u_optval, unsigned int optlen)
> +{
> +	u64 param_buf[8];
> +	int retval = 0;
> +	void *optval;
> +
> +	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
> +
> +	/* I can hardly begin to describe how wrong this is.  This is
> +	 * so broken as to be worse than useless.  The API draft
> +	 * REALLY is NOT helpful here...  I am not convinced that the
> +	 * semantics of setsockopt() with a level OTHER THAN SOL_SCTP
> +	 * are at all well-founded.
> +	 */
> +	if (level != SOL_SCTP) {
> +		struct sctp_af *af = sctp_sk(sk)->pf->af;
> +		return af->setsockopt(sk, level, optname, u_optval, optlen);
> +	}
> +
> +	if (optlen < sizeof (param_buf)) {
> +		if (copy_from_user(&param_buf, u_optval, optlen))
> +			return -EFAULT;
> +		optval = param_buf;
> +	} else {
> +		if (optlen > USHRT_MAX)
> +			optlen = USHRT_MAX;

There are functions that can work with and expect buffers larger than
that, such as sctp_setsockopt_auth_key:
@@ -3693,10 +3588,6 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 	 */
 	optlen = min_t(unsigned int, optlen, USHRT_MAX + sizeof(*authkey));

and sctp_setsockopt_reset_streams:
        /* srs_number_streams is u16, so optlen can't be bigger than this. */
        optlen = min_t(unsigned int, optlen, USHRT_MAX +
                                             sizeof(__u16) * sizeof(*params));

Need to cope with those here.

> +		optval = memdup_user(u_optval, optlen);
> +		if (IS_ERR(optval))
> +			return PTR_ERR(optval);
> +	}
> +
> +	retval = kernel_sctp_setsockopt(sk, optname, optval, optlen);
> +	if (optval != param_buf)
> +		kfree(optval);
> +
>  	return retval;
>  }
>  
...
> +static int sctp_getsockopt(struct sock *sk, int level, int optname,
> +			   char __user *u_optval, int __user *u_optlen)
> +{
> +	u64 param_buf[8];
> +	int retval = 0;
> +	void *optval;
> +	int len, optlen;
> +
> +	pr_debug("%s: sk:%p, optname:%d\n", __func__, sk, optname);
> +
> +	/* I can hardly begin to describe how wrong this is.  This is
> +	 * so broken as to be worse than useless.  The API draft
> +	 * REALLY is NOT helpful here...  I am not convinced that the
> +	 * semantics of getsockopt() with a level OTHER THAN SOL_SCTP
> +	 * are at all well-founded.
> +	 */
> +	if (level != SOL_SCTP) {
> +		struct sctp_af *af = sctp_sk(sk)->pf->af;
> +
> +		retval = af->getsockopt(sk, level, optname, u_optval, u_optlen);
> +		return retval;
> +	}
> +
> +	if (get_user(len, u_optlen))
> +		return -EFAULT;
> +
> +	if (len < 0)
> +		return -EINVAL;
> +
> +	/* Many options are RMW so we must read in the user buffer.
> +	 * For safetly we need to initialise it to avoid leaking
> +	 * kernel data - the copy does this as well.
> +	 * To simplify the processing of simple options the buffer length
> +	 * check is repeated after the request is actioned.
> +	 */
> +	if (len < sizeof (param_buf)) {
> +		/* Zero first bytes to stop KASAN complaining. */
> +		param_buf[0] = 0;
> +		if (copy_from_user(&param_buf, u_optval, len))
> +			return -EFAULT;
> +		optval = param_buf;
> +	} else {
> +		if (len > USHRT_MAX)
> +			len = USHRT_MAX;

This limit is not present today for sctp_getsockopt_local_addrs()
calls (there may be others).  As is, it will limit it and may mean
that it can't dump all addresses.  We have discussed this and didn't
come to a conclusion on what is a safe limit to use here, at least not
on that time.
