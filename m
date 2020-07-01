Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEB021117C
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 19:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732640AbgGARDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 13:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732207AbgGARDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 13:03:01 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124EFC08C5DB
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 10:03:01 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id by13so10806340edb.11
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 10:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sXLocZuYa5LyRW+7c8dY9wi1ppvduxYFU7Sa4aAHUQ0=;
        b=FNRiKjGOLujr2GHcouB/onGnSBkqERG4/SfGtF+Ui+ASREDVq0YOFGgipw9Hvu1XeC
         q8heD9a6c0iKic1AFiHslIDWRsk3kJuygMm66NNQI3CKH+rjWm7qheoPxrMSMqJirLId
         u0O6QB0nEFLdDv+1vKCf2hb9UR/WD5bow+KZtf+Yai71jqQEIysBGBLVTL5bXK91wveb
         aW19JVd27lMuXuDtDqanawo4WQLJ1PS+jkTc68VMGHm6mJimVzgSBzRTHIDNYK5Wuy8e
         MdEyachNYELHOsU4Av3kBkd99S9yklbFxhFQ6+0bJLfrFOw8CzsQH0eP8+R4xf2mYRJs
         VJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXLocZuYa5LyRW+7c8dY9wi1ppvduxYFU7Sa4aAHUQ0=;
        b=maheKs5H5SwK7/MF4WZcU0W2QGY8VdcAyQmSOav79SR5Q53GnKQWnXEc7DQO9eoEcI
         ROk0gRB57M24Jvd2DjJ3zZq4u1uSASMHKGAMjL/VIPq06GdjyM/gVkPbUlZGODjSAAFV
         2T7b5f287+LOpalI02YqMzdii2m4c6D1Y+g3btNDc5nmMY7r26CTldQqIxrX/k5S5z7M
         HQ6kWstRBZkQbKB/Axx8VB03+9K3MOCNtNoEn2G+B1q0BWbDUUXH7+FzF3b0JU2X4Z7n
         heWDm/kOsW6ckhr9p6RIU0WXk8X7YTVNOku/N9u0LUKdKliXqwGdthyGRVR3Ga5B4/7t
         OXqA==
X-Gm-Message-State: AOAM533JaluoCCHy8QpsjSPM+jkS3ifyxm+A5X4a01as94CQ/Wff1Err
        od9jkUwCfjKgjjzPWtD4a3Xw4Zx/J0yuL7gA9adVDg==
X-Google-Smtp-Source: ABdhPJx8LUrrdnwmBIDiSNRuGB4f6C/45FYDSPt9e8ZYnDUngrST9sVe5bZuefihx+MmlBauk2XZmDEsc574ZFY6EU0=
X-Received: by 2002:a50:c355:: with SMTP id q21mr27751649edb.121.1593622979559;
 Wed, 01 Jul 2020 10:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200630184922.455439-1-haoluo@google.com> <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
 <CA+khW7iJu2tzcz36XzL6gBq4poq+5Qt0vbrmPRdYuvC-c5U4_A@mail.gmail.com>
 <CA+khW7jNqVMqq2dzf6Dy0pWCZYjHrG7Vm_sUEKKLS-L-ptzEtQ@mail.gmail.com> <46fc8e13-fb3e-6464-b794-60cf90d16543@fb.com>
In-Reply-To: <46fc8e13-fb3e-6464-b794-60cf90d16543@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 1 Jul 2020 10:02:48 -0700
Message-ID: <CA+khW7hLL+=sZwCT_6gHHjHTZnmbNk5Pju9vsLOJF4VjyHY-iA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
To:     Yonghong Song <yhs@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kselftest@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 7:26 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/30/20 5:10 PM, Hao Luo wrote:
> > Ok, with the help of my colleague Ian Rogers, I think we solved the
> > mystery. Clang actually inlined hrtimer_nanosleep() inside
> > SyS_nanosleep(), so there is no call to that function throughout the
> > path of the nanosleep syscall. I've been looking at the function body
> > of hrtimer_nanosleep for quite some time, but clearly overlooked the
> > caller of hrtimer_nanosleep. hrtimer_nanosleep is pretty short and
> > there are many constants, inlining would not be too surprising.
>
> Oh thanks for explanation. inlining makes sense. We have many other
> instances like this in the past where kprobe won't work properly.
>
> Could you reword your commit message then?
>
>  > causing fentry and kprobe to not hook on this function properly on a
>  > Clang build kernel.
>
> The above is a little vague on what happens. What really happens is
> fentry/kprobe does hook on this function but has no effect since
> its caller has inlined the function.

Sure, sending a v2 with a more accurate description of the issue.

Hao
