Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECF48C42BC
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 23:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfJAVbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 17:31:14 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37386 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfJAVbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 17:31:14 -0400
Received: by mail-qt1-f194.google.com with SMTP id l3so23606924qtr.4;
        Tue, 01 Oct 2019 14:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H03/7bvNNBNTOdxvTEc5izwmYBaCQnPa6PU2xDhsBpU=;
        b=W26cn0yOFQyamHCrFN+JCYUsIp+K3+RUY+HX5hOaLVAaWHfv/M1+gzNd5TURhIhVNQ
         Jb8QqxFtkSMq9Ah7YUSCC4HYL4oQcnpmeaYDA8cdfamNFomivcADv0Do9axibJMHtX1w
         4u6S7BR0BnNz3/BtmAGzJ43hllSsxoo2l/4Fa1eMm8fxprdfI5LzgGur2Ov9ziQC+0QW
         Kn+gFvcHaup0nQ72LOblCNbv4jKuIwbemrMD6FcN2G/ZUj4JTuqkbSzSFHuyxOPDd4J9
         dIPTivkNtLpUHuFlHFznBJN3VZCBT5rkJh+BLz0IDRNRaatnbe50DcfDS9r+Y9vQjDYx
         ukUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H03/7bvNNBNTOdxvTEc5izwmYBaCQnPa6PU2xDhsBpU=;
        b=CEX3IC3T/aZqNvl+qans9zIB1BexB9KlN8PjAbHTKqsdM74JTaYLtxh79/05UgKZ44
         39RXxjKCaIyVIZemgk9Fz/YX12ScPJLFW9MJxDLblgSvJ4zaVkctA7zRz2/X708VDlU5
         kuTulksphk06te5CoYoLH+sYk2bTJwIh9Sll0vEKvcSDEFkt+BNFOudIYCGKFCQz4GwE
         OKNrozzScNGjfby/hUi3FnABoxrefHFeOb8YmRLJfcrkA+x4Urm8ICSgdBJdQCikfZ5e
         CPD6A23AMvz7ZhW7phkWHqIwf7UDm6ymA0gg3ZZrUEfcvOj7gYFl4CV2j/FkTlFXPhn4
         zqxA==
X-Gm-Message-State: APjAAAU0IaPLBLoEVfSNB8pjaEGic3rPZ8/3nDnikxgUncG7+y+SMMXs
        ExRLgSQo2W44JCndFIDLPiBMySsBNKMStjDyD/E=
X-Google-Smtp-Source: APXvYqxafwz9gOfLJ6bIosFFj58XKKXq6uA0QG3Ap2BmwjfB2TUFj67lKMHNkU6nsVk4eyXxGh2jMO2JQsZWzA4TM4E=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr464592qtq.141.1569965473477;
 Tue, 01 Oct 2019 14:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-6-andriin@fb.com>
 <5d93a58be3b5f_85b2b0fc76de5b4e@john-XPS-13-9370.notmuch>
In-Reply-To: <5d93a58be3b5f_85b2b0fc76de5b4e@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 14:31:02 -0700
Message-ID: <CAEf4BzZYLhimf+7s6oTorwFHS=+=-0OYt6Me14PQqz3_MbJRbw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] selftests/bpf: adjust CO-RE reloc tests for
 new BPF_CORE_READ macro
To:     John Fastabend <john.fastabend@gmail.com>
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

On Tue, Oct 1, 2019 at 12:14 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Given introduction of variadic BPF_CORE_READ with slightly different
> > syntax and semantics, define CORE_READ, which is a thin wrapper around
> > low-level bpf_core_read() macro, which in turn is just a wrapper around
> > bpf_probe_read(). BPF_CORE_READ is higher-level variadic macro
> > supporting multi-pointer reads and are tested separately.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../bpf/progs/test_core_reloc_arrays.c         | 10 ++++++----
> >  .../bpf/progs/test_core_reloc_flavors.c        |  8 +++++---
> >  .../selftests/bpf/progs/test_core_reloc_ints.c | 18 ++++++++++--------
> >  .../bpf/progs/test_core_reloc_kernel.c         |  6 ++++--
> >  .../selftests/bpf/progs/test_core_reloc_misc.c |  8 +++++---
> >  .../selftests/bpf/progs/test_core_reloc_mods.c | 18 ++++++++++--------
> >  .../bpf/progs/test_core_reloc_nesting.c        |  6 ++++--
> >  .../bpf/progs/test_core_reloc_primitives.c     | 12 +++++++-----
> >  .../bpf/progs/test_core_reloc_ptr_as_arr.c     |  4 +++-
> >  9 files changed, 54 insertions(+), 36 deletions(-)
> >
>
> Starting to get many layers of macros here but makes sense here.

Yeah, a bit. I was considering to either switch to bpf_core_read()
with explicit sizeof or making bpf_core_read() deriving sizeof(), but
didn't because:

1. wanted to keep bpf_core_read() a direct "substitute" for bpf_probe_read()
2. figured one copy-pasted #define for each of few files is small
enough price for much more readable tests

>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Thanks for review!
