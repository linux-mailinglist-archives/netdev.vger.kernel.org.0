Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D81434E10
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJTOlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhJTOlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 10:41:18 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EE5C06161C;
        Wed, 20 Oct 2021 07:39:03 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0db30070b4efa7ef8aef1e.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b300:70b4:efa7:ef8a:ef1e])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4B1C51EC056D;
        Wed, 20 Oct 2021 16:39:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634740741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qCfT/7b674bgNAf+bHSErWkrs72ArKBmR21b+UH3CZc=;
        b=ZPw9/L3YBYugWmEQKF2tm8UQBW0pDlVVeVDGYg1FMpEgrGNsPVp4/4OQXCrj7uzvzVpO6y
        y7n5Xa5zIfYJXJ0yY4Gonh94g5EjQX+T+uvejyD7qFFvMwoU2m2Shuhoxz3sKsqlxRvrAS
        JaTgFAKDBrL+Fll4Pt10qc6EvwAGDks=
Date:   Wed, 20 Oct 2021 16:39:00 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
Message-ID: <YXAqBOGdK91ieVIT@zn.tnic>
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com>
 <YW/oaZ2GN15hQdyd@zn.tnic>
 <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com>
 <YXAcGtxe08XiHBFH@zn.tnic>
 <62ffaeb4-1940-4934-2c39-b8283d402924@amd.com>
 <32336f13-fa66-670d-0ea3-7822bd5b829b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32336f13-fa66-670d-0ea3-7822bd5b829b@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 10:23:06PM +0800, Tianyu Lan wrote:
> This follows Joreg's previous comment and I implemented similar version in
> the V! patchset([PATCH 05/13] HV: Add Write/Read MSR registers via ghcb page
> https://lkml.org/lkml/2021/7/28/668).
> "Instead, factor out a helper function which contains what Hyper-V needs and
> use that in sev_es_ghcb_hv_call() and Hyper-V code."
> 
> https://lkml.org/lkml/2021/8/2/375

If you wanna point to mails on a mailing list, you simply do

https://lore.kernel.org/r/<Message-id>

No need to use some random, unreliable web pages.

As to Joerg's suggestion, in the version I'm seeing, you're checking the
*context* - and the one you sent today, avoids the __pa(ghcb) MSR write.

So which is it?

Because your current version will look at the context too, see

	return verify_exception_info(ghcb, ctxt);

at the end of the function.

So is the issue what Tom said that "the paravisor uses the same GHCB MSR
and GHCB protocol, it just can't use __pa() to get the address of the
GHCB."?

If that is the case and the only thing you want is to avoid the GHCB PA
write, then, in the future, we might drop that MSR write altogether on
the enlightened Linux guests too and then the same function will be used
by your paravisor and the Linux guest.

So please explain in detail what exactly you want to avoid from
sev_es_ghcb_hv_call()'s current version and why.

As I said before, I don't want to export any random details of the SEV
implementation in the kernel without any justification for it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
