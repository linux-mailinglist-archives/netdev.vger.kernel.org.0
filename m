Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBDC4579BB
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 00:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhKSXy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhKSXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 18:54:26 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060ACC061574;
        Fri, 19 Nov 2021 15:51:24 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso10076534pjb.2;
        Fri, 19 Nov 2021 15:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ffhLH0NwpgWw7E9Yn9HnKis1gEoPIxlbU3f/JfNHwEA=;
        b=VF0uTo9HspY6wdi0StIQLi0ZaTQ10ngLqMLkt2VvlRyTErcxXzM3rv9LoPoo/aieAq
         /UNrtpWqZs6NGz4v7eFFpDve8RHu9C1kpzkWKg+pX4qFT78feMe4pKSwlNwcqv7OzIDj
         3smgNNoSo/tSHNzA7EeTTFTnuzANSh5BdL701jBMk7zS2+hclSd6va4ZBE9D3F7ijmoz
         KjH1gx5ueuuUO3swBIN0CJ+pZJIq2XZ7j5ffnYlxJ87jzNV4VaNTmYBv9Y43nzLju/4k
         nHrROMkWAk/P6WOqVQUufiiovROJwHkpktsfrY4Z+NE3hqg0cjzoYMfCNg1OuiArkB3K
         3h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ffhLH0NwpgWw7E9Yn9HnKis1gEoPIxlbU3f/JfNHwEA=;
        b=HYv9EcvCNlnVv2IHiqX8NCigbUhFwuJ/jjxfyo6nYdkRzZ9GTIrrooaqFdEP/FHLrW
         27d34a7EIokJz5aVr5NQ+L3oLErV4iadxv9xXcvnSQz5CqeNPEORGlPIbtEAjeKaHOr6
         GnkX8W9Bqpa8SYBDdwJJT03bQwtW2IrWMmoUlgWSpexu4KgpQ9SCB1Jti0gd+PK9Ftbh
         DQ4U0alFmsWEj8oDxDoD7AGIEqpsEWEwQfCa0pwrzbFJv/zjLtxzgKbuzQwaxOvq3nvZ
         neL9hUfliaFWIycDGCI3ySnQK0M3qhThWSxHouKeDkk6gtnfTlvkyWmQrg0wlz6PfcYa
         KdUA==
X-Gm-Message-State: AOAM5318FGwDmT6z3bd82r3oAVZtc/Jln39OW20M1nBmvmSpJd7+VS5K
        nxHYO6tF9oRSV2kV5eXegnmytz9yVX8=
X-Google-Smtp-Source: ABdhPJzmm344D4RXCrLDJWc7Hy15wORJAA7VjQgFFKeNGHHEeSEsc2OnBzszg/+3SwXKjhoulZ43SA==
X-Received: by 2002:a17:90a:db81:: with SMTP id h1mr4789560pjv.46.1637365883457;
        Fri, 19 Nov 2021 15:51:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:a858])
        by smtp.gmail.com with ESMTPSA id qe12sm12708622pjb.29.2021.11.19.15.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 15:51:23 -0800 (PST)
Date:   Fri, 19 Nov 2021 15:51:21 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Mauricio =?utf-8?Q?V=C3=A1squez?= <mauricio@kinvolk.io>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Expose CO-RE relocation results
Message-ID: <20211119235121.kze7xiguhlcbzftc@ast-mbp.dhcp.thefacebook.com>
References: <20211116164208.164245-1-mauricio@kinvolk.io>
 <20211116164208.164245-5-mauricio@kinvolk.io>
 <CAEf4BzZ0pEXzEvArpzL=0qbVC65z=hmeVuP7cbLKk-0_Gv5Y+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzZ0pEXzEvArpzL=0qbVC65z=hmeVuP7cbLKk-0_Gv5Y+A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 09:25:03AM -0800, Andrii Nakryiko wrote:
> On Tue, Nov 16, 2021 at 8:42 AM Mauricio Vásquez <mauricio@kinvolk.io> wrote:
> >
> > The result of the CO-RE relocations can be useful for some use cases
> > like BTFGen[0]. This commit adds a new ‘record_core_relos’ option to
> > save the result of such relocations and a couple of functions to access
> > them.
> >
> > [0]: https://github.com/kinvolk/btfgen/
> >
> > Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
> > Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> > Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> > Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> > ---
> >  tools/lib/bpf/libbpf.c    | 63 ++++++++++++++++++++++++++++++++++++++-
> >  tools/lib/bpf/libbpf.h    | 49 +++++++++++++++++++++++++++++-
> >  tools/lib/bpf/libbpf.map  |  2 ++
> >  tools/lib/bpf/relo_core.c | 28 +++++++++++++++--
> >  tools/lib/bpf/relo_core.h | 21 ++-----------
> >  5 files changed, 140 insertions(+), 23 deletions(-)
> >
> 
> Ok, I've meditated on this patch set long enough. I still don't like
> that libbpf will be doing all this just for the sake of BTFGen's use
> case.
> 
> In the end, I think giving bpftool access to internal APIs of libbpf
> is more appropriate, and it seems like it's pretty easy to achieve. It
> might actually clean up gen_loader parts a bit as well. So we'll need
> to coordinate all this with Alexei's current work on CO-RE for kernel
> as well.
> 
> But here's what I think could be done to keep libbpf internals simple.
> We split bpf_core_apply_relo() into two parts: 1) calculating the
> struct bpf_core_relo_res and 2) patching the instruction. If you look
> at bpf_core_apply_relo, it needs prog just for prog_name (which we can
> just pass everywhere for logging purposes) and to extract one specific
> instruction to be patched. This instruction is passed at the very end
> to bpf_core_patch_insn() after bpf_core_relo_res is calculated. So I
> propose to make those two explicitly separate steps done by libbpf. So
> bpf_core_apply_relo() (which we should rename to bpf_core_calc_relo()
> or something like that) won't do any modification to the program
> instructions. bpf_object__relocate_core() will do bpf_core_calc_relo()
> first, if that's successful, it will pass the result into
> bpf_core_patch_insn(). Simple and clean, unless I missed some
> complication (happens all the time, but..)

I was thinking about such split as well, but for a different reason :)
Since we've discussed future kernel flag 'check what libbpf had done'
the idea is to use bpf_core_relo_res after first step and let kernel
look at insn to see whether libbpf relocated the insn the same way
as kernel is going to do.

Also I was thinking to pass struct bpf_core_spec [3] and
struct bpf_core_relo_res [2] as two arrays into bpf_core_calc_relo() to
reduce stack size, since reduction of BPF_CORE_SPEC_MAX_LEN to 32
is not enough when all kconfig debugs are on on some architectures.

I was planning to work on that as a follow up to my set.

In the light of BTFgen I was thinking whether bpf_core_relo_res should
be part of uapi returned by the kernel, but that is probably overkill.
