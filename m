Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321B2231310
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgG1Ttf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgG1Ttf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:49:35 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04006C061794;
        Tue, 28 Jul 2020 12:49:34 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l64so13122115qkb.8;
        Tue, 28 Jul 2020 12:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hj3dMxveOql5730Rx8rp2LmufJVrL75Ha1btaxCU/s=;
        b=gVe4AmxrCCr/KTcE0NgtTG1QbbbYX1HoMoQ9xEf4yiKDfQ+aBF/KU756+sQh15L3f4
         nNGXQ6N6cBWuH91FkmEk3qKgiWr8sFMthdVPx/mN7/0F7FE1KZ3btR9Zwq5gbVrLBbwx
         TSqqN0JJGfcudRMXZoI6p3lFBMCU9mjLMET8ZqV6BYmWvwwMoeDaoDq9owpaHpsjJVq8
         YUMl7fxLBZCFDYQkWlsRojqFB67apVmCzca/KlZeAKAPRz6ueEFjihX6jKZC+Xh3D/PM
         0a4xrS0+v08YoW+BrMws4E3h9FyhqqifRAkkCa+u4V1sQhPzUaCrYSEYM6Ub9RVk9gRO
         kRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hj3dMxveOql5730Rx8rp2LmufJVrL75Ha1btaxCU/s=;
        b=Gy9Cc76wRNsnAoBEEkhRnB+fXNf8NItZXa399iSE7Uitk0bhdSD7bMiiYJIAZTeASL
         bokLYqBk4mLDyXVFXYNukD7Jwyw+bMP2F6rcxucUzSXr7WccveTzJPWuaMF8Nbh+oC+N
         h/W+x7tZJZ9PQCVE9VdedABywD6iNPrr0qkZ1OxZGBvAz5l/gFJSp30rwavjBjfXLG43
         c779NM77uZrb8DTfe/9b3sm/8Jol4f06BOnlCI5/jDVQthZHkfSf7zNFVQGSxI3hAUud
         RwKA6KUM4RmXdRVDRj7OHqjme3r10BupM9oujeIiRFIEg79pGyn/dRTVlm7EPk7WLTIu
         6Esw==
X-Gm-Message-State: AOAM533QezA46FyjGImZ4XhwkayFWm91XagBq+81erg7ZtrOKSddPz+0
        aJ7gBNJQEi9ABWyK/RD0kKQ3df2+Ss86KgeT428=
X-Google-Smtp-Source: ABdhPJxOjtfUmD4YxYAqS1jgoiSAicYixqETgO9gEE8raMzfAwEJzf9z0aIGLPFLfndVtwYdDeig+0pPMAdzRU56mHI=
X-Received: by 2002:a05:620a:4c:: with SMTP id t12mr4096037qkt.449.1595965774136;
 Tue, 28 Jul 2020 12:49:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-12-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-12-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:49:22 -0700
Message-ID: <CAEf4BzaCPHEK2ir7r9YfwuELoAG4wqBirCNX+iDrf4THvAr+aA@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 11/13] selftests/bpf: Add verifier test for
 d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:14 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding verifier test for attaching tracing program and
> calling d_path helper from within and testing that it's
> allowed for dentry_open function and denied for 'd_path'
> function with appropriate error.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/test_verifier.c   | 19 +++++++++-
>  tools/testing/selftests/bpf/verifier/d_path.c | 37 +++++++++++++++++++
>  2 files changed, 55 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
>

[...]
