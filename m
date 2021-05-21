Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD738BB47
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 03:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhEUBJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 21:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235398AbhEUBJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 21:09:19 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EBCC061574;
        Thu, 20 May 2021 18:07:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso5635583pjq.3;
        Thu, 20 May 2021 18:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Oa6hJMFzuFqCtQAZfwRNzxo5sbxFFXAhEkw/QR9r+Mk=;
        b=nrwHLxEacwqdNOhGw3z0aoEN8LXPfGaDDPdwOYD34CBAJ51Nui7G7f7/mtTKRPItHc
         YiEY9PZ8Gg8LUHp3Lp8fnE6JXtmLxQa2S0Xcn+75TwibiSjT5umNgZdkxixd1+lJWXHR
         0Of5dGcuVdmaWniyq51beWrf2tjYTGxUGejTyKjwv5t9biCA+3URvf339fbjTDJUwSWy
         RPSjAX7sLVK6ftnmjgofIcLbm+4F67M0eZVZWpfViY5qEHB+2eKo45h3oRQYBtAMNYkn
         ne454b2dEjrSkq9FBd6/mZlQiBDNBNG0NDgcc+leeWqk2vumD7dzSIpBt6PXwa0GpT0l
         LnGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Oa6hJMFzuFqCtQAZfwRNzxo5sbxFFXAhEkw/QR9r+Mk=;
        b=Kubf6GfDEBN/60KBFGRSPwdkvKw0aCRicmWZjJZd2ABpKfV+4YADXaGio6K/GvayIy
         9ueGmg1OdjxgEeA3liJtANbYDM6fkai4wPlTLk5PZe5SqC3YsDLUZlwdSjYiU9K2iVPI
         /zOBe9UyoA6LUBXZayaBvR3pG47HsA5lFZZMa9wGZFUFRozVTjDgNQyCUHe8F3Suo0Uv
         CGUy011VDn0OIeDBB4zEu64jv+XbvNlMsxm3q7lwThdjG5NXxU0omb2Ju2A9KpmmpxfX
         ytw6v8KsaevRzytgLuqqC+pHios6lPnd2UtHgmv2LASXp/yv63aezHdxXNvFr3vL4Qdl
         8CfQ==
X-Gm-Message-State: AOAM530Cj98EAjGtFjoH/bt3lkoxBeUqeY24npScvngpz35GkrYTprt7
        B5q8NtVukhGal4tT0koKP1o=
X-Google-Smtp-Source: ABdhPJz2ZjiO+mSkoD9oLIHAWomO95cyzkEKJfFxffCO8QRn5YF8CxDewxV2E+XpDVRJ3BXgCu0Bbg==
X-Received: by 2002:a17:902:f291:b029:f0:ba5b:5c47 with SMTP id k17-20020a170902f291b02900f0ba5b5c47mr9251659plc.41.1621559277033;
        Thu, 20 May 2021 18:07:57 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:3fe2])
        by smtp.gmail.com with ESMTPSA id v15sm2824411pfm.187.2021.05.20.18.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 18:07:56 -0700 (PDT)
Date:   Thu, 20 May 2021 18:07:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: Re: [PATCH 15/23] io_uring: enable BPF to submit SQEs
Message-ID: <20210521010752.lky4pz7zipefrfr7@ast-mbp>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <8ec8373d406d1fcb41719e641799dcc5c0455db3.1621424513.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ec8373d406d1fcb41719e641799dcc5c0455db3.1621424513.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 03:13:26PM +0100, Pavel Begunkov wrote:
>  
> +BPF_CALL_3(io_bpf_queue_sqe, struct io_bpf_ctx *,		bpf_ctx,
> +			     const struct io_uring_sqe *,	sqe,
> +			     u32,				sqe_len)
> +{
> +	struct io_ring_ctx *ctx = bpf_ctx->ctx;
> +	struct io_kiocb *req;
> +
> +	if (sqe_len != sizeof(struct io_uring_sqe))
> +		return -EINVAL;
> +
> +	req = io_alloc_req(ctx);

that is GFP_KERNEL allocation.
It's only allowed from sleepable bpf progs and further down
there is a correct check for it, so all good.
But submitting sqe is a fundemntal io_uring operation,
so what is the use case for non-sleepable?
In other words why bother? Allow sleepable only and simplify the code?

> +	if (unlikely(!req))
> +		return -ENOMEM;
> +	if (!percpu_ref_tryget_many(&ctx->refs, 1)) {
> +		kmem_cache_free(req_cachep, req);
> +		return -EAGAIN;
> +	}
> +	percpu_counter_add(&current->io_uring->inflight, 1);
> +	refcount_add(1, &current->usage);
> +
> +	/* returns number of submitted SQEs or an error */
> +	return !io_submit_sqe(ctx, req, sqe);

A buggy bpf prog will be able to pass junk sizeof(struct io_uring_sqe)
as 'sqe' here.
What kind of validation io_submit_sqe() does to avoid crashing the kernel?

General comments that apply to all patches:
- commit logs are way too terse. Pls expand with details.
- describe new bpf helpers in comments in bpf.h. Just adding them to an enum is not enough.
- selftest/bpf are mandatory for all new bpf features.
- consider bpf_link style of attaching bpf progs. We had enough issues with progs
  that get stuck due to application bugs. Auto-detach saves the day more often than not.
