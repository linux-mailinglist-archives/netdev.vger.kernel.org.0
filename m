Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02C4429269
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244287AbhJKOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244204AbhJKOp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:45:28 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103AAC0617A4;
        Mon, 11 Oct 2021 07:42:32 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id o133so8755146pfg.7;
        Mon, 11 Oct 2021 07:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EZOY/BC1v6Dt0Z6NPA0+TD7j4V5L5DCZxaSPpWP5wwg=;
        b=Id7ba24U8hFZSQi2CM2A0JyKZ06Iu5JLB3WXdMApz4nBesMd0FXqcTCKE/eiLE12ui
         ePe8DyIThlZUXn+gDMawmrpvThOjWYQ1U2m6+5tERvoMrRLL83UkoxqJ36qZ+zJ+WIqT
         gXSeskAzTaMp1m9XFEKm4kQRwiwcOZrqAkbU1onSU6Y7qVtn7COyj0jXVf9CY8p3IWes
         aHspCiT6xu5hYTylbxojBYhJ2+UA0/ozef/FD0opCkxZ8+Gg46E0NGyF+n/mnB27ZTMA
         TKW8/ottV1wRFwRE1cHt/rXrmIUSZs0IwTaCTkC/B1Vf8FLkS7DjeXwnBcHaYC/+PZ5t
         E/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EZOY/BC1v6Dt0Z6NPA0+TD7j4V5L5DCZxaSPpWP5wwg=;
        b=NgCGA9NHbISHpfXKsx0TYO4jx2WtL12WyyfcH48XcQOelUqWQn00B7DC5x2HEvNUUP
         AJ1IjhAmtlkrYlhlioGmV2p2esOSBFgElY2xQMxgGKEA7ZqsZWDiNvtGVwBw92SbeTTk
         40vy0wjP0Iqah652dWQIFz0M7F8qISzkdglP7KZa1huqsRtMcXdGtBptZ/ayeNAPb66n
         jIb+gvMUU5z+9M4OHXgd6JsywlmvYMr2Ty9l1AUsaR33qM8spwEI6bTY8Aau5AdDgJae
         lW9DNH1kpWor+GoEHxtvNt4gBJbf7t94YisZj75kg/iYUBLcL5nIWLZAzgaTX90StzTr
         wvEg==
X-Gm-Message-State: AOAM533IxsVmlWXrgDs9VEhh3jH/z3QS8BWDa4DnYMS7Wo8q9snFqQz+
        RMegNRMr6RFVJnuUwIHQBm0=
X-Google-Smtp-Source: ABdhPJxrez/BpFr4T3w6q022Crus2C8dDApA6evVbcqw0YxCa4eWR6mXUuYpV8PQV1+0R//jk0V/Vg==
X-Received: by 2002:a63:2acc:: with SMTP id q195mr17777585pgq.45.1633963351452;
        Mon, 11 Oct 2021 07:42:31 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id o72sm7769517pjo.50.2021.10.11.07.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 07:42:30 -0700 (PDT)
Subject: Re: [PATCH V7 5/9] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
From:   Tianyu Lan <ltykernel@gmail.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "bp@alien8.de" <bp@alien8.de>
Cc:     linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com, Hikys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, jroedel@suse.de,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
References: <20211006063651.1124737-1-ltykernel@gmail.com>
 <20211006063651.1124737-6-ltykernel@gmail.com>
Message-ID: <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com>
Date:   Mon, 11 Oct 2021 22:42:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006063651.1124737-6-ltykernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi @Tom and Borislav:
      Please have a look at this patch. If it's ok, could you give your ack.

Thanks.

On 10/6/2021 2:36 PM, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V also needs to call ghcb hv call to write/read MSR in Isolation VM.
> So expose __sev_es_ghcb_hv_call() to call it in the Hyper-V code.
> 
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> ---
>   arch/x86/include/asm/sev.h   | 10 +++++++++
>   arch/x86/kernel/sev-shared.c | 43 +++++++++++++++++++++++++-----------
>   2 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index fa5cd05d3b5b..2e96869f3e9b 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -81,12 +81,22 @@ static __always_inline void sev_es_nmi_complete(void)
>   		__sev_es_nmi_complete();
>   }
>   extern int __init sev_es_efi_map_ghcbs(pgd_t *pgd);
> +extern enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					    u64 exit_code, u64 exit_info_1,
> +					    u64 exit_info_2);
>   #else
>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>   static inline void sev_es_ist_exit(void) { }
>   static inline int sev_es_setup_ap_jump_table(struct real_mode_header *rmh) { return 0; }
>   static inline void sev_es_nmi_complete(void) { }
>   static inline int sev_es_efi_map_ghcbs(pgd_t *pgd) { return 0; }
> +static inline enum es_result
> +__sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +		      u64 exit_code, u64 exit_info_1,
> +		      u64 exit_info_2)
> +{
> +	return ES_VMM_ERROR;
> +}
>   #endif
>   
>   #endif
> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
> index 9f90f460a28c..946c203be08c 100644
> --- a/arch/x86/kernel/sev-shared.c
> +++ b/arch/x86/kernel/sev-shared.c
> @@ -94,10 +94,13 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>   	ctxt->regs->ip += ctxt->insn.length;
>   }
>   
> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> -					  struct es_em_ctxt *ctxt,
> -					  u64 exit_code, u64 exit_info_1,
> -					  u64 exit_info_2)
> +/*
> + * __sev_es_ghcb_hv_call() is also used in the other platform code(e.g
> + * Hyper-V).
> + */
> +enum es_result __sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +				     u64 exit_code, u64 exit_info_1,
> +				     u64 exit_info_2)
>   {
>   	enum es_result ret;
>   
> @@ -109,15 +112,33 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>   	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>   	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>   
> -	sev_es_wr_ghcb_msr(__pa(ghcb));
>   	VMGEXIT();
>   
> +	if (ghcb->save.sw_exit_info_1 & 0xffffffff)
> +		ret = ES_VMM_ERROR;
> +	else
> +		ret = ES_OK;
> +
> +	return ret;
> +}
> +
> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> +					  struct es_em_ctxt *ctxt,
> +					  u64 exit_code, u64 exit_info_1,
> +					  u64 exit_info_2)
> +{
> +	enum es_result ret;
> +
> +	sev_es_wr_ghcb_msr(__pa(ghcb));
> +
> +	ret = __sev_es_ghcb_hv_call(ghcb, exit_code, exit_info_1,
> +					 exit_info_2);
> +	if (ret == ES_OK)
> +		return ret;
> +
>   	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
>   		u64 info = ghcb->save.sw_exit_info_2;
> -		unsigned long v;
> -
> -		info = ghcb->save.sw_exit_info_2;
> -		v = info & SVM_EVTINJ_VEC_MASK;
> +		unsigned long v = info & SVM_EVTINJ_VEC_MASK;
>   
>   		/* Check if exception information from hypervisor is sane. */
>   		if ((info & SVM_EVTINJ_VALID) &&
> @@ -127,11 +148,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>   			if (info & SVM_EVTINJ_VALID_ERR)
>   				ctxt->fi.error_code = info >> 32;
>   			ret = ES_EXCEPTION;
> -		} else {
> -			ret = ES_VMM_ERROR;
>   		}
> -	} else {
> -		ret = ES_OK;
>   	}
>   
>   	return ret;
> 
