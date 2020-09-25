Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8844278FBB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgIYRg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 13:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727812AbgIYRgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 13:36:55 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE199C0613CE;
        Fri, 25 Sep 2020 10:36:55 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id v60so2530884ybi.10;
        Fri, 25 Sep 2020 10:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZpRGIpf6h/aLDjQFUhOtDraQ6nKlUQ/ODEe9CGcDmc=;
        b=cujWZWU8IghE94FXDBFzzIKGrFjKmylSufF0j/hVSTuXBKM86g01jOvAobW92zW7cM
         +zsy0hqbeAeRHpAjnBmIv8s6U3mrgj261Nxw4R7o51yhomJUvu+3stONpXN0Ptkf6R5P
         ezagbL39cN6s6hEb/7m2ooP5E4F84YwQDn8fEjuKJ6JE6lhj/aNVXfRStdQB40Woo4e9
         AaP8lxoCuqP+RK2JboOcWyHdTRe8a/cxAXTClTu8K6yH9TuJjeUfieBYG0CzCnEaYHXs
         iism18H0r9+sKkywsK3ach/nD4Rb8oLivU+lNN6Znuau3BTOfNoGDseRsdueozz4SxSo
         t8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZpRGIpf6h/aLDjQFUhOtDraQ6nKlUQ/ODEe9CGcDmc=;
        b=W2td9uoBKUAmSGayzPij5VM2L0zYtGcdwsptwN3EJ1POy9t6Jh5yHNxPrJbUOmw/rG
         DrcJWB8RZ9Rv1KeORsuUHV3wGCZKm3XzE1IXuNz+RQqboNPud1bKrAgDxHsQ8SVW+FCK
         DAH+QKJ9aJn73/nWMXlGpFd1ZXS+fFdgARMb2E4AO69iOqTZ2qaPzoR7gGiEsKt9zs9g
         BxfWRVSYReHTdazFqN39c0Eg2FGgD5pv1WtxAKBdtjGln+LjiJFHdzvExKxkFnKjOzVS
         i/vEYKZ3vuZnJ+890xB7kOcyWgKMyBdmXuYUtJQa+BBQcn1pzqwdb1R4MlGxOG/1RT9/
         RiLg==
X-Gm-Message-State: AOAM533lKAsHoUVIMi2Nt/2NzwNptH+eUU7TfLEy21ezraUQ0FGbJtxI
        DcAlbuOz8yxcGly1Rx9UW1uQUQ2E+R0nUbPG4msc7Tws39cB1DAP
X-Google-Smtp-Source: ABdhPJxcScgubceKQGCd2YGjstpAhFXV+DIbP3KAs6SqVOIEK/EzRliRGa84SmGu6OoNz8sDo/BnrefAqFjsn/fTojU=
X-Received: by 2002:a25:6644:: with SMTP id z4mr379569ybm.347.1601055414943;
 Fri, 25 Sep 2020 10:36:54 -0700 (PDT)
MIME-Version: 1.0
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-5-git-send-email-alan.maguire@oracle.com> <20200925005051.nqf6ru46psex7oh4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200925005051.nqf6ru46psex7oh4@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Sep 2020 10:36:44 -0700
Message-ID: <CAEf4BzZxWC2cO9dmZczWWCQgGH6TLLjmDSiO_LrMzSu7Es5ZSw@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 4/6] selftests/bpf: add bpf_snprintf_btf
 helper tests
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        andriy.shevchenko@linux.intel.com, Petr Mladek <pmladek@suse.com>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Andrey Ignatov <rdna@fb.com>, scott.branden@broadcom.com,
        Quentin Monnet <quentin@isovalent.com>,
        Carlos Neira <cneirabustos@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 5:51 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Sep 23, 2020 at 06:46:26PM +0100, Alan Maguire wrote:
> > +static int __strncmp(const void *m1, const void *m2, size_t len)
> > +{
> > +     const unsigned char *s1 = m1;
> > +     const unsigned char *s2 = m2;
> > +     int i, delta = 0;
> > +
> > +#pragma clang loop unroll(full)
>
> Shouldn't be needed?
> The verifier supports bounded loops.
>
> > +     for (i = 0; i < len; i++) {
> > +             delta = s1[i] - s2[i];
> > +             if (delta || s1[i] == 0 || s2[i] == 0)
> > +                     break;
> > +     }
> > +     return delta;
> > +}
> > +
> > +/* Use __builtin_btf_type_id to test snprintf_btf by type id instead of name */
> > +#if __has_builtin(__builtin_btf_type_id)
> > +#define TEST_BTF_BY_ID(_str, _typestr, _ptr, _hflags)                        \
> > +     do {                                                            \
> > +             int _expected_ret = ret;                                \
> > +             _ptr.type = 0;                                          \
> > +             _ptr.type_id = __builtin_btf_type_id(_typestr, 0);      \
>
> The test is passing for me, but I don't understand why :)
> __builtin_btf_type_id(, 0); means btf_id of the bpf program.
> While bpf_snprintf_btf() is treating it as btf_id of vmlinux_btf.
> So it really should have been __builtin_btf_type_id(,1);

Better still to use bpf_core_type_id_kernel() macro from bpf_core_read.h.

>
> The following diff works:
> diff --git a/tools/testing/selftests/bpf/progs/netif_receive_skb.c b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> index b4f96f1f6830..bffa786e3b03 100644
> --- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> +++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
> @@ -45,7 +45,7 @@ static int __strncmp(const void *m1, const void *m2, size_t len)
>         do {                                                            \
>                 int _expected_ret = ret;                                \
>                 _ptr.type = 0;                                          \
> -               _ptr.type_id = __builtin_btf_type_id(_typestr, 0);      \
> +               _ptr.type_id = __builtin_btf_type_id(_typestr, 1);      \
>                 ret = bpf_snprintf_btf(_str, STRSIZE, &_ptr,            \
>                                        sizeof(_ptr), _hflags);          \
>                 if (ret != _expected_ret) {                             \
> @@ -88,7 +88,7 @@ static int __strncmp(const void *m1, const void *m2, size_t len)
>                         ret = -EBADMSG;                                 \
>                         break;                                          \
>                 }                                                       \
> -               TEST_BTF_BY_ID(_str, #_type, _ptr, _hflags);            \
> +               TEST_BTF_BY_ID(_str, _ptr, _ptr, _hflags);              \
>
> But still makes me suspicious of the test. I haven't debugged further.
