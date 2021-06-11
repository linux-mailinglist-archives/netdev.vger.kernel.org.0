Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8141C3A4A6E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhFKVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:01:33 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:40757 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhFKVBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 17:01:32 -0400
Received: by mail-yb1-f171.google.com with SMTP id e10so6133952ybb.7;
        Fri, 11 Jun 2021 13:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WjgLlU8LoXNlaATyl7xDX9inasD/CI1nNVfmBXx2A7I=;
        b=R9YIU/kblvxs0erA/te1OaqlCj8piLa5YxboWbYsEvkNUvirjZYltz39THhkNP6crX
         oqKr8XWlrnENFetVCfdMGrCBzIQsmSVLnQXKm8xRy8RnLP+8zrcX+Nc307UdNdwUjgy1
         CmcUl0ZIcCtagjOAyY5JfsIgsOSHkft76RhG3OxOjkQe0GhDGtK2F9EI/aJV5qx+YG0o
         Xm1pUpYp/oONthVmpb0kv/E0+YNu+I/ih0mTFsZ/KVE2UyTNcsU8y4lHp9JzcKjYZiUO
         p/D+kZbZ/Ko9oO68LMPyQpTaRUnmwhUlqHWn3P2OykAD1ix7ZXd+do4ZBOzbeJh/Dr7m
         JJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WjgLlU8LoXNlaATyl7xDX9inasD/CI1nNVfmBXx2A7I=;
        b=hCYdjDg+Jr1myrnCho4fG5ZUtR6X/legcZsWLw6K2zjr3AX6otyeD9lcV/eAk6daYm
         eK1/Q4mo4mDr32eovlVVWJEwyALMd2bXKOe5XLIRn0XHiz+ZanGy4O1vFHQZbtSHhE6W
         Sw4OrVgfVQQ5UgplNQT+UwATGLB0w+H7HjQa+gDxo8O/f3SJqaFPuKavFDYvh/cy6yeM
         BvYPsmgBiwRqqVdVRteY61O3asViPNHRb0B4JIpJhRv0IaF5obDrHARcbksIGXkZp0YZ
         YUsodttGmPKJMzWHs5y0yvjYQsA8aGFGGiTHCiSwS5S38xpIZCKaVraR9+fJLpHLf1uy
         aVbA==
X-Gm-Message-State: AOAM532K3ST/v46M6W+Rqav/vGG3nl4pEeknfO1Nwl5TmXuy5UsNy5Uq
        B1afWy1oN/NowN57rJ5opwgQD7yiMFMaVfzLZQQ=
X-Google-Smtp-Source: ABdhPJwpo9TCw8TVohZegaDwTnUMsmtqFLDWrK0cYbk+ADp/AHkk+u14I1WNePya+nJNeiX1tg116abi0orA162TfRk=
X-Received: by 2002:a25:7246:: with SMTP id n67mr8677619ybc.510.1623445100193;
 Fri, 11 Jun 2021 13:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210512103451.989420-1-memxor@gmail.com> <CAEf4BzbgFE2qtC8iw7f5m2maKZhiAYngiYU_kpx30FT0Sy9j-w@mail.gmail.com>
 <20210611204611.4xdgvqwtcin6ckdc@apollo>
In-Reply-To: <20210611204611.4xdgvqwtcin6ckdc@apollo>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Jun 2021 13:58:09 -0700
Message-ID: <CAEf4BzZWBLYuuSY5p=TO1uj4ie+JCxZ4Js0uxUmgNBwQcwZ5+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 0/3] Add TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Shaun Crampton <shaun@tigera.io>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 1:47 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sat, Jun 12, 2021 at 01:31:56AM IST, Andrii Nakryiko wrote:
> > On Wed, May 12, 2021 at 3:35 AM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > This is the seventh version of the TC-BPF series.
> > >
> > > It adds a simple API that uses netlink to attach the tc filter and its bpf
> > > classifier program. Currently, a user needs to shell out to the tc command line
> > > to be able to create filters and attach SCHED_CLS programs as classifiers. With
> > > the help of this API, it will be possible to use libbpf for doing all parts of
> > > bpf program setup and attach.
> > >
> > > Changelog contains details of patchset evolution.
> > >
> > > In an effort to keep discussion focused, this series doesn't have the high level
> > > TC-BPF API. It was clear that there is a need for a bpf_link API in the kernel,
> > > hence that will be submitted as a separate patchset based on this.
> > >
> > > The individual commit messages contain more details, and also a brief summary of
> > > the API.
> > >
> > > Changelog:
> > > ----------
> >
> > Hey Kartikeya,
> >
> > There were few issues flagged by Coverity after I synced libbpf to
> > Github. A bunch of them are netlink.c-related. Could you please take a
> > look and see if they are false positives or something that we can
> > actually fix? See links to the issues below. Thanks!
> >
> >   [0] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901199&mergedDefectId=141815
> >   [1] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901193&mergedDefectId=322806
> >   [2] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901197&mergedDefectId=322807
> >   [3] https://scan3.coverity.com/reports.htm#v40547/p11903/fileInstanceId=53874109&defectInstanceId=10901195&mergedDefectId=322808
> >
>
> Hi Andrii,
>
> These links don't work for me (I get a timeout). Would you know why? Is there
> some other link where I can look at them?
>

Sorry, I don't know any other way to share them.
https://scan3.coverity.com/reports.htm#v40547/p11903 should show all
libbpf issues. Maybe try creating an account with coverity.com?..

> > [...]
> >
> > >
> > > Kumar Kartikeya Dwivedi (3):
> > >   libbpf: add netlink helpers
> > >   libbpf: add low level TC-BPF API
> > >   libbpf: add selftests for TC-BPF API
> > >
> > >  tools/lib/bpf/libbpf.h                        |  43 ++
> > >  tools/lib/bpf/libbpf.map                      |   5 +
> > >  tools/lib/bpf/netlink.c                       | 554 ++++++++++++++++--
> > >  tools/lib/bpf/nlattr.h                        |  48 ++
> > >  .../testing/selftests/bpf/prog_tests/tc_bpf.c | 395 +++++++++++++
> > >  .../testing/selftests/bpf/progs/test_tc_bpf.c |  12 +
> > >  6 files changed, 993 insertions(+), 64 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
> > >
> > > --
> > > 2.31.1
> > >
>
> --
> Kartikeya
