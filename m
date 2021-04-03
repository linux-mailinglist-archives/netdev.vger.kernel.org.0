Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274DD353423
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbhDCN3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 09:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236687AbhDCN3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 09:29:06 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9156AC0613E6;
        Sat,  3 Apr 2021 06:29:03 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id v26so7778945iox.11;
        Sat, 03 Apr 2021 06:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SWygQCqYJBcPdL7J1tLNEfA+a85qIQLhd/8toqYvPTY=;
        b=RcCal+FaiZlVHr9+Itmdy5eyBBDc1E+duNmvNCUnDHX5FimjB4mtCaC3BQGjWkd/+T
         ja7+iww0gg8b2bSV8nAv3ja+XOLgHcJKKgO14auqx53IRcgAzdRI0fjkshKdejnoCXDW
         f0N0voeHWUpggPsQ6Io3hFqRfajoNQSsEd4P0n8g2facYNpNi+pZewvZOD0th1h75GeI
         7A3RkHNa9sQ2G39WwX7rEsZchBvN3rrWYyUyzwCCDBmH7I0dlz3ZzTCJPoQi+/GUdb5h
         dnRjcutXMml57UYIwoOvJPmUUpntiLfj3RDW0SSrht+KW37De1ZQ3vsGloQa2BNBFHzm
         gDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SWygQCqYJBcPdL7J1tLNEfA+a85qIQLhd/8toqYvPTY=;
        b=nMuxSPcZspsXagqVvdklKIjSqv1/6VppzDRJ5qROlVRacZ/C4435uB9jHwTbBNM/nV
         o8o6I/igDHjtLaQO9aw6VMgveAiBZ63AXPtjCgJybRrsTlaNUlZNvQigqZnLQ6PghTDF
         t35q2VLKlDWGijMvLeX7Zu65DvL3KjaIbnKOpL+LWxkanuNkvrM7FotFP9De8ocjWXop
         V2X35moT5b+4AJitycG/vyGBbWabOdf+z+UGkCFZHCd4AUNjd5a63TPWpP+FcVZCop1J
         F3exfCbn1BhIUAiotI7dNkDpw0ghwgzmuC6aGvmeCgNKduFcCBW9CA5uHuoZjSBcgfWc
         xH9w==
X-Gm-Message-State: AOAM532nBNvCs3UN6zZ7aliSryrjrIfgujd/S6OWyawdmAHwAZSkYgpb
        pPbkAhgfMCBL70Ow4mktK4AjjvhXitggDZho1IY=
X-Google-Smtp-Source: ABdhPJxxrKXQHHQY41eKZq2fLVXoyDOq2SytVF0laLpS7kdw5Sg8Debs7tTWKHsJdFRTuswjmjUzv7oJkK3mFDRX1lM=
X-Received: by 2002:a02:c908:: with SMTP id t8mr16841871jao.78.1617456542948;
 Sat, 03 Apr 2021 06:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210330223748.399563-1-pctammela@mojatatu.com>
 <CAADnVQK+n69_uUm6Ac1WgvqM4X0_74nXHwkYxbkWFc1F5hU98Q@mail.gmail.com> <CAEf4BzZmBiq_JG5-Y2u9jTZraEtyyuOJYWgKivcKk0WFCzKa8g@mail.gmail.com>
In-Reply-To: <CAEf4BzZmBiq_JG5-Y2u9jTZraEtyyuOJYWgKivcKk0WFCzKa8g@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Sat, 3 Apr 2021 10:28:51 -0300
Message-ID: <CAKY_9u3VR+B=q0rPNYV1V9sr7+DG=T7786wQwMf1jrSxsKUgfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()'
 and 'bpf_ringbuf_submit()'
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em qua., 31 de mar. de 2021 =C3=A0s 04:02, Andrii Nakryiko
<andrii.nakryiko@gmail.com> escreveu:
>
> On Tue, Mar 30, 2021 at 4:16 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Mar 30, 2021 at 3:54 PM Pedro Tammela <pctammela@gmail.com> wro=
te:
> > >
> > >  BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
> > >  {
> > > +       if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP=
)))
> > > +               return -EINVAL;
> > > +
> > >         bpf_ringbuf_commit(sample, flags, false /* discard */);
> > > +
> > >         return 0;
> >
> > I think ringbuf design was meant for bpf_ringbuf_submit to never fail.
> > If we do flag validation it probably should be done at the verifier tim=
e.
>
> Oops, replied on another version already. But yes, BPF verifier relies
> on it succeeding. I don't think we can do flags validation at BPF
> verification time, though, because it is defined as non-const integer
> and we do have valid cases where we dynamically determine whether to
> FORCE_WAKEUP or NO_WAKEUP, based on application-driven criteria (e.g.,
> amount of enqueued data).

Then shouldn't we remove the flags check in 'bpf_ringbuf_output()'?
