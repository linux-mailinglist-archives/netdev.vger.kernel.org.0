Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079E52E10B6
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 01:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgLWAFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 19:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgLWAFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 19:05:24 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A03C0613D6;
        Tue, 22 Dec 2020 16:04:44 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id u203so13167054ybb.2;
        Tue, 22 Dec 2020 16:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5UkDT+pBKYCLmrnGCZKgjBAkhaFuA0WMdfViISfWrsE=;
        b=hzDtiIDsUChijguC0aRtpFcI1KtdCEz9qmCzVT2GuOHPBHZ0jbm5g6A2c0dNNu3M7b
         FYRm1Nep4zlLZq5BxyIraSovFfXUhmD06g8rqmqtxrOwEJjsN5snWoKrz3Adch3UsUbR
         u295B/uMTEwMMn5VaKBHGVG/k3KyxOAgumuEISZ/s/wGIV+fry3vvSHrGZAHndrUQMly
         3YSIKO09A6b4b4krEkAVcbFYOkgeJ+kGfNd3vsTI3b7J9D/Y9H5f4U40QPwCXP+JO638
         5HsYoTm7E+FfHiJbzE4DT+WJrwyN3JcbnG5tEoJfHXNIkwfQ1vp6MfWHzQgTPCBLukHZ
         30Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5UkDT+pBKYCLmrnGCZKgjBAkhaFuA0WMdfViISfWrsE=;
        b=kmgCv0Xfd5AnIWYwXl9jHfhbHHAnPAki0yRCkvKsmzDwMnJsY82BkKqV6TpEj8pDWC
         CM+blO1isnYPvpIBjk0+NUZnOUAbQyLGeQRkJajUC8zcCaQdsMArofZ4HZ+yV+gGEXt6
         pqqxMh5oKqs7u9I/Yhfg0f64bVeoUh7VKSDw9Yox8tOmxIsKRlpvSTFIlSA9wFeQq0G1
         Go5ShGBKOR70XXXby739xtv6fhzO27KnBjyZFWH/RHmvL6t3nuTSc/C0ds4tPJHY5gVN
         phVybJDWUdogqKBj58kUlPo6bv2cKaRkRlqwzgS+P+tma/b8J/5WbnJ0oYqVHNxLNAN9
         27Kw==
X-Gm-Message-State: AOAM531YWgbUN3lsoAxmmbXEIvqY/8L553+m+TM2SIWWH1wFrZ3pW3UW
        vfpTThxfESH8fkQtJ/MpwUUL2hyakbJcx/V9qu0=
X-Google-Smtp-Source: ABdhPJyc9rPrsWvke4TV34xxv+rEGd5M0SWDm9TbU/UskXLGKXzTFsIZJKOhW4d7lbIVNYfYqGKhCulda6A+TFPJw2I=
X-Received: by 2002:a25:aea8:: with SMTP id b40mr33731815ybj.347.1608681883179;
 Tue, 22 Dec 2020 16:04:43 -0800 (PST)
MIME-Version: 1.0
References: <20201222195337.2175297-1-andrii@kernel.org> <11956701-DB1D-49E9-BD47-A9AC1E26F487@fb.com>
In-Reply-To: <11956701-DB1D-49E9-BD47-A9AC1E26F487@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Dec 2020 16:04:32 -0800
Message-ID: <CAEf4BzY0CfZ6mau4fRVmJokKZadjG0Mkx7+-1+UF5dEk613a3w@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: work-around EBUSY errors from hashmap update/delete
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 3:58 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Dec 22, 2020, at 11:53 AM, Andrii Nakryiko <andrii@kernel.org> wrote:
> >
> > 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked") introduced
> > a possibility of getting EBUSY error on lock contention, which seems to happen
> > very deterministically in test_maps when running 1024 threads on low-CPU
> > machine. In libbpf CI case, it's a 2 CPU VM and it's hitting this 100% of the
> > time. Work around by retrying on EBUSY (and EAGAIN, while we are at it) after
> > a small sleep. sched_yield() is too agressive and fails even after 20 retries,
> > so I went with usleep(1) for backoff.
> >
> > Also log actual error returned to make it easier to see what's going on.
> >
> > Fixes: 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
> > Cc: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
>
> Thanks for the fix!
>
> Acked-by: Song Liu <songliubraving@fb.com>
>
> With one minor nitpick below
>
> > ---
> > tools/testing/selftests/bpf/test_maps.c | 46 +++++++++++++++++++++----
> > 1 file changed, 40 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
> > index 0ad3e6305ff0..809004f4995f 100644
> > --- a/tools/testing/selftests/bpf/test_maps.c
> > +++ b/tools/testing/selftests/bpf/test_maps.c
> > @@ -1312,22 +1312,56 @@ static void test_map_stress(void)
> > #define DO_UPDATE 1
> > #define DO_DELETE 0
>
> [...]
>
> > +                             printf("error %d %d\n", err, errno);
> > +                     assert(err == 0);
> > +                     err = map_update_retriable(fd, &key, &value, BPF_EXIST, 20);
> > +                     if (err)
> > +                             printf("error %d %d\n", err, errno);
> > +                     assert(err == 0);
> >               } else {
> > -                     assert(bpf_map_delete_elem(fd, &key) == 0);
> > +                     err = map_delete_retriable(fd, &key, 5);
>
> nit: Why 5 here vs. 20 above?

Forgot to update here. I'll make all of them the same, thanks.

>
> > +                     if (err)
> > +                             printf("error %d %d\n", err, errno);
> > +                     assert(err == 0);
> >               }
> >       }
> > }
> > --
> > 2.24.1
> >
>
