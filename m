Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B061848B8E4
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiAKUwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbiAKUwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 15:52:04 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321DEC028BEF;
        Tue, 11 Jan 2022 12:51:43 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id o3so436905wrh.10;
        Tue, 11 Jan 2022 12:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XsmDxnCmqgTxDyNS30YCzdo9ghvlXMe30S1Vu2XW6pA=;
        b=XmLwRH8rQDlvIfMWQoNeqlHsHbJr3QflEMhvJzmk49sfMHRl7UM9dVu+NbrQS+NG+o
         YuMiG/nFJ2sl/N4IwwprPSpZ5dY/NkFAyWhEKVVDfe8cg8y/ENddcsyusXIU8jHUTCOw
         iqNSeGvW9sPeU69+8PH1NpLftafibuh74nHyuTOvHnnnQD9ve21dYznDCXZAcgqKIGHx
         /hq501ZyX/u1kkWqUBQSkjTEa/Om45Mxaz/t4jaUzmRg6iyX0QUJ5rZgbPkRe+z6elsQ
         iNNwUSRfl/sdApnW+hnIbYn/cMKKAi1ghOAbxlc73XTHecDhGnbTEr8nbjKuYwc3UtAx
         w7BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XsmDxnCmqgTxDyNS30YCzdo9ghvlXMe30S1Vu2XW6pA=;
        b=ZI/Fob+NjqCRg+9pPcgRjstym2CRRKmqDbNqYgRsnKlNq5ULo3VnmpmJmbrng9S0sr
         66t4wh7peoRCPIXhGIse2cvxB68Ftv59HZ3qZDyqIotfB77b1Bwix6p6+JLnNrIUOtMq
         zWz/HsI0ElH7duqt+T94gBZve1r9n3v6bOPiIVqn07Qp/FmsI7iAeECLOi93ABb3QYkK
         hvdYO3Nn60woFvZadINxY2oAhi4sCiCYuk1w3JFD/Qxj0Kulm84QIfu2WWQKdwjyPAmB
         EYit58UmQ+Z/SAym/HyqHp4aB8OsADQl6hKg0vFTrBl5bFqu+t/SNVAgkOESc2/lvH5k
         REww==
X-Gm-Message-State: AOAM532ac7BssfzMwLsDDJ86TKc78bG8T0SpfYyLY9pwf+yTakS3Z5cM
        NyKXSeHXwwGWkseysOqwJis=
X-Google-Smtp-Source: ABdhPJyc1m4l/BAJ5VYwYFruoGf1pbhMkcAMYjttL7V832KUi/rbuA0MyhIG35kSGQS4gVl5uRXbGA==
X-Received: by 2002:a5d:64c3:: with SMTP id f3mr5224559wri.155.1641934301765;
        Tue, 11 Jan 2022 12:51:41 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id j11sm3921394wmq.23.2022.01.11.12.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 12:51:41 -0800 (PST)
Message-ID: <d9714712-075f-17af-b4f0-67f82178abae@gmail.com>
Date:   Tue, 11 Jan 2022 20:48:12 +0000
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
 <25f5ba09-a54c-c386-e142-7b7454f1d8d4@gmail.com>
 <f2e3693ec8d1498aa376f72ebd49e058@AcuMS.aculab.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f2e3693ec8d1498aa376f72ebd49e058@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 17:25, David Laight wrote:
> From: Pavel Begunkov
>> Sent: 11 January 2022 16:59
>>
>> On 1/11/22 09:24, David Laight wrote:
>>> From: Pavel Begunkov
>>>> Sent: 11 January 2022 01:22
>>>>
>>>> Inline a HW csum'ed part of skb_csum_hwoffload_help().
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    include/linux/netdevice.h | 16 ++++++++++++++--
>>>>    net/core/dev.c            | 13 +++----------
>>>>    2 files changed, 17 insertions(+), 12 deletions(-)
>>>>
>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>> index 3213c7227b59..fbe6c764ce57 100644
>>>> --- a/include/linux/netdevice.h
>>>> +++ b/include/linux/netdevice.h
>>>> @@ -4596,8 +4596,20 @@ void netdev_rss_key_fill(void *buffer, size_t len);
>>>>
>>>>    int skb_checksum_help(struct sk_buff *skb);
>>>>    int skb_crc32c_csum_help(struct sk_buff *skb);
>>>> -int skb_csum_hwoffload_help(struct sk_buff *skb,
>>>> -			    const netdev_features_t features);
>>>> +int __skb_csum_hwoffload_help(struct sk_buff *skb,
>>>> +			      const netdev_features_t features);
>>>> +
>>>> +static inline int skb_csum_hwoffload_help(struct sk_buff *skb,
>>>> +					  const netdev_features_t features)
>>>> +{
>>>> +	if (unlikely(skb_csum_is_sctp(skb)))
>>>> +		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
>>>
>>> If that !! doing anything? - doesn't look like it.
>>
>> It doesn't, but left the original style
> 
> It just makes you think it is needed...
> 
>>>> +			skb_crc32c_csum_help(skb);
>>>> +
>>>> +	if (features & NETIF_F_HW_CSUM)
>>>> +		return 0;
>>>> +	return __skb_csum_hwoffload_help(skb, features);
>>>> +}
>>>
>>> Maybe you should remove some bloat by moving the sctp code
>>> into the called function.
>>> This probably needs something like?
>>>
>>> {
>>> 	if (features & NETIF_F_HW_CSUM && !skb_csum_is_sctp(skb))
>>> 		return 0;
>>> 	return __skb_csum_hw_offload(skb, features);
>>> }
>>
>> I don't like inlining that sctp chunk myself. It seems your way would
>> need another skb_csum_is_sctp() in __skb_csum_hw_offload(), if so I
>> don't think it's worth it. Would've been great to put the
>> NETIF_F_HW_CSUM check first and hide sctp, but don't think it's
>> correct. Would be great to hear some ideas.
> 
> Given the definition:
> 
> static inline bool skb_csum_is_sctp(struct sk_buff *skb)
> {
> 	return skb->csum_not_inet;
> }
> 
> I wouldn't worry about doing it twice.
> 
> Also skb_crc32_csum_help() is only called one.
> Make it static (so inlined) and pass 'features' into it.
> 
> In reality sctp is such a slow crappy protocol that a few extra
> function calls will make diddly-squit difference.
> (And yes, we do actually use the sctp stack.)

I was more thinking about non-sctp path without NETIF_F_HW_CSUM


-- 
Pavel Begunkov
