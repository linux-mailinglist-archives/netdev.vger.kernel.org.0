Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B956B39DFE5
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 17:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhFGPCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 11:02:53 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:36789 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbhFGPCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 11:02:52 -0400
Received: by mail-pg1-f171.google.com with SMTP id 27so14017364pgy.3;
        Mon, 07 Jun 2021 08:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LBQFfB81E+P58yjRe+k2+cx97sDCbuPy/V/8bIJeXkc=;
        b=d1nEfDWwq7FWKqIFyB7wcvXzmP+qszgIuZNrjkwP3x1/yDu+sQSJ4TgOka8JMFwdpz
         FbG95ETwwZelyW9y9nYy/fBdQQ5EpoXh41Gbn4eQmQTaoxF5map34fNshbDgQ+GKj1eQ
         M2HNtozQY8mDF7hXNffuvHHSZK/H+HS3mDWozeDZ1wrNV7N6DSSxBit7yoz2Djn0vKsu
         PTtFJD9Ofb3TtKRa65oNYY7gKKMzGB1TuT8lxEnUuKWvE9MiqzfZDCghwXldP+Yap8sq
         BhmGax5uZd/Z3aYrXJPVjrW6XKPjEpwSZcuA8L3oguKgjEhjLQ9bi63V9oWBmfiZKAst
         VQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LBQFfB81E+P58yjRe+k2+cx97sDCbuPy/V/8bIJeXkc=;
        b=l09nOkgcvg+YBP4lNEGOB9tR+Vf9c0s7nHnIRgSTBria6bL8V8q73onXABynKzglnE
         MZSI08FXq+mbBnzGl7COD5OCr28+CtA/T4tqsPX4NL+SVrf27VvBSJbrVXryUD9na4aO
         ElyCJjb+ZutONyP4NoUCo4zhJ2oRqzDH1V6c4lqiw7jNB2/s91pMHgIbq1AHHT+NWB+h
         f6r6w1ugCYjCKhaWW0PmkJZSDcjWBEyYaa7Ue4kGWrNM71sy/2RDi6iwBD+dlrhz6oRx
         AH6WeBowRVrimqB8tmczGkY5zLyGeQ5te80afsi6fSoaxlmuLB7/1FyZsO0nYrMG4itd
         6QWg==
X-Gm-Message-State: AOAM530c9LmcYFtZqp5izHbpfW1ZL6gUjeBn59s3Zb5TO3886USPtcz+
        BmVkVHEqKJAu3ev+EwRE8O0=
X-Google-Smtp-Source: ABdhPJxA6AxF//BtD4CX3ss9LWnlUG4jgLj+0PRFw+NP8biHDKV1XDA0j2C9BbRScevume4H06cdTA==
X-Received: by 2002:a63:7d2:: with SMTP id 201mr18504206pgh.14.1623078000846;
        Mon, 07 Jun 2021 08:00:00 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id x6sm8711203pfd.173.2021.06.07.07.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Jun 2021 08:00:00 -0700 (PDT)
Subject: Re: [RFC PATCH V3 11/11] HV/Storvsc: Add Isolation VM support for
 storvsc driver
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        hannes@cmpxchg.org, cai@lca.pw, krish.sadhukhan@oracle.com,
        saravanand@fb.com, Tianyu.Lan@microsoft.com,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
References: <20210530150628.2063957-1-ltykernel@gmail.com>
 <20210530150628.2063957-12-ltykernel@gmail.com>
 <20210607064603.GD24478@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <26c771e5-a64e-f2cc-e245-fa5f130f4b18@gmail.com>
Date:   Mon, 7 Jun 2021 22:59:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210607064603.GD24478@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2021 2:46 PM, Christoph Hellwig wrote:
> On Sun, May 30, 2021 at 11:06:28AM -0400, Tianyu Lan wrote:
>> +				for (i = 0; i < request->hvpg_count; i++)
>> +					dma_unmap_page(&device->device,
>> +							request->dma_range[i].dma,
>> +							request->dma_range[i].mapping_size,
>> +							request->vstor_packet.vm_srb.data_in
>> +							     == READ_TYPE ?
>> +							DMA_FROM_DEVICE : DMA_TO_DEVICE);
>> +				kfree(request->dma_range);
> 
> Unreadably long lines.  You probably want to factor the quoted code into
> a little readable helper and do the same for the map side.

Good suggestion. Will update.

Thanks.
