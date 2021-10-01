Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034DB41EEA0
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352581AbhJANdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 09:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhJANdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 09:33:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47819C061775;
        Fri,  1 Oct 2021 06:32:07 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id q23so7928045pfs.9;
        Fri, 01 Oct 2021 06:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EkX8N/foQh79zdmHXhT/3vt7GknIsH61jaJs2i8JOH0=;
        b=JVi2qlLW64stMaJ6M+MDj9e59Y++JoKgQwTX3P1JN5gtKv9XQurQTcovFy2QkDLLUj
         iKp7AScsFt/meALx0S0cg8Hs4HL+bp0zcDg0STWnr6DEV/YOsEXUWnsiFtgzOMef9C1C
         mCd0VujVTSqQWv/h92xBrUUfUO07IjJwugPluKEZrX0sIIpQfslEoXNWjbh88IrR57oN
         ieIIKYbuXF52iwtovIK2HHl9wiE1wNt5phaxiBpj6wOktz9WpGit6gzslRea4GW6ab+U
         J03nuCjmPBoyc4nslGg+y9cldUV8KS3Qr32LRxruHRAczF43xf5BbiyYyvlGnM9VzaGx
         oJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EkX8N/foQh79zdmHXhT/3vt7GknIsH61jaJs2i8JOH0=;
        b=cf/8M9JOe/MGhuRyJPCAwoSkD8o7taNloh0EgvsPzchcdhmJYiLYqWRuKNt4kX08Dr
         YQFEfv0UPM/lqR85Ujqir1od0+OZBcetBAdERfnXr7RWSIFf4RVoKVAUAzo1s60LZ49k
         rseJIvLP2JMB1QejTHhuAlXNbd/+B7p4Z5bk7fwZpT+qZo9VIOIBmcHJ2hGE2jKQHg2H
         nb40T/RVa9gSHlJw/cNolvEycPVSMa789DIcGtKMVbc6O0wm8+qR0MCNFnH0CJeh/hkm
         tiumMLKL9LwDnEkjF+0aO10eaRuRmrTscJ6WCLWRfl8pG8jC7DlERZnw7e8DctuWLD/E
         kOWg==
X-Gm-Message-State: AOAM533+qbr3hazg85bnS6SRSsIDLiltxJzjMZ172obDGDMvhi1NNtH/
        qCpV0/twE9yDlLHfB0hques=
X-Google-Smtp-Source: ABdhPJzQwMRguOEcxGL4zKu5NEXMHgfCmxG0ebgGYybD2K/CLVKC8fY2G/X91ZQ/EIJIkmT9jSkW4g==
X-Received: by 2002:a05:6a00:1891:b0:446:c141:7d2a with SMTP id x17-20020a056a00189100b00446c1417d2amr11540913pfh.36.1633095126764;
        Fri, 01 Oct 2021 06:32:06 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id i5sm7687684pjk.47.2021.10.01.06.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 06:32:06 -0700 (PDT)
Subject: Re: [PATCH V6 5/8] x86/hyperv: Add Write/Read MSR registers via ghcb
 page
To:     Borislav Petkov <bp@alien8.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, brijesh.singh@amd.com, jroedel@suse.de,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        pgonda@google.com, akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, saravanand@fb.com,
        aneesh.kumar@linux.ibm.com, rientjes@google.com, tj@kernel.org,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210930130545.1210298-1-ltykernel@gmail.com>
 <20210930130545.1210298-6-ltykernel@gmail.com> <YVX/9Xxxgy5D/Cvo@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <6525a915-fd4f-5875-cddd-06aeac5df896@gmail.com>
Date:   Fri, 1 Oct 2021 21:31:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YVX/9Xxxgy5D/Cvo@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2021 2:20 AM, Borislav Petkov wrote:
> On Thu, Sep 30, 2021 at 09:05:41AM -0400, Tianyu Lan wrote:
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index 9f90f460a28c..dd7f37de640b 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -94,10 +94,9 @@ static void vc_finish_insn(struct es_em_ctxt *ctxt)
>>   	ctxt->regs->ip += ctxt->insn.length;
>>   }
>>   
>> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> -					  struct es_em_ctxt *ctxt,
>> -					  u64 exit_code, u64 exit_info_1,
>> -					  u64 exit_info_2)
>> +enum es_result sev_es_ghcb_hv_call_simple(struct ghcb *ghcb,
>> +				   u64 exit_code, u64 exit_info_1,
>> +				   u64 exit_info_2)
> Align arguments on the opening brace.
> 
> Also, there's nothing "simple" about it - what you've carved out does
> the actual HV call and the trailing part is verifying the HV info. So
> that function should be called
> 
> __sev_es_ghcb_hv_call()
> 
> and the outer one without the "__".
> 

Good suggestion. Will fix it in the next version.

Thanks.
