Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C031A6CE5
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbgDMUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388135AbgDMUAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:00:06 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F09EC0A3BDC;
        Mon, 13 Apr 2020 13:00:06 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b10so8188174qtt.9;
        Mon, 13 Apr 2020 13:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W3a8iTpmroxpZsTfoI/UNT2i6KRHATNcoYavmwnD5FE=;
        b=eyIAXPGRHmxECNcWmKMeD86SXvZowNYjd4we8xO/vZgtlGB5Eq016WWHZlViSuEcoA
         FmTpm3cEf5xoMSf5QFL2ox24ZPA0ToHHyUfC6ovMb00Q8OGWKNw4UJII5tAg10tPC8S+
         myGPedMfvTg47IHbFjs3KPOOG0pHRCgVA9IYnCxCEuqwg7KjHsgWWzHo3qS8yV0UFkA6
         ikRljFneNb8y3++ZR/SnbElDD2M0Sj7HHpV+948XmbbbRJeWxIAxVHcptT4poDVh6LGA
         q9S3tJidSTvCgb7XlCQA0q/1n7DVlgv2/kEmHOYLehwvLqtNVhg+H0E1M1E/xwYaZe3g
         dYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W3a8iTpmroxpZsTfoI/UNT2i6KRHATNcoYavmwnD5FE=;
        b=bFLytK8rPagVY/KgtqYzNa/NT7pkkNLR1BHdMQq47fPSQRmYA3MXAB+YgwBfFWv1l7
         Z1ghMGRC5muRjKEAYUFPR7L547U+dg9aj9RPz1KZAZ53SkNVUOZOaxkMNEq34PqQe2fP
         Oe31xvSmsEyEe/9ZXcmARn0eyiNR3wAsp5lEYVYOZk3HIa13FqnW/gVkqWpPtL9tItmq
         OkOFLzATGcgb637n30pc+4eOBxEjNSaC101O4QbMtpCQr/zNIZYbqUFooTfNb16Wz9SL
         /nj19fyTbflHOxZPSYowNgI6h3VqGXqDODSdfqB0nkjh2Srk06lYIC7TGV48D7RmFqPr
         aV6w==
X-Gm-Message-State: AGi0PuaYKolTuCLhdp5J3FRrn+y6YCwEecNzQJ4zfm4wsv/bVdtyOmwh
        +QCiEX3/GxXPMgCdmF9FZlvd/YMl3NBuDIBsfFK86B3+MLU=
X-Google-Smtp-Source: APiQypIThO/5CZxH059Udi+owaSa423TCMmqo2FObcQQSlYHHvpQstTGXfjyMdi0Nl3vTcTcrxxVIgSmp1boSXcCF38=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr12158019qtj.93.1586808005426;
 Mon, 13 Apr 2020 13:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bza8w9ypepeu6eoJkiXqKqEXtWAOONDpZ9LShivKUCOJbg@mail.gmail.com> <334a91d2-1567-bf3d-4ae6-305646738132@fb.com>
In-Reply-To: <334a91d2-1567-bf3d-4ae6-305646738132@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 12:59:54 -0700
Message-ID: <CAEf4BzaYYhK8PpO4Swcj0dqjYg+bn_3OkEnqjCXUgfkkHZgWMw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 5:23 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/10/20 4:25 PM, Andrii Nakryiko wrote:
> > On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Given a loaded dumper bpf program, which already
> >> knows which target it should bind to, there
> >> two ways to create a dumper:
> >>    - a file based dumper under hierarchy of
> >>      /sys/kernel/bpfdump/ which uses can
> >>      "cat" to print out the output.
> >>    - an anonymous dumper which user application
> >>      can "read" the dumping output.
> >>
> >> For file based dumper, BPF_OBJ_PIN syscall interface
> >> is used. For anonymous dumper, BPF_PROG_ATTACH
> >> syscall interface is used.
> >>
> >> To facilitate target seq_ops->show() to get the
> >> bpf program easily, dumper creation increased
> >> the target-provided seq_file private data size
> >> so bpf program pointer is also stored in seq_file
> >> private data.
> >>
> >> Further, a seq_num which represents how many
> >> bpf_dump_get_prog() has been called is also
> >> available to the target seq_ops->show().
> >> Such information can be used to e.g., print
> >> banner before printing out actual data.
> >
> > So I looked up seq_operations struct and did a very cursory read of
> > fs/seq_file.c and seq_file documentation, so I might be completely off
> > here.
> >
> > start() is called before iteration begins, stop() is called after
> > iteration ends. Would it be a bit better and user-friendly interface
> > to have to extra calls to BPF program, say with NULL input element,
> > but with extra enum/flag that specifies that this is a START or END of
> > iteration, in addition to seq_num?
>
> The current design always pass a valid object (task, file, netlink_sock,
> fib6_info). That is, access to fields to those data structure won't
> cause runtime exceptions.
>
> Therefore, with the existing seq_ops implementation for ipv6_route
> and netlink, etc, we don't have END information. We can get START
> information though.

Right, I understand this about current implementation, because it
calls BPF program from show. But I noticed also stop(), which

>
> >
> > Also, right now it's impossible to write stateful dumpers that do any
> > kind of stats calculation, because it's impossible to determine when
> > iteration restarted (it starts from the very beginning, not from the
> > last element). It's impossible to just rememebr last processed
> > seq_num, because BPF program might be called for a new "session" in
> > parallel with the old one.
>
> Theoretically, session end can be detected by checking the return
> value of last bpf_seq_printf() or bpf_seq_write(). If it indicates
> an overflow, that means session end.

That's not what I meant by session end. If there is an overflow, the
session is going to be restart from start (but it's still the same
session, we just got bigger output buffer).

>
> Or bpfdump infrastructure can help do this work to provide
> session id.

Well, come to think about it. seq_file pointer itself is unique per
session, so that one can be used as session id, is that right?

>
> >
> > So it seems like few things would be useful:
> >
> > 1. end flag for post-aggregation and/or footer printing (seq_num == 0
> > is providing similar means for start flag).
>
> the end flag is a problem. We could say hijack next or stop so we
> can detect the end, but passing a NULL pointer as the object
> to the bpf program may be problematic without verifier enforcement
> as it may cause a lot of exceptions... Although all these exception
> will be silenced by bpf infra, but still not sure whether this
> is acceptable or not.

Right, verifier will need to know that item can be valid pointer or
NULL. It's not perfect, but not too big of a deal for user to check
for NULL at the very beginning.

What I'm aiming for with this end flags is ability for BPF program to
collect data during show() calls, and then at the end get extra call
to give ability to post-aggregate this data and emit some sort of
summary into seq_file. Think about printing out summary stats across
all tasks (e.g., p50 of run queue latency, or something like that). In
that case, I need to iterate all tasks, I don't need to emit anything
for any individual tasks, but I need to produce an aggregation and
output after the last task was iterated. Right now it's impossible to
do, but seems like an extremely powerful and useful feature. drgn
could utilize this to speed up its scripts. There are plenty of tools
that would like to have a frequent but cheap view into internals of
the system, which current is implemented through netlink (taskstats)
or procfs, both quite expensive, if polled every second.

Anonymous bpfdump, though, is going to be much cheaper, because a lot
of aggregation can happen in the kernel and only minimal output at the
end will be read by user-space.

>
> > 2. Some sort of "session id", so that bpfdumper can maintain
> > per-session intermediate state. Plus with this it would be possible to
> > detect restarts (if there is some state for the same session and
> > seq_num == 0, this is restart).
>
> I guess we can do this.

See above, probably using seq_file pointer is good enough.

>
> >
> > It seems like it might be a bit more flexible to, instead of providing
> > seq_file * pointer directly, actually provide a bpfdumper_context
> > struct, which would have seq_file * as one of fields, other being
> > session_id and start/stop flags.
>
> As you mentioned, if we have more fields related to seq_file passing
> to bpf program, yes, grouping them into a structure makes sense.
>
> >
> > A bit unstructured thoughts, but what do you think?
> >
> >>
> >> Note the seq_num does not represent the num
> >> of unique kernel objects the bpf program has
> >> seen. But it should be a good approximate.
> >>
> >> A target feature BPF_DUMP_SEQ_NET_PRIVATE
> >> is implemented specifically useful for
> >> net based dumpers. It sets net namespace
> >> as the current process net namespace.
> >> This avoids changing existing net seq_ops
> >> in order to retrieve net namespace from
> >> the seq_file pointer.
> >>
> >> For open dumper files, anonymous or not, the
> >> fdinfo will show the target and prog_id associated
> >> with that file descriptor. For dumper file itself,
> >> a kernel interface will be provided to retrieve the
> >> prog_id in one of the later patches.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >>   include/linux/bpf.h            |   5 +
> >>   include/uapi/linux/bpf.h       |   6 +-
> >>   kernel/bpf/dump.c              | 338 ++++++++++++++++++++++++++++++++-
> >>   kernel/bpf/syscall.c           |  11 +-
> >>   tools/include/uapi/linux/bpf.h |   6 +-
> >>   5 files changed, 362 insertions(+), 4 deletions(-)
> >>
> >
> > [...]
> >
