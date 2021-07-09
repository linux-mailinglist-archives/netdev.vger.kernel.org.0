Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C3C3C1D3E
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhGICHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhGICHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:07:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA502C061760
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 19:04:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so5200578pjo.3
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 19:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVmgiSoeAePhBmCLdjFJeAKj4gM8pZI9jJIBMA1d9SE=;
        b=nOy3S+hBH8Tk3VPQtRsr4FS7vHvTjqKKF3q4j4/Iz3rEow5ZwXTSH+1Eq1Qyct6jfd
         cRwQhXijCMaDM3wTbh4tJPpjF8ze2aGBDhHTisQK6YbEsAb/eJAhaXW68YmZwp7pSPKH
         y7obz32V9TCKSYEgGN1EqCp+IuW3akLvlugdeykO+p5b9g/KGZm/BxBG1Sk5VbmVjXD5
         PDj8dOYE98hqeeCiu9Ir5q+0KS07C38eKGmFtACVM/QipVxhtXvhavsADsTRBnHvVQMM
         qxtAh8B59ycVO1ZdQLuY+kzzPslqILg8akcV4XeDYTXQTbtzFvTIRDkHsc58M+8CI/Y9
         KVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVmgiSoeAePhBmCLdjFJeAKj4gM8pZI9jJIBMA1d9SE=;
        b=VkuDToNObApEkIsrV1KSTTACrXSuHXCRMNeAvUgeWtVjlWIQ/vV6YeOnnrkE8Yavzo
         RMQ/190Y9G9l3qNaAXxAScfht03SJ4UifPorI7JOzKsYmHTVLoR/SaVsrx54Kb1hPy6v
         YEt2cECd7M1S34nAZZ7PLeBh5+JG2EEm6w8q3iUGMH4qE/O2XbRpVQjx1x/fKrCYABpn
         5VOCMfdNDTkJG3z7QS9JAbu8bNYahPGVgHrVawuAtKpWoA/5zAmmUGFBh5elRLswg+tR
         eiIh8u9D/RbL5gK0p4qS/WEqlgx1shW+wVtVkcAbLob2sLXcToX6c/bgcmBaWSXLFWsp
         hhcQ==
X-Gm-Message-State: AOAM530cM+X/sHkSL0JYbuP+UXrKgqkgdCznTmrWFfcuOK/SN2CJw974
        kvPQMEtMrNEy7OYfBO3T5/oNGcRxYg5DqrcWmB25jg==
X-Google-Smtp-Source: ABdhPJyEz8U2pKVhGrHBoDqX+2MQUYuuhUzLeDOKRp5NApgfTOqBP5NVA74Lwy229E9/7syAydM5mL2FNAKSdTbIQpg=
X-Received: by 2002:a17:902:d88b:b029:128:cd59:ead2 with SMTP id
 b11-20020a170902d88bb0290128cd59ead2mr28421140plz.27.1625796290994; Thu, 08
 Jul 2021 19:04:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210707204249.3046665-1-sathyanarayanan.kuppuswamy@linux.intel.com>
 <20210707204249.3046665-6-sathyanarayanan.kuppuswamy@linux.intel.com>
 <CAPcyv4h8SaVL_QGLv1DT0JuoyKmSBvxJQw0aamMuzarexaU7VA@mail.gmail.com>
 <24d8fd58-36c1-0e89-4142-28f29e2c434b@linux.intel.com> <CAPcyv4heA8gps2K_ckUV1gGJdjGeB+5dOSntS=TREEX5-0rtwQ@mail.gmail.com>
 <4972fc1a-1ffb-2b6d-e764-471210df96a3@linux.intel.com> <CAPcyv4gwsT4rJzemkofk6SP5cAp9=nr5T6vtu+i6wTbU91R_Bg@mail.gmail.com>
 <ca608162-2a48-0816-4302-c2a5b2766a7a@linux.intel.com>
In-Reply-To: <ca608162-2a48-0816-4302-c2a5b2766a7a@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 8 Jul 2021 19:04:40 -0700
Message-ID: <CAPcyv4jPqv43Hh836bpDUwMYAsPHDrjUhXoJ0Ufgjbqc3h2eyQ@mail.gmail.com>
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

On Thu, Jul 8, 2021 at 6:44 PM Andi Kleen <ak@linux.intel.com> wrote:
>
>
> > One allocation for the life of the driver that can have its direct map
> > permissions changed rather than an allocation per-file descriptor and
> > fragmenting the direct map.
>
> The vmap() approach discussed in another mail will solve that.

Ok, not my first choice for how to handle the allocation side of that,
but not broken.

I'd still feel better if there was an actual data structure assigned
to file->private_data rather than using that 'void *' pointer directly
and casting throughout the driver.
