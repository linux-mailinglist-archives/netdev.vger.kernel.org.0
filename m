Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBF9434B63
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhJTMmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhJTMm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:42:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F12BC06161C;
        Wed, 20 Oct 2021 05:40:12 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so2334235pjb.3;
        Wed, 20 Oct 2021 05:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=389FpW7hPbIjdCkK7vlPqqeyqpeuLs8PuLNGFsawgZM=;
        b=GawgAzeOqixniffAQssHirkarO/hULRYc7TosQw4MuzirUZ4K49vHZs/IdyoSdxYQP
         CtGQW5DHyGVjNkHCYC6p548ENHmYFa7VV3HAncdF+Tpfnp0Dw8zAsEAPhSqu0px1AYtI
         yUOECu2Gkp4f+9csQd7HiYyg5GD3jgvyClF7+12ZV0JTKG3IF4aWooWNgh90bh1bkXzT
         qS1UhEIU0yFS1/qAPG2BE7UJtMy8bncfCLbGpalNKW9FqHVnHqy6EUU8mDdyUZpUUYIH
         d7wkP2ouhqXAWhaeHfhbcg1g9tqX8I5Cy1YcWTnNI0olvVjHPRBD5rOxSI7fj+sllIdT
         P1oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=389FpW7hPbIjdCkK7vlPqqeyqpeuLs8PuLNGFsawgZM=;
        b=wkSEWgwe+C0U5vM3hlB75GuQyuACxYUafJj1OSwOh+CnI08oMpw7YAH80E9yJNLdGC
         LL0OEo3BjN+l2zAFZjQYRc6l8jU3OeUFgGxkAg/VeP3jYPPS7R7JC81cOnHF5/KvZZuX
         /wmtgBIyajRnuBa12kjmWH3brmS78WwLiqTP2viX+Lr0A9ErPaFDHNzyBw3VCQSKyF6h
         b9uTlw8M3jqQcUZVBs+zUM7eiGYZVAz7JKET7y/7481xp+ZQ0FkKy8qJ+W8TUEVGpXTI
         Sc++mSYqjiiFUVMkujMlyfoKfpPqZDYiEoOJ4HfEvig08w9nbl0749xPMfTOFywy04JJ
         x/MQ==
X-Gm-Message-State: AOAM531PegQVNnRrMC6mPc2gPtC1nYl74Ajjolc3g3FxNjnAIOBI93z1
        jkODAUN9OhTaNeRqCUlXJdE=
X-Google-Smtp-Source: ABdhPJzE9tMJxUEl8urLIBHjZ5oZMaISozLab93eMEu2PKkMoUoxJHF+JEsaId+Q2ILqOGRjzBQ17Q==
X-Received: by 2002:a17:90a:6fc1:: with SMTP id e59mr7205512pjk.103.1634733611670;
        Wed, 20 Oct 2021 05:40:11 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:18:efed::a31c])
        by smtp.gmail.com with ESMTPSA id p16sm3126233pfh.97.2021.10.20.05.40.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 05:40:11 -0700 (PDT)
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org, tj@kernel.org,
        aneesh.kumar@linux.ibm.com, saravanand@fb.com, hannes@cmpxchg.org,
        rientjes@google.com, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com> <YW/oaZ2GN15hQdyd@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com>
Date:   Wed, 20 Oct 2021 20:39:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YW/oaZ2GN15hQdyd@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/20/2021 5:59 PM, Borislav Petkov wrote:
> On Wed, Oct 20, 2021 at 02:23:16AM -0400, Tianyu Lan wrote:
>> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
>>
>>
>> Hyper-V also needs to call ghcb hv call to write/read MSR in Isolation VM.
>> So expose __sev_es_ghcb_hv_call() to call it in the Hyper-V code.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>>   arch/x86/include/asm/sev.h   | 11 +++++++++++
>>   arch/x86/kernel/sev-shared.c | 24 +++++++++++++++++++-----
>>   2 files changed, 30 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index fa5cd05d3b5b..295c847c3cd4 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -81,12 +81,23 @@ static __always_inline void sev_es_nmi_complete(void)
>>   		__sev_es_nmi_complete();
>>   }
>>   extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
>> +extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> +					    struct es_em_ctxt *ctxt,
>> +					    u64 exit_code, u64 exit_info_1,
>> +					    u64 exit_info_2);
> 
> You can do here:
> 
> static inline enum es_result
> __sev_es_ghcb_hv_call(struct ghcb *ghcb, u64 exit_code, u64 exit_info_1, u64 exit_info_2) { return ES_VMM_ERROR; }
> 
>> @@ -137,12 +141,22 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>>   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>>   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>>   
>> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>>   	VMGEXIT();
>>   
>>   	return verify_exception_info(ghcb, ctxt);
>>   }
>>   
>> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> +					  struct es_em_ctxt *ctxt,
>> +					  u64 exit_code, u64 exit_info_1,
>> +					  u64 exit_info_2)
>> +{
>> +	sev_es_wr_ghcb_msr(__pa(ghcb));
>> +
>> +	return __sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1,
>> +				     exit_info_2);
>> +}
> 
> Well, why does Hyper-V need this thing a bit differently, without the
> setting of the GHCB's physical address?

Hyper-V runs paravisor in guest VMPL0 which emulates some functions
(e.g, timer, tsc, serial console and so on) via handling VC exception.
GHCB pages are allocated and set up by the paravisor and report to Linux
guest via MSR register.Hyper-V SEV implementation is unenlightened guest
case which doesn't Linux doesn't handle VC and paravisor in the VMPL0
handle it.


> 
> What if another hypervisor does yet another SEV implementation and yet
> another HV call needs to be defined?

In the early version, these ghcb operations are implemented in Hyper-V 
code and get comments to use existing code in the SEV ES as much as 
possible. So latter versions expose the API to re-use code.

Current two cases: enlightened guest and un-enlightened guest. Tom and
brjesh pushed enlightened case. Hyper-V is un-enlightened case and a
paravisor runs in VMPL0 to handle VC to emulate devices inside VM. GHCB
is allocated and set up by paravisor in the un-enlightened case. The new
__sev_es_ghcb_hv_call() is to handle these two cases.


