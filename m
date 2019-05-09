Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF345195C9
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEIXu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:50:26 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35920 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfEIXuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:50:25 -0400
Received: by mail-yw1-f67.google.com with SMTP id q185so3319310ywe.3
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5quEiHLT4OMM8uAtEyE6ssCwX+Tlc/tlF1cJ80hdlCo=;
        b=Yb6NlW7EuGFojTawn32TB9LQF5nF0ZNtt6F1yFsWqlGrK+aG8y+VI4el3bL2l/EaWV
         UPgZEgTqj522LrewHS0FP3fF8+3mYcY4taIV5BZCiJbto795k3oa+d2NQwIEk0o4MWY8
         Bm8XI3xJOCB+eU1I5kFnvXGRCV3wHbDtyZ2jt36I0qz51CEEkIiky1621NDlz4WeEYK2
         oUiC1gzKymtI/T9kUiqCAy+42zkTIjSHlh2ZB5r1fN+5YgSnCFjS6y9rQ2ixFauOjsIa
         bUzkM2oyo7wIv4IA69GzsIInqA/8udLEgo+sSJKalkyGKrMxDSWNj3JUWq8Rf8fFLhFO
         ++MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5quEiHLT4OMM8uAtEyE6ssCwX+Tlc/tlF1cJ80hdlCo=;
        b=O5B751ilOTT/VFH7Vt7KgrLAlY5O/JcnR8lEE7c3w9rTR8OvDWCV+pkvW+YJJMuIaC
         Sfg3xPqnj8e5Ilqp6GH9afsQXBjJoWivqcqSDszLaAFFukqjn71EXIK8a7uszjEPmhYU
         +Tw67rpA4Sfcvr4JhFB7IWtFBi1mvT5frcgAAre5itACjEbI8xQhbDltDrrEOTSVxrFT
         uydTl1Z7i6fSeiLwhBlXVYASnmaBmhmPfa3rrT7j3fI7njQesLpf9AixzrTTgxz0FCWW
         nGJIIwdP+bEPdMCmCXVycjhR8tQdcmZddXQLaTZwMPmr0sOUOXadRj5nziyNWMktS+7Y
         rSNA==
X-Gm-Message-State: APjAAAUnavYMdbfVrIAxL2ENHeFrGy2nQRGOPynyPM1dgBgdXCffkEMl
        uBpCli//niSP1rp/7Ej8OuSZ3nTBA1lRHQbnHtZg5Q==
X-Google-Smtp-Source: APXvYqxaNkyCYhql4457bZMi/BQ9pd96Zr5bjW0N02eviarbLdp3YmhMz72UBXrC8EJIO+baU9/40LrWoePA8iqki3I=
X-Received: by 2002:a81:27cc:: with SMTP id n195mr3992881ywn.60.1557445824113;
 Thu, 09 May 2019 16:50:24 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
 <20190508230941.6rqccgijqzkxmz4t@ast-mbp> <CANn89iL_1n8Lb5yCEk3ZrBsUtPPWPZ=0BiELUo+jyBWfLfaAzg@mail.gmail.com>
 <20190509044720.fxlcldi74atev5id@ast-mbp> <CANn89i+v52ktezz5J_0of_EvTUozf86rP1Uh36HpbHf33uzDJg@mail.gmail.com>
 <CANn89iK8e8ROW8CrtTDq9-_bFeg2MdeqAdjf10i6HiwKuaZi=g@mail.gmail.com>
 <e525ec9d-df46-4280-b1c8-486a809f61e6@iogearbox.net> <20190509233023.jrezshp2aglvoieo@ast-mbp>
In-Reply-To: <20190509233023.jrezshp2aglvoieo@ast-mbp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 9 May 2019 16:50:12 -0700
Message-ID: <CANn89iJ+2_5Myyy3HLjxoJa9ZPzDg3a0DQkK2auwoLnWqNWB-A@mail.gmail.com>
Subject: Re: Question about seccomp / bpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kees Cook <keescook@google.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jann Horn <jannh@google.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 9, 2019 at 4:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 09, 2019 at 01:49:25PM +0200, Daniel Borkmann wrote:
> > On 05/09/2019 12:58 PM, Eric Dumazet wrote:
> > > On Thu, May 9, 2019 at 3:52 AM Eric Dumazet <edumazet@google.com> wrote:
> > >> On Wed, May 8, 2019 at 9:47 PM Alexei Starovoitov
> > >> <alexei.starovoitov@gmail.com> wrote:
> > >>> On Wed, May 08, 2019 at 04:17:29PM -0700, Eric Dumazet wrote:
> > >>>> On Wed, May 8, 2019 at 4:09 PM Alexei Starovoitov
> > >>>> <alexei.starovoitov@gmail.com> wrote:
> > >>>>> On Wed, May 08, 2019 at 02:21:52PM -0700, Eric Dumazet wrote:
> > >>>>>> Hi Alexei and Daniel
> > >>>>>>
> > >>>>>> I have a question about seccomp.
> > >>>>>>
> > >>>>>> It seems that after this patch, seccomp no longer needs a helper
> > >>>>>> (seccomp_bpf_load())
> > >>>>>>
> > >>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd4cf0ed331a275e9bf5a49e6d0fd55dffc551b8
> > >>>>>>
> > >>>>>> Are we detecting that a particular JIT code needs to call at least one
> > >>>>>> function from the kernel at all ?
> > >>>>>
> > >>>>> Currently we don't track such things and trying very hard to avoid
> > >>>>> any special cases for classic vs extended.
> > >>>>>
> > >>>>>> If the filter contains self-contained code (no call, just inline
> > >>>>>> code), then we could use any room in whole vmalloc space,
> > >>>>>> not only from the modules (which is something like 2GB total on x86_64)
> > >>>>>
> > >>>>> I believe there was an effort to make bpf progs and other executable things
> > >>>>> to be everywhere too, but I lost the track of it.
> > >>>>> It's not that hard to tweak x64 jit to emit 64-bit calls to helpers
> > >>>>> when delta between call insn and a helper is more than 32-bit that fits
> > >>>>> into call insn. iirc there was even such patch floating around.
> > >>>>>
> > >>>>> but what motivated you question? do you see 2GB space being full?!
> > >>>>
> > >>>> A customer seems to hit the limit, with about 75,000 threads,
> > >>>> each one having a seccomp filter with 6 pages (plus one guard page
> > >>>> given by vmalloc)
> > >>>
> > >>> Since cbpf doesn't have "fd as a program" concept I suspect
> > >>> the same program was loaded 75k times. What a waste of kernel memory.
> > >>> And, no, we're not going to extend or fix cbpf for this.
> > >>> cbpf is frozen. seccomp needs to start using ebpf.
> > >>> It can have one program to secure all threads.
> > >>> If necessary single program can be customized via bpf maps
> > >>> for each thread.
> > >>
> > >> Yes,  docker seems to have a very generic implementation and  should
> > >> probably be fixed
> > >> ( https://github.com/moby/moby/blob/v17.03.2-ce/profiles/seccomp/seccomp.go )
> > >
> > > Even if the seccomp program was optimized to a few bytes, it would
> > > still consume at least 2 pages in module vmalloc space,
> > > so the limit in number of concurrent programs would be around 262,144
> > >
> > > We might ask seccomp guys to detect that the same program is used, by
> > > maintaining a hash of already loaded ones.
> > > ( I see struct seccomp_filter has a @usage refcount_t )
> >
> > +1, that would indeed be worth to pursue as a short term solution.
>
> I'm not sure how that can work. seccomp's prctl accepts a list of insns.
> There is no handle.
> kernel can keep a hashtable of all progs ever loaded and do a search
> in it before loading another one, but that's an ugly hack.

I guess that if such a hack is doable and can save 2GB of memory, then
it is an acceptable one.


> Another alternative is to attach seccomp prog to parent task
> instead of N childrens.

seccomp filters are stacked, the parent(s) filter(s) might be very different.
