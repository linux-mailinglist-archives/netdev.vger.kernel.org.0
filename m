Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407F61E1843
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgEYXd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgEYXd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:33:27 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDECC061A0E;
        Mon, 25 May 2020 16:33:27 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q8so2417372qkm.12;
        Mon, 25 May 2020 16:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGAlG5olRmFuMRb2dfcIhmtPFQGLh4l8c9TcPg47YH8=;
        b=f6ArtC8fTuZ7i0MxeWQdo9EXk2iJL1KvUaSsECfpi7IXMrCdLGA/xVkJRw8BOlWF/6
         gyF0tn2SW66TsWx7LQ/dk0MlYUsfkPFe/x7NZCnSEqxtIyVhv4wUXFJAq87XawnzJKXD
         4eDxDrmyFgV/C0Gn3FGyysI7oz42PNVNu8zg7SJtFJOvbpnztdHQERe9mWLfXj8iyJv6
         CSwhUBvtxaxH9O/u+lq3JzH3ws6HLagAIaDdEza/LdxQpsbDtnV6Q78CJrrhI5cFcFyL
         dr6R/ynDforF+eCsy14M9vU+G814mU31ifaz2tTfqJYNPuOkfM97UoohZeF8qF7MVyDw
         i+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGAlG5olRmFuMRb2dfcIhmtPFQGLh4l8c9TcPg47YH8=;
        b=Hn4Wf9eTjmktm5isK/lqf9NQvRjRlFujimWww01yLsv7u5INyIVwgjiV7JZmqegZKY
         HxL+QaUk/xkt2PPvuDFy/kFjP+CMibN2kUrdn0k350+yBt/te6TT/6/vDw6zit8OxNbR
         BIYlefphQ+/nvmIMgo5zAwT6Xn6Qxj8A7G0ErxyjBp3bOp5LIApSD9Rz/L7iwZYoPFSv
         pYMV8FjxaX7LFe0FmuaCEdhoiw0TtbbYg6z/vH9jeTl/+0PXgQrJspZCU4D+CJzO9Z6z
         jf1KGZhrYY2SOsPtugo0pkL3A+PlQ+kTyO6w4Yvr2MmBXMsYcwWTGoeuBqz8c05ARUKa
         /6EA==
X-Gm-Message-State: AOAM530Oxgm2LE7eFucxzhb8cqW+3+gTjkCLp10W4jZCADRXsn1+6wB1
        xlTDwMd2Py9iNKhlJ3HBJNRPta9fXtkZVdgyFtU=
X-Google-Smtp-Source: ABdhPJxtVXxtnQhgrfWf3YU5FHvH2RIivq1f7vTuqkAH8K4RNq1/bCqv/go/GZxs7X/+sMu+GOiHPOE15D14eHy7NXM=
X-Received: by 2002:a37:6508:: with SMTP id z8mr16863069qkb.39.1590449606535;
 Mon, 25 May 2020 16:33:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-3-andriin@fb.com>
 <20200522003433.GG2869@paulmck-ThinkPad-P72> <CAEf4BzaVeFfa2=-M4FCgH5HX17TSkcGsBTDZcjrZxo=He2QESg@mail.gmail.com>
In-Reply-To: <CAEf4BzaVeFfa2=-M4FCgH5HX17TSkcGsBTDZcjrZxo=He2QESg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 May 2020 16:33:15 -0700
Message-ID: <CAEf4Bza9aRM+6EfXaokV8xfEj_hRoKhNd5vYKtpc61XFAiewsA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/7] tools/memory-model: add BPF ringbuf MPSC
 litmus tests
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 11:51 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, May 21, 2020 at 5:34 PM Paul E. McKenney <paulmck@kernel.org> wrote:
> >
> > On Sun, May 17, 2020 at 12:57:22PM -0700, Andrii Nakryiko wrote:
> > > Add 4 litmus tests for BPF ringbuf implementation, divided into two different
> > > use cases.
> > >
> > > First, two unbounded case, one with 1 producer and another with
> > > 2 producers, single consumer. All reservations are supposed to succeed.
> > >
> > > Second, bounded case with only 1 record allowed in ring buffer at any given
> > > time. Here failures to reserve space are expected. Again, 1- and 2- producer
> > > cases, single consumer, are validated.
> > >
> > > Just for the fun of it, I also wrote a 3-producer cases, it took *16 hours* to
> > > validate, but came back successful as well. I'm not including it in this
> > > patch, because it's not practical to run it. See output for all included
> > > 4 cases and one 3-producer one with bounded use case.
> > >
> > > Each litmust test implements producer/consumer protocol for BPF ring buffer
> > > implementation found in kernel/bpf/ringbuf.c. Due to limitations, all records
> > > are assumed equal-sized and producer/consumer counters are incremented by 1.
> > > This doesn't change the correctness of the algorithm, though.
> >
> > Very cool!!!
> >
> > However, these should go into Documentation/litmus-tests/bpf-rb or similar.
> > Please take a look at Documentation/litmus-tests/ in -rcu, -tip, and
> > -next, including the README file.
> >
> > The tools/memory-model/litmus-tests directory is for basic examples,
> > not for the more complex real-world ones like these guys.  ;-)
>
> Oh, ok, I didn't realize there are more litmus tests under
> Documentation/litmus-tests... Might have saved me some time (more
> examples to learn from!) when I was writing mine :) Will check those
> and move everything.
>

Ok, so Documentation/litmus-tests is not present in bpf-next, so I
guess I'll have to split this patch out and post it separately. BTW,
it's not in -rcu tree either, should I post this against linux-next
tree directly?


> >
> >                                                                 Thanx, Paul
> >
>
> [...]
