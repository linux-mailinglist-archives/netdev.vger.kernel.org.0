Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BE71D8EDD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 06:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgESEkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 00:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgESEkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 00:40:03 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1694EC061A0C;
        Mon, 18 May 2020 21:40:02 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id p12so10096591qtn.13;
        Mon, 18 May 2020 21:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ef8uGVA3J/Q3uZk4bRLiF9KBaJiSBJ6a54346FamXFo=;
        b=jg5nASl04iv4Fc5ymkwoZdlDwRQVgGM2FpUy9uFpbr0c+83BGnJ1o5FV+qhpeF6MHo
         VumZG/7Rmk9kAEwa+g4riNpMv+IUHO1SEmgULUseVmK5WtcpvCK9EYqDsCMM/FmW51CL
         LakjbSnjLdyQ78kKJyrT56Y3fOiPKzirVpiIqQ8hQQ38otfUMBlAAkN92L5Rv2QUL4+q
         HJdJ+KwCgh/vGSD+RHcWa2o080Tdfhiq1JlAtdmf+oVjvRJubNgzetePevVHB0of2SEv
         gob25SdBucK9iDLvVY1B3TnjEBpf9LT9wvFi1Sy44ptyrsdu2IKpFQ8P8/4quYilGHKE
         CXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ef8uGVA3J/Q3uZk4bRLiF9KBaJiSBJ6a54346FamXFo=;
        b=AEGUCx8eqJwP1MJbdOZr36hO92dgfTFYIXgbp1RfB5+bheaAfaoLZ+HI3S8jjdXF86
         Vn0PVEOMk9QReowodkqa/qsiuZksPDRoaLpwcO6pTthDuG6vaSot/lSHk0TYNUlUv08J
         ppVFX/TcAiEJw1VQLRg9F0jZtI5LFduqk5wlzOAqAQ3D0BWEsbPG5EQj9JbtBR0qKLyl
         YCml28yygsX55MW8d0odH0VYIQr4cptVJx4oZ1KtqiToSNO8UnMQNVRwiGtr6VQfZOyo
         wK929O/SxZZGvQywFu/aGwZ/4u4xIpZwcwx/e3oqScnzqKSHVfhyuIjlwkH6ZObd6FAf
         jR0A==
X-Gm-Message-State: AOAM5328bhfhtL41a5gsq+GYQLzxMvHfiLShsDrDO90BdCJOgEwQ2E/G
        mWRMjKTuoU6Hbbtmp/bKpH+0N+n//6+uSmITk8I=
X-Google-Smtp-Source: ABdhPJy9zag//58ZgfB17SZbTGntuo6NBj9soLHQ18BKXHp8Pa3IFGtcsOrc18YvUEKZ329NgPHO/qNZXJveTbmgvW8=
X-Received: by 2002:aed:2f02:: with SMTP id l2mr19919130qtd.117.1589863201034;
 Mon, 18 May 2020 21:40:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200516005149.3841-1-quentin@isovalent.com> <CAEf4BzZDC9az2vFPTNW03gSUZiYdc9-XeyP+1h8WkAKHagkUTg@mail.gmail.com>
 <3ffe7cc3-01da-1862-d734-b7a8b1d7c63d@isovalent.com>
In-Reply-To: <3ffe7cc3-01da-1862-d734-b7a8b1d7c63d@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 21:39:50 -0700
Message-ID: <CAEf4BzaD3UW8AL7ZEiqMzpSP_u_RT-p=VK5oTVjMHyd7Wpckyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: make capability check account
 for new BPF caps
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 6:03 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-05-18 17:07 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Fri, May 15, 2020 at 5:52 PM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> Following the introduction of CAP_BPF, and the switch from CAP_SYS_ADMIN
> >> to other capabilities for various BPF features, update the capability
> >> checks (and potentially, drops) in bpftool for feature probes. Because
> >> bpftool and/or the system might not know of CAP_BPF yet, some caution is
> >> necessary:
> >>
> >> - If compiled and run on a system with CAP_BPF, check CAP_BPF,
> >>   CAP_SYS_ADMIN, CAP_PERFMON, CAP_NET_ADMIN.
> >>
> >> - Guard against CAP_BPF being undefined, to allow compiling bpftool from
> >>   latest sources on older systems. If the system where feature probes
> >>   are run does not know of CAP_BPF, stop checking after CAP_SYS_ADMIN,
> >>   as this should be the only capability required for all the BPF
> >>   probing.
> >>
> >> - If compiled from latest sources on a system without CAP_BPF, but later
> >>   executed on a newer system with CAP_BPF knowledge, then we only test
> >>   CAP_SYS_ADMIN. Some probes may fail if the bpftool process has
> >>   CAP_SYS_ADMIN but misses the other capabilities. The alternative would
> >>   be to redefine the value for CAP_BPF in bpftool, but this does not
> >>   look clean, and the case sounds relatively rare anyway.
> >>
> >> Note that libcap offers a cap_to_name() function to retrieve the name of
> >> a given capability (e.g. "cap_sys_admin"). We do not use it because
> >> deriving the names from the macros looks simpler than using
> >> cap_to_name() (doing a strdup() on the string) + cap_free() + handling
> >> the case of failed allocations, when we just want to use the name of the
> >> capability in an error message.
> >>
> >> The checks when compiling without libcap (i.e. root versus non-root) are
> >> unchanged.
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >>  tools/bpf/bpftool/feature.c | 85 +++++++++++++++++++++++++++++--------
> >>  1 file changed, 67 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> >> index 1b73e63274b5..3c3d779986c7 100644
> >> --- a/tools/bpf/bpftool/feature.c
> >> +++ b/tools/bpf/bpftool/feature.c
> >> @@ -758,12 +758,32 @@ static void section_misc(const char *define_prefix, __u32 ifindex)
> >>         print_end_section();
> >>  }
> >>
> >> +#ifdef USE_LIBCAP
> >> +#define capability(c) { c, #c }
> >> +#endif
> >> +
> >>  static int handle_perms(void)
> >>  {
> >>  #ifdef USE_LIBCAP
> >> -       cap_value_t cap_list[1] = { CAP_SYS_ADMIN };
> >> -       bool has_sys_admin_cap = false;
> >> +       struct {
> >> +               cap_value_t cap;
> >> +               char name[14];  /* strlen("CAP_SYS_ADMIN") */
> >> +       } required_caps[] = {
> >> +               capability(CAP_SYS_ADMIN),
> >> +#ifdef CAP_BPF
> >> +               /* Leave CAP_BPF in second position here: We will stop checking
> >> +                * if the system does not know about it, since it probably just
> >> +                * needs CAP_SYS_ADMIN to run all the probes in that case.
> >> +                */
> >> +               capability(CAP_BPF),
> >> +               capability(CAP_NET_ADMIN),
> >> +               capability(CAP_PERFMON),
> >> +#endif
> >> +       };
> >> +       bool has_admin_caps = true;
> >> +       cap_value_t *cap_list;
> >>         cap_flag_value_t val;
> >> +       unsigned int i;
> >>         int res = -1;
> >>         cap_t caps;
> >>
> >> @@ -774,41 +794,70 @@ static int handle_perms(void)
> >>                 return -1;
> >>         }
> >>
> >> -       if (cap_get_flag(caps, CAP_SYS_ADMIN, CAP_EFFECTIVE, &val)) {
> >> -               p_err("bug: failed to retrieve CAP_SYS_ADMIN status");
> >> +       cap_list = malloc(sizeof(cap_value_t) * ARRAY_SIZE(required_caps));
> >
> > I fail to see why you need to dynamically allocate cap_list?
> > cap_value_t cap_list[ARRAY_SIZE(required_caps)] wouldn't work?
>
> Oh I should have thought about that, thanks! I'll fix it.
>
> >> +       if (!cap_list) {
> >> +               p_err("failed to allocate cap_list: %s", strerror(errno));
> >>                 goto exit_free;
> >>         }
> >> -       if (val == CAP_SET)
> >> -               has_sys_admin_cap = true;
> >>
> >> -       if (!run_as_unprivileged && !has_sys_admin_cap) {
> >> -               p_err("full feature probing requires CAP_SYS_ADMIN, run as root or use 'unprivileged'");
> >> -               goto exit_free;
> >> +       for (i = 0; i < ARRAY_SIZE(required_caps); i++) {
> >> +               const char *cap_name = required_caps[i].name;
> >> +               cap_value_t cap = required_caps[i].cap;
> >> +
> >> +#ifdef CAP_BPF
> >> +               if (cap == CAP_BPF && !CAP_IS_SUPPORTED(cap))
> >> +                       /* System does not know about CAP_BPF, meaning
> >> +                        * that CAP_SYS_ADMIN is the only capability
> >> +                        * required. We already checked it, break.
> >> +                        */
> >> +                       break;
> >> +#endif
> >
> > Seems more reliable to check all 4 capabilities independently (so
> > don't stop if !CAP_IS_SUPPORTED(cap)), and drop those that you have
> > set. Or there are some downsides to that?
>
> If CAP_BPF is not supported, there is simply no point in going on
> checking the other capabilities, since CAP_SYS_ADMIN is the only one we
> need to do the feature probes. So in that case I see little point in
> checking the others.
>
> But if I understand your concern, you're right in the sense that the
> current code would consider a user as "unprivileged" if they do not have
> all four capabilities (in the case where CAP_BPF is supported); but they
> may still have a subset of them and not be completely unprivileged, and
> in that case we would have has_admin_caps at false and skip capabilities
> drop.
>
> I will fix that in next version. I am not sure about the advantage of
> keeping track of the capabilities and building a list just for dropping
> only the ones we have, but I can do that if you prefer.
>

Honestly, I don't use bpftool feature at all, so I'm not very
qualified to decide. I just like tools not making too many
assumptions, where not necessary. So see for yourself :)

> Thanks a lot for the review!
> Quentin
