Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8DD6872EB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjBBBV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbjBBBV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:21:56 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E0E6951E;
        Wed,  1 Feb 2023 17:21:53 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id qw12so1829948ejc.2;
        Wed, 01 Feb 2023 17:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TAG69dfUt5/OAUZ8orlOzXEYsa/nKo7Gek9mumyz4aM=;
        b=iVydcuPsKZe8s26F1/REKnFrU0SvINS1Ai7QwfjxGByZmzXyCPf7852HtpD+OGXNyq
         5IpSQxPI2FTC8UehHx+iH3QbLzVEPkXevRM9GCv5ur+H8cmSMIJoq/L6r9ggl6I7RZZk
         KeyYFHKW80chmlGZOYPV7TCLKaVe7GqiqrxQ4HnBHVMFIOrspPaxMWDdVimUIxANFSVM
         Y17nhBwohco+KC4BXeVtcDWy1gdocWMkwD3xk6+hoWgvl0nuLe9dvpH/IwuBIuv1Kc4M
         v8nxRvS+Ya/lT4JHPxAFHrBB8hZwXqys1DXgytxLsLS83FqB1QiODj+jx342AsEZ/Bjw
         HdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TAG69dfUt5/OAUZ8orlOzXEYsa/nKo7Gek9mumyz4aM=;
        b=m+/VoLDBoV8uTlTkhbkMY0jZE34T2bctVJHmOPs4MCR2aOMAT2rjqLXQGt/XAC1L/q
         Q8SuB/1aA78ZZ2c4UcLdwRSqSOWargYTLEZSKOCnYI5OjjfK1AOsdyhY3SYh/ypiruJ+
         GV/w/S9jTHg6nq4GEXWrJe7c/naNFxIerLFm3TDkT1b4HwS3RX93tV+/1FmlQYmwbAcF
         1lBCvlN3sGja8GeaRvYhuJE+TVksxk0TVOAUEo5pZ1fqskbuP3Do729dZh/BYIq3UpPJ
         DU5q0TCx8ROYZqDdAgDjoT+n8n7Frq/UUYVmtPdrNT3XHyXlJaEPRa9NYdMjpzyqBy1W
         LA8Q==
X-Gm-Message-State: AO0yUKXsW2APQG2OeT+vAIJFotBfA7OcuHWIkaa8yOixaxOC5XBPLKNP
        cppn+rVPbrecdYfihY38DBPonEdvoOgRURAV3V4hOEJH
X-Google-Smtp-Source: AK7set9J4kZ7eGXmlz5A0g5t16uvVPJBa+3/kB83I6ddR0+u0KhBlsADn6eHSEg4L26b/mI4IsLo9Y0MM46EI6IjvU0=
X-Received: by 2002:a17:906:5609:b0:88d:5955:b59 with SMTP id
 f9-20020a170906560900b0088d59550b59mr1355624ejq.68.1675300911839; Wed, 01 Feb
 2023 17:21:51 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <4b7b09b5-fd23-2447-7f05-5f903288625f@linux.dev> <CAEf4BzaQJe+UZxECg__Aga+YKrxK9KEbAuwdxA4ZBz1bQCEmSA@mail.gmail.com>
 <20230131053042.h7wp3w2zq46swfmk@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4BzbeUfmE-8Y-mm4RtZ4q=9SZ-_M-K-JF=x84o6cboUneSQ@mail.gmail.com> <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
In-Reply-To: <20230201004034.sea642affpiu7yfm@macbook-pro-6.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 1 Feb 2023 17:21:39 -0800
Message-ID: <CAEf4BzbTXqhsKqPd=hDANKeg75UDbKjtX318ucMGw7a1L3693w@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Joanne Koong <joannelkoong@gmail.com>, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@kernel.org, ast@kernel.org,
        netdev@vger.kernel.org, memxor@gmail.com, kernel-team@fb.com,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 4:40 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 31, 2023 at 04:11:47PM -0800, Andrii Nakryiko wrote:
> > >
> > > When prog is just parsing the packet it doesn't need to finalize with bpf_dynptr_write.
> > > The prog can always write into the pointer followed by if (p == buf) bpf_dynptr_write.
> > > No need for rdonly flag, but extra copy is there in case of cloned which
> > > could have been avoided with extra rd_only flag.
> >
> > Yep, given we are designing bpf_dynptr_slice for performance, extra
> > copy on reads is unfortunate. ro/rw flag or have separate
> > bpf_dynptr_slice_rw vs bpf_dynptr_slice_ro?
>
> Either flag or two kfuncs sound good to me.

Would it make sense to make bpf_dynptr_slice() as read-only variant,
and bpf_dynptr_slice_rw() for read/write? I think the common case is
read-only, right? And if users mistakenly use bpf_dynptr_slice() for
r/w case, they will get a verifier error when trying to write into the
returned pointer. While if we make bpf_dynptr_slice() as read-write,
users won't realize they are paying a performance penalty for
something that they don't actually need.

>
> > > Yes and No. bpf_skb_store_bytes is doing pull followed by memcpy,
> > > while xdp_store_bytes does scatter gather copy into frags.
> > > We should probably add similar copy to skb case to avoid allocations and pull.
> > > Then in case of:
> > >  if (p == buf) {
> > >       bpf_dynptr_write(dp, buf, 16);
> > >  }
> > >
> > > the write will guarantee to succeed for both xdp and skb and the user
> > > doesn't need to add error checking for alloc failures in case of skb.
> > >
> >
> > That seems like a nice guarantee, agreed.
>
> Just grepped through few projects that use skb_store_bytes.
> Everywhere it looks like:
> if (bpf_skb_store_byte(...))
>    return error;
>
> Not a pretty code to read.
> I should prioritize bpf_assert() work, so we can assert from inside of
> bpf_dynptr_write() eventually and remove all these IFs.
>
> > > > >
> > > > > > But I wonder if for simple cases when users are mostly sure that they
> > > > > > are going to access only header data directly we can have an option
> > > > > > for bpf_dynptr_from_skb() to specify what should be the behavior for
> > > > > > bpf_dynptr_slice():
> > > > > >
> > > > > >   - either return NULL for anything that crosses into frags (no
> > > > > > surprising perf penalty, but surprising NULLs);
> > > > > >   - do bpf_skb_pull_data() if bpf_dynptr_data() needs to point to data
> > > > > > beyond header (potential perf penalty, but on NULLs, if off+len is
> > > > > > within packet).
> > > > > >
> > > > > > And then bpf_dynptr_from_skb() can accept a flag specifying this
> > > > > > behavior and store it somewhere in struct bpf_dynptr.
> > > > >
> > > > > xdp does not have the bpf_skb_pull_data() equivalent, so xdp prog will still
> > > > > need the write back handling.
> > > > >
> > > >
> > > > Sure, unfortunately, can't have everything. I'm just thinking how to
> > > > make bpf_dynptr_data() generically usable. Think about some common BPF
> > > > routine that calculates hash for all bytes pointed to by dynptr,
> > > > regardless of underlying dynptr type; it can iterate in small chunks,
> > > > get memory slice, if possible, but fallback to generic
> > > > bpf_dynptr_read() if doesn't. This will work for skb, xdp, LOCAL,
> > > > RINGBUF, any other dynptr type.
> > >
> > > It looks to me that dynptr on top of skb, xdp, local can work as generic reader,
> > > but dynptr as a generic writer doesn't look possible.
> > > BPF_F_RECOMPUTE_CSUM and BPF_F_INVALIDATE_HASH are special to skb.
> > > There is also bpf_skb_change_proto and crazy complex bpf_skb_adjust_room.
> > > I don't think writing into skb vs xdp vs ringbuf are generalizable.
> > > The prog needs to do a ton more work to write into skb correctly.
> >
> > If that's the case, then yeah, bpf_dynptr_write() can just return
> > error for skb/xdp dynptrs?
>
> You mean to error when these skb only flags are present, but dynptr->type == xdp ?
> Yep. I don't see another option. My point was that dynptr doesn't quite work as an
> abstraction for writing into networking things.

agreed

> While libraries like: parse_http(&dynptr), compute_hash(&dynptr), find_string(&dynptr)
> can indeed be generic and work with raw bytes, skb, xdp as an input,
> which I think was on top of your wishlist for dynptr.

yep, it would be a great property
