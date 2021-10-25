Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA5439651
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhJYMaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhJYMaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:30:11 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C855DC061745;
        Mon, 25 Oct 2021 05:27:49 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id oa4so8158765pjb.2;
        Mon, 25 Oct 2021 05:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p8WaOHRGKmCaDSlRzJCYAFZWQ0rBLs7pDgy7EDMtyv8=;
        b=L3ZA9KP749BkYnNdoLq4iP7i1iR+Inqszxis10+kYWlw8gMmznXCDRlWSk8/2W8+Ed
         9bDXkV+bYYJe9UKKOcIICGmZU+DR1h5CcBxZnvDZgIDl/oug/Akndp3keMCbwTbIbaBF
         5rdvHNz0ZL5YeCmsrx+Z+io4+jf8NyPwyGvCbqH69zBVzaMv9XE43xcDy0L5z6rENGpq
         Foc1NEQN6bXXudQD3feVI4XK/k6oZtmy5+WyLRbLtSz+GtPPrrK6YbssXo7wiSx53xpp
         CGnvIQo8fLJ4M0P23prTJJ3wBJPkpOux9B4wd5S8LvAaTF83kEBJrnI/u9vvmT3SJYT3
         Pqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p8WaOHRGKmCaDSlRzJCYAFZWQ0rBLs7pDgy7EDMtyv8=;
        b=ZHyIepDo11CU0lJjro8IPdGQrtOg63uFii2bqa9hJN7+fm8qO7cDM+zeLDDI+RPo4a
         XnFCq6RwPm+3cslntn/3NthwpXer1l3vRSSyWAfsPhNK/D8Hl30sG9vHtg9Ka/E6P6JS
         DabDFYbNwPYne5SMdOIiP2/ra7NLSq+vNlmoQoSfB+gxi7VPGJPFUOMjb+tc3G3CXEBJ
         0Y0F2j3krWBZq34/enGXSWXhv4mxAJrV/QUK2sQ30kdCUVYuVLgxq1z132m6NGK1DhiC
         u31DMtdAjM1LJ1Fs/js7N3sq8gBn5WOW0N+yCzfnMl2+R20TwdNuYcSNd8hIcIyZ/Qf+
         oKsg==
X-Gm-Message-State: AOAM53172bF3CZPS0Lw6+Xkfu1SjV/nIu3LLpxKylVDw0gDrwcsx93gx
        oubMfcVayPsRy4QMXHUkMlA=
X-Google-Smtp-Source: ABdhPJyKPJBKL8xU27ieGid+51hzfeq0fdWcgDM9p/IEj6NGJE/Azd0kkuSJAyEkc02dcJFZkZDQgA==
X-Received: by 2002:a17:902:db0a:b0:13e:e968:e144 with SMTP id m10-20020a170902db0a00b0013ee968e144mr16394794plx.43.1635164869361;
        Mon, 25 Oct 2021 05:27:49 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id c4sm9143338pfl.53.2021.10.25.05.27.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 05:27:49 -0700 (PDT)
Message-ID: <f5b6f9e8-5888-bd5f-143f-a7b12ec17bbb@gmail.com>
Date:   Mon, 25 Oct 2021 20:27:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH V8 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Wei Liu <wei.liu@kernel.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        brijesh.singh@amd.com, jroedel@suse.de, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, rientjes@google.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, saravanand@fb.com, aneesh.kumar@linux.ibm.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com> <YXGTwppQ8syUyJ72@zn.tnic>
 <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
 <20211025112033.eqelx54p2dmlhykw@liuwe-devbox-debian-v2>
 <YXaT5HcLoX59jZH2@zn.tnic>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <YXaT5HcLoX59jZH2@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/2021 7:24 PM, Borislav Petkov wrote:
> On Mon, Oct 25, 2021 at 11:20:33AM +0000, Wei Liu wrote:
>> Borislav, please take the whole series via the tip tree if possible.
>> That's perhaps the easiest thing for both of us because the rest of the
>> series depends on this patch. Or else I will have to base hyperv-next on
>> the tip tree once you merge this patch.
>>
>> Let me know what you think.
> 
> You'll be able to simply merge the tip/x86/sev branch which will have it
> and then base everything ontop.
> 
> However, there's still a question open - see my reply to Michael.

Hi Boris:
       I just sent out v9 version and compile hv ghcb related functions
when CONFIG_AMD_MEM_ENCRYPT is selected. The sev_es_ghcb_hv_call() stub
is not necessary in the series and remove it. Please have a look and
give your ack if it's ok. Then Wei can merge it through Hyper-V next
branch.

Thanks.


