Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E825F7D96
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 21:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiJGTAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 15:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiJGTAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 15:00:12 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7995D45994;
        Fri,  7 Oct 2022 12:00:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s2so8305411edd.2;
        Fri, 07 Oct 2022 12:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zttRBgfr1n1gjSk5ZE8JViy+xaR2g3AlGmkJx/xKwlE=;
        b=IGoe2KBFOTMk+2As/7ocIGTewrmSuRa2gWRq7i2QL1u6q/q2yaM3N/XMOKhMRBSeoO
         S/DfF/GxfpUF/o/bodKOYo4JzF8IO6BWkN8jnih6FADn/L+oJYGQzYN3rd5hfEEYK6cU
         4xVqdgncUf7DtVfwOLbsdKTRwGeUyoGvR19YGd8cbfwNcyZOfWqJX4YNNSLYrK7U8+8t
         pW/jDFUL5ZVrVd+5atXMfYRpmc6LvAsLITm5RSNxOnL7RlCUkWJTNye/vbnP1i8IHDVl
         uuCC6voc5RnnuH61N/0jGrOnT02vN5vZC/2k8e0CxCTE2Mig5GJq1PVLXLqgt5C8VBr+
         jkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zttRBgfr1n1gjSk5ZE8JViy+xaR2g3AlGmkJx/xKwlE=;
        b=F0mFMKISTU/rCcUOKow6DjnLInEkLYkxBfUwU5nTwwUclzfXjieE7KCcXujLSFaeFO
         nUac1qVMCsDIQ1UXljiQgk4tmYmUoen4uJKXsEw1Rqfmfnuz6pSTO9KJeTfFj0K91Yad
         JfdLfA9pEz45OID2OPBtOQ+UUseuhvytCqiTido4auzslUnFxYWob1QmDOCQGWKKSVa3
         rj5b3Tvv+9syTHbfsV7YIU3QHw0DM2QPe+WXDxt8YNQtVl+8dJ8W3asLG1JSiFRBXK+5
         //APxHZWdxZWhUV6G9ntZsvsJQ1gbRbdzSF69yLqrgYXtSfVH4ED/b2lxAo6EUIxd3GV
         30KQ==
X-Gm-Message-State: ACrzQf3+Jb5FFxF3tNY1A2Mh3mJwEola5HA5op8Oe4eQrpjK8bNwCMco
        Dm8vuFWSmkaFlD0aGyBH4jvLRKQTNv4Kho6dbFw=
X-Google-Smtp-Source: AMsMyM4u+UXBm+WdVPDvTkTujFHi5bkXCRwmHF4FXwgUAqzRiTFLjfKrfePD7+BQ8lRncRul9lDQ7tV8u+O+8pJmedY=
X-Received: by 2002:a05:6402:3709:b0:459:279e:fdc6 with SMTP id
 ek9-20020a056402370900b00459279efdc6mr5974218edb.338.1665169207722; Fri, 07
 Oct 2022 12:00:07 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net> <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net> <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com> <87tu4fczyv.fsf@toke.dk>
In-Reply-To: <87tu4fczyv.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Oct 2022 11:59:55 -0700
Message-ID: <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 7, 2022 at 10:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> sdf@google.com writes:
>
> > On 10/07, Toke H=EF=BF=BDiland-J=EF=BF=BDrgensen wrote:
> >> Daniel Borkmann <daniel@iogearbox.net> writes:
> >
> >> > On 10/7/22 1:28 AM, Alexei Starovoitov wrote:
> >> >> On Thu, Oct 6, 2022 at 2:29 PM Daniel Borkmann <daniel@iogearbox.ne=
t>
> >> wrote:
> >> >>> On 10/6/22 7:00 AM, Alexei Starovoitov wrote:
> >> >>>> On Wed, Oct 05, 2022 at 01:11:34AM +0200, Daniel Borkmann wrote:
> >> >>> [...]
> >> >>>>
> >> >>>> I cannot help but feel that prio logic copy-paste from old tc,
> >> netfilter and friends
> >> >>>> is done because "that's how things were done in the past".
> >> >>>> imo it was a well intentioned mistake and all networking things (=
tc,
> >> netfilter, etc)
> >> >>>> copy-pasted that cumbersome and hard to use concept.
> >> >>>> Let's throw away that baggage?
> >> >>>> In good set of cases the bpf prog inserter cares whether the prog=
 is
> >> first or not.
> >> >>>> Since the first prog returning anything but TC_NEXT will be final=
.
> >> >>>> I think prog insertion flags: 'I want to run first' vs 'I don't c=
are
> >> about order'
> >> >>>> is good enough in practice. Any complex scheme should probably be
> >> programmable
> >> >>>> as any policy should. For example in Meta we have 'xdp chainer'
> >> logic that is similar
> >> >>>> to libxdp chaining, but we added a feature that allows a prog to
> >> jump over another
> >> >>>> prog and continue the chain. Priority concept cannot express that=
.
> >> >>>> Since we'd have to add some "policy program" anyway for use cases
> >> like this
> >> >>>> let's keep things as simple as possible?
> >> >>>> Then maybe we can adopt this "as-simple-as-possible" to XDP hooks=
 ?
> >> >>>> And allow bpf progs chaining in the kernel with "run_me_first"
> >> vs "run_me_anywhere"
> >> >>>> in both tcx and xdp ?
> >> >>>> Naturally "run_me_first" prog will be the only one. No need for
> >> F_REPLACE flags, etc.
> >> >>>> The owner of "run_me_first" will update its prog through
> >> bpf_link_update.
> >> >>>> "run_me_anywhere" will add to the end of the chain.
> >> >>>> In XDP for compatibility reasons "run_me_first" will be the defau=
lt.
> >> >>>> Since only one prog can be enqueued with such flag it will match
> >> existing single prog behavior.
> >> >>>> Well behaving progs will use (like xdp-tcpdump or monitoring prog=
s)
> >> will use "run_me_anywhere".
> >> >>>> I know it's far from covering plenty of cases that we've discusse=
d
> >> for long time,
> >> >>>> but prio concept isn't really covering them either.
> >> >>>> We've struggled enough with single xdp prog, so certainly not
> >> advocating for that.
> >> >>>> Another alternative is to do: "queue_at_head" vs "queue_at_tail".
> >> Just as simple.
> >> >>>> Both simple versions have their pros and cons and don't cover
> >> everything,
> >> >>>> but imo both are better than prio.
> >> >>>
> >> >>> Yeah, it's kind of tricky, imho. The 'run_me_first'
> >> vs 'run_me_anywhere' are two
> >> >>> use cases that should be covered (and actually we kind of do this =
in
> >> this set, too,
> >> >>> with the prios via prio=3Dx vs prio=3D0). Given users will only be
> >> consuming the APIs
> >> >>> via libs like libbpf, this can also be abstracted this way w/o use=
rs
> >> having to be
> >> >>> aware of prios.
> >> >>
> >> >> but the patchset tells different story.
> >> >> Prio gets exposed everywhere in uapi all the way to bpftool
> >> >> when it's right there for users to understand.
> >> >> And that's the main problem with it.
> >> >> The user don't want to and don't need to be aware of it,
> >> >> but uapi forces them to pick the priority.
> >> >>
> >> >>> Anyway, where it gets tricky would be when things depend on orderi=
ng,
> >> >>> e.g. you have BPF progs doing: policy, monitoring, lb, monitoring,
> >> encryption, which
> >> >>> would be sth you can build today via tc BPF: so policy one acts as=
 a
> >> prefilter for
> >> >>> various cidr ranges that should be blocked no matter what, then
> >> monitoring to sample
> >> >>> what goes into the lb, then lb itself which does snat/dnat, then
> >> monitoring to see what
> >> >>> the corresponding pkt looks that goes to backend, and maybe
> >> encryption to e.g. send
> >> >>> the result to wireguard dev, so it's encrypted from lb node to
> >> backend.
> >> >>
> >> >> That's all theory. Your cover letter example proves that in
> >> >> real life different service pick the same priority.
> >> >> They simply don't know any better.
> >> >> prio is an unnecessary magic that apps _have_ to pick,
> >> >> so they just copy-paste and everyone ends up using the same.
> >> >>
> >> >>> For such
> >> >>> example, you'd need prios as the 'run_me_anywhere' doesn't guarant=
ee
> >> order, so there's
> >> >>> a case for both scenarios (concrete layout vs loose one), and for
> >> latter we could
> >> >>> start off with and internal prio around x (e.g. 16k), so there's r=
oom
> >> to attach in
> >> >>> front via fixed prio, but also append to end for 'don't care', and
> >> that could be
> >> >>> from lib pov the default/main API whereas prio would be some kind =
of
> >> extended one.
> >> >>> Thoughts?
> >> >>
> >> >> If prio was not part of uapi, like kernel internal somehow,
> >> >> and there was a user space daemon, systemd, or another bpf prog,
> >> >> module, whatever that users would interface to then
> >> >> the proposed implementation of prio would totally make sense.
> >> >> prio as uapi is not that.
> >> >
> >> > A good analogy to this issue might be systemd's unit files.. you
> >> specify dependencies
> >> > for your own <unit> file via 'Wants=3D<unitA>', and ordering
> >> via 'Before=3D<unitB>' and
> >> > 'After=3D<unitC>' and they refer to other unit files. I think that i=
s
> >> generally okay,
> >> > you don't deal with prio numbers, but rather some kind textual
> >> representation. However
> >> > user/operator will have to deal with dependencies/ordering one way o=
r
> >> another, the
> >> > problem here is that we deal with kernel and loader talks to kernel
> >> directly so it
> >> > has no awareness of what else is running or could be running, so app=
s
> >> needs to deal
> >> > with it somehow (and it cannot without external help).
> >
> >> I was thinking a little about how this might work; i.e., how can the
> >> kernel expose the required knobs to allow a system policy to be
> >> implemented without program loading having to talk to anything other
> >> than the syscall API?
> >
> >> How about we only expose prepend/append in the prog attach UAPI, and
> >> then have a kernel function that does the sorting like:
> >
> >> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, str=
uct
> >> bpf_prog *new_prog, bool append)
> >
> >> where the default implementation just appends/prepends to the array in
> >> progs depending on the value of 'appen'.
> >
> >> And then use the __weak linking trick (or maybe struct_ops with a memb=
er
> >> for TXC, another for XDP, etc?) to allow BPF to override the function
> >> wholesale and implement whatever ordering it wants? I.e., allow it can
> >> to just shift around the order of progs in the 'progs' array whenever =
a
> >> program is loaded/unloaded?
> >
> >> This way, a userspace daemon can implement any policy it wants by just
> >> attaching to that hook, and keeping things like how to express
> >> dependencies as a userspace concern?
> >
> > What if we do the above, but instead of simple global 'attach first/las=
t',
> > the default api would be:
> >
> > - attach before <target_fd>
> > - attach after <target_fd>
> > - attach before target_fd=3D-1 =3D=3D first
> > - attach after target_fd=3D-1 =3D=3D last
> >
> > ?
>
> Hmm, the problem with that is that applications don't generally have an
> fd to another application's BPF programs; and obtaining them from an ID
> is a privileged operation (CAP_SYS_ADMIN). We could have it be "attach
> before target *ID*" instead, which could work I guess? But then the
> problem becomes that it's racy: the ID you're targeting could get
> detached before you attach, so you'll need to be prepared to check that
> and retry; and I'm almost certain that applications won't test for this,
> so it'll just lead to hard-to-debug heisenbugs. Or am I being too
> pessimistic here?

I like Stan's proposal and don't see any issue with FD.
It's good to gate specific sequencing with cap_sys_admin.
Also for consistency the FD is better than ID.

I also like systemd analogy with Before=3D, After=3D.
systemd has a ton more ways to specify deps between Units,
but none of them have absolute numbers (which is what priority is).
The only bit I'd tweak in Stan's proposal is:
- attach before <target_fd>
- attach after <target_fd>
- attach before target_fd=3D0 =3D=3D first
- attach after target_fd=3D0 =3D=3D last

The attach operation needs to be CAP_NET_ADMIN.
Just like we do for BPF_PROG_TYPE_CGROUP_SKB.

And we can do the same logic for XDP attaching.
Eventually we can add __weak "orchestrator prog",
but it would need to not only order progs, but should
interpret enum tc_action_base return codes at run-time
between progs too.
