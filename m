Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7814335D
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgATVWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:22:11 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:35321 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgATVWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:22:11 -0500
Received: by mail-ua1-f67.google.com with SMTP id y23so213148ual.2;
        Mon, 20 Jan 2020 13:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s04oBBLWi5GYfL5yePu4o49joKdSdNKGOQzWwq1iiEw=;
        b=rj9mxDB2UIn3UsYDHuA4JVe0KfUq/tCMKUyNUMvNGmFt+td05zebWnHBaVWy5CoKAa
         1RClvz9KDMxHR2EN606rKCHfBH3LhK1jGpGZ2+rJmJZUABeCICgt2doT+Xdbll3RxBz0
         wH1W0bR9xtmPanwPsK/vvA0S7yHlVKn6v5wPuBomv81eOjiB9tajYzusnbUVHEA8uHRu
         pWq6yg3MfUdTZrVJvzAUVS8jUnMAkGOtueDZFwJT56pNQu1ZIzfPAreVHvCVF6kBPOkR
         6A2XWuK5BDFXdvepLqiQwTVhZE2FKquRHbeJWPMp/RuSsfEz3hVGVnJDDBz0ky0JWerx
         wFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s04oBBLWi5GYfL5yePu4o49joKdSdNKGOQzWwq1iiEw=;
        b=hu402UwYFz/fnQCYztGBfItom+7HDX3y6k9XOPbzpa1dBXzlcoSAGe0aFRl+8gv46+
         sFCVBD5ggQP/fHAQxPJmxZbMxMAo6j6PA+u5Ikx3rxEl1Db5/AlO27JNBa0XD60BneyE
         OYVOlGKthf2MdP32HceRYczECX8rPtJ6i5r+3RZso4IGQ7extj8+JBU0dxIEyjT0uYms
         CoiI+TgNSnmu/PTNSL8RAPwYuPUca57mvonRWHmh3Ju05mxkGAcTpgvq8E2gIB0OkIsU
         YYY5/dJ+2yXvpKno2thkS4mazRyIuc7TS1/7Ab0OwkbH5F7ksFgqNo3kDS9mhU5DyFF3
         a1/Q==
X-Gm-Message-State: APjAAAXg/CPGQ9Ty7AHwRZZ3oP/zbXn+PpO7Lcs78Of7SoqNqiZyMUuu
        8zSV8k6lUy83eXRXHHTmxkwJb3yFBS70C9K+yxY=
X-Google-Smtp-Source: APXvYqwQsgXhbioyjpp1NS35YuOlfwrx7giGtd1yaaSJEBJ/OCEifpRXDqBAwylE0FRcWVvVR4BaZqBBccFmGPhe9io=
X-Received: by 2002:ab0:1006:: with SMTP id f6mr1240994uab.94.1579555330108;
 Mon, 20 Jan 2020 13:22:10 -0800 (PST)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <5e23c773d7a67_13602b2359ea05b824@john-XPS-13-9370.notmuch>
 <CAGyo_hrUXWzui9FNiZpNGXjsphSreLEYYm4K7xkp+H+de=QKSA@mail.gmail.com>
 <CAGyo_hpcO-f9uxQFDfKZNz=1t6Yux+LzxN1qLHKf6PXMAtWQ-w@mail.gmail.com> <360a11cd-2c41-159e-b92a-c7c1ec42767f@iogearbox.net>
In-Reply-To: <360a11cd-2c41-159e-b92a-c7c1ec42767f@iogearbox.net>
From:   Matt Cover <werekraken@gmail.com>
Date:   Mon, 20 Jan 2020 14:21:58 -0700
Message-ID: <CAGyo_hpPEBm1qJ+PB_5DBpuyUzZSgXXsF34iC-mLxq9o9-Kt=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jiong Wang <jiong.wang@netronome.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 2:11 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/20/20 9:10 PM, Matt Cover wrote:
> > On Mon, Jan 20, 2020 at 11:11 AM Matt Cover <werekraken@gmail.com> wrote:
> >> On Sat, Jan 18, 2020 at 8:05 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >>> Matthew Cover wrote:
> >>>> Allow looking up an nf_conn. This allows eBPF programs to leverage
> >>>> nf_conntrack state for similar purposes to socket state use cases,
> >>>> as provided by the socket lookup helpers. This is particularly
> >>>> useful when nf_conntrack state is locally available, but socket
> >>>> state is not.
> >>>>
> >>>> Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
> >>>> ---
> >>>
> >>> Couple coding comments below. Also looks like a couple build errors
> >>> so fix those up. I'm still thinking over this though.
> >>
> >> Thank you for taking the time to look this over. I will be looking
> >> into the build issues.
> >
> > Looks like I missed static inline on a couple functions when
> > nf_conntrack isn't builtin. I'll include the fix in v2.
>
> One of the big issues I'd see with this integration is that literally no-one
> will be able to use it unless they manually recompile their distro kernel with
> ct as builtin instead of module .. Have you considered writing a tcp/udp ct in
> plain bpf? Perhaps would make sense to have some sort of tools/lib/bpf/util/
> with bpf prog library code that can be included.

I don't believe the builtin requirement is permanent. Currently, that
requirement comes from an undefined reference to
nf_conntrack_find_get() during linking. As a future improvement, I am
planning to propose a function pointer which ct_lookup() uses. The
kernel proper would point this to an always NULL stub. nf_conntrack
would populate to the real function when builtin or when loaded as a
module.

If there is a better way to solve the kernel proper using an exported
symbol provided by a module, I'd be happy to hear of it.
