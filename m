Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4207177310
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgCCJuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:50:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20458 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727798AbgCCJuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:50:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583229033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AYkiMBg88+Sms3z7E2UvFQrAcA/l67u9Q2rGKyCzLxM=;
        b=jC0MH44uU72AmFgZ4D5oIKN+xJcGQy/DgEAOI2EXkummETz9BbzMauiATcIgb1QHWIn9mn
        hpEOwZn2HTYNargDzTpdrgAu56ujnzv/2RW+O71sA/hpXSbTIkFYqifQurmeq+SHfTO5OR
        6WtguYZw6o8SpZBA1EvZmLoMw+RVlNY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-VQtczUL4P7W_OUqT5ddCdw-1; Tue, 03 Mar 2020 04:50:29 -0500
X-MC-Unique: VQtczUL4P7W_OUqT5ddCdw-1
Received: by mail-wm1-f72.google.com with SMTP id m4so851450wmi.5
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:50:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=AYkiMBg88+Sms3z7E2UvFQrAcA/l67u9Q2rGKyCzLxM=;
        b=qdXnpp9UJ3HVyIEXoo8NdbJJ+4mbpJ3XNWPIVLUUMnYNpAyXjoTrwLtFhIv9yi89zJ
         o1w2IYegkuP+dp7KJ0v/DcGZ1C4xGAFEHLLpm0iUYMLYHhhndAsYkPfi6CQgbvSrKWPs
         DKU4R4tP3hEFtctp+Ffc6nbwCWXYYAYk/VlNLb3t54UlIDMGEzn3iaBEky3icWSFh4JG
         yqzKC4qP5tBZM0GG75axe2rRufONY5Y3AHaxqWGI/vTWJLx22oepSAlAV+5TZXL5FjSJ
         P4rZ5TPWGAZOirV+OfFgdJeCn2f+RaILB1SAlxVRpJv5DIjs5D94aWVw62IlUG7WRP07
         QTMQ==
X-Gm-Message-State: ANhLgQ2ag8X/f2h6xgQthtfDtoALWhZSRBhbjnQm/qy+31urrJ1GTYSC
        wBueCVMz8R/kiIuwj3DxbT+Ofcs8S9dJTH0gkGbM+6kH5e3udc2OvdPvuu1nSxBPiEVzdEoQ6pl
        zz56q+6G8GTJxkQ9l
X-Received: by 2002:a1c:2504:: with SMTP id l4mr3603880wml.72.1583229028457;
        Tue, 03 Mar 2020 01:50:28 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsADiLk8klS+dB4+wxTHurnBaAHp5n8o+bwPoJKeFEBcAoKFBmiA9/EvCjQJtl2VNjxZVuJKA==
X-Received: by 2002:a1c:2504:: with SMTP id l4mr3603849wml.72.1583229027992;
        Tue, 03 Mar 2020 01:50:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x21sm2915205wmi.30.2020.03.03.01.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:50:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8AEDB180331; Tue,  3 Mar 2020 10:50:25 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrey Ignatov <rdna@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ctakshak@fb.com
Subject: Re: [PATCH RFC] Userspace library for handling multiple XDP programs on an interface
In-Reply-To: <20200303010318.GB84713@rdna-mbp>
References: <158289973977.337029.3637846294079508848.stgit@toke.dk> <20200228221519.GE51456@rdna-mbp> <87v9npu1cg.fsf@toke.dk> <20200303010318.GB84713@rdna-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 03 Mar 2020 10:50:25 +0100
Message-ID: <877e01sr6m.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrey Ignatov <rdna@fb.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> [Sat, 2020-02-29 02:36=
 -0800]:
>> Andrey Ignatov <rdna@fb.com> writes:
>>=20
>> > The main challenges I see for applying this approach in fb case is the
>> > need to recreate the dispatcher every time a new program has to be
>> > added.
>> >
>> > Imagine there there are a few containers and every container wants to
>> > run an application that attaches XDP program to the "dispatcher" via
>> > freplace. Every application may have a "priority" reserved for it, but
>> > recreating the dispatcher may have race condition, for example:
>>=20
>> Yeah, I did realise this is potentially racy, but so is any loading of
>> XDP programs right now (i.e., two applications can both try loading a
>> single XDP program at the same time, and end up stomping on each others'
>> feet). So we'll need to solve that in any case. I've managed to come up
>> with two possible ways to solve this:
>>=20
>> 1. Locking: Make it possible for a process to temporarily lock the
>> XDP program loaded onto an interface so no other program can modify it
>> until the lock is released.
>>=20
>> 2. A cmpxchg operation: Add a new field to the XDP load netlink message
>> containing an fd of the old program that the load call is expecting to
>> replace. I.e., instead of attach(ifindex, prog_fd, flags), you have
>> attach(ifindex, prog_fd, old_fd, flags). The kernel can then check that
>> the old_fd matches the program currently loaded before replacing
>> anything, and reject the operation otherwise.
>>=20
>> With either of these mechanisms it should be possible for userspace to
>> do the right thing if the kernel state changes underneath it. I'm
>> leaning towards (2) because I think it is simpler to implement and
>> doesn't require any new state be kept in the kernel.
>
> Yep, that will solve the race.
>
> (2) sounds good to me, in fact I did similar thing for cgroup-bpf in:
>
> 7dd68b3279f1 ("bpf: Support replacing cgroup-bpf program in MULTI mode")
>
> where user can pass replace_bpf_fd and BPF_F_REPLACE flag and it
> guarantees that the program, users wants, will be replaced, not a new
> program that was attached by somebody else just a moment ago.

Yes, that was exactly the API I had in mind for XDP as well. Awesome!

>> The drawback is
>> that it may lead to a lot of retries if many processes are trying to
>> load their programs at the same time. Some data would be good here: How
>> often do you expect programs to be loaded/unloaded in your use case?
>
>
> In the case I mentioned it's more about having multiple applications
> that may start/restart at the same time, not about frequency. It'll be a
> few (one digit number) apps, what means having a few retries should be
> fine if "the old program doesn't exist" can be detected easily (e.g.
> ENOENT should work) not to do retry for errors that are obviously
> unrelated to the race condition.

OK, great, let's go with that, then.

>> As for your other suggestion:
>>=20
>> > Also I see at least one other way to do it w/o regenerating dispatcher
>> > every time:
>> >
>> > It can be created and attached once with "big enough" number of slots,
>> > for example with 100 and programs may use use their corresponding slot
>> > to freplace w/o regenerating the dispatcher. Having those big number of
>> > no-op slots should not be a big deal from what I understand and kernel
>> > can optimize it.
>>=20
>> I thought about having the dispatcher stay around for longer, and just
>> replacing more function slots as new programs are added/removed. The
>> reason I didn't go with this is the following: Modifying the dispatcher
>> while it is loaded means that the modifications will apply to traffic on
>> the interface immediately. This is fine for simple add/remove of a
>> single program, but it limits which operations you can do atomically.
>> E.g., you can't switch the order of two programs, or add or remove more
>> than one, in a way that is atomic from the PoV of the traffic on the
>> interface.
>
> Right, simple add/remove cases is the only ones I've seen so far since
> programs are usually more or less independent and they just should be
> chained properly w/o anything like "order of programs should be changed
> atomically" or "two programs must be enabled atomically".
>
> But okay, I can imagine that this may happen in the wild. In this case
> yes, full regeneration of the dispatcher looks like the option ..

Yes, my thought exactly :)

>> Since I expect that we will need to support atomic operations even for
>> these more complex cases, that means we'll need to support rebuilding
>> the dispatcher anyway, and solving the race condition problem for that.
>> And once we've done that, the simple add/remove in the existing
>> dispatcher becomes just an additional code path that we'll need to
>> maintain, so why bother? :)
>>=20
>> I am also not sure it's as simple as you say for the kernel to optimise
>> a more complex dispatcher: The current dead code elimination relies on
>> map data being frozen at verification time, so it's not applicable to
>> optimising a dispatcher as it is being changed later. Now, this could
>> probably be fixed and/or we could try doing clever tricks with the flow
>> control in the dispatcher program itself. But again, why bother if we
>> have to support the dispatcher rebuild mode of operation anyway?
>
> Yeah, having the ability to regenerate the full dispatcher helps to
> avoid dealing with those no-ops programs.
>
> This kinda solves another problem of allocating positions in the list of
> noop_fun1, noop_func2, ..., noop_funcN, since the N is limited and
> keeping "enough space" between existing programs to be able to attach
> something else between them in the future can be challenging in general
> case.

Yeah, it strikes me as one of those things that works fine for simple
cases and then breaks down badly once you hit the limit (i.e, run out of
free slots).

>> I may have missed something, of course, so feel free to point out if you
>> see anything wrong with my reasoning above!
>>=20
>> > This is the main thing so far, I'll likely provide more feedback when
>> > have some more time to read the code ..
>>=20
>> Sounds good! You're already being very helpful, so thank you! :)
>
> I've spent more time reading the library and like the static global data
> idea that allows to "regenerate" dispatcher w/o actually recompiling it
> so that it can still be compiled once and distributed to all relevant
> hosts.  It simplifies a bunch of things discussed above.

Yup, I was quite happy when I discovered this could be done with a
pre-compiled program + dead code elimination; makes things so much
easier! So glad you agree, and thank you for taking a look!

> But this part in the "missing pieces":
>
>> > - There is no way to re-attach an already loaded program to another fu=
nction;
>> >   this is needed for updating the call sequence: When a new program is=
 loaded,
>> >   libxdp should get the existing list of component programs on the int=
erface and
>> >   insert the new one into the chain in the appropriate place. To do th=
is it
>> >   needs to build a new dispatcher and reattach all the old programs to=
 it.
>> >   Ideally, this should be doable without detaching them from the old d=
ispatcher;
>> >   that way, we can build the new dispatcher completely, and atomically=
 replace
>> >   it on the interface by the usual XDP attach mechanism.
>
> seems to be "must-have", including the "Ideally" section, since IMO
> simply adding a new program should not interrupt what previously
> attached programs are doing.
>
> If there is a container A that attached progA to dispatcher some time
> ago, and then container B is regenerating dispatcher to add progB, that
> shouldn't stop progA from being executed even for short period of time
> since for some programs it's just no-go (e.g. if progA is a firewall and
> disabling it would mean allowing traffic that otherwise is denied).

Yeah, you're right, I was probably being a bit too timid when I said
"ideally"; this is really something we should support.

> I'm not the one who can answer the question how hard would it be to
> support this kind of "re-attaching" on kernel side and curios myself. I
> do see though that current implementation of ext programs has a single
> (prog->aux->linked_prog, prog->aux->attach_btf_id) pair.

No, it doesn't work with the way things are set up currently; but with a
bit of refactoring I believe it can be made to work. I'll give it a
shot, and we'll see if I'm right...

> Also it's not clear what to do with fd returned by
> bpf_tracing_prog_attach (whether it can be pined or not), e.g. if
> container A generated dispatcher with ext progA attached to it and got
> this "link" fd, but then dispatcher was regenerated and the progA was
> reattached to the new dispatcher, how to make sure that the "link" fd is
> still the right one and cleanup will happen when a process in container
> A closes the fd it has (or unpins corresponding file in bpf fs).

This is the reason why I think the 'link' between the main program and
the replacement program is in the "wrong direction". Instead I want to
introduce a new attachment API that can be used instead of
bpf_raw_tracepoint_open() - something like:

prog_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // dispatcher
func_fd =3D sys_bpf(BPF_PROG_LOAD, ...); // replacement func
err =3D sys_bpf(BPF_PROG_REPLACE_FUNC, prog_fd, btf_id, func_fd); // does *=
not* return an fd

When using this, the kernel will flip the direction of the reference
between BPF programs, so it goes main_prog -> replacement_prog. And
instead of getting an fd back, this will make the replacement prog share
its lifecycle with the main program, so that when the main program is
released, so is the replacement (absent other references, of course).
There could be an explicit 'release' command as well, of course, and a
way to list all replacements on a program.

I think that making replacement progs 'fate-share' with the main prog
this way will make for a more natural API. In fact, I don't think it's
possible to atomically keep things consistent if we have to rely on
pinning; see [0] for my brain dump on this over on Andrii's bpf_link
patch series thread.

-Toke

[0] https://lore.kernel.org/bpf/87imjms8cm.fsf@toke.dk/

