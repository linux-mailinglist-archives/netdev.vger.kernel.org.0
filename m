Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8755432903
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhJRVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRVYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 17:24:49 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC87C06161C;
        Mon, 18 Oct 2021 14:22:37 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id i84so854300ybc.12;
        Mon, 18 Oct 2021 14:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GZa9db6ti2ZpKxuk39lmqbb7gBOK3cuzg0A2hghg0pY=;
        b=o6XkFRFBFu8fcLeijwNTfD9+jtU9tlXMaKLvL3zxpQaHyva4ComzL0kSlY6kI0/OOa
         7PLhBHYE7T+l3pGweVN2tVmQC+RL2jBrXYWryo842CMOvCDXB3Bc6avZUZHPh+mS6gED
         bV7jZrcSbo9jUJuoh/K5BZ9GTsDL4jl8W+anQmNCeX39Bflu4fktpVgn/WErj43XfCN0
         hy8asRIIpsVnwXufIIEAID29f4elAqMLx67xlYWxwJnn2Yw3+83IAQrSRgShRybTohtY
         xLMBAI80mkJYpMovzUrszdXjjMKK0KSOVhfs88ICzEGXEgrzfNEgnYGTuN1fQ8gbEJx1
         RczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GZa9db6ti2ZpKxuk39lmqbb7gBOK3cuzg0A2hghg0pY=;
        b=Y5C+42Gwa+2GaeltRCW3oN221odhmIoNry96Dn7668q9AyCKiALnRjxxnNv2rrAnQZ
         u2H30hVybewJcSYEkxdBeTJfUltcMEKVfyf51HpfNNclTblwXgZPEDaNNezJ+PsybjAn
         bh3T/IVDOkzO6hxIY3lALo6XwpK4juFO9+hyNrJFA0jeJUafxqwOHjmTM83l58kj+pQk
         vjsSDX3Mjn0pSH/T17Am3tb3LwfZ37zkPRjjceaRj1ki3IEJJQV20T6zqCuQoJMDX1S4
         64eigdhvl8hbfG2OeE3pvEQi88Q0YV2xLbmBkxfa2HeYoHPK9uYk6Q/zX5KVbn50FcWV
         eERA==
X-Gm-Message-State: AOAM532ENZ/7MBsK2KjCDwxF1cJZjTiI1NYyFMCRq6iTzEWsdxsYbRM5
        CblKEBW+o12lwR6pyFA0/qfDqI/+pNRUzmQnWFP1BGx4Ztc=
X-Google-Smtp-Source: ABdhPJzvczBjhncuPSV53042DQeg7RerIWzko5MlL6jeg8f2ZZ6nTgB6Vl6ngDL9UP4F//ntyv/sjnE3AFhzGi9UEX8=
X-Received: by 2002:a25:5606:: with SMTP id k6mr32660014ybb.51.1634592156657;
 Mon, 18 Oct 2021 14:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211011205415.234479-1-davemarchevsky@fb.com> <20211011205415.234479-2-davemarchevsky@fb.com>
In-Reply-To: <20211011205415.234479-2-davemarchevsky@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 Oct 2021 14:22:25 -0700
Message-ID: <CAEf4BzaMgv5otr9AQGHZW=sUCuBdt_Vkv_GqB9n8BYVcZWHjAQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: add verified_insns to bpf_prog_info
 and fdinfo
To:     Dave Marchevsky <davemarchevsky@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 1:54 PM Dave Marchevsky <davemarchevsky@fb.com> wrote:
>
> This stat is currently printed in the verifier log and not stored
> anywhere. To ease consumption of this data, add a field to bpf_prog_aux
> so it can be exposed via BPF_OBJ_GET_INFO_BY_FD and fdinfo.
>
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  include/linux/bpf.h            | 1 +
>  include/uapi/linux/bpf.h       | 2 +-
>  kernel/bpf/syscall.c           | 8 ++++++--
>  kernel/bpf/verifier.c          | 1 +
>  tools/include/uapi/linux/bpf.h | 2 +-
>  5 files changed, 10 insertions(+), 4 deletions(-)
>

[...]

> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 6fc59d61937a..d053fc7e7995 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -5591,7 +5591,7 @@ struct bpf_prog_info {
>         char name[BPF_OBJ_NAME_LEN];
>         __u32 ifindex;
>         __u32 gpl_compatible:1;
> -       __u32 :31; /* alignment pad */
> +       __u32 verified_insns:31;

These 31 unused bits seem like a good place to add extra generic
flags, not new counters. E.g., like a sleepable flag. So I wonder if
it's better to use a dedicated u32 field for counters like
verified_insns and keep these reserved fields for boolean flags?

Daniel, I know you proposed to reuse those 31 bits. How strong do you
feel about this? For any other kind of counter we seem to be using a
complete dedicated integer field, so it would be consistent to keep
doing that?

Having a sleepable bit still seems like a good idea, btw :) but it's a
separate change from Dave's.

>         __u64 netns_dev;
>         __u64 netns_ino;
>         __u32 nr_jited_ksyms;
> --
> 2.30.2
>
