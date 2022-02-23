Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E118B4C0D52
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 08:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238581AbiBWHag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 02:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiBWHaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 02:30:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997334CD51;
        Tue, 22 Feb 2022 23:30:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44EBFB81B88;
        Wed, 23 Feb 2022 07:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05806C340EF;
        Wed, 23 Feb 2022 07:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645601405;
        bh=Dkd6HpeSMTigAZvycnaZpzuOsX23tcLFae4/dVqLXNE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=krtFsgc6sR4ui9l8fVo+0G9WaODd8Pu14fqc0ES1SDYNxb54fXw45SlHIKui3GAyF
         mg0btYXLsPPD8h09/V8K39GHCgsQd6H1h2TRs5y1D1XQQTQc66TMjKg0xOz17hW641
         D63KiDYZqZS9hoFOOCJBVWb2F9rsMRfKLsgYK0GwQ98M9E2gDWQ8KW/SprjgGPNseL
         tqY2U2gQuVHt7mdNjSSOaRxgZigtAXxd3a+j6lbd3FjkinO0KJs2vKZc7BzVzE1/2y
         Eprf+nTN6iA1YyA1Uck97qQ01L3LUBKF8Zqyn0lGQDst4yO/8VhynV22dXTSxrRl6W
         R3YPczqVL3Bug==
Received: by mail-yb1-f173.google.com with SMTP id c6so46171674ybk.3;
        Tue, 22 Feb 2022 23:30:04 -0800 (PST)
X-Gm-Message-State: AOAM532ij6y1iWL45KpUmXvoY/2uOH5ZKfM9bCWZ61CCglxFw/HEqmQH
        l7ah635bNlWVyBXZevFTGSknaSPgetcJC8eAqOc=
X-Google-Smtp-Source: ABdhPJxE0PG0FvLVsAwcfa4/OQXiVuMCCCvtSXHCHTVjC68djWs1HyayaXAW/8kxCsZf9rRtpU66Ybz1mNr/3mh26j4=
X-Received: by 2002:a05:6902:1ca:b0:624:e2a1:2856 with SMTP id
 u10-20020a05690201ca00b00624e2a12856mr4501694ybh.389.1645601404013; Tue, 22
 Feb 2022 23:30:04 -0800 (PST)
MIME-Version: 1.0
References: <20220220134813.3411982-1-memxor@gmail.com> <CAPhsuW53epuRQ3X5bYeoxRUL9sdEm7MUQ8bUoQCsf=C7k3hQ8A@mail.gmail.com>
 <20220222082129.yivvpm6yo3474dp3@apollo.legion>
In-Reply-To: <20220222082129.yivvpm6yo3474dp3@apollo.legion>
From:   Song Liu <song@kernel.org>
Date:   Tue, 22 Feb 2022 23:29:53 -0800
X-Gmail-Original-Message-ID: <CAPhsuW70ggLxKFopbKb9cr7WknqZW6utoSOLoLg4Yw971oD22g@mail.gmail.com>
Message-ID: <CAPhsuW70ggLxKFopbKb9cr7WknqZW6utoSOLoLg4Yw971oD22g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 00/15] Introduce typed pointer support in BPF maps
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 12:21 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
[...]


> >
> > I guess I missed some context here. Could you please provide some reference
> > to the use cases of these features?
> >
>
> The common usecase is caching references to objects inside BPF maps, to avoid
> costly lookups, and being able to raise it once for the duration of program
> invocation when passing it to multiple helpers (to avoid further re-lookups).
> Storing references also allows you to control object lifetime.
>
> One other use case is enabling xdp_frame queueing in XDP using this, but that
> still needs some integration work after this lands, so it's a bit early to
> comment on the specifics.
>
> Other than that, I think Alexei already mentioned this could be easily extended
> to do memory allocation returning a PTR_TO_BTF_ID in a BPF program [0] in the
> future.
>
>   [0]: https://lore.kernel.org/bpf/20220216230615.po6huyrgkswk7u67@ast-mbp.dhcp.thefacebook.com
>
> > For Unreferenced kernel pointer and userspace pointer, it seems that there is
> > no guarantee the pointer will still be valid during access (we only know it is
> > valid when it is stored in the map). Is this correct?
> >
>
> That is correct. In the case of unreferenced and referenced kernel pointers,
> when you do a BPF_LDX, both are marked as PTR_UNTRUSTED, and it is not allowed
> to pass them into helpers or kfuncs, because from that point onwards we cannot
> claim that the object is still alive when pointer is used later. Still,
> dereference is permitted because verifier handles faults for bad accesses using
> PROBE_MEM conversion for PTR_TO_BTF_ID loads in convert_ctx_accesses (which is
> then later detected by JIT to build exception table used by exception handler).
>
> In case of reading unreferenced pointer, in some cases you know that the pointer
> will stay valid, so you can just store it in the map and load and directly
> access it, it imposes very little restrictions.
>
> For the referenced case, and BPF_LDX marking it as PTR_UNTRUSTED, you could say
> that this makes it a lot less useful, because if BPF program already holds
> reference, just to make sure I _read valid data_, I still have to use the
> kptr_get style helper to raise and put reference to ensure the object is alive
> when it is accessed.
>
> So in that case, for RCU protected objects, it should still wait for BPF program
> to hit BPF_EXIT before the actual release, but for other cases like the case of
> sleepable programs, or objects where refcount alone manages lifetime, you can
> also detect writer presence of the other BPF program (to detect if pointer
> during our access was xchg'd out) using a seqlock style scheme:
>
>         v = bpf_map_lookup_elem(&map, ...);
>         if (!v)
>                 return 0;
>         seq_begin = v->seq;
>         atomic_thread_fence(memory_order_acquire); // A
>         <do access>
>         atomic_thread_fence(memory_order_acquire); // B
>         seq_end = v->seq;
>         if (seq_begin & 1 || seq_begin != seq_end)
>                 goto bad_read;
>         <use data>
>
> Ofcourse, barriers are not yet in BPF, but you get the idea (it should work on
> x86). The updater BPF program will increment v->seq before and after xchg,
> ensuring proper ordering. v->seq starts as 0, so odd seq indicates writer update
> is in progress.
>
> This would allow you to not raise refcount, while still ensuring that as long as
> object was accessed, it was still valid between A and B. Even if raising
> uncontended refcount is cheap, this is much cheaper.
>
> The case of userspace pointer is different, it sets the MEM_USER flag, so the
> only useful thing to do is calling bpf_probe_read_user, you can't even
> dereference it. You are right that in most cases that userspace pointer won't be
> useful, but for some cooperative cases between BPF program and userspace thread,
> it can act as a way to share certain thread local areas/userspace memory that
> the BPF program can then store keyed by the task_struct *, where using a BPF map
> to share memory is not always possible.

Thanks for the explanation! I can see the referenced kernel pointer be very
powerful in many use cases. The per cpu pointer is also interesting.

Song
