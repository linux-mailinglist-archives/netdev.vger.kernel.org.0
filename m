Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E300941EED6
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhJANqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhJANqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:46:46 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71853C061775;
        Fri,  1 Oct 2021 06:45:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id h3so9456941pgb.7;
        Fri, 01 Oct 2021 06:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+W0613/U97/IRk/cKafjuDgCo1b1iuYjGfZXYXnQ6Ks=;
        b=fI+a+LG8ArsPWPNVrcDlN1Y+DGYbEAMiOyVtFcrgIanlWJoHfu3nErCi7z9B7TRc0s
         XwkLDSu1HSUCVcuUGAf2UAfkIZbdq0kYiq1hwcM4Chs9DtwIyx5IcQcjIfHB/Pf2yXEo
         H7qFms2XI1NTfN593xVR9xVLDqYLgx0y3Nnz8+9Bq6V7W7c3d+wtp69kwgzNG+8b8JdR
         Y4gZtH/zc4nw9Vv9uUKElYpBKRywUCzcJ5JZ8FBtYTOLAbe6Ey+vzJmV1uMjblwCdps+
         8o6+40wggv41yfCOBYJzPR9nB5IkaksFvEMkrAHI/sEx/M2LIzl4SavufDg1IOWqSdK8
         IFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+W0613/U97/IRk/cKafjuDgCo1b1iuYjGfZXYXnQ6Ks=;
        b=2P8gyvR5aTMwtqGFCEU0p9GeLXeG/0WlyjEYxQtHBkLSzcLZP/HwZeSzKzWeNoMh4i
         4mddxL9ue+35/udtmJDURr6VS99UVPBxi7ija1KrQvGrh2fxyX9ahzfiuV22M/sZuTa8
         mhtbVJSs8QFMGOtdP4Ec4IQ6OVRd9Wlp4GS77VBQJs1dDD50bGjvWZQfVfWzM+UZlq30
         pOLuSRGPd/b37SqysX/9Dfu6fzLfiTTq27HgT36WddgvdaX6d6hcCZ02lFxDuG4hMgFy
         dWoPY7hw2+YWzBoxA8TZOWGW++euD9kdVbbKeUW4NqHyLzvRyMqG6y57HYVU0fQ8btqR
         iQHA==
X-Gm-Message-State: AOAM532zhdETqLxy0xm3RsFG72qpt4qOGOdutUcaMYJW4A/fy9H+Jtme
        i3d0j9llvtIqDKY26Wg6uU4=
X-Google-Smtp-Source: ABdhPJxUpFMG0u9Y0nQi7Ij3rISBGTDlzrBFeaSwsW5M8Ta7kbtdYw1JRUOoqo+ermBwMkbpwM/6YQ==
X-Received: by 2002:a63:f050:: with SMTP id s16mr9765518pgj.258.1633095901913;
        Fri, 01 Oct 2021 06:45:01 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id p27sm6480554pfq.164.2021.10.01.06.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 06:45:01 -0700 (PDT)
Subject: Re: [PATCH V6 5/8] x86/hyperv: Add Write/Read MSR registers via ghcb
 page
To:     Tom Lendacky <thomas.lendacky@amd.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-6-ltykernel@gmail.com>
 <0f33ca85-f1c6-bab3-5bdb-233c09f86621@amd.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <5d13faf8-0733-10cc-6e2e-c43b400f7d69@gmail.com>
Date:   Fri, 1 Oct 2021 21:44:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <0f33ca85-f1c6-bab3-5bdb-233c09f86621@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tom:
      Thanks for your review.

On 10/1/2021 2:27 AM, Tom Lendacky wrote:
> On 9/30/21 8:05 AM, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
> 
> ...
> 
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index 9f90f460a28c..dd7f37de640b 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>>       ctxt->regs->ip += ctxt->insn.length;
>>   }
>> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> -                      struct es_em_ctxt *ctxt,
>> -                      u64 exit_code, u64 exit_info_1,
>> -                      u64 exit_info_2)
>> +enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
>> +                   u64 exit_code, u64 exit_info_1,
>> +                   u64 exit_info_2)
>>   {
>>       enum es_result ret;
>> @@ -109,29 +108,45 @@ static enum es_result sev_es_ghcb_hv_call(struct 
>> ghcb *ghcb,
>>       ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>>       ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>> -    sev_es_wr_ghcb_msr(__pa(ghcb));
>>       VMGEXIT();
>> -    if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
>> -        u64 info = ghcb->save.sw_exit_info_2;
>> -        unsigned long v;
>> -
>> -        info = ghcb->save.sw_exit_info_2;
>> -        v = info & SVM_EVTINJ_VEC_MASK;
>> -
>> -        /* Check if exception information from hypervisor is sane. */
>> -        if ((info & SVM_EVTINJ_VALID) &&
>> -            ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
>> -            ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
>> -            ctxt->fi.vector = v;
>> -            if (info & SVM_EVTINJ_VALID_ERR)
>> -                ctxt->fi.error_code = info >> 32;
>> -            ret = ES_EXCEPTION;
>> -        } else {
>> -            ret = ES_VMM_ERROR;
>> -        }
>> -    } else {
>> +    if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1)
> 
> Really, any non-zero value indicates an error, so this should be:
> 
>      if (ghcb->save.sw_exit_info_1 & 0xffffffff) >
>> +        ret = ES_VMM_ERROR;
>> +    else
>>           ret = ES_OK;
>> +
>> +    return ret;
>> +}
>> +
>> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> +                   struct es_em_ctxt *ctxt,
>> +                   u64 exit_code, u64 exit_info_1,
>> +                   u64 exit_info_2)
>> +{
>> +    unsigned long v;
>> +    enum es_result ret;
>> +    u64 info;
>> +
>> +    sev_es_wr_ghcb_msr(__pa(ghcb));
>> +
>> +    ret = sev_es_ghcb_hv_call_simple(ghcb, exit_code, exit_info_1,
>> +                     exit_info_2);
>> +    if (ret == ES_OK)
>> +        return ret;
>> +
> 
> And then here, the explicit check for 1 should be performed and if not 
> 1, then return ES_VMM_ERROR. If it is 1, then check the event injection 
> values. >
> Thanks,
> Tom

Good suggestion. Will update.

> 
>> +    info = ghcb->save.sw_exit_info_2;
>> +    v = info & SVM_EVTINJ_VEC_MASK;
>> +
>> +    /* Check if exception information from hypervisor is sane. */
>> +    if ((info & SVM_EVTINJ_VALID) &&
>> +        ((v == X86_TRAP_GP) || (v == X86_TRAP_UD)) &&
>> +        ((info & SVM_EVTINJ_TYPE_MASK) == SVM_EVTINJ_TYPE_EXEPT)) {
>> +        ctxt->fi.vector = v;
>> +        if (info & SVM_EVTINJ_VALID_ERR)
>> +            ctxt->fi.error_code = info >> 32;
>> +        ret = ES_EXCEPTION;
>> +    } else {
>> +        ret = ES_VMM_ERROR;
>>       }
>>       return ret;
