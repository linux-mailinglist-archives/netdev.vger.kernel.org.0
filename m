Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605E538B7F8
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbhETUCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhETUCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:02:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77678C061761;
        Thu, 20 May 2021 13:00:46 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t11so9740153pjm.0;
        Thu, 20 May 2021 13:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e0Z60NQDc3GPWD5eylV5/m0CicByXVXeNrPxPEhDQ5A=;
        b=P+nF8AH4cRidhPm4cmPZ6jEKNzRzBevs0ywwz0F8l6Ju0dRVozAjHu55X4wZLCMSu/
         KrGizfKlb9bz8Myk2xYvMrmDbu3oOnq6unl0etF7rAYC31jWSrXMBgZdFXwHKHqd+ICW
         VHiPpFOAnqzK7fbMkFxaMr1oShmnC8Z/KAFs0iTIaosZlZs79H0tcslZ9sQiqW8bc9Le
         CBFUPGH7HNZnV09qlsELqAPxwzwZDT+KPMO3JR8yXJa9nOB/ipWPhDGBcJNgr/dUXdTe
         rtrk94j3Vj2Uez/Pj8yeWZO0fQj6r6CC7yFZJwPdkGJbdaNpuYBZZc/9l7Zel1zd1kf/
         i20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e0Z60NQDc3GPWD5eylV5/m0CicByXVXeNrPxPEhDQ5A=;
        b=PdzsZCJDwStP7Gtz/gD4xYa9fEuwUNqqZIJQEnYP4bIe6c4uYB+t72FDyE1TaeVDCy
         Z1+HH5YeySQ+uJWExB+nit1sZbYNgLFy+raerKmsd6sq/3xrjNgq40NHJ9A7VXRR9zqr
         E4EEYnX7iHN/xBiG+d1zuQVBvAxRa16vhGrsxHFiZ/KzTQb8wmicDS4vpo2lGd1nhhGh
         GuxsyU6D1zr661ih3yP/hq9Unu11mQM40Q9a6+QKynPA6fwS8MwQZzXfb+uNdHfzTFh+
         4qeDdfWjR45L5BPQdbn4zLUY1jb+2HMM4oF/lAhyNDVIVLmrNndruYm0gSYFNoXiwiP5
         TqEQ==
X-Gm-Message-State: AOAM530HRMhMsJZYVI12hVGWGA6PyvNu03g9z/lGidOCavOoQFO593s3
        AxzPIubuUEYcwcGcaWjpaUUCoyv1a1zo1HcRQqk=
X-Google-Smtp-Source: ABdhPJy8s404D/luypmknqHD0IInb86TwSio9TlhUz9NCaNSmwnOKgGmfKU5Mcp+kgca5XyWx/SbAMg1JmY+uQLuFxk=
X-Received: by 2002:a17:902:c784:b029:ef:b14e:2b0b with SMTP id
 w4-20020a170902c784b02900efb14e2b0bmr7969566pla.64.1621540845844; Thu, 20 May
 2021 13:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch> <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
 <60a6a0c61358a_4ea08208c4@john-XPS-13-9370.notmuch>
In-Reply-To: <60a6a0c61358a_4ea08208c4@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 20 May 2021 13:00:34 -0700
Message-ID: <CAM_iQpWLsfKv-bXowR2tvF4R3FcT-A2rQV+mXuqBK9D0=DXtcA@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:47 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Wed, May 19, 2021 at 2:56 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > >
> > > > We use non-blocking sockets for testing sockmap redirections,
> > > > and got some random EAGAIN errors from UDP tests.
> > > >
> > > > There is no guarantee the packet would be immediately available
> > > > to receive as soon as it is sent out, even on the local host.
> > > > For UDP, this is especially true because it does not lock the
> > > > sock during BH (unlike the TCP path). This is probably why we
> > > > only saw this error in UDP cases.
> > > >
> > > > No matter how hard we try to make the queue empty check accurate,
> > > > it is always possible for recvmsg() to beat ->sk_data_ready().
> > > > Therefore, we should just retry in case of EAGAIN.
> > > >
> > > > Fixes: d6378af615275 ("selftests/bpf: Add a test case for udp sockmap")
> > > > Reported-by: Jiang Wang <jiang.wang@bytedance.com>
> > > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > ---
> > > >  tools/testing/selftests/bpf/prog_tests/sockmap_listen.c | 6 +++++-
> > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > > index 648d9ae898d2..b1ed182c4720 100644
> > > > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> > > > @@ -1686,9 +1686,13 @@ static void udp_redir_to_connected(int family, int sotype, int sock_mapfd,
> > > >       if (pass != 1)
> > > >               FAIL("%s: want pass count 1, have %d", log_prefix, pass);
> > > >
> > > > +again:
> > > >       n = read(mode == REDIR_INGRESS ? p0 : c0, &b, 1);
> > > > -     if (n < 0)
> > > > +     if (n < 0) {
> > > > +             if (errno == EAGAIN)
> > > > +                     goto again;
> > > >               FAIL_ERRNO("%s: read", log_prefix);
> > >
> > > Needs a counter and abort logic we don't want to loop forever in the
> > > case the packet is lost.
> >
> > It should not be lost because selftests must be self-contained,
> > if the selftests could not even predict whether its own packet is
> > lost or not, we would have a much bigger trouble than just this
> > infinite loop.
> >
> > Thanks.
>
> Add the retry counter its maybe 4 lines of code. When I run this in a container

Sure, then the next question is how many times are you going to retry?
Let's say, 10. Then the next question would be is 10 sufficient? Clearly
not, because if the packet can be dropped (let's say by firewall), it can
be delayed too (let's say by netem).

Really, are we going to handle all of such cases? Or if we simply
assume the environment is self-contained and not hostile, none of
the above would happen hence nothing needs to be checked.

> and my memcg kicks in for some unknown reason I don't want it to loop
> forever I want it to fail gracefully. Plus it just looks bad to encode
> a non-terminating loop, in my opinion, so I want the counter.

There could be hundreds of reasons to drop a packet, or delay a
packet. How many of them do you want to consider and how many
of them do you not consider? Please draw a boundary.

The boundary I drew is very clear: we just assume the selftests
environment is not hostile. In fact, I believe selftests should setup
such an environment before running any test, for example, by creating
a container. And I believe this would make everyone happy.

Thanks.
