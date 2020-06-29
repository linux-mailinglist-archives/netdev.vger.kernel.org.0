Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0510320E41A
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgF2VVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbgF2Sws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:52:48 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E36C031C78;
        Mon, 29 Jun 2020 11:13:19 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id e13so16136897qkg.5;
        Mon, 29 Jun 2020 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twS0SHJ0tpWW/RvveG6R48ty/BejMf4B4mz8JuPn66w=;
        b=H97Sem+km39dRzORyaBMgYjQdrf0E87yvhB5vb1d3KG7EtSdQC/jT/udV4OSsrBPYS
         FOz007h8GjgqkQ6XSQ5uZHIuWmtUoFD23nQ4eIB7XnoI+3DJYoPh46H+QhHRXPcp1o1j
         RVuVKfu9Sh2xIO2d70XOemWpNc84ACJ53AfYVgqE+p2CF2yW2GQqecAFJu9OghkAIQgi
         E0RhGFAiB9s8d7QimvKn0Vao3M0q1cnchey54wCRsitEFviVBLipbxvqbBquhMbrUATu
         U+FymgZYhXxw1lGemyQq2TTzU8fVn/jU7SgnXpS2GHj9fRiymrvGhN+UZyIGYceCPHEL
         AfnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twS0SHJ0tpWW/RvveG6R48ty/BejMf4B4mz8JuPn66w=;
        b=KoSXbFlnYGpWBowpy0sUWV/7s/ZiXg4SsQRcH7ZUfijeMors7mmyCUkfX4RGCn32Ao
         pMmQl7OxfqSjAyU1juW0K+lHlFOjnANV40zB2scDBpKCh2QUumP8lhd6hQFw8DcN9dJ+
         nE1qmpHJjEQuFBMLmiudOBq4XEiXMI+6HBQ+Wj3VzfDCtxiv6VJqi+3vTAw4RP4fkeou
         RltQl6UTqbj3p9bB9sa8Mii29RBTkwyJWb/YflVySRkIpXxsIDmYI/F0maYFZKo6WA9Z
         sZe7M/m0kk1dl/0pw/bcGInTu/pC4rjt5UE26DmV8srW5OssrADUI+lMAQ8ksnMP8Csq
         mM8w==
X-Gm-Message-State: AOAM533V3nWeLDiBxagn256nQbvSOe+bWNMvTeCrXR+iQISCjLQAur6D
        piZh3vZRd5LJMTRyP1gmHsKlZsNNnQrAA1Wx35s=
X-Google-Smtp-Source: ABdhPJw/yYtDpU4X41/hDDEG4/K8emuKLEH++AyXZZZ9xr88Ao2OlH+ddshOxSY/LB+Js7NQ8FEIGok9UouZGj/aR3w=
X-Received: by 2002:a37:7683:: with SMTP id r125mr13834622qkc.39.1593454398945;
 Mon, 29 Jun 2020 11:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200626175501.1459961-1-kafai@fb.com> <20200626175545.1462191-1-kafai@fb.com>
 <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com>
 <20200627002302.3tqklvjxxuetjoxr@kafai-mbp.dhcp.thefacebook.com>
 <CAEf4BzZevDLp8Hzax3T8XzHLsMm85upCONULVVOEOyAxVGe4dA@mail.gmail.com> <20200629180035.huq42fif7wktfbja@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200629180035.huq42fif7wktfbja@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 11:13:07 -0700
Message-ID: <CAEf4Bzbke6B9Pf21xD0XXz_NGmuZMZcaWxbfgjdxBaNHc=zf1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpf: selftests: Restore netns after each test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Networking <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 11:00 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Sat, Jun 27, 2020 at 01:31:42PM -0700, Andrii Nakryiko wrote:
> > On Fri, Jun 26, 2020 at 5:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > On Fri, Jun 26, 2020 at 03:45:04PM -0700, Andrii Nakryiko wrote:
> > > > On Fri, Jun 26, 2020 at 10:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > > >
> > > > > It is common for networking tests creating its netns and making its own
> > > > > setting under this new netns (e.g. changing tcp sysctl).  If the test
> > > > > forgot to restore to the original netns, it would affect the
> > > > > result of other tests.
> > > > >
> > > > > This patch saves the original netns at the beginning and then restores it
> > > > > after every test.  Since the restore "setns()" is not expensive, it does it
> > > > > on all tests without tracking if a test has created a new netns or not.
> > > > >
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
> > > > >  tools/testing/selftests/bpf/test_progs.h |  2 ++
> > > > >  2 files changed, 23 insertions(+)
> > > > >
> > > > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > > > index 54fa5fa688ce..b521ce366381 100644
> > > > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > > > @@ -121,6 +121,24 @@ static void reset_affinity() {
> > > > >         }
> > > > >  }
> > > > >
> > > > > +static void save_netns(void)
> > > > > +{
> > > > > +       env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> > > > > +       if (env.saved_netns_fd == -1) {
> > > > > +               perror("open(/proc/self/ns/net)");
> > > > > +               exit(-1);
> > > > > +       }
> > > > > +}
> > > > > +
> > > > > +static void restore_netns(void)
> > > > > +{
> > > > > +       if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
> > > > > +               stdio_restore();
> > > > > +               perror("setns(CLONE_NEWNS)");
> > > > > +               exit(-1);
> > > > > +       }
> > > > > +}
> > > > > +
> > > > >  void test__end_subtest()
> > > > >  {
> > > > >         struct prog_test_def *test = env.test;
> > > > > @@ -643,6 +661,7 @@ int main(int argc, char **argv)
> > > > >                 return -1;
> > > > >         }
> > > > >
> > > > > +       save_netns();
> > > >
> > > > you should probably do this also after each sub-test in test__end_subtest()?
> > > You mean restore_netns()?
> >
> > oops, yeah :)
> >
> > >
> > > It is a tough call.
> > > Some tests may only want to create a netns at the beginning for all the subtests
> > > to use (e.g. sk_assign.c).  restore_netns() after each subtest may catch
> > > tester in surprise that the netns is not in its full control while its
> > > own test is running.
> >
> > Wouldn't it be better to update such self-tests to setns on each
> > sub-test properly? It should be a simple code re-use exercise, unless
> > I'm missing some other implications of having to do it before each
> > sub-test?
> It should be simple, I think.  Haven't looked into details of each test.
> However, I won't count re-running the same piece of code in a for-loop
> as a re-use exercise ;)
>
> In my vm, a quick try in forcing sk_assign.c to reconfigure netns in each
> subtest in the for loop increased the runtime from 1s to 8s.
> I guess it is not a big deal for test_progs.

Oh, no, thank you very much, no one needs extra 7 seconds of
test_progs run. Can you please remove reset_affinity() from sub-test
clean up then, and consistently do clean ups only between tests?

>
> >
> > The idea behind sub-test is (at least it was so far) that it's
> > independent from other sub-tests and tests, and it's only co-located
> > with other sub-tests for the purpose of code reuse and logical
> > grouping. Which is why we reset CPU affinity, for instance.
> >
> > >
> > > I think an individual test should have managed the netns properly within its
> > > subtests already if it wants a correct test result.  It can unshare at the
> > > beginning of each subtest to get a clean state (e.g. in patch 8).
> > > test_progs.c only ensures a config made by an earlier test does
> > > not affect the following tests.
> >
> > It's true that it gives more flexibility for test setup, but if we go
> > that way, we should do it consistently for CPU affinity resetting and
> > whatever else we do per-subtest. I wonder what your answers would be
> > for the above questions. We can go either way, just let's be
> > consistent.
> Right, I also don't feel strongly about which way to go for netns.
> I noticed reset_affinity().  cgroup cleanup is also per test though.
> I think netns is more close to cgroup in terms of bpf prog is running under it,
> so this patch picked the current way.
>
> If it is decided to stay with reset_affinity's way,  I can make netns change
> to other tests (there are two if i grep properly).
>
> It seems there is no existing subtest requires to reset_affinity.
