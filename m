Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A64276595
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIXBE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:04:58 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40417C0613CE;
        Wed, 23 Sep 2020 18:04:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so711768pjb.4;
        Wed, 23 Sep 2020 18:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=5pt2NuWQ2HcpSfDlU2zKGx0WWIQK0mu59zEvVgH8Rhw=;
        b=pXXGHC5bHRRgpMvQ9YR6j9BfjWtldyzSYZl+iyBAmXj4lPHYkc2E30ab84KOZ7sn0E
         wgOgwWDwHep98l6mn73gOqNmMFYeLtIBiFLQSiSZpl7z1+P9HRwUOJ6UvxRk6C1JHxBk
         N7bIlq+Odg1Acw2MNaBC3yndf9CNPGGbdU5EYxpqEjBjlGdCMoNVdsVy9nf4NSGnQzP0
         ugXJOdFUq9Qty6/jBkH6KYlVMCvRGNVal+MtLzjYNlFlxOt46NSv+VJI2+4mTnOEWC7Q
         9ShdQc2yItKCgVFPHNXEZtCeox9dBIUA+pKUPINxyd2mf3o4pITjmT6m3doJ07BYek7M
         pHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5pt2NuWQ2HcpSfDlU2zKGx0WWIQK0mu59zEvVgH8Rhw=;
        b=IYwkj7ftTsDB/+iXeahZBONRLboaAay8pQECMzWKvcVNzzjIzYZwL5KsOKqYZIMfHr
         EPDpbssgg+nFsjLLZGgUk9CeeJ4ToVOavX9gOt4Y4igmUKMjSq1IlgRVH4sH/XYSqmJQ
         B5lk73pbRVdln68CTkvAJ/M4tYP8C8Yx2f/Yd8o/gF0jCgPnWo3XFh7GPM+YjltwPy/G
         D7P0Hyq5LbaazOBDnobtLvQo7ZTNmbVwKxJToS0ZZhPXP8V7dYA0n5xnNftnG//IKH8h
         etJWbgL4OipoS8027mD3rYZcScWIY+sxtBmDJJM8IU8T3ayhmA5nHWqvsnnHfUgQ238E
         9o7A==
X-Gm-Message-State: AOAM532UBjmmbz9TVp9FNafebe3E/9OJc8jNVvMTzY2LSB4ceeQgto5Y
        XvBsDW3PBA/yYfD85HrAXq8=
X-Google-Smtp-Source: ABdhPJxdoXN2kiD4NVQLKT9BCxZvICqN/YMzsalnPFdKccL/14jTqe0DZkrGXAKod7SuN+FCSjl32Q==
X-Received: by 2002:a17:90a:e287:: with SMTP id d7mr1858411pjz.170.1600909497715;
        Wed, 23 Sep 2020 18:04:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1807])
        by smtp.gmail.com with ESMTPSA id d15sm795743pfo.85.2020.09.23.18.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 18:04:56 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:04:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v8 05/11] bpf: support attaching freplace
 programs to multiple attach points
Message-ID: <20200924010454.anythmtl53l3d3xv@ast-mbp.dhcp.thefacebook.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991915.8301.7262542368795622735.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160079991915.8301.7262542368795622735.stgit@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 08:38:39PM +0200, Toke Høiland-Jørgensen wrote:
> +
> +	if (tgt_prog_fd) {
> +		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
> +		if (prog->type != BPF_PROG_TYPE_EXT) {
> +			err = -EINVAL;
> +			goto out_put_prog;
> +		}
> +
> +		tgt_prog = bpf_prog_get(tgt_prog_fd);
> +		if (IS_ERR(tgt_prog)) {
> +			err = PTR_ERR(tgt_prog);
> +			tgt_prog = NULL;
> +			goto out_put_prog;
> +		}
> +
> +		key = ((u64)tgt_prog->aux->id) << 32 | btf_id;

key = bpf_trampoline_compute_key(tgt_prog, btf_id);
would be handy here.

> +	}
> +
>  	link = kzalloc(sizeof(*link), GFP_USER);
>  	if (!link) {
>  		err = -ENOMEM;
> @@ -2594,12 +2622,28 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>  
>  	mutex_lock(&prog->aux->tgt_mutex);
>  
> -	if (!prog->aux->tgt_trampoline) {
> +	if (!prog->aux->tgt_trampoline && !tgt_prog) {
>  		err = -ENOENT;
>  		goto out_unlock;
>  	}

Could you add a comment explaining all cases, since it's hard to follow right
now and few month later no one will remember.
As far as I understood:
prog->aux->dest_trampoline != NULL -> the program was just loaded and not attached to anything.
prog->aux->dest_trampoline == NULL -> the program was loaded and raw_tp_open-ed.
tgt_prog != NULL only when sepcifying tgt_prog_fd + target_btf_id in link_create api.
tgt_prog == NULL when this function is called from raw_tp_open.

Only the case of both NULL is invalid.

> -	tr = prog->aux->tgt_trampoline;
> -	tgt_prog = prog->aux->tgt_prog;
> +
> +	if (!prog->aux->tgt_trampoline ||
> +	    (key && key != prog->aux->tgt_trampoline->key)) {
> +
> +		err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
> +					      &fmodel, &addr, NULL, NULL);
> +		if (err)
> +			goto out_unlock;
> +
> +		tr = bpf_trampoline_get(key, (void *)addr, &fmodel);
> +		if (!tr) {
> +			err = -ENOMEM;
> +			goto out_unlock;
> +		}
> +	} else {

This 'else' is the case when a prog was loaded and _not_ raw_tp_open-ed
and the user is doing link_create with tgt_prog_fd + target_btf_id
into exactly the same place as attach_btf_id during load?
So this is the alternative api to raw_tp_open, right?
Please explain this in commit log and in comments.
It's not some minor detail.

> +		tr = prog->aux->tgt_trampoline;
> +		tgt_prog = prog->aux->tgt_prog;
> +	}
>  
>  	err = bpf_link_prime(&link->link, &link_primer);
>  	if (err)
> @@ -2614,16 +2658,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>  
>  	link->tgt_prog = tgt_prog;
>  	link->trampoline = tr;
> -
> -	prog->aux->tgt_prog = NULL;
> -	prog->aux->tgt_trampoline = NULL;
> +	if (tr == prog->aux->tgt_trampoline) {
> +		/* if we got a new ref from syscall, drop existing one from prog */
> +		if (tgt_prog_fd)
> +			bpf_prog_put(prog->aux->tgt_prog);
> +		prog->aux->tgt_trampoline = NULL;
> +		prog->aux->tgt_prog = NULL;
> +	}

What happens when the user did prog load with attach_btf_id into one tgt_prog
but then link_create into a different tgt_prog?
bpf_check_attach_target + bpf_trampoline_get will allocate new trampoline (potentially)
and tr != prog->aux->dest_trampoline,
so we won't trigger the above code.
prog->aux->dest_prog/dest_tramoline will still point to some prog.
Later raw_tp_open will succeed and prog will be attached to two places.
I would probably make it unconditional that both raw_tp_open
and link_create clear dest_prog/dest_trampoline, but can be convinced otherwise.
What use case do you have in mind to allow that?
Anyway it needs to be documented and tests written.

> +		if ((prog->aux->tgt_prog_type &&
> +		     prog->aux->tgt_prog_type != tgt_prog->type) ||
> +		    (prog->aux->tgt_attach_type &&
> +		     prog->aux->tgt_attach_type != tgt_prog->expected_attach_type))
> +			return -EINVAL;

May be call them saved_tgt_prog_type and saved_tgt_attach_type ?
Since that's another variant of 'target' meaning. Here the prog type survives
the target prog, since it will be still valid even when the first prog it was
attached to will be unloaded.
