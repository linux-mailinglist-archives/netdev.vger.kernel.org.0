Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE82B8075
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 19:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391097AbfISRww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 13:52:52 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41996 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389717AbfISRww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 13:52:52 -0400
Received: by mail-qk1-f193.google.com with SMTP id f16so4278629qkl.9;
        Thu, 19 Sep 2019 10:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n+Ua/O2NjZZMQ+DWHLhqXVyJgS3ofC2/P3HEomRe0g8=;
        b=u0drJ5vpPniINjhF75RuaMY8m6pLKY2/CKBE0M1piP76XkUmsjFjp4o6H9rHAjJtYZ
         5j60Rf8JfbF/gFiYRVFI+0xHz2NU9eIJINltYOYAtxJI3NI/atX/DocNBHzzXWSmgojl
         i/+0nBSEccWTftPmpyhiVnUFMjNTCY0fMCltykVtoRIWKQHZc9bR59Ic4B2b9bYYon2O
         FLLJXLrfx+dIX1nbQo3aMo8kSFPtSpWhbnT+0zi97jYw2/+GIR9HEbax9SN8RkHV5+PG
         WKeymxfzkmQsN5K8M78U/1tXj+Si/aj71q3E3fhnbQZ4zD9CMB675Ng92BP2d1ttmsds
         i0nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n+Ua/O2NjZZMQ+DWHLhqXVyJgS3ofC2/P3HEomRe0g8=;
        b=kHdV7v0cvJELAUFgaxEEmuUL0Ul5UiNI7W1vi+b+K/vAw3UTRDopM76RqFdCbSKxY5
         GEj2DROuyu3uRD6F0yWEwn4UxZL01wXiJLRMITic1jYkt8cF4RQKTUZIvyuS5Y5Nw5Nk
         9vVJBuEgv2m/zzyVfZSImIg2wEucsopweFUoUsbD+H5umois7N8YfbBidVnVrqbta+O9
         3EkGzxyo/0I8Olm8h6OT6Bp5mL1LuRXUlgVm3173GYerowHuSJxKsNPF6K7QWTbNwFlb
         xGbtudZN+djHtrY7KPN88VPqm6PCwKVaBxXPINDpAIE2Af+cJMmnnC46ZXJDnsoveRC9
         ilpQ==
X-Gm-Message-State: APjAAAXinK2gdiLLrexY/Q+hvdScQPYN0zWEbXYZN1V5ylInhzBq6wdE
        PZYtrn6ePdQgywkvmKnI3YPVuEEUROOOcp2K2zU=
X-Google-Smtp-Source: APXvYqzhqX0Ky5nOspIy9kkq1AOGZuLZrZsDXJRRBrLR0hBl+/wbb+pNt2nhIAJCOucHXlYQ/GLG6P2LjJc/BpxQtHc=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr4347972qkg.36.1568915570737;
 Thu, 19 Sep 2019 10:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190911190218.22628-1-danieltimlee@gmail.com>
 <CAEf4Bza7tFdDP0=Nk4UVtWn68Kr7oYZziUodN40a=ZKne4-dEQ@mail.gmail.com>
 <CAEKGpzjUu7Qr0PbU6Es=7J6KAsyr9K1qZvFoWxZ-dhPsD0_8Kg@mail.gmail.com>
 <CAEf4BzY_EAf9pH7YvL9XAXPUr9+g5Q7N_n45XBufdxkfDbf3aQ@mail.gmail.com> <CAEKGpzjf22NpMapev7OnxSmU2HpHoEcGHjX81Pw4LDvOt58NRw@mail.gmail.com>
In-Reply-To: <CAEKGpzjf22NpMapev7OnxSmU2HpHoEcGHjX81Pw4LDvOt58NRw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Sep 2019 10:52:39 -0700
Message-ID: <CAEf4Bzb1ytdbwMFGdwsx7BrucbJT6Gc0QhgQE+mZkGwWTky-oA@mail.gmail.com>
Subject: Re: [bpf-next,v3] samples: bpf: add max_pckt_size option at xdp_adjust_tail
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 2:16 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Thu, Sep 19, 2019 at 3:00 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Wed, Sep 18, 2019 at 10:37 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > On Tue, Sep 17, 2019 at 1:04 PM Andrii Nakryiko
> > > <andrii.nakryiko@gmail.com> wrote:
> > > >
> > > > On Wed, Sep 11, 2019 at 2:33 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > > > >
> > > > > Currently, at xdp_adjust_tail_kern.c, MAX_PCKT_SIZE is limited
> > > > > to 600. To make this size flexible, a new map 'pcktsz' is added.
> > > > >
> > > > > By updating new packet size to this map from the userland,
> > > > > xdp_adjust_tail_kern.o will use this value as a new max_pckt_size.
> > > > >
> > > > > If no '-P <MAX_PCKT_SIZE>' option is used, the size of maximum packet
> > > > > will be 600 as a default.
> > > > >
> > > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > >
> > > > > ---
> > > > > Changes in v2:
> > > > >     - Change the helper to fetch map from 'bpf_map__next' to
> > > > >     'bpf_object__find_map_fd_by_name'.
> > > > >
> > > > >  samples/bpf/xdp_adjust_tail_kern.c | 23 +++++++++++++++++++----
> > > > >  samples/bpf/xdp_adjust_tail_user.c | 28 ++++++++++++++++++++++------
> > > > >  2 files changed, 41 insertions(+), 10 deletions(-)
> > > > >
> > > > > diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> > > > > index 411fdb21f8bc..d6d84ffe6a7a 100644
> > > > > --- a/samples/bpf/xdp_adjust_tail_kern.c
> > > > > +++ b/samples/bpf/xdp_adjust_tail_kern.c
> > > > > @@ -25,6 +25,13 @@
> > > > >  #define ICMP_TOOBIG_SIZE 98
> > > > >  #define ICMP_TOOBIG_PAYLOAD_SIZE 92
> > > > >
> > > > > +struct bpf_map_def SEC("maps") pcktsz = {
> > > > > +       .type = BPF_MAP_TYPE_ARRAY,
> > > > > +       .key_size = sizeof(__u32),
> > > > > +       .value_size = sizeof(__u32),
> > > > > +       .max_entries = 1,
> > > > > +};
> > > > > +
> > > >
> > > > Hey Daniel,
> > > >
> > > > This looks like an ideal use case for global variables on BPF side. I
> > > > think it's much cleaner and will make BPF side of things simpler.
> > > > Would you mind giving global data a spin instead of adding this map?
> > > >
> > >
> > > Sure thing!
> > > But, I'm not sure there is global variables for BPF?
> > > AFAIK, there aren't any support for global variables yet in BPF
> > > program (_kern.c).
> > >
> > >     # when defining global variable at _kern.c
> > >     libbpf: bpf: relocation: not yet supported relo for non-static
> > > global '<var>' variable found in insns[39].code 0x18
> >
> > just what it says: use static global variable (also volatile to
> > prevent compiler optimizations) :)
> >
> > static volatile __u32 pcktsz; /* this should work */
> >
>
> My apologies, but I'm not sure I'm following.
> What you are saying is, should I define global variable to _kern,c
> and access and modify this variable from _user.c?

Exactly.

>
> For example,
>
> <_kern.c>
> static volatile __u32 pcktsz = 300;

So this part is right.

>
> <_user.c>
> extern __u32 pcktsz;
> // Later in code
> pcktsz = 400;

This one is not as simple, unfortunately. From user side you need to
find an internal map (it will most probably have .bss suffix) and
update it. See selftests/bpf/prog_tests/global_data.c for how it can
be done. Eventually working with BPF global data will be much more
natural, but we don't yet have that implemented.


>
> Is this code means similar to what you've said?
> AFAIK, 'static' keyword for global variable restricts scope to file itself,
> so the 'accessing' and 'modifying' this variable from the <_user.c>
> isn't available.
>
> The reason why I've used bpf map for this 'pcktsz' option is,
> I've wanted to run this kernel xdp program (xdp_adjust_tail_kern.o)
> as it itself, not heavily controlled by user program (./xdp_adjust_tail).
>
> When this 'pcktsz' option is implemented in bpf map, user can simply
> modify 'map' to change this size. (such as bpftool prog map)
>
> But when this variable comes to global data, it can't be changed
> after the program gets loaded.
>
> I really appreciate your time and effort for the review.
> But I'm sorry that I seem to get it wrong.

I understand your confusion, but BPF global data behaves exactly like
what you explain. From BPF side it looks like a normal variable.
Performance-wise it's also faster than doing explicit map lookup. From
user space side it's still a map, though, so you can read/modify it
and generally do the same communication between BPF kernel and user
space as you are used to with maps. Check selftests, it should make it
clearer.

>
> Thanks,
> Daniel
>
> > >
> > > By the way, thanks for the review.
> > >
> > > Thanks,
> > > Daniel
> > >
> > >
> > > > >  struct bpf_map_def SEC("maps") icmpcnt = {
> > > > >         .type = BPF_MAP_TYPE_ARRAY,
> > > > >         .key_size = sizeof(__u32),
> > > > > @@ -64,7 +71,8 @@ static __always_inline void ipv4_csum(void *data_start, int data_size,
> > > > >         *csum = csum_fold_helper(*csum);
> > > > >  }
> > > > >
> > > >
> > > > [...]
