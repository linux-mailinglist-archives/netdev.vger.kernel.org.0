Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF9B0156C0F
	for <lists+netdev@lfdr.de>; Sun,  9 Feb 2020 19:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbgBISc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Feb 2020 13:32:56 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45218 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgBISc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Feb 2020 13:32:56 -0500
Received: by mail-qk1-f196.google.com with SMTP id a2so3884510qko.12;
        Sun, 09 Feb 2020 10:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FwnS7raatQida7H2CFe9qp4MAjUyBdHcORgJ6PWgqUw=;
        b=Y0/5tjKL7sgveyW9gFjK83XEW6pBvdPc7r2ljDKNaFdD0C5k4z04v/XHmxnIcNqlHt
         R1FZqLK1nN3M/HDZ39GErlxZrRsFjvjiqEzuf70TZ1IWJ3wOa08OGIXoXCJQOhDyD6Wv
         K8fFjtpOx2GgKTNxIBdkN07b3mzdrwgueEzNSEPjB7XiV3BhyaF6NJdOLLQ7GQUAxRzy
         Lc4uBrl9ILU3JyCeQw5s7r8dlEpTQok8sNQBZOxYaCqydnqlVR1ARdAKzo8Kyz/wDDEO
         7Cq+5hr+JRPZYIIhKnl8CwEfyeKN91wu15vDylKtSVM5gPZsIXfAISXQgW8m9LxknXHp
         v8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FwnS7raatQida7H2CFe9qp4MAjUyBdHcORgJ6PWgqUw=;
        b=l1IqnaOoiEtXGeqmtOiDqhHrSbXthF1Jvj3OUkjr0oQLynaxjAUvU3Fo4gB4YOffZd
         ZzsqpWVmuv+qgAgqvuXkGghkTWKpWBfUWQ7HIVGW6isWt0BiVzJbFw3Mxa1unNGeu1s2
         dw5wFV7qwaA1EXi+Tms1grIZxD+uajV+CFME4zOHAjtTY1Wc34gYlVV0I7w20k+Mglzw
         u9rden5iYsnWQg7Ku7iwPBED4STVmXNUwq2EQ79J3/Lc4ixUK8O0XgtyEIuPtuST9VKR
         /SgSheUs1m/DZ6anQhL0IIltpLxbBL45qwWQlBkSkyi951WGcGui0A91AxDI/4gdqNpQ
         sMvw==
X-Gm-Message-State: APjAAAX89mjrC0rJEWFXAzg6wI5bJK/bXcNDSCbo9oQ7rBqOVksRxeN2
        Cbi+PDWMKSWJ20ggcZNiP4/TZaYh/qME6yk1QDA=
X-Google-Smtp-Source: APXvYqzP1RxfdsKNw9pW8Ehjii9Jtw2/sFYVRAqs2QF8LyqIifQ9oDd/1PxgSaZ9JptPmg/yJPgXwA1OFrk95pqGvno=
X-Received: by 2002:a37:785:: with SMTP id 127mr7831977qkh.437.1581273174941;
 Sun, 09 Feb 2020 10:32:54 -0800 (PST)
MIME-Version: 1.0
References: <20191212013521.1689228-1-andriin@fb.com> <CA+G9fYtAQGwf=OoEvHwbJpitcfhpfhy-ar+6FRrWC_-ti7sUTg@mail.gmail.com>
In-Reply-To: <CA+G9fYtAQGwf=OoEvHwbJpitcfhpfhy-ar+6FRrWC_-ti7sUTg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 9 Feb 2020 10:32:43 -0800
Message-ID: <CAEf4BzbEfuDNVr_gfEu13GvBAvdE1Qdw6nOxOJENzm69=iyUgg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Leo Yan <leo.yan@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 9, 2020 at 9:18 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 12 Dec 2019 at 07:05, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > This patch set fixes perf_buffer__new() behavior on systems which have some of
> > the CPUs offline/missing (due to difference between "possible" and "online"
> > sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> > perf_event only on CPUs present and online at the moment of perf_buffer
> > creation. Without this logic, perf_buffer creation has no chances of
> > succeeding on such systems, preventing valid and correct BPF applications from
> > starting.
> >
> > Andrii Nakryiko (4):
> >   libbpf: extract and generalize CPU mask parsing logic
> >   selftests/bpf: add CPU mask parsing tests
> >   libbpf: don't attach perf_buffer to offline/missing CPUs
>
> perf build failed on stable-rc 5.5 branch.
>
> libbpf.c: In function '__perf_buffer__new':
> libbpf.c:6159:8: error: implicit declaration of function
> 'parse_cpu_mask_file'; did you mean 'parse_uint_from_file'?
> [-Werror=implicit-function-declaration]
>   err = parse_cpu_mask_file(online_cpus_file, &online, &n);
>         ^~~~~~~~~~~~~~~~~~~
>         parse_uint_from_file
> libbpf.c:6159:8: error: nested extern declaration of
> 'parse_cpu_mask_file' [-Werror=nested-externs]
>
> build log,
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.5/DISTRO=lkft,MACHINE=hikey,label=docker-lkft/11/console
>

Thanks for reporting!

These changes depend on commit 6803ee25f0ea ("libbpf: Extract and
generalize CPU mask parsing logic"), which weren't backported to
stable. Greg, can you please pull that one as well? Thanks!

> --
> Linaro LKFT
> https://lkft.linaro.org
