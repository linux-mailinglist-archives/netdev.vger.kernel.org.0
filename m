Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C7421911B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgGHUDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHUDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:03:24 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13188C061A0B;
        Wed,  8 Jul 2020 13:03:24 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e12so35544640qtr.9;
        Wed, 08 Jul 2020 13:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i49nZfqplLeUNgNmhVsMpyrZjPj0G4Gmj53+u8HKe1A=;
        b=QF2yUcqDB8G3avHQFhDMwNJN0Q2NGjzvstW1yG9g+BJ85JiacL2VFDdh9iiJ/pa0Ti
         l8RSQsOjDQ9DNA5m0cz8mKZc7IheyfAQDlT3xXcPdBSdncWSwCkGtXz7TvV+7m9VuN13
         eDxfVJ8yEMudMJ1Bx/hocwSSIH0Lr4pU5ebKInFxPXoYguCCaIAIfZxvvRX9963398d7
         4nnxhY138F5OeNCvL5AVrJcNJJ9HSB7r6M2r+Z+u2Dhlr4srtpR+j/HabAdZdiNDdGHa
         x1Egp6+cPl7rR84JPyPDSZ7smFz8nqsy9VPeSdniX6ERn8TdFi7AUCAxHkYClICAR/B+
         XJ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i49nZfqplLeUNgNmhVsMpyrZjPj0G4Gmj53+u8HKe1A=;
        b=DTUQ2dOVvPl6F3tGllFsNBoe0oCHUNuNGVD9kMlhzYJ+27Tq2aGpRocj+onUNh6Jnc
         dyJYyafcrxEydtQ8u1iWwCELm+azUIrwnmxGHu6j5gEdtm0e9gvVPcTGuyoKQXvJlYvZ
         j66NUHAh0wmzpo9PbJLoXZeTfoGracvtiZU4DetGK4BAylGoLN8cM5iKFJBiWXKwgi4k
         8Dulqw1+uaclzUo4sGByOhgvdv/iEV5G5ZFmlxoM8gJ6v+RWoaAh9alLOca9ac4W4BxC
         zLLJLE5KTUl6bGaaTwMGm+kVH3DvD8KDi8ldtgGWO8t+LJsuQANzcNLQPM+NgaYq7v2l
         +khQ==
X-Gm-Message-State: AOAM530CCvuARmDlAuVIjan4uNtvVmtYLf6b+92mUv84uGptry46Daio
        FkVLyk41DOxUclFAuxyrf3t3ov3lGJBParb/DSHTAG1o
X-Google-Smtp-Source: ABdhPJwQYOzkBDcj3qj7ZUAkBHuldvrKrbmPvHTlbEjsMSdJCVk+v965V7I0tpd9rVH59cJG5sT5gOWMHdOokrkZKhs=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr61165369qtp.141.1594238603091;
 Wed, 08 Jul 2020 13:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <159410590190.1093222.8436994742373578091.stgit@firesoul>
 <CAEf4Bzb07mdCQ5DS_gao4b9GSyeg406wpteC9uDaGdfOAHXFVA@mail.gmail.com> <20200708201644.0a02602a@carbon>
In-Reply-To: <20200708201644.0a02602a@carbon>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 8 Jul 2020 13:03:11 -0700
Message-ID: <CAEf4BzZhjKeNN3eVi2UedRSGZR6Jt51hSK-Cy0UBfUP3WGG4Ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next V3 0/2] BPF selftests test runner 'test_progs'
 use proper shell exit codes
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Yonghong Song <yhs@fb.com>,
        Martin Lau <kafai@fb.com>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 11:16 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Tue, 7 Jul 2020 00:23:48 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Tue, Jul 7, 2020 at 12:12 AM Jesper Dangaard Brouer
> > <brouer@redhat.com> wrote:
> > >
> > > This patchset makes it easier to use test_progs from shell scripts, by using
> > > proper shell exit codes. The process's exit status should be a number
> > > between 0 and 255 as defined in man exit(3) else it will be masked to comply.
> > >
> > > Shell exit codes used by programs should be below 127. As 127 and above are
> > > used for indicating signals. E.g. 139 means 11=SIGSEGV $((139 & 127))=11.
> > > POSIX defines in man wait(3p) signal check if WIFSIGNALED(STATUS) and
> > > WTERMSIG(139)=11. (Hint: cmd 'kill -l' list signals and their numbers).
> > >
> > > Using Segmentation fault as an example, as these have happened before with
> > > different tests (that are part of test_progs). CI people writing these
> > > shell-scripts could pickup these hints and report them, if that makes sense.
> > >
> > > ---
> > >
> > > Jesper Dangaard Brouer (2):
> > >       selftests/bpf: test_progs use another shell exit on non-actions
> > >       selftests/bpf: test_progs avoid minus shell exit codes
> > >
> > >
> > >  tools/testing/selftests/bpf/test_progs.c |   13 ++++++++-----
> > >  1 file changed, 8 insertions(+), 5 deletions(-)
> > >
> > > --
> > >
> >
> > For the series:
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > My preference was shorter EXIT_ERR_SETUP, but it doesn't matter.
>
> I can just resend the patchset, if you prefer?

Doesn't matter to me, you can keep it as is.

>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
