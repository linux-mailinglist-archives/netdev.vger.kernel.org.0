Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592F64426E8
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 06:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhKBF4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 01:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhKBF4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 01:56:46 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA825C061714;
        Mon,  1 Nov 2021 22:54:11 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id d204so50326920ybb.4;
        Mon, 01 Nov 2021 22:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9ySVuFK0TUNLUpsat+v5CZsvbUu+2ZZ0PyyAsEqYDoc=;
        b=dIALiRg3XhutinWU+YWQGjbVKdrUhnQA18YA9GVgv63TT5LW7m05o7nQ2C98RpQkER
         SiHp1sUo20pyUT0k1BNgPA4nn9rYMQYo7X/hTO1ZMzfruYmM6l46JE3kjHglctAYP1EW
         8phRaQWjs0cvbe+xjTUeG6+SFr3n99VwxIh/oi8KDFb3i89Q8APwsbOXGhG1GGHbW7Vg
         7kCZ/p2c3jYXryJTxhEbqojz6X4LrDq94h7Or7I1Ki35SHykNZrJrezChow4bQBVnQev
         pcn+pGY9mTenFBr3lIlbrDOY7JGSXfhvCMFCQOO2uCBjJ1mlSxHqUzh4UjQGKWA78PHR
         j6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9ySVuFK0TUNLUpsat+v5CZsvbUu+2ZZ0PyyAsEqYDoc=;
        b=UFdzCUO2JC7/xOQvih7utDT2pv7Q01FE1vMCzIr9DAQwlY3nNR+xGs6b+Z+GApXX5d
         EfoJT9kb0i7Q4NIUa4qJ71GSTTbJmSeX3O8xMe6iTtTyNzFlS4lSfTRTXqnI3rT8u7cr
         yKeJste8OIsNfmoS2VVVQ9t3uKq09n386WDKAVXqG4MWp77qPI5T6ExV01LXCx1B33Kq
         be8TBrcS2dQKqrlV8EG843IibeEoP5wf6nj6/eWP+ivvjrgyOQXtyikt60rusMjM7zgA
         UVkABuGUgTY/WsHVaZefriJg6W/giZwKCqG99Ew8ezJW5hJAsqQmqRzy0AHHjtNgQpIM
         E1Ag==
X-Gm-Message-State: AOAM530UZVR95hq4CI4pIVcvnejU0k2Oim25ysxw+npzYBehrC/JBeKM
        7uFaBiM6xXUIuJ0FwIwput2PsHLIinb2BK1ZtTcf2O46XqI=
X-Google-Smtp-Source: ABdhPJxmma9VRJ+afFLEzg5b8QSqRLFUQQ66+b4e31JlgQx4elyGDPLCX8Efj6WQkVbx8wiiJvxpo4LBizbK+Y0h6h0=
X-Received: by 2002:a25:afcf:: with SMTP id d15mr34383938ybj.433.1635832450764;
 Mon, 01 Nov 2021 22:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com>
In-Reply-To: <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Nov 2021 22:53:59 -0700
Message-ID: <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 9:12 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> > Tracing progs will be peeking into task_struct.
> > To describe it in the reduced BTF most of the kernel types would be nee=
ded,
>
> That's the point of our algorithm. If a program is only accessing
> 'pid' on 'task_struct' we'll generate a BTF representation of
> task_struct that only contains the 'pid' member with the right offset,
> other members are not included and hence we don't need to carry on all
> those types that are not used by the program.
>
> > Have you considered generating kernel BTF with fields that are accessed
> > by bpf prog only and replacing all other fields with padding ?
>
> Yeah. We're implicitly doing it as described above.
>
> > I think the algo would be quite different from the actual CO-RE logic
> > you're trying to reuse.
>
> I'm not 100% sure it's so easy to do without reimplementing much of
> the actual CO-RE logic. We don't want to copy all type members but
> only the ones actually used. So I'm not sure if Andrii's idea of
> performing the matching based only on the type name will work. I'll
> try to get deep into the details and will be back to you soon.

No, now that I understand what exactly you are doing, it won't work.

But ok, I gave it quite a bit of thought and tried to find a good
compromise between completely exposing all the libbpf internals as
public APIs (which is a huge price I'm not willing to accept) and
actually allowing you to achieve your goal (which I think is worthy to
achieve).

But first. https://github.com/aquasecurity/btfhub/tree/main/tools is
awesome. Great work explaining a lot at exactly the right level of
technical details. It would be great if you published it as a
dedicated blog post, maybe splitting the more general information from
the BTF minimization problem. Both are useful, but it's too long for
one article. Great job, really!

Now, to the problem at hand. And sorry for a long reply, but there is
quite a bit of things to unpack.

I see this overall problem as two distinct problems:
  1. Knowing which fields and types libbpf is using from kernel BTF.
Basically, observe CO-RE logic from outside.
  2. Knowing information from #1, minimize BTF.

Part #2 absolutely doesn't belong in libbpf. Libbpf exposes enough BTF
constructing APIs to implement this in any application, bpftool or
otherwise. It's also a relatively straightforward problem: mark used
types and fields, create a copy of BTF with only those types and
fields.

So let's talk about #1, because I agree that it's extremely painful to
have to reimplement most of CO-RE logic just for getting the list of
types and fields. Here we have two sub-problems (assuming we let
libbpf do CO-RE relocation logic for us):
  a) perform CO-RE relocations but don't create BPF maps and load BPF
programs. Dry-run of sorts.
  b) exposing calculated relocation information.

First, 1a. The problem right now is that CO-RE relocations (and
relocations in general) happen in the same bpf_object__load() phase
and it's not possible to do them without creating maps and
subsequently loading BPF programs first. This is very suboptimal. I've
actually been thinking in the background how to improve that
situation, because even with the recent bpf_program__insns() API,
added a few days ago, you still have to load the BPF program to be
able to clone the BPF program, and so I wanted to solve that for a
long while now.

So how about we split bpf_object__load() phase into two:
bpf_object__prepare() and bpf_object__load(). prepare() will do all
the preparations (subprogs, ELF relos, also almost complete BPF map
relos, but not quite; I'll get to this), basically everything that
load does today short of actually creating maps and progs. load() then
will ensure that bpf_object__prepare() was called (i.e., user can do
just prepare(), prepare() + load() explicitly, or load() which will
call prepare() implicitly).

The biggest problem I see right now is what we do about BPF map
relocations. I propose to perform map relocations but substitute map's
internal index (so that if someone dumps prog instructions after
prepare(), it's still meaningful, even if not yet validatable by
verifier). After maps are actually created, we can do another quick
pass over just RELO_DATA and replace map_idx with map's fd.

It feels like we should split load further into two steps: creating
and pinning maps (+ finalizing FDs in instructions) and actually
loading programs. Again, with the same implicit calling of prepare and
map creation steps if the user only calls bpf_object__load(). For ease
of use and backwards compatibility.

So basically, the most granular set of steps would be:
  1. bpf_object__open()
  2. bpf_object__prepare() (or bpf_object__relocate(), naming is hard)
  3. bpf_object__create_maps();
  4. bpf_object__load().

But the old and trusty bpf_object__open() + bpf_object__load() will
work just as well, with load() doing steps #2-#4 automatically, if
necessary.

So what does that split gives us. Few things:
  - it's possible to "simulate" almost all libbpf logic without
changing the state of the system (no maps or progs created). Yet you
still validate that kconfig externs, per-cpu externs, CO-RE relos, map
relos, etc, all that works.
  - libbpf can store extra information between steps 1, 2, 3, and 4,
but after step #4 all that extra information can be discarded and
cleaned up. So advanced users will get access to stuff like
bpf_program__insns() and CO-RE information, but most users won't have
to pay for that because it will be freed after bpf_object__load(). So
in this case, bpf_program__insns() could (should?) be discarded after
actual load, because if you care about instructions, you can do steps
#1-#3, grab instructions and copy them, if necessary. Then proceed to
#4 (or not) and free the memory.

The last point is important, because to solve the problem 1b (exposing
CO-RE relo info), the best way to minimize public API commitments is
to (optionally, probably) request libbpf to record its CO-RE relo
decisions. Here's what I propose, specifically:
  1. Add something like "bool record_core_relo_info" (awful name,
don't use it) in bpf_object_open_opts.
  2. If it is set to true, libbpf will keep a "log" of CO-RE
relocation decisions, recording stuff like program name, instruction
index, local spec (i.e., root_type_id, spec string, relo kind, maybe
something else), target spec (kernel type_id, kernel spec string, also
module ID, if it's not vmlinux BTF). We can also record relocated
value (i.e., field offset, actual enum value, true/false for
existence, etc). All these are stable concepts, so I'd feel more
comfortable exposing them, compared to stuff like bpf_core_accessor
and other internal details.
  3. The memory for all that will be managed by libbpf for simplicity
of an API, and we'll expose accessors to get those arrays (at object
level or per-program level is TBD).
  4. This info will be available after the prepare() step and will be
discarded either at create_maps() or load().

I think that solves problem #1 completely (at least for BTFGen case)
and actually provides more useful information. E.g., if someone wants
to track CO-RE resolution logic for some other reason, they should
have pretty full information (BTFGen doesn't need all of that).

It also doesn't feel like too much complication to libbpf internals
(even though we'll need to be very careful with BPF map relos and
double-checking that we haven't missed any other critical part of the
process). And for most users there is no change in API or behavior.
And given this gives us a "framework" for more sustainable libbpf
"observability", I think it's a justified price to pay, overall.

I still need to sleep on this, but this feels like a bit cleaner way
forward. Thoughts are welcome.

>
> > If CO-RE matching style is necessary and it's the best approach then pl=
ease
> > add new logic to bpftool. I'm not sure such api would be
> > useful beyond this particular case to expose as stable libbpf api.
>
> I agree 100%. Our goal is to have this available on bpftool so all the
> community can use it. However it'd be a shame if we can't use some of
> the existing logic in libbpf.
