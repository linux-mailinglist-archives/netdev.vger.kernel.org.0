Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91E6243F96
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgHMUDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgHMUDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 16:03:16 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B048C061757;
        Thu, 13 Aug 2020 13:03:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id g3so3975216ybc.3;
        Thu, 13 Aug 2020 13:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h/Fu/eRm4VYiCxA0jEUY7SQKMTBFg/bd2rTSL+egI2g=;
        b=GFqIuDNCYUHC7Dv2UmaSQESpc57qp9lE7KZKubZO6qNeCtDBMpAmRsi+ASryarOsZ0
         8Aawq+dFQKmUxnUET1tF7Hs4W7tDv01xsS/E5X52Z7wJWLgQPV8tEIKBmSzZ4u+uJ7KH
         vWXcJPR1BVn3HmS8uyskgwTZRkfF873MjRI5PBJO5Eo0kZInEUnkLLeUFhiSSvErEo7R
         R4wR6PgIYYpTh0ZofwvO0X8/ZSLVfRGaGPrZ7kkUbqN/k51dNZP/gVg/YNbK3JlxoZHj
         NVWucmLBJDR/S3bFHB4PqEEu0xmtTCfbtvKX9f1gki4041jw8e7GAxrGDWmS3i6yOAJP
         iA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h/Fu/eRm4VYiCxA0jEUY7SQKMTBFg/bd2rTSL+egI2g=;
        b=Q7S0bbkMwKgoa6XPgpq6BbrhNplocNJ4VFEiO3dWGxHZ/bu8ZvSMDlXe9s8tw71rvm
         n0AEI5aeEhLp72ELWVjvzVAad5DyiMIBckJ1wGOEi0RCItZboFjtF9/oWOwVhxcI+vnd
         qOVDVK9FaVxgT/a1DarFq5EIkdPada14WvktWgTlHvx62pdmHvQJUW2OKuD1WgDmqJTA
         lTlyDYNbG1swP+t7GzfXWUDcwLy+WeoDS3o1Urv/5DgYnDXdK8ppMeOoYxAb4yeA0aSY
         qvnfVbYb4ntwdpMvrc0zH4MmDgARZFTs1zvjb/FyC65ihxcTqTVHRRWuxNQkI5vRR7ds
         1+sQ==
X-Gm-Message-State: AOAM532xxr54aGZIOuwzypkIzdHprJInpLDSMciN/Z11bXXR8QI/cKHC
        gcVYStQvlijlZutrbVMN1b/5Dp4QHm4sDskoCMo=
X-Google-Smtp-Source: ABdhPJwOsI1CRpw3t6CGSSTTVmqFMh1fH2E9svA8yHBVDahk8GGETC6stxBpY1nEFBwQvsJiuZsyxGpeGuXes8Vk+z0=
X-Received: by 2002:a25:824a:: with SMTP id d10mr9176975ybn.260.1597348995473;
 Thu, 13 Aug 2020 13:03:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200813071722.2213397-1-andriin@fb.com> <20200813192042.ntv6ybry6ck2s6jg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200813192042.ntv6ybry6ck2s6jg@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Aug 2020 13:03:04 -0700
Message-ID: <CAEf4BzaC7Jd4mg_ToXkm2eM2pxfXBEKxq_+pLkKKP-io4U6Fsw@mail.gmail.com>
Subject: Re: [PATCH bpf 0/9] Fix various issues with 32-bit libbpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 12:20 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Aug 13, 2020 at 12:17:13AM -0700, Andrii Nakryiko wrote:
> > This patch set contains fixes to libbpf, bpftool, and selftests that were
> > found while testing libbpf and selftests built in 32-bit mode. 64-bit nature
> > of BPF target and 32-bit host environment don't always mix together well
> > without extra care, so there were a bunch of problems discovered and fixed.
> >
> > Each individual patch contains additional explanations, where necessary.
> >
> > This series is really a mix of bpf tree fixes and patches that are better
> > landed into bpf-next, once it opens. This is due to a bit riskier changes and
> > new APIs added to allow solving this 32/64-bit mix problem. It would be great
> > to apply patches #1 through #3 to bpf tree right now, and the rest into
> > bpf-next, but I would appreciate reviewing all of them, of course.
>
> why first three only?
> I think btf__set_pointer_size() and friends are necessary in bpf tree.

I don't mind. The "scariest" change is bpftool's skeleton generation
change, so would be good if you double-check the logic of enforcing at
most 4 byte alignment. But it seems logically sound and safe to me.

> The only thing I would suggest is to rename guess_ptr_size() into
> determine_ptr_size() or something.
> It's not guessing it. Looking for 'long' in BTF is precise.

It was a guess only in the sense that it won't work for LLP64 model,
for instance. But that model is used on Windows platforms, it seems.
Linux sticks to ILP32 and LP64, both of which have sizeof(long) ==
sizeof(void *). I'll rename it to determine_ptr_sz() then.

> We can teach pahole and llvm to always emit 'long' type and libbpf can
> fail parsing BTF if 'long' is not found.

It's always the case for vmlinux BTF, so no need there. As for BPF .o
files, libbpf just enforces 64-bit pointer size anyways. So all
typical cases are covered reliably, I think. It's only for some
non-mainstream use cases where people want to use libbpf's BTF API for
some unconventional uses of BTF. I don't know any of such cases
besides our own selftests, but it's a generic library API, so who
knows :)

We also can do detection based on ELF target architecture, for
btf__parse_elf() API. btf__parse_raw() is a bit less lucky in that
regard.
