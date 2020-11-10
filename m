Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45592ADE9B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbgKJSnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgKJSnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:43:04 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7007FC0613D1;
        Tue, 10 Nov 2020 10:43:04 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id s8so12576563yba.13;
        Tue, 10 Nov 2020 10:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oOeFUNM4jhGqbawcUIauzPQF7fQF7Oz58AeNbXhLGQQ=;
        b=Akbtt04ubbIMlw8fPNnZFiGcd4HWgJ85/0qMrauXJB+xPCHlzIzo/DMDO63ktPEWG3
         T0YZYD8KL589ofpUbK+liXUChLeA1fd/XDiK0Sra29yQlrJ6JANNalpXv5i0woB6M4lL
         Bb5pOL/VypPyQiwO5MbjWHMyWlbz7n6gGIi+8fI+yYWQrBuEAReL+cYGQK77O8u8T4mS
         Ca7KGRYQs5/1+cj5iwrizjM6iGkXJ5t9yrQDqyVbQvFmYDdinYhGAJOGudc6dfJFa846
         RxnRZWxZ0C2mvxlo78l1DPU2mBTNvYGJ1SW0e2sLGXArEgfSQxo48zAfRzkTYuCVfJUm
         Kb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oOeFUNM4jhGqbawcUIauzPQF7fQF7Oz58AeNbXhLGQQ=;
        b=fALw/d3X2FiUEPUT6cbasbWeh9Q7QVI34s+CBLCWCD3BrF0BrsuUxCUGsJClMhpToV
         Fowzj46fRtaY/kObZ+IRWQCcbnGAaceheFzU681E1L5X+XPmDDCJ44AR74rg9ei14F/6
         Zr4anCKwuRVK9HzASFVYHcIU0tcmm5SG5LvXaM6C6G68cAFfpz4/au32nRd2WasCuBDJ
         huRZz5wcdn+1m409XhNkz/uD3XGXcH41ljrlckgmRooYs20btmT23xP1X7yqrKcL7o4l
         96Kx1wuMUNj8HM06Wr4Xx7tyob9hf3wWIBVxZdJpyyJUcUwtKyKIjEeq/2nNuIT7mn8z
         dWGg==
X-Gm-Message-State: AOAM5337+It4BJ69wqp9Kt3p0ucHRG9ulRtX3VYIi70fTWOoij1jiq+H
        JdLHouwoWyjdmWuPNHYWCTEXtybnx1don9bGQJc=
X-Google-Smtp-Source: ABdhPJzVPiwV63wNDRTuUhDdqwq6L62tcBKnJWGqscHiR4DI4J2xPusXe22uaLSMlP+Ju2baNL7nJkYUAelv0p1I5W4=
X-Received: by 2002:a25:585:: with SMTP id 127mr17284941ybf.425.1605033783761;
 Tue, 10 Nov 2020 10:43:03 -0800 (PST)
MIME-Version: 1.0
References: <1605009019-22310-1-git-send-email-kaixuxia@tencent.com> <CAOJe8K2tL5x-dESsV+PFq1Gii-yB=fJh7i-=E-FbrJeioo6pqA@mail.gmail.com>
In-Reply-To: <CAOJe8K2tL5x-dESsV+PFq1Gii-yB=fJh7i-=E-FbrJeioo6pqA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Nov 2020 10:42:53 -0800
Message-ID: <CAEf4BzaSXd4FSM7v+HMobCSkuvATB5mZRZ6ZPzG4PzQ959jv4w@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix unsigned 'datasec_id' compared with zero in check_pseudo_btf_id
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     xiakaixu1987@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 5:02 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
>
> On 11/10/20, xiakaixu1987@gmail.com <xiakaixu1987@gmail.com> wrote:
> > From: Kaixu Xia <kaixuxia@tencent.com>
> >
> > The unsigned variable datasec_id is assigned a return value from the call
> > to check_pseudo_btf_id(), which may return negative error code.
> >
> > Fixes coccicheck warning:
> >
> > ./kernel/bpf/verifier.c:9616:5-15: WARNING: Unsigned expression compared
> > with zero: datasec_id > 0
> >
> > Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> > Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> > ---
> >  kernel/bpf/verifier.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 6200519582a6..e9d8d4309bb4 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -9572,7 +9572,7 @@ static int check_pseudo_btf_id(struct bpf_verifier_env
> > *env,
> >                              struct bpf_insn *insn,
> >                              struct bpf_insn_aux_data *aux)
> >  {
> > -     u32 datasec_id, type, id = insn->imm;
> > +     s32 datasec_id, type, id = insn->imm;
>
> but the value is passed as u32 to btf_type_by_id()...
>
> btf_find_by_name_kind() returns s32

Right, valid range of BTF type IDs are >= 0 and (significantly) less
than INT_MAX. So s32 is used to signal valid BTF ID or negative error,
but all the APIs accepting BTF ID accept it as just u32.

>
>
> >       const struct btf_var_secinfo *vsi;
> >       const struct btf_type *datasec;
> >       const struct btf_type *t;
> > --
> > 2.20.0
> >
> >
