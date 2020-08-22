Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0C24E4C6
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 05:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgHVDSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 23:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgHVDSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 23:18:46 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7322C061573;
        Fri, 21 Aug 2020 20:18:45 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s195so2080582ybc.8;
        Fri, 21 Aug 2020 20:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o/AyaGw/+fYoUiMI/AaQIHr5kuzBoXNIpsrNjFQYyIo=;
        b=EsVkvSOS3niWtFCDa6KewEQFenGLUWGqWQXJToZpDSayAJG3leXLMLLqsxgLY150A+
         nELeCf6lMeYfVC2cL7acIdlU1kI/v/xIZJahQ8dYB7wa2RTef6TrITu9mWf4Kk3J86U6
         tr180xM4PrKL9Fm2yvnqOTiz/I7wQS8TjJ7LNUBrhXpcLMrozA6LHCZv6MEPhwa8h6ot
         nydg1nZYbOW3T7BK2KP5/vGQCTbVW1xEcm5vGQYjC+s3DDXr1VCL9WC473pr22ogHoQm
         zfLGHa/bkD8k7bAkCobIAW0HDPjQI4iFCIcemAmhuEgKu6Ivn81bxV12dDdtPXANRjDE
         pw6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o/AyaGw/+fYoUiMI/AaQIHr5kuzBoXNIpsrNjFQYyIo=;
        b=KaJZw+f5sqMrzJiQAuS9ScPm8hG6iMJAoRJIXv3mjgRJocT5skSyinUzJEsCzfZjpq
         A/ITdEYGdZqvzDxR2R6mK/bzMCzlMS2oasSIHEe2Lu+tF+ENQOfIZQS1DKe3Ekpuhso0
         Q9Qq3yOOqlCFdxtpfgMB6PLvOStq9xaeSUTtmMi4aZj9We9NRc5oQTZWJVDSafjj46Or
         r7wjFtbpBqnZw2N3GP9ihz5vkL+uf4Yj/WrAPVuj+JdYgjtnTUywG4qovYqO+wS1q3px
         iZt64ujaCrfR45Lw4BwV82tXwUfENJBPUFEB7wxQS+DPBR9hw2nr44yxkPREZ+ro3m3W
         GaGQ==
X-Gm-Message-State: AOAM530jQINpIbkHOPHriRka4Ykt72TszfglUl4KUYoy/EuBzk6X36Pu
        NREU7mVDZ9v7q/RVKi8P2bgy9iDD204Uuv6mAsw=
X-Google-Smtp-Source: ABdhPJwSPOhK1zC11kLHkLdNRDtate+UxW9MmBw7p6iayNB7aDy+pO9mUlul88FOaD3UMlv220zNsMqrLdbxBPu7eko=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr7429346ybq.27.1598066323168;
 Fri, 21 Aug 2020 20:18:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200820231250.1293069-1-andriin@fb.com> <20200821230031.3p6x7twnt4reayou@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200821230031.3p6x7twnt4reayou@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Aug 2020 20:18:32 -0700
Message-ID: <CAEf4BzZ7OmQw5KXtiBoY9O6FJ+GwXCQ-m=inKg1viGFR90rZGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 00/16] Add libbpf full support for BPF-to-BPF calls
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 4:00 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Aug 20, 2020 at 04:12:34PM -0700, Andrii Nakryiko wrote:
> > Currently, libbpf supports a limited form of BPF-to-BPF subprogram calls. The
> > restriction is that entry-point BPF program should use *all* of defined
> > sub-programs in BPF .o file. If any of the subprograms is not used, such
> > entry-point BPF program will be rejected by verifier as containing unreachable
> > dead code. This is not a big limitation for cases with single entry-point BPF
> > programs, but is quite a havy restriction for multi-programs that use only
> > partially overlapping set of subprograms.
> >
> > This patch sets removes all such restrictions and adds complete support for
> > using BPF sub-program calls on BPF side. This is achieved through libbpf
> > tracking subprograms individually and detecting which subprograms are used by
> > any given entry-point BPF program, and subsequently only appending and
> > relocating code for just those used subprograms.
> >
> > In addition, libbpf now also supports multiple entry-point BPF programs within
> > the same ELF section. This allows to structure code so that there are few
> > variants of BPF programs of the same type and attaching to the same target
> > (e.g., for tracepoints and kprobes) without the need to worry about ELF
> > section name clashes.
> >
> > This patch set opens way for more wider adoption of BPF subprogram calls,
> > especially for real-world production use-cases with complicated net of
> > subprograms. This will allow to further scale BPF verification process through
> > good use of global functions, which can be verified independently. This is
> > also important prerequisite for static linking which allows static BPF
> > libraries to not worry about naming clashes for section names, as well as use
> > static non-inlined functions (subprograms) without worries of verifier
> > rejecting program due to dead code.
> >
> > Patch set is structured as follows:
> > - patches 1-5 contain various smaller improvements to logging and selftests;
> > - patched 6-11 contain all the libbpf changes necessary to support multi-prog
> >   sections and bpf2bpf subcalls;
> > - patch 12 adds dedicated selftests validating all combinations of possible
> >   sub-calls (within and across sections, static vs global functions);
> > - patch 13 deprecated bpf_program__title() in favor of
> >   bpf_program__section_name(). The intent was to also deprecate
> >   bpf_object__find_program_by_title() as it's now non-sensical with multiple
> >   programs per section. But there were too many selftests uses of this and
> >   I didn't want to delay this patches further and make it even bigger, so left
> >   it for a follow up cleanup;
> > - patches 14-15 remove uses for title-related APIs from bpftool and
> >   bpf_program__title() use from selftests;
> > - patch 16 is converting fexit_bpf2bpf to have explicit subtest (it does
> >   contain 4 subtests, which are not handled as sub-tests).
>
> I've applied the first 5 patches. Cleanup of 'elf:' logs is nice.
> Thanks for doing it.
> The rest of the patches look fine as well, but minimalistic selftest is
> a bit concerning for such major update to libbpf.
> Please consider expanding the tests.

That test is not that minimalistic, actually. It tests all
combinations of bpf2bpf calls (global/static * same/other section),
plus with only subsets of functions used by entry-point BPF programs.
Similarly, fentry_bpf2bpf tests have also pretty complicated patterns,
as well as test_pkt_access.c.

> May be cloudflare's test_cls_redirect.c can be adopted for this purpose?
> test_xdp_noinline.c can also be extended by doing two copies of
> balancer_ingress(). One to process ipv4 another ipv6.

I'll take a look at those, if they are using sub-program calls (not
__always_inline), they are already testing this. I'll see if I can
un-inline some more functions, though.

> Then it will make libbpf to do plenty of intersting call adjustments
> and function munipulations for three programs in "xdp-test" section
> that use different sets of sub-programs.
> test_l4lb_noinline.c can be another candidate.
> The selftest that is part of this set is nice for targeted debugging, but would
> be great to see production bpf prog adopting this exciting libbpf feature.

Sure, I'll also see if strobemeta examples can be modified minimally
to allow non-inlined functions.
