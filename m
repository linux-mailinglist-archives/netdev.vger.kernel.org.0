Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C955307012
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 08:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhA1HrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 02:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhA1HpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 02:45:01 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C738AC061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 23:44:20 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id s7so1390650wru.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 23:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sOP/RIFXba5UUu1tJkhB8EDlkpF5U1+qHTy42nrUQPk=;
        b=fo6GAOn0nuIruZo95n5n+1Lme9fyh7JzzYI+GYFmMxv8x2najfjFL6dpLbE+46+3Q2
         f17nCrbiZbRjUvw3LDi1MkmS5p1F4zAzhm1JJ1is2MawBMP0t5s0fOEMDGiWCzw3velv
         Q5MgcauzxY/g4GpvbgLoKD08uSNLIkI+CIdJhrUWtYmJMI7sG5VQWA1y0rh4GTuMLfCF
         ZFXafbfqILBFgSikCEZ1s7A7d+oADaghzCFjn60dNAAYF742Yixpji9vmgp7xGDC25Ei
         JViHjYuPmirvWDfJ9f5quKyYlU9igYDod/Qi0RsMutvt7mN2CDvRzKM9HwZeERDaEzy7
         NivQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sOP/RIFXba5UUu1tJkhB8EDlkpF5U1+qHTy42nrUQPk=;
        b=ZHNP3CJHExD4WQgEqiN9yEo3u8wsXmAfPy/kCeL0xmDeJXygwd2mj90tqsKJlUB1r2
         01VTeXtT4cbiLdQJRgNXCJgMBjaBPzw4W/WDLnz5IreFKL4L00c+OFILem608k2babWt
         p4R71a2v19M3NOm8fcizXhqib6fkVWfgf5wyTBuxPVoak27iqDsUqdAiEpgyRn1CwkVb
         LnCrz9IqQLlFp7wnyVc92aOAiqPstRye+uwpynmS/sbaTyjnxQnsBZkF5YWgQqRX9XV2
         r34gMwAkKKABw2ZPeSEMhO6nG5/vUdxZiIR7IEMzQcCi5ulUKZXqXMN9kk4UIYiL5C2I
         eCPA==
X-Gm-Message-State: AOAM532tfT8Cxg5BCZ1F2KbDl+6NNByQhN9Q+9MQqWZp0q6eHtASodLq
        gYHELJ2bvEoJq7vtHBCk+9jQBDAWMgo=
X-Google-Smtp-Source: ABdhPJxpzFvys6y2krB88Pb+ca2EIrF+X4QGB4oRFkDUkx2JL8wkHitXqr2bH9+TG4wxhyLgbO5OFg==
X-Received: by 2002:a5d:6189:: with SMTP id j9mr14556584wru.256.1611819859241;
        Wed, 27 Jan 2021 23:44:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:cd65:6d53:f337:be79? (p200300ea8f1fad00cd656d53f337be79.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:cd65:6d53:f337:be79])
        by smtp.googlemail.com with ESMTPSA id y11sm5759129wrh.16.2021.01.27.23.44.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 23:44:18 -0800 (PST)
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
 <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com>
 <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com>
 <CAF=yD-LBAVbVuaJZgpgyU16Wd1ppKquRjvfX=HbDTJABBzeo9A@mail.gmail.com>
 <5229d00c-1b12-38fb-3f2b-e21f005281ec@gmail.com>
 <CAF=yD-J-XVLpntG=pGxuNUjs898+669v72Mh0PkJ9u34T6paQA@mail.gmail.com>
 <32d17a7c-f0be-5691-8e3f-715f7aab4992@gmail.com>
 <CAF=yD-KJbhF7ZtCcaAQQCpnXxKUPrzbO+8+7g=CEh-2n45s3Yw@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <39ccb3f1-6f9c-215c-6a6f-ea31c84083ea@gmail.com>
Date:   Thu, 28 Jan 2021 08:31:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-KJbhF7ZtCcaAQQCpnXxKUPrzbO+8+7g=CEh-2n45s3Yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.01.2021 23:48, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 4:34 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 27.01.2021 21:35, Willem de Bruijn wrote:
>>> On Wed, Jan 27, 2021 at 3:32 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> On 27.01.2021 20:54, Willem de Bruijn wrote:
>>>>> On Wed, Jan 27, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>>
>>>>>> On 27.01.2021 19:07, Willem de Bruijn wrote:
>>>>>>> On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>>>>
>>>>>>>> It was reported that on RTL8125 network breaks under heavy UDP load,
>>>>>>>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
>>>>>>>> and provided me with a test version of the r8125 driver including a
>>>>>>>> workaround. Tests confirmed that the workaround fixes the issue.
>>>>>>>> I modified the original version of the workaround to meet mainline
>>>>>>>> code style.
>>>>>>>>
>>>>>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>>>>>>>>
>>>>>>>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
>>>>>>>> Tested-by: xplo <xplo.bn@gmail.com>
>>>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>>>> ---
>>>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
>>>>>>>>  1 file changed, 58 insertions(+), 6 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>> index fb67d8f79..90052033b 100644
>>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>> @@ -28,6 +28,7 @@
>>>>>>>>  #include <linux/bitfield.h>
>>>>>>>>  #include <linux/prefetch.h>
>>>>>>>>  #include <linux/ipv6.h>
>>>>>>>> +#include <linux/ptp_classify.h>
>>>>>>>>  #include <asm/unaligned.h>
>>>>>>>>  #include <net/ip6_checksum.h>
>>>>>>>>
>>>>>>>> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
>>>>>>>>         return -EIO;
>>>>>>>>  }
>>>>>>>>
>>>>>>>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
>>>>>>>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
>>>>>>>>  {
>>>>>>>> +       switch (vlan_get_protocol(skb)) {
>>>>>>>> +       case htons(ETH_P_IP):
>>>>>>>> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
>>>>>>>> +       case htons(ETH_P_IPV6):
>>>>>>>> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
>>>>>>
>>>>>> The workaround was provided by Realtek, I just modified it to match
>>>>>> mainline code style. For your reference I add the original version below.
>>>>>> I don't know where the magic numbers come from, Realtek releases
>>>>>> neither data sheets nor errata information.
>>>>>
>>>>> Okay. I don't know what is customary for this process.
>>>>>
>>>>> But I would address the possible out of bounds read by trusting ip
>>>>> header integrity in rtl_skb_is_udp.
>>>>>
>>>> I don't know tun/virtio et al good enough to judge which header elements
>>>> may be trustworthy and which may be not. What should be checked where?
>>>
>>> It requires treating the transmit path similar to the receive path:
>>> assume malicious or otherwise faulty packets. So do not trust that a
>>> protocol of ETH_P_IPV6 implies a packet with 40B of space to hold a
>>> full ipv6 header. That is the extent of it, really.
>>>
>> OK, so what can I do? Check for
>> skb_tail_pointer(skb) - skb_network_header(skb) >= sizeof(struct ipv6hdr) ?
> 
> It is quite rare for device drivers to access protocol header fields
> (and a grep points to lots of receive side operations), so I don't
> have a good driver example.
> 
> But qdisc_pkt_len_init in net/core/dev.c shows a good approach for
> this robust access in the transmit path: using skb_header_pointer.
> 
>> On a side note: Why is IP6_HLEN defined in ptp_classify.h and not in any
>> IPv6 header file? Does no IPv6 code need such a constant?
> 
> It is customary to use sizeof(struct ipv6hdr)
> 
Thanks for the valuable feedback!
