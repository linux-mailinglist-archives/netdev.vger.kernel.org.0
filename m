Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FD634BAE5
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 06:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhC1EdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 00:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhC1EdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 00:33:10 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30656C061762;
        Sat, 27 Mar 2021 21:33:10 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id l15so10257324ybm.0;
        Sat, 27 Mar 2021 21:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CJibKbE2pHTeyp3O5gbay5BrG2Hry6PfPEoIAMQ+LSk=;
        b=ilPqnOEh9fQBeGtp0rwT2gyJ4dNWjAulC8oZ0D/S5B2eWMUYSJDsyGYZqlVHSnSCiS
         1NNlIlTIt4yX7TOVrih/LdAnlhAzW14CMvh1Gux1Ar0diImXDqRYinu2QqDlyeU6cRlR
         Ze7W/H0V8FrM5T96ZIFQrLIxzgn3n9ePfN+iDi3/AyqmFTW1uZR/vtFr7vFAGNPVa6sF
         KONaM+2RO5WNqUNBlYgdQEzb3vSZkVSrtoQyFtF1vBL9k+9JGGR4Y+Bubf4doPK9VSOR
         430uP9lXv7LiQR20e1pSsjGB+HQ/XrpmjehJLOn1PQ1Bn0LKZt0ITxBVYpM+9G2QEmn3
         2nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CJibKbE2pHTeyp3O5gbay5BrG2Hry6PfPEoIAMQ+LSk=;
        b=TmtRj3RYgC9hJLk4cI6ARb/bOQKRt6PFbtTGGoZ9w5LUJH8jnmZ14cGF7RNhwjFaBg
         CQs6wIHFMNBimuYpbT014DvYRjPsQeOF6eWC7JopXEe94OaPOwsN+mAR/zQPAA4p6/NW
         giAB4MVNx07dT/rGzBR/ql4DH2qE+j/jhmd0156/fNtMRhvYFwIwg0FLDWsXK1YuaLyF
         lKPB3QTqxZPRxOpN3hpJcWSDU12KkYkghxJVpbGb52WJCiwYxMDcME3CxlYEdmaY0N5E
         dqjdCGRHq3ghkn/9QOPV9cVCirKD8eaTkQabZ0urrcliyYOn5E/RsIkcie5gb5jJN98w
         Uinw==
X-Gm-Message-State: AOAM531Rfyg8n5WzK8lHhgFSWdJLq2sl3RVyqjBlcZR5EHP6ZBG+tNPy
        QOaQp5qoNjqG3WUUW7AgxacZjWgM7WtWs6EIGso=
X-Google-Smtp-Source: ABdhPJw+4nuWmp0dJnLLJo8TB3bkZkAg2joGu9L9FqfjWQrWzKjqP3IQ6U9kxxeMpUTCn4ISJc9ccw66DnyOzzlBkLE=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr29811546ybc.425.1616905989011;
 Sat, 27 Mar 2021 21:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-6-memxor@gmail.com>
 <20210327021534.pjfjctcdczj7facs@ast-mbp>
In-Reply-To: <20210327021534.pjfjctcdczj7facs@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Mar 2021 21:32:58 -0700
Message-ID: <CAEf4Bzba_gdTvak_UHqi96-w6GLF5JQcpQRcG7zxnx=kY8Sd5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/5] libbpf: add selftests for TC-BPF API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 7:15 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Mar 25, 2021 at 05:30:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> > This adds some basic tests for the low level bpf_tc_* API and its
> > bpf_program__attach_tc_* wrapper on top.
>
> *_block() apis from patch 3 and 4 are not covered by this selftest.
> Why were they added ? And how were they tested?
>
> Pls trim your cc. bpf@vger and netdev@vger would have been enough.
>
> My main concern with this set is that it adds netlink apis to libbpf while
> we already agreed to split xdp manipulation pieces out of libbpf.
> It would be odd to add tc apis now only to split them later.

We weren't going to split out basic attach APIs at all. So
bpf_set_link_xdp_fd() and bpf_program__attach_xdp() would stay in
libbpf. libxdp/libxsk would contain higher-level APIs which establish
additional conventions, beyond the basic operation of attaching BPF
program to XDP hook. E.g, all the chaining and how individual XDP
"sub-programs" are ordered, processed, updated/replaced, etc. That's
all based on one particular convention that libxdp would establish, so
that part shouldn't live in libbpf.

So in that sense, having TC attach APIs makes sense to complete
libbpf's APIs. I think it's totally in libbpf's domain to provide APIs
of the form "attach BPF program to BPF hook".

> I think it's better to start with new library for tc/xdp and have
> libbpf as a dependency on that new lib.
> For example we can add it as subdir in tools/lib/bpf/.
>
> Similarly I think integerating static linking into libbpf was a mistake.
> It should be a sub library as well.
>
> If we end up with core libbpf and ten sublibs for tc, xdp, af_xdp, linking,
> whatever else the users would appreciate that we don't shove single libbpf
> to them with a ton of features that they might never use.

What's the concern exactly? The size of the library? Having 10
micro-libraries has its own set of downsides, I'm not convinced that's
a better situation for end users. And would certainly cause more
hassle for libbpf developers and packagers.

And what did you include in "core libbpf"?
