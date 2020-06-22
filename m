Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189D8204283
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 23:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbgFVVS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 17:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgFVVSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 17:18:55 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E13DC061573;
        Mon, 22 Jun 2020 14:18:55 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y5so21163573iob.12;
        Mon, 22 Jun 2020 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=MEMXMHskXHFKTsNmFRzR88S3DczJXOF771UOMMZICDQ=;
        b=BDTN880+g/wQZzh0n2EQC7J1FXVMK4IYiddokm0N603fK0R9wtMhW1Ikvrg7HsfljY
         niGvZJyoXq3kfL9KRFPhd0sHdh0cfI5bB/ST8ey/RjWCqnvU8Cx5IbaFAPXX7KDTOWZJ
         31ud3757FA1PeVoutDBhtUEvR4cO+CrQE8ojfkEuhdmrKbdPKRGoDjKSfrpBqQTCTWqH
         NPa73hsVshBedm5VStt13pqozk0+JFyUCc4jIA+H2m2hIUCpGPbZfM8Y5svwkTuiH001
         OoAryVpqUAS4oLI52URcROufqCUzT+UUw2LMtbYqVL/D1LM1JSvjoYOoM3pcSAPEHHlw
         w86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=MEMXMHskXHFKTsNmFRzR88S3DczJXOF771UOMMZICDQ=;
        b=ftrPaVlu3k0905xXgs2l26WKkiTjZyt59hdxYC3qEQMhTTWgBtN15lg1UxWV/Kf4Ht
         xm3fmXyheRUdqq2ea1vz+wOGZV9zmyaOrwuPBNYDJrY0R9nVa1Y30WDXrOA9NazdGOkN
         PCOYZBSVr6hX2hxJrwUwLkUxjm85kDnqLsIijcUw1cp+OB45UMDZERQFfMwA58v7//d4
         EwpQpaD8tDYEzdIwDnthVItBxx1VzyLN3NZvHyWX5FncQnsX2uOx/1V4CE0MjJW06Z4I
         yz2ieiErqFiTbHDTFUUdTmCHFFs9IlL4F0LG1bD0yzTdBtBilp/V7hwsWvOZjkefEWoV
         TFwg==
X-Gm-Message-State: AOAM530rLPIQGsvU0nw29vVmFvlfNk6Wq4rhARkfzCiHiu3zZJcWXDp7
        dT3j8rpNThJg7V6cU/F1UBQ=
X-Google-Smtp-Source: ABdhPJzKsR9KWkhszGBzLf8zlwCZMiqEFtJ4i8QKyHXacrAvLS2sRfxgkRRZ9kdzLhQV+xuOek3+cw==
X-Received: by 2002:a02:998d:: with SMTP id a13mr21127690jal.6.1592860734324;
        Mon, 22 Jun 2020 14:18:54 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n7sm723033iob.44.2020.06.22.14.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 14:18:53 -0700 (PDT)
Date:   Mon, 22 Jun 2020 14:18:44 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Message-ID: <5ef12034da033_47842ac6d2ff65b8bd@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZFiXsPYW64RZ4FyNviRwqsqSzhaP-6m9BexUOwHD63tw@mail.gmail.com>
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
 <5ef1099fb5f9c_1c442b1627ad65c058@john-XPS-13-9370.notmuch>
 <CAEf4BzZFiXsPYW64RZ4FyNviRwqsqSzhaP-6m9BexUOwHD63tw@mail.gmail.com>
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
> On Mon, Jun 22, 2020 at 12:42 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > On Mon, Jun 22, 2020 at 11:30 AM John Fastabend
> > > <john.fastabend@gmail.com> wrote:
> > > >
> > > > Andrii Nakryiko wrote:
> > > > > On Fri, Jun 19, 2020 at 3:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > >
> > > > > > On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> > > > > > > On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > > > > >> On 6/19/20 2:39 AM, John Fastabend wrote:
> > > > > > >>> John Fastabend wrote:
> > > > > > >>>> Andrii Nakryiko wrote:
> > > > > > >>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> > > > > > >>>>> <john.fastabend@gmail.com> wrote:
> > > > > > >>>
> > > > > > >>> [...]
> > > > > > >>>
> > > > > > >>>>> That would be great. Self-tests do work, but having more testing with
> > > > > > >>>>> real-world application would certainly help as well.
> > > > > > >>>>
> > > > > > >>>> Thanks for all the follow up.
> > > > > > >>>>
> > > > > > >>>> I ran the change through some CI on my side and it passed so I can
> > > > > > >>>> complain about a few shifts here and there or just update my code or
> > > > > > >>>> just not change the return types on my side but I'm convinced its OK
> > > > > > >>>> in most cases and helps in some so...
> > > > > > >>>>
> > > > > > >>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > > >>>
> > > > > > >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > > > >>> patterns. These changes are subtle and I worry a bit that additional
> > > > > > >>> <<,s>> pattern could have the potential to break something.
> > > > > > >>>
> > > > > > >>> Another one we didn't discuss that I found in our code base is feeding
> > > > > > >>> the output of a probe_* helper back into the size field (after some
> > > > > > >>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> > > > > > >>> today didn't cover that case.
> > > > > > >>>
> > > > > > >>> I'll put it on the list tomorrow and encode these in selftests. I'll
> > > > > > >>> let the mainainers decide if they want to wait for those or not.
> > > > > > >>
> > > > > > >> Given potential fragility on verifier side, my preference would be that we
> > > > > > >> have the known variations all covered in selftests before moving forward in
> > > > > > >> order to make sure they don't break in any way. Back in [0] I've seen mostly
> > > > > > >> similar cases in the way John mentioned in other projects, iirc, sysdig was
> > > > > > >> another one. If both of you could hack up the remaining cases we need to
> > > > > > >> cover and then submit a combined series, that would be great. I don't think
> > > > > > >> we need to rush this optimization w/o necessary selftests.
> > > > > > >
> > > > > > > There is no rush, but there is also no reason to delay it. I'd rather
> > > > > > > land it early in the libbpf release cycle and let people try it in
> > > > > > > their prod environments, for those concerned about such code patterns.
> > > > > >
> > > > > > Andrii, define 'delay'. John mentioned above to put together few more
> > > > > > selftests today so that there is better coverage at least, why is that
> > > > > > an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
> > > > > > it's still as early. The unsigned optimization for len <= MAX_LEN is
> > > > > > reasonable and makes sense, but it's still one [specific] variant only.
> > > > >
> > > > > I'm totally fine waiting for John's tests, but I read your reply as a
> > > > > request to go dig up some more examples from sysdig and other
> > > > > projects, which I don't think I can commit to. So if it's just about
> > > > > waiting for John's examples, that's fine and sorry for
> > > > > misunderstanding.
> > > > >
> > > > > >
> > > > > > > I don't have a list of all the patterns that we might need to test.
> > > > > > > Going through all open-source BPF source code to identify possible
> > > > > > > patterns and then coding them up in minimal selftests is a bit too
> > > > > > > much for me, honestly.
> > > > > >
> > > > > > I think we're probably talking past each other. John wrote above:
> > > > >
> > > > > Yep, sorry, I assumed more general context, not specifically John's reply.
> > > > >
> > > > > >
> > > > > >  >>> I'll follow this up with a few more selftests to capture a couple of our
> > > > > >  >>> patterns. These changes are subtle and I worry a bit that additional
> > > > > >  >>> <<,s>> pattern could have the potential to break something.
> > > > > >
> > > > > > So submitting this as a full series together makes absolutely sense to me,
> > > > > > so there's maybe not perfect but certainly more confidence that also other
> > > > > > patterns where the shifts optimized out in one case are then appearing in
> > > > > > another are tested on a best effort and run our kselftest suite.
> > > > > >
> > > > > > Thanks,
> > > > > > Daniel
> > > >
> > > > Hi Andrii,
> > > >
> > > > How about adding this on-top of your selftests patch? It will cover the
> > > > cases we have now with 'len < 0' check vs 'len > MAX'. I had another case
> > > > where we feed the out 'len' back into other probes but this requires more
> > > > hackery than I'm willing to encode in a selftests. There seems to be
> > > > some better options to improve clang side + verifier and get a clean
> > > > working version in the future.
> > >
> > > Ok, sounds good. I'll add it as an extra patch. Not sure about all the
> > > conventions with preserving Signed-off-by. Would just keeping your
> > > Signed-off-by be ok? If you don't mind, though, I'll keep each
> > > handler{32,64}_{gt,lt} as 4 independent BPF programs, so that if any
> > > of them is unverifiable, it's easier to inspect the BPF assembly. Yell
> > > if you don't like this.
> >
> > works for me, go for it.
> >
> > >
> > > >
> > > > On the clang/verifier side though I think the root cause is we do a poor
> > > > job of tracking >>32, s<<32 case. How about we add a sign-extend instruction
> > > > to BPF? Then clang can emit BPF_SEXT_32_64 and verifier can correctly
> > > > account for it and finally backends can generate better code. This
> > > > will help here, but also any other place we hit the sext codegen.
> > > >
> > > > Alexei, Yonghong, any opinions for/against adding new insn? I think we
> > > > talked about doing it earlier.
> > >
> > > Seems like an overkill to me, honestly. I'd rather spend effort on
> > > teaching Clang to always generate `w1 = w0` for such a case (for
> > > alu32). For no-ALU32 recommendation would be to switch to ALU32, if
> > > you want to work with int instead of long and care about two bitshift
> > > operations. If you can stick to longs on no-ALU32, then no harm, no
> > > foul.
> > >
> >
> > Do you have an example of where clang doesn't generate just `w1 = w0`
> > for the alu32 case? It really should at this point I'm not aware of
> > any cases where it doesn't. I think you might have mentioned this
> > earlier but I'm not seeing it.
> 
> Yeah, ALU32 + LONG for helpers + u32 for len variable. I actually call
> this out explicitly in the commit message for this patch.
> 

Maybe we are just saying the same thing but the <<32, s>>32 pattern
from the ALU32 + LONG for helpers + u32 is becuase llvm generated a
LLVM IR sext instruction. We need the sext because its promoting a
u32 type to a long. We can't just replace those with MOV instructions
like we do with zext giving the `w1=w0`. We would have to "know" the
helper call zero'd the upper bits but this isn't C standard. My
suggestion to fix this is to generate a BPF_SEXT and then let the
verifier handle it and JITs generate good code for it. On x86
we have a sign-extending move MOVSX for example.

Trying to go the other way and enforce callees zero upper bits of
return register seems inconsistent and more difficult to implement.

> >
> > There are other cases where sext gets generated in normal code and
> > it would be nice to not always have to work around it.


