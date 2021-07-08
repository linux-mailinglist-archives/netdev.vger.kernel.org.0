Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33D23BF2D4
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 02:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhGHA0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 20:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhGHA0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 20:26:47 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB2DC061574;
        Wed,  7 Jul 2021 17:24:05 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id g19so6060227ybe.11;
        Wed, 07 Jul 2021 17:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4JA4gyENDgRM8u2jdOpOeLqy9c08YUXj4WglLNdN3zc=;
        b=Mj4U+ieNFWhyGEXQnyXtVTDg2lCJESVN10I26YFkCJWgQHd+PEwjQ9mIDWIdOvvavI
         krhPvXoVIbGs1EMBQcQzD5j3jgt70enRhSyimELNjzCLE+ZXHVVeCjwTu9DDezfUOfEd
         NwXeyR3GpIbio5pnWuAaXN3gC/O2NaKjEa+3X91Rxd+S1cJDrAjaSEpi0nzW3OO91hCC
         Nw8lO358HU31eQBp3v2qgza9yOC7vldKWP7ixPpfGg8IB6B556bwDpth1Kj3SYGmm5oq
         k6L9lBPzD3smbdj+K+vNmIMcpbHKFMGfL/YcOVtjf/JMjVPvOSBsAJ8QCCxvUHJk5EPJ
         yFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4JA4gyENDgRM8u2jdOpOeLqy9c08YUXj4WglLNdN3zc=;
        b=F8KX0rCxHND7j+248k2hB0hJXs7rXh6yd6cljhHJ9ts+JnByWjawzsOhEXHEVY4qXe
         TIFFoFFgCacDiD5pERamfQ6hRwijMpR5hiZzWurJR2A05BRDBvaWDuUavXvrZLXlLSN2
         YIvqG59OjrJJzMKppmsqngQmP6YZvxFAegF8+y3E0HbMW1PP4etBOqduCFlZM92PoZ9M
         Jq6YZ+bqH+5JKitw0ucOA59O1F0tS5Pw1pW85V5zBtfwxQp1OzHpogzhOhjQf8COShki
         oNIaVzA7SrBWlTGuMtgCPksYFUxkr0eFFomR0VkxxGW6nU+lR7g3cdeNcN23TPOPlPrK
         YPoQ==
X-Gm-Message-State: AOAM532QjGyTwR1CnleuKmHltqt41VZDqoR/KRGNPRMJlLnLCzJf/Sbj
        TwclIjXfKSELZkoRZAbHm8HAlIPCOptIzsSV0W8=
X-Google-Smtp-Source: ABdhPJzwzviM9JBKxjLOHjyexk6HOmHhFfeAWkDJufGTDd4thrHStPRdZOOfUcvn2CFSfqyk7leAUwGrU/z1X+qk68Q=
X-Received: by 2002:a25:b741:: with SMTP id e1mr36829504ybm.347.1625703845244;
 Wed, 07 Jul 2021 17:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210629095543.391ac606@oasis.local.home> <CAEf4BzZPb=cPf9V1Bz+USiq+b5opUTNkj4+CRjXdHcmExW3jVg@mail.gmail.com>
 <20210707184518.618ae497@rorschach.local.home> <CAEf4BzZ=hFZw1RNx0Pw=kMNq2xRrqHYCQQ_TY_pt86Zg9HFJfA@mail.gmail.com>
 <20210707200544.1fbfd42b@rorschach.local.home>
In-Reply-To: <20210707200544.1fbfd42b@rorschach.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Jul 2021 17:23:54 -0700
Message-ID: <CAEf4BzYRxRW8qR3oENuVEMBYtcvK0bUDEkoq+e4TRT5Hh0pV_Q@mail.gmail.com>
Subject: Re: [PATCH] tracepoint: Add tracepoint_probe_register_may_exist() for
 BPF tracing
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        syzbot+721aa903751db87aa244@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 7, 2021 at 5:05 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 7 Jul 2021 16:49:26 -0700
> Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > As for why the user might need that, it's up to the user and I don't
> > want to speculate because it will always sound contrived without a
> > specific production use case. But people are very creative and we try
> > not to dictate how and what can be done if it doesn't break any
> > fundamental assumption and safety.
>
> I guess it doesn't matter, because if they try to do it, the second
> attachment will simply fail to attach.
>

But not for the kprobe case.

And it might not always be possible to know that the same BPF program
is being attached. It could be attached by different processes that
re-use pinned program (without being aware of each other). Or it could
be done from some generic library that just accepts prog_fd and
doesn't really know the exact BPF program and whether it was already
attached.

Not sure why it doesn't matter that attachment will fail where it is
expected to succeed. The question is rather why such restriction?

> -- Steve
