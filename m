Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6064220E916
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 01:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgF2XHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 19:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbgF2XHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 19:07:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E02C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 16:07:01 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so7678752plo.7
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 16:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c5+7n7Tl91EMgeAeFXBB2YJKWmCgRJlGZJPJh/GR5aE=;
        b=ZzwvErTpElN8evrf6bXdRHdTtK3SbNRHgFElMkDSQRGQPX+5fdlAstwbQr89DBGhYK
         k6Rv5CD0/25+eeJBkEoi+tEkNf/b7SxAalDytu+AHElMJ3y/+9kmMOMMPCTQu9Oax65D
         LxiMm7xcQdA0XhibL6rW2anfDs7ciEJNnPZdy73ZXzy3+2dTDVeav/Z+eEu4CnJKB/zP
         orW+VtocCeaKLAKUh/fIO8LK/kGUKUmoOL2zcJxNuGvONjx3Tg6nWDaMrkfRPzJ05Bjw
         LLuB/KNeUPbFq27HQRfujWQGrS2g2Q0LOCzoXsgQ05q7YFckDiJo5eYVRWbbHJpZLuWp
         b6RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c5+7n7Tl91EMgeAeFXBB2YJKWmCgRJlGZJPJh/GR5aE=;
        b=ZMvfkc58Yu4PU+Bk8QJwsn9g00xKi2YrnuG8N0tOkkh0Pzp1NjazQj0yl7e5cXWpgQ
         dSbVVHgYV7u3pqrsuCkVgPr7AcMegyJ/OuMbkKokPxXsGrPiPCbBw1D0YRg1i5E3kujL
         ADX2TFpY5tKwOxxDIEnPx7rGT/eNvEDdxoR3sbfOrFjKn+fJl7h/Yse76yEgz+PzFKyz
         tQAt0lBesKmwYhbR4Vt5iiN+XKcxI2odwlJxEt9WYf2ZkzLU+gCJ2EWVYHjV9oV4i+fi
         e4vv0igSZAhGLIeps9NEHT/a05wTDP2tW4fh9ASD5fNdvkapBd1XJA6lvzVz5pkrbCId
         Yuuw==
X-Gm-Message-State: AOAM532AGhEXd2xvt6ISVw4PP4aKgbNAadUj4dNe4XtiJK4O2Qsa5TLs
        TK+s5k2Tc5MFyBVc+GecSvfBb0PW
X-Google-Smtp-Source: ABdhPJxWDNSm9znZTXbKMGWk3K4ghZ8aowKPBtKjOgrVl2sVAMt5wh/XqwKnPegMXI/8GD8yS7VyvA==
X-Received: by 2002:a17:902:fe04:: with SMTP id g4mr5147096plj.66.1593472021059;
        Mon, 29 Jun 2020 16:07:01 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id np5sm471488pjb.43.2020.06.29.16.06.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2020 16:07:00 -0700 (PDT)
Subject: Re: [PATCH net-next] icmp: support rfc 4884
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <20200629165731.1553050-1-willemdebruijn.kernel@gmail.com>
 <cb763bc5-b361-891a-94e9-be2385ddcbe0@gmail.com>
 <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f713198c-5ff7-677e-a739-c0bec4a93bd6@gmail.com>
Date:   Mon, 29 Jun 2020 16:06:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSfgz54uQbzrMr1Q0cAg2Vs1TFjyOb_+jjKUPoKAb=R-fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/29/20 2:30 PM, Willem de Bruijn wrote:
> On Mon, Jun 29, 2020 at 5:15 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 6/29/20 9:57 AM, Willem de Bruijn wrote:
>>> From: Willem de Bruijn <willemb@google.com>
>>>
>>> ICMP messages may include an extension structure after the original
>>> datagram. RFC 4884 standardized this behavior.
>>>
>>> It introduces an explicit original datagram length field in the ICMP
>>> header to delineate the original datagram from the extension struct.
>>>
>>> Return this field when reading an ICMP error from the error queue.
>>
>> RFC mentions a 'length' field of 8 bits, your patch chose to export the whole
>> second word of icmp header.
>>
>> Why is this field mapped to a prior one (icmp_hdr(skb)->un.gateway) ?
>>
>> Should we add an element in the union to make this a little bit more explicit/readable ?
>>
>> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
>> index 5589eeb791ca580bb182e1dc38c05eab1c75adb9..427ed5a6765316a4c1e2fa06f3b6618447c01564 100644
>> --- a/include/uapi/linux/icmp.h
>> +++ b/include/uapi/linux/icmp.h
>> @@ -76,6 +76,7 @@ struct icmphdr {
>>                 __be16  sequence;
>>         } echo;
>>         __be32  gateway;
>> +       __be32  second_word; /* RFC 4884 4.[123] : <unused:8>,<length:8>,<mtu:16> */
>>         struct {
>>                 __be16  __unused;
>>                 __be16  mtu;
> 
> Okay. How about a variant of the existing struct frag?
> 
> @@ -80,6 +80,11 @@ struct icmphdr {
>                 __be16  __unused;
>                 __be16  mtu;
>         } frag;
> +       struct {
> +               __u8    __unused;
> +               __u8    length;
> +               __be16  mtu;
> +       } rfc_4884;
>         __u8    reserved[4];
>    } un;
> 

Sure, but my point was later in the code :

>>> +     if (inet_sk(sk)->recverr_rfc4884)
>>> +             info = ntohl(icmp_hdr(skb)->un.gateway);
>>
>> ntohl(icmp_hdr(skb)->un.second_word);

If you leave there "info = ntohl(icmp_hdr(skb)->un.gateway)" it is a bit hard for someone
reading linux kernel code to understand why we do this.


