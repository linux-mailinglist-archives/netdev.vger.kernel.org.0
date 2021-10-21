Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3394366A4
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhJUPpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 11:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbhJUPpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 11:45:25 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03945C061764;
        Thu, 21 Oct 2021 08:43:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u6-20020a17090a3fc600b001a00250584aso3430993pjm.4;
        Thu, 21 Oct 2021 08:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r2CYBCmuGXp/M/gH39NpcxxOQQMb0H7pXgSHdjD44g4=;
        b=PaBiVr9A3g9VKQMyzRCUw1OZFoRE6DANJo1zROZqc4r4QyNLW5mBVmzi44aEFS0GYe
         16OXNrtCT7VPwWgIft1m9Oc4vUxe/ZiNvN/28Y6VYVUkfkssT8W84nFmwQgvvLH/BuDo
         yNy9ruTHu5BEg4G1U+0/I0zVmDIFtkl24QU2klNVVcOOecgCHidf2bUQKMD28CnsYSXi
         nWshiV+5uiUmTLLF30wFxaNDmgusrzGPVWuyLBdfEAGKHh8r8KHnzkWrdI/94PHRcmPh
         /LISA7pfiRHS5D4kVKnz1SCWeg+M3YDl6vLajWnPtGt7EIDmebgMrmAIqP+FWVxXz3/f
         u81A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r2CYBCmuGXp/M/gH39NpcxxOQQMb0H7pXgSHdjD44g4=;
        b=x0bi5cA/tdRuP3//DKYUE2sWRE47HkZ4UofKGr9YZDTbcsydKx47bvY8bLhQinGcof
         UUo9+ng6HkkWUhRND7w00DkRip0D/Ct5g8RBJHk9xSDTiLszMY//gAWltzHSUhKtLaQO
         NHuXNxX0gym6I/CxIOLz5KU6ZBnSWWiEKdpSd9LY7mUs8VtRySyatwOytgwzEdGoSyPH
         1aFYbN+BaYL7ai69dVc2ZmBljhqhZk2Cq7HxSL445XFI4ScQSn1/MfGI+R5izYZPAsxQ
         PZ749bjocRROSUHNYqVymTYmvLDhBudNK/h8KG3GC4mqOmrg88vJgz53XZtv0uC2aSp2
         MbsQ==
X-Gm-Message-State: AOAM533RUMS5+6tURGZmF/A9F6bR/+SvVgwbdE6SrEX8G/TVGKXoI4fD
        a2SfEXuzjZJDgdp3vr3UKq4=
X-Google-Smtp-Source: ABdhPJz8pZGy4+IbeMi6UZPlUM/KkySM3csgu6VEfpS885i+lgnYe3TibpHNpXuyTgTM3rO7e10CLw==
X-Received: by 2002:a17:90a:5b09:: with SMTP id o9mr887838pji.171.1634830988541;
        Thu, 21 Oct 2021 08:43:08 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:18:efed::a31c])
        by smtp.gmail.com with ESMTPSA id w2sm6764771pfq.207.2021.10.21.08.42.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:43:08 -0700 (PDT)
Message-ID: <ed5267f8-8306-69cc-0d1e-4c00aa6bf36d@gmail.com>
Date:   Thu, 21 Oct 2021 23:42:56 +0800
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
 <7bab8b73-e276-c23c-7a0a-2a6280e8a7d9@gmail.com> <YXBCwXXlMurXgqd9@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <YXBCwXXlMurXgqd9@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2021 12:24 AM, Borislav Petkov wrote:
> On Wed, Oct 20, 2021 at 11:09:03PM +0800, Tianyu Lan wrote:
>> Yes, this is the target of the patch. Can we put the change in the
>> Hyper-V patchset?
> 
> If you're asking about this version:
> 
> https://lore.kernel.org/r/20211020062321.3581158-1-ltykernel@gmail.com
> 
> then, no. I'd prefer if you did this:
> 
> https://lore.kernel.org/r/YXAcGtxe08XiHBFH@zn.tnic
> 
> for reasons which I already explained.
> 

Thanks for your suggestion. I just sent out v8 version according to your 
guide. Please have a look.


Thanks.
