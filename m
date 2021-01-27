Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA44306455
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344574AbhA0TmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344564AbhA0Tlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 14:41:36 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C640C06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:40:54 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id q7so3110315wre.13
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OuiVZcjzv/rz3J3JZMw0xfSfWChzbTuQtFFpRmZ9D/w=;
        b=iZ6an816k3p9tTFr2tWFj/wcexChEGOWlj6ytV3rVI7lneTHr0WyKg2iHWxGXrSnZU
         VReZUw+plbCdiD3jdwkuMx/ObniEiG8/8YMkYmg2dOdfrDRkqPtjyLXIEhXXH81jKgkr
         JyuH41NH/YbKC42rVq8NW8Wb5RUJDZ1AJ3Jhl9DjXOmyvWY2wUrPFD63yYX+cJbyZqss
         LaaR+7tQFzhwT1wyFHyAOqxERCh5j8Zi/w5Rg4srb5XQrHyFbYkIgSv8vgyaitWaI29T
         U6ATWCcqmP6atLbyiuJEP7LWMAZ5+WV80q5htljGJR423jlsmgjs/IiOA6+I54P/zKsd
         1bNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OuiVZcjzv/rz3J3JZMw0xfSfWChzbTuQtFFpRmZ9D/w=;
        b=SJd+iTdQm6d/uW/f473UIpHMREVcEalyrdWjdRtvnTRJOrGm7qmGl2OVWa794GJlUP
         LSy1kZ9eYewRbVJw/E8S+gkMV6s1YP5JYPN/oUDzVXX2v/SxlUf0qCugr7KGLE0eUpgR
         gcyTKn55DxH8+3kh9OFDTJKuM69lM2YqfgO+RCGnVyHhFKjOy50dEUfVnmnhfHTXEy2C
         oBGXWtYgGtk0tXdl4WNRTe/w4YHMEEHj93J3xe6pH9t17kVE3N37DTpylXZdNuoil2OD
         aCxLXCzvLG8QTVLz/FkraJfQ2h9AXW+0EVIcOLpm1sKQc7Binb9YeJoS48Q14m3SlmFQ
         KmwA==
X-Gm-Message-State: AOAM532z8FRMg4Q/djVJw3tV1p+Gb6AgtvpHRZnYjtx75QeFQiLmAWkP
        SUFlCBvQ/onhiuS4qrgdej0=
X-Google-Smtp-Source: ABdhPJwt6ihsN7XDpyeGiPOgB9j4tA/bQ0duLiq+QR/MPPcLzrzDak8Uaa94p5fptLAjNa9s1iqq/Q==
X-Received: by 2002:adf:fb05:: with SMTP id c5mr12594813wrr.69.1611776452917;
        Wed, 27 Jan 2021 11:40:52 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:acff:e553:5e:a443? (p200300ea8f1fad00acffe553005ea443.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:acff:e553:5e:a443])
        by smtp.googlemail.com with ESMTPSA id b2sm3790500wmd.41.2021.01.27.11.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 11:40:51 -0800 (PST)
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xplo.bn@gmail.com
References: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
 <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: work around RTL8125 UDP hw bug
Message-ID: <3afea922-776b-baf3-634c-9a1e84e8c4c2@gmail.com>
Date:   Wed, 27 Jan 2021 20:40:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-Jw6MqY+hnzFH75E4+3z5jo8dnO5G+KXpTd_vetZ6Gxwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.01.2021 19:07, Willem de Bruijn wrote:
> On Tue, Jan 26, 2021 at 2:40 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> It was reported that on RTL8125 network breaks under heavy UDP load,
>> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
>> and provided me with a test version of the r8125 driver including a
>> workaround. Tests confirmed that the workaround fixes the issue.
>> I modified the original version of the workaround to meet mainline
>> code style.
>>
>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>>
>> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
>> Tested-by: xplo <xplo.bn@gmail.com>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
>>  1 file changed, 58 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index fb67d8f79..90052033b 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -28,6 +28,7 @@
>>  #include <linux/bitfield.h>
>>  #include <linux/prefetch.h>
>>  #include <linux/ipv6.h>
>> +#include <linux/ptp_classify.h>
>>  #include <asm/unaligned.h>
>>  #include <net/ip6_checksum.h>
>>
>> @@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
>>         return -EIO;
>>  }
>>
>> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
>> +static bool rtl_skb_is_udp(struct sk_buff *skb)
>>  {
>> +       switch (vlan_get_protocol(skb)) {
>> +       case htons(ETH_P_IP):
>> +               return ip_hdr(skb)->protocol == IPPROTO_UDP;
>> +       case htons(ETH_P_IPV6):
>> +               return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
> 
> This trusts that an skb with given skb->protocol is well behaved. With
> packet sockets/tun/virtio, that may be false.
> 
>> +       default:
>> +               return false;
>> +       }
>> +}
>> +
>> +#define RTL_MIN_PATCH_LEN      47
>> +#define PTP_GEN_PORT           320
> 
> Why the two PTP ports? The report is not PTP specific. Also, what does
> patch mean in this context?
> 
>> +
>> +/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
>> +static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
>> +                                           struct sk_buff *skb)
>> +{
>> +       unsigned int padto = 0, len = skb->len;
>> +
>> +       if (rtl_is_8125(tp) && len < 175 && rtl_skb_is_udp(skb) &&
>> +           skb_transport_header_was_set(skb)) {
> 
> What is 175 here?
> 
>> +               unsigned int trans_data_len = skb_tail_pointer(skb) -
>> +                                             skb_transport_header(skb);
>> +
>> +               if (trans_data_len > 3 && trans_data_len < RTL_MIN_PATCH_LEN) {
> 
> And 3 here, instead of sizeof(struct udphdr)
> 
>> +                       u16 dest = ntohs(udp_hdr(skb)->dest);
>> +
>> +                       if (dest == PTP_EV_PORT || dest == PTP_GEN_PORT)
>> +                               padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
>> +               }
>> +
>> +               if (trans_data_len < UDP_HLEN)
>> +                       padto = max(padto, len + UDP_HLEN - trans_data_len);
>> +       }
>> +
>> +       return padto;
>> +}
>> +
>> +static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
>> +                                          struct sk_buff *skb)
>> +{
>> +       unsigned int padto;
>> +
>> +       padto = rtl8125_quirk_udp_padto(tp, skb);
>> +
>>         switch (tp->mac_version) {
>>         case RTL_GIGA_MAC_VER_34:
>>         case RTL_GIGA_MAC_VER_60:
>>         case RTL_GIGA_MAC_VER_61:
>>         case RTL_GIGA_MAC_VER_63:
>> -               return true;
>> +               padto = max_t(unsigned int, padto, ETH_ZLEN);
>>         default:
>> -               return false;
>> +               break;
>>         }
>> +
>> +       return padto;
>>  }
>>
>>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
>> @@ -4089,9 +4137,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>>
>>                 opts[1] |= transport_offset << TCPHO_SHIFT;
>>         } else {
>> -               if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
>> -                       /* eth_skb_pad would free the skb on error */
>> -                       return !__skb_put_padto(skb, ETH_ZLEN, false);
>> +               unsigned int padto = rtl_quirk_packet_padto(tp, skb);
>> +
>> +               /* skb_padto would free the skb on error */
>> +               return !__skb_put_padto(skb, padto, false);
>>         }
>>
>>         return true;
>> @@ -4268,6 +4317,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>                 if (skb->len < ETH_ZLEN)
>>                         features &= ~NETIF_F_CSUM_MASK;
>>
>> +               if (rtl_quirk_packet_padto(tp, skb))
>> +                       features &= ~NETIF_F_CSUM_MASK;
>> +
>>                 if (transport_offset > TCPHO_MAX &&
>>                     rtl_chip_supports_csum_v2(tp))
>>                         features &= ~NETIF_F_CSUM_MASK;
>> --
>> 2.30.0
>>

The workaround was provided by Realtek, I just modified it to match
mainline code style. For your reference I add the original version below.
I don't know where the magic numbers come from, Realtek releases
neither data sheets nor errata information.


#define MIN_PATCH_LEN (47)
static u32
rtl8125_get_patch_pad_len(struct sk_buff *skb)
{
        u32 pad_len = 0;
        int trans_data_len;
        u32 hdr_len;
        u32 pkt_len = skb->len;
        u8 ip_protocol;
        bool has_trans = skb_transport_header_was_set(skb);

        if (!(has_trans && (pkt_len < 175))) //128 + MIN_PATCH_LEN
                goto no_padding;

        ip_protocol = rtl8125_get_l4_protocol(skb);
        if (!(ip_protocol == IPPROTO_TCP || ip_protocol == IPPROTO_UDP))
                goto no_padding;

        trans_data_len = pkt_len -
                         (skb->transport_header -
                          skb_headroom(skb));
        if (ip_protocol == IPPROTO_UDP) {
                if (trans_data_len > 3 && trans_data_len < MIN_PATCH_LEN) {
                        u16 dest_port = 0;

                        skb_copy_bits(skb, skb->transport_header - skb_headroom(skb) + 2, &dest_port, 2);
                        dest_port = ntohs(dest_port);

                        if (dest_port == 0x13f ||
                            dest_port == 0x140) {
                                pad_len = MIN_PATCH_LEN - trans_data_len;
                                goto out;
                        }
                }
        }

        hdr_len = 0;
        if (ip_protocol == IPPROTO_TCP)
                hdr_len = 20;
        else if (ip_protocol == IPPROTO_UDP)
                hdr_len = 8;
        if (trans_data_len < hdr_len)
                pad_len = hdr_len - trans_data_len;

out:
        if ((pkt_len + pad_len) < ETH_ZLEN)
                pad_len = ETH_ZLEN - pkt_len;

        return pad_len;

no_padding:

        return 0;
}




