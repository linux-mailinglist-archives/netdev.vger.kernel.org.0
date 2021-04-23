Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A0369D34
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhDWXRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhDWXRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:17:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042D2C061574;
        Fri, 23 Apr 2021 16:16:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nk8so10702439pjb.3;
        Fri, 23 Apr 2021 16:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PVq++V0MwpK7bbM6rQxN4JsPfV1zGlBbHrHQNxX5sZA=;
        b=Mxr4iMH8H5ggi7xOag8R6+BfPQt4bsk5E8i8jP+qDs8Nuk3884bNWnrMV7hyV4Ew/j
         Dxi7VbDenUVUl9egorTD4opYTtqR77ktQzjap6fUcdRERIeIfeS0mYCNiAqUf0MGkP99
         yzBbUbCQ8R8fevsZPIFz3n3SxU6L9B79jCHLNadm7gEQVc1/qM86w1krZ8usNPYAYMoz
         wY/jUrci467s6LYqw1RAm9ha1M1tnJHXjf/naIQl3Z3ssN+MY2MzBYy8HzjPXx9cUm9+
         CYH4+7/EBzzf0a594IHInWCjCnMh83N3jlwE4/4/v8AWLW/t5IxwKcB8Xe7+HNSqQhZd
         v3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PVq++V0MwpK7bbM6rQxN4JsPfV1zGlBbHrHQNxX5sZA=;
        b=RUgk4xupe4IEuDa2FVWt6QSW/MsljHaWpPK6FwAXeK5s0/SFx8ey+d5rRbdzJQ6pGo
         0Yxv2P50n/YdEbTFF3zgt/sbBQgxjwNoKuQONCV2/o/VWUnhmZ89gKgFLYyXTrQ/UzCZ
         X61M24sCP/EE4XDa4ZYvlIO9mFKLhQHkZ9wqJOzy7mMNHFYxxTALwUxMsy40Xpn725Xx
         9sjxKPpTIQIHEG/v1j8Xz6vzockYsBtQrgQuweCZ3zzNtCf+OY430PKENc6rST8Dz0NV
         j0NVmfyZ7GS+pbCYcubtj5wFbl6HFjjm6944Xc0k8UWVt+LSj37pmTGt6BIg3VP1aMsx
         1ZWQ==
X-Gm-Message-State: AOAM531BA576Z+dTiWwNQuimp+rOjvSKX5k+YTOeiMNS79r8ELM3kvUH
        HRgGgMn2nbePAgQnH7ierQaRkgE67QM=
X-Google-Smtp-Source: ABdhPJxQqrOi4Tu8ILJrR5ZSQieTu1HFlFamhWRDWnS6G69CaWbPSR0m8y2uQVfGf+RucVHVO/tADQ==
X-Received: by 2002:a17:90a:950c:: with SMTP id t12mr8200273pjo.135.1619219805472;
        Fri, 23 Apr 2021 16:16:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:a88])
        by smtp.gmail.com with ESMTPSA id p10sm5219339pfo.210.2021.04.23.16.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 16:16:44 -0700 (PDT)
Date:   Fri, 23 Apr 2021 16:16:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 00/16] bpf: syscall program, FD array, loader
 program, light skeleton.
Message-ID: <20210423231642.tbypsaxqurjnjqts@ast-mbp.dhcp.thefacebook.com>
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <4142514b-3a0f-f931-9a8c-fb72be9c66b3@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4142514b-3a0f-f931-9a8c-fb72be9c66b3@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 02:36:43PM -0700, Yonghong Song wrote:
> > 
> > One thing that was not addressed from feedback is the name of new program type.
> > Currently it's still:
> > BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> 
> Do you have plan for other non-bpf syscalls? Maybe use the name
> BPF_PROG_TYPE_BPF_SYSCALL? It will be really clear this is
> the program type you can execute bpf syscalls.

In this patch set it's already doing sys_bpf and sys_close syscalls :)

> > 
> > The concern raised was that it sounds like a program that should be attached
> > to a syscall. Like BPF_PROG_TYPE_KPROBE is used to process kprobes.
> > I've considered and rejected:
> > BPF_PROG_TYPE_USER - too generic
> > BPF_PROG_TYPE_USERCTX - ambiguous with uprobes
> 
> USERCTX probably not a good choice. People can write a program without
> context and put the ctx into a map and use it.
> 
> > BPF_PROG_TYPE_LOADER - ok-ish, but imo TYPE_SYSCALL is cleaner.
> 
> User can write a program to do more than loading although I am not sure
> how useful it is compared to implementation in user space.

Exactly.
Just BPF_PROG_TYPE_SYSCALL alone can be used as more generic equivalent
to sys_close_range syscalls.
If somebody needs to close a sparse set of FDs or get fd_to_be_closed
from a map they can craft a bpf prog that would do that.
Or if somebody wants to do a batched map processing...
instead of doing sys_bpf() with BPF_MAP_UPDATE_BATCH they can craft
a bpf prog.
Plenty of use cases beyond LOADER.

This patch set only allows BPF_PROG_TYPE_SYSCALL to be executed
via prog_test_run, but I think it's safe to execute it upon entry
to pretty much any syscall.
So _SYSCALL suffix fits as both "a program that can execute syscalls"
and as "a program that attaches to syscalls".
The later is not implemented yet, but would fit right in.
