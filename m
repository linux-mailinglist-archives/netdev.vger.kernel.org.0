Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784A75F7C29
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 19:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJGRU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 13:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJGRUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 13:20:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ECBC8223
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 10:20:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665163253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8/cc3rA0x7qRcg5j7SUr5NIuevAztPGZBNjEBn3naY=;
        b=YZIbkvuuAaflXpt+AromgM3FX1lBb/7vU1GwKHM9YyMVaIlgMhvXt5oCAYvwvsmZ4evDiy
        N/uwYD4/wlzN3yFimITlQLC4Us99OS7Hge9TZIA2spY2rTYfKp0VHjA3QKqYdyfx+E9Snl
        Wk30gUf++hAZmHpFBxMxVtMJOoPOeAI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-216-1NbFHKwZOqGBICrTaccRRQ-1; Fri, 07 Oct 2022 13:20:47 -0400
X-MC-Unique: 1NbFHKwZOqGBICrTaccRRQ-1
Received: by mail-ed1-f71.google.com with SMTP id dz21-20020a0564021d5500b004599f697666so4302001edb.18
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 10:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e8/cc3rA0x7qRcg5j7SUr5NIuevAztPGZBNjEBn3naY=;
        b=kKAaA1yCsW2FDgirns35JrT2z6CYfjPH3vGcyiSpjUSh+r6HMmb02AlnzD6ioFJOZe
         ZJl8SpXwsnXXzAtUINszWr3kftA6UXAf3EY2xLQJxMGGhklPOLSFrB4Br6gIkvq8f7D5
         JflmnbAmHVOkG14aeAkVALljJHCtAI3294Ogw+B5lkop6rdAM/PlgJmXZyFnOP38haMX
         z+nrxd03zhmFSoQ+9N9wmHpDg5oQWP8CXgzEksQ/2QTCyS9Veja63vCA/eZyIqz5EFRn
         17Z39RuYkFmnBxNpQqm93Y8JQqVlCLieToFRyQeIXtSyrYhClAZnd7lIKkNP/K01yVGq
         lvtQ==
X-Gm-Message-State: ACrzQf0q2VzIDSSElH782mz7BEVnsyql71I+BZOiBTAQO0LFhxceSUsQ
        hlWy5URI51M9b6Wthu9ISjqwmRKlc2xGAeby9lOvPVp2SjdnxE7Ijdy8ibn37bRvQ2F8Y4KPpnI
        OUpcAsuT3JYGE92Ha
X-Received: by 2002:aa7:c956:0:b0:43b:206d:c283 with SMTP id h22-20020aa7c956000000b0043b206dc283mr5478817edt.381.1665163244098;
        Fri, 07 Oct 2022 10:20:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4DHf7zqccBgUo5jcwC5NhJfg0rUqOGAnV5SmPRzvLCg8EvG4sRaprT7t6k+hX/RytvDliRlQ==
X-Received: by 2002:aa7:c956:0:b0:43b:206d:c283 with SMTP id h22-20020aa7c956000000b0043b206dc283mr5478645edt.381.1665163241576;
        Fri, 07 Oct 2022 10:20:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v29-20020a50d09d000000b004580296bb0bsm1831561edd.83.2022.10.07.10.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 10:20:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 29FE064EF1A; Fri,  7 Oct 2022 19:20:40 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     sdf@google.com
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Joe Stringer <joe@cilium.io>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach
 tc BPF programs
In-Reply-To: <Y0BaBUWeTj18V5Xp@google.com>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net>
 <875ygvemau.fsf@toke.dk> <Y0BaBUWeTj18V5Xp@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Oct 2022 19:20:40 +0200
Message-ID: <87tu4fczyv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sdf@google.com writes:

> On 10/07, Toke H=EF=BF=BDiland-J=EF=BF=BDrgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>
>> > On 10/7/22 1:28 AM, Alexei Starovoitov wrote:
>> >> On Thu, Oct 6, 2022 at 2:29 PM Daniel Borkmann <daniel@iogearbox.net>=
=20=20
>> wrote:
>> >>> On 10/6/22 7:00 AM, Alexei Starovoitov wrote:
>> >>>> On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
>> >>> [...]
>> >>>>
>> >>>> I cannot help but feel that prio logic copy-paste from old tc,=20=20
>> netfilter and friends
>> >>>> is done because "that's how things were done in the past".
>> >>>> imo it was a well intentioned mistake and all networking things (tc=
,=20=20
>> netfilter, etc)
>> >>>> copy-pasted that cumbersome and hard to use concept.
>> >>>> Let's throw away that baggage?
>> >>>> In good set of cases the bpf prog inserter cares whether the prog i=
s=20=20
>> first or not.
>> >>>> Since the first prog returning anything but TC_NEXT will be final.
>> >>>> I think prog insertion flags: 'I want to run first' vs 'I don't car=
e=20=20
>> about order'
>> >>>> is good enough in practice. Any complex scheme should probably be=
=20=20
>> programmable
>> >>>> as any policy should. For example in Meta we have 'xdp chainer'=20=
=20
>> logic that is similar
>> >>>> to libxdp chaining, but we added a feature that allows a prog to=20=
=20
>> jump over another
>> >>>> prog and continue the chain. Priority concept cannot express that.
>> >>>> Since we'd have to add some "policy program" anyway for use cases=
=20=20
>> like this
>> >>>> let's keep things as simple as possible?
>> >>>> Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
>> >>>> And allow bpf progs chaining in the kernel with "run_me_first"=20=20
>> vs "run_me_anywhere"
>> >>>> in both tcx and xdp ?
>> >>>> Naturally "run_me_first" prog will be the only one. No need for=20=
=20
>> F_REPLACE flags, etc.
>> >>>> The owner of "run_me_first" will update its prog through=20=20
>> bpf_link_update.
>> >>>> "run_me_anywhere" will add to the end of the chain.
>> >>>> In XDP for compatibility reasons "run_me_first" will be the default.
>> >>>> Since only one prog can be enqueued with such flag it will match=20=
=20
>> existing single prog behavior.
>> >>>> Well behaving progs will use (like xdp-tcpdump or monitoring progs)=
=20=20
>> will use "run_me_anywhere".
>> >>>> I know it's far from covering plenty of cases that we've discussed=
=20=20
>> for long time,
>> >>>> but prio concept isn't really covering them either.
>> >>>> We've struggled enough with single xdp prog, so certainly not=20=20
>> advocating for that.
>> >>>> Another alternative is to do: "queue_at_head" vs "queue_at_tail".=
=20=20
>> Just as simple.
>> >>>> Both simple versions have their pros and cons and don't cover=20=20
>> everything,
>> >>>> but imo both are better than prio.
>> >>>
>> >>> Yeah, it's kind of tricky, imho. The 'run_me_first'=20=20
>> vs 'run_me_anywhere' are two
>> >>> use cases that should be covered (and actually we kind of do this in=
=20=20
>> this set, too,
>> >>> with the prios via prio=3Dx vs prio=3D0). Given users will only be=
=20=20
>> consuming the APIs
>> >>> via libs like libbpf, this can also be abstracted this way w/o users=
=20=20
>> having to be
>> >>> aware of prios.
>> >>
>> >> but the patchset tells different story.
>> >> Prio gets exposed everywhere in uapi all the way to bpftool
>> >> when it's right there for users to understand.
>> >> And that's the main problem with it.
>> >> The user don't want to and don't need to be aware of it,
>> >> but uapi forces them to pick the priority.
>> >>
>> >>> Anyway, where it gets tricky would be when things depend on ordering,
>> >>> e.g. you have BPF progs doing: policy, monitoring, lb, monitoring,=
=20=20
>> encryption, which
>> >>> would be sth you can build today via tc BPF: so policy one acts as a=
=20=20
>> prefilter for
>> >>> various cidr ranges that should be blocked no matter what, then=20=20
>> monitoring to sample
>> >>> what goes into the lb, then lb itself which does snat/dnat, then=20=
=20
>> monitoring to see what
>> >>> the corresponding pkt looks that goes to backend, and maybe=20=20
>> encryption to e.g. send
>> >>> the result to wireguard dev, so it's encrypted from lb node to=20=20
>> backend.
>> >>
>> >> That's all theory. Your cover letter example proves that in
>> >> real life different service pick the same priority.
>> >> They simply don't know any better.
>> >> prio is an unnecessary magic that apps _have_ to pick,
>> >> so they just copy-paste and everyone ends up using the same.
>> >>
>> >>> For such
>> >>> example, you'd need prios as the 'run_me_anywhere' doesn't guarantee=
=20=20
>> order, so there's
>> >>> a case for both scenarios (concrete layout vs loose one), and for=20=
=20
>> latter we could
>> >>> start off with and internal prio around x (e.g. 16k), so there's roo=
m=20=20
>> to attach in
>> >>> front via fixed prio, but also append to end for 'don't care', and=
=20=20
>> that could be
>> >>> from lib pov the default/main API whereas prio would be some kind of=
=20=20
>> extended one.
>> >>> Thoughts?
>> >>
>> >> If prio was not part of uapi, like kernel internal somehow,
>> >> and there was a user space daemon, systemd, or another bpf prog,
>> >> module, whatever that users would interface to then
>> >> the proposed implementation of prio would totally make sense.
>> >> prio as uapi is not that.
>> >
>> > A good analogy to this issue might be systemd's unit files.. you=20=20
>> specify dependencies
>> > for your own <unit> file via 'Wants=3D<unitA>', and ordering=20=20
>> via 'Before=3D<unitB>' and
>> > 'After=3D<unitC>' and they refer to other unit files. I think that is=
=20=20
>> generally okay,
>> > you don't deal with prio numbers, but rather some kind textual=20=20
>> representation. However
>> > user/operator will have to deal with dependencies/ordering one way or=
=20=20
>> another, the
>> > problem here is that we deal with kernel and loader talks to kernel=20=
=20
>> directly so it
>> > has no awareness of what else is running or could be running, so apps=
=20=20
>> needs to deal
>> > with it somehow (and it cannot without external help).
>
>> I was thinking a little about how this might work; i.e., how can the
>> kernel expose the required knobs to allow a system policy to be
>> implemented without program loading having to talk to anything other
>> than the syscall API?
>
>> How about we only expose prepend/append in the prog attach UAPI, and
>> then have a kernel function that does the sorting like:
>
>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, struc=
t=20=20
>> bpf_prog *new_prog, bool append)
>
>> where the default implementation just appends/prepends to the array in
>> progs depending on the value of 'appen'.
>
>> And then use the __weak linking trick (or maybe struct_ops with a member
>> for TXC, another for XDP, etc?) to allow BPF to override the function
>> wholesale and implement whatever ordering it wants? I.e., allow it can
>> to just shift around the order of progs in the 'progs' array whenever a
>> program is loaded/unloaded?
>
>> This way, a userspace daemon can implement any policy it wants by just
>> attaching to that hook, and keeping things like how to express
>> dependencies as a userspace concern?
>
> What if we do the above, but instead of simple global 'attach first/last',
> the default api would be:
>
> - attach before <target_fd>
> - attach after <target_fd>
> - attach before target_fd=3D-1 =3D=3D first
> - attach after target_fd=3D-1 =3D=3D last
>
> ?

Hmm, the problem with that is that applications don't generally have an
fd to another application's BPF programs; and obtaining them from an ID
is a privileged operation (CAP_SYS_ADMIN). We could have it be "attach
before target *ID*" instead, which could work I guess? But then the
problem becomes that it's racy: the ID you're targeting could get
detached before you attach, so you'll need to be prepared to check that
and retry; and I'm almost certain that applications won't test for this,
so it'll just lead to hard-to-debug heisenbugs. Or am I being too
pessimistic here?

-Toke

