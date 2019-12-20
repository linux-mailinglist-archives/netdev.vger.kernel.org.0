Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706EF12819D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLTRrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:47:12 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36244 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLTRrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:47:12 -0500
Received: by mail-qk1-f193.google.com with SMTP id a203so8669728qkc.3;
        Fri, 20 Dec 2019 09:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E0Z53j9US/Ru8iPxRBY/NIhx3B+IYvteyqpQ3CuGhOo=;
        b=Rd2LZLv7Bkzvgesea2+QtQp3UwfE9wQuv4o6XcIiChtnjFMUjFJEVLCBC51v6RpujG
         Ko4Oj9ITBFdAmSMbr7AK+dzDPd2aBlzG2nTvsPdnY5tt/YsHrs0tr8yWeqBrbvLGQFvv
         FS7NtAuNPu7mahVP4hLZhEQxjcY7Sb2P9IB3pEBU1tG5xCqmh2QCFCbMRs4AArIkJIvj
         kAUx6uL80zm3UDQ6uokUbSkTEU/DXJmE68F7QAwu7kfe3eUVkB/EVwdiU48yKnLmHefu
         7TuyTGg4DEQxPOJDQZx/6PPWxqWsFE6uNI9BYS/YYRYO5kVhhGVj2PyVV0m+cPqXD8Fu
         6jmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0Z53j9US/Ru8iPxRBY/NIhx3B+IYvteyqpQ3CuGhOo=;
        b=eiqMzF9ooJIEdcIuxlEezDN35gdnatEXb+T0ctHLygHEgvl5k/oPL1UCbaCSYp8YI2
         DeDMn6a8r4NwFv6E5GYL2jsXHA27F4WVeVexJdXQVaVI/xGbBY7DlFM2IGjcRLyapqYh
         Scf05Pboz5/IECOIYU5xnhT4C/T6ddZQ70nnqFIxvAOQ/6rbfCB/IKjUVU7b1OZH9PCR
         gd54PfZhsFPxJeRxEsl99x7p3jlpIHPnvFKvPzKZm1F6QWwvnNwKpkHpYj+gxoXuM0Q7
         E35VO0E5gWzIno74FinUCzZJhtOr9QeCEgclJNtOmorU2x2oZSp/hIXLW3Shqijjc20d
         zdxQ==
X-Gm-Message-State: APjAAAVrR7Gg1k3Pa0Mzwwm65XRnWBB8xsrv5ZbR64Q+OTih+e+qjFbt
        vD+E+Zrat5G7sq/jYhnV9kuraHbHCVOxzFrOjwemaD9X
X-Google-Smtp-Source: APXvYqy/Ff5zxO8Bf+NTZiZZOfrlHbbem6saNBk/jEiPCqi9MvFB4i4dZAwhQ9+CYXSPIlYxQP6T4ERsUxQJdaUCWLo=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr14909350qkq.437.1576864030972;
 Fri, 20 Dec 2019 09:47:10 -0800 (PST)
MIME-Version: 1.0
References: <20191212013521.1689228-1-andriin@fb.com> <20191216144404.GG14887@linux.fritz.box>
 <CAEf4BzYhmFvhL_DgeXK8xxihcxcguRzox2AXpjBS1BB4n9d7rQ@mail.gmail.com> <dfb31c60-3c8c-94a2-5302-569096428e9b@iogearbox.net>
In-Reply-To: <dfb31c60-3c8c-94a2-5302-569096428e9b@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 09:46:59 -0800
Message-ID: <CAEf4Bza2kyMQLiDnkzDi-82xShEiUY2zrre=MJdedZet4g=o7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/4] Fix perf_buffer creation on systems with
 offline CPUs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 5:00 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/16/19 6:59 PM, Andrii Nakryiko wrote:
> > On Mon, Dec 16, 2019 at 6:44 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On Wed, Dec 11, 2019 at 05:35:20PM -0800, Andrii Nakryiko wrote:
> >>> This patch set fixes perf_buffer__new() behavior on systems which have some of
> >>> the CPUs offline/missing (due to difference between "possible" and "online"
> >>> sets). perf_buffer will create per-CPU buffer and open/attach to corresponding
> >>> perf_event only on CPUs present and online at the moment of perf_buffer
> >>> creation. Without this logic, perf_buffer creation has no chances of
> >>> succeeding on such systems, preventing valid and correct BPF applications from
> >>> starting.
> >>
> >> Once CPU goes back online and processes BPF events, any attempt to push into
> >> perf RB via bpf_perf_event_output() with flag BPF_F_CURRENT_CPU would silently
> >
> > bpf_perf_event_output() will return error code in such case, so it's
> > not exactly undetectable by application.
>
> Yeah, true, given there would be no element in the perf map at that slot, the
> program would receive -ENOENT and we could account for missed events via per
> CPU map or such.
>
> >> get discarded. Should rather perf API be fixed instead of plain skipping as done
> >> here to at least allow creation of ring buffer for BPF to avoid such case?
> >
> > Can you elaborate on what perf API fix you have in mind? Do you mean
> > for perf to allow attaching ring buffer to offline CPU or something
> > else?
>
> Yes, was wondering about the former, meaning, possibility to attach ring buffer
> to offline CPU.

This sounds like a more heavy-weight fix, I'll put it on backburner
for now and will look at perf code when I get a chance to see if/how
it's possible.

>
> >>> Andrii Nakryiko (4):
> >>>    libbpf: extract and generalize CPU mask parsing logic
> >>>    selftests/bpf: add CPU mask parsing tests
> >>>    libbpf: don't attach perf_buffer to offline/missing CPUs
> >>>    selftests/bpf: fix perf_buffer test on systems w/ offline CPUs
> >>>
> >>>   tools/lib/bpf/libbpf.c                        | 157 ++++++++++++------
> >>>   tools/lib/bpf/libbpf_internal.h               |   2 +
> >>>   .../selftests/bpf/prog_tests/cpu_mask.c       |  78 +++++++++
> >>>   .../selftests/bpf/prog_tests/perf_buffer.c    |  29 +++-
> >>>   4 files changed, 213 insertions(+), 53 deletions(-)
> >>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c
> >>>
> >>> --
> >>> 2.17.1
> >>>
>
