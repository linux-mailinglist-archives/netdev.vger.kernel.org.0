Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB843D3205
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 04:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbhGWCFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 22:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhGWCFL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 22:05:11 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8FFC061575;
        Thu, 22 Jul 2021 19:45:44 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id w17so118830ybl.11;
        Thu, 22 Jul 2021 19:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=alsXQUg52MCO+W7z8LnpYlLwvTRSaHC5Km68+vb1FdA=;
        b=Hg3a3vuiu8AU8twL72OYzOlcSPWAbcISk0y3Os6gX2w5pPtwK4Ky83DXVXSoxto5vv
         Imm9xxPbyjL5EsDpJpCP2VwWCKGJCS7eJKOj1u77ZMIm6yj6uGDvpsWTDEKQhR3pgBGR
         tQkTcIRxFHjB7GX9HswJjy28csiciyqsl/Xg8Q2xt6eRUCxBdYvpt3ZF0eUnBhvQ6FBp
         9p+vFb8KwnJ59Wi6cEMNfjgHrNRrIJ3XlINYfODomoPH3UNfidnQ5phQNmbeYF48lxQk
         iJ7nEu2MoaxkI9kzTCZrnr+dzOTkLcMWg3byWGelomNYq63LL1fQATJT6ZhtjUVRc5CP
         3Wog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=alsXQUg52MCO+W7z8LnpYlLwvTRSaHC5Km68+vb1FdA=;
        b=cqE8cIFWgQV1GQFQxCvzWM/tFMbz6B63QbQxTW2dQUDoYms1BWx/26XpnF0atac3KS
         uAuJMJ5uevl2Aw7xGlshYt/5bbiVlfrHmW8JhIvPNl/UuV4tnDSN+HP3fGoZ2IV0riGf
         JS5KVPSm9GXq9eX58ZfX7eHYTeL8vnoy2IDMmJqgpi6V667I3kj4Ddz1vhBzNGzwAir3
         1jeUL2+M16cWJoT0rt0P4K+cic6stI8R7j0X9JlgLVADPusKAlRMXyNQI48cpqyeplSl
         1bJ/TgodxpXMiZwqeOmkn70ACtiw7U5bgDBPU48Cgkxe98K5CwUe3E75eLl77k9yU1Ik
         ZJzw==
X-Gm-Message-State: AOAM532qP7gVdSpNn86xcijfTP6+RuC9LGryymC0c+6u8Z+TsPPDfQzi
        iiNZwPoOmUjWcsLagK/L8Y2z/49X0hRr+oLdIEM=
X-Google-Smtp-Source: ABdhPJznzvFcqswUtFAQrQt+7hyINFIrodcpV00ntfnVzpK27j6UDMfT9McspXWAULG2sAhFqAwFgY6b/m9rsq1BvM4=
X-Received: by 2002:a25:1455:: with SMTP id 82mr3500295ybu.403.1627008343672;
 Thu, 22 Jul 2021 19:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
In-Reply-To: <CAEf4Bzb30BNeLgio52OrxHk2VWfKitnbNUnO0sAXZTA94bYfmg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 19:45:32 -0700
Message-ID: <CAEf4BzZZXx28w1y_6xfsue91c_7whvHzMhKvbSnsQRU4yA+RwA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/5] libbpf: rename btf__get_from_id() and
 btf__load() APIs, support split BTF
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 5:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > As part of the effort to move towards a v1.0 for libbpf [0], this set
> > improves some confusing function names related to BTF loading from and to
> > the kernel:
> >
> > - btf__load() becomes btf__load_into_kernel().
> > - btf__get_from_id becomes btf__load_from_kernel_by_id().
> > - A new version btf__load_from_kernel_by_id_split() extends the former to
> >   add support for split BTF.
> >
> > The old functions are not removed or marked as deprecated yet, there
> > should be in a future libbpf version.
>
> Oh, and I was thinking about this whole deprecation having to be done
> in two steps. It's super annoying to keep track of that. Ideally, we'd
> have some macro that can mark API deprecated "in the future", when
> actual libbpf version is >= to defined version. So something like
> this:
>
> LIBBPF_DEPRECATED_AFTER(V(0,5), "API that will be marked deprecated in v0.6")

Better:

LIBBPF_DEPRECATED_SINCE(0, 6, "API that will be marked deprecated in v0.6")

>
>
> We'd need to make sure that during the build time we have some
> LIBBPF_VERSION macro available against which we compare the expected
> version and add or not the __attribute__((deprecated)).
>
> Does this make sense? WDYT? I haven't looked into how hard it would be
> to implement this, but it should be easy enough, so if you'd like some
> macro challenge, please take a stab at it.
>
> Having this it would be possible to make all the deprecations at the
> same time that we add replacement APIs and not ask anyone to follow-up
> potentially a month or two later, right?
>
> >
> > The last patch is a trivial change to bpftool to add support for dumping
> > split BTF objects by referencing them by their id (and not only by their
> > BTF path).
> >
> > [0] https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
> >
> > v2:
> > - Remove deprecation marking of legacy functions (patch 4/6 from v1).
> > - Make btf__load_from_kernel_by_id{,_split}() return the btf struct.
> > - Add new functions to v0.5.0 API (and not v0.6.0).
> >
> > Quentin Monnet (5):
> >   libbpf: rename btf__load() as btf__load_into_kernel()
> >   libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
> >   tools: replace btf__get_from_id() with btf__load_from_kernel_by_id()
> >   libbpf: add split BTF support for btf__load_from_kernel_by_id()
> >   tools: bpftool: support dumping split BTF by id
> >
> >  tools/bpf/bpftool/btf.c                      |  8 ++---
> >  tools/bpf/bpftool/btf_dumper.c               |  6 ++--
> >  tools/bpf/bpftool/map.c                      | 16 +++++-----
> >  tools/bpf/bpftool/prog.c                     | 29 +++++++++++------
> >  tools/lib/bpf/btf.c                          | 33 ++++++++++++++------
> >  tools/lib/bpf/btf.h                          |  4 +++
> >  tools/lib/bpf/libbpf.c                       |  7 +++--
> >  tools/lib/bpf/libbpf.map                     |  3 ++
> >  tools/perf/util/bpf-event.c                  | 11 ++++---
> >  tools/perf/util/bpf_counter.c                | 12 +++++--
> >  tools/testing/selftests/bpf/prog_tests/btf.c |  4 ++-
> >  11 files changed, 86 insertions(+), 47 deletions(-)
> >
> > --
> > 2.30.2
> >
