Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD3D43E80C
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhJ1SNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhJ1SNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:13:01 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A761C061570;
        Thu, 28 Oct 2021 11:10:34 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y3so6397973ybf.2;
        Thu, 28 Oct 2021 11:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PibadPtFXRDa44ZUmOQfsMNDa2MEM73QABZ8NV45MJ8=;
        b=m2ICJo9qn/Rdn8KjUKxWxzAGQjl54SJUcsmKj+h5j1053QPETpn03RaDqzAyLI2V/Q
         tRt471H+AlSQEOXO8TcszLQcPvxsJk6p6/UbF+vF2oEiJFMUdruLU//D0A8pNrxS/OPI
         /4xgOf0lGRfBjDz4s3LcvpI8yQbgm3bXzTXvO2tXMqyxaI6rPWjB2OYEDO1GhUjiFYLu
         YWWCabsBoSs33FdoVYpN6KoHnDtK2wwt3OmFylCr+QOIA9l/bzn3w+XTgWZ0UFJlvvt0
         FnDxv292gOfblQAPm3SwBCiIBxlrQGyyTn41L93haC02uH9VdG6gMzdsh1zIMe0eqQNG
         dbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PibadPtFXRDa44ZUmOQfsMNDa2MEM73QABZ8NV45MJ8=;
        b=tKpfZwiR5k+4nR9X3NQYrd9roxROm5rMQNI4UvezSmU4Aiv3zQQzd1ilpgY746vAko
         P91ZKyR6O9RtXR3FCjebmwOkP2LfKI0KyKqXLxWufdOFBJd+JfP8MiZAxWjUQx7+1qDs
         0Yz6kwoSonrd/NJWEg48HIlBadmKwBtorFTj6jhe2KW33qiHpDP7Fq2YaNhuFgKCZXly
         7fuKkFtqO39Wx7dMWxmiqpgZegArsDNfXGru1SukCwwwbekI/y4OuojPb2EKCLLHsLHq
         WqibzbB/g1uTEkoJRgvLHcJuw7agEfFXsHyf1ssFP+FuWKqCYXaEPk3f0dJ6qTKqu6zk
         QJGw==
X-Gm-Message-State: AOAM533twUOYRBKejO4KgNWRQPil9OyJuFzWOQCGPJ1QCsujPtgL8Dyo
        jjs8toEvLvb4b2kejNZ3JkUUaJ+nRF38l4dRU4s=
X-Google-Smtp-Source: ABdhPJyrTl/NA+L1Emy0kUxtKXajMu0rlKAmOnm3h+cqY7G0a3QMAR9iv3/So9DBaeK3FLnqgRx6rTG2kd79dOJhiAs=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr6805131ybj.504.1635444633394;
 Thu, 28 Oct 2021 11:10:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211028063501.2239335-1-memxor@gmail.com> <20211028063501.2239335-2-memxor@gmail.com>
In-Reply-To: <20211028063501.2239335-2-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 11:10:22 -0700
Message-ID: <CAEf4BzZa_vhXB3c8atNcTS6=krQvC25H7K7c3WWZhM=27ro=Wg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add bpf_kallsyms_lookup_name helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 11:35 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This helper allows us to get the address of a kernel symbol from inside
> a BPF_PROG_TYPE_SYSCALL prog (used by gen_loader), so that we can
> relocate typeless ksym vars.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 16 ++++++++++++++++
>  kernel/bpf/syscall.c           | 27 +++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h | 16 ++++++++++++++++
>  4 files changed, 60 insertions(+)
>

[...]

> +BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flags, u64 *, res)
> +{
> +       if (flags)
> +               return -EINVAL;
> +
> +       if (name_sz <= 1 || name[name_sz - 1])
> +               return -EINVAL;
> +
> +       if (!bpf_dump_raw_ok(current_cred()))
> +               return -EPERM;
> +
> +       *res = kallsyms_lookup_name(name);
> +       return *res ? 0 : -ENOENT;
> +}
> +
> +const struct bpf_func_proto bpf_kallsyms_lookup_name_proto = {
> +       .func           = bpf_kallsyms_lookup_name,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_MEM,
> +       .arg2_type      = ARG_CONST_SIZE,

can you make it ARG_CONST_SIZE_OR_ZERO? Not because zero makes sense,
but because it removes the need to prove to the verifier that the size
(which you can get at runtime) is > 0. Just less unnecessary fussing
with preventing Clang optimizations.

> +       .arg3_type      = ARG_ANYTHING,
> +       .arg4_type      = ARG_PTR_TO_LONG,
> +};
> +

[...]
