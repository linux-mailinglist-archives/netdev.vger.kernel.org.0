Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2833BF2B2
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbhGHAJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhGHAJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 20:09:11 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F2C061574;
        Wed,  7 Jul 2021 17:06:29 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id i4so6063749ybe.2;
        Wed, 07 Jul 2021 17:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zDOiCWTAhBBG5SU12thK75xjE4ZS1kSMh2K1hIkLQQ=;
        b=KVavzJEF965C348SZ2/aXXkxD6mQPJBeDjMahT3DkU7BmaCX7/ZUJNmEAfoasJBLrX
         it0EnEz6XoV79a/jgU9TJ3cuFUGxeoEzd/rumY/1Uoj6JIPB83kQ5CZf0KZ/woa9AnFN
         bFklpRechLba1A5mtbxEZMTtHRx2SfuNj8xW5b7HEmX3QTQJNlUa/442lHO/xDupJJIF
         yLD3aswtiZ+Cylm/J0/xbGRGkkblgd3tIdwqzmYqAPiSnqykD+a0oT6/fmN/Q1aoIOD2
         5OzATbCh+TVjAQejt2NPk1ccb98ejkKDMUV2Dz/ojlN5aFYcSMHsut8LiRASDnrejeDI
         xpaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zDOiCWTAhBBG5SU12thK75xjE4ZS1kSMh2K1hIkLQQ=;
        b=EaorwHF5rBlRkmK4MxDPwp1Qo3JXf+NzZzoqGneNZnWeHb3V7mwk97T1p7mSUdNCLP
         54Mcx0i/UcX88Si2jMx+ioO4YsssMA9NuK7c1yPdI1LCbwrKlhcAR9MuWFdXvWXA2UY0
         L/Q4fmpgfiykB+YukyScq821cIcO1Q0mQ35Am2mIjgqduxKY79U4Tz7023kaqPz8jScP
         xiPLfLK6JXGjokQzrfuA9DTWt/SOVKQqLBPDwJ5ppZIc73yStgn0F0n89e4aVjEgbWUt
         +VW6Q/+r21ftGktWsVJxK0PhbBRo2GiMUgnsMwU9SJXo97sIxpgv63I8n1AVPzdvmeAF
         YXjg==
X-Gm-Message-State: AOAM5321v7huRDSTvSN9WFrZqBwgLw8um/oiMaR6g4q2Xp1NCvA7xyAO
        v/fSJfCJTRIdbczwEu/xcmkISPILKK+zAcOKSJI=
X-Google-Smtp-Source: ABdhPJxghpNJdp05TQIJ2kBLt0MRb6lCnU+P1LcXFvhJ+55utwyq6rjuhIs2F6haTA0+p1iHv4vUps2yNkp4SlOdZXI=
X-Received: by 2002:a25:b203:: with SMTP id i3mr35466594ybj.260.1625702789006;
 Wed, 07 Jul 2021 17:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210707214751.159713-1-jolsa@kernel.org> <20210707214751.159713-4-jolsa@kernel.org>
In-Reply-To: <20210707214751.159713-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 17:06:17 -0700
Message-ID: <CAEf4BzaF5Y6gbineUd-WLvbZQMSbR3v4j3zct3Qyq31OzWNnwA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 3/7] bpf: Add bpf_get_func_ip helper for
 tracing programs
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 2:53 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding bpf_get_func_ip helper for BPF_PROG_TYPE_TRACING programs,
> specifically for all trampoline attach types.
>
> The trampoline's caller IP address is stored in (ctx - 8) address.
> so there's no reason to actually call the helper, but rather fixup
> the call instruction and return [ctx - 8] value directly (suggested
> by Alexei).
>
> [fixed has_get_func_ip wrong return type]
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       |  7 +++++
>  kernel/bpf/verifier.c          | 53 ++++++++++++++++++++++++++++++++++
>  kernel/trace/bpf_trace.c       | 15 ++++++++++
>  tools/include/uapi/linux/bpf.h |  7 +++++
>  4 files changed, 82 insertions(+)
>

[...]

>  static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>                              int *insn_idx_p)
>  {
> @@ -6225,6 +6256,12 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
>         if (func_id == BPF_FUNC_get_stackid || func_id == BPF_FUNC_get_stack)
>                 env->prog->call_get_stack = true;
>
> +       if (func_id == BPF_FUNC_get_func_ip) {
> +               if (has_get_func_ip(env))

from has_xxx name I'd expect it returns true/false, so this reads
super confusing. check_get_func_ip would be a bit more consistent with
other cases like this (still reads confusing to me, but that's ok)

> +                       return -ENOTSUPP;
> +               env->prog->call_get_func_ip = true;
> +       }
> +
>         if (changes_data)
>                 clear_all_pkt_pointers(env);
>         return 0;

[...]
