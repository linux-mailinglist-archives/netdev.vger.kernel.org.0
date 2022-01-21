Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FA4496511
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382132AbiAUSbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382138AbiAUSbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:31:12 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16731C06173D;
        Fri, 21 Jan 2022 10:31:12 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id o10so8416456ilh.0;
        Fri, 21 Jan 2022 10:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RosCskWkdt9rxG/Kn964mKmVE3e+ONowkWWNdWq2eU=;
        b=WZxNZciYsovV1h2ayaikh9Jgy/b9nmUKn/GF2pyVnUpEmgikDCEWHt/fQ49tTBak2C
         CzD07FGtY9d56lNjj9oovqBZcgCe6jjYExx/0yDsK3z3w/4ghXTLAVyvRUN2myRSsp4h
         TrsBfeBIKl3KULenDa5fmMMEpFZui8b3Iw+pxe6tF/ukyonDMcE7Ae1fnTXpJnBVG+kJ
         c1AO2B8QRmQZcSKcbdaQM/KKf2hXpWxlD3fDjY977uPkin6SyZSeTaDTmsJUqzPU1pu4
         Ze2yOb9ykMHnStoEsJmd5wLAvzv4ttAeJd18DtYVDIpZKSvc+EzHTe2hRKjZkgSm+1FE
         6Lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RosCskWkdt9rxG/Kn964mKmVE3e+ONowkWWNdWq2eU=;
        b=bQd8haz00y0ZrKOyRseeucG6sd1Db1rxd/SE1W00oUXGshXaS/CXwMZ7Goz13RlM0/
         p/fSRggLRfwf4nvHEZqZqz/VoQ4FOPbVyngeag+WnRhAElLQbq5mDlJ3D2wwZhu+VPz6
         MYlGWb1XBOmp52ai2XoOFGpZyQuycvihL7nqB0NyGu1YbYWyqV9u5LsiK+OIt0gRIkOM
         SfpPuymMP0xTay5kMEt5Zdx2Ywjo8Jy5BwcD/gNvsyxaHNVf29UAU57/08lqVtXQsqpm
         TVpV9yf1F5DBcFCXGerJYpWs4heVVhgZOqtJjMIkb2EGK799EvwNmi2obSWCiPW6uuPD
         k62w==
X-Gm-Message-State: AOAM533WAR0JfK+q8UIkhIeHyW83j+IXqV4S6MLWLXhMFzpem0RDRG6U
        y0e68TbTp/0t5JBbtMqKfmF3sYwXJei2N7DT0L8=
X-Google-Smtp-Source: ABdhPJxSWA27NWAnAj0jlHUI7cKQDQkUxNDLI6I1Kg1bkjWhmPS2GhRYr1675hwEJJXODWWGRB+RCTzbZ7Gv1hKHJqA=
X-Received: by 2002:a05:6e02:1749:: with SMTP id y9mr2732285ill.252.1642789871449;
 Fri, 21 Jan 2022 10:31:11 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 10:31:00 -0800
Message-ID: <CAEf4BzbG8Rx1NXiHQrsnJdXMPmW_VQ9CCJDe9Gf9FWv3Q7vtnA@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/3] libbpf: name-based u[ret]probe attach
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

On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> This patch series is a refinement of the RFC patchset [1], focusing
> on support for attach by name for uprobes and uretprobes.  Still
> marked RFC as there are unresolved questions.
>
> Currently attach for such probes is done by determining the offset
> manually, so the aim is to try and mimic the simplicity of kprobe
> attach, making use of uprobe opts to specify a name string.
>
> uprobe attach is done by specifying a binary path, a pid (where
> 0 means "this process" and -1 means "all processes") and an
> offset.  Here a 'func_name' option is added to 'struct uprobe_opts'
> and that name is searched for in symbol tables.  If the binary
> is a program, relative offset calcuation must be done to the
> symbol address as described in [2].
>
> Having a name allows us to support auto-attach via SEC()
> specification, for example
>
> SEC("uprobe/usr/lib64/libc.so.6/malloc")
>
> Unresolved questions:
>
>  - the current scheme uses
>
> u[ret]probe[/]/path/2/binary/function[+offset]

that / after uprobe is not optional. This should be parsed as
"uprobe/<path-to-binary>/<func_name>[+<offset>]", in general. If
<path-to-binary> doesn't have leading '/' it will be just treated as a
relative path. Otherwise it's going to be ambiguous. So with your
example SEC("uprobe/usr/lib64/libc.so.6/malloc") you are specifying
"usr/lib64/libc.so.6", relative path, which is wrong. It has to be
SEC("uprobe//usr/lib64/libc.so.6/malloc"), however ugly that might
look.

>
>    ...as SEC() format for auto-attach, for example
>
> SEC("uprobe/usr/lib64/libc.so.6/malloc")
>
>    It would be cleaner to delimit binary and function with ':'
>    as is done by bcc.  One simple way to achieve that would be
>    to support section string pre-processing, where instances of
>    ':' are replaced by a '/'; this would get us to supporting
>    a similar probe specification as bcc without the backward
>    compatibility headaches.  I can't think of any valid
>    cases where SEC() definitions have a ':' that we would
>    replace with '/' in error, but I might be missing something.

I think at least for separating path and function name using ':' is
much better. I'd go with

SEC("uprobe//usr/lib64/libc.so.6:malloc")

for your example

>
>  - the current scheme doesn't support a raw offset address, since
>    it felt un-portable to encourage that, but can add this support
>    if needed.

I think for consistency with kprobe it's good to support it. And there
are local experimentation situations where this could be useful. So
let's add (sscanf() is pretty great at parsing this anyways)

>
>  - The auto-attach behaviour is to attach to all processes.
>    It would be good to have a way to specify the attach process
>    target. A few possibilities that would be compatible with
>    BPF skeleton support are to use the open opts (feels kind of
>    wrong conceptually since it's an attach-time attribute) or
>    to support opts with attach pid field in "struct bpf_prog_skeleton".
>    Latter would even allow a skeleton to attach to multiple
>    different processes with prog-level granularity (perhaps a union
>    of the various attach opts or similar?). There may be other
>    ways to achieve this.

Let's keep it simple and for auto-attach it's always -1 (all PIDs). If
that's not satisfactory, user shouldn't use auto-attach. Skeleton's
auto-attach (or bpf_program__attach()) is a convenience feature, not a
mandatory step.

>
> Changes since RFC [1]:
>  - focused on uprobe entry/return, omitting USDT attach (Andrii)
>  - use ELF program headers in calculating relative offsets, as this
>    works for the case where we do not specify a process.  The
>    previous approach relied on /proc/pid/maps so would not work
>    for the "all processes" case (where pid is -1).
>  - add support for auto-attach (patch 2)
>  - fix selftests to use a real library function.  I didn't notice
>    selftests override the usleep(3) definition, so as a result of
>    this, the libc function wasn't being called, so usleep() should
>    not be used to test shared library attach.  Also switch to
>    using libc path as the binary argument for these cases, as
>    specifying a shared library function name for a program is
>    not supported.  Tests now instrument malloc/free.
>  - added selftest that verifies auto-attach.
>
> [1] https://lore.kernel.org/bpf/1642004329-23514-1-git-send-email-alan.maguire@oracle.com/
> [2] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html
>
> Alan Maguire (3):
>   libbpf: support function name-based attach for uprobes
>   libbpf: add auto-attach for uprobes based on section name
>   selftests/bpf: add tests for u[ret]probe attach by name
>
>  tools/lib/bpf/libbpf.c                             | 259 ++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h                             |  10 +-
>  .../selftests/bpf/prog_tests/attach_probe.c        | 114 +++++++--
>  .../selftests/bpf/progs/test_attach_probe.c        |  33 +++
>  4 files changed, 396 insertions(+), 20 deletions(-)
>
> --
> 1.8.3.1
>
