Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47472200E3
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 01:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgGNXLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 19:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNXLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 19:11:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6C7C061755;
        Tue, 14 Jul 2020 16:11:38 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 207so5162pfu.3;
        Tue, 14 Jul 2020 16:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SllDjYCLmSxru1bZOSqBdTXqDffkSwFw792rO8lFa7U=;
        b=frddsaq1hig30VQdUYXKi9E7qgT+lEklhJOuEVU4cNd+zr/FZ/qJsCtxJmjZ3TUDuE
         Y4KlconxX1R+1sZBvSaH1Dh6lxYmuayz57ISCG/sKlkew04y43hYdP5ORDidVBVoELSk
         wh7Nxfb7PxmCHZJCl7hi/1Tzpvpqa6YElJ2h+qtxVg81jnUwvU5bP5Gg6m076Fzftn/W
         lssPrpDlMohAbG7/hJKo+d3GrXGpDq1KOybxNQbPjnw8uIVnsphjLn+L2xYqtl/7O9hT
         sb93U/Dq+O41EFbPSnDaQzQYojIMqqvQ/y5087/5kDCmoXsIXPqqj3UROjKOxV2N1GmY
         BWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SllDjYCLmSxru1bZOSqBdTXqDffkSwFw792rO8lFa7U=;
        b=BI4Thfy2pNpxiabdP/yYrwKl+R0D4To6VKiBYfB/YJY8ddt+rJ9YeCZoWenyB5udhl
         SPtin3TaxKBW9zmJUf2Q9h3t27HD2RS4SyiMVwOhs4SqXnqHvqeaTF16RqNHPJ7FCmHy
         CGlSnJDBhvjO0bIs40FidoSaPrPNotMuji8A1gbXA8YoPaM87n3zvN8PmASDw6UYW0oq
         Q17dBZ6s8ixNePkprLVkLb8jRDzHZARvKntDfuzoOSCz3RtzsQf1MSVRe0hHznGNqgir
         1dVDZzFAfp3gkFNMcIjZjmL0qtflI7l4qiuIYofErvm3ausFg8HSnyvQSEN5S22enKCg
         48lg==
X-Gm-Message-State: AOAM530Y2c2mw8yRhROhoUanI9fyQBRMR7QpQI1K8R/dQxX/JYa+YzQb
        Q4ievcleic0LI0yzEi8M2A4=
X-Google-Smtp-Source: ABdhPJyYtjaUYtUYgzywAr3VtAPeWosHYW2YcCoFtgQUcx6MGlqpQa+aghY4/Kqzpt6cjgrupi2pcg==
X-Received: by 2002:a63:b18:: with SMTP id 24mr5484616pgl.406.1594768298072;
        Tue, 14 Jul 2020 16:11:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:96f0])
        by smtp.gmail.com with ESMTPSA id n11sm172491pgm.1.2020.07.14.16.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 16:11:37 -0700 (PDT)
Date:   Tue, 14 Jul 2020 16:11:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
Message-ID: <20200714231133.ap5qnalf6moptvfk@ast-mbp.dhcp.thefacebook.com>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
 <159467114405.370286.1690821122507970067.stgit@toke.dk>
 <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk>
 <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk>
 <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
 <87d04xg2p4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87d04xg2p4.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 12:19:03AM +0200, Toke Høiland-Jørgensen wrote:
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> 
> >> However, assuming it *is* possible, my larger point was that we
> >> shouldn't add just a 'logging struct', but rather a 'common options
> >> struct' which can be extended further as needed. And if it is *not*
> >> possible to add new arguments to a syscall like you're proposing, my
> >> suggestion above would be a different way to achieve basically the same
> >> (at the cost of having to specify the maximum reserved space in advance).
> >>
> >
> > yeah-yeah, I agree, it's less a "logging attr", more of "common attr
> > across all commands".
> 
> Right, great. I think we are broadly in agreement with where we want to
> go with this, actually :)

I really don't like 'common attr across all commands'.
Both of you are talking as libbpf developers who occasionally need to
add printk-s to the kernel. That is not an excuse to bloat api that will be
useful to two people.

The only reason log_buf sort-of make sense in raw_tp_open is because
btf comparison is moved from prog_load into raw_tp_open.
Miscompare of (prog_fd1, btf_id1) vs (prog_fd2, btf_id2) can be easily solved
by libbpf with as nice and as human friendly message libbpf can do.

I'm not convinced yet that it's a kernel job to print it nicely. It certainly can,
but it's quite a bit different from two existing bpf commands where log_buf is used:
PROG_LOAD and BTF_LOAD. In these two cases the kernel verifies the program
and the BTF. raw_tp_open is different, since the kernel needs to compare
that function signatures (prog_fd1, btf_id1) and (prog_fd2, btf_id2) are
exactly the same. The kernel can indicate that with single specific errno and
libbpf can print human friendly function signatures via btf_dump infra for
humans to see.
So I really don't see why log_buf is such a necessity for raw_tp_open.
