Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8988F360420
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhDOIUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbhDOIUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:20:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272F5C061574;
        Thu, 15 Apr 2021 01:19:56 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id g16so2268651pfq.5;
        Thu, 15 Apr 2021 01:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=55qzNVVtKjr2EGfMAcgdM/oHJ/MI5Oe+cwdS/Ji0ZVI=;
        b=j1tVlhHWeqCzmIWXEopfN2gvVhO87Jr/RyNB0t/arTH8+bg7DKBr+fI040TTp9S9dB
         /NzzFMy3hbY/ewwcaITstDzoy52Wgs4wGuQ5U5o4uPJowRFrrEnSMnP8N2Qb3i5zZjXQ
         sCqSMpYbitygg49aIHDhasd3Pi72eqGwhTPoAnW1qgSzqZW7XWXrv/4JCx9LSDXMvhzf
         znL5/rmGU9y1+OFti8QmL1ryMuD9so/V9sqtlzAaVReyqpoDpbqtdZOG7VIAMj0ZL4w4
         Kv0HXVb9dekpbqJdlNhLG+oY2Owt4l/wcViRbNFuH7o1uikboz9/tlwvLhkf0FLxKmmz
         xTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=55qzNVVtKjr2EGfMAcgdM/oHJ/MI5Oe+cwdS/Ji0ZVI=;
        b=JGoz6Crs1qH1AMfpCkqkeQx9IylV5HCIC98ReJTHTGltQGyFP5Y1gGyJVhbjubCG3n
         wCbX29hjzJ/lRZ/7EgmXo77JFmr8DQC34JfmxNPUoKpvIs/6LPf6zGwYSSzOw0/v3P1Z
         8EbcPgcEIZNJHCGnHlGU2SE5LgJ3zdWNbhY2sFPK4WK0MMQkMw7npwH96UUltcIm3NXo
         k8Wwo0t9T5lAT6w56VgU8S339iO5pOgCBndcfJEvhPeoG5aycyuReXp7TxZudPBliuL5
         DsIA3n1u23riz1tBje3sP2wSgSp86dKG4yjZLUtniFi+5xy2Zueh6rDpcXMaxiAIqy82
         /sfw==
X-Gm-Message-State: AOAM532hy3Pztf/EZCK9am1Mdz5y8WJNLiX0wI0xYmolz8gYTC/PRF6V
        SFX+sd8qh7zejvuctXTJT9AfqeWyOsh60dyQ
X-Google-Smtp-Source: ABdhPJwWGtaQnufAXInm7v66wKabfVJG17NJUFp65axa03YX5DYY821+MSztj4RCKZDgwDB8o2T9wQ==
X-Received: by 2002:a63:470f:: with SMTP id u15mr2378163pga.199.1618474795726;
        Thu, 15 Apr 2021 01:19:55 -0700 (PDT)
Received: from ?IPv6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id h21sm1732615pgi.60.2021.04.15.01.19.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Apr 2021 01:19:55 -0700 (PDT)
Subject: Re: [Resend RFC PATCH V2 04/12] HV: Add Write/Read MSR registers via
 ghcb
To:     Christoph Hellwig <hch@lst.de>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-5-ltykernel@gmail.com>
 <20210414154141.GB32045@lst.de>
From:   Tianyu Lan <ltykernel@gmail.com>
Message-ID: <d35e6ab5-cb25-61aa-e36e-7e4bcb241964@gmail.com>
Date:   Thu, 15 Apr 2021 16:19:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414154141.GB32045@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/2021 11:41 PM, Christoph Hellwig wrote:
>> +EXPORT_SYMBOL_GPL(hv_ghcb_msr_write);
> 
> Just curious, who is going to use all these exports?  These seems like
> extremely low-level functionality.  Isn't there a way to build a more
> useful higher level API?
>

Yes, will remove it.

