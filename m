Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFD035CF3D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 19:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbhDLRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 13:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbhDLRJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 13:09:02 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F19C061574;
        Mon, 12 Apr 2021 10:08:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id n138so22637444lfa.3;
        Mon, 12 Apr 2021 10:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9yKLqiHk2kInh9XkjY0B3JWgb5a3H5BK5yAT5kVFoo=;
        b=dwZtx3a8HY8JxAzp3P/Y+m2rO6juUSU2LwwkBQ0bdejB1w/uBt1TwaTTfNR7Z0Y1Oo
         nEkNHNjJH9Sf/lYdefy+khZ0XSSHTwbbWZshd/dcPqqFWR15qs1OdalYQuabtyUEpobh
         K3RHghqSa7I5GUjhB+A1riqUn4SjTVR+wS0R9o9nr6pIihoeWRXgLhBjfi+CwxNHto+4
         1ftI+4rukuZvyOJhwXOdjCC46DOzQhYi2qLPwcrKKMNXkOgMNRnhhChiswpbwh8utyIt
         NEhZEGknwhIN80LrRNfAZS65n7M/gHi2yysw4pxLcSr1/9DCCRfaiAyfvdSvj7ORQa0l
         Su5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9yKLqiHk2kInh9XkjY0B3JWgb5a3H5BK5yAT5kVFoo=;
        b=JBYyijJD+tPMDU4UQbfnVaAAOvaBzNNoMDNWc3lzUcSXQkFBkLi1lW7sE7qAQiQXN/
         E8o6xROdhhoelahiurwOz89GgSgg8T/Fjjwea4GpfcmLZ9jxTMov7uhK1llnUWe1dr/c
         wA37ErEN+40ytitd5mJpq8GB40tFCzk4jthdgE+Gw+y5MPtcoffLMByI6B9qfVQdWz3h
         KXXFtT//UR2ZRcTzETa5MGwM+oWY4MUecOWJRnR7llXX+DVceIcYZONoQpPCyXRtTTj3
         nrmgHkT3j/fQ2v7cUSJV1CDjmoGD9LX/iXKZISFu5TiCOneKBC8L46wT0992+ySMNggc
         463w==
X-Gm-Message-State: AOAM531TV6c0LwxWJlC/atQ0crn+C2wf9+jnuq3C4lIneq9dsLficZJM
        0F3In8OzXfI5H2sT2iZWckvRZ5jVVvWg4FF/mKY=
X-Google-Smtp-Source: ABdhPJwdQOkGyTx6w7MDT1WWBesr2v3+MAbclsgUF8zQms6ncveFR/SBii9/xm4FK/lZ5PAQ0Y0I6LBuUm0hoNVFuFQ=
X-Received: by 2002:a05:6512:3ba9:: with SMTP id g41mr839392lfv.38.1618247322990;
 Mon, 12 Apr 2021 10:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <CACkBjsa12CEHfT75J6M1Pqy9=6uGFvOX+vGHCa7yO-mqUN14FQ@mail.gmail.com>
 <CACkBjsbcmt=+PFjEybaumg3Rp2peSyoyc_1McZmqT0zeKNUSCg@mail.gmail.com>
In-Reply-To: <CACkBjsbcmt=+PFjEybaumg3Rp2peSyoyc_1McZmqT0zeKNUSCg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 12 Apr 2021 10:08:31 -0700
Message-ID: <CAADnVQL2kFqcsPnew4a2QSOP4cxm0Shd7=d0wdmzXLg+S-7KkQ@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in bpf_check
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 12:11 AM Hao Sun <sunhao.th@gmail.com> wrote:
>
> Besides, another similar bug occurred while fault injection was enabled.
> ====
> BUG: unable to handle kernel paging request in bpf_prog_alloc_no_stats
> ========================================================
> RAX: ffffffffffffffda RBX: 000000000059c080 RCX: 000000000047338d
> RDX: 0000000000000078 RSI: 0000000020000300 RDI: 0000000000000005
> RBP: 00007f7e3c38fc90 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
> R13: 00007ffed3a1dd6f R14: 00007ffed3a1df10 R15: 00007f7e3c38fdc0
> BUG: unable to handle page fault for address: ffff91f2077ed028
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 1810067 P4D 1810067 PUD 1915067 PMD 3b907067 PTE 0
> Oops: 0002 [#1] SMP
> CPU: 3 PID: 17344 Comm: executor Not tainted 5.12.0-rc6+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:bpf_prog_alloc_no_stats+0x251/0x6e0 kernel/bpf/core.c:94

Both crashes don't make much sense.
There are !null checks in both cases.
I suspect it's a kmsan bug.
Most likely kmsan_map_kernel_range_noflush is doing something wrong.
No idea where that function lives. I don't see it in the kernel sources.
