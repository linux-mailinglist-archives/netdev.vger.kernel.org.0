Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FB838F4D6
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbhEXV1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhEXV1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 17:27:17 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E64C061574;
        Mon, 24 May 2021 14:25:47 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g38so39976922ybi.12;
        Mon, 24 May 2021 14:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/MUODWc9fltScBkiRbDcMekqBJXzoUSEATVWavUzR+o=;
        b=bROfTMi8M6Ie61+Nd0afQSljgKte1NtcfhrxgJ1S42hmFp1Ex3yfgi297lJomq+KA7
         6fkUSy8WfDDsWPGla0PnUNlvr97xR98sNCf2jwu/VbiraQo2ILCPqbZ+EbmnB8LlzK+u
         73JTLSB06TDCBRHqEn4A1Yd3bYtZqUv/Pq+zNOL7k9ewi91JiYv8pO9Sk5P7Z/yH4Ixs
         yZVd9PvB9zMzWjDAn9yGPOVeM8f/chVhxCJAQaCaZHgDqWQKWN+VveltUNh/TN1EIRpu
         gpqysHKAzj3nXSyoLGXrDEc8CbSF4Qw70eHkdXGLBaqozXhFdT5d0LEGPMmLlyFA5ru+
         2hJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/MUODWc9fltScBkiRbDcMekqBJXzoUSEATVWavUzR+o=;
        b=Rz/dRUSsE571bgema3N17M+b6lvyUZoMr57rRmeIyoRL8g9NwUlN6+a1PT2NmVSODN
         9x0EF2332AYlFzqZeC7yR8sBspV4kVYVBnDcvIkziH1NjJP1Sg8HTMSIHrmVUi51zzFV
         fzgVOF2aVeNRKO1g//emiB7zdbyOvCJgX1dYamOTgIMAzGGvK4GyH5qc1BMgt0zGx4MQ
         2VbSYmxz0mqd+/TVVboSn4jBj6Q2FjjS3yEleqv61S8zSidguKO10h65Tm19psvVCyf6
         /llsjzX/PeOfasM9TfYMVMeb+XNO+nUHIFT8597Y6N/QiAbHhU9IoHSlgdpEaILtcimC
         TnmQ==
X-Gm-Message-State: AOAM530PYGdCQrWuCQp+MJO9ztswQAeNb8LXaUX5O6Vth9Vq12WrXYuP
        73qp6ov9QY+VMW4iTW16Up/s0svLEcUQeCHceZc=
X-Google-Smtp-Source: ABdhPJzciw2nkZL3bXy/6V4ArRJZpqd16QlWdXK95yyDRVrXGyE30/SOsFgktd2bRWLS3HcCHZYJTgSoUmQdPXhfuJA=
X-Received: by 2002:a25:3357:: with SMTP id z84mr37626154ybz.260.1621891547041;
 Mon, 24 May 2021 14:25:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210521234203.1283033-1-andrii@kernel.org> <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
 <CAEf4BzY0=J1KP4txDSVJdS93YVLxO8LLQTn0UCJ0RKDL_XzpYw@mail.gmail.com> <CAKH8qBtvhP6KqhPy+J6YktdcojsQJhjrz3SsD9ocKuiZ-+U9Kw@mail.gmail.com>
In-Reply-To: <CAKH8qBtvhP6KqhPy+J6YktdcojsQJhjrz3SsD9ocKuiZ-+U9Kw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 May 2021 14:25:36 -0700
Message-ID: <CAEf4BzbAt8uGaTp4zec=okUwZ00y9-SLH8ahEQJVRQ7tHb=QDA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
To:     Stanislav Fomichev <sdf@google.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 1:35 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Mon, May 24, 2021 at 12:19 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, May 23, 2021 at 11:36 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Andrii Nakryiko wrote:
> > > > Implement error reporting changes discussed in "Libbpf: the road to v1.0"
> > > > ([0]) document.
> > > >
> > > > Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set of flags
> > > > that turn on a set of libbpf 1.0 changes, that might be potentially breaking.
> > > > It's possible to opt-in into all current and future 1.0 features by specifying
> > > > LIBBPF_STRICT_ALL flag.
> > > >
> > > > When some of the 1.0 "features" are requested, libbpf APIs might behave
> > > > differently. In this patch set a first set of changes are implemented, all
> > > > related to the way libbpf returns errors. See individual patches for details.
> > > >
> > > > Patch #1 adds a no-op libbpf_set_strict_mode() functionality to enable
> > > > updating selftests.
> > > >
> > > > Patch #2 gets rid of all the bad code patterns that will break in libbpf 1.0
> > > > (exact -1 comparison for low-level APIs, direct IS_ERR() macro usage to check
> > > > pointer-returning APIs for error, etc). These changes make selftest work in
> > > > both legacy and 1.0 libbpf modes. Selftests also opt-in into 100% libbpf 1.0
> > > > mode to automatically gain all the subsequent changes, which will come in
> > > > follow up patches.
> > > >
> > > > Patch #3 streamlines error reporting for low-level APIs wrapping bpf() syscall.
> > > >
> > > > Patch #4 streamlines errors for all the rest APIs.
> > > >
> > > > Patch #5 ensures that BPF skeletons propagate errors properly as well, as
> > > > currently on error some APIs will return NULL with no way of checking exact
> > > > error code.
> > > >
> > > >   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY
> > > >
> > > > Andrii Nakryiko (5):
> > > >   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
> > > >     behaviors
> > > >   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
> > > >   libbpf: streamline error reporting for low-level APIs
> > > >   libbpf: streamline error reporting for high-level APIs
> > > >   bpftool: set errno on skeleton failures and propagate errors
> > > >
> > >
> > > LGTM for the series,
> > >
> > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> >
> > Thanks, John!
> >
> > Toke, Stanislav, you cared about these aspects of libbpf 1.0 (by
> > commenting on the doc itself), do you mind also taking a brief look
> > and letting me know if this works for your use cases? Thanks!
>
> I took a quick look earlier today and everything looks good, thanks!

Great, thanks for looking.

> I'll try to enable strict mode in our codebase in the coming weeks to
> see how it goes.

Keep in mind, if you do libbpf_set_strict_mode(LIBBPF_STRICT_ALL) you
are automatically opting in for all the future "features", so for
production you might want to go conservative and start with specifying
explicitly LIBBPF_STRICT_DIRECT_ERRS | LIBBPF_STRICT_CLEAN_PTRS, and
then add more as you check that your code will handle new changes.
