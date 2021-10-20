Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C957435013
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhJTQ0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhJTQ0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:26:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB95C06161C;
        Wed, 20 Oct 2021 09:24:39 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0db300a91224c8ecca7928.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:b300:a912:24c8:ecca:7928])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 658D81EC056B;
        Wed, 20 Oct 2021 18:24:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634747076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QSuLm6rInGsrmX9zknKDjGzfXToS1VdAeufrKh1kkIE=;
        b=ZoQVVEqPuIU7jb4YrZHAavXdk03Vzpnzg8FMNDJMVe0vSh/Uj61RF6dOTh4zNCm7tBt7Iu
        sMizpGIlLSze3uRWCZtDrgb/YmBuuQ/x2NGkXFRXRTTzd374DBirUYSVhxwazFjHntGPz+
        aJewAQoYVp/7LQt6w4pT90CYd1hgioU=
Date:   Wed, 20 Oct 2021 18:24:33 +0200
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
Message-ID: <YXBCwXXlMurXgqd9@zn.tnic>
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com>
 <YW/oaZ2GN15hQdyd@zn.tnic>
 <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com>
 <YXAcGtxe08XiHBFH@zn.tnic>
 <62ffaeb4-1940-4934-2c39-b8283d402924@amd.com>
 <32336f13-fa66-670d-0ea3-7822bd5b829b@gmail.com>
 <YXAqBOGdK91ieVIT@zn.tnic>
 <7bab8b73-e276-c23c-7a0a-2a6280e8a7d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7bab8b73-e276-c23c-7a0a-2a6280e8a7d9@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:09:03PM +0800, Tianyu Lan wrote:
> Yes, this is the target of the patch. Can we put the change in the
> Hyper-V patchset?

If you're asking about this version:

https://lore.kernel.org/r/20211020062321.3581158-1-ltykernel@gmail.com

then, no. I'd prefer if you did this:

https://lore.kernel.org/r/YXAcGtxe08XiHBFH@zn.tnic

for reasons which I already explained.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
