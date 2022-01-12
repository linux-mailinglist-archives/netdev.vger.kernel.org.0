Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680AF48C90C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355419AbiALREr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355510AbiALREm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:04:42 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965EEC06173F;
        Wed, 12 Jan 2022 09:04:42 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z17so956067ilm.3;
        Wed, 12 Jan 2022 09:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MM7tsNjQ1RjKdLjIHYsiqgwyzjhwJ0Sd2pi5INVTS3Q=;
        b=OtK3i+2Ty+nFD/D/+RH0QLwdycQnaaQUlO6sUBfDW1msryhEvHE9oK7qD63hh59rVy
         q7h+GJk3N542RZW0B3y7zdihtuigG9uZCaYbfCbS+bzHVDTd9tdmh+A7ucE06NfdudmI
         1tuI+xKNe4PsXTSyFag7IFO+3gfRhb2AMvdPwOT6Yt8FC06b6yImDkf7B0tO0FJB8aP4
         S7OcapXa4cmxUobw51i+1R3FxGMaIpYhT0OTueuybnHxJwnMIkkluxAqJvBuN/L6y/xX
         9CnBjmPJVmW85hM5O2tybAPGguDJbsP1iB6Wiskp7pUsp4d9Um0uyc6w75xX30C4MQeF
         KjAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MM7tsNjQ1RjKdLjIHYsiqgwyzjhwJ0Sd2pi5INVTS3Q=;
        b=CFkx080P2OPakvqRy0C3FSnXmNdAWAbn8CbH8TvnL2JcZ3at3HMpms1o2CFgmc7wzM
         eIJyxentXOanr/HRmG5hsjo08YCaENDS3wdybCFeMZLpHM1oa7GynSL+njHtDqunyvf1
         efXoK8p4GsuS00BaEu20lI9m37Jal16prie7x5GNxaUyS5tPlsx543/Peegt3FiQT0/V
         rZ3iICGsfTRvxSI16WRqb0ODVjJyFEipCkAXN9Cf3hkQpF552iuU+2SdrW0xg7eImu19
         Kq50yZ7RzVAS5Zdaye238l1pghbrBxhYFLvC2YqMk8Iuk6iW0wT4xbau1Lml9I2hL1e+
         T2aQ==
X-Gm-Message-State: AOAM531neBKKzOpK2VokvJA9eS6av7/zPLOIthVxVPMjbFhLd96tlUVu
        lcFDTObUdocbZC/BJGoyM39MqcyAWYvlysIn2HA=
X-Google-Smtp-Source: ABdhPJw+3snJ3EljleHH4lNVkB2UC6LRoGYoai/9g0BNjhUahCdB0oAE8v5QNx53cihajRL9XmYDGptr6HOi+ZAasqY=
X-Received: by 2002:a05:6e02:1a24:: with SMTP id g4mr399887ile.71.1642007081328;
 Wed, 12 Jan 2022 09:04:41 -0800 (PST)
MIME-Version: 1.0
References: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1642004329-23514-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Jan 2022 09:04:30 -0800
Message-ID: <CAEf4BzYRLxzVHw00DUphqqdv2m_AU7Mu=S0JF0PZYN40hBvHgA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/4] libbpf: userspace attach by name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 8:19 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> This patch series is a rough attempt to support attach by name for
> uprobes and USDT (Userland Static Defined Tracing) probes.
> Currently attach for such probes is done by determining the offset
> manually, so the aim is to try and mimic the simplicity of kprobe
> attach, making use of uprobe opts.
>
> One restriction applies: uprobe attach supports system-wide probing
> by specifying "-1" for the pid.  That functionality is not supported,
> since we need a running process to determine the base address to
> subtract to get the uprobe-friendly offset.  There may be a way
> to do this without a running process, so any suggestions would
> be greatly appreciated.
>
> There are probably a bunch of subtleties missing here; the aim
> is to see if this is useful and if so hopefully we can refine
> it to deal with more complex cases.  I tried to handle one case
> that came to mind - weak library symbols - but there are probably
> other issues when determining which address to use I haven't
> thought of.
>
> Alan Maguire (4):
>   libbpf: support function name-based attach for uprobes
>   libbpf: support usdt provider/probe name-based attach for uprobes
>   selftests/bpf: add tests for u[ret]probe attach by name
>   selftests/bpf: add test for USDT uprobe attach by name
>

Hey Alan,

I've been working on USDT support last year. It's considerably more
code than in this RFC, but it handles not just finding a location of
USDT probe(s), but also fetching its arguments based on argument
location specification and more usability focused BPF-side APIs to
work with USDTs.

I don't remember how up to date it is, but the last "open source"
version of it can be found at [0]. I currently have the latest
debugged and tested version internally in the process of being
integrated into our profiling solution here at Meta. So far it seems
to be working fine and covers our production use cases well.

The plan is to open source it as a separate companion library to
libbpf some time in the next few months. Hopefully that would work for
you. Once it is available, I hope we can also utilize it to convert
some more BCC-based tools (that rely on USDT) to libbpf ([1]).

  [0] https://github.com/anakryiko/linux/commit/d473d042c8058da0a9e6c0353d97aeaf574925c6
  [1] https://github.com/iovisor/bcc/tree/master/libbpf-tools

>  tools/lib/bpf/libbpf.c                             | 244 +++++++++++++++++++++
>  tools/lib/bpf/libbpf.h                             |  17 +-
>  tools/testing/selftests/bpf/Makefile               |  34 +++
>  .../selftests/bpf/prog_tests/attach_probe.c        |  74 ++++++-
>  .../selftests/bpf/progs/test_attach_probe.c        |  24 ++
>  5 files changed, 391 insertions(+), 2 deletions(-)
>
> --
> 1.8.3.1
>
