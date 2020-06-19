Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D33201E80
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 01:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgFSXLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 19:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbgFSXLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 19:11:19 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68312C06174E;
        Fri, 19 Jun 2020 16:11:19 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cv17so5259031qvb.13;
        Fri, 19 Jun 2020 16:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ar26egJbF99kcPEeMmrjA86yF8a71qXeh2j+7ovsSZw=;
        b=npX+WAy59xvh7eSJe9LYqsYVP+lIV5Rt3a/1E3Dh1GAdNViZ1ARk33U6AxxSr4zfoH
         pdMqvSqA1kggRtCcZqL0gV+K8XoVw6f0Mj35OKqZKq5usvkNgE92ctQjybqdlatdYKeO
         hmehPLp5L/a3Q/wzy8x6KkBr82J+PFhlNXQGTOYSZoMrdwNk8QWy2D19FopaSrp2TkRa
         /scfcRNjd8wNKFrduobCb7ZWbXN5oKqQzjgW38WjNBlCZhkoVlpKEbyKUCZSEz3KTr0b
         7JXjDXA30l7OncXcV0MaCmgrrpq73T3JXv4uf0RZmbnu9+80cAgsWbzNf7OT8+npIJt3
         B84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ar26egJbF99kcPEeMmrjA86yF8a71qXeh2j+7ovsSZw=;
        b=mLvNRyFy+yS6Xnl8PoACKKTMer/9U7RuheVcScZa0Do7/PTRcfTUdmutRTL0YaODEN
         LLZwSIS0dG/fEagjr8RJGEW1elLSuECOHEMrQ9bBbB316r55MMaI2ZVPLta5BCJQqSRe
         LIPP3ZVAbsBPh/nUxgyQ4gnx6r8LFte3Ddgcjy8/6vEhTVCyklilZ42YlOMIyOG/Vriq
         rmkH+vEDXpFggt3jB9JhMvuaOiIazUATnYJwj+A+KezKqGQ2cjYMEhQTbnoN2+OPbMDJ
         Ovs3kChcy7hg7645fkUBrVBkEG+BAnb1vXlN/bguebdq3T176UGWAntZ+EYmHQOUOkUV
         2NvA==
X-Gm-Message-State: AOAM5327SVTxVpjsS0ozaXfkccMMbmQ4qko1X61CmkKFg0PDq6f4iTac
        mmlS83/8OAFj+m3dIQdIK9y0RxSJchmboSZeu5E=
X-Google-Smtp-Source: ABdhPJydr/ZESX9+fhLLtzP52CMGiwSuj0ybyuLBa6C6YxOf56sg07hsFNCJoZo+75GOLkN9sOua9TYh7GON66r8pNU=
X-Received: by 2002:ad4:4baa:: with SMTP id i10mr11562273qvw.163.1592608278572;
 Fri, 19 Jun 2020 16:11:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200617202112.2438062-1-andriin@fb.com> <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch>
 <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net> <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
 <24ac4e42-5831-f698-02f4-5f63d4620f1c@iogearbox.net>
In-Reply-To: <24ac4e42-5831-f698-02f4-5f63d4620f1c@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jun 2020 16:11:07 -0700
Message-ID: <CAEf4Bza6uGaxFURJaZirjVUt5yfFg5r-0mzaNPRg-irnA9CkcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: switch most helper return values from
 32-bit int to 64-bit long
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 3:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/19/20 8:41 PM, Andrii Nakryiko wrote:
> > On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 6/19/20 2:39 AM, John Fastabend wrote:
> >>> John Fastabend wrote:
> >>>> Andrii Nakryiko wrote:
> >>>>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> >>>>> <john.fastabend@gmail.com> wrote:
> >>>
> >>> [...]
> >>>
> >>>>> That would be great. Self-tests do work, but having more testing with
> >>>>> real-world application would certainly help as well.
> >>>>
> >>>> Thanks for all the follow up.
> >>>>
> >>>> I ran the change through some CI on my side and it passed so I can
> >>>> complain about a few shifts here and there or just update my code or
> >>>> just not change the return types on my side but I'm convinced its OK
> >>>> in most cases and helps in some so...
> >>>>
> >>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >>>
> >>> I'll follow this up with a few more selftests to capture a couple of our
> >>> patterns. These changes are subtle and I worry a bit that additional
> >>> <<,s>> pattern could have the potential to break something.
> >>>
> >>> Another one we didn't discuss that I found in our code base is feeding
> >>> the output of a probe_* helper back into the size field (after some
> >>> alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> >>> today didn't cover that case.
> >>>
> >>> I'll put it on the list tomorrow and encode these in selftests. I'll
> >>> let the mainainers decide if they want to wait for those or not.
> >>
> >> Given potential fragility on verifier side, my preference would be that we
> >> have the known variations all covered in selftests before moving forward in
> >> order to make sure they don't break in any way. Back in [0] I've seen mostly
> >> similar cases in the way John mentioned in other projects, iirc, sysdig was
> >> another one. If both of you could hack up the remaining cases we need to
> >> cover and then submit a combined series, that would be great. I don't think
> >> we need to rush this optimization w/o necessary selftests.
> >
> > There is no rush, but there is also no reason to delay it. I'd rather
> > land it early in the libbpf release cycle and let people try it in
> > their prod environments, for those concerned about such code patterns.
>
> Andrii, define 'delay'. John mentioned above to put together few more
> selftests today so that there is better coverage at least, why is that
> an 'issue'? I'm not sure how you read 'late in release cycle' out of it,
> it's still as early. The unsigned optimization for len <= MAX_LEN is
> reasonable and makes sense, but it's still one [specific] variant only.

I'm totally fine waiting for John's tests, but I read your reply as a
request to go dig up some more examples from sysdig and other
projects, which I don't think I can commit to. So if it's just about
waiting for John's examples, that's fine and sorry for
misunderstanding.

>
> > I don't have a list of all the patterns that we might need to test.
> > Going through all open-source BPF source code to identify possible
> > patterns and then coding them up in minimal selftests is a bit too
> > much for me, honestly.
>
> I think we're probably talking past each other. John wrote above:

Yep, sorry, I assumed more general context, not specifically John's reply.

>
>  >>> I'll follow this up with a few more selftests to capture a couple of our
>  >>> patterns. These changes are subtle and I worry a bit that additional
>  >>> <<,s>> pattern could have the potential to break something.
>
> So submitting this as a full series together makes absolutely sense to me,
> so there's maybe not perfect but certainly more confidence that also other
> patterns where the shifts optimized out in one case are then appearing in
> another are tested on a best effort and run our kselftest suite.
>
> Thanks,
> Daniel
