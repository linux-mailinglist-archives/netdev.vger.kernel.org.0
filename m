Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F6B253C79
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 06:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgH0EMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 00:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgH0EMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 00:12:23 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E833EC0612A8;
        Wed, 26 Aug 2020 21:12:22 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id q3so2204912ybp.7;
        Wed, 26 Aug 2020 21:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kp/u4RK/gNkc7rDaaiMxnwAkhw/8/LsUDPjsgGtLT6o=;
        b=Kno7ShG/vp6+iFF/Xh18Xh6EhpLHZp5xUCzgjmTrbkoaDKeDtcNByvG8C+h7V0kroy
         i2kFCVZH0iPjzHuhCAYaylJfkJXP63v+ny21BSfYoJ/0YKt7rvMthfXB/7JXZyqBIYgR
         Jz7JBjGk1i5SWEIcXsB6Y9VvIrUMyRT9y9rbmLW58T23FekaZzAWGze9XsrU22IZBxPh
         VLxejIENydKjzaTGnW8vpWxl2lQ+v1XymK/jC9cLPy/58T4TK1KZHWM+6rs9eygk12pP
         JDU89KuDlIfjhi5LWcT6g16ptZcI2T7oA3+cur/vdeMOQSKX/NHIQntyy/n+OSJnaNrl
         9mmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kp/u4RK/gNkc7rDaaiMxnwAkhw/8/LsUDPjsgGtLT6o=;
        b=rtz+MHohax19vl6hlQSmWeqUbawQpjYAINaRq1+Fg72wAHWQrXqKWv6ENex5hkFBkd
         KTEUDrpC1nO97E8XjRFZWFpuH5Ehqd3Suvrepz9zMZDDx3BtpUozPnIFA9vLrM1uMhIU
         UiI14XB5PRWUOMImVAwo3InZwM82GoUN9joVK4//ooilbXK+HwqhzhHNpy5MUQjMwoxx
         HnINEvGlvYCiTkUL5H+rZf+1lG5Tkcvpj+yy09JGaWzMZcZX2zYDqKqtLgsePS/hWIZF
         MiFgz+HfvUCwZ3K+ckLSBn6tu3VZ4CnZrAR5PLQupbNJUhQKe4cp0PskAd5fpRqFDFDI
         b+BQ==
X-Gm-Message-State: AOAM530+QgwYVBeoOD3wIpKyGHgxdBNhi5UOq793+Z9z0j8/aGq5MW2b
        Emm+6w+XLXlS3GtugtVmLMpxJ/m/C466mTKQexk=
X-Google-Smtp-Source: ABdhPJxDT7ZRUaeQt7UkZ2F1k5QSS9nfBPz50zh2I1Wr5FsNda3NIW/M7p1/mOTLwstva5xQ4VDlktD0qNyV00429KI=
X-Received: by 2002:a25:ad5a:: with SMTP id l26mr24810072ybe.510.1598501540763;
 Wed, 26 Aug 2020 21:12:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200826030922.2591203-1-andriin@fb.com> <20200826160852.e4hnkyvg2kzrtzjj@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200826160852.e4hnkyvg2kzrtzjj@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Aug 2020 21:12:09 -0700
Message-ID: <CAEf4BzbLj5g8PK+fTE17v4nXKDDuZMBp9g98=oaYN59d0pVeZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix compilation warnings for 64-bit
 printf args
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 26, 2020 at 9:08 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 25, 2020 at 08:09:21PM -0700, Andrii Nakryiko wrote:
> > Add __pu64 and __ps64 (sort of like "printf u64 and s64") for libbpf-internal
> > use only in printf-like situations to avoid compilation warnings due to
> > %lld/%llu mismatch with a __u64/__s64 due to some architecture defining the
> > latter as either `long` or `long long`. Use that on all %lld/%llu cases in
> > libbpf.c.
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > Fixes: eacaaed784e2 ("libbpf: Implement enum value-based CO-RE relocations")
> > Fixes: 50e09460d9f8 ("libbpf: Skip well-known ELF sections when iterating ELF")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c          | 15 ++++++++-------
> >  tools/lib/bpf/libbpf_internal.h | 11 +++++++++++
> >  2 files changed, 19 insertions(+), 7 deletions(-)
> >

[...]

> >
> > +/* These types are for casting 64-bit arguments of printf-like functions to
> > + * avoid compiler warnings on various architectures that define size_t, __u64,
> > + * uint64_t, etc as either unsigned long or unsigned long long (similarly for
> > + * signed variants). Use these typedefs only for these purposes. Alternative
> > + * is PRIu64 (and similar) macros, requiring stitching printf format strings
> > + * which are extremely ugly and should be avoided in libbpf code base. With
> > + * arguments casted to __pu64/__ps64, always use %llu/%lld in format string.
> > + */
> > +typedef unsigned long long __pu64;
> > +typedef long long __ps64;
>
> I think these extra typedefs will cause confusion. Original approach
> of open coding type casts to long long and unsigned long long is imo cleaner.

Fair enough. Sent v2 with just direct "unsigned long long" casts.
