Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047143D038F
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 23:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235501AbhGTUXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbhGTUKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 16:10:46 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D99FC061766;
        Tue, 20 Jul 2021 13:51:22 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id r135so420174ybc.0;
        Tue, 20 Jul 2021 13:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LOCFerhLALJkLkgurC4cJf0k5DwwTiLLAewdaQFoXoA=;
        b=GVAran7hwjB0HtulhTTZoPrLKek6kJzV4qpHSykgSJvJUNsVXud2Tyhf1Tx4UUi94Z
         SY6NuTxDVSovYDoxSPWcmfq9QYz3OpztWWpGQUExRRZXFY+fE6kynXixFMR0ul1j0x55
         6KaSyjXEj1wbcb9ykDfy29j3qjPYIVLjfWpsMZPdw5aQ52loUHEqLG7CPDDRnUwSg+sE
         JOzcZHw9ooRzykNkhhprSKvy73zif2ezGMAhwiGR9QjB8nhwQBW+ccmhd0KZlcJVQwj1
         JCCB9zkQe8miq52f0zu3NgH3Pq1dqqfJwCsesCrNH35oXJ/LfDvnNYA+Tyj0Bgk0hGsJ
         wB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LOCFerhLALJkLkgurC4cJf0k5DwwTiLLAewdaQFoXoA=;
        b=G0kO5PbwHajFCr1HHFaRmGmERN+iCMpdIdfikr3ycXqWc/9mgpysn8/O3MMK51GKdB
         OkkH8tbb1q4iVe7Cs+6cYotUG/veubkCD+dr74iBCkQTxCplVWo/KMCrflcqU4l49czN
         J0Bh/WniF+CiBBhoR4VvuVxrJHfvhkdFJwfCkGodMGH6SDc0kLRVmgS484Gj2KuiZmi2
         7lxMwDbm6KwJ7L2Vk9QUqCXepLG0RDKuVDi6eyxeffadWKo+TMxDhqaM89GVufI7Bo/a
         gCzoaU8udsE0iWnmKiJrYHoff2Ce2wuchzI0RjE4PfZTTvzlDENKiriQFcp764kAqe0R
         ej8A==
X-Gm-Message-State: AOAM532ZrwSU24DtVzDAbC3W232HUY+ocqj8wIcxk3umFYvjMQ/OfYEh
        mmr9ixnuhipqtdzWkmnGx3JLUNioqdnO7lWVX9I=
X-Google-Smtp-Source: ABdhPJwuCeaUDqOmG4ItAxwl+DFCV1uw43ppWLZb2x96pxpaAC953O6I1aK7StIiWvzu+pWLNFNhWf5sUHOIZIhrt6o=
X-Received: by 2002:a25:b741:: with SMTP id e1mr41857262ybm.347.1626814281317;
 Tue, 20 Jul 2021 13:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <1626730889-5658-1-git-send-email-alan.maguire@oracle.com>
 <1626730889-5658-2-git-send-email-alan.maguire@oracle.com>
 <CAEf4BzYUf_zgmJQ_3z=oYAiGOypYsAhvoaePQMB34P==4EOLbg@mail.gmail.com> <alpine.LRH.2.23.451.2107201002170.11590@localhost>
In-Reply-To: <alpine.LRH.2.23.451.2107201002170.11590@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Jul 2021 13:51:10 -0700
Message-ID: <CAEf4BzY+c8WMJAPTELOikxDLJvC4S0w532bZGGNMjWGeA2WpVg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: avoid use of __int128 in typed dump display
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 2:14 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Mon, 19 Jul 2021, Andrii Nakryiko wrote:
>
> > On Mon, Jul 19, 2021 at 2:41 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > __int128 is not supported for some 32-bit platforms (arm and i386).
> > > __int128 was used in carrying out computations on bitfields which
> > > aid display, but the same calculations could be done with __u64
> > > with the small effect of not supporting 128-bit bitfields.
> > >
> > > With these changes, a big-endian issue with casting 128-bit integers
> > > to 64-bit for enum bitfields is solved also, as we now use 64-bit
> > > integers for bitfield calculations.
> > >
> > > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > > ---
> >
> > Changes look good to me, thanks. But they didn't appear in patchworks
> > yet so I can't easily test and apply them. It might be because of
> > patchworks delay or due to a very long CC list. Try trimming the cc
> > list down and re-submit?
> >
>
> Done, looks like the v2 with the trimmed cc list made it into patchwork
> this time.

v1 also made it to the list right after I wrote the email :)

>
> > Also, while I agree that supporting 128-bit bitfields isn't important,
> > I wonder if we should warn/error on that (instead of shifting by
> > negative amount and reporting some garbage value), what do you think?
> > Is there one place in the code where we can error out early if the
> > type actually has bitfield with > 64 bits? I'd prefer to keep
> > btf_dump_bitfield_get_data() itself non-failing though.
> >
>
> Sorry, I missed the last part and made that function fail since
> it's probably the easiest place to capture too-large bitfields.
> I renamed it to btf_dump_get_bitfield_value() to match
> btf_dump_get_enum_value() which as a similar function signature
> (return int, pass in a pointer to the value we want to retrieve).
>
> We can't localize bitfield size checking to
> btf_dump_type_data_check_zero() because - depending on flags -
> the associated checks might not be carried out.  So duplication
> of bitfield size checks between the zero checking and bitfield/enum
> bitfield display seems inevitable, and that being the case, the
> extra error checking required around btf_dump_get_bitfield_value()
> seems to be required.
>
> I might be missing a better approach here of course; let me know what you
> think. Thanks again!

Nah, that's fine. Looks good. Testing and pushing in a few minutes. Thanks.

>
> Alan
