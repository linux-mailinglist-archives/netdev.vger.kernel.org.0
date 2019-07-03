Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E29D5E8D7
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 18:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfGCQ1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 12:27:32 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33794 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCQ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 12:27:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id t8so3272524qkt.1;
        Wed, 03 Jul 2019 09:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3O8MIvHwppn/d17rmSCE8fE7QPikq6qOR3fFFJEnJRM=;
        b=iP1BHGWuavdISChR6Cxaz/ZXA47gDSFA1qlodCskiCc2Cl9dJ8DnCwsMG24/Eojo58
         DSrrlQyt3H5ZIBxF54wcUsEYyfCEKPLLUcs19AD2sCPEnoGd9VDQVSZSf4ZjzTnpzHdI
         WmegdtrYhhJyZaH5/bIkdlhIk3YTSsX+Oo15yZJIAImAlwPdPY9LG85U6EVxi/3lF/+C
         /is9A+JFi7Y9kuF82HIDWT1/ZD9+v3f3RSqYjFhv6H1zL6BeJq8COhnxF0PTen3UUucf
         /CaOCJKWe9vv/YbppdLlSVWNLPKyzcY+a8SUHaJIIfzVvDMHnPl8z2Od9soPy9xAtD00
         z8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3O8MIvHwppn/d17rmSCE8fE7QPikq6qOR3fFFJEnJRM=;
        b=IeIaOLyM2r9EB4u811U36VPTTrmvWPSIDu2vRgBZL8hIU5h/72QJRcjQesGzb6EV9O
         jZlcBzUnY/G65XfywONPHqqpQ34IC97LqNjH1T3qxkAcdfEoK/2VwUl7+97dOyOUc6GD
         lw9WrOiGRrKjZjL8wYLtMU6rF/jq5ZJqIEPbJ8B2bX+AEpAks/PzC7RbHjKGUZUjkd6o
         aQDfYhoiZo+0vOkOuzMTqQHvBg0ZtCtJF9VfS7ufEfNEbLRkSZaAFl1TZEypXkSJ1t0y
         LFaKgbpP1FHJSHDDkAGyJrt4ByyqXXGLtInY/9cLzmgRMrQ/snyBah48Psh6+XdvzoeE
         HeFA==
X-Gm-Message-State: APjAAAXvRhCCRi5BZCjTRgHYNEQ9h9fEk0Bb2sRKJ461TN9onHQySeie
        0uza1jhUZoQWbwjtge6+Ii7UVFxV8jVO+3k0nTAU74w4CGU=
X-Google-Smtp-Source: APXvYqxICTCVw71uszF8HeZ9XozuvwxBDnxT95AHURZnw9DENkz1Z/YGVoMeA5WguTW5ad4z1RlFcAKUo2u0eCgIgsY=
X-Received: by 2002:a37:660d:: with SMTP id a13mr3408464qkc.36.1562171248925;
 Wed, 03 Jul 2019 09:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190630065109.1794420-1-andriin@fb.com> <5a48c2f1-2abc-2deb-6863-c9f20e4ac03b@iogearbox.net>
In-Reply-To: <5a48c2f1-2abc-2deb-6863-c9f20e4ac03b@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Jul 2019 09:27:17 -0700
Message-ID: <CAEf4BzYRAAqJAS9UuOAcnmeZegRzV3ygBWfqoy-LW-8qOgAqqg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/4] libbpf: add perf buffer abstraction and API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 2:36 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/30/2019 08:51 AM, Andrii Nakryiko wrote:
> > This patchset adds a high-level API for setting up and polling perf buffers
> > associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
> > described in corresponding commit.
> >
> > Patch #1 adds a set of APIs to set up and work with perf buffer.
> > Patch #2 enhances libbpf to support auto-setting PERF_EVENT_ARRAY map size.
> > Patch #3 adds test.
> > Patch #4 converts bpftool map event_pipe to new API.
> >
> > v3->v4:
> > - fixed bpftool event_pipe cmd error handling (Jakub);
> >
> > v2->v3:
> > - added perf_buffer__new_raw for more low-level control;
> > - converted bpftool map event_pipe to new API (Daniel);
> > - fixed bug with error handling in create_maps (Song);
> >
> > v1->v2:
> > - add auto-sizing of PERF_EVENT_ARRAY maps;
> >
> > Andrii Nakryiko (4):
> >   libbpf: add perf buffer API
> >   libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
> >   selftests/bpf: test perf buffer API
> >   tools/bpftool: switch map event_pipe to libbpf's perf_buffer
> >
> >  tools/bpf/bpftool/map_perf_ring.c             | 201 +++------
> >  tools/lib/bpf/libbpf.c                        | 397 +++++++++++++++++-
> >  tools/lib/bpf/libbpf.h                        |  49 +++
> >  tools/lib/bpf/libbpf.map                      |   4 +
> >  .../selftests/bpf/prog_tests/perf_buffer.c    |  94 +++++
> >  .../selftests/bpf/progs/test_perf_buffer.c    |  29 ++
> >  6 files changed, 630 insertions(+), 144 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c
>
> Hm, set looks good, but this does not apply cleanly. Please rebase against
> bpf-next and resubmit. Please also update tools/lib/bpf/README.rst with regards
> to the perf_buffer__ prefix. While at it, you could also address Jakub's comment.

Yeah, I forgot to mention that in cover letter: this patchset is using
APIs added in my other patch set (tracing APIs), so that one has to go
in first. I'll wait for it to land and will update and post v5,
updating README and initializing ops (Jakub's feedback). Thanks!

>
> Thanks,
> Daniel
