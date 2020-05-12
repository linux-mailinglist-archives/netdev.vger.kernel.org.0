Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D241CEB3E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgELDNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:13:50 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7478FC061A0C;
        Mon, 11 May 2020 20:13:50 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b6so11123029qkh.11;
        Mon, 11 May 2020 20:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iDSNQu5NM+JSr0tP1LCdotPyYAi2OsIrNzI95rF2jLM=;
        b=Wk9beM0ZuTM7Vvr1Luqi134+ji9BdS1x3V69EH9tnUFokkToxQDoViFDZI6I0SuQZ3
         gDJIsHoociP/gdMpHtgtwqCQKaGflpWSbpx6okE1ZC3Bg0SeFgNrjLblV/LziALzLHcl
         ptMQGr7+kxWRWaSG2B4n+QlU/cgdjx56fnI064zVGqcx9EQq9L8Gs6+fz3V5SgpushiI
         7qc7LPm/5O8IqB+cbCN3HhTm/P/KSCFjg7gx08rZ9JraT7p6dOrVDO7eitJ9d3EwmnmJ
         p1JgAoZE1f9uNSioWhSrH2or3FM108+bIhL2x5xHbqEh3shUQ8KvvFvChVTMitQyN9Du
         XGDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iDSNQu5NM+JSr0tP1LCdotPyYAi2OsIrNzI95rF2jLM=;
        b=K3ElJ+8tsePflMWLCXZcDKDr56g2UnzQmZc9YG0UsPxPr4/rMmEHwkuJbpO9jVXeYp
         fH53DMslTY0XCTPFnUXCbTydOgeFvMo7/RZSu4fGa8ZNgoqOJcL1BGZOgJ4Su4xxtsUc
         jHSfB7FL3ZAgONqKv9JltvJrvhkRkRLSSxbxSvYOUlz2bm3tfMp1TigRoxxOBZ3Erm94
         MzInIklkpObRkHBysMPF/tFaKlyd6TCQZCP7QJwU+sCXv3Ngl/IfPCHPbAP45k+O4x0w
         Ej569TLnc/JoJcP+Sgpq18XtVch04XRFq9LSUM6xrzdqS0ZesBX3ecnpbTx2PYShO/lr
         b1/Q==
X-Gm-Message-State: AGi0PubFKrNyMXMV0TI5jgYUkEZ8A0LwRPNeXe7t3RkJY3UXVOrf6NOa
        i/c/xlBUG+PPIUrJsfg3AImOEqMP3WaymLwoTwg=
X-Google-Smtp-Source: APiQypJR+NgNb8jXGD5moiJeP4WXbMZ1gSqDYU5of7kWANkHQCtZSsWX0L2Qu7hPWCAgemIdIdsXnpZ6SzXJPTt6t8c=
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr20214909qkg.437.1589253229629;
 Mon, 11 May 2020 20:13:49 -0700 (PDT)
MIME-Version: 1.0
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
 <CAEf4BzahfsBO0Xy2+65MH7x8MY6vFkHSLSb27g9mHSj6kuDHDg@mail.gmail.com> <5eb6c45fa83a6_10632b06ebe825c0d0@john-XPS-13-9370.notmuch>
In-Reply-To: <5eb6c45fa83a6_10632b06ebe825c0d0@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 May 2020 20:13:38 -0700
Message-ID: <CAEf4BzbT4ENMcCC5+ubxVjMggz3OGa1jBT741g8_MxbYzgN0=Q@mail.gmail.com>
Subject: Re: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap improvements
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 9, 2020 at 7:55 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Tue, May 5, 2020 at 1:50 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Update test_sockmap to add ktls tests and in the process make output
> > > easier to understand and reduce overall runtime significantly. Before
> > > this series test_sockmap did a poor job of tracking sent bytes causing
> > > the recv thread to wait for a timeout even though all expected bytes
> > > had been received. Doing this many times causes significant delays.
> > > Further, we did many redundant tests because the send/recv test we used
> > > was not specific to the parameters we were testing. For example testing
> > > a failure case that always fails many times with different send sizes
> > > is mostly useless. If the test condition catches 10B in the kernel code
> > > testing 100B, 1kB, 4kB, and so on is just noise.
> > >
> > > The main motivation for this is to add ktls tests, the last patch. Until
> > > now I have been running these locally but we haven't had them checked in
> > > to selftests. And finally I'm hoping to get these pushed into the libbpf
> > > test infrastructure so we can get more testing. For that to work we need
> > > ability to white and blacklist tests based on kernel features so we add
> > > that here as well.
> > >
> > > The new output looks like this broken into test groups with subtest
> > > counters,
> > >
> > >  $ time sudo ./test_sockmap
> > >  # 1/ 6  sockmap:txmsg test passthrough:OK
> > >  # 2/ 6  sockmap:txmsg test redirect:OK
> > >  ...
> > >  #22/ 1 sockhash:txmsg test push/pop data:OK
> > >  Pass: 22 Fail: 0
> > >
> > >  real    0m9.790s
> > >  user    0m0.093s
> > >  sys     0m7.318s
> > >
> > > The old output printed individual subtest and was rather noisy
> > >
> > >  $ time sudo ./test_sockmap
> > >  [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
> > >  ...
> > >  [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
> > >  Summary: 824 PASSED 0 FAILED
> > >
> > >  real    0m56.761s
> > >  user    0m0.455s
> > >  sys     0m31.757s
> > >
> > > So we are able to reduce time from ~56s to ~10s. To recover older more
> > > verbose output simply run with --verbose option. To whitelist and
> > > blacklist tests use the new --whitelist and --blacklist flags added. For
> > > example to run cork sockhash tests but only ones that don't have a receive
> > > hang (used to test negative cases) we could do,
> > >
> > >  $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"
> > >
> > > ---
> >
> > A lot of this seems to be re-implementing good chunks of what we
> > already have in test_progs. Would it make more sense to either extract
> > test runner pieces from test_progs into something that can be easily
> > re-used for creating other test runners or just fold all these test
> > into test_progs framework? None of this code is fun to write and
> > maintain, so I'd rather have less copies of it :)
>
> I like having its own test runner for test_sockmap. At leat I like
> having the CLI around to run arbitrary tests while doing devloping
> of BPF programs and on the kernel side.

Keeping them in separate binary is fine with me, but just wanted to
make sure you are aware of -t and -n options to test_progs? -t
test-substring[/subtest-substring] allows to select test(s), and,
optionally, subtests(s) by substring of their names. -n allows to do
selection by test/subtest numbers. This allows a very nice way to
debug/develop singular test or a small subset of tests. Just FYI, in
case you missed this feature.

>
> We could fold all the test progs into progs framework but because
> I want to keep test_sockmap CLI around it didn't make much sense.
> I would still need most the code for the tool.
>
> So I think the best thing is to share as much code as possible.
> I am working on a series behind this to share more code on the
> socket attach, listend, send/recv side but seeing this series was
> getting large and adds the ktls support which I want in selftests
> asap I pushed it. Once test_sockmap starts using the shared socket
> senders, receivers, etc. I hope lots of code will dissapper.
>
> The next easy candidate is the cgroup helpers. test_progs has
> test__join_cgroup() test_sockmap has equivelent.
>
> Its possible we could have used the same prog_test_def{} struct
> but it seemed a bit overkill to me for this the _test{} struct
> and helpers is ~50 lines here. Getting the socket handling and
> cgroup handling into helpers seems like a bigger win.

Test_progs is doing a bit more than just that. It's about 600 lines of
code just in test_progs.c, which does generic test
running/reporting/logging interception, etc. Plus some more in
test_progs.h. So I think sharing that "test runner base" could save
more code and allow more flexible test runner experience.

>
> Maybe the blacklist/whitelist could be reused with some refactoring
> and avoid one-off codei for that as well.
>
> Bottom line for me is this series improves things a lot on
> the test_sockmap side with a reasonable patch series size. I
> agree with your sentiment though and would propose doing those
> things in follow up series likely in this order: socket handlers,
> cgroup handlers, tester structure.

Yep, makes sense. I just wanted to make sure that this is on the table. Thanks!

>
> Thanks!
>
>
> >
> > >
> > > John Fastabend (10):
> > >       bpf: selftests, move sockmap bpf prog header into progs
> > >       bpf: selftests, remove prints from sockmap tests
> > >       bpf: selftests, sockmap test prog run without setting cgroup
> > >       bpf: selftests, print error in test_sockmap error cases
> > >       bpf: selftests, improve test_sockmap total bytes counter
> > >       bpf: selftests, break down test_sockmap into subtests
> > >       bpf: selftests, provide verbose option for selftests execution
> > >       bpf: selftests, add whitelist option to test_sockmap
> > >       bpf: selftests, add blacklist to test_sockmap
> > >       bpf: selftests, add ktls tests to test_sockmap
> > >
> > >
> > >  .../selftests/bpf/progs/test_sockmap_kern.h        |  299 +++++++
> > >  tools/testing/selftests/bpf/test_sockmap.c         |  911 ++++++++++----------
> > >  tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 ----------
> > >  3 files changed, 769 insertions(+), 892 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
> > >  delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h
> > >
> > > --
> > > Signature
>
>
