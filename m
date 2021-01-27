Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9D4306668
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbhA0Vha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:37:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhA0VfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:35:10 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91169C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:34:27 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 190so2675036wmz.0
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 13:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T2TF0K6knunjrO4GrnP+L3shOdCkCSsESqsWRwJ2188=;
        b=a9G9jB+xNziFEqfYR8hpEMYFHBfAktbF1FGK44K/C4QDiBtf1f8KzPsbO0BlB0Ha5r
         2pPTIy2l+rdw9LxVEp/bR9J5FJCZvY4vqSYK6qB3/qo/vJD98RCqI6ZYN4/9nkzrkk76
         Q4FdiGZLmE6+dx8gGqfQsqr435zPBxcmMVBdJ7Ue9ve+8nxZKjYhHWTsGXbNJaid8Ogj
         LwzUpLpxE/j+iaI83pq/TVehA5BbgHlzl9Uv6YIkpxPUKIuvukgVaFFiInTDDaejR4U7
         QmQQ0Sf8coLU+bgPDkynq3vJPSQj7hR0XRWr/LqXN+D+CiUpt6t7JzzJ5l+/oL0+59Pw
         PtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T2TF0K6knunjrO4GrnP+L3shOdCkCSsESqsWRwJ2188=;
        b=UEzFKTKP6qPHXRt44RiruU5WkAXC/i8Nge4ISSmMO8CLHLEsyRn4T95v6ccCm1/lAs
         xWxHmd4lMVZPM2RVEuXi8MRfMF/yGQyzs9iMWxbzxXSWXK95+5X5igfAT+8iAw63Xw2Z
         f1mnrZ5OFX4oEfFneY1vq1Gl/g9PYbtH5zDw/fmu6UlOrc7um81JLs/0sxjxDSzU8XQr
         DWJ6iSua5hieE3XNK94XPCxQUlKLH/rfpW3ik6j3PbxcYwYPHIcjZojl3ZrMOhTIgLnI
         Dl6/d/8NeBiViwlzX1tOxjDtTPC+MakxeZ7ldjDhwGQr5146FAkdf4GGgdt6reoM7ADw
         NiNw==
X-Gm-Message-State: AOAM532NTcCx/AMMeq/xP+ccU/2PXe/Ijbz9oUHazWk/RK+SgFAeDaPI
        QvM9I+LmjPavUgZhB9jaIDAHRPG9rtY=
X-Google-Smtp-Source: ABdhPJxVyHyBIMRyQ9SFx6+U51TqYpCpm8j5jsiQHqCCJx/iwsWzWKfSiL2WPtFUc8+MHYwTwqWvXw==
X-Received: by 2002:a05:600c:230e:: with SMTP id 14mr5783625wmo.161.1611783265940;
        Wed, 27 Jan 2021 13:34:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:acff:e553:5e:a443? (p200300ea8f1fad00acffe553005ea443.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:acff:e553:5e:a443])
        by smtp.googlemail.com with ESMTPSA id c18sm9898681wmk.0.2021.01.27.13.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 13:34:25 -0800 (PST)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
Message-ID: <32d17a7c-f0be-5691-8e3f-715f7aab4992@gmail.com>
Date:   Wed, 27 Jan 2021 22:34:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-J-XVLpntG=pGxuNUjs898+669v72Mh0PkJ9u34T6paQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.01.2021 21:35, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 3:32 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 27.01.2021 20:54, Willem de Bruijn wrote:
>>> On Wed, Jan 27, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> On 27.01.2021 19:07, Willem de Bruijn wrote:
>>>>> On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>>>
>>>>>> It was reported that on RTL8125 network breaks under heavy UDP load,
>>>>>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
>>>>>> and provided me with a test version of the r8125 driver including a
>>>>>> workaround. Tests confirmed that the workaround fixes the issue.
>>>>>> I modified the original version of the workaround to meet mainline
>>>>>> code style.
>>>>>>
>>>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>>>>>>
>>>>>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
>>>>>> Tested-by: xplo <xplo.bn@gmail.com>
>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>> ---
>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
>>>>>>  1 file changed, 58 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>> index fb67d8f79..90052033b 100644
>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>> @@ -28,6 +28,7 @@
>>>>>>  #include <linux/bitfield.h>
>>>>>>  #include <linux/prefetch.h>
>>>>>>  #include <linux/ipv6.h>
>>>>>> +#include <linux/ptp_classify.h>
>>>>>>  #include <asm/unaligned.h>
>>>>>>  #include <net/ip6_checksum.h>
>>>>>>
>>>>>> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
>>>>>>         return -EIO;
>>>>>>  }
>>>>>>
>>>>>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
>>>>>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
>>>>>>  {
>>>>>> +       switch (vlan_get_protocol(skb)) {
>>>>>> +       case htons(ETH_P_IP):
>>>>>> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
>>>>>> +       case htons(ETH_P_IPV6):
>>>>>> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
>>>>
>>>> The workaround was provided by Realtek, I just modified it to match
>>>> mainline code style. For your reference I add the original version below.
>>>> I don't know where the magic numbers come from, Realtek releases
>>>> neither data sheets nor errata information.
>>>
>>> Okay. I don't know what is customary for this process.
>>>
>>> But I would address the possible out of bounds read by trusting ip
>>> header integrity in rtl_skb_is_udp.
>>>
>> I don't know tun/virtio et al good enough to judge which header elements
>> may be trustworthy and which may be not. What should be checked where?
> 
> It requires treating the transmit path similar to the receive path:
> assume malicious or otherwise faulty packets. So do not trust that a
> protocol of ETH_P_IPV6 implies a packet with 40B of space to hold a
> full ipv6 header. That is the extent of it, really.
> 
OK, so what can I do? Check for
skb_tail_pointer(skb) - skb_network_header(skb) >= sizeof(struct ipv6hdr) ?

On a side note: Why is IP6_HLEN defined in ptp_classify.h and not in any
IPv6 header file? Does no IPv6 code need such a constant?




