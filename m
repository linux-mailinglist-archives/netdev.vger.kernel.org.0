Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B174D30B5A1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbhBBDF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:05:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58501 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhBBDFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:05:22 -0500
Received: from mail-lf1-f70.google.com ([209.85.167.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1l6lzb-0007Ae-4p
        for netdev@vger.kernel.org; Tue, 02 Feb 2021 03:04:39 +0000
Received: by mail-lf1-f70.google.com with SMTP id 2so1953112lfe.15
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 19:04:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YgW55MgxWBiZGt05gocnc5NtGJCSSQJah5poStOqLN8=;
        b=sGPz5cWv5dwHQBxtNCJwaTiAE3u0egQ69bwyR70KWzXDy05I8MZJhH2tcItXReaj9y
         kePeCmM8zWCvhTK9peAwtXOlEV7eJ4svGpk5IduEcaoo4za1neiLTNt5u4yWsgOnfXjZ
         jobJoC/DIvJKBMkXGtChFuGxEkRHYbbenEO8E9BrVlDDO+pL2kGl1N3MvUMpIoGNRjQm
         IPV1dzhNR4eMnb13pfb/v4GASWBsztoCgtmLFp8QNa0Jk2eli0xwxqh0ulfrz9ATreKO
         yiQg7JIlmKDRdtAIKloIb0jufy3eprFzsGmQxsrPpSyTU6y4Yt5c7slBKKkKV6AVUa0i
         PiPw==
X-Gm-Message-State: AOAM53167+XIj3T6AK9DkYtpXdYMcxvo4y8OR8k6Q04zv2NJ3ygGbno6
        vwiflz6R/Il6Q31XPgYIUI9VKjZGF0KMfgX9ZfS/yFXvdLqM0awj2FtnV5OCWMWCvCRpsVvwqoX
        0fhCQLIKBd6MPV0mtdSbwh3eEZjdfofS5PZkafjm0ZGPzthJ8hg==
X-Received: by 2002:a19:7001:: with SMTP id h1mr9862129lfc.513.1612235078590;
        Mon, 01 Feb 2021 19:04:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvwGpjFEieUxDOs22xx93Z+Y1uD/7ps2RcSqJbrcHjYUlKQt6jFcciAnMszy0+liorMTAkBUn/mZZk3/GBMWM=
X-Received: by 2002:a19:7001:: with SMTP id h1mr9862116lfc.513.1612235078251;
 Mon, 01 Feb 2021 19:04:38 -0800 (PST)
MIME-Version: 1.0
References: <20210201164735.1268796-1-kai.heng.feng@canonical.com> <e3a01903-1b3b-4f7c-4458-179fbbd27615@gmail.com>
In-Reply-To: <e3a01903-1b3b-4f7c-4458-179fbbd27615@gmail.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Tue, 2 Feb 2021 11:04:26 +0800
Message-ID: <CAAd53p4MwieS-a_f_rTUvjX3ejjWy=sTCK+A7+bw22vrHNuwOw@mail.gmail.com>
Subject: Re: [PATCH] r8169: Add support for another RTL8168FP
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "maintainer:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <nic_swsd@realtek.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:8169 10/100/1000 GIGABIT ETHERNET DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 2:54 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 01.02.2021 17:47, Kai-Heng Feng wrote:
> > According to the vendor driver, the new chip with XID 0x54b is
> > essentially the same as the one with XID 0x54a, but it doesn't need the
> > firmware.
> >
> > So add support accordingly.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> >  drivers/net/ethernet/realtek/r8169.h      |  1 +
> >  drivers/net/ethernet/realtek/r8169_main.c | 21 +++++++++++++--------
> >  2 files changed, 14 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
> > index 7be86ef5a584..2728df46ec41 100644
> > --- a/drivers/net/ethernet/realtek/r8169.h
> > +++ b/drivers/net/ethernet/realtek/r8169.h
> > @@ -63,6 +63,7 @@ enum mac_version {
> >       RTL_GIGA_MAC_VER_50,
> >       RTL_GIGA_MAC_VER_51,
> >       RTL_GIGA_MAC_VER_52,
> > +     RTL_GIGA_MAC_VER_53,
> >       RTL_GIGA_MAC_VER_60,
> >       RTL_GIGA_MAC_VER_61,
> >       RTL_GIGA_MAC_VER_63,
> > diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> > index a569abe7f5ef..ee1f72a9d453 100644
> > --- a/drivers/net/ethernet/realtek/r8169_main.c
> > +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > @@ -145,6 +145,7 @@ static const struct {
> >       [RTL_GIGA_MAC_VER_50] = {"RTL8168ep/8111ep"                     },
> >       [RTL_GIGA_MAC_VER_51] = {"RTL8168ep/8111ep"                     },
> >       [RTL_GIGA_MAC_VER_52] = {"RTL8168fp/RTL8117",  FIRMWARE_8168FP_3},
> > +     [RTL_GIGA_MAC_VER_53] = {"RTL8168fp/RTL8117",                   },
> >       [RTL_GIGA_MAC_VER_60] = {"RTL8125A"                             },
> >       [RTL_GIGA_MAC_VER_61] = {"RTL8125A",            FIRMWARE_8125A_3},
> >       /* reserve 62 for CFG_METHOD_4 in the vendor driver */
> > @@ -682,7 +683,7 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
> >  {
> >       return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
> >              tp->mac_version != RTL_GIGA_MAC_VER_39 &&
> > -            tp->mac_version <= RTL_GIGA_MAC_VER_52;
> > +            tp->mac_version <= RTL_GIGA_MAC_VER_53;
> >  }
> >
> >  static bool rtl_supports_eee(struct rtl8169_private *tp)
> > @@ -1012,7 +1013,9 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
> >  static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
> >  {
> >       /* based on RTL8168FP_OOBMAC_BASE in vendor driver */
> > -     if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
> > +     if (type == ERIAR_OOB &&
> > +         (tp->mac_version == RTL_GIGA_MAC_VER_52 ||
> > +          tp->mac_version == RTL_GIGA_MAC_VER_53))
> >               *cmd |= 0x7f0 << 18;
> >  }
> >
> > @@ -1164,7 +1167,7 @@ static void rtl8168_driver_start(struct rtl8169_private *tp)
> >       case RTL_GIGA_MAC_VER_31:
> >               rtl8168dp_driver_start(tp);
> >               break;
> > -     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> > +     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
> >               rtl8168ep_driver_start(tp);
> >               break;
> >       default:
> > @@ -1195,7 +1198,7 @@ static void rtl8168_driver_stop(struct rtl8169_private *tp)
> >       case RTL_GIGA_MAC_VER_31:
> >               rtl8168dp_driver_stop(tp);
> >               break;
> > -     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> > +     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
> >               rtl8168ep_driver_stop(tp);
> >               break;
> >       default:
> > @@ -1223,7 +1226,7 @@ static bool r8168_check_dash(struct rtl8169_private *tp)
> >       case RTL_GIGA_MAC_VER_28:
> >       case RTL_GIGA_MAC_VER_31:
> >               return r8168dp_check_dash(tp);
> > -     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> > +     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
> >               return r8168ep_check_dash(tp);
> >       default:
> >               return false;
> > @@ -1930,6 +1933,7 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
> >               { 0x7c8, 0x608, RTL_GIGA_MAC_VER_61 },
> >
> >               /* RTL8117 */
> > +             { 0x7cf, 0x54b, RTL_GIGA_MAC_VER_53 },
> >               { 0x7cf, 0x54a, RTL_GIGA_MAC_VER_52 },
> >
> >               /* 8168EP family. */
> > @@ -2274,7 +2278,7 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
> >       case RTL_GIGA_MAC_VER_38:
> >               RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST);
> >               break;
> > -     case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
> > +     case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
> >               RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
> >               break;
> >       case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
> > @@ -2449,7 +2453,7 @@ DECLARE_RTL_COND(rtl_rxtx_empty_cond_2)
> >  static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
> >  {
> >       switch (tp->mac_version) {
> > -     case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
> > +     case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_53:
> >               rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42);
> >               rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
> >               break;
> > @@ -3708,6 +3712,7 @@ static void rtl_hw_config(struct rtl8169_private *tp)
> >               [RTL_GIGA_MAC_VER_50] = rtl_hw_start_8168ep_2,
> >               [RTL_GIGA_MAC_VER_51] = rtl_hw_start_8168ep_3,
> >               [RTL_GIGA_MAC_VER_52] = rtl_hw_start_8117,
> > +             [RTL_GIGA_MAC_VER_53] = rtl_hw_start_8117,
> >               [RTL_GIGA_MAC_VER_60] = rtl_hw_start_8125a_1,
> >               [RTL_GIGA_MAC_VER_61] = rtl_hw_start_8125a_2,
> >               [RTL_GIGA_MAC_VER_63] = rtl_hw_start_8125b,
> > @@ -5101,7 +5106,7 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
> >  static void rtl_hw_initialize(struct rtl8169_private *tp)
> >  {
> >       switch (tp->mac_version) {
> > -     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_52:
> > +     case RTL_GIGA_MAC_VER_49 ... RTL_GIGA_MAC_VER_53:
> >               rtl8168ep_stop_cmac(tp);
> >               fallthrough;
> >       case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_48:
> >
>
> I think you have to add the following in r8169_phy_config.c
> [RTL_GIGA_MAC_VER_53] = rtl8117_hw_phy_config,
> Or doesn't VER_53 need this?

Hmm, it works great with or without rtl8117_hw_phy_config.
But yes, it should need this, let me send a V2 on top of net-next.

Kai-Heng
