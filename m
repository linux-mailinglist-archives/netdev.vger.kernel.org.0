Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A17E5F8142
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 01:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJGXfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 19:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiJGXfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 19:35:14 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD7C3E759;
        Fri,  7 Oct 2022 16:35:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id kg6so14303625ejc.9;
        Fri, 07 Oct 2022 16:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NUn6PJnyQLmWn9QrxA1ZcD4c7d7LYHiBixtS86xNsjA=;
        b=hRNk3tXL4av3AVjcG3Wd8411Cc6D3emEKNbomu97+X5RNvsIzZ1cHWEJT22CcIpbht
         97lcD+CuIr5qa037BxbF6RPE4xn8Go2amubDlYYcxwlJvEIGQY5MaaNiqom14m1upG6M
         TAKAr+vLDQL+e6KcI5BDpPLXL8mLhAnY3uoHIBsIYO4TrZw+H6rekVdCM2RWHnAUfXAL
         vljJ9AzEH1lszhDYOxUjb0GF52gjRc1Juco3GaxclNcSZeSaEXKnA/u7byqTWI1IH845
         ZLaVl58i2dUkoL4i5nCxXBouRpp5Ya9ksH20BTdk17yvSCp/TRIDxWAVbft7aw96WOSy
         fE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NUn6PJnyQLmWn9QrxA1ZcD4c7d7LYHiBixtS86xNsjA=;
        b=Kznyvtex+0gHYrzJsPoZZp2u4m/LPFcPH3fS9b5tV/s9zY+He+NAB/M4NF3tf+dWV+
         hqA10kY2PfI3NVDtss2EBk0rCMMgqSXxEd5iz3R7+SevjToGcvvhH6IkUYQMTjHFpSv9
         41UzPaZFlHlcpNH0WrSi/FheZQlY4FwFs3COeVwb+GYfctXwMSFah7pRe0Su21XrNrcC
         Rn46UuFTd/RAEAzRCSieBe8td/XHM/24bYll8Sj8HzM0BY/O7bFaftcaT2RanysCjpDj
         F4NFX5Aq8DEOuqsy4nhFgMYUQlbV0TOsU7WoMDVQSSIjhpcV0P3xMGb6YlAp0tbVz6HD
         TLAQ==
X-Gm-Message-State: ACrzQf12jMSc+L9PePNYHntmmiOxHQGLuY9T4RdA0QQPNVlale2wQysA
        nPpfHzsy6GfODt8TcsjDvhD1+AzCCQ/PpeELEvA=
X-Google-Smtp-Source: AMsMyM4QARoD+FAFVSg2wGdw1KrElxiaesg5AtQlDN394YcRxN5VzeXLufiqxY/2t4XqQwDMJ7EqUeNQnPuWi7+KoP4=
X-Received: by 2002:a17:907:a421:b0:783:c25a:cee0 with SMTP id
 sg33-20020a170907a42100b00783c25acee0mr5791238ejc.94.1665185709740; Fri, 07
 Oct 2022 16:35:09 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
 <20221006050053.pbwo72xtzoza6gfl@macbook-pro-4.dhcp.thefacebook.com>
 <f355eeba-1b46-749f-c102-65074e7eac27@iogearbox.net> <CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com>
 <14f368eb-9158-68bc-956c-c8371cfcb531@iogearbox.net> <875ygvemau.fsf@toke.dk>
 <Y0BaBUWeTj18V5Xp@google.com> <87tu4fczyv.fsf@toke.dk> <CAADnVQLH9R94iszCmhYeLKnDPy_uiGeyXnEwoADm8_miihwTmQ@mail.gmail.com>
 <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net>
In-Reply-To: <8cc9811e-6efe-3aa5-b201-abbd4b10ceb4@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Oct 2022 16:34:58 -0700
Message-ID: <CAADnVQLpcLWrL-URhRgqCQa6XRZzib4BorZ2QKpPC+Uw_JNW=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>,
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

On Fri, Oct 7, 2022 at 12:37 PM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 10/7/22 8:59 PM, Alexei Starovoitov wrote:
> > On Fri, Oct 7, 2022 at 10:20 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> [...]
> >>>> I was thinking a little about how this might work; i.e., how can the
> >>>> kernel expose the required knobs to allow a system policy to be
> >>>> implemented without program loading having to talk to anything other
> >>>> than the syscall API?
> >>>
> >>>> How about we only expose prepend/append in the prog attach UAPI, and
> >>>> then have a kernel function that does the sorting like:
> >>>
> >>>> int bpf_add_new_tcx_prog(struct bpf_prog *progs, size_t num_progs, s=
truct
> >>>> bpf_prog *new_prog, bool append)
> >>>
> >>>> where the default implementation just appends/prepends to the array =
in
> >>>> progs depending on the value of 'appen'.
> >>>
> >>>> And then use the __weak linking trick (or maybe struct_ops with a me=
mber
> >>>> for TXC, another for XDP, etc?) to allow BPF to override the functio=
n
> >>>> wholesale and implement whatever ordering it wants? I.e., allow it c=
an
> >>>> to just shift around the order of progs in the 'progs' array wheneve=
r a
> >>>> program is loaded/unloaded?
> >>>
> >>>> This way, a userspace daemon can implement any policy it wants by ju=
st
> >>>> attaching to that hook, and keeping things like how to express
> >>>> dependencies as a userspace concern?
> >>>
> >>> What if we do the above, but instead of simple global 'attach first/l=
ast',
> >>> the default api would be:
> >>>
> >>> - attach before <target_fd>
> >>> - attach after <target_fd>
> >>> - attach before target_fd=3D-1 =3D=3D first
> >>> - attach after target_fd=3D-1 =3D=3D last
> >>>
> >>> ?
> >>
> >> Hmm, the problem with that is that applications don't generally have a=
n
> >> fd to another application's BPF programs; and obtaining them from an I=
D
> >> is a privileged operation (CAP_SYS_ADMIN). We could have it be "attach
> >> before target *ID*" instead, which could work I guess? But then the
> >> problem becomes that it's racy: the ID you're targeting could get
> >> detached before you attach, so you'll need to be prepared to check tha=
t
> >> and retry; and I'm almost certain that applications won't test for thi=
s,
> >> so it'll just lead to hard-to-debug heisenbugs. Or am I being too
> >> pessimistic here?
> >
> > I like Stan's proposal and don't see any issue with FD.
> > It's good to gate specific sequencing with cap_sys_admin.
> > Also for consistency the FD is better than ID.
> >
> > I also like systemd analogy with Before=3D, After=3D.
> > systemd has a ton more ways to specify deps between Units,
> > but none of them have absolute numbers (which is what priority is).
> > The only bit I'd tweak in Stan's proposal is:
> > - attach before <target_fd>
> > - attach after <target_fd>
> > - attach before target_fd=3D0 =3D=3D first
> > - attach after target_fd=3D0 =3D=3D last
>
> I think the before(), after() could work, but the target_fd I have my dou=
bts
> that it will be practical. Maybe lets walk through a concrete real exampl=
e. app_a
> and app_b shipped via container_a resp container_b. Both want to install =
tc BPF
> and we (operator/user) want to say that prog from app_b should only be in=
serted
> after the one from app_a, never run before; if no prog_a is installed, we=
 ofc just
> run prog_b, but if prog_a is inserted, it must be before prog_b given the=
 latter
> can only run after the former. How would we get to one anothers target fd=
? One
> could use the 0, but not if more programs sit before/after.

I read your desired use case several times and probably still didn't get it=
.
Sounds like prog_b can just do after(fd=3D0) to become last.
And prog_a can do before(fd=3D0).
Whichever the order of attaching (a or b) these two will always
be in a->b order.
Are you saying that there should be no progs between them?
Sure, the daemon could iterate the hook progs, discover prog_id,
get its FD and do before(prog_fd).
The use case sounds hypothetical.
Since the first and any prog returning !TC_NEXT will abort
the chain we'd need __weak nop orchestrator prog to interpret
retval for anything to be useful.
With cgroup-skb we did fancy none/override/multi and what for?
As far as I can see everyone is using 'multi' and all progs are run.
If we did only 'multi' for cgroup it would be just as fine
and we would have avoided all the complexity in the kernel.
Hence I'm advocating for the simplest approach for tcx and xdp.
