Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8DB3F33AF
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhHTS0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbhHTSX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:23:56 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CD8C0611C2;
        Fri, 20 Aug 2021 11:21:13 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x4so9986632pgh.1;
        Fri, 20 Aug 2021 11:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FnnZUNvhPvIx/VcFIRs7Mx/cKrQt7VgripjVwaHxsaI=;
        b=nOkgFzUUeuE2uOq6KpBWbmk2uCSVbcFBzkWKWriACYTXwD2Dfd42Y/PQxXFWgP/UQB
         TogIgojLtlyPz9QZAvWYG7x2Pth4sWyW9aCIzNRMkahsKt7LnIP0hQceLcgKHpy70hBM
         tN3pbDH8t4qDq8nt48kTuMyGdfR+karexcyZbSVJGxqKp8Xjr7WSOFalJR4zWRTyN9eU
         cS/bv7TIGxxMVY+JEwNGmD+vn6WhpJX2S3CF5XZsTbPF9biARKkYXKoQGAuaOxtAT4R5
         vG04+TCNyrhDuU8ZUFurYQVnP2CxwvKxr71yt2ETcHsuHN50myIZUfVBAsyoQwK7oxl8
         TKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FnnZUNvhPvIx/VcFIRs7Mx/cKrQt7VgripjVwaHxsaI=;
        b=lT24w5jkNezfMbpXVvKatR1Q2ooiBJKVbkGOWLAUWqUqPK1fChPlRGutWHnMcKli4B
         +I5gwSGOsG9xZfjHafYNuDsXrD88yeMQaG+yZz5iHVSAihq6pgfY4WQSlpgB37utNHKv
         Y9gycczLVkgtIJR90y1hTOYMerkkJZypgo06fzPj1QBLlcGGCeBNcuBZ4VoHT25GskBm
         OR10/MPvGqbq49X5IvX0EoDrAz+MYQzkXn9566ut2+enWpO7NSIEACs2uQxOftFGk0Rd
         w5+3linZdJm0FQhAkSuhMYQWFXUzgsTmI+6v0aFMsaXWrlDkzRG8a1Tp/e9b4bp7o3S7
         N7Ig==
X-Gm-Message-State: AOAM5325vx1yIGrnTs7qAVEevL3yG+xkDjscNbOhTTMalBdkHpHrcb01
        eQpU/sfM5KP0Ff9HR53q/r8=
X-Google-Smtp-Source: ABdhPJxzsYelAgPwIrLwHXwqEGliJ5vS+we4MW2tj375Z/nX9HFwmx8yp+6BPHWxDivdPsW7WY4m1A==
X-Received: by 2002:a62:78c1:0:b0:3e2:bdc:6952 with SMTP id t184-20020a6278c1000000b003e20bdc6952mr20448852pfc.45.1629483673512;
        Fri, 20 Aug 2021 11:21:13 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id n12sm9253074pgr.2.2021.08.20.11.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 11:21:13 -0700 (PDT)
Subject: Re: [PATCH V3 12/13] HV/Netvsc: Add Isolation VM support for netvsc
 driver
To:     Michael Kelley <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>, "hch@lst.de" <hch@lst.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-13-ltykernel@gmail.com>
 <MWHPR21MB15936FE72E65A62FBA3EF4F2D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <713480b3-f924-60dd-96a4-b6318930383f@gmail.com>
Date:   Sat, 21 Aug 2021 02:20:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <MWHPR21MB15936FE72E65A62FBA3EF4F2D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/2021 2:14 AM, Michael Kelley wrote:
>> @@ -477,6 +521,15 @@ static int netvsc_init_buf(struct hv_device *device,
>>   		goto cleanup;
>>   	}
>>
>> +	if (hv_isolation_type_snp()) {
>> +		vaddr = netvsc_remap_buf(net_device->send_buf, buf_size);
>> +		if (!vaddr)
>> +			goto cleanup;
> I don't think this error case is handled correctly.  Doesn't the remapping
> of the recv buf need to be undone?
>

Yes, actually I thought to return error here and free_netvsc_device() 
will help to unmap recv_buffer finally. But I forget to set ret = 
-ENOMEM when add netvsc_remap_buf() helper.

