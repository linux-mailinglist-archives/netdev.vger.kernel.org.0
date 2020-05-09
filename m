Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48271CC243
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 16:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgEIOzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 10:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgEIOzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 10:55:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0649C061A0C;
        Sat,  9 May 2020 07:55:37 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e9so4805151iok.9;
        Sat, 09 May 2020 07:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Wd03D8Bf2bKPLRMUqGg5Cx0oxcErmoAYm8aSNwvVaWE=;
        b=bFephrkmRcSBGX7s5D+S8ILFs6R6A41is3j6PkTwiZ0v0tK78k8tplAZgJ0xoddM0n
         MpDVsphYraDAA8k5CB+za6DBA+5uef+pXSyDNdbQ2BmE7V0XeCNQIhjigxNRvxtsa2r+
         pr6F54VXJH1H6XTYgfy/VcvErh/vSy74OgzhAaM0mhJbVXa+oxAiCFbJ1xKFErwdyYlS
         on/U/E8wVl/9RXKefaI7bMWMCHCOJhplyEh7AcB58xKko15laCEBUvSm74Gfw5tyFw0l
         c9XkbYUbSYDpehvQ0hX95U7Imfm0iA4guhug9q0VLgG/PRieN9UJD3Jr7t32H18H44Th
         KtMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Wd03D8Bf2bKPLRMUqGg5Cx0oxcErmoAYm8aSNwvVaWE=;
        b=KYP9LTdlSN603O88EEdm0E94O7X2t03VU5ea4V4wg08Sfdm5MsIoEAWhrRhiTI3qe8
         VWrnJYFME/MqQvlgu3BXGxTfPIXK5HNkSzGGztZLNdUuztNx661x6xcLGE9qvtA+wI8T
         CExVXHZOGH6bXw+W3QzHdJnV4Vo7AiLwJ3pXl1vWQ6VfzDljLYrQyDIXDzxx6WfuyCa8
         x6JhCZYG3TPm9CtztOI0XcQ95+RoHhUsALOw4uuEIk8fZty+7q3ckBHgQJeqttJu/2sB
         i7gDJJpsiLUX5QW5a82sHZLvEqPUAQhH5PQDo8fGwgiTO+lW840kzTVVJtFSXu2514Iu
         xnQg==
X-Gm-Message-State: AGi0Pub1ydcGfj7vqWwengk2LfYanZ3BlB59PjptD50U9ewS/ippE99d
        BeFx3JN0I+tkpYP0vw2p3oA=
X-Google-Smtp-Source: APiQypIMF3K+jpwKNZ7Fn0Quhv9ILS4d/dJdp+jlNwOm8rdTiMkWvBVVlVbrnrUnQ9vaDTyKY+XxdQ==
X-Received: by 2002:a02:23c1:: with SMTP id u184mr7230824jau.11.1589036136919;
        Sat, 09 May 2020 07:55:36 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r8sm2402171ilc.80.2020.05.09.07.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 07:55:36 -0700 (PDT)
Date:   Sat, 09 May 2020 07:55:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Message-ID: <5eb6c45fa83a6_10632b06ebe825c0d0@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzahfsBO0Xy2+65MH7x8MY6vFkHSLSb27g9mHSj6kuDHDg@mail.gmail.com>
References: <158871160668.7537.2576154513696580062.stgit@john-Precision-5820-Tower>
 <CAEf4BzahfsBO0Xy2+65MH7x8MY6vFkHSLSb27g9mHSj6kuDHDg@mail.gmail.com>
Subject: Re: [bpf-next PATCH 00/10] bpf: selftests, test_sockmap improvements
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Tue, May 5, 2020 at 1:50 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > Update test_sockmap to add ktls tests and in the process make output
> > easier to understand and reduce overall runtime significantly. Before
> > this series test_sockmap did a poor job of tracking sent bytes causing
> > the recv thread to wait for a timeout even though all expected bytes
> > had been received. Doing this many times causes significant delays.
> > Further, we did many redundant tests because the send/recv test we used
> > was not specific to the parameters we were testing. For example testing
> > a failure case that always fails many times with different send sizes
> > is mostly useless. If the test condition catches 10B in the kernel code
> > testing 100B, 1kB, 4kB, and so on is just noise.
> >
> > The main motivation for this is to add ktls tests, the last patch. Until
> > now I have been running these locally but we haven't had them checked in
> > to selftests. And finally I'm hoping to get these pushed into the libbpf
> > test infrastructure so we can get more testing. For that to work we need
> > ability to white and blacklist tests based on kernel features so we add
> > that here as well.
> >
> > The new output looks like this broken into test groups with subtest
> > counters,
> >
> >  $ time sudo ./test_sockmap
> >  # 1/ 6  sockmap:txmsg test passthrough:OK
> >  # 2/ 6  sockmap:txmsg test redirect:OK
> >  ...
> >  #22/ 1 sockhash:txmsg test push/pop data:OK
> >  Pass: 22 Fail: 0
> >
> >  real    0m9.790s
> >  user    0m0.093s
> >  sys     0m7.318s
> >
> > The old output printed individual subtest and was rather noisy
> >
> >  $ time sudo ./test_sockmap
> >  [TEST 0]: (1, 1, 1, sendmsg, pass,): PASS
> >  ...
> >  [TEST 823]: (16, 1, 100, sendpage, ... ,pop (1599,1609),): PASS
> >  Summary: 824 PASSED 0 FAILED
> >
> >  real    0m56.761s
> >  user    0m0.455s
> >  sys     0m31.757s
> >
> > So we are able to reduce time from ~56s to ~10s. To recover older more
> > verbose output simply run with --verbose option. To whitelist and
> > blacklist tests use the new --whitelist and --blacklist flags added. For
> > example to run cork sockhash tests but only ones that don't have a receive
> > hang (used to test negative cases) we could do,
> >
> >  $ ./test_sockmap --whitelist="cork" --blacklist="sockmap,hang"
> >
> > ---
> 
> A lot of this seems to be re-implementing good chunks of what we
> already have in test_progs. Would it make more sense to either extract
> test runner pieces from test_progs into something that can be easily
> re-used for creating other test runners or just fold all these test
> into test_progs framework? None of this code is fun to write and
> maintain, so I'd rather have less copies of it :)

I like having its own test runner for test_sockmap. At leat I like
having the CLI around to run arbitrary tests while doing devloping
of BPF programs and on the kernel side.

We could fold all the test progs into progs framework but because
I want to keep test_sockmap CLI around it didn't make much sense.
I would still need most the code for the tool.

So I think the best thing is to share as much code as possible.
I am working on a series behind this to share more code on the
socket attach, listend, send/recv side but seeing this series was
getting large and adds the ktls support which I want in selftests
asap I pushed it. Once test_sockmap starts using the shared socket
senders, receivers, etc. I hope lots of code will dissapper.

The next easy candidate is the cgroup helpers. test_progs has
test__join_cgroup() test_sockmap has equivelent.

Its possible we could have used the same prog_test_def{} struct
but it seemed a bit overkill to me for this the _test{} struct
and helpers is ~50 lines here. Getting the socket handling and
cgroup handling into helpers seems like a bigger win.

Maybe the blacklist/whitelist could be reused with some refactoring
and avoid one-off codei for that as well.

Bottom line for me is this series improves things a lot on
the test_sockmap side with a reasonable patch series size. I
agree with your sentiment though and would propose doing those
things in follow up series likely in this order: socket handlers,
cgroup handlers, tester structure.

Thanks!


> 
> >
> > John Fastabend (10):
> >       bpf: selftests, move sockmap bpf prog header into progs
> >       bpf: selftests, remove prints from sockmap tests
> >       bpf: selftests, sockmap test prog run without setting cgroup
> >       bpf: selftests, print error in test_sockmap error cases
> >       bpf: selftests, improve test_sockmap total bytes counter
> >       bpf: selftests, break down test_sockmap into subtests
> >       bpf: selftests, provide verbose option for selftests execution
> >       bpf: selftests, add whitelist option to test_sockmap
> >       bpf: selftests, add blacklist to test_sockmap
> >       bpf: selftests, add ktls tests to test_sockmap
> >
> >
> >  .../selftests/bpf/progs/test_sockmap_kern.h        |  299 +++++++
> >  tools/testing/selftests/bpf/test_sockmap.c         |  911 ++++++++++----------
> >  tools/testing/selftests/bpf/test_sockmap_kern.h    |  451 ----------
> >  3 files changed, 769 insertions(+), 892 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_kern.h
> >  delete mode 100644 tools/testing/selftests/bpf/test_sockmap_kern.h
> >
> > --
> > Signature


