Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6758644B9E5
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 02:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhKJBTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 20:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhKJBTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 20:19:12 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D0BC061764;
        Tue,  9 Nov 2021 17:16:26 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id e136so2171349ybc.4;
        Tue, 09 Nov 2021 17:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHh1Vf7eeOvmCwF+55LrkkbRXe+afVAhadgPvbSrnKk=;
        b=pDlhRfk0awturO4GS2aiXEz8Ivc/si2mwtowUrx+rdFycuj907j249Cwz3OWq9G6FM
         U1jfOssi6Meb80uPGYaq+LFiP06gIkoWk3eNjY1CYuQOofIyp+AiJDRwTMRPnKDyIBIm
         Cca0GiQsBM+3KcLCp2DyhLr136CFMtIMeZZFTTjlSiHpx445yxdX7M60clV7dAmZ80Cf
         zW2gBbzs0DoLt+b7/oIEK9ii/umSx4c6rI+T8snH3p/OJkqXYO+Utd4qFITdSmgUJ2x0
         bFWREjXqvaoyqx2qIoUcjIafbZ+ZTqpKx+l1dy5IRon82rfxhDlkY4x+GBY/yDzJBAq4
         FPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qHh1Vf7eeOvmCwF+55LrkkbRXe+afVAhadgPvbSrnKk=;
        b=I2xNEUjfjUosG67FkwleKDzAhGnGr+vLRBDj/pb5z1NlbasI20VjhonlFg0IMiEu2I
         F1V3FUtBTVVQm+i3jx/GUYDODvUGNg3E4IIU7nkGi+a+pj6elztak1xKeK4G4saSFAxq
         APHKRYlFYj3pAMvRU6PGZtkPfnnLa/chbZ+x6ROoP+LKKBcLYap+2UPiFgL+h/k5jyWI
         O38JvIsRwY+fCKvSU0SrF0HpKAXFdIYX7NfFmu0m+j8p1lgzpZTdhYFbc0nI62OVg2Gx
         vr2LSFNYdnxz9fp3PY/yRLgfnNUmhO3FNy+0g0zgsm2QjhBHw1K98eGq8lLzhQkJ9dvd
         fgbA==
X-Gm-Message-State: AOAM533ZKWeapBA3qb6aPtbDdCtMiV5hKQME1OzaZ5lb5+O7OSR7SbOF
        7DdErTOWHNiB8cLQC0FBPRJP5Jbj3KTraeetihU=
X-Google-Smtp-Source: ABdhPJzMXC1jDV3CtTLI82Xa7AFYWAK8GkXPeJgKa7P7MEPZyacaT65bminV+cf3BSUFeOOpxf9cSaZf5TeLwWctwy8=
X-Received: by 2002:a25:d010:: with SMTP id h16mr14985690ybg.225.1636506985487;
 Tue, 09 Nov 2021 17:16:25 -0800 (PST)
MIME-Version: 1.0
References: <20211108164620.407305-1-me@ubique.spb.ru> <20211108164620.407305-3-me@ubique.spb.ru>
 <20211109064837.qtokqcxf6yj6zbig@amnesia>
In-Reply-To: <20211109064837.qtokqcxf6yj6zbig@amnesia>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 9 Nov 2021 17:16:14 -0800
Message-ID: <CAEf4BzbaFSwSA9R1FgeD=CXdOi3iWW1QR7cF0jEnRmw6tZpiAQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Add tests for allowed helpers
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, john.stultz@linaro.org,
        sboyd@kernel.org, Peter Ziljstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, rosted@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 8, 2021 at 10:48 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> On Mon, Nov 08, 2021 at 08:46:20PM +0400, Dmitrii Banshchikov wrote:
> > This patch adds tests that bpf_ktime_get_coarse_ns() and bpf_timer_* and
> > bpf_spin_lock()/bpf_spin_unlock() helpers are forbidden in tracing
> > progs as it may result in various locking issues.
> >
> > Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c   |  36 +++-
> >  .../selftests/bpf/verifier/helper_allowed.c   | 196 ++++++++++++++++++
> >  2 files changed, 231 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/verifier/helper_allowed.c
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index 25afe423b3f0..e16eab6fc3a9 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -92,6 +92,7 @@ struct bpf_test {
> >       int fixup_map_event_output[MAX_FIXUPS];
> >       int fixup_map_reuseport_array[MAX_FIXUPS];
> >       int fixup_map_ringbuf[MAX_FIXUPS];
> > +     int fixup_map_timer[MAX_FIXUPS];
> >       /* Expected verifier log output for result REJECT or VERBOSE_ACCEPT.
> >        * Can be a tab-separated sequence of expected strings. An empty string
> >        * means no log verification.
> > @@ -605,7 +606,7 @@ static int create_cgroup_storage(bool percpu)
> >   *   struct bpf_spin_lock l;
> >   * };
> >   */
> > -static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l";
> > +static const char btf_str_sec[] = "\0bpf_spin_lock\0val\0cnt\0l\0bpf_timer\0";
>
> There is extra null byte at the end.

Won't hurt, probably. But I wonder if it will be much easier to add
all those programs as C code and test from test_progs? Instead of all
this assembly.

You can put all of them into a single file and have loop that disabled
all but one program at a time (using bpf_program__set_autoload()) and
loading it and validating that the load failed. WDYT?

>
>
> --
>
> Dmitrii Banshchikov
