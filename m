Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F4A344DD8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhCVRzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhCVRyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:54:47 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94D7C061756;
        Mon, 22 Mar 2021 10:54:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id l1so9101983pgb.5;
        Mon, 22 Mar 2021 10:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=87pGrLteJ+237RV0BtDd06HtY25mz530b4exQgqj/zg=;
        b=CrG38DWa9qAvcmrymHnZgrao/1g2aKLb2W6MED98qp8qS/XKo30r9qyY9+QSLsaWDS
         STfYM+DhjwcP/3e+Wz3ZTmwOL95cZmsZuYiiwrra/J1lJOO/MhJ0agQFJ4h+QFR3QYKp
         IM9fmzv8M6hpL7YqIB7Yy+z2IfrYAPIZErsRkAnUPyee2MoEnxp/Qo3uwCeAmg358tUm
         VPDahDnxjV1MiSo8yjBdOCJeidX6DAZT/pB8gpJoTaalpEQdfx8i61SlMWJyPfXNRilS
         noiZmlX0uXHlnOVCmGTlsKbppTteN2hUpQku3cqjBt2eZOtB3Xu40yOPprCAsRXLlOr5
         Xz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=87pGrLteJ+237RV0BtDd06HtY25mz530b4exQgqj/zg=;
        b=VdFHCvYZm2IZpXT0JdD7l9soF69m0z+rrsqmcnZ+qM2DF80diVmp+7PDtlB+RhZmYX
         rwHGaCGSkUSz/quK/cYBlMl8KT+SdwUGvK/lHRgG+wtI+y0mXRX0Bfi/AKMyTQMEycB2
         UFVA/9H6EOcEpM2npHVjCNvoFlFp90nqrHCthgWJM8eSUrXCE0IuYvEapU4D+1wkDz4I
         q84QGT2jpipuzPOU3ZTn8NMOKKe/C1Dlc8MnmiHjQBZ9eDXLb8qQtTAHEYOUjKiuk1Z9
         6aos8vz1jvpCumGxhL+56uZ3BFG7Wl280/2LnK3Ay8P7G21erTi0C+liIWDPD10BGLhs
         tj5A==
X-Gm-Message-State: AOAM531s9wjzimhObQFxVIGx+jjGS7RBg9GXHSJ7BrXF4Nw30f96K2wt
        IB6/EZFAWzuoWn+q1WgJFI1rQsiJJFU=
X-Google-Smtp-Source: ABdhPJxqweOaS6g+BETYVuqs+Sytqb7t6qAF8onnorVNo/uV0UgFqgWPen0BStGAttW9dnkwp5AUFw==
X-Received: by 2002:a63:fb10:: with SMTP id o16mr644549pgh.368.1616435686172;
        Mon, 22 Mar 2021 10:54:46 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:6970])
        by smtp.gmail.com with ESMTPSA id w189sm14167569pfw.86.2021.03.22.10.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:54:45 -0700 (PDT)
Date:   Mon, 22 Mar 2021 10:54:43 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: allow compiling BPF objects
 without BTF
Message-ID: <20210322175443.zflwaf7dstpg4y2b@ast-mbp>
References: <20210319205909.1748642-1-andrii@kernel.org>
 <20210319205909.1748642-4-andrii@kernel.org>
 <20210320022156.eqtmldxpzxkh45a7@ast-mbp>
 <CAEf4Bzarx33ENLBRyqxDz7k9t0YmTRNs5wf_xCqL2jNXvs+0Sg@mail.gmail.com>
 <20210322010734.tw2rigbr3dyk3iot@ast-mbp>
 <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbdgPnw81+diwcvAokv+S6osqvAAzSQYt_BoYbga9t-qQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 09:56:19AM -0700, Andrii Nakryiko wrote:
> On Sun, Mar 21, 2021 at 6:07 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, Mar 20, 2021 at 10:00:57AM -0700, Andrii Nakryiko wrote:
> > > On Fri, Mar 19, 2021 at 7:22 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > On Fri, Mar 19, 2021 at 01:59:09PM -0700, Andrii Nakryiko wrote:
> > > > > Add ability to skip BTF generation for some BPF object files. This is done
> > > > > through using a convention of .nobtf.c file name suffix.
> > > > >
> > > > > Also add third statically linked file to static_linked selftest. This file has
> > > > > no BTF, causing resulting object file to have only some of DATASEC BTF types.
> > > > > It also is using (from BPF code) global variables. This tests both libbpf's
> > > > > static linking logic and bpftool's skeleton generation logic.
> > > >
> > > > I don't like the long term direction of patch 1 and 3.
> > > > BTF is mandatory for the most bpf kernel features added in the last couple years.
> > > > Making user space do quirks for object files without BTF is not something
> > > > we should support or maintain. If there is no BTF the linker and skeleton
> > > > generation shouldn't crash, of course, but they should reject such object.
> > >
> > > I don't think tools need to enforce any policies like that. They are
> > > tools and should be unassuming about the way they are going to be used
> > > to the extent possible.
> >
> > Right and bpftool/skeleton was used with BTF since day one.
> > Without BTF the skeleton core ideas are lost. The skeleton api
> > gives no benefit. So what's the point of adding support for skeleton without BTF?
> > Is there a user that would benefit? If so, what will they gain from
> > such BTF-less skeleton?
> 
> The only part of skeleton API that's not available is convenient
> user-space access to global variables. If you don't use global
> variables you don't use BTF at all with skeleton. So all features but
> one work without BTF just fine: compile-time maps and progs (and
> links) references, embedding object file in .skel.h, and even
> automatic memory-mapping of .data/.rodata/.bss (just unknown struct
> layout).
> 
> Compile-time maps and progs and separately object file embedding in C
> header are useful in their own rights, even individually. There is no
> single "core idea" of the BPF skeleton in my mind. What is it for you?
> 
> So given none of the fixes are horrible hacks and won't incur
> additional maintenance costs, what's the problem with accepting them?

Because they double the maintenance cost now and double the support forever.
We never needed to worry about skeleton without BTF and now it would be
a thing ? So all tests realistically need to be doubled: with and without BTF.
Even more so for static linking. If one .o has BTF and another doesn't
what linker suppose to do? Keep it, but the linked BTF will sort of cover
both .o-s, but line info in some funcs will be missing.
All these weird combinations would need to be tested.
The sensible thing to do would be to reject skel generation without BTF
and reject linking without BTF. The user most likely forgot -g during
compilation of bpf prog. The bpftool should give the helpful message
in such case. Whether it's generating skel or linking. Silently proceeding
and generating half-featured skeleton is not what user wanted.
