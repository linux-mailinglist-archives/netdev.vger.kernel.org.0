Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9796C1A0518
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 05:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgDGDDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 23:03:11 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:32886 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDGDDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 23:03:11 -0400
Received: by mail-qv1-f68.google.com with SMTP id p19so1200752qve.0;
        Mon, 06 Apr 2020 20:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WbDQfGvEy3c+QsymmHuU9VuBimtHN8oEIU7+9lLArc4=;
        b=p/PfBoJyxYLgAL7DpO2DiaqoAthU9Vj8oIThZBHE6SrQi6Lu7SV1VH2iy70QOkUhUV
         a01ar+q4vBMZ3FHweRJ0LLJAOlQ8Aa155uANk4E/Gip6yLH+C5Q47mHxPPS61xIsq7j7
         +OnmlkuPmh5nzp0Ku0zmTg/l02kcmuKiSBQqD5dte71T4wt07rLfDdEHYOCGlI0ShGOL
         1ceGbtozMUPM7EaQB5rLza3rwVtcoeNH1zhMdlnWetBrQ7ZWFc9xI04/ashwDz8JJ/Ir
         UQvTcE0jl4WgMhjQr9D1L1nH3UwmaKZi+Djf0s2nc43IBHvRJPVMVd+Uih8hLlpyzt/n
         cBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WbDQfGvEy3c+QsymmHuU9VuBimtHN8oEIU7+9lLArc4=;
        b=km9VAiq24eTjE8tq6JodC06SKV8t1+LqauCRuOJliWHlF77ismiJEs75ta5yaR/7OQ
         wgLHz54f4b3JMxJylrM8mCVVhsY7dfqKBYo5HR9Srk+sYIWhb0PZyU70hTrzLMjTP9tA
         wN1IOjGtBoCVbq0YQkE1tccV3JKjTg+HlScrgFe5kgWhr3nuQbfJklvc04lz8FcvZ9Fn
         O2t6+NXYyUeb6wv6duSW5ztOKcJjYP9kJe0A4QOE/0opkm4sb+NVtC8yWdy6mt73Jyzx
         phBE4iyxlUFTYu5gbITA/q7zKfVy0JvFo17TeQwk3y5x2UOVMXMIyQceWPvB9CegvxX4
         CWpQ==
X-Gm-Message-State: AGi0PubHRwdFupcfG+uDJ8d119GphTr2Tf43PcKDIT01Ru2h4mUv+Y1P
        NeT3N36DyfrqgvAmM1BVEUw=
X-Google-Smtp-Source: APiQypJiM+/r3UVLurkIOflQr4v2CwWGsWYEyBhzFkSz7uthu+E8O0lVRfLfbF48zkNXI9oUQawKMQ==
X-Received: by 2002:a05:6214:11f4:: with SMTP id e20mr219186qvu.66.1586228589598;
        Mon, 06 Apr 2020 20:03:09 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c091:480::84df])
        by smtp.gmail.com with ESMTPSA id v49sm10897919qtv.82.2020.04.06.20.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 20:03:08 -0700 (PDT)
Date:   Mon, 6 Apr 2020 20:03:03 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Matt Cover <werekraken@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Cover <matthew.cover@stackpath.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Subject: Re: unstable bpf helpers proposal. Was: [PATCH bpf-next v2 1/2] bpf:
 add bpf_ct_lookup_{tcp,udp}() helpers
Message-ID: <20200407030303.ffs7xxruuktss5fs@ast-mbp.dhcp.thefacebook.com>
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com>
 <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
 <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
 <CAGyo_hprQRLLUUnt9G4SJnbgLSdN=HTDDGFBsPYMDC5bGmTPYA@mail.gmail.com>
 <20200130215330.f3unziderf5rlipf@ast-mbp>
 <CAGyo_hrYhwzVRcyN22j_4pBAcVGaazSu2xQFHT_DYpFeHdUjyA@mail.gmail.com>
 <20200220044505.bpfvdrcmc27ik2jp@ast-mbp>
 <CAGyo_hrcibFyz=b=+y=yO_yapw=TbtbO8d1vGPSLpTU0Y2gzBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGyo_hrcibFyz=b=+y=yO_yapw=TbtbO8d1vGPSLpTU0Y2gzBw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 04:56:01PM -0700, Matt Cover wrote:
> > I think doing BTF annotation for EXPORT_SYMBOL_BPF(bpf_icmp_send); is trivial.
> 
> I've been looking into this more; here is what I'm thinking.
> 
> 1. Export symbols for bpf the same as modules, but into one or more
>    special namespaces.
> 
>    Exported symbols recently gained namespaces.
>      https://lore.kernel.org/linux-usb/20190906103235.197072-1-maennich@google.com/
>      Documentation/kbuild/namespaces.rst
> 
>    This makes the in-kernel changes needed for export super simple.
> 
>      #define EXPORT_SYMBOL_BPF(sym)     EXPORT_SYMBOL_NS(sym, BPF_PROG)
>      #define EXPORT_SYMBOL_BPF_GPL(sym) EXPORT_SYMBOL_NS_GPL(sym, BPF_PROG)
> 
>    BPF_PROG is our special namespace above. We can easily add
>    BPF_PROG_ACQUIRES and BPF_PROG_RELEASES for those types of
>    unstable helpers.
> 
>    Exports for bpf progs are then as simple as for modules.
> 
>      EXPORT_SYMBOL_BPF(bpf_icmp_send);
> 
>    Documenting these namespaces as not for use by modules should be
>    enough; an explicit import statement to use namespaced symbols is
>    already required. Explicitly preventing module use in
>    MODULE_IMPORT_NS or modpost are also options if we feel more is
>    needed.
> 
> 2. Teach pahole's (dwarves') dwarf loader to parse __ksymtab*.
> 
>    I've got a functional wip which retrieves the namespace from the
>    __kstrtab ELF section. Working to differentiate between __ksymtab
>    and __ksymtab_gpl symbols next. Good news is this info is readily
>    available in vmlinux and module .o files. The interface here will
>    probably end up similar to dwarves' elf_symtab__*, but with an
>    struct elf_ksymtab per __ksymtab* section (all pointing to the
>    same __kstrtab section though).
> 
> 3. Teach pahole's btf encoder to encode the following bools: export,
>    gpl_only, acquires, releases.
> 
>    I'm envisioning this info will end up in a new struct
>    btf_func_proto in btf.h. Perhaps like this.
> 
>      struct btf_func_proto {
>          /* "info" bits arrangement
>           * bit     0: exported (callable by bpf prog)
>           * bit     1: gpl_only (only callable from GPL licensed bpf prog)
>           * bit     2: acquires (acquires and returns a refcounted pointer)
>           * bit     3: releases (first argument, a refcounted pointer,
> is released)
>           * bits 4-31: unused
>           */
>          __u32    info;
>      };
> 
>    Currently, a "struct btf_type" of type BTF_KIND_FUNC_PROTO is
>    directly followed by vlen struct btf_param/s. I'm hoping we can
>    insert btf_func_proto before the first btf_param or after the
>    last. If that's not workable, adding a new type,
>    BTF_KIND_FUNC_EXPORT, is another idea.

I don't see why 1 and 2 are necessary.
What is the value of true export_symbol here?
What is the value of namespaced true export_symbol?
Imo it only adds memory overhead to vmlinux.
The same information is available in BTF as a _name_.
What is the point to replicate it into kcrc?
Imo kcrc is a poor protection mechanism that is already worse
that BTF. I really don't see a value going that route.

I think just encoding the intent to export into BTF is enough.
Option 3 above looks like overkill too. Just name convention would do.
We already use different prefixes to encode certain BTFs
(see struct_ops and btf_trace).
Just say when BTF func_proto starts with "export_" it means it's exported.
It would be trivial for users to grep as well:
bpftool btf dump file ./vmlinux |grep export_

> 
> The crcs could be used to improve the developer experience when
> using unstable helpers.

crc don't add any additional value on top of BTF. BTF types has to match exactly.
It's like C compiler checking that you can call a function with correct proto.
