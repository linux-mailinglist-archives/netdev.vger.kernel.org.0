Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B14257429
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFZWPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 18:15:47 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44458 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfFZWPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 18:15:47 -0400
Received: by mail-qt1-f193.google.com with SMTP id x47so293405qtk.11;
        Wed, 26 Jun 2019 15:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YqsrTlo+gcL4B4t7G2VP05OG6ppDqWg6u3t/7Le3dgU=;
        b=UP/ZCqb5s0tOdnhdvJw7Fe0TSqgphP0+Q+5GdHWqQ/99+fBJEhOSstfgGAxHGWjp2k
         vrr7ywq4P7HJLC0bWqcB+TzMDsSfA444WZNhMVPW41AvDeter62iDTgZxQ7OJgMAavcs
         k14M+vlAzLpXcbk+UU8OLBBJD5GGzxmcGT3M33OqypIYozik86ZGwt5zvW6X4XELGBRr
         0yu1iC2WGSMp7IVrY3vH9jTrelGx2sXJvPXM56b5oYBK2YrBAcsD0ZjUAVubjZqxVtOr
         9WVn5055124Wy0nT2J26vE2zHNs/CUonP9jqNyeRo3sL98XTU6/sp8cxxY8ITEK2truG
         U0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YqsrTlo+gcL4B4t7G2VP05OG6ppDqWg6u3t/7Le3dgU=;
        b=rihv9yuus7vS9+rHSZTt/UgR1WJghFpaKOoahMoD9Jb6g0sc9Rv47yz1U21o5LdeI8
         ctcY0tVW1O3h2jgfSTL0S3h5htPMWtzAyFrNW7kEi8EXpeya9/g3qyppVRq3CCgIbD2M
         KkHzmEsg7/9gAQxR8FmmfJqtOjFcMtMFDLctV6n9Vnjy5Ip///SqOZKkoDSHRxQ4HNw4
         bmtO0Z9DNelODTeE8Zl6VQ7G1ZT9rk49Dg8mZ1ssa5sQdXxXID9S+oOD/YYGGsFg/JrY
         jRsr+mH7TPpxQmQ3Fyg4DnDyBPHmEiXmH3sUCKWfXxDd+xNJrGE8sMJPEiKyW5ViHx0t
         Y/iQ==
X-Gm-Message-State: APjAAAXw+/iPJiD3U1WXQMYYQdik7v0feuOpY1NZiVWLTKNvJyAaq7oP
        0/UfHUty8I2niK/PAzXEimnDoD0qlJQoejsak1U=
X-Google-Smtp-Source: APXvYqxgK8NBrIMk7RSclF2SVPR3il0nDfSR8eLdLdwFXEQ/rfesYSS9T2i24ZfnoSO1h1jP1jLxHYFqehDu+CUiy7Q=
X-Received: by 2002:a0c:c107:: with SMTP id f7mr191115qvh.150.1561587346020;
 Wed, 26 Jun 2019 15:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190621045555.4152743-1-andriin@fb.com> <20190621045555.4152743-4-andriin@fb.com>
 <a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net>
In-Reply-To: <a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Jun 2019 15:15:34 -0700
Message-ID: <CAEf4BzYy4Eorj0VxzArZg+V4muJCvDTX_VVfoouzZUcrBwTa1w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/7] libbpf: add kprobe/uprobe attach API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 7:25 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 06/21/2019 06:55 AM, Andrii Nakryiko wrote:
> > Add ability to attach to kernel and user probes and retprobes.
> > Implementation depends on perf event support for kprobes/uprobes.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---

<snip>

> > +}
>
> I do like that we facilitate usage by adding these APIs to libbpf, but my $0.02
> would be that they should be designed slightly different. See it as a nit, but
> given it's exposed in libbpf.map and therefore immutable in future it's worth
> considering; right now with this set here you have:
>
> int bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
>                                const char *func_name)
> int bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
>                                pid_t pid, const char *binary_path,
>                                size_t func_offset)
> int bpf_program__attach_tracepoint(struct bpf_program *prog,
>                                    const char *tp_category,
>                                    const char *tp_name)
> int bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
>                                        const char *tp_name)
> int bpf_program__attach_perf_event(struct bpf_program *prog, int pfd)
> int libbpf_perf_event_disable_and_close(int pfd)
>
> So the idea is that all the bpf_program__attach_*() APIs return an fd that you
> can later on pass into libbpf_perf_event_disable_and_close(). I think there is
> a bit of a disconnect in that the bpf_program__attach_*() APIs try to do too
> many things at once. For example, the bpf_program__attach_raw_tracepoint() fd
> has nothing to do with perf, so passing to libbpf_perf_event_disable_and_close()
> kind of works, but is hacky since there's no PERF_EVENT_IOC_DISABLE for it so this
> would always error if a user cares to check the return code. In the kernel, we

Yeah, you are absolutely right, missed that it's not creating perf
event under cover, to be honest.

> use anon inode for this kind of object. Also, if a user tries to add more than
> one program to the same event, we need to recreate a new event fd every time.
>
> What this boils down to is that this should get a proper abstraction, e.g. as
> in struct libbpf_event which holds the event object. There should be helper
> functions like libbpf_event_create_{kprobe,uprobe,tracepoint,raw_tracepoint} returning
> such an struct libbpf_event object on success, and a single libbpf_event_destroy()
> that does the event specific teardown. bpf_program__attach_event() can then take
> care of only attaching the program to it. Having an object for this is also more
> extensible than just a fd number. Nice thing is that this can also be completely
> internal to libbpf.c as with struct bpf_program and other abstractions where we
> don't expose the internals in the public header.

Yeah, I totally agree, I think this is a great idea! I don't
particularly like "event" name, that seems very overloaded term. Do
you mind if I call this "bpf_hook" instead of "libbpf_event"? I've
always thought about these different points in the system to which one
can attach BPF program as hooks exposed from kernel :)

Would it also make sense to do attaching to non-tracing hooks using
the same mechanism (e.g., all the per-cgroup stuff, sysctl, etc)? Not
sure how people do that today, will check to see how it's done, but I
think nothing should conceptually prevent doing that using the same
abstract bpf_hook way, right?

>
> Thanks,
> Daniel
