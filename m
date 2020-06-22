Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C23D20424D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbgFVVAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728545AbgFVVAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 17:00:34 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A428C061573;
        Mon, 22 Jun 2020 14:00:34 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i16so13800823qtr.7;
        Mon, 22 Jun 2020 14:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YDvIUKeo9xH5Wm1gAmY/bGb5lnUM5FVfVHbkLbq1g2w=;
        b=pZiDhiVtxb4rdN984Ke2l5Awqgvveq5jR4vQNh/Vh0U56QvI2H1JRtMQFKd8RaXGgM
         K0kYkGFU3BS5RdANVp/2WhLwYcatHGW7WEWooJoNaQOhEx2yAWJBlQC9uNyVvIhb0Aly
         6xWFxO93UGBn9xkAVfWesI0sWKLIkRqA6Ou15jaFzth8Zk5yOYrGMQ1oIlnszsLa3zF4
         yRhs7E/HpQ+tLy3r/uvlwE07KtcPb5VLxvoP1qZIopI0tAj9+G/KxWYgOebWV/lxBPVX
         GIk1f3a4Tu8O4sqSn7lbWLgokmifi/5AU+4j1M3GBzdknhVrKGuViqL1/DqR/0ychdKr
         kg5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YDvIUKeo9xH5Wm1gAmY/bGb5lnUM5FVfVHbkLbq1g2w=;
        b=bziRy8mScY/uiCsopWgX2lFOuiEwePpgvBmhJ+j6Xo7gpDlFSLeMc1RI62sHhpdMSC
         It/J7z6eB/CxzhR1GKJc1FFokBQsRiRwG5MR/OGDexSvhyG/cuxcQa70EXbXXznqPTPV
         Q8gJfMNKT8T21ts1TdB2F91GpnjzVEdmBOGRE1XWFmNc5oDCDsUDVmfZbQvmXpf1j6cu
         AP/vUIPcNwzSjlxCgPlGOdPgM5LuqRRniUh4I4gvxUEAFZ1qFF2HvHSdt0VgKANSiRmO
         G98/uQuNT7rGzfK1XCx0FA7iWMHcH/ZxsAaMLlQSnWGkQWTI5DjemEJOKLzH98nSQXld
         xPXw==
X-Gm-Message-State: AOAM5330gVAsuS8OFFGolVbVSqq5cXUW+0iS29rHNPHA7zFC7kgEJLDE
        Z1h0NKzP/5P3bMF6kJ3MvfFQUpH/S7Go4I4/bcY=
X-Google-Smtp-Source: ABdhPJwAuY/CYjR13ow7Ke85ifQYmBdaK3G2oqkYHzaNYOy6tuN/I9pXF8enJsb12kfL2CytvFIE5R6Na/q88Q9hrVQ=
X-Received: by 2002:ac8:2bba:: with SMTP id m55mr18231999qtm.171.1592859633094;
 Mon, 22 Jun 2020 14:00:33 -0700 (PDT)
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
 <CAEf4BzadWaEcXHMTAmg34Of4Y_QQAx1-_Rd9w5938nBHPCSPsQ@mail.gmail.com> <5ef1099fb5f9c_1c442b1627ad65c058@john-XPS-13-9370.notmuch>
In-Reply-To: <5ef1099fb5f9c_1c442b1627ad65c058@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 14:00:22 -0700
Message-ID: <CAEf4BzZFiXsPYW64RZ4FyNviRwqsqSzhaP-6m9BexUOwHD63tw@mail.gmail.com>
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

On Mon, Jun 22, 2020 at 12:42 PM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Mon, Jun 22, 2020 at 11:30 AM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > Andrii Nakryiko wrote:
> > > > On Fri, Jun 19, 2020 at 3:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > >
> > > > > On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> > > > > > On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > >> On 6/19/20 2:39 AM, John Fastabend wrote:
> > > > > >>> John Fastabend wrote:
> > > > > >>>> Andrii Nakryiko wrote:
> > > > > >>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> > > > > >>>>> <john.fastabend@gmail.com> wrote:
> > > > > >>>
> > > > > >>> [...]
> > > > > >>>
> > > > > >>>>> That would be great. Self-tests do work, but having more testing with
> > > > > >>>>> real-world application would certainly help as well.
> > > > > >>>>
> > > > > >>>> Thanks for all the follow up.
> > > > > >>>>
> > > > > >>>> I ran the change through some CI on my side and it passed so I can
> > > > > >>>> complain about a few shifts here and there or just update my code or
> > > > > >>>> just not change the return types on my side but I'm convinced its OK
> > > > > >>>> in most cases and helps in some so...
> > > > > >>>>
> > > > > >>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > >>>
> > > > > >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > > >>> patterns. These changes are subtle and I worry a bit that additional
> > > > > >>> <<,s>> pattern could have the potential to break something.
> > > > > >>>
> > > > > >>> Another one we didn't discuss that I found in our code base is feeding
> > > > > >>> the output of a probe_* helper back into the size field (after some
> > > > > >>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> > > > > >>> today didn't cover that case.
> > > > > >>>
> > > > > >>> I'll put it on the list tomorrow and encode these in selftests. I'll
> > > > > >>> let the mainainers decide if they want to wait for those or not.
> > > > > >>
> > > > > >> Given potential fragility on verifier side, my preference would be that we
> > > > > >> have the known variations all covered in selftests before moving forward in
> > > > > >> order to make sure they don't break in any way. Back in [0] I've seen mostly
> > > > > >> similar cases in the way John mentioned in other projects, iirc, sysdig was
> > > > > >> another one. If both of you could hack up the remaining cases we need to
> > > > > >> cover and then submit a combined series, that would be great. I don't think
> > > > > >> we need to rush this optimization w/o necessary selftests.
> > > > > >
> > > > > > There is no rush, but there is also no reason to delay it. I'd rather
> > > > > > land it early in the libbpf release cycle and let people try it in
> > > > > > their prod environments, for those concerned about such code patterns.
> > > > >
> > > > > Andrii, define 'delay'. John mentioned above to put together few more
> > > > > selftests today so that there is better coverage at least, why is that
> > > > > an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
> > > > > it's still as early. The unsigned optimization for len <= MAX_LEN is
> > > > > reasonable and makes sense, but it's still one [specific] variant only.
> > > >
> > > > I'm totally fine waiting for John's tests, but I read your reply as a
> > > > request to go dig up some more examples from sysdig and other
> > > > projects, which I don't think I can commit to. So if it's just about
> > > > waiting for John's examples, that's fine and sorry for
> > > > misunderstanding.
> > > >
> > > > >
> > > > > > I don't have a list of all the patterns that we might need to test.
> > > > > > Going through all open-source BPF source code to identify possible
> > > > > > patterns and then coding them up in minimal selftests is a bit too
> > > > > > much for me, honestly.
> > > > >
> > > > > I think we're probably talking past each other. John wrote above:
> > > >
> > > > Yep, sorry, I assumed more general context, not specifically John's reply.
> > > >
> > > > >
> > > > >  >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > >  >>> patterns. These changes are subtle and I worry a bit that additional
> > > > >  >>> <<,s>> pattern could have the potential to break something.
> > > > >
> > > > > So submitting this as a full series together makes absolutely sense to me,
> > > > > so there's maybe not perfect but certainly more confidence that also other
> > > > > patterns where the shifts optimized out in one case are then appearing in
> > > > > another are tested on a best effort and run our kselftest suite.
> > > > >
> > > > > Thanks,
> > > > > Daniel
> > >
> > > Hi Andrii,
> > >
> > > How about adding this on-top of your selftests patch? It will cover the
> > > cases we have now with 'len < 0' check vs 'len > MAX'. I had another case
> > > where we feed the out 'len' back into other probes but this requires more
> > > hackery than I'm willing to encode in a selftests. There seems to be
> > > some better options to improve clang side + verifier and get a clean
> > > working version in the future.
> >
> > Ok, sounds good. I'll add it as an extra patch. Not sure about all the
> > conventions with preserving Signed-off-by. Would just keeping your
> > Signed-off-by be ok? If you don't mind, though, I'll keep each
> > handler{32,64}_{gt,lt} as 4 independent BPF programs, so that if any
> > of them is unverifiable, it's easier to inspect the BPF assembly. Yell
> > if you don't like this.
>
> works for me, go for it.
>
> >
> > >
> > > On the clang/verifier side though I think the root cause is we do a poor
> > > job of tracking >>32, s<<32 case. How about we add a sign-extend instruction
> > > to BPF? Then clang can emit BPF_SEXT_32_64 and verifier can correctly
> > > account for it and finally backends can generate better code. This
> > > will help here, but also any other place we hit the sext codegen.
> > >
> > > Alexei, Yonghong, any opinions for/against adding new insn? I think we
> > > talked about doing it earlier.
> >
> > Seems like an overkill to me, honestly. I'd rather spend effort on
> > teaching Clang to always generate `w1 = w0` for such a case (for
> > alu32). For no-ALU32 recommendation would be to switch to ALU32, if
> > you want to work with int instead of long and care about two bitshift
> > operations. If you can stick to longs on no-ALU32, then no harm, no
> > foul.
> >
>
> Do you have an example of where clang doesn't generate just `w1 = w0`
> for the alu32 case? It really should at this point I'm not aware of
> any cases where it doesn't. I think you might have mentioned this
> earlier but I'm not seeing it.

Yeah, ALU32 + LONG for helpers + u32 for len variable. I actually call
this out explicitly in the commit message for this patch.

>
> There are other cases where sext gets generated in normal code and
> it would be nice to not always have to work around it.
