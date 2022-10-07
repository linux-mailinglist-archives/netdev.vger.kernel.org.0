Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CB35F79B5
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiJGOdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 10:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiJGOdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 10:33:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3891204FB
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 07:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665153185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dpyGKzQ4djygt/FjTKUqOv/R5LP+sgmTctNH9D/8PMw=;
        b=TI23yowpztoTqmNovf2ozGo4LIgeeL/95zoqXLCRpdWV1CeR6tJzjA92A790wEkcYsOgaN
        ePNuko6XtpipycKMRf27COjxIFjmpcmg3uEbojm8wMBHaWumoTyBVS+P7CN7aBkC06nDje
        kvFE2+pCbpeYx/Qju2zeGrZKCk5V9to=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-530-oTxMxcUIM_2W0aPWHfPWvg-1; Fri, 07 Oct 2022 10:33:01 -0400
X-MC-Unique: oTxMxcUIM_2W0aPWHfPWvg-1
Received: by mail-ed1-f70.google.com with SMTP id m10-20020a056402430a00b0045968bb0874so4008602edc.10
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 07:33:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dpyGKzQ4djygt/FjTKUqOv/R5LP+sgmTctNH9D/8PMw=;
        b=d8302XIfW7RLbi0vHBdjnuC/EY056kgbgTVqKmIF5SJHbN4y8Un8ZRnlHf4EgvsMd8
         Fycek+DcvwnLP+zfy9fwUJvkX0tbUe57kIEcmZJ9X+YCW7v8SW65u5QZXxivbM1UtibU
         m7rVYFvqNSUSjC4eTiMkboZwomcCHOvQ61UhmZCFhuY0cHUNF6qQGCuOItz5tuVtSu3Q
         +RMGyrdmvVPP0c6Z/gqeIXfNrLiJRj7bHAVD1Cdn0yILnhb+AmN2rdEeqNqKwIqJLg47
         00gK8w5D30j4JSwgsAw3zdUTUne2gvEoTFpOgN8fIyS7DtlKTenP/58wI/JQ3/hjw6Rz
         Dw2Q==
X-Gm-Message-State: ACrzQf0xFoPWhn4GloCd17dWgsdlNcI3YW6SI6wmihFKXri1aAyOHEtf
        FWnUQPZ5TyawERYtrZPL0arUhYHFI8hBS1LNDk1hzXnjuTmjWsabzxYi1RZ6h7BngrjZeL52gNa
        SgwlGHZV+S3VdqBFR
X-Received: by 2002:a17:907:7248:b0:78d:1cb2:41ac with SMTP id ds8-20020a170907724800b0078d1cb241acmr4402150ejc.283.1665153179986;
        Fri, 07 Oct 2022 07:32:59 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5sYqCI1WEbWgvHHis0dtP8PDmohalHqLdU03dvkS/1uKY2UTYZRGAkj1JoJCietc85Z/nQ6g==
X-Received: by 2002:a17:907:7248:b0:78d:1cb2:41ac with SMTP id ds8-20020a170907724800b0078d1cb241acmr4402119ejc.283.1665153179561;
        Fri, 07 Oct 2022 07:32:59 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id g25-20020a170906539900b0078d3be14d4bsm1368990ejo.11.2022.10.07.07.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 07:32:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 067FF64EEEE; Fri,  7 Oct 2022 16:32:57 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
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
In-Reply-To: <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net>
 <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Oct 2022 16:32:57 +0200
Message-ID: <875ygvemau.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 10/7/22 1:28 AM, Alexei Starovoitov wrote:
>> On Thu, Oct 6, 2022 at 2:29 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 10/6/22 7:00 AM, Alexei Starovoitov wrote:
>>>> On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
>>> [...]
>>>>
>>>> I cannot help but feel that prio logic copy-paste from old tc, netfilter and friends
>>>> is done because "that's how things were done in the past".
>>>> imo it was a well intentioned mistake and all networking things (tc, netfilter, etc)
>>>> copy-pasted that cumbersome and hard to use concept.
>>>> Let's throw away that baggage?
>>>> In good set of cases the bpf prog inserter cares whether the prog is first or not.
>>>> Since the first prog returning anything but TC_NEXT will be final.
>>>> I think prog insertion flags: 'I want to run first' vs 'I don't care about order'
>>>> is good enough in practice. Any complex scheme should probably be programmable
>>>> as any policy should. For example in Meta we have 'xdp chainer' logic that is similar
>>>> to libxdp chaining, but we added a feature that allows a prog to jump over another
>>>> prog and continue the chain. Priority concept cannot express that.
>>>> Since we'd have to add some "policy program" anyway for use cases like this
>>>> let's keep things as simple as possible?
>>>> Then maybe we can adopt this "as-simple-as-possible" to XDP hooks ?
>>>> And allow bpf progs chaining in the kernel with "run_me_first" vs "run_me_anywhere"
>>>> in both tcx and xdp ?
>>>> Naturally "run_me_first" prog will be the only one. No need for F_REPLACE flags, etc.
>>>> The owner of "run_me_first" will update its prog through bpf_link_update.
>>>> "run_me_anywhere" will add to the end of the chain.
>>>> In XDP for compatibility reasons "run_me_first" will be the default.
>>>> Since only one prog can be enqueued with such flag it will match existing single prog behavior.
>>>> Well behaving progs will use (like xdp-tcpdump or monitoring progs) will use "run_me_anywhere".
>>>> I know it's far from covering plenty of cases that we've discussed for long time,
>>>> but prio concept isn't really covering them either.
>>>> We've struggled enough with single xdp prog, so certainly not advocating for that.
>>>> Another alternative is to do: "queue_at_head" vs "queue_at_tail". Just as simple.
>>>> Both simple versions have their pros and cons and don't cover everything,
>>>> but imo both are better than prio.
>>>
>>> Yeah, it's kind of tricky, imho. The 'run_me_first' vs 'run_me_anywhere' are two
>>> use cases that should be covered (and actually we kind of do this in this set, too,
>>> with the prios via prio=x vs prio=0). Given users will only be consuming the APIs
>>> via libs like libbpf, this can also be abstracted this way w/o users having to be
>>> aware of prios.
>> 
>> but the patchset tells different story.
>> Prio gets exposed everywhere in uapi all the way to bpftool
>> when it's right there for users to understand.
>> And that's the main problem with it.
>> The user don't want to and don't need to be aware of it,
>> but uapi forces them to pick the priority.
>> 
>>> Anyway, where it gets tricky would be when things depend on ordering,
>>> e.g. you have BPF progs doing: policy, monitoring, lb, monitoring, encryption, which
>>> would be sth you can build today via tc BPF: so policy one acts as a prefilter for
>>> various cidr ranges that should be blocked no matter what, then monitoring to sample
>>> what goes into the lb, then lb itself which does snat/dnat, then monitoring to see what
>>> the corresponding pkt looks that goes to backend, and maybe encryption to e.g. send
>>> the result to wireguard dev, so it's encrypted from lb node to backend.
>> 
>> That's all theory. Your cover letter example proves that in
>> real life different service pick the same priority.
>> They simply don't know any better.
>> prio is an unnecessary magic that apps _have_ to pick,
>> so they just copy-paste and everyone ends up using the same.
>> 
>>> For such
>>> example, you'd need prios as the 'run_me_anywhere' doesn't guarantee order, so there's
>>> a case for both scenarios (concrete layout vs loose one), and for latter we could
>>> start off with and internal prio around x (e.g. 16k), so there's room to attach in
>>> front via fixed prio, but also append to end for 'don't care', and that could be
>>> from lib pov the default/main API whereas prio would be some kind of extended one.
>>> Thoughts?
>> 
>> If prio was not part of uapi, like kernel internal somehow,
>> and there was a user space daemon, systemd, or another bpf prog,
>> module, whatever that users would interface to then
>> the proposed implementation of prio would totally make sense.
>> prio as uapi is not that.
>
> A good analogy to this issue might be systemd's unit files.. you specify dependencies
> for your own <unit> file via 'Wants=<unitA>', and ordering via 'Before=<unitB>' and
> 'After=<unitC>' and they refer to other unit files. I think that is generally okay,
> you don't deal with prio numbers, but rather some kind textual representation. However
> user/operator will have to deal with dependencies/ordering one way or another, the
> problem here is that we deal with kernel and loader talks to kernel directly so it
> has no awareness of what else is running or could be running, so apps needs to deal
> with it somehow (and it cannot without external help).

I was thinking a little about how this might work; i.e., how can the
kernel expose the required knobs to allow a system policy to be
implemented without program loading having to talk to anything other
than the syscall API?

How about we only expose prepend/append in the prog attach UAPI, and
then have a kernel function that does the sorting like:

int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, struct bpf_prog *new_prog, bool append)

where the default implementation just appends/prepends to the array in
progs depending on the value of 'appen'.

And then use the __weak linking trick (or maybe struct_ops with a member
for TXC, another for XDP, etc?) to allow BPF to override the function
wholesale and implement whatever ordering it wants? I.e., allow it can
to just shift around the order of progs in the 'progs' array whenever a
program is loaded/unloaded?

This way, a userspace daemon can implement any policy it wants by just
attaching to that hook, and keeping things like how to express
dependencies as a userspace concern?

-Toke

