Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D045DEAC
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 17:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237190AbhKYQnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 11:43:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbhKYQk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 11:40:58 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE62C0613B4;
        Thu, 25 Nov 2021 08:14:26 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y7so4922374plp.0;
        Thu, 25 Nov 2021 08:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g3YOy32wAiS4F1wiZhx4eVxL906t+jOLf5KQMas9Kmw=;
        b=YB8JQFjOo+iWcT2Y8FNFFHiBPDH/Yr/ZAv0K/a1JlFpaVgJuSGElHhwiixpNn5NW3R
         LXCqkXbY4lqeDlj6SnlUhPGMdy1aTKUMTs3xrWroedi7C7IeZ1N4c1x/hNvof22687Aa
         Qr0loWvIt0J0v0KlGjlsGOMHA3VIpJ27v9jMQW73l5/50b14QXrOQXyDOdV/7KDnysU6
         tJW4qUUwahEFkatJAZ0JCwa5Uzz1X4bwvpAdYwx1Rbm+VNl82ukwPdxadPskidhDmxiy
         viBj8RSzGpO8G0ckU4aV2Nxe5yKRxzdLMa68kgy64kYJ7S+vQfrNdkv8o/0LevoUkHD2
         cSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g3YOy32wAiS4F1wiZhx4eVxL906t+jOLf5KQMas9Kmw=;
        b=7aglaSIBlC6csQ826oqt40wOPQphEjTxx95VUW0aNsmyi/uOaVre5qK3OdYydaF/1m
         mM1aHUaCw28Y5efU0Zk30EDC/pPYpWkKAzlLfMfy+/qCOcuwd9YdivN2epMzga+Y8NcK
         9w5V19e29NPHWfLkBC8XY6F5KavGEtxz5p10dCsqr7VkRewnaQX/xuMt0r8hE9OJ5NR4
         lDrH8BQIIaKFJQ2+azss8m48bqxGCivmK39TqyODb7XAyOk02KJJGUkVho7ayRYjLmDJ
         Mdwz0yy0daNVZF2Q0KIqLbCaJGMA0ILVkL+bMxiosh/0V/oKis3e9JKPl4b2VYU7tpfq
         FIpQ==
X-Gm-Message-State: AOAM533/hzbQ6t2F3eiHklNLAWOZk1XX9+RGlHC5wB1fct9jSlgUh8CT
        ZRCx2sHmf/GjzD6X3okcugR7rH/pt8J90H4JfWI=
X-Google-Smtp-Source: ABdhPJxLbbLPvwFQp2ksuxU2G311B7Nqm5IaIZVNwHEDRDGduXj3iYkMbPHSiy9plbgdK33wHN0GYsL+hMAsDdpKgvA=
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr8242463pja.122.1637856866419;
 Thu, 25 Nov 2021 08:14:26 -0800 (PST)
MIME-Version: 1.0
References: <20211118112455.475349-1-jolsa@kernel.org> <20211118112455.475349-7-jolsa@kernel.org>
 <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
In-Reply-To: <CAEf4Bza0UZv6EFdELpg30o=67-Zzs6ggZext4u40+if9a5oQDg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Nov 2021 09:14:15 -0700
Message-ID: <CAADnVQLx_-GuCeE5S3KV5g+YsDfQaFS_BZ8qDCN72gYFLXjj6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 06/29] bpf: Add bpf_arg/bpf_ret_value helpers for
 tracing programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 2:43 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
> > +               /* Implement bpf_arg inline. */
> > +               if (prog_type == BPF_PROG_TYPE_TRACING &&
> > +                   insn->imm == BPF_FUNC_arg) {
> > +                       /* Load nr_args from ctx - 8 */
> > +                       insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
> > +                       insn_buf[1] = BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
> > +                       insn_buf[2] = BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
> > +                       insn_buf[3] = BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
> > +                       insn_buf[4] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
> > +                       insn_buf[5] = BPF_JMP_A(1);
> > +                       insn_buf[6] = BPF_MOV64_IMM(BPF_REG_0, 0);
> > +
> > +                       new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 7);
> > +                       if (!new_prog)
> > +                               return -ENOMEM;
> > +
> > +                       delta    += 6;
> > +                       env->prog = prog = new_prog;
> > +                       insn      = new_prog->insnsi + i + delta;
> > +                       continue;
>
> nit: this whole sequence of steps and calculations seems like
> something that might be abstracted and hidden behind a macro or helper
> func? Not related to your change, though. But wouldn't it be easier to
> understand if it was just written as:
>
> PATCH_INSNS(
>     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1, -8);
>     BPF_JMP32_REG(BPF_JGE, BPF_REG_2, BPF_REG_0, 4);
>     BPF_ALU64_IMM(BPF_MUL, BPF_REG_2, 8);
>     BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_1);
>     BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 0);
>     BPF_JMP_A(1);
>     BPF_MOV64_IMM(BPF_REG_0, 0));

Daniel and myself tried to do similar macro magic in the past,
but it suffers unnecessary stack increase and extra copies.
So eventually we got rid of it.
I suggest staying with Jiri's approach.

Independent from anything else...
Just noticed BPF_MUL in the above...
Please use BPF_LSH instead. JITs don't optimize such things.
It's a job of gcc/llvm to do so. JITs assume that all
normal optimizations were done by the compiler.
