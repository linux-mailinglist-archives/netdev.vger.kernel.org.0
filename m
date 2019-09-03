Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6560A776B
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 01:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfICXHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 19:07:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38880 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfICXHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 19:07:32 -0400
Received: by mail-lj1-f195.google.com with SMTP id h3so10895205ljb.5
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 16:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mqmGLWDNtJU9nnruhkc+eJHdA1F9Px92K0ZgMpo2U7s=;
        b=clMtA7QxgF1EvgP1F4dhTD0K4wP1lxSy0NZzmDQQnJ7mbLGmYuyDhVEsSYO49P+jTu
         3UCrQSH/Hm2s9qJagmhzr9xATyYX0lKGdg0X9pg3m3vv7Lv70CJoAuzE9vXVVNmmKDjT
         84g+dUoRGj8TfKbxCS+V21SJZeZsQ5DxZLelnia/2Szgrw8QMnt1gRKWBwhoGbLcsxQn
         a0yJ/R9EsOhJO8IpzV2Og0PL0XZXd16fxmvvH3KtpZMGTfPs/Mxo6CBQjkXB/OqHY+TY
         w0wBocoDC98kKFMOgDSPMwyK8W5jfEu1a43s9QmpolpJXacU5Qm4LJ85whSidGmKdNqk
         E4iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mqmGLWDNtJU9nnruhkc+eJHdA1F9Px92K0ZgMpo2U7s=;
        b=GyIT7B8+XqpDcU0Zt2qjycBv7eHMSIQ63eppLv20080RXc0/njH1qRqQ4pu5RoKKvg
         fgnglOqPcsab+oYlWv0Ya7eKOpo5rZSYD7hdNrEQT7TO+LnWVCZxRAIGXfZ/zJ70ORlq
         nV7A3XVg8hRObvIXklfRMhb8PFFRhIKaaIXFg4GeN/uo6JoYKrkA1GwtDkGc8x89OP2N
         Mm9fAgGGChQmIeJPyhg+sKs/zS7gxMJ4GCrk7TFnP2f9FRlWuDeyi2jAhbyUzd4/YKJd
         7i/dGYlpjE6Py/Y23+8UWXBy5qy5yHoQgUeXQBmd0+Az5NeQNda/+azloBK+5H9PObfj
         9tCA==
X-Gm-Message-State: APjAAAVJY8+3jeaYG84trkhv357SzaiB6XWfGckyfiFW9sCs7rovVqY4
        L9gDy3fpaSuXT3rdRgm0NE+Wh6t/KGor6nM46tagHw==
X-Google-Smtp-Source: APXvYqyh1lYeI3GFwIpWYhi0afIm4G5kpzWJ934FxEdhnOVcWFSWLA29jDm1YjXFwccInj5ss5KyXfsRwsbHhsme37k=
X-Received: by 2002:a2e:5418:: with SMTP id i24mr8877551ljb.126.1567552049275;
 Tue, 03 Sep 2019 16:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190829064502.2750303-1-yhs@fb.com> <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com> <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com> <20190830211809.GB2101@mini-arch>
 <20190903210127.z6mhkryqg6qz62dq@ast-mbp.dhcp.thefacebook.com> <20190903223043.GC2101@mini-arch>
In-Reply-To: <20190903223043.GC2101@mini-arch>
From:   Brian Vazquez <brianvv@google.com>
Date:   Tue, 3 Sep 2019 16:07:17 -0700
Message-ID: <CAMzD94Qge5CtUZ+_0DsuQ_VLpmoADDZemFH1=WA-H8P0ax8qDQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 3, 2019 at 3:30 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 09/03, Alexei Starovoitov wrote:
> > On Fri, Aug 30, 2019 at 02:18:09PM -0700, Stanislav Fomichev wrote:
> > > > >
> > > > > I personally like Jakub's/Quentin's proposal more. So if I get to choose
> > > > > between this series and Jakub's filter+dump in BPF, I'd pick filter+dump
> > > > > (pending per-cpu issue which we actually care about).
> > > > >
> > > > > But if we can have both, I don't have any objections; this patch
> >
> > I think we need to have both.
> > imo Jakub's and Yonghong's approach are solving slightly different cases.
> >
> > filter+dump via program is better suited for LRU map walks where filter prog
> > would do some non-trivial logic.
> > Whereas plain 'delete all' or 'dump all' is much simpler to use without
> > loading yet another prog just to dump it.
> > bpf infra today isn't quite ready for this very short lived auxiliary progs.
> > At prog load pages get read-only mapping, tlbs across cpus flushed,
> > kallsyms populated, FDs allocated, etc.
> > Loading the prog is a heavy operation. There was a chatter before to have
> > built-in progs. This filter+dump could benefit from builtin 'allow all'
> > or 'delete all' progs, but imo that complicates design and asks even
> > more questions than it answers. Should this builtin progs show up
> > in 'bpftool prog show' ? When do they load/unload? Same safety requirements
> > as normal progs? etc.
> > imo it's fine to have little bit overlap between apis.
> > So I think we should proceed with both batching apis.
> We don't need to load filter+dump every time we need a dump, right?
> We, internally, want to have this 'batch dump' only for long running daemons
> (I think the same applies to bcc), we can load this filter+dump once and
> then have a sys_bpf() command to trigger it.
>
> Also, related, if we add this batch dump, it doesn't mean that
> everything should switch to it. For example, I feel like we
> are perfectly fine if bpftool still uses get_next_key+lookup
> since we use it only for debugging.
>
> > Having said that I think both are suffering from the important issue pointed out
> > by Brian: when kernel deletes an element get_next_key iterator over hash/lru
> > map will produce duplicates.
> > The amount of duplicates can be huge. When batched iterator is slow and
> > bpf prog is doing a lot of update/delete, there could be 10x worth of duplicates,
> > since walk will resume from the beginning.
> > User space cannot be tasked to deal with it.
> > I think this issue has to be solved in the kernel first and it may require
> > different batching api.

We could also modify get_next_key behaviour _only_ when it's called
from a dumping function in which case we do know that we want to move
forward not backwards (basically if prev_key is not found, then
retrieve the first key in the next bucket).

That approach might miss entries that are in the same bucket where the
prev_key used to be, but missing entries is something that can always
happen (new additions in previous buckets), we can not control that
and as it has said before, if users care about consistency they can
use map-in-map.

> > One idea is to use bucket spin_lock and batch process it bucket-at-a-time.
> > From api pov the user space will tell kernel:
> > - here is the buffer for N element. start dump from the beginning.
> > - kernel will return <= N elements and an iterator.
> > - user space will pass this opaque iterator back to get another batch
> > For well behaved hash/lru map there will be zero or one elements per bucket.
> > When there are 2+ the batching logic can process them together.
> > If 'lookup' is requested the kernel can check whether user space provided
> > enough space for these 2 elements. If not abort the batch earlier.
> > get_next_key won't be used. Instead some sort of opaque iterator
> > will be returned to user space, so next batch lookup can start from it.
> > This iterator could be the index of the last dumped bucket.
> > This idea won't work for pathological hash tables though.
> > A lot of elements in a single bucket may be more than room for single batch.
> > In such case iterator will get stuck, since num_of_elements_in_bucket > batch_buf_size.
> > May be special error code can be used to solve that?
> This all requires new per-map implementations unfortunately :-(
> We were trying to see if we can somehow improve the existing bpf_map_ops
> to be more friendly towards batching.

Agreed that one of the motivations for current batching implementation
was to re use the existing code as much as we can. Although this might
be a good opportunity to do some per-map implementations as long as
they behave better than the current ones.

>
> You also bring a valid point with regard to well behaved hash/lru,
> we might be optimizing for the wrong case :-)

For pathological hash tables, wouldn't batching lookup_and_delete
help? In theory you are always requesting for the current first_key,
copying it and deleting it. And even if you retrieve the same key
during the batch (because another cpu added it again) it would contain
different info right?

> > I hope we can come up with other ideas to have a stable iterator over hash table.
> > Let's use email to describe the ideas and upcoming LPC conference to
> > sort out details and finalize the one to use.
