Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF4A1D3FC6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbgENVNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727827AbgENVNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 17:13:13 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0598BC061A0C;
        Thu, 14 May 2020 14:13:13 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s1so379899qkf.9;
        Thu, 14 May 2020 14:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0093alRvyC8yZFWYKJHaSSNn+cVonBhIWEwGwLPUces=;
        b=XEhe6gsHQXCQc7jBN++QtHGV8UKGBSW11Vrl+OvypWnRbZitQ1ibof7SFP269Capgs
         HCU7mE3Z7TKU/4J8gvovzhN0No+Hsx6s/49/Qg9+aS3951ksJQxAdjGzys9yjpUX1459
         CXG1Xyarkoqs/+iy4duamwb7TYU4SnpkWVlHOXqNUcYUrUneLYAzxjUR1qB/Zkq22hsN
         z25LpCgp9CVeD1nQXq2lwUNspfVm8Me4XVQsNH+6WcfRVYU1z0+GiY6FlX7QScD5z5Z2
         v+5EPBc01BxAeQuDVR2qQMw54M7vRLkOnJvnj/xo7W79gpTYgwacfAoypkw9rXeo7L07
         E56Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0093alRvyC8yZFWYKJHaSSNn+cVonBhIWEwGwLPUces=;
        b=hHDCmfmrM7eUwMDOWbtQa2k5WbvaV3MlkMDKTit7DE4KCRdf7D6vXXbe+BbpkFsfYy
         gbswd5PR/HkSTLDfv3wYYzy8ov1mPoM3EgX76DOb8QXOXK9WdGqFVp+YyUrFTD9Vvi6v
         OB3X3HLo5WBcWGLAXyYq1RzwsHFhx4EJxhNXPjl8gDFEo6PbNRW/F3jOEGgYi75mR9+N
         4IfEcG+qB8J2ndyDLO767WPzRKkQIJz3EN75Deb+lc/WzEVUIKqRgvD1lA4Rjvj9hVRP
         Y/m7xkCuxFgog8CQxNB7HvBQM1BfoaWulXxHf2blyjawx3UKcQ4kRh1LKYFsF0GDvZ2U
         xCNQ==
X-Gm-Message-State: AOAM530kLrK2lZ1XG36ztAYDpL5gtUK80jbQhBhbw1y0dqfZEARIu0iS
        by393x9vZHdmX7ybs+yHDw0E9QzXVsgMA/zKkDE=
X-Google-Smtp-Source: ABdhPJwooosMYjRa13Qqd8sAjpZhpw8pUzQ0b7LrWOXfpqisif7bT8BSICMlLga6A2kzCzq1tLeBntTzGQEX14FN3Bo=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr311635qka.449.1589490791537;
 Thu, 14 May 2020 14:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513192532.4058934-2-andriin@fb.com>
 <20200514173338.GA161830@google.com> <CAEf4BzbhqQB61JTmmp5999bbEFeHEMdvnE9vpV3tHCHm12cf-Q@mail.gmail.com>
 <20200514205348.GB161830@google.com>
In-Reply-To: <20200514205348.GB161830@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 14:13:00 -0700
Message-ID: <CAEf4BzbvjQy+8T43e91OXDaLgWsy5_1RSr278=uAVUGOT0LgZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: implement BPF ring buffer and verifier
 support for it
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 1:53 PM <sdf@google.com> wrote:
>
> On 05/14, Andrii Nakryiko wrote:
> > On Thu, May 14, 2020 at 10:33 AM <sdf@google.com> wrote:
> > >
> > > On 05/13, Andrii Nakryiko wrote:
>
> [...]
>
> > > > + * void bpf_ringbuf_submit(void *data)
> > > > + *   Description
> > > > + *           Submit reserved ring buffer sample, pointed to by
> > *data*.
> > > > + *   Return
> > > > + *           Nothing.
> > > Even though you mention self-pacing properties, would it still
> > > make sense to add some argument to bpf_ringbuf_submit/bpf_ringbuf_output
> > > to indicate whether to wake up userspace or not? Maybe something like
> > > a threshold of number of outstanding events in the ringbuf after which
> > > we do the wakeup? The default 0/1 preserve the existing behavior.
> > >
> > > The example I can give is a control plane userspace thread that
> > > once a second aggregates the events, it doesn't care about millisecond
> > > resolution. With the current scheme, I suppose, if BPF generates events
> > > every 1ms, the userspace will be woken up 1000 times (if it can keep
> > > up). Most of the time, we don't really care and some buffering
> > > properties are desired.
>
> > perf buffer has setting like this, and believe me, it's so confusing
> > and dangerous, that I wouldn't want this to be exposed. Even though I
> > was aware of this behavior, I still had to debug and work-around this
> > lack on wakeup few times, it's really-really confusing feature.
>
> > In your case, though, why wouldn't user-space poll data just once a
> > second, if it's not interested in getting data as fast as possible?
> If I poll once per second I might lose the events if, for some reason,
> there is a spike. I really want to have something like: "wakeup
> userspace if the ringbuffer fill is over some threshold or
> the last wakeup was too long ago". We currently do this via a percpu
> cache map. IIRC, you've shared on lsfmmbpf that you do something like
> that as well.

Hm... don't remember such use case on our side. All applications I
know of use default perf_buffer settings with no sampling.

>
> So I was thinking how I can use new ringbuff to remove the unneeded
> copies and help with the reordering, but I'm a bit concerned about
> regressing on the number of wakeups.
>
> Maybe having a flag like RINGBUF_NO_WAKEUP in bpf_ringbuf_submit()
> will suffice? And if there is a helper or some way to obtain a
> number of unconsumed items, I can implement my own flushing policy.

Ok, I guess giving application control at each discard/commit makes
for ultimate flexibility. Let me add flags argument to commit/discard
and allow to specify NO_WAKEUP flag. As for count of unconsumed events
-- that would be a bit expensive to maintain. How about amount of data
that's not consumed? It's obviously going to be racy, but returning
(producer_pos - consumer_pos) should be sufficient enough for such
smart and best-effort heuristics? WDYT?
