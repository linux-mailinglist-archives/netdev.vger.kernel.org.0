Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D37248B2C7
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242695AbiAKRCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240781AbiAKRCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:02:16 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE928C06173F;
        Tue, 11 Jan 2022 09:02:15 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id h10so24036945wrb.1;
        Tue, 11 Jan 2022 09:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=mXVQ1PbsGt6E7WnElgMdh7YxskWHKJ7cXGHBOHZ7Esg=;
        b=NMl70OoyrtUbqH4c2Bqm742xUeygACYhczAcv/5uL8M0eFRgPdU7bRGW7Y/fUfah/v
         S55faUvcSAN72EhNj50c0CrL/T4TYAdqYELi4oJKrWPEMVl6/1MjHa287HWFSowFnj5F
         eVJ7wNv+d0G02h2zc+TAJQ4zMLkcK13WCGgHLV+xQh1GnVaMmLLPpLeyKVo+FiIn7upX
         qcCmhnj98Jh6nfgQF4YmpXkAG+FW/MACbcWrVimHk+wmMWVNb1uwAKu/jlqX0jQJhkmq
         UAehWKMyONaAmCLVDo3QqhTrAu1Bxcx1oYdIiCdwMIWKSeOPbByd1iuzy/8xMHqm1vbU
         aoGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mXVQ1PbsGt6E7WnElgMdh7YxskWHKJ7cXGHBOHZ7Esg=;
        b=rgAyzgCCf3cPeGPJj3f5DlNefLwUPhbqxVje5xCXxzwVS5U9v+Gn6yRhADaLDEYPbl
         DKyBTpBeiXUox9D0AfH4oH4w1qRtTDV9I1ZctyBhmNoCBhrcjOHZsjyAkP38x187k1Qe
         tXwje+ed38ueVu9Tj64WtsVRc8rds7pHMB1OJVZT5sb25ZqixOLUE1v777zwi2pn8hIQ
         hV73482DpH/mb2m9TLzAspdLei8MN6GyfYvcxRWnvguCq3mQWmLhBEV525xVyz+hmkpK
         yTTcneGPvfoQOmzYkPAzH2agcf7COS5IbeI2BqA0z5EyDmhL9Guf0eMO4DRemNCtHhD0
         1Rbg==
X-Gm-Message-State: AOAM5313ETH6NLCNExvOBbkIVs2Yg0hQLhQpYW5X/aLaCl6O5uil/zQm
        syfJdce11bCHOG+uZ17r2xs=
X-Google-Smtp-Source: ABdhPJxhYLtku6q2EWXXe/rY01jj9HMQ9McdpVRef2XLXOOq/you036jaEvGHciimDoZa7etQwaeJg==
X-Received: by 2002:adf:ab59:: with SMTP id r25mr4783092wrc.321.1641920534311;
        Tue, 11 Jan 2022 09:02:14 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id i8sm12587171wry.108.2022.01.11.09.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 09:02:13 -0800 (PST)
Message-ID: <25f5ba09-a54c-c386-e142-7b7454f1d8d4@gmail.com>
Date:   Tue, 11 Jan 2022 16:59:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 13/14] net: inline part of skb_csum_hwoffload_help
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1641863490.git.asml.silence@gmail.com>
 <0bc041d2d38a08064a642c05ca8cceb0ca165f88.1641863490.git.asml.silence@gmail.com>
 <918a937f6cef44e282353001a7fbba7a@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <918a937f6cef44e282353001a7fbba7a@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 09:24, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 11 January 2022 01:22
>>
>> Inline a HW csum'ed part of skb_csum_hwoffload_help().
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/netdevice.h | 16 ++++++++++++++--
>>   net/core/dev.c            | 13 +++----------
>>   2 files changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> index 3213c7227b59..fbe6c764ce57 100644
>> --- a/include/linux/netdevice.h
>> +++ b/include/linux/netdevice.h
>> @@ -4596,8 +4596,20 @@ void netdev_rss_key_fill(void *buffer, size_t len);
>>
>>   int skb_checksum_help(struct sk_buff *skb);
>>   int skb_crc32c_csum_help(struct sk_buff *skb);
>> -int skb_csum_hwoffload_help(struct sk_buff *skb,
>> -			    const netdev_features_t features);
>> +int __skb_csum_hwoffload_help(struct sk_buff *skb,
>> +			      const netdev_features_t features);
>> +
>> +static inline int skb_csum_hwoffload_help(struct sk_buff *skb,
>> +					  const netdev_features_t features)
>> +{
>> +	if (unlikely(skb_csum_is_sctp(skb)))
>> +		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
> 
> If that !! doing anything? - doesn't look like it.

It doesn't, but left the original style


>> +			skb_crc32c_csum_help(skb);
>> +
>> +	if (features & NETIF_F_HW_CSUM)
>> +		return 0;
>> +	return __skb_csum_hwoffload_help(skb, features);
>> +}
> 
> Maybe you should remove some bloat by moving the sctp code
> into the called function.
> This probably needs something like?
> 
> {
> 	if (features & NETIF_F_HW_CSUM && !skb_csum_is_sctp(skb))
> 		return 0;
> 	return __skb_csum_hw_offload(skb, features);
> }

I don't like inlining that sctp chunk myself. It seems your way would
need another skb_csum_is_sctp() in __skb_csum_hw_offload(), if so I
don't think it's worth it. Would've been great to put the
NETIF_F_HW_CSUM check first and hide sctp, but don't think it's
correct. Would be great to hear some ideas.

-- 
Pavel Begunkov
