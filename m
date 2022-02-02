Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44AC4A6BDA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245013AbiBBGxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244736AbiBBGwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:52:37 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD1CC061779;
        Tue,  1 Feb 2022 22:45:25 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id y84so24297526iof.0;
        Tue, 01 Feb 2022 22:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=99PdMSG7fssDvFf9N097p0XNVEdHq9damvGoLVqvdd4=;
        b=dlVwBGPODkKb2hdVy+RFna1f85hfrd8o3Ho0QhBARg7u9l3AJ36hq434T8O4GRH3Bi
         7RG5BBiSCUim057fW3I9gmJdpD1opz1dtEdu2qq9Q1WYuG04GTTZJzMWUys82gJ2kuGP
         v4b5E0s1D00AesONdiJUnVwKeLVZJ+3MA8/4dVJrWcFOvjf+1wNgJVpHbC6Ym3vyV299
         ghH6BE3VaeIHHExVmdrbe9Za47I30vEkFxPS8dPcyTG/EDVQE4EhmR0CEthTTzkd9YCB
         1qFWXJLR1EAYRHExscmVmR6dkNqwo2PUZm66mol/HsoLqoLUYduIQO6F/dIPBZBgA4wC
         3tIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=99PdMSG7fssDvFf9N097p0XNVEdHq9damvGoLVqvdd4=;
        b=4KPXaw9mHpraX4Q29NQzlLTdgiItZ9L46ztjCJB4r8cW1YI7TqX3+8x1gs5V2/QIVb
         tvzO41NGzCukIQaJm3nBAa6ItdspyL5vqZubGakYyIAjr4fkSavfWIYHw0C4loXGhtqT
         ZaCuIH/2qWpRT6s8NcBOzhOY54f8CSDHKeTxRu3quv2RAas8zGd+4KvreV292Vldz2v2
         mW/MATlCp0ot6cSnEVR2SMO/rn5kPm8ZSk33Fuz65GPSBLsP7DxoAkZW/oG3bcAYGysK
         K8MGgWsZ10x4osh4DqM42uAla5T7I43gjTbr+O9WvIC4WJLsfHNwtrKvbmx/3e42/woR
         G/FA==
X-Gm-Message-State: AOAM532Jl+tP3H3hchs9g9jn4ZvaL6haV0BayIiynXFgcI+oXWsl9kus
        C6zZHpwo78I6lLQOYNXSmG5ia5vbrf8g8ozgO1YZAfab
X-Google-Smtp-Source: ABdhPJyXBUn6EE7VrnC4QXCLuHj6nBPcboBldShJpWMbYStfQ3wigiLdDyaESZGNveeBCHA2tGVYKqA5qE2hhwsntvE=
X-Received: by 2002:a05:6602:2e88:: with SMTP id m8mr9299800iow.79.1643784325226;
 Tue, 01 Feb 2022 22:45:25 -0800 (PST)
MIME-Version: 1.0
References: <CAEf4BzYbbPT_og-_GGQYpsRmpBGRC-c1Xe8=QDybK243DhiKAQ@mail.gmail.com>
 <20220202023616.4687-1-houtao1@huawei.com>
In-Reply-To: <20220202023616.4687-1-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Feb 2022 22:45:14 -0800
Message-ID: <CAEf4BzY_BGV_8d8+gUMva6dpnHq=JSo8oU0p3tc_o=7ii2gU4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: use getpagesize() to initialize
 ring buffer size
To:     Hou Tao <hotforest@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hou Tao <houtao1@huawei.com>, Martin Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 1, 2022 at 6:36 PM Hou Tao <hotforest@gmail.com> wrote:
>
> Hi,
>
> > >
> > > Hi Andrii,
> > >
> > > > >
> > > > > 4096 is OK for x86-64, but for other archs with greater than 4KB
> > > > > page size (e.g. 64KB under arm64), test_verifier for test case
> > > > > "check valid spill/fill, ptr to mem" will fail, so just use
> > > > > getpagesize() to initialize the ring buffer size. Do this for
> > > > > test_progs as well.
> > > > >
> > > [...]
> > >
> > > > > diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
> > > > > index 96060ff4ffc6..e192a9f16aea 100644
> > > > > --- a/tools/testing/selftests/bpf/progs/ima.c
> > > > > +++ b/tools/testing/selftests/bpf/progs/ima.c
> > > > > @@ -13,7 +13,6 @@ u32 monitored_pid = 0;
> > > > >
> > > > >  struct {
> > > > >         __uint(type, BPF_MAP_TYPE_RINGBUF);
> > > > > -       __uint(max_entries, 1 << 12);
> > > >
> > > > Should we just bump it to 64/128/256KB instead? It's quite annoying to
> > > > do a split open and then load just due to this...
> > > >
> > > Agreed.
> > >
> > > > I'm also wondering if we should either teach kernel to round up to
> > > > closes power-of-2 of page_size internally, or teach libbpf to do this
> > > > for RINGBUF maps. Thoughts?
> > > >
> > > It seems that max_entries doesn't need to be page-aligned. For example
> > > if max_entries is 4096 and page size is 65536, we can allocate a
> > > 65536-sized page and set rb->mask 4095 and it will work. The only
> > > downside is 60KB memory is waster, but it is the implementation
> > > details and can be improved if subpage mapping can be supported.
> > >
> > > So how about removing the page-aligned restraint in kernel ?
> > >
> >
> > No, if you read BPF ringbuf code carefully you'll see that we map the
> > entire ringbuf data twice in the memory (see [0] for lame ASCII
> > diagram), so that records that are wrapped at the end of the ringbuf
> > and go back to the start are still accessible as a linear array. It's
> > a very important guarantee, so it has to be page size multiple. But
> > auto-increasing it to the closest power-of-2 of page size seems like a
> > pretty low-impact change. Hard to imagine breaking anything except
> > some carefully crafted tests for ENOSPC behavior.
> >
>
> Yes, i know the double map trick. What i tried to say is that:
> (1) remove the page-aligned restrain for max_entries
> (2) still allocate page-aligned memory for ringbuf
>
> instead of rounding max_entries up to closest power-of-2 page size
> directly, so max_entries from userspace is unchanged and double map trick
> still works.

I don't see how. Knowing the correct and exact size of the ringbuf
data area is mandatory for correctly consuming ringbuf data from
user-space. But if I'm missing something, feel free to give it a try
and see if it actually works.

>
> > [0] https://github.com/torvalds/linux/blob/master/kernel/bpf/ringbuf.c#L73-L89
>
> > > Regards,
> > > Tao
>
