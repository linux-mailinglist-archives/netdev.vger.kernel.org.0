Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE8B3C1C94
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 02:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhGIAXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 20:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbhGIAXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 20:23:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49111C061574
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 17:20:31 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id f17so7135081pfj.8
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 17:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TT5zfrLu6vWa/4z/bXKwUCLEUNEr9ejX8Ax6l+MRnD8=;
        b=v0AZHEfeVGRVzZxjd5LP30OvggeS4fKO79WkNtCsGrSeRhi6eGID2oG40HP+atgPGH
         RSNDFdKelYfFoy5BqW/u5DcmH0ApN48+QW/U5V1nVALFeJPJ/lIPtR1IA3VM0AWRTW6x
         cWAwVsrzCrepazzvhvE89xtGAxQ9+y6i5su3X0VjrO+OqnW+ABfl/S7OwOqXhi5fKpT/
         92nP2pU6IgzpoPPdMYv8UVmEY3iGvAgRcoqLOKs+fvNZE169ePydHXUe2+EE5YxuDerU
         L3b5uVtmxZ/10Wbow8yKU2tg15UL+lUSFG1KnxBPnTLXJgkAjSR50HkT8oGzhDVq2wlo
         EdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TT5zfrLu6vWa/4z/bXKwUCLEUNEr9ejX8Ax6l+MRnD8=;
        b=A49qS1OMWZAbR2b6RudaOtm19kYspA5yEJYZbKavw6zvHEh4C3UmV4B39LdVncwPr/
         XDOyhkVTnNaePf3hLX1zUdMvvSUTGzRV+BctBV6aetPID5tOqkcRaHFLK35SDW65DRfh
         SqlrsIATs6FSX/38VwkvxMceT96MXmtLRQAn49JccPrGLdKR7hNbo7gfqv1XU278kqpJ
         uanXrRYEGdDN03kI14IWVvcYQ+BGilXkYT9weDqk2/6Su0SuIVXTT/eIb0lQ+wUwlQw3
         tbZSVwTBuoQeqkUPWQegGuTREamkEhiQHF7k9wTTiiVy1qGQj7VHHUeF+Nypn9YJBTB0
         CqWg==
X-Gm-Message-State: AOAM532jb0VCfcPRPMw5VJKVkF/tfgKVkxCUEcUEY2BGqiYuWJEM+3nT
        psQwvgt7toJQ8mt6imLcj+CQaanST20HrtD2QJ1PPw==
X-Google-Smtp-Source: ABdhPJzho1Wzz2jIdtaNYyVK4S67fvXLH+RcYyaPQATK2rlI06EzO9IB95vuvqpfmxw0CljZbQ6/ijjjTemokiCJZ60=
X-Received: by 2002:a62:ce85:0:b029:316:8ca6:c2e with SMTP id
 y127-20020a62ce850000b02903168ca60c2emr33862440pfg.70.1625790030762; Thu, 08
 Jul 2021 17:20:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com> <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com>
In-Reply-To: <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Jul 2021 17:20:19 -0700
Message-ID: <CAPcyv4heA8gps2K_ckUV1gGJdjGeB+5dOSntS=TREEX5-0rtwQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] platform/x86: intel_tdx_attest: Add TDX Guest
 attestation interface driver
To:     "Kuppuswamy, Sathyanarayanan" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
        Andi Kleen <ak@linux.intel.com>,
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

On Thu, Jul 8, 2021 at 4:57 PM Kuppuswamy, Sathyanarayanan
<sathyanarayanan.kuppuswamy@linux.intel.com> wrote:
>
>
>
> On 7/8/21 4:36 PM, Dan Williams wrote:
> >> +static int tdg_attest_open(struct inode *inode, struct file *file)
> >> +{
> >> +       /*
> >> +        * Currently tdg_event_notify_handler is only used in attestation
> >> +        * driver. But, WRITE_ONCE is used as benign data race notice.
> >> +        */
> >> +       WRITE_ONCE(tdg_event_notify_handler, attestation_callback_handler);
> > Why is this ioctl not part of the driver that registered the interrupt
>
> We cannot club them because they are not functionally related. Even notification
> is a separate common feature supported by TDX and configured using
> SetupEventNotifyInterrupt hypercall. It is not related to TDX attestation.
> Attestation just uses event notification interface to get the quote
> completion event.
>
> > handler for this callback in the first instance? I've never seen this
> > style of cross-driver communication before.
>
> This is similar to x86_platform_ipi_callback() acrn_setup_intr_handler()
> use cases.

Those appear to be for core functionality, not one off drivers. Where
is the code that does the SetupEventNotifyInterrupt, is it a driver?

>
> >
> >> +
> >> +       file->private_data = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
> >> +                                                     get_order(QUOTE_SIZE));
> > Why does this driver abandon all semblance of type-safety and use
> > ->private_data directly? This also seems an easy way to consume
> > memory, just keep opening this device over and over again.
> >
> > AFAICS this buffer is only used ephemerally. I see no reason it needs
> > to be allocated once per open file. Unless you need several threads to
> > be running the attestation process in parallel just allocate a single
> > buffer at module init (statically defined or on the heap) and use a
> > lock to enforce only one user of this buffer at a time. That would
> > also solve your direct-map fracturing problem.
>
> Theoretically attestation requests can be sent in parallel. I have
> allocated the memory in open() call mainly for this reason. But current
> TDX ABI specification does not clearly specify this possibility and I am
> not sure whether TDX KVM supports it. Let me confirm about it again with
> TDX KVM owner. If such model is not currently supported, then I will move
> the memory allocation to init code.

If you have a lock would TDX KVM even notice that its parallel
requests are being handled serially? I.e. even if they said "yes,
multiple requests may happen in parallel", until it becomes an actual
latency problem in practice it's not clear that this generous use of
resources is justified.

Scratch that... this driver already has the attestation_lock! So, it's
already the case that only one thread can be attesting at a time. The
per-file buffer is unecessary.

>
> >
> > All that said, this new user ABI for passing blobs in and out of the
> > kernel is something that the keyutils API already does. Did you
> > consider add_key() / request_key() for this case? That would also be
> > the natural path for the end step of requesting the drive decrypt key.
> > I.e. a chain of key payloads starting with establishing the
> > attestation blob.
>
> I am not sure whether we can use keyutil interface for attestation. AFAIK,
> there are other use cases for attestation other than  getting keys for
> encrypted drives.

keyutils supports generating and passing blobs into and out of the
kernel with a handle associated to those blobs. This driver adds a TDX
way to pass blobs into and out of the kernel. If Linux grows other
TDX-like attestation requirements in the future (e.g. PCI SPDM) should
each of those invent their own user ABI for passing blobs around?
