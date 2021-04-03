Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66FC735349C
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 17:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236866AbhDCPxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 11:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhDCPxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 11:53:31 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD56CC0613E6;
        Sat,  3 Apr 2021 08:53:26 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id l15so8081492ybm.0;
        Sat, 03 Apr 2021 08:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0QORQQ85/zORLcruKl4W25E8R6bS7s+xRhix7pPuuzE=;
        b=Aatz7RP1zMiYQdAsTrrO+XmPiEsJKNmfW6ROxNtEUoyNeB6gy247WSH1OAXpsi5w5z
         2On51glSZcnhBLq85rbDmOY4dEcj1+dFb/Y7NrWhv/O1DiqUJxyOZe7tT6MLGTGdTLeU
         5xlyNEvQc6/if4Z5PEDzQNTi9O6Iupf33/JeZvRuG3HtDreFtrIjZ01sg7P98K8+1FD7
         Zy424Bjt090Z+uYB7fGTlJpcCsXPiIchs3rMjVqh7/vOC/Qr1svR4C7j7Lat8c91Oor8
         ooaRRa6vqm7XTFnzBUPvzzH/SchWIWWP+JSo5oo5gmp0sWMBj4wRfBkng85slXq7yHDD
         Zk3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0QORQQ85/zORLcruKl4W25E8R6bS7s+xRhix7pPuuzE=;
        b=jnmihlYU3EH3OjUAx+tPyX6ScA3KgdTpYg9s8N41yc65jpGE9I0FDtgIvwYPgFpoBe
         1/nYAC89clUbqM3oVapdDAeC2HkUSCk5rn2xQ7aN3gbNiAb4tRauqvOvbTdK8o+5+Vgk
         2cPoTjzuwgnDpznbE4wiKq1eUXSUUZI/W+17gjErjV+WMMpqhYwh59GYOdKGcqpLL4XP
         d7KbRJNY/YA4/9oGbuc3gbMviJgV2zV52hfqWw1LhnCmiV/2U1crBsgk3php8g6UOQ2q
         AJjlXORIANldnvaanSXjbalXkHvIpmHMxWccxy+IFvtol9hhc9OA+OVXh9ACG9Dj1FOT
         y5sA==
X-Gm-Message-State: AOAM533zDe6s6rRwKTyQ55ushjO63S1c6NzET9qYZ7VjGJQMnpxc5ddk
        072lTI2IwPmCrodWb2o+NcFDRK+SZEbumPFXcmI=
X-Google-Smtp-Source: ABdhPJxyAOSP8SvOxRkrqL6uUAx7A5ZDlierIHAEMBesbHi2wQsnmSDepywX1+BK5rJWgkIMZVGx0k170mVKesvUes4=
X-Received: by 2002:a25:9942:: with SMTP id n2mr25148921ybo.230.1617465206168;
 Sat, 03 Apr 2021 08:53:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210330223748.399563-1-pctammela@mojatatu.com>
 <CAADnVQK+n69_uUm6Ac1WgvqM4X0_74nXHwkYxbkWFc1F5hU98Q@mail.gmail.com>
 <CAEf4BzZmBiq_JG5-Y2u9jTZraEtyyuOJYWgKivcKk0WFCzKa8g@mail.gmail.com> <CAKY_9u3VR+B=q0rPNYV1V9sr7+DG=T7786wQwMf1jrSxsKUgfw@mail.gmail.com>
In-Reply-To: <CAKY_9u3VR+B=q0rPNYV1V9sr7+DG=T7786wQwMf1jrSxsKUgfw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 3 Apr 2021 08:53:15 -0700
Message-ID: <CAEf4BzYAcUsObPj_hm3tfC-d+EHfeeHLVDD4OigPg82hiehc7A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()'
 and 'bpf_ringbuf_submit()'
To:     Pedro Tammela <pctammela@gmail.com>
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

On Sat, Apr 3, 2021 at 6:29 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> Em qua., 31 de mar. de 2021 =C3=A0s 04:02, Andrii Nakryiko
> <andrii.nakryiko@gmail.com> escreveu:
> >
> > On Tue, Mar 30, 2021 at 4:16 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Mar 30, 2021 at 3:54 PM Pedro Tammela <pctammela@gmail.com> w=
rote:
> > > >
> > > >  BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
> > > >  {
> > > > +       if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKE=
UP)))
> > > > +               return -EINVAL;
> > > > +
> > > >         bpf_ringbuf_commit(sample, flags, false /* discard */);
> > > > +
> > > >         return 0;
> > >
> > > I think ringbuf design was meant for bpf_ringbuf_submit to never fail=
.
> > > If we do flag validation it probably should be done at the verifier t=
ime.
> >
> > Oops, replied on another version already. But yes, BPF verifier relies
> > on it succeeding. I don't think we can do flags validation at BPF
> > verification time, though, because it is defined as non-const integer
> > and we do have valid cases where we dynamically determine whether to
> > FORCE_WAKEUP or NO_WAKEUP, based on application-driven criteria (e.g.,
> > amount of enqueued data).
>
> Then shouldn't we remove the flags check in 'bpf_ringbuf_output()'?

bpf_ringbuf_output() combines reserve + commit operations, so if it
performs checks before anything is reserved in ringbuf, it's ok for it
to fail and return error. So I don't see any problem there. But once
it internally reserves, it always proceeds to complete the commit.
