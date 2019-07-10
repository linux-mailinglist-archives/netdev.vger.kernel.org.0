Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DFD64BDA
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfGJSFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:05:13 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39346 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbfGJSFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:05:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id l9so3429706qtu.6;
        Wed, 10 Jul 2019 11:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lG0qUUr5/Z/mwUfmND13kN55kIlfQbjEMe/rizbF9b8=;
        b=qvIRVpv0FO+/41p1JnXFbAQCUMHzxeWRDejDgBibVnhYyAehG1T/sqerngar3rVwKf
         c2AFzj9oGfzZsI2KWemKU/hwgp7qAbxa/R1vz9FrrZHeEiQlxerQz96M9tQ5FER4iEZe
         0Jruwq4Hkx8yj/gF8c9Ii8lVoW424mkcF1Hf02OPqWM/5LXEXF2yjz2ggstZXpKDudvt
         ML5xWnWRCozCH4flZlikr3A36I9nGqtbk7/3qcPSlg0SIK7QqOpJD1B7OYOPPSk+j51U
         zVBssBKkn2TV7NDbfSabj3f6JxSsy+3609XW/iqQJMFIPzUGdxYQjHP2ZHHyrfIwPIbp
         gv9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lG0qUUr5/Z/mwUfmND13kN55kIlfQbjEMe/rizbF9b8=;
        b=Af4kNVtsiRVOIWJ89p8m1cVU3diuHhdHcQ1qQhpp0gPQiebhLy8eFT54ijCpsDuRlk
         HDCHmtC60vnv4Moahhl9KLlwyAmWaKFGtpCYXozDrRoc2ofaeIidgzGxFryybJ2K15JQ
         v+FBbEuYoosSQwJkLkVWppzeSqGqyT0IOLRyic8zpqxA7gMyQf5DKb9BK9bMOR4dD9uT
         UKeyCZKRHW3BsHybc5Lvn+aUM2sHCESoEftlvqhDQc0Hx6W+E4nG7bPfevArpKvPXTp4
         t4GNAbUrqqsIXrs66RJYJ/mYq4sR7QOgx3XZ5Vt7AFiiluuxkEVHl0sGuWK91Cswdk6Q
         1aUA==
X-Gm-Message-State: APjAAAUe9hqVN6hVF6vdSWVzJi4cpyjXE9W70Shd2KqWyPpV/eNaavV7
        1x/DrldgEfdYZXGmqjgaJkQwo1UG0aO+sBdh+ag=
X-Google-Smtp-Source: APXvYqzHaFJKtRl+rv/gz7gP4RVht6WJ2jWi6kNLPvhpttOU3IAXT0r2exFcmKdbHuKmGQBjWs7mrUWrcJI0bSa3u0U=
X-Received: by 2002:a05:6214:1306:: with SMTP id a6mr26429977qvv.38.1562781911655;
 Wed, 10 Jul 2019 11:05:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190709180005.33406-1-allanzhang@google.com>
In-Reply-To: <20190709180005.33406-1-allanzhang@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 11:05:00 -0700
Message-ID: <CAEf4BzYbOCYUsgAtOcUwO7_rFosfdhBPPLpq5ppj=f5foGWHzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 0/2] bpf: Allow bpf_skb_event_output for more
 prog types
To:     Allan Zhang <allanzhang@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 11:03 AM Allan Zhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>
> More prog types are enabled to access bpf_skb_event_output in this
> patch.
>
> v8 changes:
> No actual change, just cc to netdev@vger.kernel.org and
> bpf@vger.kernel.org.
> v7 patches are acked by Song Liu.

You forgot to include Song's Acked-by into your patch commit messages. Just add

Acked-by: Song Liu <songliubraving@fb.com>

to both patches after your Signed-off-by.

>
> v7 changes:
> Reformat from hints by scripts/checkpatch.pl, including Song's comment
> on signed-off-by name to captical case in cover letter.
> 3 of hints are ignored:
> 1. new file mode.
> 2. SPDX-License-Identifier for event_output.c since all files under
>    this dir have no such line.
> 3. "Macros ... enclosed in parentheses" for macro in event_output.c
>    due to code's nature.
>
> Change patch 02 subject "bpf:..." to "selftests/bpf:..."
>
> v6 changes:
> Fix Signed-off-by, fix fixup map creation.
>
> v5 changes:
> Fix typos, reformat comments in event_output.c, move revision history to
> cover letter.
>
> v4 changes:
> Reformating log message.
>
> v3 changes:
> Reformating log message.
>
> v2 changes:
> Reformating log message.
>
> Allan Zhang (2):
>   bpf: Allow bpf_skb_event_output for a few prog types
>   selftests/bpf: Add selftests for bpf_perf_event_output
>
>  net/core/filter.c                             |  6 ++
>  tools/testing/selftests/bpf/test_verifier.c   | 12 ++-
>  .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
>  3 files changed, 111 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
