Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD64FCA1A
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfKNPlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:41:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29906 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726474AbfKNPlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:41:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573746066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TsUJgGUVpXmofLpPKpc4ZZrOh9LKGy0txkuAyysjhio=;
        b=S0/6f0Y1yZYRSU6BqHmXzYY9uTLU1YWNGJpnMHLWZvEjIaYbcNlkeEBuQp95AkyznStD5K
        sLINAiK4h+NY8diCxeEjse5YN12mZDRwaEW4TTxraFozUqIAn0HW0GVbu/zAbYbpHAtUxP
        B9Ut9FvBDWK+vcpA/5FUf2BDh1Kpxzk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-Px9Q31ioPlW78js8xCc2nA-1; Thu, 14 Nov 2019 10:41:05 -0500
Received: by mail-lf1-f70.google.com with SMTP id y188so2080522lfc.6
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:41:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GLlkNjP2tY8QkKUF/OUq6PPbMjkE8ofUEdh3FKzNTPE=;
        b=HTuUww7GubLMKRL+JvlXHaQSBFuMAFyHUWQ4Aq6qtP97MrrSE6sS3fVR21TKq8Pgai
         6pHtYhrBMSsZNXdHIksNjn9CCnHdp2GPNe8dlfofUYLxtEH0EgVYffk9OgI6W+1S9Nh7
         64oztT1FpjrmDixH/ddUDo8LTfK/NSmUDEsOaauvckFll083lHcGB07FD1qgGVvXKwMo
         q2DK3gjUkG13EYwmOr6KnpAlE5wPwKkpt6cDS8CCeGvQ8zgXNMPkI14lXBzqicfhvh6X
         nk1yQKKDFtOyAKB194xGDWWUc0NWTakcwUeeAvJlxnO7aSO3au/AKvqacGpJhUd/3hVm
         7CNQ==
X-Gm-Message-State: APjAAAUYiR3VuV0fgPrCL476N5Fu0eYUr/HayW0O48LeMhpQY7EDCTFo
        GVbjVJXBZfIf6UWQ1HslpNUvCK0JVml8Eb2K4WE77P1r0KCeO0PwirwlJAnLh5Se7UXq8pwfFeX
        H869xfzJoZKKDDjD8
X-Received: by 2002:a19:6d12:: with SMTP id i18mr7332764lfc.153.1573746063791;
        Thu, 14 Nov 2019 07:41:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqw7DlklcocOm5Bieb8jiL3ND9ar6KSd0KbOYO2zf8WREILKU6HiWQQTMUYBqv+4ssIvPPyCTQ==
X-Received: by 2002:a19:6d12:: with SMTP id i18mr7332736lfc.153.1573746063358;
        Thu, 14 Nov 2019 07:41:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id g14sm2885065lfj.17.2019.11.14.07.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:41:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B4D781803C7; Thu, 14 Nov 2019 16:41:01 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf: Support chain calling multiple BPF
In-Reply-To: <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
References: <5da4ab712043c_25f42addb7c085b83b@john-XPS-13-9370.notmuch> <87eezfi2og.fsf@toke.dk> <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com> <87r23egdua.fsf@toke.dk> <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com> <874l07fu61.fsf@toke.dk> <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com> <87eez4odqp.fsf@toke.dk> <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com> <87h839oymg.fsf@toke.dk> <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Nov 2019 16:41:01 +0100
Message-ID: <87y2wimpo2.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: Px9Q31ioPlW78js8xCc2nA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

[...]

> Back to your question of how fw2 will get loaded.. I'm thinking the follo=
wing:
> 1. Static linking:
>   obj =3D bpf_object__open("rootlet.o", "fw1.o", "fw2.o");
>   // libbpf adjusts call offsets and links into single loadable bpf_objec=
t
>   bpf_object__load(obj);
>   bpf_set_link_xdp_fd()
> No kernel changes are necessary to support program chaining via static li=
nking.
>
> 2. Dynamic linking:
>   // assuming libxdp.so manages eth0
>   rootlet_fd =3D get_xdp_fd(eth0);
>   subprog_btf_id =3D libbpf_find_prog_btf_id("name_of_placeholder", roole=
t_fd);
>   //                  ^ this function is in patch 16/18 of trampoline
>   attr.attach_prog_fd =3D roolet_fd;
>   attr.attach_btf_id =3D subprog_btf_id;
>   // pair (prog_fd, btf_id) needs to be specified at load time
>   obj =3D bpf_object__open("fw2.o", attr);
>   bpf_object__load(obj);
>   prog =3D bpf_object__find_program_by_title(obj);
>   link =3D bpf_program__replace(prog); // similar to bpf_program__attach_=
trace()
>   // no extra arguments during 'replace'.
>   // Target (prog_fd, btf_id) already known to the kernel and verified

OK, this makes sense.

>> So the two component programs would still exist as kernel objects,
>> right?=20
>
> yes. Both fw1.o and fw2.o will be loaded and running instead of placehold=
ers.
>
>> And the trampolines would keep individual stats for each one (if
>> BPF stats are enabled)?=20
>
> In case of dynamic linking both fw1.o and fw2.o will be seen as individua=
l
> programs from 'bpftool p s' point of view. And both will have
> individual stats.

Right, this is important, and I think it's where my skepticism about
static linking comes from. With static linking, each XDP program will be
"reduced" to a subprog instead of a full stand-alone program. Which
means that its execution will be different depending on whether it is
just attached directly to an interface, or if it's been linked with a
rootlet before loading.

I'll admit I don't know enough about how subprograms actually work to
know if it's a *meaningful* difference, so I guess I'll go play around
with it. If nothing else, experimenting with static linking can be a way
to hash out the semantics until dynamic linking lands.

>> Could userspace also extract the prog IDs being
>> referenced by the "glue" proglet?=20
>
> Not sure I follow. Both fw1.o and fw2.o will have their own prog ids.
> fw1_prog->aux->linked_prog =3D=3D rootlet_prog
> fw2_prog->aux->linked_prog =3D=3D rootlet_prog
> Unloading and detaching fw1.o will make kernel to switch back to placehol=
der
> subprog in roolet_prog. I believe roolet_prog should not keep a list of p=
rogs
> that attached to it (or replaced its subprogs) to avoid circular
> dependency.

Well I did mean the link in the other direction. But thinking about it
some more, I don't think it really matters. The important bit is that
userspace can answer the question "given that rootlet ID X is currently
attached on eth0, which two program IDs Y and Z will actually run on
that interface?". And if there's a link in the other direction, it could
just iterate over all loaded programs in the kernel to find them, so
that is OK; as long as we can also tell in which "slot" in the rootlet a
given program is currently attached.

> Due to that detaching roolet_prog from netdev will stop the flow of
> packets into fw1.o, but refcnt of rootlet_prog will not go to zero, so
> it will stay in memory until both fw1.o and fw2.o detach from
> rootlet.o.

OK, that is probably fine. I think we should teach most utilities to
deal with this anyway; in particular, iproute2 should know about
multi-progs (i.e., link against libxdp).

>> What about attaching a third program? Would that work by recursion (as
>> above, but with the old proglet as old_fd), or should the library build
>> a whole new sequence from the component programs?
>
> This choice is up to libxdp.so. It can have a number of placeholders
> ready to be replaced by new progs. Or it can re-generate rootlet.o
> every time new fwX.o comes along. Short term I would start development
> with auto-generated roolet.o and static linking done by libbpf
> while the policy and roolet are done by libxdp.so, since this work
> doesn't depend on any kernel changes. Long term auto-generation
> can stay in libxdp.so if it turns out to be sufficient.

Yes, as I said above this sounds like at least it's a start.

>> Finally, what happens if someone where to try to attach a retprobe to
>> one of the component programs? Could it be possible to do that even
>> while program is being run from proglet dispatch? That way we can still
>> debug an individual XDP program even though it's run as part of a chain.
>
> Right. The fentry/fexit tracing is orthogonal to static/dynamic linking.
> It will be available for all prog types after trampoline patches land.
> See fexit_bpf2bpf.c example in the last 18/18 patch.
> We will be able to debug XDP program regardless whether it's a rootlet
> or a subprogram. Doesn't matter whether linking was static or dynamic.

OK, that's great, and certainly resolved one point of skepticism :)

> With fentry/fexit we will be able to do different stats too.
> Right now bpf program stats are limited to cycles and I resisted a lot
> of pressure to add more hard coded stats. With fentry/fexit we can
> collect arbitrary counters per program. Like number of L1-cache misses
> or number of TLB misses in a given XDP prog.

Yeah, that makes a lot of sense, of course. Great!

>> Sounds reasonable. Any reason libxdp.so couldn't be part of libbpf?
>
> libxdp.so is a policy specifier while libbpf is a tool. It makes more
> sense for them to be separate. libbpf has strong api compatibility
> guarantees. While I don't think anyone knows at this point how libxdp
> api should look and it will take some time for it to mature.

Well, we'd want libxdp to have the same strong API guarantees,
eventually. Which would be a reason to just include it in libbpf. But
sure, I wasn't suggesting to do this from the get-go; we can start out
with something separate and decide later when/if it makes sense to
integrate. As long as libbpf can do the heavy lifting on the actual
linking that is fine with me.

-Toke

