Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713E83FC00E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 02:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbhHaAhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 20:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhHaAhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 20:37:07 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE00BC061575;
        Mon, 30 Aug 2021 17:36:12 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id c206so11006314ybb.12;
        Mon, 30 Aug 2021 17:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n/UeFFlCa74EsS7IyYq7akak0tcCHnBJ1WNxtzu9DWA=;
        b=r84boiSRLGg153hJ86LESi0lg5jH93IFUiq9GEt8D+CSBKtOIMZz6EfNUoabp2UpOu
         cjjtvRbqGMX/3DJ5I+cA96aUWDdw9JdCPBWFwkoXLyUrIHJbl+OVRB1qkgBIGSsXOc13
         E7YBjkjAjW6aaNGr2jND7wnfSzPMQCTzB8LSwrqW7Z/OgZ3N69tRUXp1l5fGCTgJKMdd
         E6yrkY3AZ41PvnM2XVumKBezoTQhURfPIZ1m8yTJxdtXLQFR0xqX2alRBZs6MTJAB+5A
         JNACFDLEdMt1H1VbafMQ4X6BuhCZB7HVPlzeb5Gy3amT29wSFdd2t8E92vD662sPVoDo
         MUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n/UeFFlCa74EsS7IyYq7akak0tcCHnBJ1WNxtzu9DWA=;
        b=qYNhrTAz9qyIKxCNOpriLyTqm2l8s6WuZADjxyxCR2Mhv8tnVA5mog+SoGEKsJm+7o
         UC6o7Q0l40/m2rmdd616dnVgjNZ0gKeIOKSYbxDxxgZe1rB2o+251tDSgNVR4EtL/pq6
         VIMBx/aNAHHmF/AUhMSwaTd69dp816udIelciUHhsom/EclTgemxwo16XR4iRwt7FwZJ
         FxrbkO1ylXTw86A866mXRDguWgFpx6rTKqzyypQOcvjiu4wT19WziX8tKUZIN0vAwJuh
         uu1v4p7j+QKlVaAl33uOg+uQQ2EHKfOLHpG6J4rGXfyI5cBph6IpnjsD/nVVQ1pNTJOI
         F65A==
X-Gm-Message-State: AOAM5333iHepUqWLYOHPqPoWwAvMMzJx5u86XAIGLCdJgBfDcYHi2ieU
        mJlohhAswG6Jssplr8Aenab6GL49qy+O8PHi7nQ=
X-Google-Smtp-Source: ABdhPJw5w+EILsZ3B+ztvODPlZO7Oc4ajOGXbTqXHHp6udt7lm8crHHN3RZlnUC/V9/+8jH6Xw0ia2U88eZBEA1m02Y=
X-Received: by 2002:a25:ac7:: with SMTP id 190mr25683978ybk.260.1630370172162;
 Mon, 30 Aug 2021 17:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
 <20210828052006.1313788-5-davemarchevsky@fb.com> <3da3377c-7f79-9e07-7deb-4fca6abae8fd@fb.com>
 <20210829165714.wghn236g2ka7lgna@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210829165714.wghn236g2ka7lgna@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Aug 2021 17:36:01 -0700
Message-ID: <CAEf4Bzar9-ZLeponMHuU3ALUPGv4eKS-bObPzu_HO8BC+2KrQg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 4/7] libbpf: use static const fmt string in __bpf_printk
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Dave Marchevsky <davemarchevsky@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 9:57 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Aug 28, 2021 at 12:40:17PM -0400, Dave Marchevsky wrote:
> > On 8/28/21 1:20 AM, Dave Marchevsky wrote:
> > > The __bpf_printk convenience macro was using a 'char' fmt string holder
> > > as it predates support for globals in libbpf. Move to more efficient
> > > 'static const char', but provide a fallback to the old way via
> > > BPF_NO_GLOBAL_DATA so users on old kernels can still use the macro.
> > >
> > > Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> > > ---
> > >  tools/lib/bpf/bpf_helpers.h | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> > > index 5f087306cdfe..a1d5ec6f285c 100644
> > > --- a/tools/lib/bpf/bpf_helpers.h
> > > +++ b/tools/lib/bpf/bpf_helpers.h
> > > @@ -216,10 +216,16 @@ enum libbpf_tristate {
> > >                  ___param, sizeof(___param));               \
> > >  })
> > >
> > > +#ifdef BPF_NO_GLOBAL_DATA
> > > +#define BPF_PRINTK_FMT_TYPE char
> > > +#else
> > > +#define BPF_PRINTK_FMT_TYPE static const char
> >
> > The reference_tracking prog test is failing as a result of this.
> > Specifically, it fails to load bpf_sk_lookup_test0 prog, which
> > has a bpf_printk:
> >
> >   47: (b4) w3 = 0
> >   48: (18) r1 = 0x0
> >   50: (b4) w2 = 7
> >   51: (85) call bpf_trace_printk#6
> >   R1 type=inv expected=fp, pkt, pkt_meta, map_key, map_value, mem, rdonly_buf, rdwr_buf
> >
> > Setting BPF_NO_GLOBAL_DATA in the test results in a pass
>
> hmm. that's odd. pls investigate.

It's a broken reference_tracking selftest which uses direct calls into
bpf_program__load() API, which is not supposed to be used directly. In
this case bpf_program__load() doesn't apply any relocation for
.rodata, so verifier rightfully complains that constant zero is not
really a valid pointer to memory. It's a plan for libbpf 1.0 to hide
bpf_program__load() (which is supposed to be used only internally by
libbpf). And it's surprising that we have a test using that API
directly, it somehow slipped by us.

Dave, can you please switch this selftest to use bpf_object__load()
properly? This seems to be the only selftests that's using
bpf_program__load(). You'll probably need to open/iterate
programs/bpf_progam__set_autoload() properly based on
name/bpf_object__load() in a loop for each BPF prog to be tested.


> Worst case we can just drop this patch for now.
> The failing printk is this one, right?
> bpf_printk("sk=%d\n", sk ? 1 : 0);
> iirc we had an issue related to ?: operand being used as an argument
> and llvm generating interesting code path with 'sk' and the later
> if (sk) bpf_sk_release(sk);
> would not be properly recognized by the verifier leading it to
> believe that sk may not be released in some cases.
> That printk was triggering such interesting llvm codegen.
> See commit d844a71bff0f ("bpf: Selftests, add printk to test_sk_lookup_kern to encode null ptr check")
