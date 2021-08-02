Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 440EC3DDADB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbhHBOWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235963AbhHBOWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:22:39 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412A2C0701F8;
        Mon,  2 Aug 2021 07:09:00 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t3so17633081plg.9;
        Mon, 02 Aug 2021 07:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/cdM8HpdDM3Yh7GGE7exLVKVMbD9iA/9tyiszM+STgg=;
        b=EyGzIbCm/4WfGRl2TIpRtI8exR5hEZdzfziWgkyJF2rPPiSQ75H+98IAopMmYevfFk
         Ov/fJ43JIQnILsE3s/0qzNMc0nrf6uUXE2j26BExy5g7B3BpTmvtolJxygg5zsp4OzjQ
         /7pE2ruUo+gM4LDOxH4S0QCLE3cZn8HjYiXLd7zaPCzN5tcqN75mDO2ycYHk5nf3h82W
         fzBmyU3qV/42PwBr8KexEQmrjqnx6SCVYEPtgGSjDXNVb1Uffuv26Hb9ID8hcdFyzcOI
         2ZeoAyGM+UdW1S66kVSqZMjoR5QEIes/nzm112DtVAisubEuzui0RUvnkB/UUMAP1zyE
         JLjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/cdM8HpdDM3Yh7GGE7exLVKVMbD9iA/9tyiszM+STgg=;
        b=KCWguRI6XpOC4NANbUmdJU8A2dKRuK8R8fYdNL+T/y2i5pq1CEhNeHe45HxKcHKw7Z
         86ge4xwUvuutP+xU1LxjDEeMvvNjEsVWu2kVa3U1QxxpQMMqARf+5y4M5fp/khkhQT23
         WayH5FKCOBE0JERAK67O8grW/MY7MUbLdbbWxBbVYcVSUcyh3kvrpJ027G0GPXcFrgJd
         UpAq0gShQ9irj3syRYMy17jpzm0mTlxc4mw7VdyGEl2MeNxeiaz/fntlkl+o3aK2BXvW
         IafCL2rZu5XdS8ynS5ivAMw16b68P7ejnCqw++4vWtdbqJ+rzfAWUBmbl4xjDMNqrhOw
         FRkw==
X-Gm-Message-State: AOAM531p54V5x9dsA35BewNi8pOllVsm8IvlHH0EVAzNGznsHIXa1fAx
        kOnx+1AHhY0DeljgNcI3H8g=
X-Google-Smtp-Source: ABdhPJz9/oIt1d6cc74gFPmQ4IHl6g1R2CxfQ4Ko9VZ15V7BmdIE77nzkycqmmDE/JgZuYIJykKPEQ==
X-Received: by 2002:aa7:8148:0:b029:31b:10b4:f391 with SMTP id d8-20020aa781480000b029031b10b4f391mr16506898pfn.69.1627913339735;
        Mon, 02 Aug 2021 07:08:59 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:18:efec::4b1])
        by smtp.gmail.com with ESMTPSA id fz10sm11071046pjb.40.2021.08.02.07.08.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:08:59 -0700 (PDT)
Subject: Re: [PATCH 13/13] HV/Storvsc: Add Isolation VM support for storvsc
 driver
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-14-ltykernel@gmail.com> <YQfxA/AYfOqyqNh0@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <eaeb75b7-7e98-ad2d-0e2c-0565b9db79dd@gmail.com>
Date:   Mon, 2 Aug 2021 22:08:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfxA/AYfOqyqNh0@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/2021 9:20 PM, Joerg Roedel wrote:
> On Wed, Jul 28, 2021 at 10:52:28AM -0400, Tianyu Lan wrote:
>> In Isolation VM, all shared memory with host needs to mark visible
>> to host via hvcall. vmbus_establish_gpadl() has already done it for
>> storvsc rx/tx ring buffer. The page buffer used by vmbus_sendpacket_
>> mpb_desc() still need to handle. Use DMA API to map/umap these
>> memory during sending/receiving packet and Hyper-V DMA ops callback
>> will use swiotlb function to allocate bounce buffer and copy data
>> from/to bounce buffer.
> 
> I am wondering why you dont't use DMA-API unconditionally? It provides
> enough abstraction to do the right thing for isolated and legacy VMs.
> 

In VMbus, there is already a similar bounce buffer design and so there 
is no need to call DMA-API for such buffer. Calling DMA-API is to use
swiotlb bounce buffer for those buffer which hasn't been covered. This
is why need to conditionally call DMA API.
