Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B7A421DD5
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 07:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhJEFPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 01:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhJEFO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 01:14:59 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B96C061745;
        Mon,  4 Oct 2021 22:13:09 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v19so13183742pjh.2;
        Mon, 04 Oct 2021 22:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U5yN7pAzjpU0stxPyweIcQkHnN3qFNaQQ8UMF8LaTQw=;
        b=NnHQS67YIGqPf1JEQpORUXpH9bpni8ZjjpSeOIo5cQAs6UNYU6FAIgk84SmshCbh46
         HpFnZX/J1uZtG8ruiE/iqZeUxnuJyzSJ/XqR6JNeKp+v9hQZY2S2mEE7VNUziqY7BNLS
         Lvn0gaZsntrTumxAxtMtW+lPvx0sOkk+Lpul806gLoAd+/kJJl50VPekyS6tAZLP+zzv
         NB+7dYnas+b0Bm1RBFc1yaRwylNTH9L5tX3qnNw3W/Kr+duxvmftlYpe+EPrjMpWeWvg
         XMHKULN84RWdl8ucU1pqhpoCOZJ0tYDXYLHDq2GSfpYfwmsR7C83uUm1cllAwBkeq96K
         RnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U5yN7pAzjpU0stxPyweIcQkHnN3qFNaQQ8UMF8LaTQw=;
        b=eSJVXVrz7FC8SPYchrktwKw0podk8pUnOJUw9BJ+eC+ym0CLh9fGSjai0QYo4c9RhL
         JRwKhCEkiJ/qhNDYtw0ZNVZ79ajQdZrxq1E0U7rpbYyMUGd/VEjB27LGMq7ZnAqKsLc2
         +jFL7IiCv24dckjRR4CfXG6ZQi0tt0CnVtkdUAjKn5NxaJNTxwGQsugV63eI641i0Hgs
         asKMguwsQC1wC3PQQ8BIP66yG4RYD15zLSN+7SM59H/J8BeiERWr5JVbb/HzQz5TL9ks
         m7YylGybCAgrMtq/XBzGeROaLPmeO+OX/i5X/JZdmtmQYHwfHchF/E6Pf10W8ktFokTb
         gyIg==
X-Gm-Message-State: AOAM533ttq65PiN799DZL6qwF0KypC02F3zAKMde9h8vK/3kbCZ2JOAs
        a5CbPIn5l9bPky8dyQPzjgERc9l/Eho=
X-Google-Smtp-Source: ABdhPJyNdts7bI/1dIDJ0zeQHksIpWkBRRATXOG4hk1DYCgz3yTuGiDt91qfJ48mZlXsxbZt3BxbXw==
X-Received: by 2002:a17:90a:4e:: with SMTP id 14mr1402358pjb.180.1633410789022;
        Mon, 04 Oct 2021 22:13:09 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:413d])
        by smtp.gmail.com with ESMTPSA id o1sm282164pjs.52.2021.10.04.22.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 22:13:08 -0700 (PDT)
Date:   Mon, 4 Oct 2021 22:13:06 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Burton <jevburton.kernel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: Re: [RFC PATCH v2 00/13] Introduce BPF map tracing capability
Message-ID: <20211005051306.4zbdqo3rnecj3hyv@ast-mbp>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 11:58:57PM +0000, Joe Burton wrote:
> From: Joe Burton <jevburton@google.com>
> 
> This patch introduces 'map tracing': the capability to execute a
> tracing program after updating a map.
> 
> Map tracing enables upgrades of stateful programs with fewer race
> conditions than otherwise possible. We use a tracing program to
> imbue a map with copy-on-write semantics, then use an iterator to
> perform a bulk copy of data in the map. After bulk copying concludes,
> updates to that map automatically propagate via the tracing
> program, avoiding a class of race conditions. This use case is
> demonstrated in the new 'real_world_example' selftest.
> 
> Extend BPF_PROG_TYPE_TRACING with a new attach type, BPF_TRACE_MAP,
> and allow linking these programs to arbitrary maps.
> 
> Extend the verifier to invoke helper calls directly after
> bpf_map_update_elem() and bpf_map_delete_elem(). The helpers have the
> exact same signature as the functions they trace, and simply pass those
> arguments to the list of tracing programs attached to the map.

It's a neat idea to user verifier powers for this job,
but I wonder why simple tracepoint in map ops was not used instead?
With BTF the bpf progs see the actual types of raw tracepoints.
If tracepoint has map, key, value pointers the prog will be able
to access them in read-only mode.
Such map pointer will be PTR_TO_BTF_ID, so the prog won't be able
to recursively do lookup/update on this map pointer,
but that's what you need anyway, right?
If not we can extend this part of the tracepoint/verifier.

Instead of tracepoint it could have been an empty noinline function
and fentry/fexit would see all arguments as well.

> One open question is how to handle pointer-based map updates. For
> example:
>   int *x = bpf_map_lookup_elem(...);
>   if (...) *x++;
>   if (...) *x--;
> We can't just call a helper function right after the
> bpf_map_lookup_elem(), since the updates occur later on. We also can't
> determine where the last modification to the pointer occurs, due to
> branch instructions. I would therefore consider a pattern where we
> 'flush' pointers at the end of a BPF program:
>   int *x = bpf_map_lookup_elem(...);
>   ...
>   /* Execute tracing programs for this cell in this map. */
>   bpf_map_trace_pointer_update(x);
>   return 0;
> We can't necessarily do this in the verifier, since 'x' may no
> longer be in a register or on the stack. Thus we might introduce a
> helper to save pointers that should be flushed, then flush all
> registered pointers at every exit point:
>   int *x = bpf_map_lookup_elem(...);
>   /*
>    * Saves 'x' somewhere in kernel memory. Does nothing if no
>    * corresponding tracing progs are attached to the map.
>    */
>   bpf_map_trace_register_pointer(x);
>   ...
>   /* flush all registered pointers */
>   bpf_map_trace_pointer_update();
>   return 0;
> This should be easy to implement in the verifier.

I don't think the "solution" for lookup operation is worth pursuing.
The bpf prog that needs this map tracing is completely in your control.
So just don't do writes after lookup.

> In addition, we use the verifier to instrument certain map update
> calls. This requires saving arguments onto the stack, which means that
> a program using MAX_BPF_STACK bytes of stack could exceed the limit.
> I don't know whether this actually causes any problems.

Extra 8*4 bytes of stack is not a deal breaker.
