Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451D638D2A7
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 02:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbhEVAsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 20:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbhEVAsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 20:48:03 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68073C061574;
        Fri, 21 May 2021 17:46:39 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id y2so29775761ybq.13;
        Fri, 21 May 2021 17:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RdygxSbSqsWz9BfeMNSc2FteZY17xkWEnp8K+VZHat0=;
        b=Z7+ykzF+PSO7JYR0DUvVodmmpJz6jm5VoUJ0RbLpsMBuATAk+jZ0bjJIR7Pc2Ka7jb
         xeJsQ5F3KHD04JO5Ts9MWuyhHOIWSE+z1fJSP3nAXXkhH7n/UUPz2vQb78MBApyglo2O
         iqSxg+lVbFU8ryxbQEdHdod1DpEHwZ3hlUujZ3V9nsJx0UYAnAxfdKtlcyo/yhK22wjl
         hFKr1+MATzRbJK714vVw7BMlqL0gh2AnHtHFUxKB1kl0ZiK8o5t1JOH0Zo8ZorbSHDi1
         Y6gut9Mt+Lk8+xQT/Z2bC3Vj1ZlQbAGEHXS/cYtYO9lScf3DIye3fAHGIU6e+QYFGbFh
         3gLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RdygxSbSqsWz9BfeMNSc2FteZY17xkWEnp8K+VZHat0=;
        b=lquVT5asxXzcb7H6RWs2wONH2483PQhfr17wlEbo2NeAEfS7ycn8z5quK7hivy34ik
         FJfX8C4DHmccXzDI051kLHjp1TN/37KDv7aV0CMahbf3DkPF1vVcDEQHtIS8TkUaw8fD
         KpLFAHko+ZAyfioCaGMlaS0Q36lgmEodMJqGbbcBeQ6oXWIPjvr0hxBtoV+2O7CnFNKM
         38nuIjGrmbRiAVGpPhNdp+2Mp/oed9y5/yas3zlExzFtDeLI1R7+3jCMNT9mvNdJx2+b
         ZinlmzRq8ikGevOaC5lsgglg5DaGggX1QYOQ3RWqubz/yzogBg+gHox6R18mf5r3630+
         5cTw==
X-Gm-Message-State: AOAM533SaE/sUmUZh0DtRYGwiP+3WocvvGCRJNj43EcX1CF7xOvGtR2m
        nSc9a0fK75LlsXD/vd6zlq9sSY1rV44zbDo/dfY=
X-Google-Smtp-Source: ABdhPJzYYiVgQn2patbTAzQcchSjTQQ9r/3Qwi7eKoSsVjBQmDo3PdW6guUSdJPUpu5nEfJKa6lboM+iefQrSMUpwM8=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr18321502ybr.425.1621644398645;
 Fri, 21 May 2021 17:46:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210521162041.GH8544@kitsune.suse.cz>
In-Reply-To: <20210521162041.GH8544@kitsune.suse.cz>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 May 2021 17:46:27 -0700
Message-ID: <CAEf4BzbgJPgVmdS32nnzd8mBj3L=mib7D8JyP09Gq4bGdYpTyg@mail.gmail.com>
Subject: Re: BTF: build failure on 32bit on linux-next
To:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>
Cc:     Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 9:20 AM Michal Such=C3=A1nek <msuchanek@suse.de> wr=
ote:
>
> Hello,
>
> looks like the TODO prints added in 67234743736a6 are not 32bit clean.
>
> Do you plan to implement this functionality or should they be fixed?

They should be fixed regardless. Can you please re-submit as a proper
patch to bpf@vger.kernel.org with [PATCH bpf-next] subj prefix?

>
> Thanks
>
> Michal
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 69cd1a835ebd..70a26af8d01f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4565,7 +4565,7 @@ static int init_map_slots(struct bpf_object *obj, s=
truct bpf_map *map)
>                 targ_map =3D map->init_slots[i];
>                 fd =3D bpf_map__fd(targ_map);
>                 if (obj->gen_loader) {
> -                       pr_warn("// TODO map_update_elem: idx %ld key %d =
value=3D=3Dmap_idx %ld\n",
> +                       pr_warn("// TODO map_update_elem: idx %td key %d =
value=3D=3Dmap_idx %td\n",
>                                 map - obj->maps, i, targ_map - obj->maps)=
;
>                         return -ENOTSUP;
>                 } else {
> @@ -6189,7 +6189,7 @@ static int bpf_core_apply_relo(struct bpf_program *=
prog,
>                 return -EINVAL;
>
>         if (prog->obj->gen_loader) {
> -               pr_warn("// TODO core_relo: prog %ld insn[%d] %s %s kind =
%d\n",
> +               pr_warn("// TODO core_relo: prog %td insn[%d] %s %s kind =
%d\n",
>                         prog - prog->obj->programs, relo->insn_off / 8,
>                         local_name, spec_str, relo->kind);
>                 return -ENOTSUP;
