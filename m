Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FE810EDE6
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 18:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfLBRJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 12:09:48 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:39597 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbfLBRJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 12:09:47 -0500
Received: by mail-qv1-f65.google.com with SMTP id y8so110641qvk.6;
        Mon, 02 Dec 2019 09:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fSLpCsC0gIfY0yNpzNg6ZYUHgfqDiFco3xCemoRy4iM=;
        b=JGT1wvi7Mxpe5wO3iuZdiTBowwcSDL2PV10ehqW5a71+rQ8d6L/dY66/rzqHw0LHX/
         c7m+7Pk7qw4vQMyyODN43cp4rn/eWqjSiRitTnp9UuhEV2AiWOxvSjc5fhm8RVH5N2Hy
         omEoeo4cuGcHsrI8I5WCS0BaJI0NUx9tTmFfyCLj+P9BW+QpohFNsNyxNB24J8OPEg2H
         W3QtFiQ5u5fixCsExbVo/A/D1FrCl8jd9HQVlCGvvneGeobDxcWpElppYnMMRTj/Ygkv
         TZUeONnst/mdYNJNa5+95qZ+v8u6J0WK+efkGQd5dgIMli9HQtFFuJNwZB0st2e6ejEU
         rLdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fSLpCsC0gIfY0yNpzNg6ZYUHgfqDiFco3xCemoRy4iM=;
        b=qX56gglAEv0ERKkxFSLlDNTbKUUbHkAisR8kvKT7n3J8iYCsompO0TOMR8706NRWS5
         m3mSB10B4cOO/AAB2joKYe8APQqNVD/euAE96EUC8XZS4N5YfapFH2Lvt77LE/pKQ7UY
         hUnI+TZX9lGCFiyvwKfzfqewFJw7eJ5HMdCZccwD7difyIpSOEB3LzknngyBl8dAZ3ch
         uMiv7/Vato3Gk58K8ugQrS18HWBcAgZC1XdYX3URU5uMiCEx4OqeTpi4v9ViiRUqnHM0
         In01SFHN3IrWhHazRUrOIhLu9ewgfoq3h00pmoBa12FYsrVYYIzrgYwI79cPUCcd64Kb
         OPRQ==
X-Gm-Message-State: APjAAAWCU8XqZdnh0neodgWx7xnBBNI9GKLaIqAr/UMZjwjPKOrCwwAm
        G7uP9cKrdxa79V0yKEl2qB4UKrfwU0M5hTVvrs0=
X-Google-Smtp-Source: APXvYqyKT6NO6KDsZ2ei5bKypY+iyosLPbJZy/xkL0hciZw1x+t08E3mYmWD+InttgZD7tNu/S5UBmrc2HpBRhRWSwc=
X-Received: by 2002:a05:6214:38c:: with SMTP id l12mr1561456qvy.224.1575306584723;
 Mon, 02 Dec 2019 09:09:44 -0800 (PST)
MIME-Version: 1.0
References: <20191127094837.4045-1-jolsa@kernel.org>
In-Reply-To: <20191127094837.4045-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 09:09:33 -0800
Message-ID: <CAEf4BzbUK98tsYH1mSNoTjuVB4dstRsL5rpkA+9nRCcqrdn6-Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf/bpftool: Allow to link libbpf dynamically
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 1:49 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> adding support to link bpftool with libbpf dynamically,
> and config change for perf.
>
> It's now possible to use:
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1

I wonder what's the motivation behind these changes, though? Why is
linking bpftool dynamically with libbpf is necessary and important?
They are both developed tightly within kernel repo, so I fail to see
what are the huge advantages one can get from linking them
dynamically.

>
> which will detect libbpf devel package with needed version,
> and if found, link it with bpftool.
>
> It's possible to use arbitrary installed libbpf:
>   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tmp/libbp=
f/
>
> I based this change on top of Arnaldo's perf/core, because
> it contains libbpf feature detection code as dependency.
> It's now also synced with latest bpf-next, so Toke's change
> applies correctly.
>
> Also available in:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   libbpf/dyn
>
> thanks,
> jirka
>
>
> ---
> Jiri Olsa (2):
>       perf tools: Allow to specify libbpf install directory
>       bpftool: Allow to link libbpf dynamically
>
> Toke H=C3=B8iland-J=C3=B8rgensen (1):
>       libbpf: Export netlink functions used by bpftool
>
>  tools/bpf/bpftool/Makefile        | 40 +++++++++++++++++++++++++++++++++=
++++++-
>  tools/build/feature/test-libbpf.c |  9 +++++++++
>  tools/lib/bpf/libbpf.h            | 22 +++++++++++++---------
>  tools/lib/bpf/libbpf.map          |  7 +++++++
>  tools/lib/bpf/nlattr.h            | 15 ++++++++++-----
>  tools/perf/Makefile.config        | 27 ++++++++++++++++++++-------
>  6 files changed, 98 insertions(+), 22 deletions(-)
>
