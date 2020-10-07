Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3F2855A2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 02:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgJGA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 20:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgJGA4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 20:56:32 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCAFC061755;
        Tue,  6 Oct 2020 17:56:31 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 67so555911ybt.6;
        Tue, 06 Oct 2020 17:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V3zqpSMPS8gtKxeX3TbkFq5u4mIeEj4U3nOHYlCoGeo=;
        b=vGg+OypGRkCqFLX2djYv0TqEfRRV5vwCvcmreBa0IP6X4OCUNlzLbPZGt7kqBJRhP8
         NA0aeHDYnnC7+NYpdXdTK3xpLrhK5I5yBLyIeomDUM2Ku2FObiInUTYvEb6Aw67l28rR
         PQXcksLDGdbMvWZ3zInbLnE2ifSjyzT2cHtioqywwrmToBz4fbzN51OnJdQItyjOfOIz
         thbUgt/T2M0KpZhQyEpsOtZQ4LQN8TzfIeBkbXyodKw85XAzOH8wqAm0hq/a8/+i9lyC
         rJ1wXjh0K4LJVR95wmDfzhvSJNo2uDymq23u6Ykvx39FFUFn7+47tI5pHv1UrE0vtunK
         NIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V3zqpSMPS8gtKxeX3TbkFq5u4mIeEj4U3nOHYlCoGeo=;
        b=G+IqccQwAxl1EzgxDl9tEFLEraLr2EyhT49KDf6Qwopvp1U+TIWko2JGAhwik74K2U
         7rL+bbavHYd3ex+uV41qPSB/I4plZNO+isZi9kH9gwEnHKnwfJ1HupDIjU50rNOxpyh/
         Xae1TiYujUQ8XSxldth7RFs94jRGtmlOLGvmyHsOH4+K64Bnp8fk6y1k6H1dCkzJsfmp
         ctfty4eP5ymndxXQHiiJEc72R0XBtn43BmQR0k4FzSj1IPIOwecCH86LbkxWU4kmp3Jb
         x0l1edFrMWlJwuzDYqXBsaALKU4q6T3CABJGJUSxnhnzNLcjJPDQzgacoyb7CtZP6wVC
         z2BA==
X-Gm-Message-State: AOAM533BtKg68zJxNiFhessJaCsc4CSS2IfTo/xyjPJ2pAqKvW8Dk7K2
        p1FGvUK5W+xeyY/mu+7SCgQahYpjgL9jxdnNGcM=
X-Google-Smtp-Source: ABdhPJwtV3QALkbyCX1DdAt++HauBCU2BBlMN7Ar7/rvkWYaWmdUHQs74Ixqo8P6GBcdptOpS+zttr1maEotqb+NfzM=
X-Received: by 2002:a25:730a:: with SMTP id o10mr1235486ybc.403.1602032190986;
 Tue, 06 Oct 2020 17:56:30 -0700 (PDT)
MIME-Version: 1.0
References: <20201006231706.2744579-1-haoluo@google.com> <CAEf4BzY1ggHq6UGkHQ_S=0_US=bLPc9u+9pyeUP2hWb_3kWN+w@mail.gmail.com>
 <CA+khW7hVh4PJHtZSNG-_ZPxthQdvKSxoL4P17GZn5NdQxjnHxA@mail.gmail.com>
In-Reply-To: <CA+khW7hVh4PJHtZSNG-_ZPxthQdvKSxoL4P17GZn5NdQxjnHxA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 6 Oct 2020 17:56:20 -0700
Message-ID: <CAEf4BzakCTkR2E1EPgAKEgdBqwLif3HOZWCypE0h-Z9oS5zrkg@mail.gmail.com>
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

On Tue, Oct 6, 2020 at 5:51 PM Hao Luo <haoluo@google.com> wrote:
>
> On Tue, Oct 6, 2020 at 5:43 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 6, 2020 at 4:45 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Commit 4976b718c355 ("bpf: Introduce pseudo_btf_id") switched
> > > the order of check_subprogs() and resolve_pseudo_ldimm() in
> > > the verifier. Now an empty prog and the prog of a single
> > > invalid ldimm expect to see the error "last insn is not an
> > > exit or jmp" instead, because the check for subprogs comes
> > > first. Fix the expection of the error message.
> > >
> > > Tested:
> > >  # ./test_verifier
> > >  Summary: 1130 PASSED, 538 SKIPPED, 0 FAILED
> > >  and the full set of bpf selftests.
> > >
> > > Fixes: 4976b718c355 ("bpf: Introduce pseudo_btf_id")
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> [...]
> > > diff --git a/tools/testing/selftests/bpf/verifier/ld_imm64.c b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> > > index 3856dba733e9..f300ba62edd0 100644
> > > --- a/tools/testing/selftests/bpf/verifier/ld_imm64.c
> > > +++ b/tools/testing/selftests/bpf/verifier/ld_imm64.c
> > > @@ -55,7 +55,7 @@
> > >         .insns = {
> > >         BPF_RAW_INSN(BPF_LD | BPF_IMM | BPF_DW, 0, 0, 0, 0),
> > >         },
> > > -       .errstr = "invalid bpf_ld_imm64 insn",
> > > +       .errstr = "last insn is not an exit or jmp",
> >
> > but this completely defeats the purpose of the test; better add
> > BPF_EXIT_INSN() after ldimm64 instruction to actually get to
> > validation of ldimm64
> >
>
> Actually there is already a test (test4) that covers this case. So it
> makes sense to remove it, I think. I will resend with this change.

ah, this test validates that half of ldimm64 at the very end won't
cause any troubles to verifier... Yeah, I guess now it's pointless
because it can never be the very last instruction.

>
> > >         .result = REJECT,
> > >  },
> > >  {
> > > --
> > > 2.28.0.806.g8561365e88-goog
> > >
