Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6B7434EA7
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhJTPLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhJTPL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 11:11:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66909C06161C;
        Wed, 20 Oct 2021 08:09:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f21so16361756plb.3;
        Wed, 20 Oct 2021 08:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4uNWaRHMlXqdsk57g9klMRY2UiTW10bRdpFkdpi3veM=;
        b=cukLpuMoyHVybbDBE/wFKzKYtBZovXI9IN2vPTTq8tXwOPJQ9hv0EJY2P0R4J/4ntC
         PQwrbCvTFvGnPngpRUk9z5upZGGHXa9IhLi20i7R4vweKFQ/hfgC02+wNk8PxKKZpo9H
         ji8f7YqN69ON1KH7uJxiyBAR4iwTtT+8Z1ylJwMhz7WHESu1btDvFkNl3Iqrni7bbxmr
         kds1M3lwsloxN2bs3cABQCPQLlHrDvbCB8+ZUQb46m+LtSq3t1RpINTdyNdz+d0GqLo3
         iRymbGAMMgcnuNd8keU8nIt2RiK8UiiFiawJ4FmL3+zx8Iy4y/bcbljSM9w7rmQpZbfo
         saAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4uNWaRHMlXqdsk57g9klMRY2UiTW10bRdpFkdpi3veM=;
        b=RpUJ9eZB0jCnCQqXA+H78DlNFzEjIdXFqw2+Vv8MKnvF5tXHtvDXkMHL5DY3x85Eg6
         XjI8m2TBsPxMqTPaRmVe4Gq0P82+4PyoVaKL7+QqzYM0kKdRG3eYt49pYGV5PuV8JXY9
         2OVJwh+dpWwL/XjP4N33gcEimgtnjK3DH4qpz4SMeZ0ERMu6eRsW+lNnkxsuiwCUsG77
         Qr/dZblSivCQvLeBBZgn63DS2jckqrRdjESiNggWQMWvkZ99zgTUjN2V6TRBgDv0vjY9
         z9bWPMJJbN7aVeeVleU01BQFl8TWy9uOlC0MuxjyqBkpnaIrVXx3EwBcN54GJurjG27A
         w3sw==
X-Gm-Message-State: AOAM533qFTikoUg30tbYyKBmqlQxoYMS3GF8czvbvAH5wkkyASRHBsVS
        AdisD3IfUGvXmP+LrsqK8pU=
X-Google-Smtp-Source: ABdhPJx+osVdmcY4WzrIowC8Ed0OTbBfwj1di+wfvGAl8i8LmLnBVUR8cbSpCfhqCoim9OS7v6fgfg==
X-Received: by 2002:a17:90b:33c7:: with SMTP id lk7mr533731pjb.172.1634742554921;
        Wed, 20 Oct 2021 08:09:14 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:18:efed::a31c])
        by smtp.gmail.com with ESMTPSA id o72sm2759176pjo.50.2021.10.20.08.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:09:14 -0700 (PDT)
Message-ID: <7bab8b73-e276-c23c-7a0a-2a6280e8a7d9@gmail.com>
Date:   Wed, 20 Oct 2021 23:09:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
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
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com> <YW/oaZ2GN15hQdyd@zn.tnic>
 <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com> <YXAcGtxe08XiHBFH@zn.tnic>
 <62ffaeb4-1940-4934-2c39-b8283d402924@amd.com>
 <32336f13-fa66-670d-0ea3-7822bd5b829b@gmail.com> <YXAqBOGdK91ieVIT@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <YXAqBOGdK91ieVIT@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/2021 10:39 PM, Borislav Petkov wrote:
> On Wed, Oct 20, 2021 at 10:23:06PM +0800, Tianyu Lan wrote:
>> This follows Joreg's previous comment and I implemented similar version in
>> the V! patchset([PATCH 05/13] HV: Add Write/Read MSR registers via ghcb page
>> https://lkml.org/lkml/2021/7/28/668).
>> "Instead, factor out a helper function which contains what Hyper-V needs and
>> use that in sev_es_ghcb_hv_call() and Hyper-V code."
>>
>> https://lkml.org/lkml/2021/8/2/375
> 
> If you wanna point to mails on a mailing list, you simply do
> 
> https://lore.kernel.org/r/<Message-id>
> 
> No need to use some random, unreliable web pages.

OK. Thanks for suggestion.

> 
> As to Joerg's suggestion, in the version I'm seeing, you're checking the
> *context* - and the one you sent today, avoids the __pa(ghcb) MSR write.
> 
> So which is it?
> 
> Because your current version will look at the context too, see
> 
> 	return verify_exception_info(ghcb, ctxt);
> 
> at the end of the function.
Both old and new patches are to avoid setting GHCB page address via MSR.
Paravisor is in charge of doing that and un-enlightened guest should not 
change it. The old one was in the patchset v1 "x86/Hyper-V: Add Hyper-V
Isolation VM support". The patch I sent today is based on your clean up 
patch and for review first. It should be in patchset "x86/Hyper-V: Add 
Hyper-V Isolation VM support."

> 
> So is the issue what Tom said that "the paravisor uses the same GHCB MSR
> and GHCB protocol, it just can't use __pa() to get the address of the
> GHCB."?

Yes, hyper-V enables vTOM in the CVM and GHCB page PA reported by 
paravisor contains vTOM bit. We need to use memremap() to map ghcb page 
before accessing GHCB page. __pa() doesn't work for PA with vTOM bit.
Otherwise, guest should not set GHCB page address and avoid conflict 
with paravisor.

> 
> If that is the case and the only thing you want is to avoid the GHCB PA
> write, then, in the future, we might drop that MSR write altogether on
> the enlightened Linux guests too and then the same function will be used
> by your paravisor and the Linux guest.

Yes, this is the target of the patch. Can we put the change in the 
Hyper-V patchset? Other patch has been fully reviewed.

Thanks.
