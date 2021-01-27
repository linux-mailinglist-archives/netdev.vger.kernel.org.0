Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4338630653A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhA0Ucz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbhA0Ucw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:32:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0627C061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:32:11 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id f16so2562693wmq.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nzi+khuzcwpkW66S52P8/6t674x/FLwJB+lS9ztzhb4=;
        b=RhRhvPfoLuAmM3lDBLqBQvuys3DKvPak4Zf81CEVCGURKNY7ELFJbYhoALXl8py1zh
         0wOBjM9WvYQjJLzR0mwEFIoOUFSrCjPxk3HAdUg5ag2CDdypojkA6Sr+p6eGoifeh1XU
         pK8Cq/dB3WbT6Ge3l19jiTU7s6L4bY+n3T5GC1BBAsxBi8xspUOTrqv6cBw2roXsc8MY
         EheMTAtzvo4Tv0CLjo5AtbWuY2iT6OWDP/33uDEszcKN9gTfYhHA3p7e2ZrnD1AfMKqj
         pPRLwoXAlnNxlNgJJSQTWqFYy9tY+h3sU+gKnkyuVUQZQbiPzAr+r2s5LT+MTmwWHw9k
         G+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nzi+khuzcwpkW66S52P8/6t674x/FLwJB+lS9ztzhb4=;
        b=qH3l2a0ADRGBbsjF2NKhLTEHnCK6bm/zHa+RMaSXU0vzGW9uDovg7HoF/F0dIMl8mc
         DixuuvmvJd+mw3nrf1vSNby0Gi+YvdS0DXgAAN9N881X5oOYjXqFOJYhJqlF1Tekm2F7
         CBRVVNAW71Oiu32D8mjHzJPdCfZ5ZNNLbi5Nr55TLDcB5AhAgAT0KD4/dIwSJpewFDU/
         LmLg9w0AvrlVE0pNg4A1+ZJCoF4suT03WymxvXvg8Px6l/XQ2f47IdGqlAvvL9bqz4cP
         K4+m1ze4CBmpEqklBeeXvlgH3OPsmuRQ0fVOklJ1VGLCRWvb9GtXj3PjsQik4j7/MT2P
         JRLA==
X-Gm-Message-State: AOAM532KlsI0JR2UuoWJmOoxkDKHH5ivAch1e648LkYdutlaWlqcnLRb
        kxmxzaJmotmad7nn9jvOMus=
X-Google-Smtp-Source: ABdhPJx7xbDP5ZPsrmfYKutYIZ6aEi9HkG4QUV91WmmGqXPr01FbCX661jACmNg0iAYIoVZ4+zClDw==
X-Received: by 2002:a1c:a7c5:: with SMTP id q188mr5571370wme.108.1611779530528;
        Wed, 27 Jan 2021 12:32:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:acff:e553:5e:a443? (p200300ea8f1fad00acffe553005ea443.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:acff:e553:5e:a443])
        by smtp.googlemail.com with ESMTPSA id i8sm4409744wry.90.2021.01.27.12.32.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 12:32:09 -0800 (PST)
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xplo.bn@gmail.com
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
 <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com>
 <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com>
 <CAF=yD-LBAVbVuaJZgpgyU16Wd1ppKquRjvfX=HbDTJABBzeo9A@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <5229d00c-1b12-38fb-3f2b-e21f005281ec@gmail.com>
Date:   Wed, 27 Jan 2021 21:32:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-LBAVbVuaJZgpgyU16Wd1ppKquRjvfX=HbDTJABBzeo9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.01.2021 20:54, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 27.01.2021 19:07, Willem de Bruijn wrote:
>>> On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>>
>>>> It was reported that on RTL8125 network breaks under heavy UDP load,
>>>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
>>>> and provided me with a test version of the r8125 driver including a
>>>> workaround. Tests confirmed that the workaround fixes the issue.
>>>> I modified the original version of the workaround to meet mainline
>>>> code style.
>>>>
>>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>>>>
>>>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
>>>> Tested-by: xplo <xplo.bn@gmail.com>
>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>> ---
>>>>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
>>>>  1 file changed, 58 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index fb67d8f79..90052033b 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -28,6 +28,7 @@
>>>>  #include <linux/bitfield.h>
>>>>  #include <linux/prefetch.h>
>>>>  #include <linux/ipv6.h>
>>>> +#include <linux/ptp_classify.h>
>>>>  #include <asm/unaligned.h>
>>>>  #include <net/ip6_checksum.h>
>>>>
>>>> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
>>>>         return -EIO;
>>>>  }
>>>>
>>>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
>>>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
>>>>  {
>>>> +       switch (vlan_get_protocol(skb)) {
>>>> +       case htons(ETH_P_IP):
>>>> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
>>>> +       case htons(ETH_P_IPV6):
>>>> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
>>>
>>> This trusts that an skb with given skb->protocol is well behaved. With
>>> packet sockets/tun/virtio, that may be false.
>>>
>>>> +       default:
>>>> +               return false;
>>>> +       }
>>>> +}
>>>> +
>>>> +#define RTL_MIN_PATCH_LEN      47
>>>> +#define PTP_GEN_PORT           320
>>>
>>> Why the two PTP ports? The report is not PTP specific. Also, what does
>>> patch mean in this context?
>>>
>>>> +
>>>> +/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
>>>> +static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
>>>> +                                           struct sk_buff *skb)
>>>> +{
>>>> +       unsigned int padto = 0, len = skb->len;
>>>> +
>>>> +       if (rtl_is_8125(tp) && len < 175 && rtl_skb_is_udp(skb) &&
>>>> +           skb_transport_header_was_set(skb)) {
>>>
>>> What is 175 here?
>>>
>>>> +               unsigned int trans_data_len = skb_tail_pointer(skb) -
>>>> +                                             skb_transport_header(skb);
>>>> +
>>>> +               if (trans_data_len > 3 && trans_data_len < RTL_MIN_PATCH_LEN) {
>>>
>>> And 3 here, instead of sizeof(struct udphdr)
>>>
>>>> +                       u16 dest = ntohs(udp_hdr(skb)->dest);
>>>> +
>>>> +                       if (dest == PTP_EV_PORT || dest == PTP_GEN_PORT)
>>>> +                               padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
>>>> +               }
>>>> +
>>>> +               if (trans_data_len < UDP_HLEN)
>>>> +                       padto = max(padto, len + UDP_HLEN - trans_data_len);
>>>> +       }
>>>> +
>>>> +       return padto;
>>>> +}
>>>> +
>>>> +static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
>>>> +                                          struct sk_buff *skb)
>>>> +{
>>>> +       unsigned int padto;
>>>> +
>>>> +       padto = rtl8125_quirk_udp_padto(tp, skb);
>>>> +
>>>>         switch (tp->mac_version) {
>>>>         case RTL_GIGA_MAC_VER_34:
>>>>         case RTL_GIGA_MAC_VER_60:
>>>>         case RTL_GIGA_MAC_VER_61:
>>>>         case RTL_GIGA_MAC_VER_63:
>>>> -               return true;
>>>> +               padto = max_t(unsigned int, padto, ETH_ZLEN);
>>>>         default:
>>>> -               return false;
>>>> +               break;
>>>>         }
>>>> +
>>>> +       return padto;
>>>>  }
>>>>
>>>>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>>>> @@ -4089,9 +4137,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>>>
>>>>                 opts[1] |= transport_offset << TCPHO_SHIFT;
>>>>         } else {
>>>> -               if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
>>>> -                       /* eth_skb_pad would free the skb on error */
>>>> -                       return !__skb_put_padto(skb, ETH_ZLEN, false);
>>>> +               unsigned int padto = rtl_quirk_packet_padto(tp, skb);
>>>> +
>>>> +               /* skb_padto would free the skb on error */
>>>> +               return !__skb_put_padto(skb, padto, false);
>>>>         }
>>>>
>>>>         return true;
>>>> @@ -4268,6 +4317,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>>>                 if (skb->len < ETH_ZLEN)
>>>>                         features &= ~NETIF_F_CSUM_MASK;
>>>>
>>>> +               if (rtl_quirk_packet_padto(tp, skb))
>>>> +                       features &= ~NETIF_F_CSUM_MASK;
>>>> +
>>>>                 if (transport_offset > TCPHO_MAX &&
>>>>                     rtl_chip_supports_csum_v2(tp))
>>>>                         features &= ~NETIF_F_CSUM_MASK;
>>>> --
>>>> 2.30.0
>>>>
>>
>> The workaround was provided by Realtek, I just modified it to match
>> mainline code style. For your reference I add the original version below.
>> I don't know where the magic numbers come from, Realtek releases
>> neither data sheets nor errata information.
> 
> Okay. I don't know what is customary for this process.
> 
> But I would address the possible out of bounds read by trusting ip
> header integrity in rtl_skb_is_udp.
> 
I don't know tun/virtio et al good enough to judge which header elements
may be trustworthy and which may be not. What should be checked where?
