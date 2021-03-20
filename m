Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7074B342E8B
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 18:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCTRNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhCTRNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 13:13:12 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3722DC061574;
        Sat, 20 Mar 2021 10:13:12 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a143so1748537ybg.7;
        Sat, 20 Mar 2021 10:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=svt8d5xI+4b3dDLGJBm68sSzefk8qJCqA3JLTzmJIoo=;
        b=TAI/uFt7KmZ/9soktkFzwLIk6J5Wx75GPUxNHOt6j/7vvtmR8FLBEGWuuNXsO3wdmu
         wrDaXRtg5ukSwg+eZrhmIjQG0hWogsibRwgI0eeOjU4TvMH5H2cEU1MwrA+NSlmIjaXZ
         qY6nEIZ5DjETOqfdUrur/xZB8+JNPpOoeRlMj/OGPzgGQhnZpyU+ipEAWVPUxN4i4OdQ
         iiy+Bd0lkWf1hHE/PeV+g/1C/wviDDcxNuG3f49NqzFG09yXNrprUXvkkSgzhMZSbiR8
         1rI2EO7cfwVdDZWN+7VaOyhtgpPVAE8E2RezMhAGbm2f8CTK9sr/zRsHqpkqZ73ojBIX
         Ofmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=svt8d5xI+4b3dDLGJBm68sSzefk8qJCqA3JLTzmJIoo=;
        b=d4uJOKGuFGHS7HNekIgDv509AsjkgQvY2+29cOHf9+gFIr65V8DyBONUEjyJzEtCGL
         HWfwPPv7F6jwl408HY7LSuAw9pxf80C5ym7HheKd3aWbfh3F+WRG3B7FgcQvfq4BuSMT
         hvPh8c1rphoILGDlW1qA6/P/O+KW4ws1IbWtXAebysCkiu/PL1NNnT3BC3JplOpr/G5l
         1TCKDtLF49ATXr4fsBqerhZ4BI9YMCqP+coxzLRAuoT/BaLsPwkq0bDCiZVUdEbjmZHb
         PcWagGxYz1bx7gSUxxAicsZCrhxDkGR2SHuRGyq8xMFHzrbFgrRLRqsVh9hWb81Gdn8S
         X2lw==
X-Gm-Message-State: AOAM530yBgv7DTU/jHM5Gks3ZbHQZEsUqWlii7fgXzp2lF5skbOs7SrN
        1300iIRSl4FABFWMRCh7mCMKcGavUBcm2peJmdxVLzyU2MrQ9w==
X-Google-Smtp-Source: ABdhPJxZlLdieMygda2nFbJD9nPZUcrkKi6hXGk0GGDU1wEWd7caJkSiyomYLBzDaJ7QgjWXXqdBkOovHeIuLbGE6VU=
X-Received: by 2002:a25:40d8:: with SMTP id n207mr13681048yba.459.1616260391610;
 Sat, 20 Mar 2021 10:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210316011336.4173585-1-kafai@fb.com> <20210316011355.4176313-1-kafai@fb.com>
 <CAEf4BzbyKPgHC8h9z--j=h9Fw+Qd6HSgCtvPvytO5nw82FJoMQ@mail.gmail.com>
 <20210319193250.qogxn6ajnzoys43h@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4Bzb2UuzbiiG7ArFtH4eskJMm7XvQiGA5H7gzH+y7K0gPHA@mail.gmail.com> <8de72618-22fc-ba88-686b-301e46f40dd3@fb.com>
In-Reply-To: <8de72618-22fc-ba88-686b-301e46f40dd3@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 20 Mar 2021 10:13:00 -0700
Message-ID: <CAEf4BzbA+mB7ZU-eBCWg+JCXXHYLmqRH995F7QrRMRX4nD3fcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/15] bpf: Refactor btf_check_func_arg_match
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 5:10 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 3/19/21 2:51 PM, Andrii Nakryiko wrote:
> >
> > It's a matter of taste, I suppose. I'd probably disagree with you on
> > the readability of those verifier parts ;) So it's up to you, of
> > course, but for me this code pattern:
> >
> > for (...) {
> >      if (A) {
> >          handleA;
> >      } else if (B) {
> >          handleB;
> >      } else {
> >          return -EINVAL;
> >      }
> > }
> >
> > is much harder to follow than more linear (imo)
> >
> > for (...) {
> >      if (A) {
> >          handleA;
> >          continue;
> >      }
> >
> >      if (!B)
> >          return -EINVAL;
> >
> >      handleB;
> > }
> >
> > especially if handleA and handleB are quite long and complicated.
> > Because I have to jump back and forth to validate that C is not
> > allowed/handled later, and that there is no common subsequent logic
> > for both A and B (or even C). In the latter code pattern there are
> > clear "only A" and "only B" logic and it's quite obvious that no C is
> > allowed/handled.
>
> my .02. I like the former (Martin's case) much better than the later.
> We had few patterns like the later in the past and had to turn them
> into the former because "case C" appeared.
> In other words:
> if (A)
> else if (B)
> else
>    return
>
> is much easier to extend for C and later convert to 'switch' with 'D':
> less code churn, easier to refactor.

I think code structure should reflect current logic, not be in
preparation for further potential extension, which might not even
happen. If there are only A and B possible, then code should make it
as clear as possible. But if we anticipate another case C, then

if (A) {
    handleA;
    continue;
}
if (B) {
    handle B;
    continue;
}
return -EINVAL;

Is still easier to follow and is easy to extend.

My original point was that `if () {} else if () {}` code structure
implies that there is or might be some common handling logic after
if/else, so at least my brain constantly worries about that and jumps
around in the code to validate that there isn't actually anything
else. And that gets progressively more harder with longer or more
complicated logic inside handleA and handleB.

Anyways, I'm not trying to enforce my personal style, I tried to show
that it's objectively superior from my brain's point of view. That
`continue` is "a pruning point", if you will. But I'm not trying to
convert anyone. Please proceed with whatever code structure you feel
is better.
