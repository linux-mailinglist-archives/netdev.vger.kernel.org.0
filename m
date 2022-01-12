Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C79C48C8AA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355302AbiALQoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiALQoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:44:23 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C583CC06173F;
        Wed, 12 Jan 2022 08:44:22 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id q8so5263859wra.12;
        Wed, 12 Jan 2022 08:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VOF4KtBnpM2ybbffoSUARMscyXTZoj5N2lzy0vNvQy4=;
        b=N6i4e7ZRXL/fXMy7DPHxy45GD0pjwaT0QJ4TNr1x36yruAeOQIA9AU78XEKEZ0kgaU
         hPnAvfBBmebKnLiEeD4L8wjngyb8mn7f2aDRuLUNsMt4kpFS6K68xl37NavVV6rkKia6
         AaCNQ2ug+XOkXLUgfDXxRoPuNKs+jnHblI+IN1oriAGQXXiibqVrjnKUD6vp9mnEMdEe
         SQJMqLNtbF9mpIJZmX67M/0/WVRtGYLbgCGLvMJ2KQgn3Feynzh3eWgLXGlwUipQh+mF
         Ppjb1WOR67t8y5WiKj+aWckvAEcl5nq6V30GgL60ImEkoGINmQoon9qv2TLAq64BWQ/H
         PWFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VOF4KtBnpM2ybbffoSUARMscyXTZoj5N2lzy0vNvQy4=;
        b=ajsG8Y2g8Kw2Cyez8DLaWZSTnJURku3hjDHrJyzSJ2J+0h03NRmHXCbVvFNxXYDIad
         zFhyvBthWDZUOOfonP3wgi/GcwNrbfzP0rXkyYedZJeaqWVgVAXmcI8qZrfxRuQr0ZD/
         ocMbiAaB+VeFlE8xz7CMMWNIgqVPUGMKJpcISsxR5/jR33o49gCo7qjmmE/0d15e8BxC
         15XBU7sZxIkLpCCXsv4bzSDk1U4lACJan61Iyw1bsW79gwcir/Wuxa0KvQSeUDpptxSw
         k3V/evTKvKqlKOx4Swv9Ni5uyqHuak3A/n1FjFxIDOmHYoeaQACR7j4l1icNH7f2D8v8
         VA1A==
X-Gm-Message-State: AOAM531Gey8eUp0TSG1GZ7my/OcjLIEEkQ2Z2ERuXtnuQlUSo12PO+c1
        jcA3vbKBJBhlTe15RQWk9xg=
X-Google-Smtp-Source: ABdhPJxZfSsF1dAlnUAaT8GITig0maLt/ooIUzj1FIRNvwQsFGt9n960qJM0jPTQcMoU7G/FSBwh7A==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr477788wrw.629.1642005861410;
        Wed, 12 Jan 2022 08:44:21 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id n1sm380216wri.46.2022.01.12.08.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 08:44:21 -0800 (PST)
Message-ID: <a913f4a5-866c-2779-94c2-87a1377fb4fd@gmail.com>
Date:   Wed, 12 Jan 2022 16:43:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
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
 <25f5ba09-a54c-c386-e142-7b7454f1d8d4@gmail.com>
 <f2e3693ec8d1498aa376f72ebd49e058@AcuMS.aculab.com>
 <d9714712-075f-17af-b4f0-67f82178abae@gmail.com>
 <941373b680b648e3be1175b23595be4a@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <941373b680b648e3be1175b23595be4a@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 02:41, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 11 January 2022 20:48
>> On 1/11/22 17:25, David Laight wrote:
>>> From: Pavel Begunkov
>>>> Sent: 11 January 2022 16:59
>>>>
>>>> On 1/11/22 09:24, David Laight wrote:
>>>>> From: Pavel Begunkov
>>>>>> Sent: 11 January 2022 01:22
>>>>>>
>>>>>> Inline a HW csum'ed part of skb_csum_hwoffload_help().
>>>>>>
>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>> ---
>>>>>>     include/linux/netdevice.h | 16 ++++++++++++++--
>>>>>>     net/core/dev.c            | 13 +++----------
>>>>>>     2 files changed, 17 insertions(+), 12 deletions(-)
>>>>>>
>>>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>>>> index 3213c7227b59..fbe6c764ce57 100644
>>>>>> --- a/include/linux/netdevice.h
>>>>>> +++ b/include/linux/netdevice.h
>>>>>> @@ -4596,8 +4596,20 @@ void netdev_rss_key_fill(void *buffer, size_t len);
>>>>>>
>>>>>>     int skb_checksum_help(struct sk_buff *skb);
>>>>>>     int skb_crc32c_csum_help(struct sk_buff *skb);
>>>>>> -int skb_csum_hwoffload_help(struct sk_buff *skb,
>>>>>> -			    const netdev_features_t features);
>>>>>> +int __skb_csum_hwoffload_help(struct sk_buff *skb,
>>>>>> +			      const netdev_features_t features);
>>>>>> +
>>>>>> +static inline int skb_csum_hwoffload_help(struct sk_buff *skb,
>>>>>> +					  const netdev_features_t features)
>>>>>> +{
>>>>>> +	if (unlikely(skb_csum_is_sctp(skb)))
>>>>>> +		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
>>>>>
>>>>> If that !! doing anything? - doesn't look like it.
>>>>
>>>> It doesn't, but left the original style
>>>
>>> It just makes you think it is needed...
>>>
>>>>>> +			skb_crc32c_csum_help(skb);
>>>>>> +
>>>>>> +	if (features & NETIF_F_HW_CSUM)
>>>>>> +		return 0;
>>>>>> +	return __skb_csum_hwoffload_help(skb, features);
>>>>>> +}
>>>>>
>>>>> Maybe you should remove some bloat by moving the sctp code
>>>>> into the called function.
>>>>> This probably needs something like?
>>>>>
>>>>> {
>>>>> 	if (features & NETIF_F_HW_CSUM && !skb_csum_is_sctp(skb))
>>>>> 		return 0;
>>>>> 	return __skb_csum_hw_offload(skb, features);
>>>>> }
>>>>
>>>> I don't like inlining that sctp chunk myself. It seems your way would
>>>> need another skb_csum_is_sctp() in __skb_csum_hw_offload(), if so I
>>>> don't think it's worth it. Would've been great to put the
>>>> NETIF_F_HW_CSUM check first and hide sctp, but don't think it's
>>>> correct. Would be great to hear some ideas.
>>>
>>> Given the definition:
>>>
>>> static inline bool skb_csum_is_sctp(struct sk_buff *skb)
>>> {
>>> 	return skb->csum_not_inet;
>>> }
>>>
>>> I wouldn't worry about doing it twice.
>>>
>>> Also skb_crc32_csum_help() is only called one.
>>> Make it static (so inlined) and pass 'features' into it.
>>>
>>> In reality sctp is such a slow crappy protocol that a few extra
>>> function calls will make diddly-squit difference.
>>> (And yes, we do actually use the sctp stack.)
>>
>> I was more thinking about non-sctp path without NETIF_F_HW_CSUM
> 
> In which case you need the body of __skb_csum_hw_offload()
> and end up doing the 'sctp' check once inside it.
> The 'sctp' check is only done twice for sctp.

Ah yes, might be better indeed

-- 
Pavel Begunkov
