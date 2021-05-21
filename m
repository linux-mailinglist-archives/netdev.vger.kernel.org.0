Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88C38C338
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 11:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbhEUJfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 05:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhEUJfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 05:35:24 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC57AC061574;
        Fri, 21 May 2021 02:34:00 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d11so20348503wrw.8;
        Fri, 21 May 2021 02:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=imeCbusdpJ8n4ZoOyUiUylLuf21SNxjoYsk0+9mvpX8=;
        b=ov8OOZbvhaT7oXctO9aUDR0w6cl67+mD52rMqgqC+qkb4SpIptFivLQ9NrJ5PT5hkV
         a9bsRKpn/f6/5h/NJMf1cEmpvVSNK6PGfqtRbba/yWf6MQAgj5EMZ7EHMSaC0xtuitiu
         1WGDR/pg7NpTg6JcmbPxbnGnuJWX0A+4ZM9VUpaSvDOBeJBvcxXo9EimnNw3CDDwkKcu
         WNCV53VRtIWLGzSChSbdS+xruU1qquVqdZDJOv4SFh+KZCo4mWsBJJ3jmuawf+aW6VAZ
         M4sYMduI9WVU2PdHeDdJz/v8yUiEPq04WSPkipiSC490pREnCMcDkySmQU62O1uEw2J9
         u4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=imeCbusdpJ8n4ZoOyUiUylLuf21SNxjoYsk0+9mvpX8=;
        b=qAhr2fetPRuWGpf4HHJE9HVTa0MxGRdgV1kva3z0AI7RfRwlTPuR+/XSNMf3EYxcdS
         nPHmVpYPMrqAwcQq09b8Q2gPsa9RH8q8ovD9AXJ90Im6b7kBvMd7ZSDCEVAbbCRURv7A
         eKjhxlPySurxS9TZ+3ndvYs/yhl5x+FKzm4S//XO2Tq7e0YFUm2tVa7xtMuEUhtYj7yx
         UV5a0ztQOqRGKZ3HYrol5RKWvKrB00apx3Tlzi/rydbtZbEBfhbqEo3d+mpnKnqj4Q7Y
         mtnZlsYWggZmP6nRG8D4Y/rQvdBB9cmrIBkZPAJ7yAKrYpLhksXHoF/Ly1VQAstMjPF8
         P3Tw==
X-Gm-Message-State: AOAM533+XzNCDOmM1Q3J4HewB2uAf2E4RGGBrJ5B+j1eBPouw73nrFmO
        TyjNAYDGBDJJUkJrvIUnttrMy4dVl1O9gc0jnrQ=
X-Google-Smtp-Source: ABdhPJzuO7pAw76NCPCBzlt+kNUCh9XZZ7T+7qLd29OuyC1fRjNYDvzgD2Z3dSe7CCgyQMXJhorLzw==
X-Received: by 2002:adf:f751:: with SMTP id z17mr8525694wrp.150.1621589639610;
        Fri, 21 May 2021 02:33:59 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id x13sm1448649wro.31.2021.05.21.02.33.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 02:33:59 -0700 (PDT)
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
References: <cover.1621424513.git.asml.silence@gmail.com>
 <8ec8373d406d1fcb41719e641799dcc5c0455db3.1621424513.git.asml.silence@gmail.com>
 <20210521010752.lky4pz7zipefrfr7@ast-mbp>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 15/23] io_uring: enable BPF to submit SQEs
Message-ID: <a5cc80c8-5dea-031f-703e-cc18d6625ad6@gmail.com>
Date:   Fri, 21 May 2021 10:33:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210521010752.lky4pz7zipefrfr7@ast-mbp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 2:07 AM, Alexei Starovoitov wrote:
> On Wed, May 19, 2021 at 03:13:26PM +0100, Pavel Begunkov wrote:
>>  
>> +BPF_CALL_3(io_bpf_queue_sqe, struct io_bpf_ctx *,		bpf_ctx,
>> +			     const struct io_uring_sqe *,	sqe,
>> +			     u32,				sqe_len)
>> +{
>> +	struct io_ring_ctx *ctx = bpf_ctx->ctx;
>> +	struct io_kiocb *req;
>> +
>> +	if (sqe_len != sizeof(struct io_uring_sqe))
>> +		return -EINVAL;
>> +
>> +	req = io_alloc_req(ctx);
> 
> that is GFP_KERNEL allocation.
> It's only allowed from sleepable bpf progs and further down
> there is a correct check for it, so all good.
> But submitting sqe is a fundemntal io_uring operation,
> so what is the use case for non-sleepable?
> In other words why bother? Allow sleepable only and simplify the code?

Actual submission may be moved out of BPF, so enabling it for both, but
the question I wonder about is what are the plans for sleepable
programs? E.g. if it's a marginal features much limited in
functionality, e.g. iirc as it's not allowed to use some BPF data
types, it may not worth doing.

> 
>> +	if (unlikely(!req))
>> +		return -ENOMEM;
>> +	if (!percpu_ref_tryget_many(&ctx->refs, 1)) {
>> +		kmem_cache_free(req_cachep, req);
>> +		return -EAGAIN;
>> +	}
>> +	percpu_counter_add(&current->io_uring->inflight, 1);
>> +	refcount_add(1, &current->usage);
>> +
>> +	/* returns number of submitted SQEs or an error */
>> +	return !io_submit_sqe(ctx, req, sqe);
> 
> A buggy bpf prog will be able to pass junk sizeof(struct io_uring_sqe)
> as 'sqe' here.
> What kind of validation io_submit_sqe() does to avoid crashing the kernel?

It works on memory rw shared with userspace, so it already assumes
the worst
 
> General comments that apply to all patches:
> - commit logs are way too terse. Pls expand with details.
> - describe new bpf helpers in comments in bpf.h. Just adding them to an enum is not enough.
> - selftest/bpf are mandatory for all new bpf features.
> - consider bpf_link style of attaching bpf progs. We had enough issues with progs
>   that get stuck due to application bugs. Auto-detach saves the day more often than not.

Thanks for taking a look! I have no idea what bpf_link is, need
to check it out

-- 
Pavel Begunkov
