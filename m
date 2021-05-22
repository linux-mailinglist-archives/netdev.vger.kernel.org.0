Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09B338D246
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 02:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhEVAOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 20:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhEVAOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 20:14:10 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70557C061574;
        Fri, 21 May 2021 17:12:45 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id d14so21801112ybe.3;
        Fri, 21 May 2021 17:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zLMN3Cn6IYFVhlk/rLtM6Nox4oiAMYhwPBk5npBEcsM=;
        b=N0pyoJ08+FzpQ5m2dFXE0InH1OclzuFxYwyGCGLCDj+pj9hVzs0XurNlDFzELsva+1
         elF5aq9zIbWxm9KH3AjMOpuwk88vFK6rc1QOCxnNyE1aDY518B0gzUgEabcSl3U6e15U
         /mxkvLWv3ktiNw43GXPYhlMEWNb1yCy217cv4tHXXE7JH/+1FLDORM1vnE92BXyJ4tIX
         Ar6sHfpBYbRbjaGmL5jCVTgAnA6wJ7ljI2KCYiZlN5kJjNPBy8M7z+p1Q+hvmuLox8z5
         S4aT+/Bci3XvI9F+GroXisx3GOJOPKwDmdgnNGVO+90ZT7fxBe+dVGe8Y7tTWrVaSTNq
         rAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zLMN3Cn6IYFVhlk/rLtM6Nox4oiAMYhwPBk5npBEcsM=;
        b=b2AYfJthsMzkgkhCtiyl9ed3xOjJK8nD2vO9216UHJewtQjz6fBGlD0TdjMRycKsS3
         qkX/TgDAHKie8CgxUYcR04iOEhV3wKJHYaZHH+hh0G62/gf2yqVPmhZMZfJgDp9SDVlg
         qQ+lu9dsXgqQO7rBFDNSr23eiDqv606qVSljsjr9kCaw+NczI28ju8tqyQieY3fO8S4g
         tuqJ+FnxUknbMwrzGiRazEIyyOm9TsJMb/TfZuxT5k6XJ9hcO2Fw8no9IyhPLqP0Jyn6
         5F82nmBFihws38JoanrrrZka5E8FH5xSE4mTGilqd5Z4uNzo9pT30RFBEz2QEPC+78Dj
         rksA==
X-Gm-Message-State: AOAM533QhCQ6gVTSkO1GcsAlxDt7iYaaK5YyyMC0qyDSYf+pR1ACwn6q
        7FmpMgc3DYdr1NlCLA2VssKjYbYDwKA6oJocxM1E2Uy3
X-Google-Smtp-Source: ABdhPJzRlYVgjL5eJRvOYCRT1U+OWh6PUJQgem+4zqiqbwVQkqghJf42gIDU1J3GHnguxsrjk13Ty4QpA80IJuEoizM=
X-Received: by 2002:a5b:f05:: with SMTP id x5mr18186252ybr.425.1621642364642;
 Fri, 21 May 2021 17:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch> <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
 <60a6a0c61358a_4ea08208c4@john-XPS-13-9370.notmuch> <CAM_iQpWLsfKv-bXowR2tvF4R3FcT-A2rQV+mXuqBK9D0=DXtcA@mail.gmail.com>
In-Reply-To: <CAM_iQpWLsfKv-bXowR2tvF4R3FcT-A2rQV+mXuqBK9D0=DXtcA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 May 2021 17:12:33 -0700
Message-ID: <CAEf4BzY1v=0fri=5jpk4yXLTbNhmAMxCpL+5EH9PKKBRtM0YTg@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 12:31 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, May 20, 2021 at 10:47 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Wed, May 19, 2021 at 2:56 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > > >
> > > > Cong Wang wrote:
> > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > >
> > > > > We use non-blocking sockets for testing sockmap redirections,
> > > > > and got some random EAGAIN errors from UDP tests.
> > > > >
> > > > > There is no guarantee the packet would be immediately available
> > > > > to receive as soon as it is sent out, even on the local host.
> > > > > For UDP, this is especially true because it does not lock the
> > > > > sock during BH (unlike the TCP path). This is probably why we
> > > > > only saw this error in UDP cases.
> > > > >
> > > > > No matter how hard we try to make the queue empty check accurate,
> > > > > it is always possible for recvmsg() to beat ->sk_data_ready().
> > > > > Therefore, we should just retry in case of EAGAIN.
> > > > >
> > > > > Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
> > > > > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
> > > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > > > index 648d9ae898d2..b1ed182c4720 100644
> > > > > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > > > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > > > @@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
> > > > >       if (pass != 1)
> > > > >               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> > > > >
> > > > > +again:
> > > > >       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> > > > > -     if (n < 0)
> > > > > +     if (n < 0) {
> > > > > +             if (errno == EAGAIN)
> > > > > +                     goto again;
> > > > >               FAIL_ERRNO("%s: read", log_prefix);
> > > >
> > > > Needs a counter and abort logic we don't want to loop forever in the
> > > > case the packet is lost.
> > >
> > > It should not be lost because selftests must be self-contained,
> > > if the selftests could not even predict whether its own packet is
> > > lost or not, we would have a much bigger trouble than just this
> > > infinite loop.
> > >
> > > Thanks.
> >
> > Add the retry counter its maybe 4 lines of code. When I run this in a container
>
> Sure, then the next question is how many times are you going to retry?
> Let's say, 10. Then the next question would be is 10 sufficient? Clearly
> not, because if the packet can be dropped (let's say by firewall), it can
> be delayed too (let's say by netem).

10 is fine. If something unexpected happens (whatever hostility of the
environment), getting stuck is much-much worse than erroring out. So
please add the counter and be done with it.

>
> Really, are we going to handle all of such cases? Or if we simply
> assume the environment is self-contained and not hostile, none of
> the above would happen hence nothing needs to be checked.

We have many different environments in which selftests are running. We
shouldn't have an infinite loop in any of them, even if some selftests
can't succeed in some of them. Not in all environments it is possible
to do Ctrl-C (e.g., CIs).

>
> > and my memcg kicks in for some unknown reason I don't want it to loop
> > forever I want it to fail gracefully. Plus it just looks bad to encode
> > a non-terminating loop, in my opinion, so I want the counter.
>
> There could be hundreds of reasons to drop a packet, or delay a
> packet. How many of them do you want to consider and how many
> of them do you not consider? Please draw a boundary.
>
> The boundary I drew is very clear: we just assume the selftests

See above, the minimum bar is that selftest shouldn't get stuck, no matter what.

> environment is not hostile. In fact, I believe selftests should setup
> such an environment before running any test, for example, by creating
> a container. And I believe this would make everyone happy.
>
> Thanks.
