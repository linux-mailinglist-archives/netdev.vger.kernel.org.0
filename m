Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8790636BC03
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhDZXVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhDZXU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 19:20:59 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BB3C061574;
        Mon, 26 Apr 2021 16:20:16 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p202so23357953ybg.8;
        Mon, 26 Apr 2021 16:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ragf3pBBuOEv+S1+l8phR3UOvi6C6PkqHckvqRYzvXY=;
        b=UK7IhNV1heUyIiPLGQUdXqP1iNOhkcz769U45fdE85RdnUk2FAjb8aW+W1AmVMSvuf
         EZiT5yhc9Jtm4IHvlZAiHGqo+ugl8OS3FiXv6MkU6dLvmif+V5Qjr0M+P2ZK8dkPLC0+
         6cHoINCbovh6Y/r0IiKjijjnw/+wWXPdGNABIN0n6lniXrXHKWfEkSFgKhTeWuzBduHt
         Y1ZMWNBzrPlOgcPp4TUp5eftd3GAnnthHKBN6BYwtV4ZQ9+6nn/en0CcXYQCJrGveY+S
         o/nTPRsqLtTvNJsGAynEak50S3Kc3E8cBtiRbwPfZMa40wGoHvRaOaHCOxCUZpQMQqWB
         8Iig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ragf3pBBuOEv+S1+l8phR3UOvi6C6PkqHckvqRYzvXY=;
        b=b41xCATx9kPMrhwd5GYwm41PN5vhHK0Q7x4uxa71y44FrFgfOEnWlR3SvEAxBFfvrM
         cIv0Q2JFoNcphdkxiCmnrDcGYMwdoQ/jGuVvxdVH5lbptdYBpnRauIApMlT//Z2SMS++
         CW1SHhHstUqcYSi4/xh1khT+171IZVxJGaKenOEFq6Ucw+Zyy14F7ZCbqUnXPEZg9GIX
         jWIMgnK3ZoAhi1uEjVBQPt6LTURoYdRAiZID2yQLh9DDJzVpFJ+h+HK6/YX0quxB+UX1
         3NYzQH4SNhNjjW9Qyq4QOTxwY9LnYZylhhBsIlc7Bs10o6Dh1Zlu4hPATKlZAhzDJtiB
         JUgg==
X-Gm-Message-State: AOAM531+Nj5gEMBLEQgi869fPVLMtEfx567G+Yj2HkvH6KL/HPUERw92
        iFqMCBgo9Nmzocgv+UW1cYf8ZQoNB8nnK5SQxgc=
X-Google-Smtp-Source: ABdhPJxxx6uaPeIb83QO/9C/e3b9O2PSHVMqC27f7E+0oQ3+5OTLmYpDmFNq+ECvYhiV9fWDhEuc4qgvehmposIQaYU=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr28538624ybf.425.1619479216354;
 Mon, 26 Apr 2021 16:20:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210426202240.518961-1-memxor@gmail.com>
In-Reply-To: <20210426202240.518961-1-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 16:20:04 -0700
Message-ID: <CAEf4BzaDbVpLvbOnkTKtzHVGq74TfBprLuZ6fJtYqJ+jFZN+Gw@mail.gmail.com>
Subject: Re: [PATCH] libbpf: export inline helpers as symbols for xsk
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 1:22 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This helps people writing language bindings to not have to rewrite C
> wrappers for inline functions in the headers. We force inline the
> definition from the header for C and C++ consumers, but also export a
> symbol in the library for others. This keeps the performance
> advantages similar to using static inline, while also allowing tools
> like Rust's bindgen to generate wrappers for the functions.
>
> Also see
> https://lore.kernel.org/bpf/CAJ8uoz0QqR97qEYYK=VVCE9A=V=k2tKnH6wNM48jeak2RAmL0A@mail.gmail.com/
> for some context.
>
> Also see https://github.com/xdp-project/xdp-tools/pull/97 for more
> discussion on the same.
>
> extern inline is used as it's slightly better since it warns when an
> inline definition is missing.
>
> The fvisibility attribute goes on the inline definition, as essentially
> it acts as a declaration for the function, while the extern inline
> declaration ends up acting as a definition.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---

xsk is moving into libxdp, why not do this there, instead of exporting
a lot of symbols that we'll be deprecating very soon. It will also
incentivise customers to make a move more promptly.

Bjorn, Magnus, what's the status of libxsk in libxdp?

>  tools/lib/bpf/libbpf.map | 16 ++++++++++++++
>  tools/lib/bpf/xsk.c      | 24 +++++++++++++++++++++
>  tools/lib/bpf/xsk.h      | 45 +++++++++++++++++++++++-----------------
>  3 files changed, 66 insertions(+), 19 deletions(-)
>

[...]
