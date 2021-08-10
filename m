Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5D3E59C1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbhHJMST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhHJMSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 08:18:17 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B8FC0613D3;
        Tue, 10 Aug 2021 05:17:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so1813658pje.0;
        Tue, 10 Aug 2021 05:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nvD6+M9t7qTrvrmcvKckt/OKOvl8Bvz01WtaH3hiQrw=;
        b=W8VJHgJYz2WQSwNj+l2V4hKZLutN1MT1dVCGeD6amKZrIf5ru9mj7Kr5RPC5btWdWX
         RcBrITr2iOAHNEFyRwZNQK2DWBs/jeslabKlgJrh6HL+/vTklPVAPdNaLnbz89wRnuqp
         vInDusDjinU1k1tXuSrvNl+arW4OUoLjK4+N1kssywggZW7Jvt3yFTBcvkkKO5md3u7e
         bBYY198+1xHTBLt8BAqooipJ4q/UaotaCIigVxqnzz3L1RWNDBQzAY5XUbKRG2hYDfQr
         DyJeQjfUNmnEVrq8buf0/t08+AhEw6uB7PdFS6dLDgmOJUh/gxis1n7pHXyKAOel03W2
         Aoig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nvD6+M9t7qTrvrmcvKckt/OKOvl8Bvz01WtaH3hiQrw=;
        b=KQHI85++P3+Hd88kMibAbhjpS1u2RRdz4qSSW37f3YsveDJX8wMjyJ+y6nnalLExUC
         +C3TIZKwC4KA737inxc9TnLI5qm9XJjzrUel3oY4RKWgZcmMQEUJtslU4fnDaUxcs7cX
         BHWlQKCct8lBzL/jZit9TwPIhYPfpgbRizh22kJtCQnLvGKxxNNXoR7hd1DhADs3eWBZ
         ZuaRhgBOKqzCzr/dihLpdZ3JhhVIx1Rx14hevhdLk8nqVBAXgvJJfNY24Nka0VgYjjrP
         4tstNjr8KlgfeQrhkH5upkXDnZk+6Kny2XLbBjfFSOU1UcJ3w0nibtfGgk3heRVzgalO
         jZhg==
X-Gm-Message-State: AOAM530J9Wij/AxcvY2OXwxdVZNaPu9GsyII1ziYBaYJ2PGFOxbNfKd6
        6gARKUHrlzKfD80UksVfk1E=
X-Google-Smtp-Source: ABdhPJzf0LwxUC1SEDmEJ4+woyBt3uEtabjBKjNM9eN5IQM2eh4nYHReWO5vIVqWyXP8Bs1frIDsoA==
X-Received: by 2002:a63:131f:: with SMTP id i31mr348459pgl.207.1628597875367;
        Tue, 10 Aug 2021 05:17:55 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id ls16sm22103844pjb.49.2021.08.10.05.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 05:17:54 -0700 (PDT)
Subject: Re: [PATCH V3 01/13] x86/HV: Initialize GHCB page in Isolation VM
To:     Wei Liu <wei.liu@kernel.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-2-ltykernel@gmail.com>
 <20210810105609.soi67eg2us5w7yuq@liuwe-devbox-debian-v2>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <93f3b1c6-feec-9c3b-c2d0-6fceffd00ae9@gmail.com>
Date:   Tue, 10 Aug 2021 20:17:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810105609.soi67eg2us5w7yuq@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wei:
       Thanks for review.

On 8/10/2021 6:56 PM, Wei Liu wrote:
> On Mon, Aug 09, 2021 at 01:56:05PM -0400, Tianyu Lan wrote:
> [...]
>>   static int hv_cpu_init(unsigned int cpu)
>>   {
>>   	union hv_vp_assist_msr_contents msr = { 0 };
>> @@ -85,6 +111,8 @@ static int hv_cpu_init(unsigned int cpu)
>>   		}
>>   	}
>>   
>> +	hyperv_init_ghcb();
>> +
> 
> Why is the return value not checked here? If that's not required, can
> you leave a comment?
> 

The check is necessary here. Will update in the next version.

Thanks.
