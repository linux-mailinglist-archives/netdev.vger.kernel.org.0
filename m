Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4204282A7
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhJJRcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 13:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhJJRck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 13:32:40 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B099C061570
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 10:30:41 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id a7so33424650yba.6
        for <netdev@vger.kernel.org>; Sun, 10 Oct 2021 10:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x5ZjKsTtEg68L0kiGkt4LxgOXkimH+/pqF53AqKiKZQ=;
        b=ipoQjOKZwOE7PQSN4YXQwnoGYQ+z2crmfDLF5WIwFdsg3/6MkCvp/W7Wp6ZqZE7wuo
         nGSKuaAKG9OW2VEgKfWnY0DSuF4iI52mCBt1gBRWdFthEOl1PdRxO3H2Huo5aCLhzmxu
         fVkrm35sRErkUmXrOi+JSiFTshKPLob3y1O7ZMiUsQO8p6ahUdSuSEeoM8xipzZjAFKi
         hommd4/b7ihiMx6RnGbDIPnKmweJZlVlcZw49A6iPSYG+aDkJFvpv12ZKnnIt1YFg7XQ
         F0HFqjMkZNnBAryZ1Rh8K3ZzI6v6fSyZHnkBwK5v0TbxSBnra/n5CcPMbZ55+JslYFWL
         ZEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5ZjKsTtEg68L0kiGkt4LxgOXkimH+/pqF53AqKiKZQ=;
        b=vg9Vn19NM2NIu49btoXHQkx7f0hxJNoHddyzJe9KlDzfE5dzYGRg4CIl+Mv4Xd0sAR
         mv6KfMUcKcV3WA9y8uZvWmuhH7C619s7WLgmLl9DWHZTeN7nqTygEyOmpOtAaoEEu+e8
         JlL9cJbXxbJhfv35nDLLQdzJ4awXp3apQsyLZEfF/W7eYC+MvJCsK4AkZbfebpA8a4eM
         nAbzIPyy554Y0Pa60qbUlRp+38HsriKknZk1fDQuckezpSJyMU+Nw/+W5HxtXIzb403v
         3wPcMzNNNILNo3hzp5dX2Tflc/iDvIJ3A97S1bNzqZsMqJjZ4VWVlKGLo3I1VufHurQ5
         W8Ig==
X-Gm-Message-State: AOAM532H7oyn+2UA5G8h2rZcAqJ9ZPw1FA7IMrSZMnNA8UtcAc4pawq8
        OM0KRYZSJMucyW9f65vyfSuelnhzYzwX7mJQ68tQMw==
X-Google-Smtp-Source: ABdhPJx8Fk4BpspxBCZ2m/Sp4AXxb8sK180DHkACb9ArP+uC+7grt/9YcUYABlz2722J3dAdk2nBKALi/OP5ZqpUj2U=
X-Received: by 2002:a25:520b:: with SMTP id g11mr17619445ybb.268.1633887040541;
 Sun, 10 Oct 2021 10:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <1633777076-17256-1-git-send-email-yangtiezhu@loongson.cn> <1633777076-17256-3-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1633777076-17256-3-git-send-email-yangtiezhu@loongson.cn>
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
Date:   Sun, 10 Oct 2021 19:30:29 +0200
Message-ID: <CAM1=_QTwdbYKqjG8hEsSOvJzi5GxmBieKZYtVUz_BvfEQt3RZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpf, mips: Modify check condition about tail
 call count
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 12:58 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> In emit_tail_call() of bpf_jit_comp32.c, "blez t2" (t2 <= 0) is not
> consistent with the comment "t2 < 0", modify the check condition to
> keep consistency.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>  arch/mips/net/bpf_jit_comp32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/net/bpf_jit_comp32.c b/arch/mips/net/bpf_jit_comp32.c
> index 9d7041a..b887c01 100644
> --- a/arch/mips/net/bpf_jit_comp32.c
> +++ b/arch/mips/net/bpf_jit_comp32.c
> @@ -1312,12 +1312,12 @@ static int emit_tail_call(struct jit_context *ctx)
>         emit(ctx, sltu, t1, ind, t1);            /* t1 = ind < t1            */
>         emit(ctx, beqz, t1, get_offset(ctx, 1)); /* PC += off(1) if t1 == 0  */
>                                                  /* (next insn delay slot)   */
> -       /* if (TCC-- <= 0) goto out */
> +       /* if (--TCC < 0) goto out */
>         emit(ctx, lw, t2, ctx->stack_size, MIPS_R_SP);  /* t2 = *(SP + size) */
>         emit_load_delay(ctx);                     /* Load delay slot         */
> -       emit(ctx, blez, t2, get_offset(ctx, 1));  /* PC += off(1) if t2 < 0  */
>         emit(ctx, addiu, t2, t2, -1);             /* t2-- (delay slot)       */
>         emit(ctx, sw, t2, ctx->stack_size, MIPS_R_SP);  /* *(SP + size) = t2 */
> +       emit(ctx, bltz, t2, get_offset(ctx, 1));  /* PC += off(1) if t2 < 0  */

If the comment is not consistent with the code, and the code is
correct, why did you change the code? Have you seen the JIT fail on
any of the tail call test cases?

The current code works as intended. The t2 register is decremented in
the branch delay slot of the blez. After your change, the the comment
still says "delay slot", but it is no longer in the delay slot of a
branch. Instead the next instruction emitted, not visible in the patch
context, fills the delay slot of the bltz. In this case it probably is
ok, but if that instruction is also a branch, the result would be
unpredictable.

I prefer to emit the delay slot instruction immediately after the
branch is emitted when possible. If a branch and its delay slot is
separated in the JIT logic, it makes the JIT more brittle IMO.

Please keep the original logic, but update the blez comment so it is
consistent with the code.



>
>         /* prog = ary->ptrs[ind] */
>         off = offsetof(struct bpf_array, ptrs);
> --
> 2.1.0
>
