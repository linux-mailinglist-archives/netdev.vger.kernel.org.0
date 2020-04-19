Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830AA1AFE45
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgDSVEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725891AbgDSVEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:04:06 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66ADFC061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:04:06 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x4so8754696wmj.1
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=f19cLCmMJgavyF8w71UStps1xPazBu/R/dbm7fFYcSU=;
        b=QgeDnUEeLGmA/VA4doRVbkGDt4K+zK5jOFPM7popoGm0kWHK7ceWSQhmVvCnJDV66T
         G3bSJlECNpDp67R4vM4KgpVHJbzjJ4oTRz9oZ1z67OIr7t1xKato4/cF1FqH/dfNeK38
         DjTFPbC7QLhqxLiTv5SOAU0MYpB0//NE4miLiyh4zWRLDQ1qeYluocaeP3PnUIgBSHsv
         aSn8qaXkj8ehUmYWBoBEDJrWC6RkouxpjsoSDZ4qwKfmTLIYPZ9WRnc6nVdPPW+Wwi1P
         l4mmYDYuMzze/0jOuLaml/L3oZ0hTbeIc/EUaSClbqWs/67o/ywjssgF2DJx2z7voCL3
         Gt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f19cLCmMJgavyF8w71UStps1xPazBu/R/dbm7fFYcSU=;
        b=V+2f+cX/KqIiCCkrI80beEcBIddN6jYXXbBoXcOam9u+DCSwm5BnvPfX6OqYHiJJOZ
         3SMRiWxnWwhxdeBoaYk61IYlG87dkbVcAYZy6xvTzUtfaglSgt3NVaVwIHixZWrQpp35
         ysq3Zyy+do/MckiGrhgVJaWiMP85uzf6D+jk7J5eVRGdgpm/HBZ+UEVz0kdwrZoLlSrL
         DEeJvd8tGlEQ7BI0QutOJMYJ74zj5g6vu6wlvz3p+koHRK1y5WCHfQy05Xw8UmvmOvdA
         DTZDR6m11XTQo/iWshZS6PsAphPanBGDbaNXLn7urUlHmqNFutbQiGRZv06wlLpKWFQv
         ruBQ==
X-Gm-Message-State: AGi0PuaNnQYY7Lyp9g9OQah36WAZjixG+AyzVZNFluHTC4dejRtvDX8y
        /lWcSWe0OsGCZnzB8wG0Cfyg7RbC
X-Google-Smtp-Source: APiQypKFl/mypY7tJbFSTIx48AMC6Ku0BkjEGm0A+Gixe/vPYtr1YZy7usdDy4Y/T8d0U7LM4cMlaA==
X-Received: by 2002:a1c:8141:: with SMTP id c62mr14132666wmd.87.1587330244710;
        Sun, 19 Apr 2020 14:04:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id w12sm27083632wrk.56.2020.04.19.14.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 14:04:04 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] r8169: use WRITE_ONCE instead of dma_wmb
 in rtl8169_mark_to_asic
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
 <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
 <20200419190029.GA37084@carbon>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <3bd2992b-e0da-0ee6-ae82-03d75e8fa706@gmail.com>
Date:   Sun, 19 Apr 2020 23:03:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419190029.GA37084@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 21:00, Petko Manolov wrote:
> On 20-04-19 20:16:21, Heiner Kallweit wrote:
>> We want to ensure that desc->opts1 is written as last descriptor field.
>> This doesn't require a full compiler barrier, WRITE_ONCE provides the
>> ordering guarantee we need.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 2fc65aca3..3e4ed2528 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
>>  {
>>  	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
>>  
>> -	desc->opts2 = 0;
>> -	/* Force memory writes to complete before releasing descriptor */
>> -	dma_wmb();
> 
> If dma_wmb() was really ever needed here you should leave it even after you 
> order these writes with WRITE_ONCE().  If not, then good riddance.
> 
My understanding is that we have to avoid transferring ownership of
descriptor to device (by setting DescOwn bit) before opts2 field
has been written. Using WRITE_ONCE() should be sufficient to prevent
the compiler from merging or reordering the writes.
At least that's how I read the process_level() example in
https://www.kernel.org/doc/Documentation/memory-barriers.txt

> Just saying, i am not familiar with the hardware nor with the driver. :)
> 
> 
> 		Petko
> 
> 
>> -
>> -	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
>> +	/* Ensure ordering of writes */
>> +	WRITE_ONCE(desc->opts2, 0);
>> +	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
>>  }
>>  
>>  static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>> @@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>>  		return NULL;
>>  	}
>>  
>> -	desc->addr = cpu_to_le64(mapping);
>> +	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
>>  	rtl8169_mark_to_asic(desc);
>>  
>>  	return data;
>> -- 
>> 2.26.1
>>
>>

