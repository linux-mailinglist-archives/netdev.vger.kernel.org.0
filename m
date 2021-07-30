Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 971693DB157
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 04:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhG3CxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 22:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG3CxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 22:53:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909F3C061765;
        Thu, 29 Jul 2021 19:52:59 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id l19so13123269pjz.0;
        Thu, 29 Jul 2021 19:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bmL4SQ8GAZJWK3xApvq+PZaab/7COKw/aR8FnJTkZ8A=;
        b=NAhocIP4f3vAt+HHEuF7oFkro+lh/6vEAuGcefhg6XueHZFW/VgAw1rUNxuPFA9NmR
         cmXx+ceLZex9nGJ0OyzZaxsYsT8tiRb1jRyPL71vgLtSWLPo0cCqvQ2qriDvy8CpQssj
         viNqrboexe+B/LVVnnduOrHj946GTrR2N6htuF3Da/GGsbOKkj/XSoD3hUHgJvjwaB5p
         T3Mh0d9xRtStBYG2xEqHf2hhw7W3QR/YGkGCbpjg9hYVaJSISM4slgqWraPF6pZEHZNm
         jukHYbtabQpZEinKjbGFHZgXMHh/LOo9XYtuFBdeFaYM0POV1AQF6Po3lzHo4DXqdZqC
         RNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bmL4SQ8GAZJWK3xApvq+PZaab/7COKw/aR8FnJTkZ8A=;
        b=BxY6GLIvDAhhB/d/w4O2cgNVXG2HwWRr2NHWKwirZGPj082T0m9rr9Cw0oqEe01K7q
         //x2eiRzICqr6cY/7fXbSeNQCHcxih5NOpbv09scgntHcXJ9KDvrl7flac5sXdS7siVF
         x2iFbgeXqMNl9Pqnr5s/P8hXvJYrXfpAuVVzjYuaFdNLQOUPokUzXRbu2KTnMU/1PtYV
         5Gjpgd16tTiBGx8rzin0JG6RckukwGHZNNrcLabWIiUnxcz+xh3E2BtbJE4cEevPiD0g
         06SS3MZS4WO5dBLV4+jh78JL8HqAKndrC2RI0OFFBL5F8B8cZPryty0nS3o7BBPAaggH
         1NUw==
X-Gm-Message-State: AOAM533Xw4nqIh5Vka3CyyZu1b970O1aJyBqslC//jI7RIBqeEVvJiF8
        cFOCzMCF9fpnazIxMh+t6tU=
X-Google-Smtp-Source: ABdhPJyyZoBDWV7ZCj8Ji9VpActKffc9EXcufc2IzXROiuNMi/ja4nm1BshkPIm0WrFthtY+V0e3wQ==
X-Received: by 2002:a17:90a:1109:: with SMTP id d9mr575516pja.183.1627613579170;
        Thu, 29 Jul 2021 19:52:59 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id l10sm154977pjg.11.2021.07.29.19.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 19:52:58 -0700 (PDT)
Subject: Re: [PATCH 03/13] x86/HV: Add new hvcall guest address host
 visibility support
To:     Dave Hansen <dave.hansen@intel.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com
Cc:     iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-4-ltykernel@gmail.com>
 <a2444c36-0103-8e1c-7005-d97f77f90e85@intel.com>
 <0d956a05-7d24-57a0-f4a9-dccc849b52fc@gmail.com>
 <ec1d4cfd-bbbc-e27a-7589-e85d9f0438f4@intel.com>
 <8df2845d-ee90-56d0-1228-adebb103ec37@gmail.com>
 <7a2ddcca-e249-ba63-8709-e355fcef2d41@intel.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <fa6cf8b6-7da0-dadf-b137-d90ce3513d5e@gmail.com>
Date:   Fri, 30 Jul 2021 10:52:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7a2ddcca-e249-ba63-8709-e355fcef2d41@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/2021 12:05 AM, Dave Hansen wrote:
> On 7/29/21 8:02 AM, Tianyu Lan wrote:
>>>
>>
>> There is x86_hyper_type to identify hypervisor type and we may check
>> this variable after checking X86_FEATURE_HYPERVISOR.
>>
>> static inline bool hv_is_isolation_supported(void)
>> {
>>      if (!cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
>>          return 0;
>>
>>          if (x86_hyper_type != X86_HYPER_MS_HYPERV)
>>                  return 0;
>>
>>      // out of line function call:
>>      return __hv_is_isolation_supported();
>> }
> 
> Looks fine.  You just might want to use this existing helper:
> 
> static inline bool hypervisor_is_type(enum x86_hypervisor_type type)
> {
>          return x86_hyper_type == type;
> }
> 

Yes,thanks for suggestion and will update in the next version.
