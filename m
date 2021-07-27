Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04213D7E45
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbhG0TGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhG0TGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 15:06:06 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6B1C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 12:06:05 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g76so22416474ybf.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 12:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6FbK7fw17KnDkks7uGdcoRLJymvkHGssn75T6/ebhI=;
        b=coMGWV8FeI47JDEAhF4HiAXmS42pz/MKR70aA8RLOb83n/O3cp4THqjgCNx4hmMgV0
         rhMMXCgrmoHTQboNwpVhCmtDezK/w1KP8b8h8b1vXPRQCFFrwfy4EGbdvySWPNcH5/zP
         BQ4Ij9wyJ6S/PZ5f+/TI4FLH79VvvmvhIViGVHho4v5P2LL6qbz7BtJPkqgxvD4qI+Ya
         aapkUg5Aa4FWTn7f01wWG27IUhWXk/TdqwvwVPXYYtfUZzj3sJjSVw2toUev/LFnJmLG
         0bJ2gu864YcVEHVqDQVQvMd214xDnlCSGohLIfqAhdY15XW3iz51xaDEP4OVs6pr51wb
         Mbtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6FbK7fw17KnDkks7uGdcoRLJymvkHGssn75T6/ebhI=;
        b=IbamjAQJtV3hlAJGpndVOrhg4Bj8lln+N4hliDSLrT3TkirCFgIcPhCzdMZ3G0IbHq
         vHeRze6Pe3qQ9iOQBCdcCpZiaJO05AlGIFa2alKwnsRxs1ueXmi2wnoiDwvwouiMrdRQ
         dXKcR1pUdSOB8J+gmY5DBXyyfRGyou/dZUdP1VtM/PP7c921cF7SJ5YEKT20GHbJBOQZ
         jL60pj24pcJH68lg8dsfsXq/hJCNCfFkn7FUdTgEjrTVqVfuhOoQADC7yGfMMnaOaskB
         rINT09UVpmoH1vFx3njMDuakvbqoN004NKaVM+xerWnHSZ6TqC8/QED87qi5Hj4bJMwB
         Q7dg==
X-Gm-Message-State: AOAM533MWSf682t74dp4W5x1pv5VrV2P2Fm51S7xCYclBNMASYtFN1OP
        asia8M38WXbJr8w9CNPrZZeKAk4aYWaL1Lhw/ik=
X-Google-Smtp-Source: ABdhPJyf9iB4W4iozTCtkjzHpbFRp05qbLXIL6x4rWiwSl4obI+f2PDY9OR9vwG0HYZB2HbkhT+zV3njzQp+MvVvcTE=
X-Received: by 2002:a25:9942:: with SMTP id n2mr33563075ybo.230.1627412764546;
 Tue, 27 Jul 2021 12:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210705124307.201303-1-m@lambda.lt> <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
 <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt> <YPpIeppWpqFCSaqZ@Laptop-X1>
 <CAEf4Bzavevcn=p7iBSH6iXMOCXp5kCu71a1kZ7PSawW=LW5NSQ@mail.gmail.com>
 <0cc404df-078a-686e-c5ce-8473c0e220f5@gmail.com> <CAEf4Bza3gMzfSQcv_QDzVP=vsCzxy=8DHwU-EVqOt8XagK7OHw@mail.gmail.com>
 <cce56767-efbe-e572-6290-111c6c845578@gmail.com> <CAEf4BzZHTuq8FhxyoQ-gksXspUqmocsEGyU2D5r6pFibOSSVMw@mail.gmail.com>
 <69ee30ef-5bdb-9179-c6a4-f87502b14e31@gmail.com>
In-Reply-To: <69ee30ef-5bdb-9179-c6a4-f87502b14e31@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Jul 2021 12:05:53 -0700
Message-ID: <CAEf4Bzad70FY2mWxjQm4-Vx7=T3_S5VA5YdYbDxb1BmG2z6F-A@mail.gmail.com>
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple sections
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>, Martynas Pumputis <m@lambda.lt>,
        Networking <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 26, 2021 at 7:51 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/26/21 9:13 AM, Andrii Nakryiko wrote:
> > On Mon, Jul 26, 2021 at 6:58 AM David Ahern <dsahern@gmail.com> wrote:
> >>
> >> On 7/23/21 6:25 PM, Andrii Nakryiko wrote:
> >>>>>>>> This is still problematic, because one section can have multiple BPF
> >>>>>>>> programs. I.e., it's possible two define two or more XDP BPF programs
> >>>>>>>> all with SEC("xdp") and libbpf works just fine with that. I suggest
> >>>>>>>> moving users to specify the program name (i.e., C function name
> >>>>>>>> representing the BPF program). All the xdp_mycustom_suffix namings are
> >>>>>>>> a hack and will be rejected by libbpf 1.0, so it would be great to get
> >>>>>>>> a head start on fixing this early on.
> >>>>>>>
> >>>>>>> Thanks for bringing this up. Currently, there is no way to specify a
> >>>>>>> function name with "tc exec bpf" (only a section name via the "sec" arg). So
> >>>>>>> probably, we should just add another arg to specify the function name.
> >>>>>>
> >>>>>> How about add a "prog" arg to load specified program name and mark
> >>>>>> "sec" as not recommended? To keep backwards compatibility we just load the
> >>>>>> first program in the section.
> >>>>>
> >>>>> Why not error out if there is more than one program with the same
> >>>>> section name? if there is just one (and thus section name is still
> >>>>> unique) -- then proceed. It seems much less confusing, IMO.
> >>>>>
> >>>>
> >>>> Let' see if I understand this correctly: libbpf 1.0 is not going to
> >>>> allow SEC("xdp_foo") or SEC("xdp_bar") kind of section names - which is
> >>>> the hint for libbpf to know program type. Instead only SEC("xdp") is
> >>>> allowed.
> >>>
> >>> Right.
> >>>
> >>>>
> >>>> Further, a single object file is not going to be allowed to have
> >>>> multiple SEC("xdp") instances for each program name.
> >>>
> >>> On the contrary. Libbpf already allows (and will keep allowing)
> >>> multiple BPF programs with SEC("xdp") in a single object file. Which
> >>> is why section_name is not a unique program identifier.
> >>>
> >>
> >> Does that require BTF? My attempts at loading an object file with 2
> >> SEC("xdp") programs failed. This is using bpftool from top of tree and
> >> loadall.
> >
> > You mean kernel BTF? Not if XDP programs themselves were built
> > requiring CO-RE. So if those programs use #include "vmlinux.h", or
> > there is BPF_CORE_READ() use somewhere in the code, or explicit
> > __attribute__((preserve_access_index)) is used on some of the used
> > structs, then yes, vmlinux BTF will be needed. But otherwise no. Do
> > you have verbose error logs? I think with bpftool you can get them
> > with -d argument.
> >
>
> xdp_l3fwd is built using an old school compile line - no CO-RE or BTF,
> just a basic compile line extracted from samples/bpf 2-3 years ago.
> Works fine for what I need and take this nothing more than an example to
> verify your comment
>
> "Libbpf already allows (and will keep allowing) multiple BPF programs
> with SEC("xdp") in a single object file."
>
>
> The bpftool command line to load the programs is:
>
> $ bpftool -ddd prog loadall xdp_l3fwd.o /sys/fs/bpf
>
> It fails because libbpf is trying to put 2 programs at the same path:
>
> libbpf: pinned program '/sys/fs/bpf/xdp'
> libbpf: failed to pin program: File exists
> libbpf: unpinned program '/sys/fs/bpf/xdp'
> Error: failed to pin all programs

Ok, I see, that's the problem with pinning path using section name as
an identifier (same wrong assumption made a long time ago). We have a
task to fix that ([0]) and use program name instead of section name
for this, but it's a backwards incompatible change, so users will have
to opt-in.

And we should fix bpftool as well, of course, though I never used
bpftool to load programs so I wasn't even aware it's doing pinning
like that.


  [0] https://github.com/libbpf/libbpf/issues/273

>
> The code that works is this:
>
> SEC("xdp_l3fwd")
> int xdp_l3fwd_prog(struct xdp_md *ctx)
> {
>         return xdp_l3fwd_flags(ctx, 0);
> }
>
> SEC("xdp_l3fwd_direct")
> int xdp_l3fwd_direct_prog(struct xdp_md *ctx)
> {
>         return xdp_l3fwd_flags(ctx, BPF_FIB_LOOKUP_DIRECT);
> }
>
> The code that fails is this:
>
> SEC("xdp")
> int xdp_l3fwd_prog(struct xdp_md *ctx)
> {
>         return xdp_l3fwd_flags(ctx, 0);
> }
>
> SEC("xdp")
> int xdp_l3fwd_direct_prog(struct xdp_md *ctx)
> {
>         return xdp_l3fwd_flags(ctx, BPF_FIB_LOOKUP_DIRECT);
> }
>
> which is what you said should work -- 2 programs with the same section name.
>

And I didn't lie, see progs/test_check_mtu.c as an example, it has 6
XDP programs with SEC("xdp"). The problem is in the pinning, which is
in general an area that was pretty ad-hoc and not very well thought
out in libbpf, growing organically. This hopefully will be addressed
and improved before libbpf 1.0 is finalized.

Right now users can override the default pin path by setting it
explicitly with bpf_program__set_pin_path(), which might be a good
idea to do for this new "prog" approach that Hangbin proposed.

> From a very quick check of bpftool vs libbpf, the former is calling
> bpf_object__pin_programs from the latter and passing the base path
> (/sys/fs/bpf in this example) and then bpf_object__pin_programs adds the
> pin_name for the prog - which must be the same for both programs since
> the second one fails.
>
