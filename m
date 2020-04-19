Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D7C1AFEAB
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 00:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSWdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 18:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725891AbgDSWdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 18:33:20 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC338C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:33:20 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x77so1394622pfc.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 15:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vyGAQsXwqIfR4e40mfxI7RqlHu0Kl9GLF1zWxRL003k=;
        b=ACrIMxg0Yl4WmXNEO/JHHwHrCnLvzg7mI7ITkNtFBZmoMTE/55wpVt0+AMxgiMSLAM
         tNtvIg4VX0K1QcmodKLgn+FNPm9pdK8lgYAYJNVEBiHQAwzSUcJ2iv3i73KsSonZnQPJ
         Vu3lCm48BRRotpOtYim+PJw0QhCJA0YhlIgSEO9U7abHiLF1QHce4DZMtwnmIt6ddmrl
         55bdRxpGqQqVyNeXJ/wPb83pLbiTLJcOvUZ7EKoIorL7StCL2XuJUuVTlh2vBm+WVwl3
         pDjTuG9+Ylzna10ZMtm3KbzlYSqpa+cF7Dyo729tcANcu/MA6EVj6vCzCFNMbS3IVUR8
         mjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vyGAQsXwqIfR4e40mfxI7RqlHu0Kl9GLF1zWxRL003k=;
        b=N5C4VWgN35qz/LReC7jmGy7hUkT0ukoo+WRrxOmfTeiGA/JdP7mfz/gGZ853mUbdbb
         NWu+Ro+OA7bgbgnVvgZjyuzKlIHJwj61xQ5wjSycJDVpksUwQ4VGWVioK2x/TDLZjkJT
         JrofzZebM3vs+N8O+EANtxyk+RvzyV3OvHCdMShiBXDIhEdIAHBO7MLaLybIKLcSDCLv
         sp42chP2bc9NctQYfgNx7LGZ8KlzxrR8p174Ia0aQofY/qF8K/rPx8FXUYEpz9kjef5J
         HNkLlaYyqp/vMFl90J5a/pIF4wHGn18pvLyYrC6dJKecCxFINARkS43t4Bobh1mtmjNW
         Zc4A==
X-Gm-Message-State: AGi0PuaJKIq5fdD/+ZZVuq8hVRBWgBnVFBQlCS3+JPnOKshpCQab4x/s
        kn06y3x9W9iho9qGlyuCowmS+B4M
X-Google-Smtp-Source: APiQypKfKfjlRxleW/wOfe4pArZ0MdmRtzFL+GyV5A2q2x673/AMX4pzqQsfnEtihW2YKDNx/pzyBw==
X-Received: by 2002:a62:5209:: with SMTP id g9mr7586702pfb.220.1587335599899;
        Sun, 19 Apr 2020 15:33:19 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o125sm23808055pgo.74.2020.04.19.15.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 15:33:19 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] r8169: use WRITE_ONCE instead of dma_wmb
 in rtl8169_mark_to_asic
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
 <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
 <20200419190029.GA37084@carbon>
 <3bd2992b-e0da-0ee6-ae82-03d75e8fa706@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b899d4c7-6332-f10a-7049-821bdd1086b0@gmail.com>
Date:   Sun, 19 Apr 2020 15:33:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <3bd2992b-e0da-0ee6-ae82-03d75e8fa706@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/19/20 2:03 PM, Heiner Kallweit wrote:
> On 19.04.2020 21:00, Petko Manolov wrote:
>> On 20-04-19 20:16:21, Heiner Kallweit wrote:
>>> We want to ensure that desc->opts1 is written as last descriptor field.
>>> This doesn't require a full compiler barrier, WRITE_ONCE provides the
>>> ordering guarantee we need.
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
>>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 2fc65aca3..3e4ed2528 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
>>>  {
>>>  	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
>>>  
>>> -	desc->opts2 = 0;
>>> -	/* Force memory writes to complete before releasing descriptor */
>>> -	dma_wmb();
>>
>> If dma_wmb() was really ever needed here you should leave it even after you 
>> order these writes with WRITE_ONCE().  If not, then good riddance.
>>
> My understanding is that we have to avoid transferring ownership of
> descriptor to device (by setting DescOwn bit) before opts2 field
> has been written. Using WRITE_ONCE() should be sufficient to prevent
> the compiler from merging or reordering the writes.
> At least that's how I read the process_level() example in
> https://www.kernel.org/doc/Documentation/memory-barriers.txt
> 
>> Just saying, i am not familiar with the hardware nor with the driver. :)
>>
>>
>> 		Petko
>>
>>
>>> -
>>> -	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
>>> +	/* Ensure ordering of writes */
>>> +	WRITE_ONCE(desc->opts2, 0);
>>> +	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));


No, this is not correct.

WRITE_ONCE(X, ...)
WRITE_ONCE(Y, ...)

has no guarantee X is written before Y

Sure, the compiler is making sure to perform one write for X, one for Y,
but you want stronger semantic than that. You want to keep dma_wmb()

However, this part of your patch seems fine :

-	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
+       WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));



>>>  }
>>>  
>>>  static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>>> @@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
>>>  		return NULL;
>>>  	}
>>>  
>>> -	desc->addr = cpu_to_le64(mapping);
>>> +	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
>>>  	rtl8169_mark_to_asic(desc);
>>>  
>>>  	return data;
>>> -- 
>>> 2.26.1
>>>
>>>
> 
