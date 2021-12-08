Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602FE46C87F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbhLHAM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhLHAM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:12:26 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43D5C061574;
        Tue,  7 Dec 2021 16:08:55 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id e136so1925901ybc.4;
        Tue, 07 Dec 2021 16:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IOTLCyGsqH0ywp1lXJ/bYKa97w4jYJfpHJ73cdFeoWA=;
        b=exNgfelxy1c/fMR2+X6YhZXeSdpyzp5JSdJdPjCr1bWOQ6pzYG39kKFLz7nDOgIWED
         Vb5DN+DAQkuRF8IrNb/YQyejqA7ZHskcSqCcaycjHqdjsigwoBf2IBt8bPXGMyJrqJr+
         G0upqdcwaYtPIdYLMG6WgwsZ83p7mkk9FzJgQnf5LPTKQXpALQjV+wv8XZmemdkGxw74
         uGWLCdnaOTxRhQUyKGK07gWaPKurdgqlVUIuTfh/nVRbZ8KPpRn2hpWpo9ePf0cMDXmu
         YDwn2ufdS7VNPp/WIQzJFeuTHzUEn27QlZMUiKeXkIx3Y5scKUNnBt8AYAgJwX8W2TYg
         svSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IOTLCyGsqH0ywp1lXJ/bYKa97w4jYJfpHJ73cdFeoWA=;
        b=211RkJUhzHB4QXdKqncOrw19DgljbxsIWwR1DkGJyuaCfbA0jW2eiYdge/sWpneceu
         Lja0N/bQZYSHZivb///paAH4LGnk4/BRM6/4LiBpbtfxDcoD9N2HVIu/zn+MuJvR8Z80
         l8dKX1X7yN6WFooRwJM6+vjL9GEWB6F0w+r7wSSXpsOuSpJDDaECCZ9NCCByTUkWF596
         DjS8F+0loYW4kP3uLrXP+/G0VgRRNMmlId8VhgINlvdAAoiIXW5Bkr3mUlVMqCpABa+8
         y7wTtIk4l5bapIziNmkZedNkWQoAbtriwrHpeE1NGNe7v2Y0UhnnGFJpJ/J56PPxR6Xb
         MulA==
X-Gm-Message-State: AOAM532mxds1aLGf8TYepEfg/RHDnIGkq0nfZGG9/+qVKFhlqFLvf3F3
        rr6H/Srepl2jKKHUu36sKTRkt4/lMzReruFfjEg=
X-Google-Smtp-Source: ABdhPJxPES6KwHJrKb/hNluZLnoHyT9MBMtEgnSO2RgqXsr94lUmTbCOjMloSPW9BmJe1YSh0rShMDvpBT+0aXr53GA=
X-Received: by 2002:a5b:1c2:: with SMTP id f2mr55982787ybp.150.1638922134976;
 Tue, 07 Dec 2021 16:08:54 -0800 (PST)
MIME-Version: 1.0
References: <20201110011932.3201430-1-andrii@kernel.org> <20201110011932.3201430-4-andrii@kernel.org>
 <B51AA745-00B6-4F2A-A7F0-461E845C8414@fb.com> <SN6PR11MB2751CF60B28D5788B0C15B5AB5E30@SN6PR11MB2751.namprd11.prod.outlook.com>
 <CAEf4BzYSN+XnaA4V3jTLEmoUZO=Yxwp7OAwAY+HOvVEKT5kRFA@mail.gmail.com>
 <20201116132409.4a5b8e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <1637926692.uyvrkty41j.astroid@nora.none>
In-Reply-To: <1637926692.uyvrkty41j.astroid@nora.none>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Dec 2021 16:08:43 -0800
Message-ID: <CAEf4BzZrVT3Mn2oL6kx2E2jdM_mTLX9FfhYsYw8va8_1VNftaQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/5] kbuild: build kernel module BTFs if BTF
 is enabled and pahole supports it
To:     =?UTF-8?Q?Fabian_Gr=C3=BCnbichler?= <f.gruenbichler@proxmox.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Starovoitov, Alexei" <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 7:16 AM Fabian Gr=C3=BCnbichler
<f.gruenbichler@proxmox.com> wrote:
>
> On November 16, 2020 10:24 pm, Jakub Kicinski wrote:
> > On Mon, 16 Nov 2020 12:34:17 -0800 Andrii Nakryiko wrote:
> >> > This change, commit 5f9ae91f7c0d ("kbuild: Build kernel module BTFs =
if BTF is enabled and pahole
> >> > supports it") currently in net-next, linux-next, etc. breaks the use=
-case of compiling only a specific
> >> > kernel module (both in-tree and out-of-tree, e.g. 'make M=3Ddrivers/=
net/ethernet/intel/ice') after
> >> > first doing a 'make modules_prepare'.  Previously, that use-case wou=
ld result in a warning noting
> >> > "Symbol info of vmlinux is missing. Unresolved symbol check will be =
entirely skipped" but now it
> >> > errors out after noting "No rule to make target 'vmlinux', needed by=
 '<...>.ko'.  Stop."
> >> >
> >> > Is that intentional?
> >>
> >> I wasn't aware of such a use pattern, so definitely not intentional.
> >> But vmlinux is absolutely necessary to generate the module BTF. So I'm
> >> wondering what's the proper fix here? Leave it as is (that error
> >> message is actually surprisingly descriptive, btw)? Force vmlinux
> >> build? Or skip BTF generation for that module?
> >
> > For an external out-of-tree module there is no guarantee that vmlinux
> > will even be on the system, no? So only the last option can work in
> > that case.
>
> a year late to the party, but it seems to me that this patch

hi, sorry, you email slipped through the cracks initially, just
getting back to it...

> series/features also missed another, not yet fixed scenario. I have to
> admit I am not very well-versed in BTF/BPF matters though, so please
> take the analysis below with a grain of salt or two ;)
>
> (am subscribed to LKML/netdev, but not the bpf list, so please keep me
> CCed if discussion moves there! apologies if too many people are CCed
> here, feel free to trim down to relevant people/lists)
>
> many distros do their own tracking of kernel <-> module ABI (usually
> these checks use Module.symvers and some combination of lists/symbols/..
> to skip/ignore[0]).
>
> depending on detected changes, a kernel update can either
> - bump ABI, resulting in a new kernel/modules package that is installed
>   next to the current one
> - keep ABI, resulting in an updated kernel/modules package that is
>   installed over/instead of the current one
>
> the former case is obviously not an issue, since the modules and vmlinux
> image shipped in that (set of) package(s) match. but in the later case
> of updated, compatible kernel image + modules with unchanged ABI
> (which is important, as it allows shipping fixed modules that are
> loadable for a compatible, older, booted kernel image), the following is
> possible:
> - install kernel+modules with ABI 1
> - boot kernel with ABI 1
> - install ABI-compatible upgrade (e.g. a security fix)
> - load module
> - BTF validation fails, because the base_btf (loaded at boot time) and
>   the offsets in the module's .BTF section (loaded at module load time)
>   aren't matching
>
> of course the validation might also not fail but the parsed BTF info
> might be bogus, or the base_btf might be similar enough that validation
> passes and the parsed BTF data is correct.
>
> in our case the symptoms look like this (exact details vary with kernel
> builds/modules, but likely not relevant):
>
> Nov 24 11:39:11 host kernel: BPF:         type_id=3D7 bits_offset=3D0
> Nov 24 11:39:11 host kernel: BPF:
> Nov 24 11:39:11 host kernel: BPF:Invalid name
> Nov 24 11:39:11 host kernel: BPF:
> Nov 24 11:39:11 host kernel: failed to validate module [overlay] BTF: -22
>
> where the booted kernel and the (attempted to get) loaded module are not
> from the same build, but the Module.symvers is matching and loading
> should thus work. adding some more debug logging reveals that the root
> cause is the module's BTF start_str_off being, well, off, since it's deri=
ved
> from vmlinux' BTF/base_btf. if it is too big, the name/type lookups will
> wrongly look in the base_btf, if it's too small, the name/type lookups
> will be offset within the module or wrongly look inside the module when
> they should look inside base_btf/vmlinux. in any case, random garbage is
> the result, usually tripping up some validation check (e.g. the first
> byte not being 0 when checking a name). but even if it's correct (old
> and new vmlinux image have the same nr_types/hdr.str_len), there is no
> guarantuee that the offsets into base_btf are pointing at the right
> stuff.
>
> example with debug logging patched in, note the garbled names, and
> offset slightly below the (wrong) start_str_off:
>
> ----8<----
>
> BPF:magic: 0xeb9f
>
> BPF:version: 1
>
> BPF:flags: 0x0
>
> BPF:hdr_len: 24
>
> BPF:type_off: 0
>
> BPF:type_len: 9264
>
> BPF:str_off: 9264
>
> BPF:str_len: 5511
>
> BPF:btf_total_size: 14799
>
> BPF:[106314] STRUCT rimary_device
> BPF:size=3D56 vlen=3D14
> BPF:
>
> BPF:offset at call: 1915394
> BPF:offset too small, choosing base_btf: 1915397
>
> BPF:offset after base_btf: 1915394
>
> BPF:     ce type_id=3D49 bits_offset=3D0
> BPF:
>
> BPF:offset at call: 1915403
> BPF:offset after base_btf: 6
>
> BPF:     nfig type_id=3D49 bits_offset=3D64
> BPF:
>
> BPF:offset at call: 1915412
> BPF:offset after base_btf: 15
>
> BPF:     rdir type_id=3D49 bits_offset=3D128
> BPF:
>
> BPF:offset at call: 768428
> BPF:offset too small, choosing base_btf: 1915397
>
> BPF:offset after base_btf: 768428
>
> BPF:     _dio type_id=3D56 bits_offset=3D192
> BPF:
>
> BPF:offset at call: 1915420
> BPF:offset after base_btf: 23
>
> BPF:     erdir type_id=3D56 bits_offset=3D200
> BPF:
>
> BPF:offset at call: 1915433
> BPF:offset after base_btf: 36
>
> BPF:first char wrong - 0
>
> BPF:      type_id=3D56 bits_offset=3D208
> BPF:
> BPF:Invalid name STRUCT MEMBER (name offset 1915433)
> BPF:
>
> failed to validate module [overlay] BTF: -22
>
> ---->8----
>
> also note how it's only after a few botched entries that a check
> actually trips up - not sure what the impliciations for crafted BTF info
> are, but might be worthy a closer look by someone more knowledgable as
> well..
>
> it seems to me this can be solved on the distro/user side by tracking
> vmlinux BTF infos as part of the ABI tracking (how stable are those
> compared to the existing interfaces making up the kernel <-> module
> ABI/Module.symvers? does this effectively mean bumping ABI for any

Yes, I think so, unfortunately. Any change in order of types emitted
by DWARF or any extra string might cause a big change in string
offsets or type IDs.


> change anyway?) or by disabling CONFIG_DEBUG_INFO_BTF_MODULES.
>
> on the kernel/libbpf side it could maybe be solved by storing a hash of
> the base_btf data used to generate the split BTF-sections inside the
> modules, and skip BTF loading/validating if another base_btf is
> currently loaded (so BTF is best-effort, if the booted kernel and the
> module are matching it works, if not module loading works but no BTF
> support). this might be a good safe-guard for split-BTF in general?
>
> I'd appreciate input on how to proceed (we were recently hit by this in
> a downstream Debian derivative, and will disable BTF info for modules as
> an interim measure).
>

Yeah, I think "BTF is best-effort" is a necessity for the complicated
setups you described above. It probably is good to keep strict
behavior (BTF fails to load -> fail loading the module), but allow you
to tune it with the Kconfig option. Most modules probably would be
just fine without its BTF loaded successfully.

As for the check sums, this would add another layer of protection, so
I think storing base vmlinux BTF checksum in some special ELF section
in module' ELF (e.g. ".BTF.base_checksum" or something along those
lines) is also a good idea and would be easy to implement. Insmod and
related tooling might even provide a validation check that vmlinux BTF
matches module's expectation, if necessary.

> thanks!
>
> 0: e.g., Debian's: https://salsa.debian.org/kernel-team/linux/-/blob/mast=
er/debian/bin/abiupdate.py
>
