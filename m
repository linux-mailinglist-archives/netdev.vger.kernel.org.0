Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6511ED803
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 23:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgFCVWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 17:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFCVWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 17:22:44 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F33AC08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 14:22:44 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y18so4001388iow.3
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 14:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mforney-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Vd1tK7E4e8B2IJoSA0SswmHmJ19G2rVBFIVNVFG/X94=;
        b=giwJlAm6IcT7kr/NSD2Y2PEVgUTF1GkxDvtDYdMcfTOtsH8Qvykupu1wcGfjbv8pNv
         5vJgAsbKs526WBmmBr6aliR4qAcsGnj+jDKcfFqfLLj2VZriMgLDHDXiZndXcFsXU5kl
         N2wg9z0MRON7wos2mtwKzoVc4IiFjLNrxY2bdmvlbiPSIH2smUKLSh3E0tqjSEBvEj8k
         ZSwVhEtzTxyHSwCDcoUBy/0mUvh4oaZsA0LXOy4S+qw3cP7nv2RwMCYcSzg4RaPf3jCO
         I6iKh72CcIPrtNylbvuTf4dOTv+H+eZwJ+UH6eU2bC5Jvw9fFqYo4+wbPVMf5CnyuXzq
         CQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Vd1tK7E4e8B2IJoSA0SswmHmJ19G2rVBFIVNVFG/X94=;
        b=F9ofgB/SOz8pqloDNf1Gty3ZMNa5Intfi6LiKjwH4Oc3NphDqiEhDXTWZKiaHBnQu5
         9xNiQMIQIdbQvBNcwZdek4bj+zDbh7NAPr9oM6l1zBNvZo/K90qJ3B8y/5kA/FLTO7nE
         w6z3LSw5XoSwQCXWNYanML1XzxPayi8J6TBR0YpqkuKHMk1z2x86X2S+4Rf+KCa/EgMh
         T7gL5EVqmJJ1zW4ehJuh1N86iGjXW2prFsXCGKX/4fcjC6GlIvCrK+Fzv2mb3QrVRN6H
         tTo0mYvXMDSYmQLKDavuGeCuBE3rBT2kSrCnRNVkDMxMKuDN3Gs4l4fDqMcfu4DWibpN
         S+6A==
X-Gm-Message-State: AOAM532oExYdRz1okCJWaMTBaJIJromDc11dLigr0NWzUIHyEGsKcPhM
        rmS62ATAgopV3hlgmvnEvmIDEP2zenGzP4X0Gl3bww==
X-Google-Smtp-Source: ABdhPJyUv7TtObDa4+oi4CiavulBo96tgOsMZmelhqiT6FWh92m1tnV3EX2us6FKIicn1NINkALJXBxCfI7/DRp4rkI=
X-Received: by 2002:a5d:9242:: with SMTP id e2mr1433044iol.85.1591219363695;
 Wed, 03 Jun 2020 14:22:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6638:150:0:0:0:0 with HTTP; Wed, 3 Jun 2020 14:22:42
 -0700 (PDT)
X-Originating-IP: [73.70.188.119]
In-Reply-To: <CAADnVQLzQcUyi3Trtr0iT7gEhpSQYAH8WD5q+X8EmRwMYMzhbQ@mail.gmail.com>
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net> <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
 <87blpc4g14.fsf@toke.dk> <945cf1c4-78bb-8d3c-10e3-273d100ce41c@iogearbox.net>
 <CAGw6cBuCwmbULDq2v76SWqVYL2o8i+pBg7JnDi=F+6Wcq3SDTA@mail.gmail.com>
 <20200602191703.xbhgy75l7cb537xe@ast-mbp.dhcp.thefacebook.com>
 <CAGw6cBstsD40MMoHg2dGUe7YvR5KdHD8BqQ5xeXoYKLCUFAudg@mail.gmail.com>
 <20200602230720.hf2ysnlssg67cpmw@ast-mbp.dhcp.thefacebook.com>
 <CAGw6cBuF8Dj-22bH=ryL+17N48pwMD5hN49sH4AHYYyMm2xgtg@mail.gmail.com> <CAADnVQLzQcUyi3Trtr0iT7gEhpSQYAH8WD5q+X8EmRwMYMzhbQ@mail.gmail.com>
From:   Michael Forney <mforney@mforney.org>
Date:   Wed, 3 Jun 2020 14:22:42 -0700
Message-ID: <CAGw6cBvpe_pL4dPY8USuETe4jh2Aq24XPf6PkFKAYHmHCGE1jw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-02, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> ISO C forbids zero-size arrays, unnamed struct/union, gcc extensions,
> empty unions, etc
> So ?

So their use should be avoided in UAPI headers whenever possible.
While the other extensions are simple and have clear semantics, enums
with out-of-range values do not. Even gcc and clang don't agree on
what the types of out-of-range constants are within the enum
specifier:

	enum { A = 0x80000000ULL, is_clang =
__builtin_types_compatible_p(__typeof__(A), unsigned long long) };

On gcc x86_64, is_clang == 0. On clang x86_64, is_clang == 1.

> #define BPF_F_CTXLEN_MASK BPF_F_CTXLEN_MASK
> will only work as workaround for _your_ compiler.
> We are not gonna add hacks like this for every compiler.

This doesn't solve the problem, which is that after preprocessing,
BPF_F_INDEX_MASK and BPF_F_CURRENT_CPU, and BPF_F_CTXLEN_MASK are enum
constants with values that can't be represented as int. Changing them
back to defines will. This is not a hack, it is following the C
standard.

> and I still don't see how it breaks anything.
> If it was #define and .h switched its definition from 1 to 1ULL
> it would have had the same effect. That is the point of the constant in .h.
> Same effect regardless whether it was done via #define and via enum.
> The size and type of the constant may change. It's not uapi breakage.

My point is that something like

	unsigned long long x = BPF_DEVCG_DEV_BLOCK << 32;

used to be perfectly fine in Linux 5.6. Now, in 5.7 with the enum
definition, it is undefined behavior.

-Michael
