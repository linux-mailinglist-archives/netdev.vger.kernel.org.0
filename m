Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C984D2040A8
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgFVTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgFVTmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 15:42:33 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E50C061573;
        Mon, 22 Jun 2020 12:42:33 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u13so20893968iol.10;
        Mon, 22 Jun 2020 12:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=OckeUK/ck6N4WJ1msFqMTqBObdyPgo1ne/Nw8ybLmQQ=;
        b=gM0KfgDSq9REv13cBE7SZ4F7hK+JK7NwzwAw7nt/1CnWgIELRHgvTTqQp11+zmGQWF
         0yl4mRTK2FqX1TXogd0grm85VT2OaDbCGuFV1NK7H0lguLossjXwiaKybaRjKlyiP52T
         KCw0o9j2QGTMov4o8Pbl/fTOmunxz0fhx6AI+YOr83fcSW7oFnffabDKhoKdw++LfET4
         HQf3FLGSH/4K+z7mdiBrjjfYtadWOncXJtckHknEHvQx/Svtf0jz+y0p/CxhCeMa1ghc
         nVTNjhhcpcmPWwfdEMKcaZUZgWxlwc1F2iJzWH0g4qw+9cFUw1Xz7OJex2nSQEiQx1IS
         SJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=OckeUK/ck6N4WJ1msFqMTqBObdyPgo1ne/Nw8ybLmQQ=;
        b=h7486O8lxTH6IurrCDW3bhMVpq/oPOFglDUuyyCraUb2si2iFyvu32k7vBXR48TmTG
         JcJUGYfVfJAo1+tOHu3T7F4o+YTkP2Mfvq9UHzl5bd3w2aeHQ++MGd4hC8+7+qq4h+bT
         g1oHsVpzJDQXV7msK7K6oBSOHRnI7HLOt5QTtAsNhGRSh2T2HKOKApcISn4L3GHBcj47
         Zb7FvdLyBY3ZiMAmfwBq/LlSq4lXOrZTmGCyLPcdA0tIpKhN45WX4PJrNI5ECs6CFcHu
         DI8VIFqVSOHisNSFckIQkjDBiSx3NAsmG8/mtVi9TwEo7wD48ng8H6oVA/qFApPL4IGA
         3mUA==
X-Gm-Message-State: AOAM5334/XxecTwlSSIKKBvHNKqEl9EEz/B6PAcvBDKAvbBSS1HhC6mK
        e4r893IieeOmzBytfvdZjLQ=
X-Google-Smtp-Source: ABdhPJzeMkb3miTDRvURV07GKZUV09ue1sINQad8G4B+A2e18fR9BdQP6riUzMQWvO2dDxuyCuSW6Q==
X-Received: by 2002:a05:6638:686:: with SMTP id i6mr9286964jab.123.1592854952650;
        Mon, 22 Jun 2020 12:42:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f76sm5075412ilg.62.2020.06.22.12.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 12:42:31 -0700 (PDT)
Date:   Mon, 22 Jun 2020 12:42:23 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5ef1099fb5f9c_1c442b1627ad65c058@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzadWaEcXHMTAmg34Of4Y_QQAx1-_Rd9w5938nBHPCSPsQ@mail.gmail.com>
References: <20200617202112.2438062-1-andriin@fb.com>
 <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
 <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net>
 <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
 <24ac4e42-5831-f698-02f4-5f63d4620f1c@iogearbox.net>
 <CAEf4Bza6uGaxFURJaZirjVUt5yfFg5r-0mzaNPRg-irnA9CkcQ@mail.gmail.com>
 <5ef0f8ac51fad_1c442b1627ad65c09d@john-XPS-13-9370.notmuch>
 <CAEf4BzadWaEcXHMTAmg34Of4Y_QQAx1-_Rd9w5938nBHPCSPsQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Mon, Jun 22, 2020 at 11:30 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > On Fri, Jun 19, 2020 at 3:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> > > > > On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > >> On 6/19/20 2:39 AM, John Fastabend wrote:
> > > > >>> John Fastabend wrote:
> > > > >>>> Andrii Nakryiko wrote:
> > > > >>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> > > > >>>>> <john.fastabend@gmail.com> wrote:
> > > > >>>
> > > > >>> [...]
> > > > >>>
> > > > >>>>> That would be great. Self-tests do work, but having more testing with
> > > > >>>>> real-world application would certainly help as well.
> > > > >>>>
> > > > >>>> Thanks for all the follow up.
> > > > >>>>
> > > > >>>> I ran the change through some CI on my side and it passed so I can
> > > > >>>> complain about a few shifts here and there or just update my code or
> > > > >>>> just not change the return types on my side but I'm convinced its OK
> > > > >>>> in most cases and helps in some so...
> > > > >>>>
> > > > >>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > >>>
> > > > >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > >>> patterns. These changes are subtle and I worry a bit that additional
> > > > >>> <<,s>> pattern could have the potential to break something.
> > > > >>>
> > > > >>> Another one we didn't discuss that I found in our code base is feeding
> > > > >>> the output of a probe_* helper back into the size field (after some
> > > > >>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> > > > >>> today didn't cover that case.
> > > > >>>
> > > > >>> I'll put it on the list tomorrow and encode these in selftests. I'll
> > > > >>> let the mainainers decide if they want to wait for those or not.
> > > > >>
> > > > >> Given potential fragility on verifier side, my preference would be that we
> > > > >> have the known variations all covered in selftests before moving forward in
> > > > >> order to make sure they don't break in any way. Back in [0] I've seen mostly
> > > > >> similar cases in the way John mentioned in other projects, iirc, sysdig was
> > > > >> another one. If both of you could hack up the remaining cases we need to
> > > > >> cover and then submit a combined series, that would be great. I don't think
> > > > >> we need to rush this optimization w/o necessary selftests.
> > > > >
> > > > > There is no rush, but there is also no reason to delay it. I'd rather
> > > > > land it early in the libbpf release cycle and let people try it in
> > > > > their prod environments, for those concerned about such code patterns.
> > > >
> > > > Andrii, define 'delay'. John mentioned above to put together few more
> > > > selftests today so that there is better coverage at least, why is that
> > > > an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
> > > > it's still as early. The unsigned optimization for len <= MAX_LEN is
> > > > reasonable and makes sense, but it's still one [specific] variant only.
> > >
> > > I'm totally fine waiting for John's tests, but I read your reply as a
> > > request to go dig up some more examples from sysdig and other
> > > projects, which I don't think I can commit to. So if it's just about
> > > waiting for John's examples, that's fine and sorry for
> > > misunderstanding.
> > >
> > > >
> > > > > I don't have a list of all the patterns that we might need to test.
> > > > > Going through all open-source BPF source code to identify possible
> > > > > patterns and then coding them up in minimal selftests is a bit too
> > > > > much for me, honestly.
> > > >
> > > > I think we're probably talking past each other. John wrote above:
> > >
> > > Yep, sorry, I assumed more general context, not specifically John's reply.
> > >
> > > >
> > > >  >>> I'll follow this up with a few more selftests to capture a couple of our
> > > >  >>> patterns. These changes are subtle and I worry a bit that additional
> > > >  >>> <<,s>> pattern could have the potential to break something.
> > > >
> > > > So submitting this as a full series together makes absolutely sense to me,
> > > > so there's maybe not perfect but certainly more confidence that also other
> > > > patterns where the shifts optimized out in one case are then appearing in
> > > > another are tested on a best effort and run our kselftest suite.
> > > >
> > > > Thanks,
> > > > Daniel
> >
> > Hi Andrii,
> >
> > How about adding this on-top of your selftests patch? It will cover the
> > cases we have now with 'len < 0' check vs 'len > MAX'. I had another case
> > where we feed the out 'len' back into other probes but this requires more
> > hackery than I'm willing to encode in a selftests. There seems to be
> > some better options to improve clang side + verifier and get a clean
> > working version in the future.
> 
> Ok, sounds good. I'll add it as an extra patch. Not sure about all the
> conventions with preserving Signed-off-by. Would just keeping your
> Signed-off-by be ok? If you don't mind, though, I'll keep each
> handler{32,64}_{gt,lt} as 4 independent BPF programs, so that if any
> of them is unverifiable, it's easier to inspect the BPF assembly. Yell
> if you don't like this.

works for me, go for it.

> 
> >
> > On the clang/verifier side though I think the root cause is we do a poor
> > job of tracking >>32, s<<32 case. How about we add a sign-extend instruction
> > to BPF? Then clang can emit BPF_SEXT_32_64 and verifier can correctly
> > account for it and finally backends can generate better code. This
> > will help here, but also any other place we hit the sext codegen.
> >
> > Alexei, Yonghong, any opinions for/against adding new insn? I think we
> > talked about doing it earlier.
> 
> Seems like an overkill to me, honestly. I'd rather spend effort on
> teaching Clang to always generate `w1 = w0` for such a case (for
> alu32). For no-ALU32 recommendation would be to switch to ALU32, if
> you want to work with int instead of long and care about two bitshift
> operations. If you can stick to longs on no-ALU32, then no harm, no
> foul.
> 

Do you have an example of where clang doesn't generate just `w1 = w0`
for the alu32 case? It really should at this point I'm not aware of
any cases where it doesn't. I think you might have mentioned this
earlier but I'm not seeing it.

There are other cases where sext gets generated in normal code and
it would be nice to not always have to work around it.
