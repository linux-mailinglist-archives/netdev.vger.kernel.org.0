Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0CB297816
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755857AbgJWUJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755850AbgJWUJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 16:09:38 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D700C0613CE;
        Fri, 23 Oct 2020 13:09:38 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a12so2187893ybg.9;
        Fri, 23 Oct 2020 13:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=El7n9g9IpTwimcyLscJxzPdBa9Fjw65jnHGZIuOfetw=;
        b=mpiO8W3JtmvbbsTw4FUAY/0KxFsMKhIfYBR6nMRCap9YbNCFiOnqE1d5V81gESf51H
         k2Ijcn/mIs2eDuVHsDJwe+aAXK2nQsDtZXA3kbt09jU6smu3JKuKWH2+dVYULmYPslQU
         l+6XJd90WUBTTPs7ywvv3EKduTfiGWv6SrNZMYWGzkV4SwN49DGMNY5otWNgYF5PpE6O
         +kMXmAr0xdXvIaZAcrlOKXpHUoooBxAGecJiLybpbC3TEyNoOsX7XSJ/ZZNMwiIxvpvE
         7dpP8NvED35l5eNmoRm7H+simYYj4h6AvAvFpIsiWno3V1EaWvhWo8HdI7isrPe57ToR
         vsmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=El7n9g9IpTwimcyLscJxzPdBa9Fjw65jnHGZIuOfetw=;
        b=KPvKZrAR2f3tPpI64V8/Qreaq+nWaam2Dvb2SHMPZFgaeImjim36bBtJFBTYKyyDb0
         5EejjtMunXRU4buAy/8/BZS9MMMNJQmLgFfKTMhdpd+Ch6P7w1qcS1rV4pd7HoCMC2bp
         mPiQTSNaI+ONuBYN+pelLq+NIc/DkKWivk+WRE0Nkp9741vLxf6c0rLOck2gRk9oitLm
         7nn0WtQ8XxsmAEJpMM3B/uw3tqz6PMgghrflQe3eDI1W81ApLrTzUY7qV3nlHD71MK5+
         aOJByIfnbkZbSs5OexqjoYnEl0p8VHdGlev2VIV9q9ARvYY6SRagKpu25RXqzHIGLQBo
         2UVg==
X-Gm-Message-State: AOAM5328NY4gQGUaDOUHGWRQbkmA3SbrXtcF+3vsc6waGcxi1+wBWKl3
        vyiBe/SV47YVke9xRyrUZhiah0uWMybQsGnX898=
X-Google-Smtp-Source: ABdhPJzQTBaHueyXmOWVUtZIoo/MbRpCtwLzDXUGjyoVGwTQZGxDrNe6RqzjRV/xfBFDWH0/uOHl5UQaqE3FWrTJopA=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr6270924ybl.347.1603483777250;
 Fri, 23 Oct 2020 13:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201022082138.2322434-1-jolsa@kernel.org> <20201022082138.2322434-14-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-14-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Oct 2020 13:09:26 -0700
Message-ID: <CAEf4Bzbch2SGNwG-tTUT6pPdDCsFyGPbS1Zkx4f6-nLmcv+wOA@mail.gmail.com>
Subject: Re: [RFC bpf-next 13/16] libbpf: Add trampoline batch attach support
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 2:03 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding trampoline batch attach support so it's possible to use
> batch mode to load tracing programs.
>
> Adding trampoline_attach_batch bool to struct bpf_object_open_opts.
> When set to true the bpf_object__attach_skeleton will try to load
> all tracing programs via batch mode.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Assuming we go with the current kernel API for batch-attach, why can't
libbpf just detect kernel support for it and just use it always,
without requiring users to opt into anything?

But I'm also confused a bit how this is supposed to be used with BPF
skeleton. You use case described in a cover letter (bpftrace glob
attach, right?) would have a single BPF program attached to many
different functions. While here you are trying to collect different
programs and attach each one to its respective kernel function. Do you
expect users to have hundreds of BPF programs in their skeletons? If
not, I don't really see why adding this complexity. What am I missing?

Now it also seems weird to me for the kernel API to allow attaching
many-to-many BPF programs-to-attach points. One BPF program-to-many
attach points seems like a more sane and common requirement, no?


>  tools/lib/bpf/bpf.c      | 12 +++++++
>  tools/lib/bpf/bpf.h      |  1 +
>  tools/lib/bpf/libbpf.c   | 76 +++++++++++++++++++++++++++++++++++++++-
>  tools/lib/bpf/libbpf.h   |  5 ++-
>  tools/lib/bpf/libbpf.map |  1 +
>  5 files changed, 93 insertions(+), 2 deletions(-)
>

[...]
