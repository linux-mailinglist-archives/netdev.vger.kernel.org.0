Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21BD38B51E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhETRYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 13:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhETRYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 13:24:35 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC35C061574;
        Thu, 20 May 2021 10:23:13 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r8so23823770ybb.9;
        Thu, 20 May 2021 10:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hrfGNdJQviYTDIwq5pUkBSs0ZaBMgTRXGDnod5Fzc0=;
        b=KhegAMuT9sFAWj7axrgLKAaUtMgQ+9poV+P6OTsDOd7VrgwOJWp0EBjG8+p8BxYn5G
         h8j0cXcY2I93Aa6G2hk2E/GORIpWWrFfVklKMhFv6iVvGp3qPw/5FdU/MICi01s8VDYl
         QI+vLxMcYLDutOnZvETUeqMMAodNQDTuFbiJTZbeDzr0OttaWJ+jPyIZ8HEbIeU1PYm/
         2hiobsJLWkL52pP7Tk5tQHoUpVYYnxVdKnNq0Ncfe+Lm8/l+MeHtKwV7A6MDCcAqQWJs
         g6WZqaj4r4xLqFTT2qWCEZXMG8lWag3JPBKN2+q/mVMpFoWtdvpM74TS/gXI+Wq2+Gll
         tsJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hrfGNdJQviYTDIwq5pUkBSs0ZaBMgTRXGDnod5Fzc0=;
        b=pq9s5w3eTv/nKRXyPOkcZzBM9CAd+RjOTN8htq7KoDUqITSMlCPtTyAmISJu1GDM6M
         u6VA5OURPxSHaOMANwzICBF5QKV3I1NplF1UWgjzZbwnyhkOq2hyZQ7Lm4IPx8t49Hnb
         7n7Z128/kfUnJ8TKSGzI2Zc45ptN/HF+itSrsggGh6wg0vagrpa4oCnyheSA0KeVmWCq
         Gf1ouFR1VwPjwokpzRkHIjQjnL/+gxx8rCuoPxKBVVLTJzx/y01i/EIfz6XO61vntyR+
         LyzOJV82dPk9UTIb1j+5A3mK5GRjiDVv1YRwePWwAtTdeGLcNoVVAJzB0zQuKK9mUXdD
         yfCw==
X-Gm-Message-State: AOAM531tQhVoqbtPGlVh/egoCfqBh0SKWI6GFCjKn6Tvb8c8TzXcPC/0
        THy3/lo85kEr6roeMH/r9Oqjq5tob6XOJGMGTv7w5EjE
X-Google-Smtp-Source: ABdhPJzO32iRUOnxZkOFDn/AZEdv2T6RB6HUMeONEAaTqfy5AOpyGoZdXJGbe4j2onx6yFTAm3z61gyvGQ9BC5jpbdI=
X-Received: by 2002:a25:7246:: with SMTP id n67mr8682179ybc.510.1621531392491;
 Thu, 20 May 2021 10:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1621424513.git.asml.silence@gmail.com> <94134844a6f4be2e0da2c518cb0e2e9ebb1d71b0.1621424513.git.asml.silence@gmail.com>
 <CAEf4BzZU_QySZFHA1J0jr5Fi+gOFFKzTyxrvCUt1_Gn2H6hxLA@mail.gmail.com> <d86035d9-66f0-de37-42ef-8eaa4d849651@gmail.com>
In-Reply-To: <d86035d9-66f0-de37-42ef-8eaa4d849651@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 May 2021 10:23:01 -0700
Message-ID: <CAEf4BzbLPxNo--P7mCxS_miagFHF4fyoec1VOkpL=uY=oNqpVg@mail.gmail.com>
Subject: Re: [PATCH 18/23] libbpf: support io_uring
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 2:58 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 5/19/21 6:38 PM, Andrii Nakryiko wrote:
> > On Wed, May 19, 2021 at 7:14 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> >> ---
> >>  tools/lib/bpf/libbpf.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 4181d178ee7b..de5d1508f58e 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -13,6 +13,10 @@
> >>  #ifndef _GNU_SOURCE
> >>  #define _GNU_SOURCE
> >>  #endif
> >> +
> >> +/* hack, use local headers instead of system-wide */
> >> +#include "../../../include/uapi/linux/bpf.h"
> >> +
> >
> > libbpf is already using the latest UAPI headers, so you don't need
> > this hack. You just haven't synced include/uapi/linux/bpf.h into
> > tools/include/uapi/linux/bpf.h
>
> It's more convenient to keep it local to me while RFC, surely will
> drop it later.
>
> btw, I had a problem with find_sec_def() successfully matching
> "iouring.s" string with "iouring", because section_defs[i].len
> doesn't include final \0 and so does a sort of prefix comparison.
> That's why "iouring/". Can we fix it? Are compatibility concerns?

If you put "iouring.s" before "iouring" it will be matched first,
libbpf matches them in order, so more specific prefix should go first.
It is currently always treated as a prefix, not exact match,
unfortunately. I have a work planned to revamp this logic quite a bit
for libbpf 1.0, so this should be improved as part of that work.



>
> >
> >>  #include <stdlib.h>
> >>  #include <stdio.h>
> >>  #include <stdarg.h>
> >> @@ -8630,6 +8634,9 @@ static const struct bpf_sec_def section_defs[] = {
> >>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
> >>         BPF_EAPROG_SEC("sk_lookup/",            BPF_PROG_TYPE_SK_LOOKUP,
> >>                                                 BPF_SK_LOOKUP),
> >> +       SEC_DEF("iouring/",                     IOURING),
> >> +       SEC_DEF("iouring.s/",                   IOURING,
> >> +               .is_sleepable = true),
> >>  };
> >>
> >>  #undef BPF_PROG_SEC_IMPL
> >> --
> >> 2.31.1
> >>
>
> --
> Pavel Begunkov
