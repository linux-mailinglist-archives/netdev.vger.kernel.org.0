Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33699217F51
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 08:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728858AbgGHGBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 02:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgGHGBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 02:01:45 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E07C061755;
        Tue,  7 Jul 2020 23:01:45 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so40480471qkg.5;
        Tue, 07 Jul 2020 23:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h46sytC3dVmHv8xrOAubvrrK7HsHhfWItZlwDU6JO/I=;
        b=Q3aLc47qKjpaan/9JjMLz2pepmzfJao0bSK4t/G2ejkYNlnIs7cQtCPXktZSm2tzni
         uUNS2x4gu+TMDPBjV1+5ffhBo+YjHBxSzYjnip9cHC0niX/T4k7yJJCLGvazoss8IIiO
         NWGBNqhfWCo/M71etTwhUHGfEA+pU9HQDRc79sdpcOp298WgQZOUpR15UHJJLpVmmPsM
         hE53n80Z1+vi2z4C4jDCO/0kn+SQZUCnSru8dLTbI4WLAwefz2kexYKxEAi2vJZ9/6Bc
         PMnY63y6Ud85Oa+QA7aLFq1lq6t1Zp28pch91Bk2TwIURiyOK9dtdnL73wIYpIudiwW4
         Lsuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h46sytC3dVmHv8xrOAubvrrK7HsHhfWItZlwDU6JO/I=;
        b=LeWts6nNMtFnFh5AfOdkC/QKaV2l71sTXBQP/qta9HP97Rr0UMGzbIfQqE/+0FclI9
         Ol2THCfG5TBwg/gVnE6IEfTJw496MJhwHdB2dR0fjaD3nD4TSE77cAcAxPuFH4sIwMRp
         BxkQgiheU0Aujz8tuMgBlQa0mTAxcH36AoiUZNunt6Hjn+yHfS9TCMidfEwKWwA/thec
         7KXxEDH35NRTXifIQ5XDUd6OHs74cwS8l0vR1PESv/EBd1VdntVN6uVaxiGTmv5hjpm6
         VO0AB4M4XfsDaStYHBKpxEB+1bjPr0Fvanc6gCgKo4eSSLibHoLaTN7oRO188dEOHrMY
         D/XA==
X-Gm-Message-State: AOAM5331byKz1hWPDlcWZQ2pxFp15iiOuOgXGmUNkiodTflEib40oEc0
        2bJdAFbyOtGlHBfsPf3XNiYwaZKpLGeInidqw/U=
X-Google-Smtp-Source: ABdhPJwWoyGm00k/ypOdXdVBhWYkHXAq5w/0Pi0eB8KyYebc89k2VEUPFyfXjs6puYqw9FpEqiRrR3M7uoSYDKLO8j4=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr57777749qkn.36.1594188104172;
 Tue, 07 Jul 2020 23:01:44 -0700 (PDT)
MIME-Version: 1.0
References: <1593787468-29931-1-git-send-email-alan.maguire@oracle.com> <1593787468-29931-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1593787468-29931-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 23:01:33 -0700
Message-ID: <CAEf4BzaUQT8399tvd+XsbjL+ZyC-sfH-B5ixrgzWC+q6Wnvh8w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] selftests/bpf: add selftests verifying
 bpf_trace_printk() behaviour
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 3, 2020 at 7:45 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Simple selftest that verifies bpf_trace_printk() returns a sensible
> value and tracing messages appear.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/trace_printk.c        | 71 ++++++++++++++++++++++
>  tools/testing/selftests/bpf/progs/trace_printk.c   | 21 +++++++
>  2 files changed, 92 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_printk.c
>  create mode 100644 tools/testing/selftests/bpf/progs/trace_printk.c
>

[...]

> +       fd = open(TRACEBUF, O_RDONLY);
> +       if (CHECK(fd < 0, "could not open trace buffer",
> +                 "error %d opening %s", errno, TRACEBUF))
> +               goto cleanup;
> +
> +       /* We do not want to wait forever if this test fails... */
> +       fcntl(fd, F_SETFL, O_NONBLOCK);
> +
> +       /* wait for tracepoint to trigger */
> +       sleep(1);

that's a long sleep, it's better to use tp/raw_syscalls/sys_enter
tracepoint to trigger BPF program and then just usleep(1)

> +       trace_printk__detach(skel);
> +
> +       if (CHECK(bss->trace_printk_ran == 0,
> +                 "bpf_trace_printk never ran",
> +                 "ran == %d", bss->trace_printk_ran))
> +               goto cleanup;
> +

[...]

> +
> +int trace_printk_ret = 0;
> +int trace_printk_ran = 0;
> +
> +SEC("tracepoint/sched/sched_switch")

see above, probably better to stick to something like
tp/raw_syscalls/sys_enter or raw_tp/sys_enter. Also, to not overwhelm
trace_pipe output, might want to filter by PID and emit messages for
test_prog's PID only.


> +int sched_switch(void *ctx)
> +{
> +       static const char fmt[] = "testing,testing %d\n";
> +
> +       trace_printk_ret = bpf_trace_printk(fmt, sizeof(fmt),
> +                                           ++trace_printk_ran);
> +       return 0;
> +}
> --
> 1.8.3.1
>
