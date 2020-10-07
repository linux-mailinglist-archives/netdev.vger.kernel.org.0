Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A759285581
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 02:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgJGAoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 20:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgJGAoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 20:44:00 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B984C061755;
        Tue,  6 Oct 2020 17:43:58 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b142so529826ybg.9;
        Tue, 06 Oct 2020 17:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SyZblE9xC0nmAy+e+XaJzQ7/L8Iiy5qS/+bTpihGNwQ=;
        b=DBXYBsdvnrW5yB3aSn0XQCNhysNNyPsbVxDZ43LGt5LPcW/Tw2hFOiW8Ztz1PcUGXP
         MfaO6HHiPCVYJGw6kX+D1JEiFlo3/qOflosuXjCXPMNTb1IuRzUuhuGHwi0nAEp0gZz2
         igdyNRkBy57Ly9PgdHgnukl2VaszP5Ic18Od1/VA78NBnQYE19g8poGE34kcFowHWaQz
         cQ6r3gRMlc6D+zzHiLTDnfHd8Gp32bnLTRVAevDHn0X+GNy0sGl3rq7N/yJAodjRaqpC
         J0q+Ng81LT9ZwaEzTVgVnsuCRJEEXnT9B3gzlDO1/EMrQuA8+zz3UBMPLFOISPAGdNPu
         IE1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SyZblE9xC0nmAy+e+XaJzQ7/L8Iiy5qS/+bTpihGNwQ=;
        b=oKK/plrlLY8GpuknsivF9i/ozGpCTtknraXaMJzJHgpKGBizwbZRuGy7WRjB6qLYHz
         KYJzQ34MLylENcEnSmRRmaohKZXOQ95ML/UARv7FoLxN6MjKQ+B2yP97OwV3fmk8QEgh
         RjZCBIgvbsV3tHjRSN+fExWUumqKOaSI5gZiBkeBeDLYlQ7zYBqJXtgSBTVuT39Gk/m5
         saUIz21qgqyROjTd4+vGsELwzXUs8ocFIp0PAni/ptt5QnZK8FiJGyzURaBL23CrdFtn
         tPv3nMwg6MuzwcfCn4FfKpxEP88K3IwPB4npWmIxkoRK+1DgffsHp3C9I3pS03I24SUc
         LEYg==
X-Gm-Message-State: AOAM5331bRJBzN1xDeJa1orxdCzKIubNhmdY7lr1ysdbzSkFsyQOdBrT
        RJ4XfDzfZOzcI3EYcCmQBo/0nv0QVFfp0DveRSMTze6HPoQ=
X-Google-Smtp-Source: ABdhPJzmZfbphdxld/IHexJY4Qcs8fvhckSYSM+00uJdHyDFMj27XtkHQrOFcnDVCV/InaANujPRdvaBBvmkc7C+Rk8=
X-Received: by 2002:a25:8541:: with SMTP id f1mr1069611ybn.230.1602031437507;
 Tue, 06 Oct 2020 17:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201006231706.2744579-1-haoluo@google.com>
In-Reply-To: <20201006231706.2744579-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Oct 2020 17:43:46 -0700
Message-ID: <CAEf4BzY1ggHq6UGkHQ_S=0_US=bLPc9u+9pyeUP2hWb_3kWN+w@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix test_verifier after introducing resolve_pseudo_ldimm64
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 4:45 PM Hao Luo <haoluo@google.com> wrote:
>
> Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
> the order of check_subprogs() and resolve_pseudo_ldimm() in
> the verifier. Now an empty prog and the prog of a single
> invalid ldimm expect to see the error "last insn is not an
> exit or jmp" instead, because the check for subprogs comes
> first. Fix the expection of the error message.
>
> Tested:
>  # ./test_verifier
>  Summary: 1130 PASSED, 538 SKIPPED, 0 FAILED
>  and the full set of bpf selftests.
>
> Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  tools/testing/selftests/bpf/verifier/basic.c    | 2 +-
>  tools/testing/selftests/bpf/verifier/ld_imm64.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/verifier/basic.c b/tools/testing/selftests/bpf/verifier/basic.c
> index b8d18642653a..de84f0d57082 100644
> --- a/tools/testing/selftests/bpf/verifier/basic.c
> +++ b/tools/testing/selftests/bpf/verifier/basic.c
> @@ -2,7 +2,7 @@
>         "empty prog",
>         .insns = {
>         },
> -       .errstr = "unknown opcode 00",
> +       .errstr = "last insn is not an exit or jmp",

in this case the new message makes more sense, so this is a good change

>         .result = REJECT,
>  },
>  {
> diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> index 3856dba733e9..f300ba62edd0 100644
> --- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
> +++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> @@ -55,7 +55,7 @@
>         .insns = {
>         BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
>         },
> -       .errstr = "invalid bpf_ld_imm64 insn",
> +       .errstr = "last insn is not an exit or jmp",

but this completely defeats the purpose of the test; better add
BPF_EXIT_INSN() after ldimm64 instruction to actually get to
validation of ldimm64

>         .result = REJECT,
>  },
>  {
> --
> 2.28.0.806.g8561365e88-goog
>
