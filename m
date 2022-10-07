Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D585F814B
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 01:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJGXlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 19:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJGXlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 19:41:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7E1A8CC8;
        Fri,  7 Oct 2022 16:41:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id sc25so8236179ejc.12;
        Fri, 07 Oct 2022 16:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zHb7dfHUdWwpRTPAV/SA+OabG3x+I/4Hc0w8FBx7mM0=;
        b=QroeSz07Frf7HBZiuvSGa8KySeJOnhezjeezy+TBTzM9tFcjaWg2KTJFv5v82suBiR
         LicBs4n+eWkBumfPk8e6rpQZBjxhHlZwtiNEjjjYIQZDKDAC4W7SzvCu22A2O4zhr9/b
         oUaz1lF6nXQ/h4gwBx+m20W9ZGtUsng/T0LoHI/X/m91svhPxl3ommMkQgf48r237vgD
         NT9V2yG9RSohb2jINw4tRYITZMmqVqG2CR10hK22yWNJN7kvviq5W7WI//b9JPcIuHuX
         RlP4Ot5yi0kujxyCN2t5MBPo0/QLuc4UXA7aEqza4W0YsPwnqLBKZAQjKP5W7eqZvcpS
         w58w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zHb7dfHUdWwpRTPAV/SA+OabG3x+I/4Hc0w8FBx7mM0=;
        b=I4t61+v3g6/EPRGULTpbtUKN9RV8XbtmZMRD0mYm+rp9uIQwZN/UULBnV8MGIVfISA
         51g8PtvimlnShobehqb3ZDx/jJTsshZlhj/u79oxiz17N82e33yn/58q1xyLbaXUfnZH
         f5C6fqjYz57/u0fUzXmhRv3U0SaWCVSKpaSCdP20UO9MnXApOduqnVNVYrzA/SBYrfEs
         WL26ICb3MLMGAk5POv23AL7ubf8aOiRxfIeEWuiWtKfBcjKoZOfUX8szE22gc66m01ec
         uv+aOBrPE4HWJvzJupeoFPk/BAP2eEqBFMsTm1DZUGSRuC+iQJnf1ecG7Cu5gf3lRKiU
         upNw==
X-Gm-Message-State: ACrzQf2TPV+btEfBDVajdC2vnseVeP2J+uFodPwHhgeF78gl8Xwq4Kly
        LuHvJNv885vbUrLtYqHn8sVHwX03/q1ciPF0dog=
X-Google-Smtp-Source: AMsMyM4mTIA25/ZYmsWsT38u7nVFuIEaUgxdmrZJQBYC/JyhEe0W4oLkP4anoZ3jM4KZGj7JTEqBSqrnr1K34sbteas=
X-Received: by 2002:a17:906:7310:b0:782:cfd4:9c07 with SMTP id
 di16-20020a170906731000b00782cfd49c07mr6264914ejc.708.1665186101036; Fri, 07
 Oct 2022 16:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-2-daniel@iogearbox.net> <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net> <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net> <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com> <87tu4fczyv.fsf@toke.dk> <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net> <Y0CsATkd2qK1Mu2Z@google.com>
In-Reply-To: <Y0CsATkd2qK1Mu2Z@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Oct 2022 16:41:29 -0700
Message-ID: <CAADnVQKKCu_6fbef5R1nvXw1PsVM0q2KpQog3M_4g51xzVdYOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Fri, Oct 7, 2022 at 3:45 PM <sdf@google.com> wrote:
>
> On 10/07, Daniel Borkmann wrote:
> > On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
> > > On Fri, Oct 7, 2022 at 10:20 AM Toke H=EF=BF=BDiland-J=EF=BF=BDrgense=
n
> > <toke@redhat.com> wrote:
> > [...]
> > > > > > I was thinking a little about how this might work; i.e., how ca=
n
> > the
> > > > > > kernel expose the required knobs to allow a system policy to be
> > > > > > implemented without program loading having to talk to anything
> > other
> > > > > > than the syscall API?
> > > > >
> > > > > > How about we only expose prepend/append in the prog attach UAPI=
,
> > and
> > > > > > then have a kernel function that does the sorting like:
> > > > >
> > > > > > int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t
> > num_progs, struct
> > > > > > bpf_prog *new_prog, bool append)
> > > > >
> > > > > > where the default implementation just appends/prepends to the
> > array in
> > > > > > progs depending on the value of 'appen'.
> > > > >
> > > > > > And then use the __weak linking trick (or maybe struct_ops with=
 a
> > member
> > > > > > for TXC, another for XDP, etc?) to allow BPF to override the
> > function
> > > > > > wholesale and implement whatever ordering it wants? I.e., allow
> > it can
> > > > > > to just shift around the order of progs in the 'progs' array
> > whenever a
> > > > > > program is loaded/unloaded?
> > > > >
> > > > > > This way, a userspace daemon can implement any policy it wants =
by
> > just
> > > > > > attaching to that hook, and keeping things like how to express
> > > > > > dependencies as a userspace concern?
> > > > >
> > > > > What if we do the above, but instead of simple global 'attach
> > first/last',
> > > > > the default api would be:
> > > > >
> > > > > - attach before <target_fd>
> > > > > - attach after <target_fd>
> > > > > - attach before target_fd=3D-1 =3D=3D first
> > > > > - attach after target_fd=3D-1 =3D=3D last
> > > > >
> > > > > ?
> > > >
> > > > Hmm, the problem with that is that applications don't generally hav=
e
> > an
> > > > fd to another application's BPF programs; and obtaining them from a=
n
> > ID
> > > > is a privileged operation (CAP_SYS_ADMIN). We could have it be "att=
ach
> > > > before target *ID*" instead, which could work I guess? But then the
> > > > problem becomes that it's racy: the ID you're targeting could get
> > > > detached before you attach, so you'll need to be prepared to check
> > that
> > > > and retry; and I'm almost certain that applications won't test for
> > this,
> > > > so it'll just lead to hard-to-debug heisenbugs. Or am I being too
> > > > pessimistic here?
> > >
> > > I like Stan's proposal and don't see any issue with FD.
> > > It's good to gate specific sequencing with cap_sys_admin.
> > > Also for consistency the FD is better than ID.
> > >
> > > I also like systemd analogy with Before=3D, After=3D.
> > > systemd has a ton more ways to specify deps between Units,
> > > but none of them have absolute numbers (which is what priority is).
> > > The only bit I'd tweak in Stan's proposal is:
> > > - attach before <target_fd>
> > > - attach after <target_fd>
> > > - attach before target_fd=3D0 =3D=3D first
> > > - attach after target_fd=3D0 =3D=3D last
>
> > I think the before(), after() could work, but the target_fd I have my
> > doubts
> > that it will be practical. Maybe lets walk through a concrete real
> > example. app_a
> > and app_b shipped via container_a resp container_b. Both want to instal=
l
> > tc BPF
> > and we (operator/user) want to say that prog from app_b should only be
> > inserted
> > after the one from app_a, never run before; if no prog_a is installed, =
we
> > ofc just
> > run prog_b, but if prog_a is inserted, it must be before prog_b given t=
he
> > latter
> > can only run after the former. How would we get to one anothers target
> > fd? One
> > could use the 0, but not if more programs sit before/after.
>
> This fd/id has to be definitely abstracted by the loader. With the
> program, we would ship some metadata like 'run_after:prog_a' for
> prog_b (where prog_a might be literal function name maybe?).
> However, this also depends on 'run_before:prog_b' in prog_a (in
> case it happens to be started after prog_b) :-/

Let's not overload libbpf with that.
I don't see any of that being used.
If a real use case comes up we'll do that at that time.

> So yeah, some central place might still be needed; in this case, Toke's
> suggestion on overriding this via bpf seems like the most flexible one.
>
> Or maybe libbpf can consult some /etc/bpf.init.d/ directory for those?
> Not sure if it's too much for libbpf or it's better done by the higher
> levels? I guess we can rely on the program names and then all we really
> need is some place to say 'prog X happens before Y' and for the loaders
> to interpret that.

It's getting into bikeshedding territory.
We made this mistake with xdp.
No one could convince anyone of anything and got stuck with
single prog.

> > To me it sounds reasonable to have the append mode as default mode/API,
> > and an advanced option to say 'I want to run as 2nd prog, but if someth=
ing
> > is already attached as 2nd prog, shift all the others +1 in the array'
> > which
> > would relate to your above point, Stan, of being able to stick into any
> > place in the chain.
>
> Replying to your other email here:
>
> I'd still prefer, from the user side, to be able to stick my prog into
> any place for debugging. But you suggestion to shift others for +1 works
> for me.
> (although, not sure, for example, what happens if I want to shift right t=
he
> program that's at position 65k; aka already last?)

65k progs attached to a single hook?!
At that point it won't really matter how before() and after()
are implemented.
Copy of the whole array is the simplest implementation that would
work just fine.

I guess I wasn't clear that the absolute position in the array
is not going to be returned to the user space.
The user space could grab IDs of all progs attached
in the existing order. But that order is valid only at that
very second. Another prog might get inserted anywhere a second later.
Same thing we do for cgroups.
