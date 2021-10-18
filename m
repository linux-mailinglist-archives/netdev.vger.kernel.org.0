Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C254318E6
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhJRMV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhJRMV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:21:58 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3F3C06161C;
        Mon, 18 Oct 2021 05:19:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f5so15963559pgc.12;
        Mon, 18 Oct 2021 05:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sud4zcsfxZSSpepwvWISp+jEXhBT18LLJ0OlvHd2lTA=;
        b=XWrn75DS+tXBQNfoNKDv7q8gT3AZpuXHtwxC2rLK1ldrcMyPwB6xfRxYZ9F7gC/uTG
         jwU+BpFCnT3jVRXEyAmCiYBn1RzrLt6gKoqseePVaH6z7V/5UwJ+UE3tY4EwfVm0qGP/
         +QWytX2TLyAYIT5grq3vleifxZhKofsmM7pWfr0L/8+vZ8dWpJ4TphIg9Xqd0g8JjCOD
         Dpfb4x6uIYG+Z90SOraXxo+Cm1sDwZ3LYqbwNU8kK6QA48u1HvYwHbA0XxfHMQtbI+pj
         L6TgE3FNwlnunIDjsgZRL7FlAW8fa/KLCdQUonp1yhYMN+MqKjZn8JPqKBWnEaN8tmpM
         yreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sud4zcsfxZSSpepwvWISp+jEXhBT18LLJ0OlvHd2lTA=;
        b=jllF6kae6U0KCZAoft7LPs+W1S1HFcRkSibYULZc3RGR3TftAY1sh6S/bKrVky+7Ku
         J8Zvv9wQPZuo01+dMUkE+iJgDjlTop1u43EoRbQSYSsOLImRJ4Jhfkfwa7jrOWCDgnDs
         x6ix3g73xGXxty6WwHJh8O83sbTvrWG4BHr8XwN9gKNisIfQyY+W+z116tNeTVUydNCv
         yeEQLxChR/nTS16wJSFvSJVlSl+Wk2QMRnUYFX82/DHrp+dDkSies535iHeh5r1b+Hvi
         n8lROaEYjPhL/nx9WghchQSriueR5CF8N8A4aWkcQFIbZEagOV5Ela6tZTHoXfbD+4RR
         qKAw==
X-Gm-Message-State: AOAM5321qABcedT/2fCjYZfg+iImqdJG5yU5TyKvPMa9hwT6Z6LDChsE
        MwEYmdmSm4xx0Rf1eHZVzko=
X-Google-Smtp-Source: ABdhPJwlqPvzaxLwFMVLLC+IEjRy/yF2w3mrI+N+sLKPqu6J9NKIDa6vkOL+A6wWeb6mXBf467VSUw==
X-Received: by 2002:a63:4b5b:: with SMTP id k27mr22929262pgl.294.1634559586707;
        Mon, 18 Oct 2021 05:19:46 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id z8sm12877401pgc.53.2021.10.18.05.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:19:46 -0700 (PDT)
Subject: Re: [PATCH V7 5/9] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com,
        Hikys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, jroedel@suse.de,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
References: <20211006063651.1124737-1-ltykernel@gmail.com>
 <20211006063651.1124737-6-ltykernel@gmail.com>
 <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com> <YWRyvD413h+PwU9B@zn.tnic>
 <5a0b9de8-e133-c17b-bc0d-93bfb593c48f@gmail.com>
Message-ID: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
Date:   Mon, 18 Oct 2021 20:19:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5a0b9de8-e133-c17b-bc0d-93bfb593c48f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gentle Ping.

On 10/13/2021 10:24 PM, Tianyu Lan wrote:
> On 10/12/2021 1:22 AM, Borislav Petkov wrote:
>> On Mon, Oct 11, 2021 at 10:42:18PM +0800, Tianyu Lan wrote:
>>> Hi @Tom and Borislav:
>>>       Please have a look at this patch. If it's ok, could you give 
>>> your ack.
>>
>> I needed to do some cleanups in that area first:
>>
>> https://lore.kernel.org/r/YWRwxImd9Qcls/Yy@zn.tnic
>>
>> Can you redo yours ontop so that you can show what exactly you need
>> exported for HyperV?
>>
>> Thx.
> 
> Hi Borislav :
>      Please check whether the following change based on you patch is
> ok for you.
> ---
> x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb hv call out of 
> sev code
> 
>      Hyper-V also needs to call ghcb hv call to write/read MSR in 
> Isolation VM.
>      So expose __sev_es_ghcb_hv_call() to call it in the Hyper-V code.
> 
>      Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..295c847c3cd4 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,12 +81,23 @@ static __always_inline void sev_es_nmi_complete(void)
>                  __sev_es_nmi_complete();
>   }
>   extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +                                           struct es_em_ctxt *ctxt,
> +                                           u64 exit_code, u64 exit_info_1,
> +                                           u64 exit_info_2);
>   #else
>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>   static inline void sev_es_ist_exit(void) { }
>   static inline int sev_es_setup_ap_jump_table(struct real_mode_header 
> *rmh) { return 0; }
>   static inline void sev_es_nmi_complete(void) { }
>   static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> +static inline enum es_result
> +__sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +                     u64 exit_code, u64 exit_info_1,
> +                     u64 exit_info_2)
> +{
> +       return ES_VMM_ERROR;
> +}
>   #endif
> 
>   #endif
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index ea9abd69237e..08c97cb057fa 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -124,10 +124,14 @@ static enum es_result verify_exception_info(struct 
> ghcb *ghcb, struct es_em_ctxt
>          return ES_VMM_ERROR;
>   }
> 
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -                                         struct es_em_ctxt *ctxt,
> -                                         u64 exit_code, u64 exit_info_1,
> -                                         u64 exit_info_2)
> +/*
> + * __sev_es_ghcb_hv_call() is also used in the other platform code(e.g
> + * Hyper-V).
> + */
> +enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +                                    struct es_em_ctxt *ctxt,
> +                                    u64 exit_code, u64 exit_info_1,
> +                                    u64 exit_info_2)
>   {
>          /* Fill in protocol and format specifiers */
>          ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> @@ -137,12 +141,22 @@ static enum es_result sev_es_ghcb_hv_call(struct 
> ghcb *ghcb,
>          ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>          ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> 
> -       sev_es_wr_ghcb_msr(__pa(ghcb));
>          VMGEXIT();
> 
>          return verify_exception_info(ghcb, ctxt);
>   }
> 
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +                                         struct es_em_ctxt *ctxt,
> +                                         u64 exit_code, u64 exit_info_1,
> +                                         u64 exit_info_2)
> +{
> +       sev_es_wr_ghcb_msr(__pa(ghcb));
> +
> +       return __sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, exit_info_1,
> +                                    exit_info_2);
> +}
> +
>   /*
>    * Boot VC Handler - This is the first VC handler during boot, there 
> is no GHCB
>    * page yet, so it only supports the MSR based communication with the
> (END)
> 
> 
> Thanks.
> 
> 
