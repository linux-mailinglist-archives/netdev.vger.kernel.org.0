Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014C046B1A4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 04:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhLGDwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 22:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbhLGDwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 22:52:15 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11EAC061746;
        Mon,  6 Dec 2021 19:48:45 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id f9so37190278ybq.10;
        Mon, 06 Dec 2021 19:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5LixDfplhjIadwPlhHnbZziuotju+ffMcnX0uh37HLo=;
        b=I4BeOvJMWYSoqI9qRPOFlQhoWplRmI0Qh6ZmNoWbR3MeYHOlen9iLZaRjAfHt2D6te
         S3VQ0exLbjFTKba6D/xyrQ3+gKv/5MIQLr/koJW1UzsFp4NQilAU1Tn9RsbpzCHuvSkn
         AS7w0zHkWVFYlxzulybp8rJdZkl9h6igrmkfzfg7qM09bVmuTsHPOPfbWPpzTtAvixVb
         SlPYEeMxqMLfOkmE9enczVwNA3WhA7Em/2OaVP6u7xbvta0KqvYZrPlro1dr4d5JePxR
         HG15Jlf6EJVjqSHSfwh7oCcTUofJJqFo614TWQFtahf2Dg0feyu1e1kl4sgL8L+ApF2N
         hJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5LixDfplhjIadwPlhHnbZziuotju+ffMcnX0uh37HLo=;
        b=vUGER5+eHYis5mSj6W8gCQSVEz0EvmBFOvNPYTn8z8za0VV0tGWBQ5zJS6vYb/gwAE
         OnaGCnxePFSnPltI7k+I74Ldu9wzudZ3/hPZ6VSOsO6bPMWwyClwU3SblBRIeGW6VcQv
         5ghce1H/txV/AW5AOUOU3Bl5Zji+I/A6cNqUnvGE0JDtLIZe6COAt5a5yhwucLApB7I7
         YtQSIAF4rsdd8eS070ohCwcr2mA21clRpMZRIPsGPIum33e5knX3yo+5OY/0gxuIzVr6
         EiKowYFxH/fQsMe5L2D2bx3WjPjS57lFK3dQxv8eQmiLvVW5+GPF/fgFWmTxitIhKJ3q
         DhyQ==
X-Gm-Message-State: AOAM5302KFGhYwZxGB5IHqIIpSH4vdaHrgqse7ROqlDc0BAYwEDsfTtv
        M44bAzFdmsOBn4DVmYdodYyXPQl6xl8OX0Ne5Jk=
X-Google-Smtp-Source: ABdhPJwqZo9KLKSYznui6BQsC0HtuLnHcTUHcsUDyfE0/t7ozUjIkR1We5cDHaCEa6tEi8H8HKAraV27//IGwEBrURY=
X-Received: by 2002:a25:2c92:: with SMTP id s140mr46406198ybs.308.1638848924851;
 Mon, 06 Dec 2021 19:48:44 -0800 (PST)
MIME-Version: 1.0
References: <20211116164208.164245-1-mauricio@kinvolk.io> <20211116164208.164245-5-mauricio@kinvolk.io>
 <CAEf4BzZ0pEXzEvArpzL=0qbVC65z=hmeVuP7cbLKk-0_Gv5Y+A@mail.gmail.com> <CAHap4ztw05d7gfko+bjOcgoGoJiW2rsnGar11TVO5au80LsfHg@mail.gmail.com>
In-Reply-To: <CAHap4ztw05d7gfko+bjOcgoGoJiW2rsnGar11TVO5au80LsfHg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Dec 2021 19:48:33 -0800
Message-ID: <CAEf4BzbGxe7tSOnjpLv91Oj8kxtaOuPR0gSJbpZta5-AZpY+7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Expose CO-RE relocation results
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 3, 2021 at 1:08 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Fri, Nov 19, 2021 at 12:25 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Nov 16, 2021 at 8:42 AM Mauricio V=C3=A1squez <mauricio@kinvolk=
.io> wrote:
> > >
> > > The result of the CO-RE relocations can be useful for some use cases
> > > like BTFGen[0]. This commit adds a new =E2=80=98record_core_relos=E2=
=80=99 option to
> > > save the result of such relocations and a couple of functions to acce=
ss
> > > them.
> > >
> > > [0]: https://github.com/kinvolk/btfgen/
> > >
> > > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> > > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > > ---
> > >  tools/lib/bpf/libbpf.c    | 63 +++++++++++++++++++++++++++++++++++++=
+-
> > >  tools/lib/bpf/libbpf.h    | 49 +++++++++++++++++++++++++++++-
> > >  tools/lib/bpf/libbpf.map  |  2 ++
> > >  tools/lib/bpf/relo_core.c | 28 +++++++++++++++--
> > >  tools/lib/bpf/relo_core.h | 21 ++-----------
> > >  5 files changed, 140 insertions(+), 23 deletions(-)
> > >
> >
> > Ok, I've meditated on this patch set long enough. I still don't like
> > that libbpf will be doing all this just for the sake of BTFGen's use
> > case.
> >
> > In the end, I think giving bpftool access to internal APIs of libbpf
> > is more appropriate, and it seems like it's pretty easy to achieve. It
> > might actually clean up gen_loader parts a bit as well. So we'll need
> > to coordinate all this with Alexei's current work on CO-RE for kernel
> > as well.
>
> Fine for us. I followed the CO-RE in the kernel patch and I didn't
> spot any change that could complicate the BTFGen implementation.
>
> > But here's what I think could be done to keep libbpf internals simple.
> > We split bpf_core_apply_relo() into two parts: 1) calculating the
> > struct bpf_core_relo_res and
>
> For the BTFGen case we actually need "struct bpf_core_relo_res". I
> suppose it's not a big deal to move its definition to a header file
> that can be included by bpftool.

either move it to relo_core.h (if it's ok to be used in kernel, not
sure, try it) or we can put it into libbpf_internal.h

>
> > 2) patching the instruction. If you look
> > at bpf_core_apply_relo, it needs prog just for prog_name (which we can
> > just pass everywhere for logging purposes) and to extract one specific
> > instruction to be patched. This instruction is passed at the very end
> > to bpf_core_patch_insn() after bpf_core_relo_res is calculated. So I
> > propose to make those two explicitly separate steps done by libbpf. So
> > bpf_core_apply_relo() (which we should rename to bpf_core_calc_relo()
> > or something like that) won't do any modification to the program
> > instructions. bpf_object__relocate_core() will do bpf_core_calc_relo()
> > first, if that's successful, it will pass the result into
> > bpf_core_patch_insn(). Simple and clean, unless I missed some
> > complication (happens all the time, but..)
>
> While implementing a prototype of this idea I faced the following challen=
ges:
> - bpf_core_apply_relo() requires a candidate cache. I think we can
> create two helpers functions to create / destroy a candidate cache so
> we don't have to worry about it's internals in bpftool.

yeah, two helpers exposed through libbpf_internal.h is the lesser evil

> - we need to access obj->btf_ext in bpftool. It should be fine to
> create bpf_object__btf_ext() as part of the public libbpf api.

Yeah, bpf_object__btf_ext() sounds good, it's a natural counterpart to
btf_object__btf().

It probably makes sense to also move struct btf_ext_header into btf.h
(btf_header is part of kernel UAPI, BTF.ext header is not going to
change in a non-backwards-compatible way either). There are also
btf_ext_info_sec, bpf_func_info_min and bpf_line_info_min (and Alexei
already exposed core reloc record), which probably makes sense to make
part of btf.h, but that should be tackled separately, probably.

> - bpf_core_apply_relo() requires the bpf program as argument. Before
> Alexei's patches it was used only for logging and getting the
> instruction. Now it's also used to call record_relo_core(). Getting it
> from bpftool is not that easy, in order to do I had to expose
> bpf_program__sec_idx() and find_prog_by_sec_insn() to bpftool. We
> could find a way to avoid passing prog but I think it's important for
> the logs.

record_relo_core can be moved out of bpf_core_apply_relo(). It only
needs prog and relo. It can be called as an alternative to
bpf_core_apply_relo() if gen_loader is set.

> - obj->btf_vmlinux_override needs to be set in order to calculate the
> core relocations. It's only set in bpf_object__relocate_core() but
> we're not using this function. I created and exposed a
> bpf_object_set_vmlinux_override() function to bpftool.

ok, this one I'm confused with. btf_custom_path in
bpf_object_open_opts doesn't work?..

> - There are also some naming complications but we can discuss them
> when I send the patch.
>
> I'm going to polish a bit more and finish rebasing on top of "CO-RE in
> the kernel" changes to then send the patch. Please let me know if you
> have any big concerns regarding my points above.
>

ok

> > At this point, we can teach bpftool to just take btf_ext (from BPF
> > object file), iterate over all CO-RE relos and call only
> > bpf_core_calc_relo() (no instruction patching). Using
> > bpf_core_relo_res bpftool will know types and fields that need to be
> > preserved and it will be able to construct minimal btf. So interface
> > for bpftool looks like this:
> >
> >    bpftool gen distill_btf (or whatever the name) <file.bpf.o>
> > <distilled_raw.btf>
> >
> > BTFGen as a solution, then, can use bpftool to process each pair of
> > btf + bpf object.
> >
> > Thoughts?
>
> I have the feeling that it could be easier to extend
> bpf_object__relocate_core() to be able to calculate the core
> relocations without patching the instructions (something similar to
> what we did in v1). bpftool could pass two parameters to gather this
> information and the normal libbpf workflow could just pass NULL to
> indicate the instructions should be actually patched. I think this
> could help specially with the difficulty to get the prog argument from
> bpftool (we are almost implementing the same logic present on
> bpf_object__relocate_core() to get sec_idx, prog and so on).  Does it
> make any sense to you?

No, not really, see above. It might be a slightly smaller amount of
refactoring to achieve this, but will make for more complicated code,
I think. Let's try the original approach, see my suggestions above.
Seems like everything is pretty straightforward at this point.

>
> Thanks!
>
> > [...]
