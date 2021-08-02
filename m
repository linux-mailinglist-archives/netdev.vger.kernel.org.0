Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB503DD727
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhHBNdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbhHBNdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:33:00 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A76AC061760;
        Mon,  2 Aug 2021 06:32:50 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id t3so17496871plg.9;
        Mon, 02 Aug 2021 06:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zaf+5dU3RLSl9eL+MQvIjvf9i9eq7xHute6xnxP/ss8=;
        b=lzLycDZx+VgbDgddV/I+3isOD43Vy0BkIdAf1yHmxOpy7/nQ2h/20I3MZKvLheRAfo
         bQGladbLi22o2mpFkEByG5LNltJK09xhP1gfAPOR8XF9Vgo3NEVD/jyTJznRBYBCRjq7
         mmnAa6JV8TPX7L6HR2Yw9fBKonGL4iSYr9ttnd9k3KcVWf/HnsrrQ0l71AwCJ07/uolw
         qMzfDw7EEeP/xzHEQK5KLJHSpIyFcZ1xwGqJvKS7M/hpYiX31RexDYDQYOH3f8znEAYa
         +gp0X5yO6CkoB7PtXKHyTPRWGAPzTrwFvh3JsjSYhcxB6xBY5Zyqb4DJ96A4xrQjjHm+
         1kNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zaf+5dU3RLSl9eL+MQvIjvf9i9eq7xHute6xnxP/ss8=;
        b=P2kS82OSwWykqqvjaChOiNB9NvFggxFAgoeIxXUQk9IMCrel0iyI0PjCZAHrCVSG0o
         cUO83IOEKpcoVPogUvfUK+Zr3x3ViZQEADlq9ym3kl77DcuKQwsB1J8BeWXs9C33hm3f
         PDTJZyXOZW6ZREs7UnBPb9zq8RZdxuGWG8sG5t9zzMf9uKnWmlFfKKGMuMsQRkRBUl3i
         8VGExj5Ey7kDzHsGmfhnwav5PhIRDAnAQSsW1NHo45WwRMaIWiDswa417I6XvfH6AGh0
         C/hdjew8+6XYZQgfx//slqjvj+70dt8BbrTJbpb41yT/iTtg6Qfn2lQxADtO1ikzpIvc
         v7SA==
X-Gm-Message-State: AOAM53239WV9aS8WXUVTuwjgEtkE8C04TTnWCHNQdhvF1UaONFjUBoO1
        rqLWJdhaErWHaTFsadCeQhQ=
X-Google-Smtp-Source: ABdhPJw26TcdJx7nJdP8OVOffK3BNROQGPQJnGpjzP8q2wSE+WsIrRM3Kk21HhrucVZR9IjyKRevpw==
X-Received: by 2002:a65:6a01:: with SMTP id m1mr1550797pgu.201.1627911169578;
        Mon, 02 Aug 2021 06:32:49 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id f5sm11780560pfn.134.2021.08.02.06.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:32:49 -0700 (PDT)
Subject: Re: [PATCH 06/13] HV: Add ghcb hvcall support for SNP VM
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
 <20210728145232.285861-7-ltykernel@gmail.com> <YQfnlBwyZUJyixQX@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <436a4eda-bed2-9107-e297-3dee381354ff@gmail.com>
Date:   Mon, 2 Aug 2021 21:32:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfnlBwyZUJyixQX@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/2021 8:39 PM, Joerg Roedel wrote:
> On Wed, Jul 28, 2021 at 10:52:21AM -0400, Tianyu Lan wrote:
>> +	hv_ghcb->ghcb.protocol_version = 1;
>> +	hv_ghcb->ghcb.ghcb_usage = 1;
> 
> The values set to ghcb_usage deserve some defines (here and below).
> 

OK. Will update in the next version.

