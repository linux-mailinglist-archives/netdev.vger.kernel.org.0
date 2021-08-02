Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FFB3DD682
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhHBNJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbhHBNJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:09:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E25C061760;
        Mon,  2 Aug 2021 06:09:09 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q2so19507713plr.11;
        Mon, 02 Aug 2021 06:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s/dUVvpQRfOjAzBt73Z4sPW5uLvROM0ZUBasKGMCJKg=;
        b=kRMvDASIqRBkh8RnkUbf4UEErYFb5pjTrI6eLr74f8VE9FC14kfOqhTTEmBemGcWD3
         vxF/Oj4Z0mk+mgXZi+CkxzbvUrEg28DPozJRYT1LYoOgvdgCBdrLhlOgqpznXe77ZF+D
         ZRsfi1MTLPkKWKWY6a5qMSDRAgZid5FCeeP8fEMwHWa1vSNeigfHF23aRro1H5sDCITB
         EkTFVr45YxpYj6Y6XQuQIcwcDZu7zU/oMfjlkHdXqZuf7OlMlr3TYL3Nw0k3yZuHftYR
         WAG6jG72nxOzN64BlclBwzp9zH42noiu3RiOVNcjdPpHm0wiyHoYEebWFRLTYg8ibXLV
         BBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s/dUVvpQRfOjAzBt73Z4sPW5uLvROM0ZUBasKGMCJKg=;
        b=EpbTeBRrTUS1UZ0/i/MtcuQjr6RehHs++hdJmmkUqZGqxJc+WAgPF9gjBjfgDJ+dZN
         z//Gm2Pk/MkjcCbJpj7Zey1iuDiHHeST2OD3s5ivanbU2PQJ4+tq9lsSf8Lu6YTkP0XE
         oorIyWpjN7w2fp9POqksiYWJoaVN3ZJJU7P+uZCmu1QdX5Yq/Wukos3ON1VfqZGH+lbc
         0bQ6Bne/8KF2jMZV9bjTJszbtLaOVNCijfgIFMFV30BsNPldTHjjz2xxJrHGEWj2MjLy
         RkZKqMI4ZtOW7/NcNUt2KL4YoUdyYKrccHzpHvprQpJDgB72yb4WOcVdW1beuO5Xxtq+
         lvuw==
X-Gm-Message-State: AOAM533UsCmQjpH87/K14BiugSAFRu45ysTucOJwrTPFQXreHrUFYWo0
        G64YfMFjunivoFTr5EVNvd0=
X-Google-Smtp-Source: ABdhPJx2NfTYcUiQrmyHhfgUguAE1fsYh8w8C7CJUbW8FCsL7TTUQHMc87bO07ZeIOQ6KIC3nB5Wog==
X-Received: by 2002:a17:902:a415:b029:129:5342:eab7 with SMTP id p21-20020a170902a415b02901295342eab7mr2273582plq.26.1627909749426;
        Mon, 02 Aug 2021 06:09:09 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:5:8000::4b1? ([2404:f801:9000:1a:efea::4b1])
        by smtp.gmail.com with ESMTPSA id g7sm6715970pfv.66.2021.08.02.06.08.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 06:09:08 -0700 (PDT)
Subject: Re: [PATCH 04/13] HV: Mark vmbus ring buffer visible to host in
 Isolation VM
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
 <20210728145232.285861-5-ltykernel@gmail.com> <YQfgH04t2SqacnHn@8bytes.org>
 <173823d1-280c-d34e-be2c-157b55bb6bc3@gmail.com>
 <YQfsPv1WC7dnHGDu@8bytes.org>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <b1dcf756-d29c-1e64-f630-ae4c53253656@gmail.com>
Date:   Mon, 2 Aug 2021 21:08:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQfsPv1WC7dnHGDu@8bytes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/2021 8:59 PM, Joerg Roedel wrote:
> On Mon, Aug 02, 2021 at 08:56:29PM +0800, Tianyu Lan wrote:
>> Both second and third are HV_GPADL_RING type. One is send ring and the
>> other is receive ring. The driver keeps the order to allocate rx and
>> tx buffer. You are right this is not robust and will add a mutex to keep
>> the order.
> 
> Or you introduce fixed indexes for the RX and TX buffers?
>

The interface just allocates a buffer and driver will continue to 
configure the buffer to be rx or tx after calling.

