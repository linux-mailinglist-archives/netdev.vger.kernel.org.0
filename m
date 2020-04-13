Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF01A6DBC
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388721AbgDMVFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 17:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733294AbgDMVFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 17:05:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D1C0A3BDC;
        Mon, 13 Apr 2020 14:05:10 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id x66so11025339qkd.9;
        Mon, 13 Apr 2020 14:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EeQ8cPZJyMnqn3qp0XRBgz6RrgR26tWzPDHmc+2fnOM=;
        b=CjtQsC66PMc5HraPdj9ULgl0I8UNFNaoXL8fU45Rx5NRMwAa1u6t9+jumKL0iav37x
         /tywjmQvUxa2vTMLxcQKkc/P+1bnPucswYSqH4IhJgG1KMnp4Qg/J6pOnpz8g75GjL+v
         a/2HDWioSOcGGK7tjtLnu4Lc83nKk2MZ6ICFS9M6M9l7OSsUHw6JWwrwmDfYiP5mZGbJ
         0maX2a/AsBqa4I8HkYtfdZxlEBtaAZjroK87P0EceVEVaiJbdkvZ2QPs5GEicyERRXlR
         8tOrGL1J3v5gSYKqdZqceB1OgEysedaUv8MRjBQAETbaDUK83rSfU6Uv+u3df/dyeXf9
         ZEcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EeQ8cPZJyMnqn3qp0XRBgz6RrgR26tWzPDHmc+2fnOM=;
        b=PrgN2ziRBn0JgBTeE9UVt4S8T7bxUn+H2n53xrEI1VR+QkA0THTVzGdELIBj807mJB
         NJBGTFFRDW3LWfNUkCi+r3lA9Yh3+ARHoNWpCRhv1SVVJx3YiF+GUMG0ep3Aa/b4wm4c
         QbrmzN6fW+01cIzxpFlHB/QOQ0thJllWaELE9ivAoeMeS7Rnalnkzg4JWC+wSyJbBunj
         0MMXnXOJq6RWttScKkm2vPQJoRt+STXFUjVmJ2yBwv7jcxQGsA5fvutc9ENC5L7F6GV9
         1sbF/35LuoJ/LXGpPvw6yytqzKazth7atIyZeeF+CfEgKCbACdD5V40LGEvvJ9qNxdqU
         zJ8w==
X-Gm-Message-State: AGi0PuYCIL/QuLqakAyrllZkQc6XCQRnhBk8q/c248gYytM0NqZznFzR
        UdehguRE3EKAlfOUCwA65xsR1JBA0p4uCg2ypQI=
X-Google-Smtp-Source: APiQypJIPQcMRZSZaBjNWQXP2uxgKBJ6dTQb55JCjl/jSob8DKg+WUwl/6wUY9XZkqC7yRZAjcnsZYZYyIww4BV+ito=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr18268101qkg.36.1586811909682;
 Mon, 13 Apr 2020 14:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232526.2675664-1-yhs@fb.com>
 <CAEf4Bza8w9ypepeu6eoJkiXqKqEXtWAOONDpZ9LShivKUCOJbg@mail.gmail.com>
 <334a91d2-1567-bf3d-4ae6-305646738132@fb.com> <20200411231719.4nybod6ku524eawv@ast-mbp>
In-Reply-To: <20200411231719.4nybod6ku524eawv@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 14:04:58 -0700
Message-ID: <CAEf4BzaH6oMM=mxaBq3TOK1aK9GmBy-rd0gR12RK6NwVyjUDPg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 4:17 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 10, 2020 at 05:23:30PM -0700, Yonghong Song wrote:
> > >
> > > So it seems like few things would be useful:
> > >
> > > 1. end flag for post-aggregation and/or footer printing (seq_num == 0
> > > is providing similar means for start flag).
> >
> > the end flag is a problem. We could say hijack next or stop so we
> > can detect the end, but passing a NULL pointer as the object
> > to the bpf program may be problematic without verifier enforcement
> > as it may cause a lot of exceptions... Although all these exception
> > will be silenced by bpf infra, but still not sure whether this
> > is acceptable or not.
>
> I don't like passing NULL there just to indicate something to a program.
> It's not too horrible to support from verifier side, but NULL is only
> one such flag. What does it suppose to indicate? That dumper prog
> is just starting? or ending? Let's pass (void*)1, and (void *)2 ?
> I'm not a fan of such inband signaling.
> imo it's cleaner and simpler when that object pointer is always valid.

I'm not proposing to pass fake pointers. I proposed to have bpfdump
context instead. E.g., one way to do this would be something like:

struct bpf_dump_context {
  struct seq_file *seq;
  u64 seq_num;
  int flags; /* 0 | BPF_DUMP_START | BPF_DUMP_END */
};

int prog(struct bpf_dump_context *ctx, struct netlink_sock *sk) {
  if (ctx->flags & BPF_DUMP_END) {
    /* emit summary */
    return 0;
  }

  /* sk must be not null here. */
}


This is one way. We can make it simpler by saying that sk == NULL is
always end of aggregation for given seq_file, then we won't need flags
and will require `if (!sk)` check explicitly. Don't know what's the
best way, but what I'm advocating for is to have a way for BPF program
to know that processing is finished and it's time to emit summary. See
my other reply in this thread with example use cases.


>
> > > 2. Some sort of "session id", so that bpfdumper can maintain
> > > per-session intermediate state. Plus with this it would be possible to
> > > detect restarts (if there is some state for the same session and
> > > seq_num == 0, this is restart).
> >
> > I guess we can do this.
>
> beyond seq_num passing session_id is a good idea. Though I don't quite see
> the use case where you'd need bpfdumper prog to be stateful, but doesn't hurt.

State per session seems most useful, so session id + hashmap solves
it. If we do sk_local storage per seq_file, that might be enough as
well, I guess...

Examples are any kind of summary stats across all sockets/tasks/etc.

Another interesting use case: produce map from process ID (tgid) to
bpf_maps, bpf_progs, bpf_links (or sockets, or whatever kind of file
we need). You'd need FD/file -> kernel object map and then kernel
object -> tgid map. I think there are many useful use-cases beyond
"one line per object" output cases that inspired bpfdump in the first
place.
