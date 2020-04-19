Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FF11AFE73
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 23:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDSVwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 17:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725848AbgDSVwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 17:52:36 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927B6C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:52:36 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j1so4359604wrt.1
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 14:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5EBtWzyzJoU62lqyWNmTVLSHb7p2bzgrGwng8/TVnBc=;
        b=PfpMHllCzvPovQTTpReANtds8hbP7MkcglzA6CpzaRtsO7NkFtwcvvuEL5Xlcs9+vl
         rCNdsXy6FEGgTehb4s+krkFnINBEvf335G+lvLQyw93M8Fl9VI/dTHX24JUsaElMcurT
         uFWAOF6cpZeir13wpakwok6oHYDg6fhqCRX7Al4kA9cJDYt+I0l2AY9zix7lQPAZTzeM
         PElny3faGuio+ljQ23L6N++HWCQY06DZ/ooH/SA3rT6SarErYHviTGDwyysMm/U9XglV
         VoRZt3aQtx/9YENJzprOHcCcDMjMv7j9XxEolfUezKkJWFQ8q+pWnJEd1MONHvvW40yo
         6ciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5EBtWzyzJoU62lqyWNmTVLSHb7p2bzgrGwng8/TVnBc=;
        b=EuVaJ0Ruc6GwJdG3gmjpfPpW7iJqepF+nBfmSYIW63lUmPFqqKkt8HmyoI5bODkgpW
         FlT8G4EjRki0Z4WccsLsWlUYdvAb/c1b/06u6diUnGvkPzb1Z7DY+7sTwwAnAPMmFyqa
         vHIrFijx8fc+TAIaLW0npDaKmdbpnfAFJpLF9u5CngiyKCBG1bO0WgwECvm9SRJ5arwI
         OzZNcsnx8hN/Z3AQigQrFIPiAK0W7kz7ZaeZ77v3noPDtQxqYFJBAd70Mg5Po/rBU6cT
         r5qU4vKqOeEe3Cu+VU9ijKqrjfSSOIiHzVOr0q66r5U6uOPiCLailPsNfyEUqgoAWpQh
         2LBg==
X-Gm-Message-State: AGi0PuZfIXSQWuUTWC2rgRhuGpv03UzxnTDalWh5LcpEN5Oz9a6w6s5l
        R0WacLJADWZPGu5ObDD1O9RcZYx+
X-Google-Smtp-Source: APiQypIj/BRBo1ctA/QWyxmVFUDTbHg20fJ9Gatiy3XsjCmTMIBSPozMxzDy7sD+vV6+AHJeRWuVHA==
X-Received: by 2002:adf:fe12:: with SMTP id n18mr2979429wrr.29.1587333154883;
        Sun, 19 Apr 2020 14:52:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id s17sm17494348wmc.48.2020.04.19.14.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 14:52:34 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] r8169: use WRITE_ONCE instead of dma_wmb
 in rtl8169_mark_to_asic
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
 <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
 <20200419190029.GA37084@carbon>
 <3bd2992b-e0da-0ee6-ae82-03d75e8fa706@gmail.com>
 <20200419213817.GA39723@carbon>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <19c7d811-5e41-011b-b35f-c4bbe7d890ee@gmail.com>
Date:   Sun, 19 Apr 2020 23:52:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419213817.GA39723@carbon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 23:38, Petko Manolov wrote:
> On 20-04-19 23:03:57, Heiner Kallweit wrote:
>> On 19.04.2020 21:00, Petko Manolov wrote:
>>> On 20-04-19 20:16:21, Heiner Kallweit wrote:
>>>> We want to ensure that desc->opts1 is written as last descriptor field.
>>>> This doesn't require a full compiler barrier, WRITE_ONCE provides the
>>>> ordering guarantee we need.
>>>>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> ---
>>>>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
>>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index 2fc65aca3..3e4ed2528 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
>>>>  {
>>>>  	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
>>>>  
>>>> -	desc->opts2 = 0;
>>>> -	/* Force memory writes to complete before releasing descriptor */
>>>> -	dma_wmb();
>>>
>>> If dma_wmb() was really ever needed here you should leave it even after you 
>>> order these writes with WRITE_ONCE().  If not, then good riddance.
>>>
>> My understanding is that we have to avoid transferring ownership of
>> descriptor to device (by setting DescOwn bit) before opts2 field
>> has been written. Using WRITE_ONCE() should be sufficient to prevent
>> the compiler from merging or reordering the writes.
>> At least that's how I read the process_level() example in
>> https://www.kernel.org/doc/Documentation/memory-barriers.txt
> 
> WRITE_ONCE() will prevent the compiler from reordering, but not the CPU.  On x86 
> this code will run just fine, but not on ARM or PPC.  Based on your description 
> above i think dma_wmb() is still needed.
> 

After reading a little about ARMv8-A and weakly-ordered memory I tend to agree
with you. It's a pity that I don't know of any use of Realtek network chips
on such a weakly-ordered platform (what of course doesn't mean it doesn't exist).
This would really help me in testing and avoid such "but it works on x86" ..

> 
> 		Petko
> 
> 
>>> Just saying, i am not familiar with the hardware nor with the driver. :)
>>>
>>>
>>> 		Petko
>>>
>>>
>>>> -
>>>> -	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
>>>> +	/* Ensure ordering of writes */
>>>> +	WRITE_ONCE(desc->opts2, 0);
>>>> +	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
>>>>  }
>>>>  
>>>>  static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>>>> @@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>>>>  		return NULL;
>>>>  	}
>>>>  
>>>> -	desc->addr = cpu_to_le64(mapping);
>>>> +	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
>>>>  	rtl8169_mark_to_asic(desc);
>>>>  
>>>>  	return data;
>>>> -- 
>>>> 2.26.1
>>>>
>>>>
>>

