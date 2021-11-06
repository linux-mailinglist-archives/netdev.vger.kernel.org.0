Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E26447054
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhKFUJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 16:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhKFUJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 16:09:53 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5469C061570;
        Sat,  6 Nov 2021 13:07:11 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id s186so32028378yba.12;
        Sat, 06 Nov 2021 13:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7PMk2LODnuYK2JswHOw8gmG1okLs8PvKewJG/qmyDUo=;
        b=VbXyxqBRMH3vNZ9ruMpmI4BPOoHmrLVQYCRRi9Qggn5wtQEacC7zAxv8wUv78iM0dg
         L2fl5hFBP1/G0K/YsBjGwUQeQrljaEUJTBJYBuaVdE2oiE2b74ZPjkcqE8PmG2lssKt/
         n9pid7vECQ1D3NbOgugSxgRlPXtU2axkdWmJQ9b8VN45Ao8gGqjqBm71bXoG+G9Gcvrr
         ebgjKULdi8Io473y0oBGzCRmOASERJQgLHTseqSlGdYO+7KHqRTYx81iNlQkGnhyfC7G
         eaySoB+m3Zy9i+MhOFoiDXGiRl+JUagJ9lQX9dHcpQKQjlH3KkM2NvNWhoQ9Y/pkp6fr
         vAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7PMk2LODnuYK2JswHOw8gmG1okLs8PvKewJG/qmyDUo=;
        b=ySuMKhXCY8rpG0kT+Io7CWNeXWc4uE+2pLqnm9C2CW/D4pUCwkDtujLVryNLA8GfT+
         CqFY7KI2H5ZEpHFxGigJN9nH/K2HimwqoEJPq+vz6h0UjvlluY8OD1FSMNstX3Rgb/Oh
         tiQ1Azq8crAxjhpVyzJ91IoA3LCpHXn12SkLjBX1FQHx7VehphohdOgnGPhdo/vl4oD3
         Jgj29bet7FNNSFqMMNIdidMt6Md1Yf3xqHuvIGeTFHmegrNrDS59hzYzLuf2QV00dYL2
         lkK/yB5MDjykkVM2qhIgej2mVf6KMSqAJP9jTEk1dfjnGjMWZhG9JJ3ta7BapsMS8PG1
         a62Q==
X-Gm-Message-State: AOAM531fqvwV4oRnZFI1MJctC/5mPLlujMIY2O8kHnqS9VRgayhKBrDT
        KYAUbCq2Lkxx78+M5/Hog/Lqos7poONpBsqn2Lk=
X-Google-Smtp-Source: ABdhPJw+ELjeeKeABYfUUh9A9Wq3EiTksUXSUnO1DHxXcVCfEP8ebEHHx0UN6A4EKUd4t5A/yPzHU3ovK0Upg8POHes=
X-Received: by 2002:a25:d187:: with SMTP id i129mr60183246ybg.2.1636229231186;
 Sat, 06 Nov 2021 13:07:11 -0700 (PDT)
MIME-Version: 1.0
References: <20211106132822.1396621-1-houtao1@huawei.com> <20211106132822.1396621-2-houtao1@huawei.com>
 <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211106192602.knmfk2x7ogcjuzvw@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 6 Nov 2021 13:07:00 -0700
Message-ID: <CAEf4BzZ-g2U-=kLihD3xNkWsZrkg+B29Es=WZqCH1+r5V95sVg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 1/2] bpf: add bpf_strncmp helper
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 6, 2021 at 12:26 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Nov 06, 2021 at 09:28:21PM +0800, Hou Tao wrote:
> > The helper compares two strings: one string is a null-terminated
> > read-only string, and another one has const max storage size. And
> > it can be used to compare file name in tracing or LSM program.
> >
> > We don't check whether or not s2 in bpf_strncmp() is null-terminated,
> > because its content may be changed by malicous program, and we only
> > ensure the memory accessed is bounded by s2_sz.
>
> I think "malicous" adjective is unnecessary and misleading.
> It's also misspelled.
> Just mention that 2nd argument doesn't have to be null terminated.
>
> > + * long bpf_strncmp(const char *s1, const char *s2, u32 s2_sz)
> ...
> > +BPF_CALL_3(bpf_strncmp, const char *, s1, const char *, s2, size_t, s2_sz)
>
> probably should match u32 instead of size_t.
>
> > @@ -1210,6 +1210,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> >               return &bpf_get_branch_snapshot_proto;
> >       case BPF_FUNC_trace_vprintk:
> >               return bpf_get_trace_vprintk_proto();
> > +     case BPF_FUNC_strncmp:
> > +             return &bpf_strncmp_proto;
>
> why tracing only?
> Should probably be in bpf_base_func_proto.
>
> I was thinking whether the proto could be:
> long bpf_strncmp(const char *s1, u32 s1_sz, const char *s2)
> but I think your version is better though having const string as 1st arg
> is a bit odd in normal C.

Why do you think it's better? This is equivalent to `123 == x` if it
was integer comparison, so it feels like bpf_strncmp(s, sz, "blah") is
indeed more natural. No big deal, just curious what's better about it.

>
> Would it make sense to add bpf_memchr as well while we are at it?
> And
> static inline bpf_strnlen(const char *s, u32 sz)
> {
>   return bpf_memchr(s, sz, 0);
> }
> to bpf_helpers.h ?
