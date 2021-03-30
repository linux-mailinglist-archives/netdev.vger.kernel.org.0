Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C450734F257
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhC3UkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhC3Ujj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 16:39:39 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED4DC061574;
        Tue, 30 Mar 2021 13:39:39 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 8so18733728ybc.13;
        Tue, 30 Mar 2021 13:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHFETPlCm5ghAjLH5TwVdNy5XrA3VED7pKjEr1FvnQI=;
        b=uycPTR+xErTW6WvImIxkYRVwhbADeQEdOUjkK+Cd8k+Ghk3NESFWsx7hbg3zNl8rYM
         7VNLB7aZ7I0kJYeDVcVM4JFggeZ+camx28CbuWthp2jsl9CoBCUakkMM6hB7JHUBtThM
         K29405u0YpRbegkCbU77RQw46UMVXMRGZTZHw/iQFE5J8Cbdwrtxr3KbrKezeMppOczX
         jZA0mRitWHQrR089DUeIZUAC7KPgM8SC3bzEYKDiRG2Ix5Uyhpve3jOL7kFlqeCUtvn3
         eLuFI7m2RSBmw+FSP9HR0ULXJTrErSxujmKH82/lMIKbV//MYauYzTC3LmIocY9yWJ6p
         JP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHFETPlCm5ghAjLH5TwVdNy5XrA3VED7pKjEr1FvnQI=;
        b=SteT7Vvj8tCkMzJ2L5spLt1BswEdh38pwNGEMBf9mM7AuMX0189sWUwtviTkJOv5Lj
         /iwr70CqefQ1RoP88gXtmiE6GsXk7i+f+CZKHqwjE2qV7qSQk+4KPHF5m7HrNPNqR9fW
         5C3NHlcTEbVtyx7hVu0hFfsKMvnMjZWha4ACbyVCsj5hCtGzuE+dygFdVIQjMpG7twS1
         nR4aEXuwh8C9RsgyaZJ3FFAdEa7utfeefHOh3PY5/1NkjN5Sd8vD+UOir1zwo7zNB9io
         UCMlx8PtzU/QJFDfO1E4qJ8IqLTEWSE0HV2QPMmPyn520rUd4yroYAecydQ/ZoPHY3uV
         6cjg==
X-Gm-Message-State: AOAM5332ZJvbn9zMEY/XyZ/JCCRsVJSkFlsHnfSaurGCBBFLGcXWE0p5
        WfFNUZxkOsABmUov+qC0Lp0iVs8rvMKSo1+oEZM=
X-Google-Smtp-Source: ABdhPJz/C/OKlDXnUKi7UwL7ca2OiUVAIYqhZ8kErBU1p7eHbesrmmeSL53C+RjbeCXCtosZxEgAXzmiIdAoCy8sfH8=
X-Received: by 2002:a25:9942:: with SMTP id n2mr92030ybo.230.1617136778404;
 Tue, 30 Mar 2021 13:39:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210325120020.236504-1-memxor@gmail.com> <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com> <20210328080648.oorx2no2j6zslejk@apollo>
In-Reply-To: <20210328080648.oorx2no2j6zslejk@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Mar 2021 13:39:27 -0700
Message-ID: <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
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

On Sun, Mar 28, 2021 at 1:11 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sun, Mar 28, 2021 at 10:12:40AM IST, Andrii Nakryiko wrote:
> > Is there some succinct but complete enough documentation/tutorial/etc
> > that I can reasonably read to understand kernel APIs provided by TC
> > (w.r.t. BPF, of course). I'm trying to wrap my head around this and
> > whether API makes sense or not. Please share links, if you have some.
> >
>
> Hi Andrii,
>
> Unfortunately for the kernel API part, I couldn't find any when I was working
> on this. So I had to read the iproute2 tc code (tc_filter.c, f_bpf.c,
> m_action.c, m_bpf.c) and the kernel side bits (cls_api.c, cls_bpf.c, act_api.c,
> act_bpf.c) to grok anything I didn't understand. There's also similar code in
> libnl (lib/route/{act,cls}.c).
>
> Other than that, these resources were useful (perhaps you already went through
> some/all of them):
>
> https://docs.cilium.io/en/latest/bpf/#tc-traffic-control
> https://qmonnet.github.io/whirl-offload/2020/04/11/tc-bpf-direct-action/
> tc(8), and tc-bpf(8) man pages
>
> I hope this is helpful!

Thanks! I'll take a look. Sorry, I'm a bit behind with all the stuff,
trying to catch up.

I was just wondering if it would be more natural instead of having
_dev _block variants and having to specify __u32 ifindex, __u32
parent_id, __u32 protocol, to have some struct specifying TC
"destination"? Maybe not, but I thought I'd bring this up early. So
you'd have just bpf_tc_cls_attach(), and you'd so something like

bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, parent_id, protocol))

or

bpf_tc_cls_attach(prog_fd, TC_BLOCK(block_idx, protocol))

? Or it's taking it too far?

But even if not, I think detaching can be unified between _dev and
_block, can't it?

>
> --
> Kartikeya
