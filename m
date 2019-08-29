Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCF8A2A92
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfH2XOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:14:14 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43587 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfH2XOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:14:14 -0400
Received: by mail-lf1-f65.google.com with SMTP id q27so3820537lfo.10
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MYk+CYp9dlFnH2Cn3oaYUDbLEuf1oYYrekZXRqPpvWE=;
        b=HwJdHBD5iwInprC9ONdbjuYZX7LS31sWh9K8+RkS5z5PCuRTyLAaqIQQrahYOoYdZl
         /R3ltd7ZkExE8FBZTC09DXkvSZpAf1FHeqqWsh+yK2ujq7RXNTGYiN49lLcu9TJMzx1K
         5X1m+qS9q5lTQCVN/cjLijZIdSqOM9iJJ+iK1KjAOKYDoXjjxAM/ZTkiCntZgp3UkG3M
         5sxjAGVaHNcTQ/XBB8RedbqWNT18CjUGWWtBEkAM8gPZgEeZYs/IMJAyddrwRu7wuVtZ
         PMosEq1x0bBzQEk7IFU2FS/M3wTfb8JAjo985VvkaxGS05MGRzDPbiox1OeOOg0RvdF9
         Ukyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MYk+CYp9dlFnH2Cn3oaYUDbLEuf1oYYrekZXRqPpvWE=;
        b=GXIJWVXMqa14qbSogZOL/jqCIpTMXX/gMJSLTAkELr2jKKwWVqtOChL0Ty3fH1rX/Q
         6jIgGzEMvBBN5aoaL7VMn1v3f6BTEOu0xNK/0hMSNuFhrPg7+2QxtbrQlMghqLnxoQ3V
         ErMsnzbCz4tnY5/L7T2hiDVMV31YunWMT5zTOMxX1GptNurlZRiVPp8mykGrPR3SISWO
         dmRzyxXPfBMplGAuXAR6ZLx7sG9whBZMc4/gVCZdKZww+xNIWssj+P/qIoloZNsnRqqW
         hwF1Z06Iom19BeyVEOtN2BkjtZqrHLNFhqF7lfC8gxjmpdq+LV6o79t3xRBzawXPdFOH
         ExyA==
X-Gm-Message-State: APjAAAX+lTzxSuwITGMzBALfHztlW9PDXklhFdK5VoOAks0acIu13114
        zWP9U5xhZswWCR1pSflQwqpP+al8WhlvgNl9V6x2lQ==
X-Google-Smtp-Source: APXvYqygGUzXk0pCJ2VxPZ1QFnMULDzuMZl9X5UxSGce+B+Z/PR+Z++BxBPOO637ocTu5WX8KtM8JIvequsWOMdCQiI=
X-Received: by 2002:ac2:410e:: with SMTP id b14mr7467939lfi.123.1567120451264;
 Thu, 29 Aug 2019 16:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190829064502.2750303-1-yhs@fb.com> <20190829113932.5c058194@cakuba.netronome.com>
In-Reply-To: <20190829113932.5c058194@cakuba.netronome.com>
From:   Brian Vazquez <brianvv@google.com>
Date:   Thu, 29 Aug 2019 16:13:59 -0700
Message-ID: <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@fb.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 11:40 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 28 Aug 2019 23:45:02 -0700, Yonghong Song wrote:
> > Brian Vazquez has proposed BPF_MAP_DUMP command to look up more than one
> > map entries per syscall.
> >   https://lore.kernel.org/bpf/CABCgpaU3xxX6CMMxD+1knApivtc2jLBHysDXw-0E9bQEL0qC3A@mail.gmail.com/T/#t
> >
> > During discussion, we found more use cases can be supported in a similar
> > map operation batching framework. For example, batched map lookup and delete,
> > which can be really helpful for bcc.
> >   https://github.com/iovisor/bcc/blob/master/tools/tcptop.py#L233-L243
> >   https://github.com/iovisor/bcc/blob/master/tools/slabratetop.py#L129-L138
> >
> > Also, in bcc, we have API to delete all entries in a map.
> >   https://github.com/iovisor/bcc/blob/master/src/cc/api/BPFTable.h#L257-L264
> >
> > For map update, batched operations also useful as sometimes applications need
> > to populate initial maps with more than one entry. For example, the below
> > example is from kernel/samples/bpf/xdp_redirect_cpu_user.c:
> >   https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_redirect_cpu_user.c#L543-L550
> >
> > This patch addresses all the above use cases. To make uapi stable, it also
> > covers other potential use cases. Four bpf syscall subcommands are introduced:
> >     BPF_MAP_LOOKUP_BATCH
> >     BPF_MAP_LOOKUP_AND_DELETE_BATCH
> >     BPF_MAP_UPDATE_BATCH
> >     BPF_MAP_DELETE_BATCH
> >
> > In userspace, application can iterate through the whole map one batch
> > as a time, e.g., bpf_map_lookup_batch() in the below:
> >     p_key = NULL;
> >     p_next_key = &key;
> >     while (true) {
> >        err = bpf_map_lookup_batch(fd, p_key, &p_next_key, keys, values,
> >                                   &batch_size, elem_flags, flags);
> >        if (err) ...
> >        if (p_next_key) break; // done
> >        if (!p_key) p_key = p_next_key;
> >     }
> > Please look at individual patches for details of new syscall subcommands
> > and examples of user codes.
> >
> > The testing is also done in a qemu VM environment:
> >       measure_lookup: max_entries 1000000, batch 10, time 342ms
> >       measure_lookup: max_entries 1000000, batch 1000, time 295ms
> >       measure_lookup: max_entries 1000000, batch 1000000, time 270ms
> >       measure_lookup: max_entries 1000000, no batching, time 1346ms
> >       measure_lookup_delete: max_entries 1000000, batch 10, time 433ms
> >       measure_lookup_delete: max_entries 1000000, batch 1000, time 363ms
> >       measure_lookup_delete: max_entries 1000000, batch 1000000, time 357ms
> >       measure_lookup_delete: max_entries 1000000, not batch, time 1894ms
> >       measure_delete: max_entries 1000000, batch, time 220ms
> >       measure_delete: max_entries 1000000, not batch, time 1289ms
> > For a 1M entry hash table, batch size of 10 can reduce cpu time
> > by 70%. Please see patch "tools/bpf: measure map batching perf"
> > for details of test codes.
>
> Hi Yonghong!
>
> great to see this, we have been looking at implementing some way to
> speed up map walks as well.
>
> The direction we were looking in, after previous discussions [1],
> however, was to provide a BPF program which can run the logic entirely
> within the kernel.
>
> We have a rough PoC on the FW side (we can offload the program which
> walks the map, which is pretty neat), but the kernel verifier side
> hasn't really progressed. It will soon.
>
> The rough idea is that the user space provides two programs, "filter"
> and "dumper":
>
>         bpftool map exec id XYZ filter pinned /some/prog \
>                                 dumper pinned /some/other_prog
>
> Both programs get this context:
>
> struct map_op_ctx {
>         u64 key;
>         u64 value;
> }
>
> We need a per-map implementation of the exec side, but roughly maps
> would do:
>
>         LIST_HEAD(deleted);
>
>         for entry in map {
>                 struct map_op_ctx {
>                         .key    = entry->key,
>                         .value  = entry->value,
>                 };
>
>                 act = BPF_PROG_RUN(filter, &map_op_ctx);
>                 if (act & ~ACT_BITS)
>                         return -EINVAL;
>
>                 if (act & DELETE) {
>                         map_unlink(entry);
>                         list_add(entry, &deleted);
>                 }
>                 if (act & STOP)
>                         break;
>         }
>
>         synchronize_rcu();
>
>         for entry in deleted {
>                 struct map_op_ctx {
>                         .key    = entry->key,
>                         .value  = entry->value,
>                 };
>
>                 BPF_PROG_RUN(dumper, &map_op_ctx);
>                 map_free(entry);
>         }
>
Hi Jakub,

how would that approach support percpu maps?

I'm thinking of a scenario where you want to do some calculations on
percpu maps and you are interested on the info on all the cpus not
just the one that is running the bpf program. Currently on a pcpu map
the bpf_map_lookup_elem helper only returns the pointer to the data of
the executing cpu.

> The filter program can't perform any map operations other than lookup,
> otherwise we won't be able to guarantee that we'll walk the entire map
> (if the filter program deletes some entries in a unfortunate order).
>
> If user space just wants a pure dump it can simply load a program which
> dumps the entries into a perf ring.
>
> I'm bringing this up because that mechanism should cover what is
> achieved with this patch set and much more.
>
> In particular for networking workloads where old flows have to be
> pruned from the map periodically it's far more efficient to communicate
> to user space only the flows which timed out (the delete batching from
> this set won't help at all).
>
> With a 2M entry map and this patch set we still won't be able to prune
> once a second on one core.
>
> [1]
> https://lore.kernel.org/netdev/20190813130921.10704-4-quentin.monnet@netronome.com/
