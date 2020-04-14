Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE72A1A8955
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgDNSYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2503891AbgDNSYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:24:30 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E74C061A0C;
        Tue, 14 Apr 2020 11:24:30 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id 37so352651qvc.8;
        Tue, 14 Apr 2020 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vv3ui4zDdvpTcOqmfaq/t1/w4FqNjsPqidFOalTcQUw=;
        b=RhyYbbbXm85p/qji1+l9Kd1gf/g6nnD0TRyzNSA+UenlIggh3A3btEadV5e7ebp1zs
         tSFtmJiP2G2AsByVxoyG/E+LruZGjyUn21CLmgGcDuq2o8JcVxi3jOSHOE9/v5kcjTJx
         PcnELNWYVRBIHky2CqmL8BEcnwoa4H8MvnNEHm22Eu3dwKs5yCdI94K2xn23IOHUsoCN
         u3HY9nJfsgMTzKMOxccNHypWvELRUyQ3h0V+i7O5Xrwu9D29mTIRIBiZlXW4jpasz66u
         vRkJLbI4VTb/GwTvxas88r1KGO+bFMOEcER2BXOb+c3dBMZFkeeyMGY1kARmK0Hq56RN
         gFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vv3ui4zDdvpTcOqmfaq/t1/w4FqNjsPqidFOalTcQUw=;
        b=m3JY5oh2rzCbijUNXSZfwsm1Psgn6sr8Yrbqj1f0MgZkw0Pj6FnI6N8EvtoRt9ACXl
         TmtyofIbnQ9UIbs0x9WDrvXOKbyS4ZDL+KP1IlRB29Z13FopyXLDwsYePKurOrFleVuR
         WypxECiD8X0LGIDb1enCmlwcqVhacDrjFL0K1OqNR6rkZ9+Xpzy6FctTLJMX/LtPuL9M
         RMuOIythuFf0UpwmMZRfahgWtN1R91G6mqbIAtpa/PWbPpvWhn0ctwWVYWPU2Zl+p8P0
         OlyETzp4kdIYAmarwEXtOrGZ2H6Z8xpCddpR1dPNr3Ez5yKdSpE7c0dtqWZo15yR2jhb
         aY4w==
X-Gm-Message-State: AGi0PuZ70vp1WiRm/FC8X/sYHahD9kslkzUKmkqVduSMad+m+/BUm4BL
        JfurRQu8FM4BDpTrnmHZSHzc3npJUWVmn9lZvkY=
X-Google-Smtp-Source: APiQypJaqT+5U05ni29J2R22Xxag9ogoIZrRJf0TXg+w9pO7LqszszEy1W9SGS/On8+TzCjgcuqvv1THiNiw8QpIxdA=
X-Received: by 2002:a0c:e844:: with SMTP id l4mr1241083qvo.247.1586888669693;
 Tue, 14 Apr 2020 11:24:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200414045613.2104756-1-andriin@fb.com> <20200414175608.GB54710@rdna-mbp>
In-Reply-To: <20200414175608.GB54710@rdna-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Apr 2020 11:24:18 -0700
Message-ID: <CAEf4BzbM4-PvOgro-SjHx6h2ndYndSNkbQTA6xq74W=PuPTpjA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 10:56 AM Andrey Ignatov <rdna@fb.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> [Mon, 2020-04-13 21:56 -0700]:
> > For some types of BPF programs that utilize expected_attach_type, libbpf won't
> > set load_attr.expected_attach_type, even if expected_attach_type is known from
> > section definition. This was done to preserve backwards compatibility with old
> > kernels that didn't recognize expected_attach_type attribute yet (which was
> > added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But this
> > is problematic for some BPF programs that utilize never features that require
> > kernel to know specific expected_attach_type (e.g., extended set of return
> > codes for cgroup_skb/egress programs).
> >
> > This patch makes libbpf specify expected_attach_type by default, but also
> > detect support for this field in kernel and not set it during program load.
> > This allows to have a good metadata for bpf_program
> > (e.g., bpf_program__get_extected_attach_type()), but still work with old
> > kernels (for cases where it can work at all).
> >
> > Additionally, due to expected_attach_type being always set for recognized
> > program types, bpf_program__attach_cgroup doesn't have to do extra checks to
> > determine correct attach type, so remove that additional logic.
> >
> > Also adjust section_names selftest to account for this change.
> >
> > More detailed discussion can be found in [0].
> >
> >   [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.thefacebook.com/
> >
> > Reported-by: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> > v1->v2:
> > - fixed prog_type/expected_attach_type combo (Andrey);
> > - added comment explaining what we are doing in probe_exp_attach_type (Andrey).
>
> Thanks for changes.
>
> I built the patch (removing the double .sec Song mentioned since it
> breaks compilation) and tested it: it fixes the problem with NET_XMIT_CN

Wait, what? How does it break compilation? I compiled and tested
before submitting and just cleaned and built again, no compilation
errors or even warnings. Can you share compilation error you got,
please?

> on old kernels and works for me with cgroup skb on old kernels.
>
> Thank you!
>
> Acked-by: Andrey Ignatov <rdna@fb.com>

Thanks!

>
> I guess we can deal with selftest separately in the original thread.

Sure, if this is going to be applied to bpf as a fix, I'd rather
follow-up with selftests separately.

>
> Also a question about bpf vs bpf-next: since this fixes real problem
> with loading cgroup skb programs, should it go to bpf tree instead?

It will be up to maintainers, it's not so clear whether it's a new
feature or a bug fix.. I don't mind either way.

>
>
> >  tools/lib/bpf/libbpf.c                        | 127 ++++++++++++------
> >  .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
> >  2 files changed, 110 insertions(+), 59 deletions(-)
> >

[...]

trimming :)
