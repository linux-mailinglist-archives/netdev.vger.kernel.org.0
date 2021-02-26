Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9154032679F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 21:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBZUAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 15:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBZUAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 15:00:31 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A13C061574;
        Fri, 26 Feb 2021 11:59:51 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id m188so10046659yba.13;
        Fri, 26 Feb 2021 11:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0wW9ihePZwe97DT7A41283++qBY9mU95V+ssnXjWZcA=;
        b=dw9XaB7T6bVDd8gqxatF3Sos/7T7GPzDCSLazkhJaUeQtic7LkPwmI99VA8wx96CEx
         sg2FpSdKpruDrDV13LviWRsWnVZwPeVXDBYwOiYjkOGsNPIzkGy6khTlP2/d/+GJA72z
         x2Y0iu1LU6SqQ211bRFiIvyAAlzR1LtKKDqpU+5h6nkeydb+pDR3lwvpd3Ohp7XzGUFr
         bHPKFGKyLoZUfw2oJfSA0Z1TOJqIhM0CGDlXFRHXMkym/Rux2TTGX0+0jOmEtSKCEBvI
         NszF2VYPVpiabqXKcXSaCHRuMxoYtFcSQxVXFKShctcjevO3q8B0NZ/2L7ww6c2R3lSl
         Xtfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0wW9ihePZwe97DT7A41283++qBY9mU95V+ssnXjWZcA=;
        b=bcrNQjinYRxy4MiY70nu5h0KYnadcGMyi5K36ONdrrLmIoNaQgRClTCrqJW24vMtUH
         HVJmZD3vKp11Cq9DX/xUZawIBgYIMerTlq9/7K+fmACUYpH0gsAE27jR3qJtiJyMztZg
         WT5etiryCedXA67XqZOXzwFgCc2kHDd48VuhghG3IE/+6PYpM34OON3tnXppvUrYESdZ
         ONWEQ/JHmkgrRVT4PAL3p/KNZZS0jkl73y0ZzGG/44sFzc5mCzGvdWnXCbk1HcFE1pvN
         5jM+LbZysxJM5qVayQts3mVYXWcaR0RVlZQctmLbr5U8moaImhbKzmD0DY4B2DkpscS9
         MP+Q==
X-Gm-Message-State: AOAM533HoYXrJ6bV6N+AXEMtmMAPqZGNLNKLU/EJYpXFlSwOlN4chCLb
        T1T+mQWgdZ7gP3dOuPD/TqxKmntYN9k6hyjuQds=
X-Google-Smtp-Source: ABdhPJwD5ZhRsKkBMGT/otx2TVyusbk9tXE1yEzjfHaMzGDRivRIn4Cn742dq4gYIMviDcf+2UVJoZI+9yszAtavd/w=
X-Received: by 2002:a25:f40e:: with SMTP id q14mr6945315ybd.230.1614369590180;
 Fri, 26 Feb 2021 11:59:50 -0800 (PST)
MIME-Version: 1.0
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
 <20210223154327.6011b5ee@carbon> <2b917326-3a63-035e-39e9-f63fe3315432@iogearbox.net>
 <CAEf4BzaqsyhJvav-GsJkxP7zHvxZQWvEbrcjc0FH2eXXmidKDw@mail.gmail.com> <b64fa932-5902-f13f-b3b9-f476e389db1b@isovalent.com>
In-Reply-To: <b64fa932-5902-f13f-b3b9-f476e389db1b@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Feb 2021 11:59:39 -0800
Message-ID: <CAEf4BzYGJf6Steg0eh5JUxOMQy+qqcNgsb=b6b-PzSeRC1sS+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix missing * in bpf.h
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Joe Stringer <joe@wand.net.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 8:50 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-02-24 10:59 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Wed, Feb 24, 2021 at 7:55 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >>
> >> On 2/23/21 3:43 PM, Jesper Dangaard Brouer wrote:
> >>> On Tue, 23 Feb 2021 20:45:54 +0800
> >>> Hangbin Liu <liuhangbin@gmail.com> wrote:
> >>>
> >>>> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
> >>>> in bpf.h. This will make bpf_helpers_doc.py stop building
> >>>> bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
> >>>> future add functions.
> >>>>
> >>>> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
> >>>> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >>>> ---
> >>>>   include/uapi/linux/bpf.h       | 2 +-
> >>>>   tools/include/uapi/linux/bpf.h | 2 +-
> >>>>   2 files changed, 2 insertions(+), 2 deletions(-)
> >>>
> >>> Thanks for fixing that!
> >>>
> >>> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >>
> >> Thanks guys, applied!
> >>
> >>> I though I had already fix that, but I must have missed or reintroduced
> >>> this, when I rolling back broken ideas in V13.
> >>>
> >>> I usually run this command to check the man-page (before submitting):
> >>>
> >>>   ./scripts/bpf_helpers_doc.py | rst2man | man -l -
> >>
> >> [+ Andrii] maybe this could be included to run as part of CI to catch such
> >> things in advance?
> >
> > We do something like that as part of bpftool build, so there is no
> > reason we can't add this to selftests/bpf/Makefile as well.
>
> Hi, pretty sure this is the case already? [0]
>
> This helps catching RST formatting issues, for example if a description
> is using invalid markup, and reported by rst2man. My understanding is
> that in the current case, the missing star simply ends the block for the
> helpers documentation from the parser point of view, it's not considered
> an error.
>
> I see two possible workarounds:
>
> 1) Check that the number of helpers found ("len(self.helpers)") is equal
> to the number of helpers in the file, but that requires knowing how many
> helpers we have in the first place (e.g. parsing "__BPF_FUNC_MAPPER(FN)").

It's a bit hacky, but you could also just count a number of '*
\tDescription' lines.

>
> 2) Add some ending tag to the documentation block, and make sure we
> eventually reach it. This is probably a much simpler solution. I could
> work on this (or sync with Joe (+Cc) who is also working on these bits
> for documenting the bpf() syscall).

Fine by me as well.


>
> [0]
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/Makefile?h=v5.11#n189
>
> Quentin
