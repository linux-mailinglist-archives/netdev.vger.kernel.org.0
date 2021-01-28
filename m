Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71746307E41
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhA1SkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 13:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232347AbhA1SiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 13:38:02 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCA1C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 10:37:19 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id hs11so9303510ejc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 10:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oc8eFQ89ZKBbdQspIBiCJXfCdATnJTulpEZ63lvc/S0=;
        b=cIqQqATzznu5HuPKoKJ52IZA1ujq67kdxisMm6ZOFYxTGGb2E9YcvpfV+QwHPFC5tr
         7tXWm1ZWuMmalCMrmznro/Wq7ojn8BtBb5cBjW88zNzMBXdqVJBjHIDVsbTTWP/LQbT4
         3mX/kBBt6H0LImPcJdmawcTaZULkx27by3i1usuM6GSMDizEUbhnRAsOuLU15O4HZ2A1
         35HtsYNFJgCW0JBF6H8OyTqdlnN9iWPOKU5JP7r8xjt8aYiSRcBUO6WxvsPfGF3ewvbM
         qIvGM64peH1Sm6YPa9fx0KnYsH+Iv7gNr1EecQkZfXBdNANMktFoRf+mjWawWKUlXgW1
         ZV+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oc8eFQ89ZKBbdQspIBiCJXfCdATnJTulpEZ63lvc/S0=;
        b=KLI+XQ9uXhLEEwvMKeeXu8oPoaFUmCehVrtJUVGk94Yw7nfVBYc62uelIl9zxps+lK
         Vtx8dgYA5k/ovIyct9nFrg11bvTwWtPFvTUjmhwdgoJ3+B9KjlViYm7ZWZhD5dPqGfG0
         GTiK51V5w/H6uxNo+bilCBUTjVahb0ejKy773ZZk7W6DPCB90pzP32DlVvqHfByoCJZQ
         gzlmSIQRNp66NLa1XaT9+Lkh+jngDorJQl81yBKJs3hIkQHDvcNN3m0shWu52hj8JzSq
         mBLhvVuNnPytgoRgMic8vJG4mNkfDvsgUc8OJIheAl1PV0DtWNy9xsLHwOHzbDYPexTl
         3mVQ==
X-Gm-Message-State: AOAM531LM6VD8xBMhA7MMH0gWuhJtWbRRyk/nJrOW8QqRvyzlfB+vWOI
        lTrGNB5isYzTgNM60reBANDKL50BV6wfIMYgqUk=
X-Google-Smtp-Source: ABdhPJzeKrhMJ6s4xHVZTosxg6KLLqaFG05H+8iavA94c511fC0es39A75re4MZW+csW2CtjQhWS2f9RpRvYEcZcj/A=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr750845ejk.538.1611859038644;
 Thu, 28 Jan 2021 10:37:18 -0800 (PST)
MIME-Version: 1.0
References: <c8dcb440-a2f5-0ff5-c4a7-854dc655151b@gmail.com>
In-Reply-To: <c8dcb440-a2f5-0ff5-c4a7-854dc655151b@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 28 Jan 2021 13:36:41 -0500
Message-ID: <CAF=yD-+n6RGCTnWXf4Tjq8pvKTdWmr8xdHHbYX5JPSmTHOi1ZQ@mail.gmail.com>
Subject: Re: [PATCH v3 net] r8169: work around RTL8125 UDP hw bug
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 2:44 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> It was reported that on RTL8125 network breaks under heavy UDP load,
> e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
> and provided me with a test version of the r8125 driver including a
> workaround. Tests confirmed that the workaround fixes the issue.
> I modified the original version of the workaround to meet mainline
> code style.
>
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=209839
>
> v2:
> - rebased to net
> v3:
> - make rtl_skb_is_udp() more robust and use skb_header_pointer()
>   to access the ip(v6) header
>
> Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
> Tested-by: xplo <xplo.bn@gmail.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 70 +++++++++++++++++++++--
>  1 file changed, 64 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a569abe7f..457fa1404 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -28,6 +28,7 @@
>  #include <linux/bitfield.h>
>  #include <linux/prefetch.h>
>  #include <linux/ipv6.h>
> +#include <linux/ptp_classify.h>

this is only for UDP_HLEN? perhaps use sizeof(struct udphdr) instead
to remove the dependency.

>  #include <net/ip6_checksum.h>
>
>  #include "r8169.h"
> @@ -4046,17 +4047,70 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
>         return -EIO;
>  }
>
> -static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
> +static bool rtl_skb_is_udp(struct sk_buff *skb)
>  {
> +       int no = skb_network_offset(skb);
> +       struct ipv6hdr *i6h, _i6h;
> +       struct iphdr *ih, _ih;
> +
> +       switch (vlan_get_protocol(skb)) {
> +       case htons(ETH_P_IP):
> +               ih = skb_header_pointer(skb, no, sizeof(_ih), &_ih);
> +               return ih && ih->protocol == IPPROTO_UDP;
> +       case htons(ETH_P_IPV6):
> +               i6h = skb_header_pointer(skb, no, sizeof(_i6h), &_i6h);
> +               return i6h && i6h->nexthdr == IPPROTO_UDP;
> +       default:
> +               return false;
> +       }
> +}
> +
> +#define RTL_MIN_PATCH_LEN      47
> +#define PTP_GEN_PORT           320
> +
> +/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
> +static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
> +                                           struct sk_buff *skb)
> +{
> +       unsigned int padto = 0, len = skb->len;
> +
> +       if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
> +           rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
> +               unsigned int trans_data_len = skb_tail_pointer(skb) -
> +                                             skb_transport_header(skb);
> +
> +               if (trans_data_len > 3 && trans_data_len < RTL_MIN_PATCH_LEN) {

   trans_data_len > 3

here probably means

   trans_data_len >= offsetof(struct udphdr, len)

to safely access dest. Then that is a bit more self documenting

> +                       u16 dest = ntohs(udp_hdr(skb)->dest);
> +
> +                       if (dest == PTP_EV_PORT || dest == PTP_GEN_PORT)
> +                               padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
> +               }
> +
> +               if (trans_data_len < UDP_HLEN)

nit: else if ?

> +                       padto = max(padto, len + UDP_HLEN - trans_data_len);
> +       }
> +
> +       return padto;
> +}
> +
> +static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
> +                                          struct sk_buff *skb)
> +{
> +       unsigned int padto;
> +
> +       padto = rtl8125_quirk_udp_padto(tp, skb);
> +
>         switch (tp->mac_version) {
>         case RTL_GIGA_MAC_VER_34:
>         case RTL_GIGA_MAC_VER_60:
>         case RTL_GIGA_MAC_VER_61:
>         case RTL_GIGA_MAC_VER_63:
> -               return true;
> +               padto = max_t(unsigned int, padto, ETH_ZLEN);
>         default:
> -               return false;
> +               break;
>         }
> +
> +       return padto;
>  }
>
>  static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
> @@ -4128,9 +4182,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
>
>                 opts[1] |= transport_offset << TCPHO_SHIFT;
>         } else {
> -               if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
> -                       /* eth_skb_pad would free the skb on error */
> -                       return !__skb_put_padto(skb, ETH_ZLEN, false);
> +               unsigned int padto = rtl_quirk_packet_padto(tp, skb);
> +
> +               /* skb_padto would free the skb on error */
> +               return !__skb_put_padto(skb, padto, false);

should this path still pad to ETH_ZLEN as a minimum when the other
cases do not hit?

>         }
>
>         return true;
> @@ -4307,6 +4362,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>                 if (skb->len < ETH_ZLEN)
>                         features &= ~NETIF_F_CSUM_MASK;
>
> +               if (rtl_quirk_packet_padto(tp, skb))
> +                       features &= ~NETIF_F_CSUM_MASK;
> +
>                 if (transport_offset > TCPHO_MAX &&
>                     rtl_chip_supports_csum_v2(tp))
>                         features &= ~NETIF_F_CSUM_MASK;
> --
> 2.30.0
>
