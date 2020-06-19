Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07EB0201A8E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 20:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436673AbgFSSlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 14:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436668AbgFSSlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 14:41:31 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624BEC06174E;
        Fri, 19 Jun 2020 11:41:30 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id w90so7947855qtd.8;
        Fri, 19 Jun 2020 11:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XHmv1ekUZ+R3PNH51MCJg49mz2A0pYE+w+ycVVBqxj4=;
        b=jx8SwXYSM2uASnIgq+iBEPxKqzkW0kNYCOD02erbXzwAthEmt/RiwR4+z29qjMoS+P
         lEYxupZY8T40s3/u4oUp/kWOAIQCL3AnJFesw+CTjat6YTbVDWxgB3Vu0HmspymClFuy
         LDys9sD9D+y/dzglxheKBefJOwkOMF+JcbG5Ashe5bk0WG2gzL8nDDmycVyAq3Cs83uP
         SV/Qonc9eFKCnkHWpHYBPdwN66RY6DJE1zKLfyftLL9BDr8v1AEdFGI/BTRlrrIDqj2n
         ahl6cSVjMlX2k1z1aXqQzZxzNW1zfjFSZgDCdA/5sqlsiBUG0xO3DF2QN8e7GtCGbNXh
         97/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XHmv1ekUZ+R3PNH51MCJg49mz2A0pYE+w+ycVVBqxj4=;
        b=Cp/+wWCPjizOystSN19w5+FC4e+CdfyqH602UHL7fK+xGwIAM1ReT1Ge5Y3BEdVowQ
         ZmPGZBUo+O4ZukRqpC7+Qbih37QK5jh5fROGPFgikTYSfMYm1Vv0F/UQN1oh/Xrb1m3O
         h5TVGgzCqnT7DdyoJ4R7Cxg601jclO/wmaYUTvI1Pid9kkBQ6KV2CzOlRu/28f7sUvFG
         I7/YNfgEYcGwWV5CWG5A8eF94Ovq71E6W3d/LmpiiZ/NGxqtFEBelEdMFlZc1XYvP+Ev
         kJaUIZAS+CsPV/W5WQu6voTwG+fgRpCpxLM9vw6G6LN/YMGgENkvg1vvy3hsAjzt07wH
         NWgA==
X-Gm-Message-State: AOAM531wKHpZp90Fr3azBxA6CfY1GL7epkBAUWwm8usIKrXHn/KxKrox
        7kmeEPjtKsX45ZyAIMXQSQn36lqZKSlchM6wFQI=
X-Google-Smtp-Source: ABdhPJw6mjrzDNTAnYZhFJCQv6YRerhV64SJY3iHtZjZxwrw9vSh1WB5H3Fe4Bg5ZM/2xc2Vg93YfMeAtfwYN19stB8=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr4722535qta.141.1592592089563;
 Fri, 19 Jun 2020 11:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200617202112.2438062-1-andriin@fb.com> <5eeb0e5dcb010_8712abba49be5bc91@john-XPS-13-9370.notmuch>
 <CAEf4BzZi5pMTC9Fq53Mi_mXUm-EQZDyqS_pxEYuGoc0J1ETGUA@mail.gmail.com>
 <5eebb95299a20_6d292ad5e7a285b835@john-XPS-13-9370.notmuch>
 <CAEf4BzZmWO=hO0kmtwkACEfHZm+H7+FZ+5moaLie2=13U3xU=g@mail.gmail.com>
 <5eebf9321e11a_519a2abc9795c5bc21@john-XPS-13-9370.notmuch>
 <5eec09418954e_27ce2adb0816a5b8f7@john-XPS-13-9370.notmuch> <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net>
In-Reply-To: <45321002-2676-0f5b-c729-5526e503ebd2@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 19 Jun 2020 11:41:18 -0700
Message-ID: <CAEf4Bzb-nqK0Z=GaWWejriSqqGd6D5Cz_w689N7_51D+daGyvw@mail.gmail.com>
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

On Fri, Jun 19, 2020 at 6:08 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 6/19/20 2:39 AM, John Fastabend wrote:
> > John Fastabend wrote:
> >> Andrii Nakryiko wrote:
> >>> On Thu, Jun 18, 2020 at 11:58 AM John Fastabend
> >>> <john.fastabend@gmail.com> wrote:
> >
> > [...]
> >
> >>> That would be great. Self-tests do work, but having more testing with
> >>> real-world application would certainly help as well.
> >>
> >> Thanks for all the follow up.
> >>
> >> I ran the change through some CI on my side and it passed so I can
> >> complain about a few shifts here and there or just update my code or
> >> just not change the return types on my side but I'm convinced its OK
> >> in most cases and helps in some so...
> >>
> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >
> > I'll follow this up with a few more selftests to capture a couple of our
> > patterns. These changes are subtle and I worry a bit that additional
> > <<,s>> pattern could have the potential to break something.
> >
> > Another one we didn't discuss that I found in our code base is feeding
> > the output of a probe_* helper back into the size field (after some
> > alu ops) of subsequent probe_* call. Unfortunately, the tests I ran
> > today didn't cover that case.
> >
> > I'll put it on the list tomorrow and encode these in selftests. I'll
> > let the mainainers decide if they want to wait for those or not.
>
> Given potential fragility on verifier side, my preference would be that we
> have the known variations all covered in selftests before moving forward in
> order to make sure they don't break in any way. Back in [0] I've seen mostly
> similar cases in the way John mentioned in other projects, iirc, sysdig was
> another one. If both of you could hack up the remaining cases we need to
> cover and then submit a combined series, that would be great. I don't think
> we need to rush this optimization w/o necessary selftests.

There is no rush, but there is also no reason to delay it. I'd rather
land it early in the libbpf release cycle and let people try it in
their prod environments, for those concerned about such code patterns.

I don't have a list of all the patterns that we might need to test.
Going through all open-source BPF source code to identify possible
patterns and then coding them up in minimal selftests is a bit too
much for me, honestly. Additionally, some of those patterns will most
probably be broken in no-ALU32 and making them work with assembly and
other clever tricks is actually where the majority of time usually
goes. Also, simple selftests might not actually trigger pathological
codegen cases (because in a lot of cases register spill/pressure
triggers different codegen patterns). So I just don't believe we can
have a full piece of mind, regardless of how many selftests we add.
This test_varlen selftest is a simplification of a production code
we've had for a long while. We never bothered to contribute it as a
selftest before, which I'd say is our fault as users of BPF. Anyone
interested in ensuring regressions get detected for the way they write
BPF code, should distill them into selftests and contribute to our
test suite (like we did with PyPerf, Strobemeta, and how Jakub
Sitnicki did recently with his program).

So sure, maintainers might decide to not land this because of
potential regressions, but I tried to do my best to explain why there
shouldn't be really regressions (after all, int -> long reflects
*reality*, where everything is u64/s64 on return from BPF helper),
apart from actually testing for two patterns I knew about.

After all, even in case of regression, doing `int bla =
(int)bpf_helper_whatever(...);` is in theory equivalent to what we had
before, so it's an easy fix. Reality might require an extra compiler
barrier after that to force Clang to emit casting instructions sooner,
but that's another story.

>
> Thanks everyone,
> Daniel
>
>    [0] https://lore.kernel.org/bpf/20200421125822.14073-1-daniel@iogearbox.net/
