Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC316307FB2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhA1U2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhA1U2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:28:38 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23BCC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:27:57 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id s24so5829163wmj.0
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ri/l5rju/y5bC/bw/lojZJZUZ2WQw26j3oTYHYm8yg4=;
        b=vRhw/QVNmavL73+/eiixBuZAalq3vdsy4YsBukPKj40bPdoOBsNgRN4umr7pRA9TXx
         bVuGewPQNMYR+VDjfNV1gYR8U0P/85rgmsUzlZycWm4v+rOLCVsdcIj3EBMwRSAD4g9V
         OyxeqBz75GKKB9OSsoQqDdjJOk37AVc7mWr2MfILlJVD1SQoUc9Sn07GbcfKZQppYiDC
         qFSvqU7VcY+6OryfoVDzhxz1Q7xvkpYpxcd7UyHQQe07kEAVoxdPPCaSZdry+K7D8MkP
         ysepfn3dg12WfTAM48pB/vC4ZGwxMbk3NRT+6XiKTmEyOOpTbHZtGAU70GU8hvXjNVXQ
         wnWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ri/l5rju/y5bC/bw/lojZJZUZ2WQw26j3oTYHYm8yg4=;
        b=Q6zWA5ccWSe+swtxa0g2lDc9Q24gMQVJrwjk3GBUb7+6JItEd92IyI67cEMea+nw/6
         ufItVHSPxmz3D6Sol/1opzhjW28Vz4SN6zexH2gh8AgWhB9AZG2FxZwbMF5HDaYt6GG0
         ynUHc6CgrmPI+4fgWwqyT9iH0Sx6IL4P4nfSG0AlDOo/XKy2f9zkHD8/CUwmnnwayZHp
         wdosF6PJaCic7DQpWDX8xcPqQus/jH/HD4zPAB+NVmpDF0vjgHanv61NhgU+cc2pU0JB
         XUAZNhmkb2JXGg0QUHZTRYXdK4avXvfakXm3CAusDsBveRz3SYGE3iQNpN08Hwwz/GB1
         qLPA==
X-Gm-Message-State: AOAM532w6BGOqh7+wUlCIffNDXDQ9cZ19xSbTpzHQO0VEFjm0T8hl2Bd
        EXuf+wpNLIJtR3MncDn/UIEuxaCg6WU=
X-Google-Smtp-Source: ABdhPJy5OZf1HJrsGycySZ/5xzSwc+6uy7hqLWKsuw6rcTD4ALl/7BXFqG6Qxwblj0UpbV60wpsAng==
X-Received: by 2002:a7b:c407:: with SMTP id k7mr851944wmi.159.1611865676406;
        Thu, 28 Jan 2021 12:27:56 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e93a:3209:70cb:a1d3? (p200300ea8f1fad00e93a320970cba1d3.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e93a:3209:70cb:a1d3])
        by smtp.googlemail.com with ESMTPSA id z8sm6968648wmi.44.2021.01.28.12.27.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 12:27:55 -0800 (PST)
Subject: Re: [PATCH v3 net] r8169: work around RTL8125 UDP hw bug
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c8dcb440-a2f5-0ff5-c4a7-854dc655151b@gmail.com>
 <CAF=yD-+n6RGCTnWXf4Tjq8pvKTdWmr8xdHHbYX5JPSmTHOi1ZQ@mail.gmail.com>
 <705c618b-1e24-97f8-e223-ee933a31de41@gmail.com>
Message-ID: <d33b9695-e187-38a0-6fe5-34e0755afcf9@gmail.com>
Date:   Thu, 28 Jan 2021 21:27:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <705c618b-1e24-97f8-e223-ee933a31de41@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.01.2021 21:17, Heiner Kallweit wrote:
> On 28.01.2021 19:36, Willem de Bruijn wrote:
>> On Thu, Jan 28, 2021 at 2:44 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>
>>> It was reported that on RTL8125 network breaks under heavy UDP load,
>>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
>>> and provided me with a test version of the r8125 driver including a
>>> workaround. Tests confirmed that the workaround fixes the issue.
>>> I modified the original version of the workaround to meet mainline
>>> code style.
>>>
>>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>>>
>>> v2:
>>> - rebased to net
>>> v3:
>>> - make rtl_skb_is_udp() more robust and use skb_header_pointer()
>>>   to access the ip(v6) header
>>>
>>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
>>> Tested-by: xplo <xplo.bn@gmail.com>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 70 +++++++++++++++++++++--
>>>  1 file changed, 64 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index a569abe7f..457fa1404 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -28,6 +28,7 @@
>>>  #include <linux/bitfield.h>
>>>  #include <linux/prefetch.h>
>>>  #include <linux/ipv6.h>
>>> +#include <linux/ptp_classify.h>
>>
>> this is only for UDP_HLEN? perhaps use sizeof(struct udphdr) instead
>> to remove the dependency.
>>
> 
> It's also for PTP_EV_PORT. But yes, we can define this locally to
> remove the dependency.
> 
>>>  #include <net/ip6_checksum.h>
>>>
>>>  #include "r8169.h"
>>> @@ -4046,17 +4047,70 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
>>>         return -EIO;
>>>  }
>>>
>>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
>>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
>>>  {
>>> +       int no = skb_network_offset(skb);
>>> +       struct ipv6hdr *i6h, _i6h;
>>> +       struct iphdr *ih, _ih;
>>> +
>>> +       switch (vlan_get_protocol(skb)) {
>>> +       case htons(ETH_P_IP):
>>> +               ih = skb_header_pointer(skb, no, sizeof(_ih), &_ih);
>>> +               return ih && ih->protocol == IPPROTO_UDP;
>>> +       case htons(ETH_P_IPV6):
>>> +               i6h = skb_header_pointer(skb, no, sizeof(_i6h), &_i6h);
>>> +               return i6h && i6h->nexthdr == IPPROTO_UDP;
>>> +       default:
>>> +               return false;
>>> +       }
>>> +}
>>> +
>>> +#define RTL_MIN_PATCH_LEN      47
>>> +#define PTP_GEN_PORT           320
>>> +
>>> +/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
>>> +static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
>>> +                                           struct sk_buff *skb)
>>> +{
>>> +       unsigned int padto = 0, len = skb->len;
>>> +
>>> +       if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
>>> +           rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
>>> +               unsigned int trans_data_len = skb_tail_pointer(skb) -
>>> +                                             skb_transport_header(skb);
>>> +
>>> +               if (trans_data_len > 3 && trans_data_len < RTL_MIN_PATCH_LEN) {
>>
>>    trans_data_len > 3
>>
>> here probably means
>>
>>    trans_data_len >= offsetof(struct udphdr, len)
>>
> 
> offsetof(struct udphdr, len) = 5
> Presumably the check ensures that udphdr->dest is accessible. I think we should
> use skb_header_pointer() here too.
> 
Uups, sorry, you' right here of course. My bad.


>> to safely access dest. Then that is a bit more self documenting
>>
>>> +                       u16 dest = ntohs(udp_hdr(skb)->dest);
>>> +
>>> +                       if (dest == PTP_EV_PORT || dest == PTP_GEN_PORT)
>>> +                               padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
>>> +               }
>>> +
>>> +               if (trans_data_len < UDP_HLEN)
>>
>> nit: else if ?
>>
> I don't think so. If e.g. trans_data_len == 5 and dest port isn't a PTP port,
> then the trans_data_len < UDP_HLEN branch wouldn't be execeuted.
> 
>>> +                       padto = max(padto, len + UDP_HLEN - trans_data_len);
>>> +       }
>>> +
>>> +       return padto;
>>> +}
>>> +
>>> +static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
>>> +                                          struct sk_buff *skb)
>>> +{
>>> +       unsigned int padto;
>>> +
>>> +       padto = rtl8125_quirk_udp_padto(tp, skb);
>>> +
>>>         switch (tp->mac_version) {
>>>         case RTL_GIGA_MAC_VER_34:
>>>         case RTL_GIGA_MAC_VER_60:
>>>         case RTL_GIGA_MAC_VER_61:
>>>         case RTL_GIGA_MAC_VER_63:
>>> -               return true;
>>> +               padto = max_t(unsigned int, padto, ETH_ZLEN);
>>>         default:
>>> -               return false;
>>> +               break;
>>>         }
>>> +
>>> +       return padto;
>>>  }
>>>
>>>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>>> @@ -4128,9 +4182,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>>
>>>                 opts[1] |= transport_offset << TCPHO_SHIFT;
>>>         } else {
>>> -               if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
>>> -                       /* eth_skb_pad would free the skb on error */
>>> -                       return !__skb_put_padto(skb, ETH_ZLEN, false);
>>> +               unsigned int padto = rtl_quirk_packet_padto(tp, skb);
>>> +
>>> +               /* skb_padto would free the skb on error */
>>> +               return !__skb_put_padto(skb, padto, false);
>>
>> should this path still pad to ETH_ZLEN as a minimum when the other
>> cases do not hit?
>>
> For most chip versions that's not needed because hw does the padding
> to ETH_ZLEN. Few chip versions have a hw bug and padding needs to be
> done in sw, that's handled in rtl_quirk_packet_padto().
> 
>>>         }
>>>
>>>         return true;
>>> @@ -4307,6 +4362,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>>                 if (skb->len < ETH_ZLEN)
>>>                         features &= ~NETIF_F_CSUM_MASK;
>>>
>>> +               if (rtl_quirk_packet_padto(tp, skb))
>>> +                       features &= ~NETIF_F_CSUM_MASK;
>>> +
>>>                 if (transport_offset > TCPHO_MAX &&
>>>                     rtl_chip_supports_csum_v2(tp))
>>>                         features &= ~NETIF_F_CSUM_MASK;
>>> --
>>> 2.30.0
>>>
> 

