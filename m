Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E05C22B267
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgGWPWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgGWPWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:22:33 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B82C0619DC;
        Thu, 23 Jul 2020 08:22:33 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k17so3482958lfg.3;
        Thu, 23 Jul 2020 08:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L81wTFA53gfp7hYtms3C94J0jBeZGUSiKMHUeZoLf74=;
        b=EJ/MMS9NJ0fa7vp2B2cpL8GsEZFuIK04OhTRyhJVsY5qLLm+Jldv7Rx2TXbULPN2Cs
         62Ct2jJU+poxwYVG1TUtpgXqlGVsODkX4GlAkQPnxR7RPRPGgZN5xnIQLvA7DD8fCA1E
         ETgwAwT/t1vrZwjgmkv2WzX0igbmKVqkS8OBnvMiQ9ix8UkR1sq93/djIqJTg0iwAIK2
         vZZ5z1yBdGJoJxcL+fwkFmoTESEbAg5oOahR3NrMqCyTYphW2oUjaENHITHjuGcecNIj
         cFOMDsr/5kXwCuiY71153T9y2zbuN4IGZIwlFnBbGWf3K1f3vSJgg8UVtgMa2bwOXjb+
         +tFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L81wTFA53gfp7hYtms3C94J0jBeZGUSiKMHUeZoLf74=;
        b=hEiR1RdSL8uKi1wQSMKIHlHacnaerOvU8wOQqyWWf7GBNZLIsFf9MOieoeOCy2vWpv
         iGVqjqgPF/P9V3A//lAuTTXQ7UBOTKJ93Pk1CifIh8p37CLQyC9oimS/4kN7NfztO5QB
         zpOUlH8Ht4KSLcfbpURFbxdYoN30rp/xT/zbYmoWZPCbI+us8B5s2YyScZjtmz0cCNQg
         RFTcCLGuzUD1mZ5OaFN4n7Dh5iYZ088do7rlz5TQ5d2XI2HOnbsSGSiS/qpwB9PLIUAG
         b6MhDvhMh3K96Rp6sz4etzCXeHf7Qnd4XuE4sUt343kLePn9PhQn8yXXLsA3sbl3WsEz
         V+zQ==
X-Gm-Message-State: AOAM530MMzvZ9oCwPT8KstW1e7Re0+pgVxkadu3SBUaSf5ZkFAMHjiY/
        LRbs/5QsYRflAJ/XbV1OIfc7y9oY1XD9aEjJMeE=
X-Google-Smtp-Source: ABdhPJxuvwgfuAanQGNYX7PvikPhn/NQCxwDohI9W4Y893EwG29iNI4LFtdnK9U3931oOB6GvwOtBKz8kki1RW+GZso=
X-Received: by 2002:ac2:5f48:: with SMTP id 8mr2469875lfz.157.1595517751613;
 Thu, 23 Jul 2020 08:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200722184210.4078256-1-songliubraving@fb.com>
 <20200722184210.4078256-3-songliubraving@fb.com> <20200723055518.onydx7uhmzomt7ud@ast-mbp.dhcp.thefacebook.com>
 <684DA506-6780-4CB5-B99C-24D939CDE6DF@fb.com>
In-Reply-To: <684DA506-6780-4CB5-B99C-24D939CDE6DF@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Jul 2020 08:22:19 -0700
Message-ID: <CAADnVQK+xX8oKF5f=FzmE+xxbSovJ+rbZD6TRxTAtdH+-ockEw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: fail PERF_EVENT_IOC_SET_BPF when
 bpf_get_[stack|stackid] cannot work
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:20 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 22, 2020, at 10:55 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Jul 22, 2020 at 11:42:08AM -0700, Song Liu wrote:
> >> diff --git a/kernel/events/core.c b/kernel/events/core.c
> >> index 856d98c36f562..f77d009fcce95 100644
> >> --- a/kernel/events/core.c
> >> +++ b/kernel/events/core.c
> >> @@ -9544,6 +9544,24 @@ static int perf_event_set_bpf_handler(struct perf_event *event, u32 prog_fd)
> >>      if (IS_ERR(prog))
> >>              return PTR_ERR(prog);
> >>
> >> +    if (event->attr.precise_ip &&
> >> +        prog->call_get_stack &&
> >> +        (!(event->attr.sample_type & __PERF_SAMPLE_CALLCHAIN_EARLY) ||
> >> +         event->attr.exclude_callchain_kernel ||
> >> +         event->attr.exclude_callchain_user)) {
> >> +            /*
> >> +             * On perf_event with precise_ip, calling bpf_get_stack()
> >> +             * may trigger unwinder warnings and occasional crashes.
> >> +             * bpf_get_[stack|stackid] works around this issue by using
> >> +             * callchain attached to perf_sample_data. If the
> >> +             * perf_event does not full (kernel and user) callchain
> >> +             * attached to perf_sample_data, do not allow attaching BPF
> >> +             * program that calls bpf_get_[stack|stackid].
> >> +             */
> >> +            bpf_prog_put(prog);
> >> +            return -EINVAL;
> >
> > I suspect this will be a common error. bpftrace and others will be hitting
> > this issue and would need to fix how they do perf_event_open.
> > But EINVAL is too ambiguous and sys_perf_event_open has no ability to
> > return a string.
> > So how about we pick some different errno here to make future debugging
> > a bit less painful?
> > May be EBADFD or EPROTO or EPROTOTYPE ?
> > I think anything would be better than EINVAL.
>
> I like EPROTO most. I will change it to EPROTO if we don't have better ideas.
>
> Btw, this is not the error code on sys_perf_event_open(). It is the ioctl()
> on the perf_event fd. So debugging this error will be less painful than
> debugging sys_perf_event_open() errors.

ahh. right. Could you also add a string hint to libbpf when it sees this errno?
