Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B073B204436
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgFVXDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731099AbgFVXD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:03:29 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE73C061573;
        Mon, 22 Jun 2020 16:03:29 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z1so14035749qtn.2;
        Mon, 22 Jun 2020 16:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=miGri7+ySbKgLYLE37LsxAxDOfQqRpdF/EhBxXtvXU8=;
        b=MfmtbPEJ2z40erSXpWTrqXMU+VjYjKyBbO+/T9c1Qte7iTNdUxEn35F55ufQy+SG4S
         GiqJN0oYj6uTagG9ZPm/Or8HkQdi+Yx2ZmlMR2TtO6nA6uQqQn2hkVkyiQ5tnd13svtI
         vZI8/UzHocALIzSJAHNWTt6/oRBMSmSAUSiS3UCf6RwnmLA7d/xpmZ7cLUwiB6Y03ecE
         huXuvuzCik/5o7VXwdIfl/K0O9s01r8xdNj1/OmEM2ETvJFXt1MbgW/Q953sbfJYXRv/
         ecUBmVBbo1Be5rnGd9J2hWEJtx0v2aHF6VaWwk6dDAxWmp7FL7wEnLCj1UqEaGFuH8mI
         VT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=miGri7+ySbKgLYLE37LsxAxDOfQqRpdF/EhBxXtvXU8=;
        b=NhrhM3Z+L5g6XV4j8lrnhb2+8yECESFMfdevuTcyOdYjHwbIn4xIR1lhEbHtRU35il
         Wz+fTctY8uPoig9lre94EmxDxw01yKkQw9oI/fxFhVfJTqJWxMVILedCNJweyoAZOwjB
         jNn27XUBXjNF15gEWmtstBcUJgF/nqwlUvlGSwaAXBxma0aqdviUsUvbWzXRx7KpFZTr
         eU2kQ1AGHG5aRRQtxKZx/4gf16Ch47G+wbFU+Uh4qP5Ktngv2fbFXinC9eOvjE/qOJmS
         arnCdRD8CXT0gQpA/LPTV1i6zUAB66OXx+41nrRX+PRlhCJXmhuUNMO0DxV9uGDegabu
         F8fw==
X-Gm-Message-State: AOAM531QrNorA9wkf+8hKkoIWWSjCsaVOg21U14zlO3li4o1twvzuf4E
        hAtQ3bPO6d8TO5A5HItqj5iWU5ZCAtaMKrjTe8E=
X-Google-Smtp-Source: ABdhPJxFiWzbtxN9YHQtjEoFMFoSJ602i/iLjCC9i3zmWBJLRSLQRSHFwsjEIX6k8U8/v2rRM6a57OuEVC9tcxUAqdA=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr18648396qtm.171.1592867008542;
 Mon, 22 Jun 2020 16:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200617202112.2438062-1-andriin@fb.com> <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
 <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net> <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
 <24ac4e42-5831-f698-02f4-5f63d4620f1c@iogearbox.net> <CAEf4Bza6uGaxFURJaZirjVUt5yfFg5r-0mzaNPRg-irnA9CkcQ@mail.gmail.com>
 <5ef0f8ac51fad_1c442b1627ad65c09d@john-XPS-13-9370.notmuch>
 <CAEf4BzadWaEcXHMTAmg34Of4Y_QQAx1-_Rd9w5938nBHPCSPsQ@mail.gmail.com>
 <5ef1099fb5f9c_1c442b1627ad65c058@john-XPS-13-9370.notmuch>
 <CAEf4BzZFiXsPYW64RZ4FyNviRwqsqSzhaP-6m9BexUOwHD63tw@mail.gmail.com> <5ef12034da033_47842ac6d2ff65b8bd@john-XPS-13-9370.notmuch>
In-Reply-To: <5ef12034da033_47842ac6d2ff65b8bd@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 16:03:17 -0700
Message-ID: <CAEf4BzYusOR=ES3Sy6S4wvBpmY-hgdShm0s9amvDR-jz8_0kNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 2:18 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Mon, Jun 22, 2020 at 12:42 PM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Andrii Nakryiko wrote:
> > > > On Mon, Jun 22, 2020 at 11:30 AM John Fastabend
> > > > <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Andrii Nakryiko wrote:
> > > > > > On Fri, Jun 19, 2020 at 3:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > > >
> > > > > > > On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> > > > > > > > On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > > > >> On 6/19/20 2:39 AM, John Fastabend wrote:
> > > > > > > >>> John Fastabend wrote:
> > > > > > > >>>> Andrii Nakryiko wrote:
> > > > > > > >>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> > > > > > > >>>>> <john.fastabend@gmail.com> wrote:
> > > > > > > >>>
> > > > > > > >>> [...]
> > > > > > > >>>
> > > > > > > >>>>> That would be great. Self-tests do work, but having more testing with
> > > > > > > >>>>> real-world application would certainly help as well.
> > > > > > > >>>>
> > > > > > > >>>> Thanks for all the follow up.
> > > > > > > >>>>
> > > > > > > >>>> I ran the change through some CI on my side and it passed so I can
> > > > > > > >>>> complain about a few shifts here and there or just update my code or
> > > > > > > >>>> just not change the return types on my side but I'm convinced its OK
> > > > > > > >>>> in most cases and helps in some so...
> > > > > > > >>>>
> > > > > > > >>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > > > >>>
> > > > > > > >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > > > > >>> patterns. These changes are subtle and I worry a bit that additional
> > > > > > > >>> <<,s>> pattern could have the potential to break something.
> > > > > > > >>>
> > > > > > > >>> Another one we didn't discuss that I found in our code base is feeding
> > > > > > > >>> the output of a probe_* helper back into the size field (after some
> > > > > > > >>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> > > > > > > >>> today didn't cover that case.
> > > > > > > >>>
> > > > > > > >>> I'll put it on the list tomorrow and encode these in selftests. I'll
> > > > > > > >>> let the mainainers decide if they want to wait for those or not.
> > > > > > > >>
> > > > > > > >> Given potential fragility on verifier side, my preference would be that we
> > > > > > > >> have the known variations all covered in selftests before moving forward in
> > > > > > > >> order to make sure they don't break in any way. Back in [0] I've seen mostly
> > > > > > > >> similar cases in the way John mentioned in other projects, iirc, sysdig was
> > > > > > > >> another one. If both of you could hack up the remaining cases we need to
> > > > > > > >> cover and then submit a combined series, that would be great. I don't think
> > > > > > > >> we need to rush this optimization w/o necessary selftests.
> > > > > > > >
> > > > > > > > There is no rush, but there is also no reason to delay it. I'd rather
> > > > > > > > land it early in the libbpf release cycle and let people try it in
> > > > > > > > their prod environments, for those concerned about such code patterns.
> > > > > > >
> > > > > > > Andrii, define 'delay'. John mentioned above to put together few more
> > > > > > > selftests today so that there is better coverage at least, why is that
> > > > > > > an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
> > > > > > > it's still as early. The unsigned optimization for len <= MAX_LEN is
> > > > > > > reasonable and makes sense, but it's still one [specific] variant only.
> > > > > >
> > > > > > I'm totally fine waiting for John's tests, but I read your reply as a
> > > > > > request to go dig up some more examples from sysdig and other
> > > > > > projects, which I don't think I can commit to. So if it's just about
> > > > > > waiting for John's examples, that's fine and sorry for
> > > > > > misunderstanding.
> > > > > >
> > > > > > >
> > > > > > > > I don't have a list of all the patterns that we might need to test.
> > > > > > > > Going through all open-source BPF source code to identify possible
> > > > > > > > patterns and then coding them up in minimal selftests is a bit too
> > > > > > > > much for me, honestly.
> > > > > > >
> > > > > > > I think we're probably talking past each other. John wrote above:
> > > > > >
> > > > > > Yep, sorry, I assumed more general context, not specifically John's reply.
> > > > > >
> > > > > > >
> > > > > > >  >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > > > >  >>> patterns. These changes are subtle and I worry a bit that additional
> > > > > > >  >>> <<,s>> pattern could have the potential to break something.
> > > > > > >
> > > > > > > So submitting this as a full series together makes absolutely sense to me,
> > > > > > > so there's maybe not perfect but certainly more confidence that also other
> > > > > > > patterns where the shifts optimized out in one case are then appearing in
> > > > > > > another are tested on a best effort and run our kselftest suite.
> > > > > > >
> > > > > > > Thanks,
> > > > > > > Daniel
> > > > >
> > > > > Hi Andrii,
> > > > >
> > > > > How about adding this on-top of your selftests patch? It will cover the
> > > > > cases we have now with 'len < 0' check vs 'len > MAX'. I had another case
> > > > > where we feed the out 'len' back into other probes but this requires more
> > > > > hackery than I'm willing to encode in a selftests. There seems to be
> > > > > some better options to improve clang side + verifier and get a clean
> > > > > working version in the future.
> > > >
> > > > Ok, sounds good. I'll add it as an extra patch. Not sure about all the
> > > > conventions with preserving Signed-off-by. Would just keeping your
> > > > Signed-off-by be ok? If you don't mind, though, I'll keep each
> > > > handler{32,64}_{gt,lt} as 4 independent BPF programs, so that if any
> > > > of them is unverifiable, it's easier to inspect the BPF assembly. Yell
> > > > if you don't like this.
> > >
> > > works for me, go for it.
> > >
> > > >
> > > > >
> > > > > On the clang/verifier side though I think the root cause is we do a poor
> > > > > job of tracking >>32, s<<32 case. How about we add a sign-extend instruction
> > > > > to BPF? Then clang can emit BPF_SEXT_32_64 and verifier can correctly
> > > > > account for it and finally backends can generate better code. This
> > > > > will help here, but also any other place we hit the sext codegen.
> > > > >
> > > > > Alexei, Yonghong, any opinions for/against adding new insn? I think we
> > > > > talked about doing it earlier.
> > > >
> > > > Seems like an overkill to me, honestly. I'd rather spend effort on
> > > > teaching Clang to always generate `w1 = w0` for such a case (for
> > > > alu32). For no-ALU32 recommendation would be to switch to ALU32, if
> > > > you want to work with int instead of long and care about two bitshift
> > > > operations. If you can stick to longs on no-ALU32, then no harm, no
> > > > foul.
> > > >
> > >
> > > Do you have an example of where clang doesn't generate just `w1 = w0`
> > > for the alu32 case? It really should at this point I'm not aware of
> > > any cases where it doesn't. I think you might have mentioned this
> > > earlier but I'm not seeing it.
> >
> > Yeah, ALU32 + LONG for helpers + u32 for len variable. I actually call
> > this out explicitly in the commit message for this patch.
> >
>
> Maybe we are just saying the same thing but the <<32, s>>32 pattern
> from the ALU32 + LONG for helpers + u32 is becuase llvm generated a
> LLVM IR sext instruction. We need the sext because its promoting a
> u32 type to a long. We can't just replace those with MOV instructions
> like we do with zext giving the `w1=w0`. We would have to "know" the
> helper call zero'd the upper bits but this isn't C standard. My
> suggestion to fix this is to generate a BPF_SEXT and then let the
> verifier handle it and JITs generate good code for it. On x86
> we have a sign-extending move MOVSX for example.
>

There is no sign extension there, we convert long into u32, so just
truncating upper 32 bits and leaving lower 32 bits intact. Here are
relevant listings:

ALU32 + INT                                ALU32 + LONG
===========                                ============

32-BIT (11 insns):                         32-BIT (12 insns):
------------------------------------       ------------------------------------
  17:   call 115                             17:   call 115
  18:   if w0 > 256 goto +7 <LBB1_4>         18:   if w0 > 256 goto +8 <LBB1_4>
  19:   r1 = 0 ll                            19:   r1 = 0 ll
  21:   *(u32 *)(r1 + 0) = r0                21:   *(u32 *)(r1 + 0) = r0
  22:   w1 = w0                              22:   r0 <<= 32
  23:   r6 = 0 ll                            23:   r0 >>= 32
  25:   r6 += r1                             24:   r6 = 0 ll
00000000000000d0 <LBB1_4>:                   26:   r6 += r0
  26:   r1 = r6                            00000000000000d8 <LBB1_4>:
  27:   w2 = 256                             27:   r1 = r6
  28:   r3 = 0 ll                            28:   w2 = 256
  30:   call 115                             29:   r3 = 0 ll
                                             31:   call 115

See insns 22-23 on the right side and equivalent insn 17 on the left
side. It's identical code except for these bit shifts. It still seems
to me the suboptimal choice on the part of Clang.


> Trying to go the other way and enforce callees zero upper bits of
> return register seems inconsistent and more difficult to implement.
>
> > >
> > > There are other cases where sext gets generated in normal code and
> > > it would be nice to not always have to work around it.
>
>
