Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F19B13C1D27
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 03:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGIBkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 21:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhGIBkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 21:40:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A1AC061762
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 18:37:38 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x16so7238825pfa.13
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 18:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZFu0LDbG95B1yaNBJ4fOjmqr6d8M46HMHg6GLetGXU=;
        b=xiDZEEYxruTTfQgL3aJXGO59DvjtJZObMOjVhV0sWjDcj17iafQLkdUmxo1ZSTVmqq
         hOhBbHdS08z+NS/vzPxqGEGqVYPRgWJvkts85BPJvK8rc4qls93ozI7b1mU3D7ftHLHa
         lRKvHtMRK4ld+oh1MKjaF/wv5C2u6ht+OCwoYTFE0Nq+8PdRMSesPZdnr6LAMjefcfT3
         PDyrqH9mqO3aR2xv1s3hlxGss1SvpmSTTWaPeiSi5TGztoIA2Tc6OTHduB81a3alI0+t
         q1S9FpPVXSCUKoPVBguy200hSUDzhWXhtiQuTEaC8ZSgb+CDluoxriqvXGDMKvrxhKfk
         LixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZFu0LDbG95B1yaNBJ4fOjmqr6d8M46HMHg6GLetGXU=;
        b=mDFrR+GicbaLHNPiohO/qlqGIt8JlZ/NUyAKZt3L5nP054bWqh5cCvTyX5Jb1Dp8lk
         xzDLu6dRTZCoTvYgPBgx9ZSce3PkCXFlYdqSXXkNYpcClz+m9uylrZhmQtiis6ZmY2Lb
         rB3tiBDODaQctfEpqzlrxcmPhtU72bZI4f0zdbKUt4H5hwljP/BCCV1eJiwmOsHrB0my
         wvy2QxuW93B8YRn/5qvSqpEPwyqCCd+xPPy5Q7uasp9h52o6ZAYIgya6F6xSGOXhmj4e
         fY0RsFYE8oupMxKsp8jXWuWcut59coc8TZ8m4/SQvXk1spJZBV3LNupc1F02wOM4tfeX
         SnJg==
X-Gm-Message-State: AOAM530UK/XIfOKEu7Qsu/zfZRG+bTao9UfuZ4r6LaJnSzj4o15a4W6D
        TcSbg2x2wzPf5pqTqmrXQb3jqmH2u/DKEQixcO00SA==
X-Google-Smtp-Source: ABdhPJxuJg/c8OhWhs8F8A3S/ckvZ0rDfon+3bRcdZtYFFx8C5h1oj5aEYTfw4sblldln9EwK8T/S11b0MOw0hSvnBQ=
X-Received: by 2002:a05:6a00:22c4:b029:323:4955:a5d3 with SMTP id
 f4-20020a056a0022c4b02903234955a5d3mr17330045pfj.31.1625794657827; Thu, 08
 Jul 2021 18:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com>
 <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com> <CAPcyv4heA8gps2K_ckUV1gGJdjGeB+5dOSntS=TREEX5-0rtwQ@mail.gmail.com>
 <4972fc1a-1ffb-2b6d-e764-471210df96a3@linux.intel.com>
In-Reply-To: <4972fc1a-1ffb-2b6d-e764-471210df96a3@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Jul 2021 18:37:26 -0700
Message-ID: <CAPcyv4gwsT4rJzemkofk6SP5cAp9=nr5T6vtu+i6wTbU91R_Bg@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     Andi Kleen <ak@linux.intel.com>
Cc:     "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter H Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org, bpf@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 8, 2021 at 5:36 PM Andi Kleen <ak@linux.intel.com> wrote:
>
>
> On 7/8/2021 5:20 PM, Dan Williams wrote:
> >
> > If you have a lock would TDX KVM even notice that its parallel
> > requests are being handled serially? I.e. even if they said "yes,
> > multiple requests may happen in parallel", until it becomes an actual
> > latency problem in practice it's not clear that this generous use of
> > resources is justified.
> The worst case usage is 2 pages * file descriptor. There are lots of
> other ways to use that much and more memory for each file descriptor.
>
> >
> > Scratch that... this driver already has the attestation_lock! So, it's
> > already the case that only one thread can be attesting at a time. The
> > per-file buffer is unecessary.
>
> But then you couldn't free the buffer. So it would be leaked forever for
> likely only one attestation.
>
> Not sure what problem you're trying to solve here.

One allocation for the life of the driver that can have its direct map
permissions changed rather than an allocation per-file descriptor and
fragmenting the direct map.

> > keyutils supports generating and passing blobs into and out of the
> > kernel with a handle associated to those blobs. This driver adds a TDX
> > way to pass blobs into and out of the kernel. If Linux grows other
> > TDX-like attestation requirements in the future (e.g. PCI SPDM) should
> > each of those invent their own user ABI for passing blobs around?
>
> The TDX blobs are different than any blobs that keyutils supports today.
> The TDX operations are different too.
>
> TDREPORT doesn't even involve any keys, it's just attestation reports.
>
> keyutils today nothing related to attestation.
>
> I just don't see any commonality. If there was commonality it would be
> more with the TPM interface, but TDX attestation is different enough
> that it also isn't feasible to directly convert it into TPM operation
> (apart from standard TPM being a beast that you better avoid as much as
> possible anyways)
>

Ok. I'll leave that alone for TDX, but I still have my eyes on
keyutils for aspects of PCI SPDM.
