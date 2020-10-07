Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9285F28577E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 06:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgJGEPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 00:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGEPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 00:15:21 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3A3C061755;
        Tue,  6 Oct 2020 21:15:21 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so586234pfn.9;
        Tue, 06 Oct 2020 21:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=16jAAdowUmY3bd4fX8MyftEZPxZRFgyOmLiavi/4938=;
        b=W0fhlkzUsnEts6yP/a7j39y+37WmNQHB25nBzBDmxMB4efUuQGNQJgfC4zm4UQqio/
         cUl9j5b/dvQQGCZ88ECt5ksETPGdxRfMG587+m6TfkaAbPIpH+ya4KTLYE0Md/yZeJFc
         x01Q1Ms+OsYDdb1WwlDGQtCKQKhG0BeqA+pUgFHxFmCrQFEA/YFjz9JFFLgwL4jh0spz
         WpajXTa4bvyjj0Vx2/5Vx8KyObV2vBRdna8RtLATYTElvqo3YD8YIiycJrns5WynR6PT
         xj7bMgZcbnmy29kx2ShKhrfzJ+/0LYcZ6ClCFw+0ySiKHjd+2TTZQnAJSEW1xwxFC7dG
         qOow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=16jAAdowUmY3bd4fX8MyftEZPxZRFgyOmLiavi/4938=;
        b=sOU0Xgm3BBTbkSi55t1yTYAAqR0T7juGoIY2gyWG/Qux5SmIZqAEAiz8bwHIg51Okl
         FvRSXlPk63A/qKtC851Ghx5LxFuqTjp5H+QKRcyyToEXinfSNLO+MyJ6zb3t8miKxP3z
         7KD+fMj8Sb8epPLx5P/H8d6U+BzCeTzXowcuGLYj7rQYeGM2+L/bNfsjtUvZYUKdiGHT
         x+EMwB8I3wNPeuyqPeYqVTwhLL6g1aY1PRyApl4ia4TQyrTmM1nkLSi4bjHTRPbpXeFu
         ZbvCKBP+qazu8Hrl4wHBdgUeMjdR7clgdorsbixJ9xTuwj3tk8qsEiNBev+/9cgM2TIj
         9GFw==
X-Gm-Message-State: AOAM532D5kXEaOxLXaNoJJBSHlI5OxeuLeQJdsLVsp0w50BAffy1mLww
        sWxjX9PZkcUpJUhqpV6F2tI=
X-Google-Smtp-Source: ABdhPJybGI6XhUCvLbTKQmqgkWcNL+aDr87/o6t/BjFMs1XgrAkDlHVkoRIFErEt62cLmOvELJCprA==
X-Received: by 2002:a63:3d88:: with SMTP id k130mr1360646pga.30.1602044121354;
        Tue, 06 Oct 2020 21:15:21 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9c77])
        by smtp.gmail.com with ESMTPSA id i126sm893691pfc.48.2020.10.06.21.15.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 21:15:20 -0700 (PDT)
Date:   Tue, 6 Oct 2020 21:15:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Propagate scalar ranges through
 register assignments.
Message-ID: <20201007041517.6wperlh6dqrk7xjc@ast-mbp>
References: <20201006200955.12350-1-alexei.starovoitov@gmail.com>
 <20201006200955.12350-2-alexei.starovoitov@gmail.com>
 <CAEf4BzbRLLJ=r3LJfQbkkXtXgNqQL3Sr01ibhOaxNN-QDqiXdw@mail.gmail.com>
 <20201007021842.2lwngvsvj2hbuzh5@ast-mbp>
 <CAEf4Bza=7GzvXJinkwO1XcASg7ahHranmNRmXEzU-KzOg9wVCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza=7GzvXJinkwO1XcASg7ahHranmNRmXEzU-KzOg9wVCw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 08:31:23PM -0700, Andrii Nakryiko wrote:
> 
> > 'linked' is also wrong. The regs are exactly equal.
> > In case of pkt and other pointers two regs will have the same id
> > as well, but they will not be equal. Here these two scalars are equal
> > otherwise doing *reg = *known_reg would be wrong.
> 
> Ok, I guess it also means that "reg->type == SCALAR_VALUE" checks
> below are unnecessary as well, because if known_reg->id matches, that
> means register states are exactly the same.
> > > > +               for (j = 0; j < MAX_BPF_REG; j++) {
> > > > +                       reg = &state->regs[j];
> > > > +                       if (reg->type == SCALAR_VALUE && reg->id == known_reg->id)

Right. The type check is technically unnecessary. It's a safety net in case id
assignment goes wrong plus it makes it easier to understand the logic.

> > > Even if yes, it probably would be more
> > > straightforward to call appropriate updates in the respective if
> > > branches (it's just a single line for each register, so not like it's
> > > duplicating tons of code).
> >
> > You mean inside reg_set_min_max() and inside reg_combine_min_max() ?
> > That won't work because find_equal_scalars() needs access to the whole
> > bpf_verifier_state and not just bpf_reg_state.
> 
> No, I meant something like this, few lines above:
> 
> if (BPF_SRC(insn->code) == BPF_X) {
> 
>     if (dst_reg->type == SCALAR_VALUE && src_reg->type == SCALAR_VALUE) {
>         if (...)
>         else if (...)
>         else
> 
>         /* both src/dst regs in both this/other branches could have
> been updated */
>         find_equal_scalars(this_branch, src_reg);
>         find_equal_scalars(this_branch, dst_reg);
>         find_equal_scalars(other_branch, &other_branch_regs[insn->src_reg])
>         find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg])
>     }
> } else if (dst_reg->type == SCALAR_VALUE) {
>     reg_set_min_max(...);
> 
>     /* only dst_reg in both branches could have been updated */
>     find_equal_scalars(this_branch, dst_reg);
>     find_equal_scalars(other_branch, &other_branch_regs[insn->dst_reg]);
> }
> 
> 
> This keeps find_equal_scalars() for relevant registers very close to
> places where those registers are updated, instead of jumping back and
> forth between the complicated if  after it, and double-checking under
> which circumstances dst_reg can be updated, for example.

I see it differently.
I don't like moving if (reg->id) into find_equal_scalars(). Otherwise it would
have to be named something like try_find_equal_scalars(). And even with such
"try_" prefix it's still not clean. It's my general dislike of defensive
programming. I prefer all functions to be imperative: "do" vs "try_do".
There are exception from the rule, of course. Like kfree() that accepts NULL.
That's fine.
In this case I think if (type == SCALAR && id != 0) should be done by the caller.
Note that's different from __update_reg_bounds().
There the bounds may or may not change, but the action is performed.
What you're proposing it to make find_equal_scalars() accept any kind
of register and do the action only if argument is actual scalar
and its "id != 0". That's exactly the defensive programming
that I feel make programmers sloppier.
Note that's not the same as mark_reg_unknown() doing
if (WARN_ON(regno >= MAX_BPF_REG)) check. I hope the difference is clear.
