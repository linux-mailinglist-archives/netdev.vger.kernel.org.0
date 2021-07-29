Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E028E3DA3A4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 15:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhG2NCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 09:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbhG2NCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 09:02:10 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83771C061765;
        Thu, 29 Jul 2021 06:02:06 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id f13so6921510plj.2;
        Thu, 29 Jul 2021 06:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xWZDnZQ7Uje44tOvyd+WhPXcE6YbxVNUTkV2DmxlC/I=;
        b=ExonRuvAP6deeZWP4ARMhx8XszTEeQWKqexdxGr8TsuL+Bz8VPrFj6Y730SphdAQDC
         84Fqe2zxnVuAY/b+yUA8Eq195vN/ev0qbH1bKyG9MpEY83Z3AAYzJOmRRNOSb1q264YH
         H1r0MDXkAlN2lmoLmNB9pMzmaE8qMyQJV2yXvzwM4lU7+cUmxyAefZ33Vtx/QsvY0B2Y
         7299cOKI8WViF8nwItNn9KeFY/6ShDYN3GG/09Lm/PkrJetdxTquTYKbp14IyHKNKJri
         w4KULmdKqUg3LoIRw+FRYrv+H/B2Jf9av5u6lx3SllYemnIcK4W70fMX/uAcJnqsyzu9
         1r1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xWZDnZQ7Uje44tOvyd+WhPXcE6YbxVNUTkV2DmxlC/I=;
        b=OKSsg36e2e0ZcnJpSj2aoLw7c6+REdPtjvpZ/b1IqKRyUvsRcP9N16R+FrCqK8UK/f
         7AekgCk+pEXIGbjUJsosowiKw/P/z35J3ic/Cflhq9jJtTgnZF75LMCdHTbFNrJy+GeM
         jbmkvPs72e2YdwAagE83Q3/SWQAHGBW4H2aXdNGH/PSgcXoW+mT3dB0U7N5liIQFfVI4
         7DnEyCfvAN15hvQ8MWRKpYrysmhUjCt4nslMC5XDTb5S58Ekv7PbHh19d4isTs5yGPMD
         vqe6U+klAS2j6e5MAP/UPP/eNRA6YXyYCadPUK9W0SvIBcpEvAxuPko3UXywvSmxZLAL
         QRsA==
X-Gm-Message-State: AOAM531dX/7sgntf3H/1rq+UMQYYzdKThFIzYGN5cG46iWGxyJnYZgSA
        nz1rxUK/zGspf/yvmlWd5o0=
X-Google-Smtp-Source: ABdhPJyrI/P/7aQeOr7fGMy78ZxY6RcR1Rwj4jALXoPGmX2VorLJRrRMQ6J111Dxy7HnP0DgW7LcpA==
X-Received: by 2002:a05:6a00:24c6:b029:332:6773:165c with SMTP id d6-20020a056a0024c6b02903326773165cmr4937276pfv.33.1627563725957;
        Thu, 29 Jul 2021 06:02:05 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id w2sm9730504pjt.14.2021.07.29.06.01.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 06:02:05 -0700 (PDT)
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
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <0d956a05-7d24-57a0-f4a9-dccc849b52fc@gmail.com>
Date:   Thu, 29 Jul 2021 21:01:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a2444c36-0103-8e1c-7005-d97f77f90e85@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/2021 1:06 AM, Dave Hansen wrote:
> On 7/28/21 7:52 AM, Tianyu Lan wrote:
>> @@ -1986,7 +1988,9 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>>   	int ret;
>>   
>>   	/* Nothing to do if memory encryption is not active */
>> -	if (!mem_encrypt_active())
>> +	if (hv_is_isolation_supported())
>> +		return hv_set_mem_enc(addr, numpages, enc);
>> +	else if (!mem_encrypt_active())
>>   		return 0;
> 
> One more thing.  If you're going to be patching generic code, please
> start using feature checks that can get optimized away at runtime.
> hv_is_isolation_supported() doesn't look like the world's cheapest
> check.  It can't be inlined and costs at least a function call.

Yes, you are right. How about adding a static branch key for the check 
of isolation VM? This may reduce the check cost.


