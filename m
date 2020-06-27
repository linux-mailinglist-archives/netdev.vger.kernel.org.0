Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E4A20C414
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgF0Uby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgF0Uby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:31:54 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEEEC061794;
        Sat, 27 Jun 2020 13:31:54 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id t7so6021720qvl.8;
        Sat, 27 Jun 2020 13:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJQanw1Sm8hwnATJTWZ5T87d463paNUhJgkC8Hl7E0E=;
        b=hEJh7yY9E4qYRjNevS/zCPlzGDcwOQLghXYfGA8p/z8UwYcLgDuh3WmSm623l9uTCC
         hyhJUL5d5FbMyIn6fA33oRNyD5HJ9lYWApGYAZfJT9X1uQTNVEE9hBYqhtwctwTSan6U
         v5rEoYoHZ6/q8q6wCnlRh5azFy8q4hAC8e8Y7zlARr+3V+80GXDpqDNRShfC0I+sk9YQ
         IBhpEwmz22oMsB4/NAZkCMa4dYK4dkfxtMnRuSsxsFokBydRROb8vCvawI6TwJR+gDjQ
         2gfFIVMU9+MWEJcqAhDk35E6TEcy1ohLpRprwLdtULNZBMTH3TPavGFZF5oWHuJdJtGA
         0jsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJQanw1Sm8hwnATJTWZ5T87d463paNUhJgkC8Hl7E0E=;
        b=VXW1r9gaeUOJgfFWNL+U+IvIsKb0c0gWOG/N7W4DVvNWaAJ0rWKQ8s2hCGg3Sda3lv
         0OuBVYJeKuIjukcj3GMGUDS+95FwgV/a21nfvb7hC2LI7du6h3h4sgduSKnZamGMkUAB
         N+hRwoGnByCi5y6osJPQDGVY9+Chx0fHtflNXnlv4PPGVVjVc/KGmll65Khb5DNdFWOL
         d3Cd96vrLV10C08p5PZVlqfNT1hbvj4BWmPrtppmEolhJbfwBWdxqXQsT4T8RQjlQrSk
         9qlYW9W+dDkAJsSdHwDpEO9KhjJ0g2OL8PTd0xjrHGKudF+lPfG1qus01d1657e0OMIE
         EUFA==
X-Gm-Message-State: AOAM530WpKGpiNM81ceVyD8885jveFFL5n9JoA39vdnN9UF0uJr826Hu
        4t9oH8R5pBUoGjEjx0WrVA0/sTxs5ikSxWOk5JM=
X-Google-Smtp-Source: ABdhPJztE1lvvidDrRF+BYsAwOY6JCfitsgajU9q8lmvMEGLRnkLPEnVEVavm0YJ+M3o8uzfP8ksBjC/XrLPsnOAsqE=
X-Received: by 2002:a0c:f388:: with SMTP id i8mr8847755qvk.224.1593289913134;
 Sat, 27 Jun 2020 13:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200626175501.1459961-1-kafai@fb.com> <20200626175545.1462191-1-kafai@fb.com>
 <CAEf4BzZ3Jb296zJ7bfsntk7v5fkynrBcKncGQgrSHJ2zqifgsA@mail.gmail.com> <20200627002302.3tqklvjxxuetjoxr@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200627002302.3tqklvjxxuetjoxr@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jun 2020 13:31:42 -0700
Message-ID: <CAEf4BzZevDLp8Hzax3T8XzHLsMm85upCONULVVOEOyAxVGe4dA@mail.gmail.com>
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

On Fri, Jun 26, 2020 at 5:23 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Fri, Jun 26, 2020 at 03:45:04PM -0700, Andrii Nakryiko wrote:
> > On Fri, Jun 26, 2020 at 10:56 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > It is common for networking tests creating its netns and making its own
> > > setting under this new netns (e.g. changing tcp sysctl).  If the test
> > > forgot to restore to the original netns, it would affect the
> > > result of other tests.
> > >
> > > This patch saves the original netns at the beginning and then restores it
> > > after every test.  Since the restore "setns()" is not expensive, it does it
> > > on all tests without tracking if a test has created a new netns or not.
> > >
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> > >  tools/testing/selftests/bpf/test_progs.c | 21 +++++++++++++++++++++
> > >  tools/testing/selftests/bpf/test_progs.h |  2 ++
> > >  2 files changed, 23 insertions(+)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> > > index 54fa5fa688ce..b521ce366381 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.c
> > > +++ b/tools/testing/selftests/bpf/test_progs.c
> > > @@ -121,6 +121,24 @@ static void reset_affinity() {
> > >         }
> > >  }
> > >
> > > +static void save_netns(void)
> > > +{
> > > +       env.saved_netns_fd = open("/proc/self/ns/net", O_RDONLY);
> > > +       if (env.saved_netns_fd == -1) {
> > > +               perror("open(/proc/self/ns/net)");
> > > +               exit(-1);
> > > +       }
> > > +}
> > > +
> > > +static void restore_netns(void)
> > > +{
> > > +       if (setns(env.saved_netns_fd, CLONE_NEWNET) == -1) {
> > > +               stdio_restore();
> > > +               perror("setns(CLONE_NEWNS)");
> > > +               exit(-1);
> > > +       }
> > > +}
> > > +
> > >  void test__end_subtest()
> > >  {
> > >         struct prog_test_def *test = env.test;
> > > @@ -643,6 +661,7 @@ int main(int argc, char **argv)
> > >                 return -1;
> > >         }
> > >
> > > +       save_netns();
> >
> > you should probably do this also after each sub-test in test__end_subtest()?
> You mean restore_netns()?

oops, yeah :)

>
> It is a tough call.
> Some tests may only want to create a netns at the beginning for all the subtests
> to use (e.g. sk_assign.c).  restore_netns() after each subtest may catch
> tester in surprise that the netns is not in its full control while its
> own test is running.

Wouldn't it be better to update such self-tests to setns on each
sub-test properly? It should be a simple code re-use exercise, unless
I'm missing some other implications of having to do it before each
sub-test?

The idea behind sub-test is (at least it was so far) that it's
independent from other sub-tests and tests, and it's only co-located
with other sub-tests for the purpose of code reuse and logical
grouping. Which is why we reset CPU affinity, for instance.

>
> I think an individual test should have managed the netns properly within its
> subtests already if it wants a correct test result.  It can unshare at the
> beginning of each subtest to get a clean state (e.g. in patch 8).
> test_progs.c only ensures a config made by an earlier test does
> not affect the following tests.

It's true that it gives more flexibility for test setup, but if we go
that way, we should do it consistently for CPU affinity resetting and
whatever else we do per-subtest. I wonder what your answers would be
for the above questions. We can go either way, just let's be
consistent.
