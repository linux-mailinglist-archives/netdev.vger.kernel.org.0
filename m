Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D511A068E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 07:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgDGF23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 01:28:29 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:37063 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgDGF23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 01:28:29 -0400
Received: by mail-vs1-f67.google.com with SMTP id o3so1447348vsd.4;
        Mon, 06 Apr 2020 22:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrrS0Lhv15zxlqz1Gg8dhCo/1YDYxqP75f329M6pi8g=;
        b=ecWsFgYxhiIQvqETzF0YU62LFUUJpET9TBMlx/sk0c/jmfFnFtkHFuLXoVMQp+seqm
         tZY9UvlZV2xPSiTnbMjOIKzecJoipBK3eq+WrxAqCuKugzMrywczIyV873todT6OwFTB
         ZmYRz+/xWizAbFXs6k4ygl5JIz/MZVUsdpXt+6t4c1Mp7xWqBLV2smPPAlh+tleZpumK
         CNXkCgYtlkHYKrckeC+MywD0XH9ALgIQfiZUEHPUF133dLOhEXYfr4ISPgK0w9d1bfTg
         yqvFxzq+HoEfqpICa2k4OwxaxX1GVetOHFZmTJXlx826yeBuQ93SkA6N7TVVG38FSU+c
         PJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrrS0Lhv15zxlqz1Gg8dhCo/1YDYxqP75f329M6pi8g=;
        b=N268/RZ1MAP4EJM+hdjXfS2/iInM2HyWeb0DCf5kveGaooGVHb0iOCcWwGl0bnYOXR
         ZOQRPgR0tvARyqH4NB7Ljn60gGxbbXA76MBNkHAfhlPgLvPR3lPouXHS586dVCl2cAZN
         YvQiveV7pCthSKrLDy2M1Dad2YroflKLJh/dqgFqTZ395PMraUYxH/0gwJAJiNI+s7EN
         EmnLRlDCEHt4qokR5uIHzDUKkoHDiXHcp8wUX0n5H7zCjXo+y2DHqmGaDpXMGmq7fmQ7
         L1t62BS3Pi6QHoVx9axNT3+1p/CjUVLH/KStMrSTFrTVjpXpi8UHZhLwgfhsE3gZX7Mx
         plCg==
X-Gm-Message-State: AGi0PuYjCzoZqx1JgrUYhZtLQ6EJG2oXYgLtpNd+nvHPAKcC/4FOVOAI
        M8fOtA/F0LDsamkyBnZb6YELwPYwFswzd6LwYvk=
X-Google-Smtp-Source: APiQypIby2UXjuX8vOzjjgILvfC+AKaKfIeOVqPZMgfFRa7+1YoghBkUDH/75MUxC3ZBPdUOACQWBqcCuCYnrY88pSE=
X-Received: by 2002:a67:fd6f:: with SMTP id h15mr503854vsa.96.1586237306008;
 Mon, 06 Apr 2020 22:28:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com> <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
 <20200130215330.f3unziderf5rlipf@ast-mbp> <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
 <20200220044505.bpfvdrcmc27ik2jp@ast-mbp> <CAGyo_hrcibFyz=b=+y=yO_yapw=TbtbO8d1vGPSLpTU0Y2gzBw@mail.gmail.com>
 <20200407030303.ffs7xxruuktss5fs@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200407030303.ffs7xxruuktss5fs@ast-mbp.dhcp.thefacebook.com>
From:   Matt Cover <werekraken@gmail.com>
Date:   Mon, 6 Apr 2020 22:28:13 -0700
Message-ID: <CAGyo_hrYYYN6EXnbocauMo52pF52fAQwiJbDVZwH4NG3UC5anQ@mail.gmail.com>
Subject: Re: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf:
 add bpf_ct_lookup_{tcp,udp}() helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 8:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 03, 2020 at 04:56:01PM -0700, Matt Cover wrote:
> > > I think doing BTF annotation for EXPORT_SYMBOL_BPF(bpf_icmp_send); is trivial.
> >
> > I've been looking into this more; here is what I'm thinking.
> >
> > 1. Export symbols for bpf the same as modules, but into one or more
> >    special namespaces.
> >
> >    Exported symbols recently gained namespaces.
> >      https://lore.kernel.org/linux-usb/20190906103235.197072-1-maennich@google.com/
> >      Documentation/kbuild/namespaces.rst
> >
> >    This makes the in-kernel changes needed for export super simple.
> >
> >      #define EXPORT_SYMBOL_BPF(sym)     EXPORT_SYMBOL_NS(sym, BPF_PROG)
> >      #define EXPORT_SYMBOL_BPF_GPL(sym) EXPORT_SYMBOL_NS_GPL(sym, BPF_PROG)
> >
> >    BPF_PROG is our special namespace above. We can easily add
> >    BPF_PROG_ACQUIRES and BPF_PROG_RELEASES for those types of
> >    unstable helpers.
> >
> >    Exports for bpf progs are then as simple as for modules.
> >
> >      EXPORT_SYMBOL_BPF(bpf_icmp_send);
> >
> >    Documenting these namespaces as not for use by modules should be
> >    enough; an explicit import statement to use namespaced symbols is
> >    already required. Explicitly preventing module use in
> >    MODULE_IMPORT_NS or modpost are also options if we feel more is
> >    needed.
> >
> > 2. Teach pahole's (dwarves') dwarf loader to parse __ksymtab*.
> >
> >    I've got a functional wip which retrieves the namespace from the
> >    __kstrtab ELF section. Working to differentiate between __ksymtab
> >    and __ksymtab_gpl symbols next. Good news is this info is readily
> >    available in vmlinux and module .o files. The interface here will
> >    probably end up similar to dwarves' elf_symtab__*, but with an
> >    struct elf_ksymtab per __ksymtab* section (all pointing to the
> >    same __kstrtab section though).
> >
> > 3. Teach pahole's btf encoder to encode the following bools: export,
> >    gpl_only, acquires, releases.
> >
> >    I'm envisioning this info will end up in a new struct
> >    btf_func_proto in btf.h. Perhaps like this.
> >
> >      struct btf_func_proto {
> >          /* "info" bits arrangement
> >           * bit     0: exported (callable by bpf prog)
> >           * bit     1: gpl_only (only callable from GPL licensed bpf prog)
> >           * bit     2: acquires (acquires and returns a refcounted pointer)
> >           * bit     3: releases (first argument, a refcounted pointer,
> > is released)
> >           * bits 4-31: unused
> >           */
> >          __u32    info;
> >      };
> >
> >    Currently, a "struct btf_type" of type BTF_KIND_FUNC_PROTO is
> >    directly followed by vlen struct btf_param/s. I'm hoping we can
> >    insert btf_func_proto before the first btf_param or after the
> >    last. If that's not workable, adding a new type,
> >    BTF_KIND_FUNC_EXPORT, is another idea.
>
> I don't see why 1 and 2 are necessary.
> What is the value of true export_symbol here?

Hmm... I was under the impression that these functions had to be
exported to be eligible for BTF. Perhaps I'm misunderstanding this
dwaves commit:

  3c5f2a224aa1 ("btf_encoder: Preserve and encode exported functions
as BTF_KIND_FUNC")

Looking briefly I can see that the functions in symvers and BTF are
not an exact match. Does "exported functions" in the above commit
message not mean "exported symbols"?

It looks like BTF FUNCs line up perfectly with symbols marked 'T' and
'W' in kallsyms. I'll look into what adds a [TW] marked symbol to
kallsyms and see how this differs from symvers.

> What is the value of namespaced true export_symbol?

This simply seemed like a clean way to group the symbols under the
premise these functions already needed to be exported via
EXPORT_SYMBOL*.

> Imo it only adds memory overhead to vmlinux.
> The same information is available in BTF as a _name_.
> What is the point to replicate it into kcrc?

See below.

> Imo kcrc is a poor protection mechanism that is already worse
> that BTF. I really don't see a value going that route.
>

See below

> I think just encoding the intent to export into BTF is enough.
> Option 3 above looks like overkill too. Just name convention would do.
> We already use different prefixes to encode certain BTFs
> (see struct_ops and btf_trace).
> Just say when BTF func_proto starts with "export_" it means it's exported.
> It would be trivial for users to grep as well:
> bpftool btf dump file ./vmlinux |grep export_

Ok, cool. A naming convention could work (even if it turns out we do
have to EXPORT_SYMBOL).

>
> >
> > The crcs could be used to improve the developer experience when
> > using unstable helpers.
>
> crc don't add any additional value on top of BTF. BTF types has to match exactly.
> It's like C compiler checking that you can call a function with correct proto.

I can see that for the verifier BTF is much superior to crc. The
safety of the program is not improved by the crc. I was simply
thinking the crc could be used in struct variant selection instead
of kernel version. In some environments this could be useful since
distros often backport patches while leaving version old (often
meaning a second distro-specific version must also be considered).
